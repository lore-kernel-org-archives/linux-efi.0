From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/3] efi: add support for seeding the kernel RNG from UEFI
Date: Thu, 20 Oct 2016 12:21:23 +0100
Message-ID: <1476962486-18368-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
Cc: tytso-3s7WtUTddSA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This implements generic EFI core kernel code to seed the kernel entropy
pool from a Linux specific UEFI configuration table containing a random seed
supplied by the firmware. (#1)

In addition, it wires it up for ARM and arm64, by invoking the EFI_RNG_PROTOCOL
UEFI protocol from the stub, and populating such a UEFI config table using its
output.

Changes since v1:
- Add a patch to actually build random.c for the ARM version of the stub, so
  that the functionality that patch #3 adds is available on ARM as well as arm64
- Handle the kexec case, by updating the seed in the configuration table on
  reboot.

How to wire this up for x86 is left as an exercise for the Intel developer.

Ard Biesheuvel (3):
  efi: add support for seeding the RNG from a UEFI config table
  efi/libstub: add random.c to ARM build
  efi/arm*: libstub: invoke EFI_RNG_PROTOCOL to seed the UEFI RNG table

 drivers/firmware/efi/efi.c                     | 67 ++++++++++++++++++++
 drivers/firmware/efi/libstub/Makefile          |  4 +-
 drivers/firmware/efi/libstub/arm-stub.c        |  2 +
 drivers/firmware/efi/libstub/efi-stub-helper.c |  9 ---
 drivers/firmware/efi/libstub/efistub.h         | 11 ++++
 drivers/firmware/efi/libstub/random.c          | 48 ++++++++++++++
 include/linux/efi.h                            |  9 +++
 7 files changed, 139 insertions(+), 11 deletions(-)

-- 
2.7.4
