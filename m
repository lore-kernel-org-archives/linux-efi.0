From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Add asm-generic/efi.h for non-x86
Date: Thu, 17 Oct 2013 15:16:53 +0100
Message-ID: <20131017141653.GJ10834@console-pimps.org>
References: <1382012355-8846-1-git-send-email-matt@console-pimps.org>
 <1382012355-8846-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1382012355-8846-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 17 Oct, at 01:19:14PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> From the #ifdef CONFIG_X86 in linux/efi.h it's clear we need a place to
> declare functions that are implemented differently for each
> architecture.
> 
> Since it's only x86 that needs to do special things, add a generic EFI
> header file that can be used by everyone else and move the x86-specific
> stuff to arch/x86/include/asm/efi.h.
> 
> Because the asm files are now included from linux/efi.h directly, this
> change means we no longer have to include the asm file explicitly from C
> files, allowing us to delete quite a few #include lines.
> 
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

[...]

> diff --git a/include/asm-generic/efi.h b/include/asm-generic/efi.h
> new file mode 100644
> index 0000000..8a31713
> --- /dev/null
> +++ b/include/asm-generic/efi.h
> @@ -0,0 +1,17 @@
> +#ifndef _ASM_GENERIC_EFI_H
> +#define _ASM_GENERIC_EFI_H
> +
> +static inline void efi_late_init(void) {}
> +static inline void efi_free_boot_services(void) {}
> +
> +static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
> +{
> +	return EFI_SUCCESS;
> +}
> +
> +static inline int efi_enabled(int facility)
> +{
> +	return IS_ENABLED(CONFIG_EFI);
> +}
> +
> +#endif /* _ASM_GENERIC_EFI_H */

After reading Leif's arm runtime patches this patch obviously doesn't
make much sense. I'll work on something better.

-- 
Matt Fleming, Intel Open Source Technology Center
