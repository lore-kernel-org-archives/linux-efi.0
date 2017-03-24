From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 0/7] efi: Enhance capsule loader to support signed Quark images
Date: Fri, 24 Mar 2017 18:34:13 +0100
Message-ID: <cover.1490376860.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This addresses the review feedback provided on round 1, specifically
- refactored queue to keep the Quark mess in 
- only check for CSH on Quark CPUs
- added some smaller cleanups of the capsule loader
- documented capsule header / linked to original code

See last patch for the background of the series.

The series has been tested on the Galileo Gen2, to exclude regressions,
with a firmware.cap with AND without security header and the SIMATIC
IOT2040 which requires the header because of its mandatory secure boot.

Jan

Jan Kiszka (7):
  efi/capsule: Fix return code on failing kmap/vmap
  efi/capsule: Remove pr_debug on ENOMEM or EFAULT
  efi/capsule: Clean up pr_err/info messages
  efi/capsule: Adjust return type of efi_capsule_setup_info
  efi/capsule: Prepare for loading images with security header
  efi/capsule: Factor out overloadable efi_capsule_identify_image
  efi/capsule: Add support for Quark security header

 arch/x86/platform/efi/quirks.c        |  95 ++++++++++++++++++++++++
 drivers/firmware/efi/capsule-loader.c | 136 +++++++++++++++++++---------------
 drivers/firmware/efi/capsule.c        |  21 +++++-
 include/linux/efi.h                   |  19 +++++
 4 files changed, 208 insertions(+), 63 deletions(-)

-- 
2.10.2
