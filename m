From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fixes
Date: Mon, 10 Jun 2013 22:36:32 +0100
Message-ID: <20130610213632.GF31198@console-pimps.org>
References: <20130607115046.GN30420@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130607115046.GN30420-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi folks,
 
The following changes since commit eccaf52fee8305d5207ff110950a82c100e459bc:

  x86, efi: initial the local variable of DataSize to zero (2013-05-14 08:13:05 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to f8b8404337de4e2466e2e1139ea68b1f8295974f:

  Modify UEFI anti-bricking code (2013-06-10 21:59:37 +0100)

----------------------------------------------------------------
 * More tweaking to the EFI variable anti-bricking algorithm. Quite a
   few users were reporting boot regressions in v3.9. This has now been
   fixed with a more accurate "minimum storage requirement to avoid
   bricking" value from Samsung (5K instead of 50%) and code to trigger
   garbage collection when we near our limit - Matthew Garrett.

----------------------------------------------------------------
Matthew Garrett (1):
      Modify UEFI anti-bricking code

 arch/x86/boot/compressed/eboot.c      |  47 ---------
 arch/x86/include/asm/efi.h            |   7 --
 arch/x86/include/uapi/asm/bootparam.h |   1 -
 arch/x86/platform/efi/efi.c           | 188 ++++++++++++----------------------
 4 files changed, 65 insertions(+), 178 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
