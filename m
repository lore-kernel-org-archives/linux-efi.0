From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fixes
Date: Fri, 7 Jun 2013 12:50:46 +0100
Message-ID: <20130607115046.GN30420@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi folks,

The following changes since commit eccaf52fee8305d5207ff110950a82c100e459bc:

  x86, efi: initial the local variable of DataSize to zero (2013-05-14 08:13:05 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to d70005bfc5f47f74fb5cb77a84983ed26bf65557:

  efi: Convert runtime services function ptrs (2013-06-06 11:07:07 +0100)

----------------------------------------------------------------
 * More tweaking to the EFI variable anti-bricking algorithm. Quite a
   few users were reporting boot regressions in v3.9. This has now been
   fixed with a more accurate "minimum storage requirement to avoid
   bricking" value from Samsung (5K instead of 50%) and code to trigger
   garbage collection when we near our limit - Matthew Garrett.

 * A small cleanup to get rid of all the void * casting that is
   prevalent in the EFI code - Borislav Petkov

----------------------------------------------------------------
Borislav Petkov (1):
      efi: Convert runtime services function ptrs

Matthew Garrett (1):
      Modify UEFI anti-bricking code

 arch/x86/boot/compressed/eboot.c      |  47 ---------
 arch/x86/include/asm/efi.h            |  35 +++----
 arch/x86/include/uapi/asm/bootparam.h |   1 -
 arch/x86/platform/efi/efi.c           | 188 ++++++++++++----------------------
 include/linux/efi.h                   |  28 ++---
 5 files changed, 93 insertions(+), 206 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
