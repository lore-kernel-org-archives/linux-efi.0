From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 0/4] EFI memmap fix v2
Date: Sat, 11 Jan 2014 21:49:26 +0100
Message-ID: <1389473370-1940-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Ok, here's v2 rebased and rediffed against tip (which has the relevant
efi branches).

Toshi, I'm pushing it to:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git#efi-fixes

so that you can give it another run and so that the build robot can poke
at it.

Thanks.

Changelog:

* v1:

this is the result of Toshi and me debugging a #GP on one of his big HP
boxes sporting UEFI. Each commit message should be self-explanatory so
please look there.

This has more or less an RFC nature thus I'm sending it now to collect
feedback. It is going to wait in the EFI queue anyway after the kexec
stuff gets sorted out first.

Comments and suggestions as always are very much appreciated.

Borislav Petkov (4):
  x86, ptdump: Add the functionality to dump an arbitrary pagetable
  efi: Dump the EFI page table
  x86, pageattr: Export page unmapping interface
  efi: Make efi virtual runtime map passing more robust

 arch/x86/include/asm/efi.h           |  3 +-
 arch/x86/include/asm/pgtable.h       |  3 +-
 arch/x86/include/asm/pgtable_types.h |  2 +
 arch/x86/mm/dump_pagetables.c        | 77 ++++++++++++++++++++++++------------
 arch/x86/mm/pageattr.c               | 44 +++++++++++++++------
 arch/x86/platform/efi/efi.c          | 73 ++++++++++++++++++++++++++--------
 arch/x86/platform/efi/efi_32.c       |  6 ++-
 arch/x86/platform/efi/efi_64.c       | 31 +++++++++++++--
 8 files changed, 177 insertions(+), 62 deletions(-)

-- 
1.8.5.2.192.g7794a68
