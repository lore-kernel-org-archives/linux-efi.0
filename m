From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/4] efi: libstub enhancements for cmdline parsing and kaslr
Date: Fri, 24 Mar 2017 13:24:06 +0000
Message-ID: <20170324132410.16628-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rfranz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This adds support for the 'quiet' kernel command line parameter, so
that meaningless debug prints can be prevented from corrupting the
boot splash (#3)

Secondly, it enables randomization of the UEFI runtime services region when
KASLR is in effect (#4)

Patches #1 and #2 are preparatory cleanup patches. Patch #4 trivially depends
on #2 which is why they are part of the same series.

Ard Biesheuvel (4):
  efi/libstub: fix harmless command line parsing bug
  efi/libstub: unify command line param parsing
  efi/libstub: arm/arm64: disable debug prints on 'quiet' cmdline arg
  ef/libstub: arm/arm64: randomize the base of the UEFI rt services
    region

 drivers/firmware/efi/libstub/arm-stub.c        | 68 +++++++++++---------
 drivers/firmware/efi/libstub/arm32-stub.c      |  2 +
 drivers/firmware/efi/libstub/arm64-stub.c      |  4 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c | 36 ++++++++---
 drivers/firmware/efi/libstub/efistub.h         |  9 +++
 drivers/firmware/efi/libstub/secureboot.c      |  2 +
 include/linux/efi.h                            |  5 +-
 7 files changed, 79 insertions(+), 47 deletions(-)

-- 
2.9.3
