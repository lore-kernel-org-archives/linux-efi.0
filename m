From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/7] ARM/efi minor fixes + stub pre-boot compat checks
Date: Thu,  4 Feb 2016 16:50:23 +0100
Message-ID: <1454601030-9093-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, jeremy.linton-5wv7dgnIgG8@public.gmane.org, suzuki.poulose-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

I merged two EFI/ARM related series, whose v1's I sent out last week:

Changes since v1:
- added various tags from various people
- new patch #3 to undefine __init

@Matt: are you happy with all of this going through the arm64 tree? I don't
think it clashes with anything else we've got queued up for v4.6 in tip/efi/core

Series 1: arm efi minor fixes
http://thread.gmane.org/gmane.linux.ports.arm.kernel/473027
This fixes two minor issues with the handling of .init data in the stub (#1, #2)

Patch #3 is a new patch that un-#defines __init in efistub.h, to catch its
inadvertent use in the UEFI stub

Patch #4 replaces some instances of early_memremap() with early_memremap_ro()
where the region in question is only accessed in r/o mode.

Series 2: UEFI stub pre-boot compat checks
http://thread.gmane.org/gmane.linux.ports.arm.kernel/473189

As discussed earlier today [1], and last year [2], it makes sense for the
UEFI stub to perform some basic checks on the hardware for missing features
that would prevent the kernel from booting to a state where it can even
complain about this.

So implements this for ARM, to check on LPAE builds whether the CPU supports
it (patch #5), and for arm64, to check whether the build time granule is
implemented by the CPU (patch #6). Patch #7 wires it up into the shared init
code.

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/472880
[2] http://thread.gmane.org/gmane.linux.ports.arm.kernel/447370

Ard Biesheuvel (7):
  arm64: efistub: drop __init annotation from handle_kernel_image()
  arm64: vmlinux.lds.S: handle .init.rodata.xxx and .init.bss sections
  efi: efistub: prevent __init annotations from being used
  efi: arm-init: use read-only early mappings
  ARM: efistub: check for LPAE support before booting a LPAE kernel
  arm64: efistub: check for h/w support before booting a >4 KB granule
    kernel
  ARM/arm64: efistub: perform hardware compatibility check

 arch/arm64/kernel/vmlinux.lds.S           |  1 +
 drivers/firmware/efi/arm-init.c           | 14 ++++----
 drivers/firmware/efi/libstub/arm-stub.c   |  4 +++
 drivers/firmware/efi/libstub/arm32-stub.c | 17 ++++++++++
 drivers/firmware/efi/libstub/arm64-stub.c | 34 ++++++++++++++++----
 drivers/firmware/efi/libstub/efistub.h    | 12 +++++++
 6 files changed, 68 insertions(+), 14 deletions(-)

-- 
2.5.0
