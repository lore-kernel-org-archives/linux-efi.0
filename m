From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix
Date: Sat, 3 May 2014 06:51:34 +0100
Message-ID: <20140503055134.GV26088@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following patch from Dave that fixes some bugs in
the EFI earlyprintk code when using ",keep".

The following changes since commit 47514c996fac5e6f13ef3a4c5e23f1c5cffabb7b:

  efi: Pass correct file handle to efi_file_{read,close} (2014-04-10 21:20:03 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 5f35eb0e29ca26da82febe49d7698dbeb8882ea0:

  x86/efi: earlyprintk=efi,keep fix (2014-05-03 06:39:06 +0100)

----------------------------------------------------------------
 * Fix earlyprintk=efi,keep support by switching to an ioremap() mapping
   of the framebuffer when early_ioremap() is no longer available and
   dropping __init from functions that may be invoked after
   free_initmem() - Dave Young

----------------------------------------------------------------
Dave Young (1):
      x86/efi: earlyprintk=efi,keep fix

 arch/x86/platform/efi/early_printk.c | 83 +++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 19 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
