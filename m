From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix
Date: Fri, 26 Apr 2013 17:30:22 +0100
Message-ID: <20130426163022.GC23038@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Peter, Linus,

I've got a small patch that fixes a crash for the Google folks and their
EFI SMI driver, which was caused by dereferencing a garbage pointer.

Please consider pulling.

The following changes since commit f697036b93aa7345d4cbb3c854a76456c0ddac45:

  efi: Check EFI revision in setup_efi_vars (2013-04-24 16:19:01 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 45432323ef7038a91599959173700fdb8a0adb2f:

  efivars: only check for duplicates on the registered list (2013-04-26 16:50:01 +0100)

----------------------------------------------------------------
 * Last minute bugfix for the efivars code. The google EFI SMI driver
   maintains its own list of EFI variables but the efivars core was
   directly accessing a different (and in this case, uninitialised) list
   resulting in a crash.

----------------------------------------------------------------
Matt Fleming (1):
      efivars: only check for duplicates on the registered list

 drivers/firmware/efivars.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
