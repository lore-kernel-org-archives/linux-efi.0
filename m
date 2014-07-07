From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3 0/5] efistub: convert into static library
Date: Mon, 7 Jul 2014 20:31:24 +0100
Message-ID: <20140707193124.GD2914@console-pimps.org>
References: <1404305683-26501-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404305683-26501-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 02 Jul, at 02:54:38PM, Ard Biesheuvel wrote:
> This is v3 of the series to change the #include "../../../../xxx.c" pattern
> into a static library linked into either the kernel (arm64) or a separate boot
> decompressor (x86, ARM).
> 
> Changes since v2:
> - make sure that removals of 'static' modifiers occur in a way that doesn't
>   break bisect (i.e., definition + all declarations in the same patch)
> - avoid ia64 breakage (which does not use the stub) by building it conditionally
>   on CONFIG_EFI_STUB not CONFIG_EFI
> 
> Changes since v1:
> - added patch #1 to change EFI_ERROR, it is not a result code defined by UEFI so
>   it should only be returned by get_dram_base() and efi_entry()
> - added a section to libstub Makefile to clean CFLAGS of stack protecter and
>   other options that are inappropriate for the stub
> - rebased onto the UEFI Runtime Services NEON patches (re)posted earlier today
> 
> Ard Biesheuvel (5):
>   efi/arm64: Avoid EFI_ERROR as a generic return code
>   efi/x86: efistub: Move shared dependencies to <asm/efi.h>
>   efi/arm64: efistub: Move shared dependencies to <asm/efi.h>
>   efi: efistub: refactor stub components
>   efi: efistub: convert into static library
> 
>  arch/arm64/Kconfig                                 |  5 ++
>  arch/arm64/Makefile                                |  1 +
>  arch/arm64/include/asm/efi.h                       | 12 ++++
>  arch/arm64/kernel/efi-stub.c                       | 48 +++-----------
>  arch/x86/boot/compressed/Makefile                  |  3 +-
>  arch/x86/boot/compressed/eboot.c                   | 20 ++----
>  arch/x86/boot/compressed/eboot.h                   | 16 -----
>  arch/x86/include/asm/efi.h                         | 25 ++++++++
>  drivers/firmware/efi/Kconfig                       |  3 +
>  drivers/firmware/efi/Makefile                      |  1 +
>  drivers/firmware/efi/libstub/Makefile              | 26 ++++++++
>  drivers/firmware/efi/{ => libstub}/arm-stub.c      | 32 ++++++----
>  .../firmware/efi/{ => libstub}/efi-stub-helper.c   | 74 +++++++++++-----------
>  drivers/firmware/efi/libstub/efistub.h             | 42 ++++++++++++
>  drivers/firmware/efi/{ => libstub}/fdt.c           | 20 +++---
>  include/linux/efi.h                                | 42 ++++++++++++
>  16 files changed, 242 insertions(+), 128 deletions(-)
>  create mode 100644 drivers/firmware/efi/libstub/Makefile
>  rename drivers/firmware/efi/{ => libstub}/arm-stub.c (93%)
>  rename drivers/firmware/efi/{ => libstub}/efi-stub-helper.c (88%)
>  create mode 100644 drivers/firmware/efi/libstub/efistub.h
>  rename drivers/firmware/efi/{ => libstub}/fdt.c (94%)

Thanks Ard, queued up for v3.17.

-- 
Matt Fleming, Intel Open Source Technology Center
