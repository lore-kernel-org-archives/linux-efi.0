From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC Part1 PATCH v3 14/17] x86/boot: Add early boot support when
 running with SEV active
Date: Thu, 24 Aug 2017 13:54:57 -0500
Message-ID: <42cf82fc-03be-c4c7-eaab-b2306a049d20@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-15-brijesh.singh@amd.com>
 <20170823153058.yli5qogrmjl74wkl@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170823153058.yli5qogrmjl74wkl@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Benjamin
List-Id: linux-efi@vger.kernel.org

On 8/23/2017 10:30 AM, Borislav Petkov wrote:
> On Mon, Jul 24, 2017 at 02:07:54PM -0500, Brijesh Singh wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Early in the boot process, add checks to determine if the kernel is
>> running with Secure Encrypted Virtualization (SEV) active.
>>
>> Checking for SEV requires checking that the kernel is running under a
>> hypervisor (CPUID 0x00000001, bit 31), that the SEV feature is available
>> (CPUID 0x8000001f, bit 1) and then check a non-interceptable SEV MSR
>> (0xc0010131, bit 0).
>>
>> This check is required so that during early compressed kernel booting the
>> pagetables (both the boot pagetables and KASLR pagetables (if enabled) are
>> updated to include the encryption mask so that when the kernel is
>> decompressed into encrypted memory.
> 
> 				    , it can boot properly.
> 
> :)
> 

Yup, kinda didn't complete that sentence.

>> After the kernel is decompressed and continues booting the same logic is
>> used to check if SEV is active and set a flag indicating so.  This allows
>> us to distinguish between SME and SEV, each of which have unique
>> differences in how certain things are handled: e.g. DMA (always bounce
>> buffered with SEV) or EFI tables (always access decrypted with SME).
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   arch/x86/boot/compressed/Makefile      |   2 +
>>   arch/x86/boot/compressed/head_64.S     |  16 +++++
>>   arch/x86/boot/compressed/mem_encrypt.S | 103 +++++++++++++++++++++++++++++++++
>>   arch/x86/boot/compressed/misc.h        |   2 +
>>   arch/x86/boot/compressed/pagetable.c   |   8 ++-
>>   arch/x86/include/asm/mem_encrypt.h     |   3 +
>>   arch/x86/include/asm/msr-index.h       |   3 +
>>   arch/x86/include/uapi/asm/kvm_para.h   |   1 -
>>   arch/x86/mm/mem_encrypt.c              |  42 +++++++++++---
>>   9 files changed, 169 insertions(+), 11 deletions(-)
>>   create mode 100644 arch/x86/boot/compressed/mem_encrypt.S
>>
>> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
>> index 2c860ad..d2fe901 100644
>> --- a/arch/x86/boot/compressed/Makefile
>> +++ b/arch/x86/boot/compressed/Makefile
>> @@ -72,6 +72,8 @@ vmlinux-objs-y := $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
>>   	$(obj)/string.o $(obj)/cmdline.o $(obj)/error.o \
>>   	$(obj)/piggy.o $(obj)/cpuflags.o
>>   
>> +vmlinux-objs-$(CONFIG_X86_64) += $(obj)/mem_encrypt.o
> 
> There's a
> 
> ifdef CONFIG_X86_64
> 
> a couple of lines below. Just put it there.

Will do.

> 
> ...
> 
>> +++ b/arch/x86/boot/compressed/mem_encrypt.S
>> @@ -0,0 +1,103 @@
>> +/*
>> + * AMD Memory Encryption Support
>> + *
>> + * Copyright (C) 2017 Advanced Micro Devices, Inc.
>> + *
>> + * Author: Tom Lendacky <thomas.lendacky@amd.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/linkage.h>
>> +
>> +#include <asm/processor-flags.h>
>> +#include <asm/msr.h>
>> +#include <asm/asm-offsets.h>
>> +
>> +	.text
>> +	.code32
>> +ENTRY(get_sev_encryption_bit)
>> +	xor	%eax, %eax
>> +
>> +#ifdef CONFIG_AMD_MEM_ENCRYPT
>> +	push	%ebx
>> +	push	%ecx
>> +	push	%edx
>> +
>> +	/* Check if running under a hypervisor */
>> +	movl	$1, %eax
>> +	cpuid
>> +	bt	$31, %ecx		/* Check the hypervisor bit */
>> +	jnc	.Lno_sev
>> +
>> +	movl	$0x80000000, %eax	/* CPUID to check the highest leaf */
>> +	cpuid
>> +	cmpl	$0x8000001f, %eax	/* See if 0x8000001f is available */
>> +	jb	.Lno_sev
>> +
>> +	/*
>> +	 * Check for the SEV feature:
>> +	 *   CPUID Fn8000_001F[EAX] - Bit 1
>> +	 *   CPUID Fn8000_001F[EBX] - Bits 5:0
>> +	 *     Pagetable bit position used to indicate encryption
>> +	 */
>> +	movl	$0x8000001f, %eax
>> +	cpuid
>> +	bt	$1, %eax		/* Check if SEV is available */
>> +	jnc	.Lno_sev
>> +
>> +	movl	$MSR_F17H_SEV, %ecx	/* Read the SEV MSR */
>> +	rdmsr
>> +	bt	$MSR_F17H_SEV_ENABLED_BIT, %eax	/* Check if SEV is active */
>> +	jnc	.Lno_sev
>> +
>> +	/*
>> +	 * Get memory encryption information:
>> +	 */
> 
> The side-comment is enough. This one above can go.

