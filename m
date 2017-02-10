From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi: arm-stub: Correct FDT and initrd allocation
 rules for arm64
Date: Fri, 10 Feb 2017 10:05:26 +0000
Message-ID: <20170210100525.GA28753@leverpostej>
References: <1486676573-19237-1-git-send-email-ard.biesheuvel@linaro.org>
 <a7058407-a770-d413-e072-ba3edd7df197@codeaurora.org>
 <A1A268D8-2B0B-4333-9E2D-A88CE6061F22@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <A1A268D8-2B0B-4333-9E2D-A88CE6061F22-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "Ruigrok, Richard" <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 10, 2017 at 06:38:11AM +0000, Ard Biesheuvel wrote:
> > On 10 Feb 2017, at 00:42, Ruigrok, Richard <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> >> On 2/9/2017 2:42 PM, Ard Biesheuvel wrote:

> >> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
> >> index 0b6b1633017f..342e90d6d204 100644
> >> --- a/arch/arm64/include/asm/efi.h
> >> +++ b/arch/arm64/include/asm/efi.h
> >> @@ -46,7 +46,23 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
> >>  * 2MiB so we know it won't cross a 2MiB boundary.
> >>  */
> >> #define EFI_FDT_ALIGN    SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
> >> -#define MAX_FDT_OFFSET    SZ_512M
> >> +
> >> +/* on arm64, the FDT may be located anywhere in system RAM */
> >> +static inline unsigned long efi_get_max_fdt_addr(unsigned long dram_base)
> >> +{
> >> +    return ULONG_MAX;
> >> +}
> >> +
> >> +/*
> >> + * On arm64, we have to ensure that the initrd ends up in the linear region,
> >> + * which is a 1 GB aligned region of size '1UL << (VA_BITS - 1)' that is
> >> + * guaranteed to cover the kernel Image.
> >> + */
> >> +static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
> >> +                            unsigned long image_addr)
> >> +{
> >> +    return (image_addr & ~(SZ_1G - 1UL)) + (1UL << (VA_BITS - 1));
> >> +}
> >> 
> > Please update booting.txt which specifies a window of 32G for ARM64
> > 
> 
> No. The efi stub is built into the kernel, so there we can be lax
> about these things.

Sure.

Given this is a source of confusion, can we drop a comment here as to
how this is deliberate? e.g.

/*
 * On arm64, we have to ensure that the initrd ends up in the linear region,
 * which is a 1 GB aligned region of size '1UL << (VA_BITS - 1)' that is
 * guaranteed to cover the kernel Image.
 *
 * Since the EFI stub is part of the kernel Image, we can relax than the
 * usual requirements in Documentation/arm64/booting.txt, which still
 * apply to other bootloaders, and are required for some kernel
 * configurations.
 */

Thanks,
Mark.
