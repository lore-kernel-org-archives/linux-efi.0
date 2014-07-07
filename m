From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix
Date: Mon, 7 Jul 2014 07:43:34 +0100
Message-ID: <20140707064334.GA2914@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Guys, please pull the following fix from Ard that stops the arm64 EFI
stub being rebuilt on every arm64 kernel build by removing the
dependency on the generated header files.

The following changes since commit 783ee43118dc773bc8b0342c5b230e017d5a04d0:

  efi-pstore: Fix an overflow on 32-bit builds (2014-06-27 07:30:32 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to a55c072dfe520f8fa03cf11b07b9268a8a17820a:

  efi/arm64: efistub: remove local copy of linux_banner (2014-07-07 07:26:02 +0100)

----------------------------------------------------------------
 * Remove a duplicate copy of linux_banner from the arm64 EFI stub
   which, apart from reducing code duplication also stops the arm64 stub
   being rebuilt every time make is invoked - Ard Biesheuvel

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/arm64: efistub: remove local copy of linux_banner

 arch/arm64/kernel/efi-stub.c |  2 --
 drivers/firmware/efi/fdt.c   | 10 ----------
 2 files changed, 12 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
