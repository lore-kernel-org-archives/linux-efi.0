From: Borislav Petkov <bp@alien8.de>
Subject: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Mon, 17 Jun 2013 19:50:12 +0200
Message-ID: <1371491416-11037-1-git-send-email-bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>, Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi all,

this is just a snapshot of the current state of affairs. The patchset
starts to boot successfully on real hardware now but we're far away from
the coverage we'd like to have before we even consider upstreaming it.

And yes, considering the sick f*ck EFI is, we're keeping the 1:1 mapping
optional and off by default (you need to boot with "efi=1:1_map" to
enable it).

Matt has picked up 1/4 already so I'll drop it when it lands into -tip
and so on...

Thanks for any suggestions, as always.

Borislav Petkov (4):
  efi: Convert runtime services function ptrs
  x86, cpa: Map in an arbitrary pgd
  x86, efi: Add an efi= kernel command line parameter
  x86, efi: Map runtime services 1:1

 arch/x86/boot/compressed/eboot.c     |   2 +-
 arch/x86/include/asm/efi.h           |  81 ++++++++++-----
 arch/x86/include/asm/pgtable_types.h |   3 +-
 arch/x86/mm/pageattr.c               |  82 ++++++++++++----
 arch/x86/platform/efi/efi.c          | 184 +++++++++++++++++++++++++++++------
 arch/x86/platform/efi/efi_stub_64.S  |  56 +++++++++++
 include/linux/efi.h                  |  28 +++---
 7 files changed, 348 insertions(+), 88 deletions(-)

-- 
1.8.3
