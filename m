From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 0/4] EFI capsule update support
Date: Thu, 17 Mar 2016 12:57:07 +0000
Message-ID: <1458219431-24741-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is the reincarnation of the EFI capsule patches I originally
posted in 2013, plus Hock's capsule loader driver from earlier this
year. Together they provide a way for users to send capsule images to
firmware. 

EFI capsules are binary blobs passed from the OS to the firmware. The
firmware then parses them and makes some decision based upon their
contents. The most common use case is to bundle a flashable firmware
image into a capsule that the firmware can use to upgrade the existing
version in the flash.

The series has been tested on the Intel Quark Galileo.

I plan on queuing this up for v4.7.

Kweh, Hock Leong (1):
  efi: A misc char interface to update EFI firmware

Matt Fleming (3):
  efi: Move efi_status_to_err() to drivers/firmware/efi/
  efi: Capsule update support
  x86/efi: Force EFI reboot to process pending capsules

 arch/x86/kernel/reboot.c              |   9 +
 drivers/firmware/efi/Kconfig          |  10 +
 drivers/firmware/efi/Makefile         |   3 +-
 drivers/firmware/efi/capsule-loader.c | 343 ++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/capsule.c        | 286 ++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c            |  33 ++++
 drivers/firmware/efi/reboot.c         |  12 +-
 drivers/firmware/efi/vars.c           |  33 ----
 include/linux/efi.h                   |  22 +++
 9 files changed, 716 insertions(+), 35 deletions(-)
 create mode 100644 drivers/firmware/efi/capsule-loader.c
 create mode 100644 drivers/firmware/efi/capsule.c

-- 
2.6.2
