From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 0/2] xen/efi: Fixes
Date: Tue, 20 Jun 2017 22:14:26 +0200
Message-ID: <1497989668-6238-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
List-Id: linux-efi@vger.kernel.org

Hey,

Two small fixes for Xen dom0 running on x86_64 EFI platforms.

I am CC-ing stable maintainers because similar stuff is needed for various
stable kernels too. Unfortunately, almost every version needs a bit different
set of fixes. So, please treat this email more as head up than real set of
patches for your kernel. If you wish to get Xen EFI stuff fixed just drop me
a line. Then I will prepare set of patches for your kernel (if needed).

Daniel

 arch/x86/xen/efi.c         |   45 ++++++++++++---------------------------------
 drivers/firmware/efi/efi.c |    3 ++-
 2 files changed, 14 insertions(+), 34 deletions(-)

Daniel Kiper (2):
      efi: Process MEMATTR table only if EFI_MEMMAP
      x86/xen/efi: Init only efi struct members used by Xen