Done.

> 
>> +	movl	%ebx, %eax
>> +	andl	$0x3f, %eax		/* Return the encryption bit location */
>> +	jmp	.Lsev_exit
>> +
>> +.Lno_sev:
>> +	xor	%eax, %eax
>> +
>> +.Lsev_exit:
>> +	pop	%edx
>> +	pop	%ecx
>> +	pop	%ebx
>> +
>> +#endif	/* CONFIG_AMD_MEM_ENCRYPT */
>> +
>> +	ret
>> +ENDPROC(get_sev_encryption_bit)
>> +
>> +	.code64
>> +ENTRY(get_sev_encryption_mask)
>> +	xor	%rax, %rax
>> +
>> +#ifdef CONFIG_AMD_MEM_ENCRYPT
>> +	push	%rbp
>> +	push	%rdx
>> +
>> +	movq	%rsp, %rbp		/* Save current stack pointer */
>> +
>> +	call	get_sev_encryption_bit	/* Get the encryption bit position */
> 
> So we get to call get_sev_encryption_bit() here again and noodle through
> the CPUID discovery and MSR access. We should instead cache that info
> and return the encryption bit directly on a second call. (And initialize
> it to -1 to denote that get_sev_encryption_bit() hasn't run yet).

Ok, I'll look into that optimization.

> 
> ...
> 
>> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
>> index 9274ec7..9cb6472 100644
>> --- a/arch/x86/include/asm/mem_encrypt.h
>> +++ b/arch/x86/include/asm/mem_encrypt.h
>> @@ -19,6 +19,9 @@
>>   
>>   #include <asm/bootparam.h>
>>   
>> +#define AMD_SME_FEATURE_BIT	BIT(0)
>> +#define AMD_SEV_FEATURE_BIT	BIT(1)
> 
> s/_FEATURE//
> 
> AMD_SME_BIT and AMD_SEV_BIT is good enough :)
> 
> And frankly, if you're going to use them only below in sme_enable() - I
> need to check more thoroughly the remaining patches - but if you only
> are going to use them there, just define them inside the function so
> that they're close.

Sounds good. I believe that is the only place they are/will be used
so I'll make that change.

> 
>> +
>>   #ifdef CONFIG_AMD_MEM_ENCRYPT
>>   
>>   extern unsigned long sme_me_mask;
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index e399d68..530020f 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -326,6 +326,9 @@
>>   
>>   /* Fam 17h MSRs */
>>   #define MSR_F17H_IRPERF			0xc00000e9
>> +#define MSR_F17H_SEV			0xc0010131
> 
> If that MSR is going to be used later on - and I don't see why not - you
> probably should make it an arch one: MSR_AMD64_SEV. Even if it isn't yet
> officially. :-)
> 

Will do.

