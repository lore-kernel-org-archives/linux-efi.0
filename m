From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] Urgent fix
Date: Fri, 7 Feb 2014 15:42:53 +0000
Message-ID: <20140207154253.GA2887@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Folks,

Please pull the following which fixes an issue people are hitting on
Baytrail platforms.

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 081cd62a010f97b5bc1d2b0cd123c5abc692b68a:

  x86/efi: Allow mapping BGRT on x86-32 (2014-02-05 23:39:34 +0000)

----------------------------------------------------------------
 * Avoid WARN_ON() when mapping BGRT on Baytrail (EFI 32-bit).

----------------------------------------------------------------
Matt Fleming (1):
      x86/efi: Allow mapping BGRT on x86-32

 arch/x86/platform/efi/efi-bgrt.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
