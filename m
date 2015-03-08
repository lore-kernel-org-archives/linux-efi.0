From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 0/8] x86, boot: clean up setup_data handling
Date: Sat,  7 Mar 2015 16:56:13 -0800
Message-ID: <1425776181-10219-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Now setup_data is reserved via memblock and e820 and different
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
5. export SETUP_PCI via sysfs.

Also put them in:
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-4.0-rc2-setup_data

Should be materials for v4.1.

Thanks

Yinghai Lu

-v3: separated with kasl patches, and fix early_ioremap return checking.

Yinghai Lu (8):
  x86: Kill E820_RESERVED_KERN
  x86, efi: Copy SETUP_EFI data and access directly
  x86, of: Let add_dtb reserve setup_data locally
  x86, boot: Add add_pci handler for SETUP_PCI
  x86: Kill not used setup_data handling code
  x86, boot, PCI: Convert SETUP_PCI data to list
  x86, boot, PCI: Copy SETUP_PCI rom to kernel space
  x86, boot, PCI: Export SETUP_PCI data via sysfs

 arch/x86/include/asm/efi.h       |   2 +-
 arch/x86/include/asm/pci.h       |   4 +
 arch/x86/include/asm/prom.h      |   9 +-
 arch/x86/include/uapi/asm/e820.h |   9 --
 arch/x86/kernel/devicetree.c     |  43 +++---
 arch/x86/kernel/e820.c           |   6 +-
 arch/x86/kernel/kdebugfs.c       | 142 ------------------
 arch/x86/kernel/setup.c          |  52 ++-----
 arch/x86/kernel/tboot.c          |   3 +-
 arch/x86/mm/init_64.c            |  11 +-
 arch/x86/pci/common.c            | 316 ++++++++++++++++++++++++++++++++++++---
 arch/x86/platform/efi/efi.c      |  13 +-
 arch/x86/platform/efi/efi_64.c   |  13 +-
 arch/x86/platform/efi/quirks.c   |  23 +--
 14 files changed, 371 insertions(+), 275 deletions(-)

-- 
1.8.4.5
