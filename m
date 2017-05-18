From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/3] efi: arm64: use -fpie for building the stub
Date: Thu, 18 May 2017 10:09:50 +0100
Message-ID: <20170518090953.32628-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Bernhard.Rosenkranzer-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Clang requires the stub to be built with -fpie, or it may emit absolute
symbol references that trigger the absolute relocation detection code and
cause the build to fail.

The remedy is to set -fpie (#3), but due to stupid ELF symbol preemption
rules that only apply to shared libraries, this will result in more rather
than fewer absolute references (i.e., GOT entries), which we have to massage
away using visibility overrides first. (#1, #2)

Ard Biesheuvel (3):
  efi/libstub: arm64: use hidden attribute for struct screen_info
    reference
  efi/libstub: arm64: force 'hidden' visibility for section markers
  efi/libstub: arm64: set -fpie when building the EFI stub

 arch/arm64/include/asm/efi.h              |  3 +++
 drivers/firmware/efi/libstub/Makefile     |  2 +-
 drivers/firmware/efi/libstub/arm64-stub.c | 10 +++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

-- 
2.9.3
