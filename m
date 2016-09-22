From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 0/3] efi: MMC proxy support for the UEFI varstore
Date: Thu, 22 Sep 2016 12:30:03 +0100
Message-ID: <1474543806-19210-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, glikely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

================================================================================
NOTE: this is a work in progress, and not fully functional yet. In particular,
the actual MMC host protocol methods are stubbed out at the moment, and need to
be wired up to the Linux device drivers.
================================================================================

On mobile and embedded systems, there is usually only a single MMC device for
non-volatile storage, which sits behind a controller that is owned by the OS at
runtime. This makes it difficult to host the UEFI variable store on MMC as well,
since the UEFI runtime services routines expect ownership of the underlying
device as well.

This series proposes an approach to work around this. It implements the UEFI
MMC host protocol in the kernel, in a way that makes it possible to expose it
to the firmware. At the same time, the firmware needs be set up for this, i.e.,
it needs to expose its MMC host protocol pointer via a UEFI configuration table,
so that the kernel can override it if it decides to expose this functionality
to the firmware.

Note that these patches are based on patches in the EFI tree that are queued
for v4.9, which replace the runtime wrappers spinlock with a semaphore. This
allows us to sleep in the firmware callbacks.

Prerequisites for using these patches:

* qemu-system-aarch64 built from this branch:
  https://git.linaro.org/people/ard.biesheuvel/qemu.git/shortlog/refs/heads/mach-virt-pl181
  which adds a PL181 SD/MMC controller to the mach-virt model, and exposes it
  via the device tree. It also sets the 'linux,uefi-varstore' property on this
  node.

* UEFI firmware built from this branch:
  https://git.linaro.org/people/ard.biesheuvel/uefi-next.git/shortlog/refs/heads/mmc-proxy
  
  Build using the following command
  build -a AARCH64 -t GCC5 -p ArmVirtPkg/ArmVirtQemuMmcVars.dsc

  Run using 
  qemu-system-aarch64 \
    -M virt -cpu cortex-a57 -m 2048 \
    -device virtio-blk-device,drive=boot \
    -drive if=none,id=boot,file=fat:<path-of-Image>,format=raw \
    -kernel <edk2-dir>/Build/ArmVirtQemuMmcVars-AARCH64/DEBUG_GCC5/FV/QEMU_EFI.fd \
    -sd <edk2-dir>/build/edk2/Build/ArmVirtQemuMmcVars-AARCH64/DEBUG_GCC5/FV/QEMU_VARS.fd \
    -nographic $@

  This will give you an UEFI environment which keeps its UEFI variables in the
  emulated MMC volume, and exposes its MMC host protocol in a way that allows
  these patches to hook into it.

Patches #1 and #2 implement the arch specific hooks to preserve/restore the NEON
registers that the firmware may expect to be preserved across function calls.

Patch #3 implements the plumbing to call back into the kernel from the firmware.

Please comment on whether this approach seems feasible, and in particular, how
on earth I should wire this up to the actual MMC code.

Thanks,
Ard.

Ard Biesheuvel (3):
  efi/arm64: add SIMD stash/unstash operations
  efi/arm: add SIMD stash/unstash operations
  efi: implement MMC proxy support for the UEFI variable store

 arch/arm/include/asm/efi.h       |  11 +
 arch/arm64/include/asm/efi.h     |  33 +++
 drivers/firmware/efi/Kconfig     |   9 +
 drivers/firmware/efi/Makefile    |   1 +
 drivers/firmware/efi/arm-init.c  |   2 +
 drivers/firmware/efi/mmc-proxy.c | 222 ++++++++++++++++++++
 include/linux/efi.h              |   1 +
 7 files changed, 279 insertions(+)
 create mode 100644 drivers/firmware/efi/mmc-proxy.c

-- 
2.7.4
