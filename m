From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 00/15] x86, boot: clean up kasl and setup_data handling
Date: Wed,  4 Mar 2015 00:00:33 -0800
Message-ID: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

patch 1-7: are kasl related.
1. make ZO: arch/x86/boot/compressed/vmlinux data region is not
overwritten by final VO: vmlinux after decompress.
so could pass data from ZO to VO
2. create new ident mapping for kasl 64bit, so we can cover
   above 4G random kernel base, also don't need to track pagetable
   for 64bit bootloader (patched grub2 or kexec).
   that will make mem_avoid handling simple.

patch 8-15: setup_data related.

Now we setup_data is reserved via memblock and e820 and different
handlers have different ways, and it is confusing.
1. SETUP_E820_EXT: is consumed early and will not copy or access again.
        have memory wasted.
2. SETUP_EFI: is accessed via ioremap every time at early stage.
        have memory wasted.
3. SETUP_DTB: is copied locally.
        have memory wasted.
4. SETUP_PCI: is accessed via ioremap for every pci devices, even run-time.
5. SETUP_KASLR: is accessed early, will not copy or access again.
        have memory wasted.

Also setup_data is exported to debugfs for debug purpose.

Here will convert to let every handler to decide how to handle it.
and will not reserve the setup_data generally, so will not
waste memory and also make memblock/e820 keep page aligned.
1. not touch E820 anymore.
2. copy SETUP_EFI to __initdata variable and access it without ioremap.
3. SETUP_DTB: reserver and copy to local and free.
4. SETUP_PCI: reverve localy and convert to list, to avoid keeping ioremap.
5. SETUP_KASLR: fix accessing kaslr_enabled accessing...
6. export SETUP_PCI via sysfs.

Yinghai Lu (15):
  x86, kaslr: Use init_size instead of run_size
  x86, boot: move ZO to end of buffer
  x86, boot: keep data from ZO boot stage to VO kernel stage.
  x86, kaslr: get kaslr_enabled back correctly
  x86, kaslr: consolidate the mem_avoid filling
  x86, boot: split kernel_ident_mapping_init into another file
  x86, kaslr, 64bit: set new or extra ident_mapping
  x86: Kill E820_RESERVED_KERN
  x86, efi: copy SETUP_EFI data and access directly
  x86, of: let add_dtb reserve by itself
  x86, boot: Add add_pci handler for SETUP_PCI
  x86: kill not used setup_data handling code
  x86, pci: convert SETUP_PCI data to list
  x86, boot: copy rom to kernel space
  x86, pci: export SETUP_PCI data via sysfs

 arch/x86/boot/Makefile                 |   2 +-
 arch/x86/boot/compressed/Makefile      |   4 +-
 arch/x86/boot/compressed/aslr.c        |  55 ++++--
 arch/x86/boot/compressed/head_32.S     |  16 +-
 arch/x86/boot/compressed/head_64.S     |  17 +-
 arch/x86/boot/compressed/misc.c        |  15 +-
 arch/x86/boot/compressed/misc_pgt.c    |  96 ++++++++++
 arch/x86/boot/compressed/mkpiggy.c     |  12 +-
 arch/x86/boot/compressed/vmlinux.lds.S |   2 +
 arch/x86/boot/header.S                 |   7 +-
 arch/x86/include/asm/boot.h            |  13 ++
 arch/x86/include/asm/efi.h             |   2 +-
 arch/x86/include/asm/page.h            |   5 +
 arch/x86/include/asm/pci.h             |   4 +
 arch/x86/include/asm/prom.h            |   9 +-
 arch/x86/include/uapi/asm/e820.h       |   9 -
 arch/x86/kernel/asm-offsets.c          |   1 +
 arch/x86/kernel/devicetree.c           |  39 ++--
 arch/x86/kernel/e820.c                 |   6 +-
 arch/x86/kernel/kdebugfs.c             | 142 ---------------
 arch/x86/kernel/setup.c                |  60 ++-----
 arch/x86/kernel/tboot.c                |   3 +-
 arch/x86/mm/ident_map.c                |  74 ++++++++
 arch/x86/mm/init_64.c                  |  85 +--------
 arch/x86/pci/common.c                  | 313 +++++++++++++++++++++++++++++++--
 arch/x86/platform/efi/efi.c            |  13 +-
 arch/x86/platform/efi/efi_64.c         |  13 +-
 arch/x86/platform/efi/quirks.c         |  23 +--
 arch/x86/tools/calc_run_size.sh        |  42 -----
 29 files changed, 640 insertions(+), 442 deletions(-)
 create mode 100644 arch/x86/boot/compressed/misc_pgt.c
 create mode 100644 arch/x86/mm/ident_map.c
 delete mode 100644 arch/x86/tools/calc_run_size.sh

-- 
1.8.4.5
