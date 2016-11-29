From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v3 15/20] x86: Check for memory encryption on the APs
Date: Tue, 29 Nov 2016 12:00:56 -0600
Message-ID: <b3b5cc5d-dc1d-187d-d738-ba55798327d2@amd.com>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
 <20161110003740.3280.57300.stgit@tlendack-t1.amdoffice.net>
 <20161122192526.vg63jjhwsbjwex7i@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161122192526.vg63jjhwsbjwex7i-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Alexander
List-Id: linux-efi@vger.kernel.org

On 11/22/2016 1:25 PM, Borislav Petkov wrote:
> On Wed, Nov 09, 2016 at 06:37:40PM -0600, Tom Lendacky wrote:
>> Add support to check if memory encryption is active in the kernel and that
>> it has been enabled on the AP. If memory encryption is active in the kernel
>> but has not been enabled on the AP then do not allow the AP to continue
>> start up.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
>>  arch/x86/include/asm/realmode.h      |   12 ++++++++++++
>>  arch/x86/realmode/init.c             |    4 ++++
>>  arch/x86/realmode/rm/trampoline_64.S |   19 +++++++++++++++++++
>>  3 files changed, 35 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
>> index 230e190..850dbe0 100644
>> --- a/arch/x86/include/asm/realmode.h
>> +++ b/arch/x86/include/asm/realmode.h
>> @@ -1,6 +1,15 @@
>>  #ifndef _ARCH_X86_REALMODE_H
>>  #define _ARCH_X86_REALMODE_H
>>  
>> +/*
>> + * Flag bit definitions for use with the flags field of the trampoline header
>> + * when configured for X86_64
> 
> Let's use kernel nomenclature: "... of the trampoline header in the
> CONFIG_X86_64 variant."

Ok.

> 
>> + */
>> +#define TH_FLAGS_SME_ENABLE_BIT		0
>> +#define TH_FLAGS_SME_ENABLE		BIT_ULL(TH_FLAGS_SME_ENABLE_BIT)
> 
> BIT() is the proper one for u32 flags variable.

Yup, not sure why I used BIT_ULL...  will fix.

> 
>> +
>> +#ifndef __ASSEMBLY__
>> +
>>  #include <linux/types.h>
>>  #include <asm/io.h>
>>  
>> @@ -38,6 +47,7 @@ struct trampoline_header {
>>  	u64 start;
>>  	u64 efer;
>>  	u32 cr4;
>> +	u32 flags;
>>  #endif
>>  };
>>  
>> @@ -69,4 +79,6 @@ static inline size_t real_mode_size_needed(void)
>>  void set_real_mode_mem(phys_addr_t mem, size_t size);
>>  void reserve_real_mode(void);
>>  
>> +#endif /* __ASSEMBLY__ */
>> +
>>  #endif /* _ARCH_X86_REALMODE_H */
>> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
>> index 44ed32a..a8e7ebe 100644
>> --- a/arch/x86/realmode/init.c
>> +++ b/arch/x86/realmode/init.c
>> @@ -101,6 +101,10 @@ static void __init setup_real_mode(void)
>>  	trampoline_cr4_features = &trampoline_header->cr4;
>>  	*trampoline_cr4_features = mmu_cr4_features;
>>  
>> +	trampoline_header->flags = 0;
>> +	if (sme_me_mask)
>> +		trampoline_header->flags |= TH_FLAGS_SME_ENABLE;
>> +
>>  	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
>>  	trampoline_pgd[0] = trampoline_pgd_entry.pgd;
>>  	trampoline_pgd[511] = init_level4_pgt[511].pgd;
>> diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
>> index dac7b20..94e29f4 100644
>> --- a/arch/x86/realmode/rm/trampoline_64.S
>> +++ b/arch/x86/realmode/rm/trampoline_64.S
>> @@ -30,6 +30,7 @@
>>  #include <asm/msr.h>
>>  #include <asm/segment.h>
>>  #include <asm/processor-flags.h>
>> +#include <asm/realmode.h>
>>  #include "realmode.h"
>>  
>>  	.text
>> @@ -92,6 +93,23 @@ ENTRY(startup_32)
>>  	movl	%edx, %fs
>>  	movl	%edx, %gs
>>  
>> +	/* Check for memory encryption support */
>> +	bt	$TH_FLAGS_SME_ENABLE_BIT, pa_tr_flags
>> +	jnc	.Ldone
>> +	movl	$MSR_K8_SYSCFG, %ecx
>> +	rdmsr
>> +	bt	$MSR_K8_SYSCFG_MEM_ENCRYPT_BIT, %eax
>> +	jc	.Ldone
>> +
>> +	/*
>> +	 * Memory encryption is enabled but the MSR has not been set on this
>> +	 * CPU so we can't continue
> 
> Can this ever happen?
> 
> I mean, we set TH_FLAGS_SME_ENABLE when sme_me_mask is set and this
> would have happened only if the BSP has MSR_K8_SYSCFG[23] set.
> 
> How is it possible that that bit won't be set on some of the APs but set
> on the BSP?
> 
> I'd assume the BIOS is doing a consistent setting everywhere...
> 

It can happen if BIOS doesn't do something right.  So this is just a
safety thing.  I thought I had changed this to set the bit if it
wasn't set, which is safe to do.  I'm not sure what happened to that
change (based on your previous comment actually!)...  I'll add that
back so that the AP is useful.

Thanks,
Tom
