From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL 0/2] EFI urgent fixes
Date: Fri, 25 Sep 2015 23:02:17 +0100
Message-ID: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Folks,

The patches in this pull request fix kernel crashes when booting Linux
on UEFI v2.5 machines with the Properties Table feature enabled.

Essentially, when this feature is enabled the firmware allocates
separate entries in the EFI memory map for the code and data sections
of PE/COFF images, whereas previously only one memory map entry would
have existed.

Because we've now got two entries that reference each other we *must*
map them into the kernel virtual address space with the same offsets
and in the same order as they appear in the EFI memory map. Failure to
do so causes the firmware to access unmapped/invalid addresses. 

These patches were intentionally kept as small as possible so that
they can be backported by distributions, aggressively.

The following changes since commit 1f93e4a96c9109378204c147b3eec0d0e8100fde:

  Linux 4.3-rc2 (2015-09-20 14:32:34 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 1fa25e09ca2ce07f03bca93ad71800c312fd4951:

  arm64/efi: Don't pad between EFI_MEMORY_RUNTIME regions (2015-09-25 22:35:15 +0100)

----------------------------------------------------------------
 * arm64 bug fix for UEFI 2.5 firmware that has the Properties Table
   feature enabled. The fix avoids a kernel crash by removing the padding
   between runtime regions that we currently do in the kernel so we don't
   break the EFI's cross-region references - Ard Biesheuvel

 * Map EFI memory regions in-order on x86 so that we maintain the
   relative offset between regions and fix a crash when booting on
   UEFI 2.5 machines with the Properties Table feature enabled.

----------------------------------------------------------------
Ard Biesheuvel (1):
      arm64/efi: Don't pad between EFI_MEMORY_RUNTIME regions

Matt Fleming (1):
      x86/efi: Map EFI memmap entries in-order at runtime

 arch/arm64/kernel/efi.c                 |  3 +-
 arch/x86/platform/efi/efi.c             | 67 ++++++++++++++++++++++++-
 drivers/firmware/efi/libstub/arm-stub.c | 88 +++++++++++++++++++++++++++------
 3 files changed, 141 insertions(+), 17 deletions(-)
