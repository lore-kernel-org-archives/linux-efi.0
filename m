From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL 0/2] EFI urgent fixes
Date: Thu, 11 Aug 2016 11:41:58 +0100
Message-ID: <1470912120-22831-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Austin Christ <austinwc-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Please pull the following two patches that fix EFI issues in v4.7.
They're both tagged for stable.

The following changes since commit 29b4817d4018df78086157ea3a55c1d9424a7cfc:

  Linux 4.8-rc1 (2016-08-07 18:18:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to be6743b7f66c7d8bf7f8a48de9d86a66a177c3a2:

  efi/capsule: Allocate whole capsule into virtual memory (2016-08-09 11:32:55 +0100)

----------------------------------------------------------------
 * Fix a boot crash on SGI/UV when kexec'ing a kernel with the "noefi"
   kernel parameter - Alex Thorlton

 * Wholly map EFI capsules with vmap() instead of just the first page
   with kmap(), so that the capsule driver works on Qualcomm QDF2432,
   and because the UEFI specification requires the capsule to be fully
   mapped into the kernel's virtual address space - Austin Christ

----------------------------------------------------------------
Alex Thorlton (1):
      x86/platform/uv: Skip UV runtime services mapping in the efi_runtime_disabled case

Austin Christ (1):
      efi/capsule: Allocate whole capsule into virtual memory

 arch/x86/platform/uv/bios_uv.c        | 3 ++-
 drivers/firmware/efi/capsule-loader.c | 8 +++++---
 drivers/firmware/efi/capsule.c        | 6 +++---
 3 files changed, 10 insertions(+), 7 deletions(-)
