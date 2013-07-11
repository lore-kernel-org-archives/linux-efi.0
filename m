From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fixes
Date: Thu, 11 Jul 2013 12:16:18 +0100
Message-ID: <20130711111618.GP12287@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The following changes since commit 6d128e1e72bf082542e85f72e6b7ddd704193588:

  Revert "Makefile: Fix install error with make -j option" (2013-07-10 19:02:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 8216a67eb5e92224b4509b7f55ec4891c9021fdb:

  Revert "UEFI: Don't pass boot services regions to SetVirtualAddressMap()" (2013-07-11 11:00:32 +0100)

----------------------------------------------------------------
 * Revert Matthew Garrett's patch that avoids passing EFI Boot Services
   regions to SetVirtualAddressMap(). It caused boot regressions.

 * Fix a crash in the efivars code by checking whether that EFI Runtime
   Services are available before attempting to use them.

----------------------------------------------------------------
Matt Fleming (2):
      efivars: check for EFI_RUNTIME_SERVICES
      Revert "UEFI: Don't pass boot services regions to SetVirtualAddressMap()"

 arch/x86/platform/efi/efi.c    | 7 -------
 drivers/firmware/efi/efivars.c | 3 +++
 2 files changed, 3 insertions(+), 7 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
