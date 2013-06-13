From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI changes for v3.11
Date: Thu, 13 Jun 2013 14:46:46 +0100
Message-ID: <20130613134646.GU31198@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to d3768d885c6ccbf8a137276843177d76c49033a7:

  x86, efi: retry ExitBootServices() on failure (2013-06-11 07:51:54 +0100)

----------------------------------------------------------------
 * Only pass memory regions that are marked as required for runtime to
   SetVirtualAddressMap() - Matthew Garrett

 * A small cleanup to get rid of all the void * casting that is
   prevalent in the EFI code - Borislav Petkov

 * Handle the case where ExitBootServices() wants us to call it a second
   time because some of the firmware signal handlers have changed the
   memory map - Zach Bobroff

----------------------------------------------------------------
Borislav Petkov (1):
      efi: Convert runtime services function ptrs

Matthew Garrett (1):
      UEFI: Don't pass boot services regions to SetVirtualAddressMap()

Zach Bobroff (1):
      x86, efi: retry ExitBootServices() on failure

 arch/x86/boot/compressed/eboot.c | 20 +++++++++++++++++---
 arch/x86/include/asm/efi.h       | 28 ++++++++++++++--------------
 arch/x86/platform/efi/efi.c      |  7 +++++++
 include/linux/efi.h              | 28 ++++++++++++++--------------
 4 files changed, 52 insertions(+), 31 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
