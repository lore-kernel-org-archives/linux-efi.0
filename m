From: Juergen Gross <jgross@suse.com>
Subject: [PATCH 0/4] x86: use correct early_[mem,io][re,un]map pairs
Date: Tue, 24 Feb 2015 10:13:27 +0100
Message-ID: <1424769211-11378-1-git-send-email-jgross@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, linux-efi@vger.kernel.org, matt.fleming@intel.com
Cc: Juergen Gross <jgross@suse.com>
List-Id: linux-efi@vger.kernel.org

Areas mapped via early_memremap() should be unmapped via
early_memunmap(), while I/O-areas should be mapped via early_ioremap()
and unmapped via early_iounmap().

There are multiple spots where an area is mapped via the mem variant
and unmapped via the io variant. This series corrects this by using
the appropriate variants.

Juergen Gross (4):
  x86: use early_memunmap in arch/x86/kernel/devicetree.c
  x86: use early_memunmap in arch/x86/kernel/e820.c
  x86: use early_memunmap in arch/x86/kernel/setup.c
  x86, efi: use early_ioremap in arch/x86/platform/efi/efi-bgrt.c

 arch/x86/kernel/devicetree.c     | 4 ++--
 arch/x86/kernel/e820.c           | 2 +-
 arch/x86/kernel/setup.c          | 8 ++++----
 arch/x86/platform/efi/efi-bgrt.c | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.1.4
