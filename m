From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI changes
Date: Sun, 27 Oct 2013 21:48:15 +0000
Message-ID: <20131027214815.GH1982@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Guys, do you think we could get the EFI earlyprintk support into the
'x86/efi' branch for the upcoming merge window? I know it's quite late
in the game but since it's a new feature it shouldn't introduce any kind
of regression and is a much needed feature.

The following changes since commit c158c3bf59951bbb44bd7ccca9e6665dfd1617c5:

  boot, efi: Remove redundant memset() (2013-10-04 20:07:47 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 32c9e70fc3912c3b9c7d53ce016960ce99ff93d4:

  x86/efi: Add EFI framebuffer earlyprintk support (2013-10-27 21:18:48 +0000)

----------------------------------------------------------------
 * Add support for earlyprintk=efi which uses the EFI framebuffer. Very
   useful for debugging boot issues.

----------------------------------------------------------------
Matt Fleming (2):
      efi: Add asm-generic/efi.h for non-x86
      x86/efi: Add EFI framebuffer earlyprintk support

 Documentation/kernel-parameters.txt  |   8 +-
 arch/ia64/include/asm/efi.h          |   6 ++
 arch/x86/Kconfig.debug               |   9 ++
 arch/x86/boot/compressed/eboot.c     |   1 -
 arch/x86/include/asm/efi.h           |  12 +++
 arch/x86/kernel/early_printk.c       |   6 ++
 arch/x86/kernel/setup.c              |   1 -
 arch/x86/platform/efi/Makefile       |   1 +
 arch/x86/platform/efi/early_printk.c | 191 +++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi.c          |   1 -
 arch/x86/platform/efi/efi_32.c       |   1 -
 arch/x86/platform/efi/efi_64.c       |   1 -
 arch/x86/platform/uv/bios_uv.c       |   1 -
 include/asm-generic/efi.h            |  17 ++++
 include/linux/efi.h                  |  31 +-----
 15 files changed, 249 insertions(+), 38 deletions(-)
 create mode 100644 arch/ia64/include/asm/efi.h
 create mode 100644 arch/x86/platform/efi/early_printk.c
 create mode 100644 include/asm-generic/efi.h

-- 
Matt Fleming, Intel Open Source Technology Center
