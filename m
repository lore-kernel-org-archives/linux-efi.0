From: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
Subject: [RFC PATCH 0/4] EFI boot stub memory map fix
Date: Mon, 19 Aug 2013 14:00:15 -0600
Message-ID: <1376942419-5684-1-git-send-email-linn@hp.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jacob.shin-5C7GfCeVMHo@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

I realize the EFI stub for ARM patches are in flight, 

https://lkml.org/lkml/2013/8/9/554

and overlap with some of the files but I wanted to send these out for comment.

This series fixes a problem with EFI memory maps larger than 128 entries when
booting using the EFI boot stub, which results in overflowing the e820_map in
boot_params and an eventual halt when checking the map size in
sanitize_e820_map().

The fix implemented is to add the EFI memory map from setup_arch() via a
memory_setup hook.

Two options were considered:

 1. Use the SETUP_E820_EXT setup_data type to add the extra entries.

 2. Create a memory_setup function to be enabled when the EFI memory map is
    needed.

Option 2 appeared to be the cleaner solution, reducing duplication with
existing code, given a reasonable mechanism for determining when to
replace the default memory_setup function.


Linn Crosetto (4):
  efi: Decouple efi_memmap_init() and do_add_efi_memmap()
  efi: Add memory_setup function efi_memory_setup()
  efi: Add efi_memmap_needed()
  x86: Fix EFI boot stub for large memory maps

 arch/x86/boot/compressed/eboot.c | 64 ++--------------------------------------
 arch/x86/kernel/setup.c          |  3 ++
 arch/x86/platform/efi/efi.c      | 51 +++++++++++++++++++++++---------
 include/linux/efi.h              |  2 ++
 4 files changed, 45 insertions(+), 75 deletions(-)

-- 
1.7.11.3
