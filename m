From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 00/19] x86, boot: kaslr cleanup and 64bit kaslr support
Date: Wed, 18 Mar 2015 00:28:07 -0700
Message-ID: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

First make ZO (arch/x86/boot/compressed/vmlinux) data region is not
overwritten by VO (vmlinux) after decompress.  So could pass data from ZO to VO.

Second one is second try for kaslr_setup_data support.

Patch 3-11, are kaslr clean up and enable ident mapping for He's patches.
  kill run_size calculation shell scripts.
  create new ident mapping for kasl 64bit, so we can cover
   above 4G random kernel base, also don't need to track pagetable
   for 64bit bootloader (patched grub2 or kexec).
   that will make mem_avoid handling simple.

Also put 7 patches from He that support random random, as I already used
his patches to test the ident mapping code, and could save some rebase
work for him.

also at:
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-4.0-rc5-aslr

Thanks

Yinghai


Baoquan He (7):
  x86, kaslr: Fix a bug that relocation can not be handled when kernel is loaded above 2G
  x86, kaslr: Introduce struct slot_area to manage randomization slot info
  x86, kaslr: Add two functions which will be used later
  x86, kaslr: Introduce fetch_random_virt_offset to randomize the kernel text mapping address
  x86, kaslr: Randomize physical and virtual address of kernel separately
  x86, kaslr: Add support of kernel physical address randomization above 4G
  x86, kaslr: Remove useless codes

Jiri Kosina (1):
  x86, kaslr: Propagate base load address calculation v2

Yinghai Lu (11):
  x86, boot: Make data from decompress_kernel stage live longer
  x86, boot: Simplify run_size calculation
  x86, kaslr: Kill not used run_size related code.
  x86, kaslr: Use output_run_size
  x86, kaslr: Consolidate mem_avoid array filling
  x86, boot: Move z_extract_offset calculation to header.S
  x86, kaslr: Get correct max_addr for relocs pointer
  x86, boot: Split kernel_ident_mapping_init to another file
  x86, 64bit: Set ident_mapping for kaslr
  x86, boot: Add checking for memcpy
  x86, kaslr: Allow random address could be below loaded address

 arch/x86/boot/Makefile                 |  13 +-
 arch/x86/boot/compressed/Makefile      |  19 ++-
 arch/x86/boot/compressed/aslr.c        | 281 ++++++++++++++++++++++++---------
 arch/x86/boot/compressed/head_32.S     |  14 +-
 arch/x86/boot/compressed/head_64.S     |  15 +-
 arch/x86/boot/compressed/misc.c        |  71 +++++----
 arch/x86/boot/compressed/misc.h        |  32 ++--
 arch/x86/boot/compressed/misc_pgt.c    |  91 +++++++++++
 arch/x86/boot/compressed/mkpiggy.c     |  28 +---
 arch/x86/boot/compressed/string.c      |  28 +++-
 arch/x86/boot/compressed/vmlinux.lds.S |   2 +
 arch/x86/boot/header.S                 |  43 ++++-
 arch/x86/include/asm/aslr.h            |  10 ++
 arch/x86/include/asm/boot.h            |  19 +++
 arch/x86/include/asm/page.h            |   5 +
 arch/x86/include/asm/page_types.h      |   2 +
 arch/x86/include/uapi/asm/bootparam.h  |   1 +
 arch/x86/kernel/asm-offsets.c          |   1 +
 arch/x86/kernel/module.c               |  10 +-
 arch/x86/kernel/setup.c                |  27 +++-
 arch/x86/kernel/vmlinux.lds.S          |   1 +
 arch/x86/mm/ident_map.c                |  74 +++++++++
 arch/x86/mm/init_64.c                  |  74 +--------
 arch/x86/tools/calc_run_size.sh        |  42 -----
 24 files changed, 610 insertions(+), 293 deletions(-)
 create mode 100644 arch/x86/boot/compressed/misc_pgt.c
 create mode 100644 arch/x86/include/asm/aslr.h
 create mode 100644 arch/x86/mm/ident_map.c
 delete mode 100644 arch/x86/tools/calc_run_size.sh

-- 
1.8.4.5
