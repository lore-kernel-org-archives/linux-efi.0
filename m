From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 0/7] x86, boot: clean up kasl
Date: Sat,  7 Mar 2015 14:07:14 -0800
Message-ID: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

First 3 patches make ZO (arch/x86/boot/compressed/vmlinux) data region is not
overwritten by VO (vmlinux) after decompress.  So could pass data from ZO to VO.

The 4th one is fixing kaslr_enabled accessing. Old code is using address
as value wrongly.

Last 3 patches are the base for kaslr supporting kernel above 4G.
create new ident mapping for kasl 64bit, so we can cover
   above 4G random kernel base, also don't need to track pagetable
   for 64bit bootloader (patched grub2 or kexec).
   that will make mem_avoid handling simple.

Please put first 4 patches into tip/x86/urgent to v4.0

Last 3 patches should go to tip/x86/kasl and to v4.1, but you may need to
pull x86/urgent to x86/kasl, as them depends on first 4 patches.

He could rebase his patches about kasl on top those patches.

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-4.0-rc2-aslr

Thanks

Yinghai Lu

Yinghai Lu (7):
  x86, kaslr: Use init_size instead of run_size
  x86, boot: Move ZO to end of buffer
  x86, boot: Don't overlap VO with ZO data
  x86, kaslr: Access the correct kaslr_enabled variable
  x86, kaslr: Consolidate mem_avoid array filling
  x86, boot: Split kernel_ident_mapping_init to another file
  x86, kaslr, 64bit: Set new or extra ident_mapping

 arch/x86/boot/Makefile                 |  2 +-
 arch/x86/boot/compressed/Makefile      |  4 +-
 arch/x86/boot/compressed/aslr.c        | 48 ++++++++++++-----
 arch/x86/boot/compressed/head_32.S     | 16 ++++--
 arch/x86/boot/compressed/head_64.S     | 17 +++---
 arch/x86/boot/compressed/misc.c        | 15 +++---
 arch/x86/boot/compressed/misc.h        |  4 +-
 arch/x86/boot/compressed/misc_pgt.c    | 98 ++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/mkpiggy.c     | 16 ++----
 arch/x86/boot/compressed/vmlinux.lds.S |  2 +
 arch/x86/boot/header.S                 |  9 ++--
 arch/x86/include/asm/boot.h            | 19 +++++++
 arch/x86/include/asm/page.h            |  5 ++
 arch/x86/kernel/asm-offsets.c          |  1 +
 arch/x86/kernel/setup.c                | 13 ++++-
 arch/x86/kernel/vmlinux.lds.S          |  1 +
 arch/x86/mm/ident_map.c                | 74 +++++++++++++++++++++++++
 arch/x86/mm/init_64.c                  | 74 +------------------------
 arch/x86/tools/calc_run_size.sh        | 42 ---------------
 19 files changed, 288 insertions(+), 172 deletions(-)
 create mode 100644 arch/x86/boot/compressed/misc_pgt.c
 create mode 100644 arch/x86/mm/ident_map.c
 delete mode 100644 arch/x86/tools/calc_run_size.sh

-- 
1.8.4.5
