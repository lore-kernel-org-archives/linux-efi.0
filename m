From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI changes
Date: Tue, 29 Oct 2013 08:18:43 +0000
Message-ID: <20131029081843.GQ1982@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

I dropped the cleanup patch which was causing build issues for ARM.

The following changes since commit c158c3bf59951bbb44bd7ccca9e6665dfd1617c5:

  boot, efi: Remove redundant memset() (2013-10-04 20:07:47 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 72548e836b0c4abbb652e791dee9c91203a9a4c6:

  x86/efi: Add EFI framebuffer earlyprintk support (2013-10-28 18:09:58 +0000)

----------------------------------------------------------------
 * Add support for earlyprintk=efi which uses the EFI framebuffer. Very
   useful for debugging boot issues.

----------------------------------------------------------------
Matt Fleming (1):
      x86/efi: Add EFI framebuffer earlyprintk support

 Documentation/kernel-parameters.txt  |   8 +-
 arch/x86/Kconfig.debug               |  10 ++
 arch/x86/include/asm/efi.h           |   2 +
 arch/x86/kernel/early_printk.c       |   7 ++
 arch/x86/platform/efi/Makefile       |   1 +
 arch/x86/platform/efi/early_printk.c | 191 +++++++++++++++++++++++++++++++++++
 6 files changed, 216 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/platform/efi/early_printk.c

-- 
Matt Fleming, Intel Open Source Technology Center
