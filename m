From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 0/5] EFI memmap and other fixes, v3
Date: Sat, 18 Jan 2014 12:48:13 +0100
Message-ID: <1390045698-16882-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Hi all,

this is the latest incarnation which should hopefully work just fine. It
tpasses esting at least on all our boxes so we have *some* coverage.

It took us a long time to debug the unmapping path and realize how
exactly we're doing the PGD sharing between the kernel and the EFI page
table. I've commented on this verbosely in 4/5 for future reference
because this stuff is not trivial.

We definitely should have this in mind when we do more changes on how we
handle the EFI page table and what we do with it, maybe even decouple it
completely from the kernel one. I dunno - it is all future stuff to pay
attention to.

Anyway, if anyone with an EFI box wants to give it a run, feel free to
do so.

As always, all comments and suggestions are appreciated.

Thanks.

Changelog:

* v2:

here's v2 rebased and rediffed against tip (which has the relevant
efi branches).

* v1:

this is the result of Toshi and me debugging a #GP on one of his big HP
boxes sporting UEFI. Each commit message should be self-explanatory so
please look there.

This has more or less an RFC nature thus I'm sending it now to collect
feedback. It is going to wait in the EFI queue anyway after the kexec
stuff gets sorted out first.

Borislav Petkov (5):
  x86, ptdump: Add the functionality to dump an arbitrary pagetable
  efi: Dump the EFI page table
  x86, pageattr: Export page unmapping interface
  efi: Make efi virtual runtime map passing more robust
  efi: Split efi_enter_virtual_mode

 arch/x86/Kconfig                     |   9 ++
 arch/x86/include/asm/efi.h           |   4 +-
 arch/x86/include/asm/pgtable.h       |   3 +-
 arch/x86/include/asm/pgtable_types.h |   2 +
 arch/x86/mm/dump_pagetables.c        |  84 +++++++++-----
 arch/x86/mm/pageattr.c               |  44 +++++---
 arch/x86/platform/efi/efi.c          | 210 ++++++++++++++++++++++++++---------
 arch/x86/platform/efi/efi_32.c       |   7 +-
 arch/x86/platform/efi/efi_64.c       |  41 ++++++-
 include/linux/efi.h                  |   1 +
 10 files changed, 304 insertions(+), 101 deletions(-)

-- 
1.8.5.2.192.g7794a68
