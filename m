From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/4]  efi: libstub enhancements for cmdline parsing and kaslr
Date: Mon, 27 Mar 2017 18:16:59 +0100
Message-ID: <20170327171703.15489-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This adds support for the 'quiet' kernel command line parameter, so
that meaningless debug prints can be prevented from corrupting the
boot splash (#3)

Secondly, it enables randomization of the UEFI runtime services region when
KASLR is in effect (#4)

Patches #1 and #2 are preparatory cleanup patches. Patch #4 trivially depends
on #2 which is why they are part of the same series.

v2: - Fix x86 breakage caused by the fact that CONFIG_CMDLINE is not guaranteed
      to be defined on that architecture. So instead, preserve the original x86
      behavior, and move th handling of CONFIG_CMDLINE_FORCE back to the ARM
      code.
    - Add Mark's ack.

Ard Biesheuvel (4):
  efi/libstub: fix harmless command line parsing bug
  efi/libstub: unify command line param parsing
  efi/libstub: arm/arm64: disable debug prints on 'quiet' cmdline arg
  ef/libstub: arm/arm64: randomize the base of the UEFI rt services
    region

 drivers/firmware/efi/libstub/arm-stub.c        | 72 ++++++++++++--------
 drivers/firmware/efi/libstub/arm32-stub.c      |  2 +
 drivers/firmware/efi/libstub/arm64-stub.c      |  4 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c | 32 ++++++---
 drivers/firmware/efi/libstub/efistub.h         |  9 +++
 drivers/firmware/efi/libstub/secureboot.c      |  2 +
 include/linux/efi.h                            |  5 +-
 7 files changed, 79 insertions(+), 47 deletions(-)

-- 
2.9.3