>> +#define MSR_F17H_SEV_ENABLED_BIT	0
>> +#define MSR_F17H_SEV_ENABLED		BIT_ULL(MSR_F17H_SEV_ENABLED_BIT)
>>   
>>   /* Fam 16h MSRs */
>>   #define MSR_F16H_L2I_PERF_CTL		0xc0010230
>> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
>> index a965e5b..c202ba3 100644
>> --- a/arch/x86/include/uapi/asm/kvm_para.h
>> +++ b/arch/x86/include/uapi/asm/kvm_para.h
>> @@ -109,5 +109,4 @@ struct kvm_vcpu_pv_apf_data {
>>   #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>>   #define KVM_PV_EOI_DISABLED 0x0
>>   
>> -
>>   #endif /* _UAPI_ASM_X86_KVM_PARA_H */
>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>> index 5e5d460..ed8780e 100644
>> --- a/arch/x86/mm/mem_encrypt.c
>> +++ b/arch/x86/mm/mem_encrypt.c
>> @@ -288,7 +288,9 @@ void __init mem_encrypt_init(void)
>>   	if (sev_active())
>>   		dma_ops = &sme_dma_ops;
>>   
>> -	pr_info("AMD Secure Memory Encryption (SME) active\n");
>> +	pr_info("AMD %s active\n",
>> +		sev_active() ? "Secure Encrypted Virtualization (SEV)"
>> +			     : "Secure Memory Encryption (SME)");
>>   }
>>   
>>   void swiotlb_set_mem_attributes(void *vaddr, unsigned long size)
>> @@ -616,12 +618,23 @@ void __init __nostackprotector sme_enable(struct boot_params *bp)
>>   {
>>   	const char *cmdline_ptr, *cmdline_arg, *cmdline_on, *cmdline_off;
>>   	unsigned int eax, ebx, ecx, edx;
>> +	unsigned long feature_mask;
>>   	bool active_by_default;
>>   	unsigned long me_mask;
>>   	char buffer[16];
>>   	u64 msr;
>>   
>> -	/* Check for the SME support leaf */
>> +	/*
>> +	 * Set the feature mask (SME or SEV) based on whether we are
>> +	 * running under a hypervisor.
>> +	 */
>> +	eax = 1;
>> +	ecx = 0;
>> +	native_cpuid(&eax, &ebx, &ecx, &edx);
>> +	feature_mask = (ecx & BIT(31)) ? AMD_SEV_FEATURE_BIT
>> +				       : AMD_SME_FEATURE_BIT;
> 
> Set that feature mask before using it...
> 
>> +
>> +	/* Check for the SME/SEV support leaf */
> 
> ... because if that check exits due to no SME leaf, you're uselessly
> doing all the above.

Ok, I'll move that down after the leaf check.

> 
>>   	eax = 0x80000000;
>>   	ecx = 0;
>>   	native_cpuid(&eax, &ebx, &ecx, &edx);
>> @@ -629,24 +642,39 @@ void __init __nostackprotector sme_enable(struct boot_params *bp)
>>   		return;
>>   
>>   	/*
>> -	 * Check for the SME feature:
>> +	 * Check for the SME/SEV feature:
>>   	 *   CPUID Fn8000_001F[EAX] - Bit 0
>>   	 *     Secure Memory Encryption support
>> +	 *   CPUID Fn8000_001F[EAX] - Bit 1
> 
> No need to repeat the CPUID leaf here - only Bit 1:
> 
>           *   CPUID Fn8000_001F[EAX]
> 	 * - Bit 0:  Secure Memory Encryption support
>           * - Bit 1:  Secure Encrypted Virtualization support
> 

Ok, I'll clean that up.

Thanks,
Tom

> 
>> +	 *     Secure Encrypted Virtualization support
>>   	 *   CPUID Fn8000_001F[EBX] - Bits 5:0
>>   	 *     Pagetable bit position used to indicate encryption
>>   	 */
>>   	eax = 0x8000001f;
>>   	ecx = 0;
>>   	native_cpuid(&eax, &ebx, &ecx, &edx);
>> -	if (!(eax & 1))
>> +	if (!(eax & feature_mask))
>>   		return;
>>   
>>   	me_mask = 1UL << (ebx & 0x3f);
>>   
>> -	/* Check if SME is enabled */
>> -	msr = __rdmsr(MSR_K8_SYSCFG);
>> -	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
>> +	/* Check if memory encryption is enabled */
>> +	if (feature_mask == AMD_SME_FEATURE_BIT) {
>> +		/* For SME, check the SYSCFG MSR */
>> +		msr = __rdmsr(MSR_K8_SYSCFG);
>> +		if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
>> +			return;
>> +	} else {
>> +		/* For SEV, check the SEV MSR */
>> +		msr = __rdmsr(MSR_F17H_SEV);
>> +		if (!(msr & MSR_F17H_SEV_ENABLED))
>> +			return;
>> +
>> +		/* SEV state cannot be controlled by a command line option */
>> +		sme_me_mask = me_mask;
>> +		sev_enabled = 1;
>>   		return;
>> +	}
> 
> Nice. Two birds with one stone is always better. :)
> 
> 
