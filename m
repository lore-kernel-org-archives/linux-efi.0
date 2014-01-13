From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v4 4/5] arm: Add [U]EFI runtime services support
Date: Mon, 13 Jan 2014 15:40:40 +0000
Message-ID: <20140113154040.GH3256@console-pimps.org>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-5-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1389445524-30623-5-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 11 Jan, at 01:05:23PM, Leif Lindholm wrote:
> This patch implements basic support for UEFI runtime services in the
> ARM architecture - a requirement for using efibootmgr to read and update
> the system boot configuration.
> 
> It uses the generic configuration table scanning to populate ACPI and
> SMBIOS pointers.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Reviewed-by: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> ---
>  arch/arm/Kconfig            |   16 ++
>  arch/arm/include/asm/uefi.h |   28 +++
>  arch/arm/kernel/Makefile    |    2 +
>  arch/arm/kernel/setup.c     |    4 +
>  arch/arm/kernel/uefi.c      |  418 +++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/uefi_phys.S |   67 +++++++
>  include/linux/efi.h         |    2 +-
>  7 files changed, 536 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/include/asm/uefi.h
>  create mode 100644 arch/arm/kernel/uefi.c
>  create mode 100644 arch/arm/kernel/uefi_phys.S

[...]

> @@ -664,7 +664,7 @@ extern int __init efi_setup_pcdp_console(char *);
>  #define EFI_64BIT		5	/* Is the firmware 64-bit? */
>  
>  #ifdef CONFIG_EFI
> -# ifdef CONFIG_X86
> +# if defined(CONFIG_X86) || defined(CONFIG_ARM)
>  extern int efi_enabled(int facility);
>  # else
>  static inline int efi_enabled(int facility)

This looks like it's going to conflict with Mark's "[PATCH 6/6] arm64:
add EFI runtime services".

Guys, what's going on here? Srsly. The dependency chain is so nuts that
I'm struggling to even review these patches. Good luck to the maintainer
that wants to merge this stuff.

Can't you guys work together a bit more closely so that all of your
patches feel like one logical progression of work?

-- 
Matt Fleming, Intel Open Source Technology Center
