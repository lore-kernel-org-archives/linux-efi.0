From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2] efi: add support for seeding the kernel RNG from UEFI
Date: Thu,  6 Oct 2016 11:27:24 +0100
Message-ID: <1475749646-10844-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This implements generic EFI core kernel code to seed the kernel entropy
pool from a Linux specific UEFI configuration table containing a random seed
supplied by the firmware. (#1)

In addition, it wires it up for ARM and arm64, by invoking the EFI_RNG_PROTOCOL
UEFI protocol from the stub, and populating such a UEFI config table using its
output.

How to wire this up for x86 is left as an exercise for the Intel developer.

Ard Biesheuvel (2):
  efi: add support for seeding the RNG from a UEFI config table
  efi/arm*: libstub: invoke EFI_RNG_PROTOCOL to seed the UEFI RNG table

 drivers/firmware/efi/efi.c              | 26 +++++++++++
 drivers/firmware/efi/libstub/arm-stub.c |  2 +
 drivers/firmware/efi/libstub/efistub.h  |  2 +
 drivers/firmware/efi/libstub/random.c   | 48 ++++++++++++++++++++
 include/linux/efi.h                     |  9 ++++
 5 files changed, 87 insertions(+)

-- 
2.7.4
