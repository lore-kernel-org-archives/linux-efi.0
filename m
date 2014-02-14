From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fixes
Date: Fri, 14 Feb 2014 13:08:53 +0000
Message-ID: <20140214130853.GI20717@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

There have been reports of EFI crashes since -rc1. The following two
commits fix known issues.

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 09503379dc99535b1bbfa51aa1aeef340f5d82ec:

  x86/efi: Check status field to validate BGRT header (2014-02-14 10:07:15 +0000)

----------------------------------------------------------------
 * Fix boot failure on 32-bit EFI due to the recent EFI memmap changes
   merged during the merge window - Borislav Petkov

 * Avoid a crash during efi_bgrt_init() by detecting invalid BGRT
   headers based on the 'status' field.

----------------------------------------------------------------
Borislav Petkov (1):
      x86/efi: Fix 32-bit fallout

Matt Fleming (1):
      x86/efi: Check status field to validate BGRT header

 arch/x86/include/asm/efi.h       | 2 ++
 arch/x86/platform/efi/efi-bgrt.c | 2 +-
 arch/x86/platform/efi/efi.c      | 5 ++---
 arch/x86/platform/efi/efi_32.c   | 6 ++++++
 arch/x86/platform/efi/efi_64.c   | 9 +++++++++
 5 files changed, 20 insertions(+), 4 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
