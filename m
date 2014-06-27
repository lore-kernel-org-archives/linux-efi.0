From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fixes
Date: Fri, 27 Jun 2014 15:51:46 +0100
Message-ID: <20140627145146.GB7539@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Guys,

Please pull the following EFI fixes. The fix from Catalin is the same as
the one I sent a week ago and Andrzej's patch fixes an efi-pstore issue
on 32-bit machines where efi-pstore variables don't appear in the
filesystem and so can never be deleted, potentially leading to
exhaustion of NVRAM space.

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 783ee43118dc773bc8b0342c5b230e017d5a04d0:

  efi-pstore: Fix an overflow on 32-bit builds (2014-06-27 07:30:32 +0100)

----------------------------------------------------------------
 * Fix a few compiler warnings (one being a real bug) in the arm64 EFI
   code that lots of people are running into and reporting - Catalin Marinas

 * Use a cast to avoid a 32-bit overflow issue when generating pstore
   filenames - Andrzej Zaborowski

----------------------------------------------------------------
Andrzej Zaborowski (1):
      efi-pstore: Fix an overflow on 32-bit builds

Catalin Marinas (1):
      efi: Fix compiler warnings (unused, const, type)

 drivers/firmware/efi/efi-pstore.c | 2 +-
 drivers/firmware/efi/efi.c        | 6 +++---
 drivers/firmware/efi/fdt.c        | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
