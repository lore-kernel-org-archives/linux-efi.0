From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 0/4] EFI 1:1 mapping
Date: Sun,  2 Jun 2013 14:56:06 +0200
Message-ID: <1370177770-26661-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Hi all,

this one is 64-bit only for now and it has been tested only in kvm with
OVMF.

Keeping in mind the ihnerent efi b0rkedness left and right, I'd like to
be very cautious and conservative with this and not hurry anything until
it has been actually very well tested on a variety of baremetal boxes.

Please take a closer look and let me know.

Thanks.

Borislav Petkov (4):
  efi: Convert runtime services function ptrs
  x86, cpa: Map in an arbitrary pgd
  x86, efi: Add an efi= kernel command line parameter
  x86, efi: Map runtime services 1:1

 arch/x86/boot/compressed/eboot.c     |   2 +-
 arch/x86/include/asm/efi.h           |  30 +++---
 arch/x86/include/asm/pgtable_types.h |   3 +-
 arch/x86/mm/pageattr.c               |  80 ++++++++++++----
 arch/x86/platform/efi/efi.c          | 177 +++++++++++++++++++++++++++++------
 arch/x86/platform/efi/efi_stub_64.S  |  48 ++++++++++
 include/linux/efi.h                  |  28 +++---
 7 files changed, 290 insertions(+), 78 deletions(-)

-- 
1.8.3.rc1.25.g423ecb0
