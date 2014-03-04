From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix
Date: Tue, 4 Mar 2014 23:47:47 +0000
Message-ID: <20140304234747.GD17362@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Please pull the following fix from Borislav that fixes a boot regression
for SGI UV.

The following changes since commit 09503379dc99535b1bbfa51aa1aeef340f5d82ec:

  x86/efi: Check status field to validate BGRT header (2014-02-14 10:07:15 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to a5d90c923bcfb9632d998ed06e9569216ad695f3:

  x86/efi: Quirk out SGI UV (2014-03-04 23:43:33 +0000)

----------------------------------------------------------------
 * Disable the new EFI 1:1 virtual mapping for SGI UV because using it
   causes a crash during boot - Borislav Petkov

----------------------------------------------------------------
Borislav Petkov (1):
      x86/efi: Quirk out SGI UV

 arch/x86/include/asm/efi.h  |  1 +
 arch/x86/kernel/setup.c     | 10 ++--------
 arch/x86/platform/efi/efi.c | 20 ++++++++++++++++++++
 3 files changed, 23 insertions(+), 8 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
