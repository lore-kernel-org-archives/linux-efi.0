From: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: [PATCH 0/4] x86/efi: Minor cleanup patches
Date: Sun,  7 Sep 2014 19:42:13 +0200
Message-ID: <1410111737-5220-1-git-send-email-minipli@googlemail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

this series is a collection of rather random cleanup patches. The init code
patch, though, should result in a lower runtime memory usage as more memory
can be released after initialization, now.

Please apply!


Mathias Krause (4):
  x86/efi: Remove unused efi_call* macros
  x86/efi: Unexport add_efi_memmap variable
  x86/efi: Update comment regarding required phys mapped EFI services
  x86/efi: Mark initialization code as such

 arch/x86/include/asm/efi.h          |   31 +++++++++------------------
 arch/x86/platform/efi/efi.c         |   20 ++++++++---------
 arch/x86/platform/efi/efi_32.c      |   12 ++++++-----
 arch/x86/platform/efi/efi_64.c      |    6 +++---
 arch/x86/platform/efi/efi_stub_32.S |    4 ++--
 5 files changed, 31 insertions(+), 42 deletions(-)

-- 
1.7.10.4
