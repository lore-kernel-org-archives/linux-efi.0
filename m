From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC Part1 PATCH v3 02/17] x86/CPU/AMD: Add the Secure Encrypted
 Virtualization CPU feature
Date: Tue, 25 Jul 2017 09:29:40 -0500
Message-ID: <7236d267-ebcb-8b45-b8d3-5955903e395f@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-3-brijesh.singh@amd.com>
 <20170725102657.GD21822@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170725102657.GD21822-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Benjamin
List-Id: linux-efi@vger.kernel.org

On 7/25/2017 5:26 AM, Borislav Petkov wrote:
> On Mon, Jul 24, 2017 at 02:07:42PM -0500, Brijesh Singh wrote:
>> From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>>
>> Update the CPU features to include identifying and reporting on the
>> Secure Encrypted Virtualization (SEV) feature.  SME is identified by
>> CPUID 0x8000001f, but requires BIOS support to enable it (set bit 23 of
>> MSR_K8_SYSCFG and set bit 0 of MSR_K7_HWCR).  Only show the SEV feature
>> as available if reported by CPUID and enabled by BIOS.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
>> ---
>>   arch/x86/include/asm/cpufeatures.h |  1 +
>>   arch/x86/include/asm/msr-index.h   |  2 ++
>>   arch/x86/kernel/cpu/amd.c          | 30 +++++++++++++++++++++++++-----
>>   arch/x86/kernel/cpu/scattered.c    |  1 +
>>   4 files changed, 29 insertions(+), 5 deletions(-)
> 
> ...
> 
>> @@ -637,6 +642,21 @@ static void early_init_amd(struct cpuinfo_x86 *c)
>>   			clear_cpu_cap(c, X86_FEATURE_SME);
>>   		}
>>   	}
>> +
>> +	if (cpu_has(c, X86_FEATURE_SEV)) {
>> +		if (IS_ENABLED(CONFIG_X86_32)) {
>> +			clear_cpu_cap(c, X86_FEATURE_SEV);
>> +		} else {
>> +			u64 syscfg, hwcr;
>> +
>> +			/* Check if SEV is enabled */
>> +			rdmsrl(MSR_K8_SYSCFG, syscfg);
>> +			rdmsrl(MSR_K7_HWCR, hwcr);
>> +			if (!(syscfg & MSR_K8_SYSCFG_MEM_ENCRYPT) ||
>> +			    !(hwcr & MSR_K7_HWCR_SMMLOCK))
>> +				clear_cpu_cap(c, X86_FEATURE_SEV);
>> +		}
>> +	}
> 
> Let's simplify this and read the MSRs only once. Diff ontop. Please
> check if I'm missing a case:

Yup, we can do something like that.  I believe the only change that
would be needed to your patch would be to move the IS_ENABLED() check
to after the physical address space reduction check.

Thanks,
Tom

> 
> ---
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index c413f04bdd41..79af07731ab1 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -546,6 +546,48 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
>   	}
>   }
>   
> +static void early_detect_mem_enc(struct cpuinfo_x86 *c)
> +{
> +	u64 syscfg, hwcr;
> +
> +	/*
> +	 * BIOS support is required for SME and SEV.
> +	 *   For SME: If BIOS has enabled SME then adjust x86_phys_bits by
> +	 *	      the SME physical address space reduction value.
> +	 *	      If BIOS has not enabled SME then don't advertise the
> +	 *	      SME feature (set in scattered.c).
> +	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
> +	 *            SEV feature (set in scattered.c).
> +	 *
> +	 *   In all cases, since support for SME and SEV requires long mode,
> +	 *   don't advertise the feature under CONFIG_X86_32.
> +	 */
> +	if (cpu_has(c, X86_FEATURE_SME) ||
> +	    cpu_has(c, X86_FEATURE_SEV)) {
> +
> +		if (IS_ENABLED(CONFIG_X86_32))
> +			goto clear;
> +
> +		/* Check if SME is enabled */
> +		rdmsrl(MSR_K8_SYSCFG, syscfg);
> +		if (!(syscfg & MSR_K8_SYSCFG_MEM_ENCRYPT))
> +			goto clear;
> +
> +		c->x86_phys_bits -= (cpuid_ebx(0x8000001f) >> 6) & 0x3f;
> +
> +		/* Check if SEV is enabled */
> +		rdmsrl(MSR_K7_HWCR, hwcr);
> +		if (!(hwcr & MSR_K7_HWCR_SMMLOCK))
> +			goto clear_sev;
> +
> +		return;
> +clear:
> +		clear_cpu_cap(c, X86_FEATURE_SME);
> +clear_sev:
> +		clear_cpu_cap(c, X86_FEATURE_SEV);
> +	}
> +}
> +
>   static void early_init_amd(struct cpuinfo_x86 *c)
>   {
>   	u32 dummy;
> @@ -617,46 +659,8 @@ static void early_init_amd(struct cpuinfo_x86 *c)
>   	if (cpu_has_amd_erratum(c, amd_erratum_400))
>   		set_cpu_bug(c, X86_BUG_AMD_E400);
>   
> -	/*
> -	 * BIOS support is required for SME and SEV.
> -	 *   For SME: If BIOS has enabled SME then adjust x86_phys_bits by
> -	 *	      the SME physical address space reduction value.
> -	 *	      If BIOS has not enabled SME then don't advertise the
> -	 *	      SME feature (set in scattered.c).
> -	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
> -	 *            SEV feature (set in scattered.c).
> -	 *
> -	 *   In all cases, since support for SME and SEV requires long mode,
> -	 *   don't advertise the feature under CONFIG_X86_32.
> -	 */
> -	if (cpu_has(c, X86_FEATURE_SME)) {
> -		u64 msr;
> -
> -		/* Check if SME is enabled */
> -		rdmsrl(MSR_K8_SYSCFG, msr);
> -		if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT) {
> -			c->x86_phys_bits -= (cpuid_ebx(0x8000001f) >> 6) & 0x3f;
> -			if (IS_ENABLED(CONFIG_X86_32))
> -				clear_cpu_cap(c, X86_FEATURE_SME);
> -		} else {
> -			clear_cpu_cap(c, X86_FEATURE_SME);
> -		}
> -	}
> +	early_detect_mem_enc(c);
>   
> -	if (cpu_has(c, X86_FEATURE_SEV)) {
> -		if (IS_ENABLED(CONFIG_X86_32)) {
> -			clear_cpu_cap(c, X86_FEATURE_SEV);
> -		} else {
> -			u64 syscfg, hwcr;
> -
> -			/* Check if SEV is enabled */
> -			rdmsrl(MSR_K8_SYSCFG, syscfg);
> -			rdmsrl(MSR_K7_HWCR, hwcr);
> -			if (!(syscfg & MSR_K8_SYSCFG_MEM_ENCRYPT) ||
> -			    !(hwcr & MSR_K7_HWCR_SMMLOCK))
> -				clear_cpu_cap(c, X86_FEATURE_SEV);
> -		}
> -	}
>   }
>   
>   static void init_amd_k8(struct cpuinfo_x86 *c)
> 
