From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL 00/13] EFI changes for v4.6 part 2
Date: Wed, 17 Feb 2016 12:35:53 +0000
Message-ID: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Folks, here are the remaining EFI changes for v4.6.

Two of the patches were sent in the previous v4.6 pull request on 1st
February. Those include running EFI runtime services with interrupts
enabled (just like Windows does) and aligning the EFI GUID formats in
include/linux/efi.h to match the way they're written in the UEFI spec.
They've both been reworked to address comments.

The rest of the changes are all over the tree, and range from simple
fixes and cleanups to support for EFI_PROPERTIES_TABLE on x86.

The following changes since commit 35575e0e8ba633fc8276509a21f89b599b4f9006:

  efi: Add Persistent Memory type name (2016-02-03 11:41:20 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 83a901db98e790e5682b85b8ee85f9e545d84e27:

  x86/efi: Only map kernel text for EFI mixed mode (2016-02-15 11:37:02 +0000)

----------------------------------------------------------------
 * checkpatch.pl cleanup of the GUIDs in efi.h which has the added
   benefit of making them more closely resemble how they're presented
   in the UEFI specification - Peter Jones

 * Now that we've verified that Windows works this way, leave
   interrupts enabled when invoking EFI runtime services which
   also reduces interrupt latencies - Ard Biesheuvel

 * Reduce page table attribute inconsistencies between the EFI page
   tables and the standard kernel page tables by ensuring we also set
   _PAGE_GLOBAL in the EFI-specific paths - Sai Praneeth Prakhya

 * A bunch of small fixes to the generic EFI stub and some early boot
   platform compatibility checks for ARM and arm64 - Ard Biesheuvel

 * Add support for EFI_PROPERTIES_TABLE to x86, allowing us to apply
   more secure memory mapping permissions for firmware that ships with
   the feature enabled - Sai Praneeth Prakhya

 * Fix an EFI mixed mode bug where we intend to only map the kernel
   image's text but end up mapping the entire image - Sai Praneeth Prakhya

----------------------------------------------------------------
Ard Biesheuvel (8):
      efi/runtime-wrappers: Run UEFI Runtime Services with interrupts enabled
      efi/arm64: Drop __init annotation from handle_kernel_image()
      arm64: vmlinux.lds.S: Handle .init.rodata.xxx and .init.bss sections
      efi/efistub: Prevent __init annotations from being used
      efi/arm-init: Use read-only early mappings
      efi/arm: Check for LPAE support before booting a LPAE kernel
      efi/arm64: Check for h/w support before booting a >4 KB granule kernel
      efi/arm*: Perform hardware compatibility check

Peter Jones (1):
      efi: Reformat GUID tables to follow the format in UEFI spec

Sai Praneeth (4):
      x86/mm/pageattr: Use _PAGE_GLOBAL bit for EFI page table mappings
      x86/mm/pageattr: Don't implicitly allow _PAGE_RW in kernel_map_pages_in_pgd()
      x86/efi: Map EFI_MEMORY_{XP,RO} memory region bits to EFI page tables
      x86/efi: Only map kernel text for EFI mixed mode

 arch/arm64/kernel/vmlinux.lds.S           |  1 +
 arch/x86/include/asm/efi.h                |  2 +-
 arch/x86/mm/pageattr.c                    | 17 ++++++++
 arch/x86/platform/efi/efi.c               |  9 +++-
 arch/x86/platform/efi/efi_32.c            |  2 +-
 arch/x86/platform/efi/efi_64.c            | 55 ++++++++++++++++++++----
 drivers/firmware/efi/arm-init.c           | 14 +++---
 drivers/firmware/efi/libstub/arm-stub.c   |  4 ++
 drivers/firmware/efi/libstub/arm32-stub.c | 17 ++++++++
 drivers/firmware/efi/libstub/arm64-stub.c | 34 ++++++++++++---
 drivers/firmware/efi/libstub/efistub.h    | 12 ++++++
 drivers/firmware/efi/runtime-wrappers.c   | 71 ++++++++++++-------------------
 include/linux/efi.h                       | 63 ++++++++++++++++++---------
 13 files changed, 210 insertions(+), 91 deletions(-)
