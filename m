From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix
Date: Wed, 6 Aug 2014 10:46:51 +0100
Message-ID: <20140806094651.GU15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following fix. It's something that Peter and I
talked about a while ago, and it seems that people are actually hitting
issues without this patch and have been since v3.13.

The following changes since commit c7fb93ec51d462ec3540a729ba446663c26a0505:

  x86/efi: Include a .bss section within the PE/COFF headers (2014-07-10 14:21:39 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 7b2a583afb4ab894f78bc0f8bd136e96b6499a7e:

  x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub (2014-08-05 22:01:04 +0100)

----------------------------------------------------------------
 * Enforce CONFIG_RELOCATABLE for the x86 EFI boot stub, otherwise
   it's possible to overwrite random pieces of unallocated memory during
   kernel decompression, leading to machine resets.

----------------------------------------------------------------
Matt Fleming (1):
      x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub

 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

-- 
Matt Fleming, Intel Open Source Technology Center
