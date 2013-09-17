From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V4 00/17] ARM EFI stub common code
Date: Mon, 16 Sep 2013 21:11:16 -0700
Message-ID: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patch is the common/x86 portion of the ARM EFI stub
patchset broken out.  These changes support the addition
of EFI stub support for the ARM and ARM64 architectures.
The common code that is now shared in efi-stub-helper.c
is based on code in the x86 stub that has been generalized
to support other architectures.



(Previously these changes were submitted as part of
the "EFI stub for ARM" patch series that included the
common/x86 changes as well as the ARM changes.)
Changes since V3:
* Made relocate_kernel() a shared function.
* Made command line unicode to ASCII conversion ASCII
  a shared function
* Updated efi_get_memory_map() to return descriptor version,
  and updated x86 stub to use it to retrieve final memory map.
* removed min_address argument of efi_low_alloc(), as it is
  no longer used.
* Squashed very tiny patch moving EFI_READ_CHUNK_SIZE into
  related patch.


Changes since v2:
* EFI bugfix "correct call to free_pages" that patch series
  depends on now in mainline
* remove unnecessary zimage_size variable from relocate_kernel()
* correct return types on EFI functions - should be efi_status_t, not int.

Changes since V1:
* Broke up changes to x86 and common code into more patches.
  10 more patches in this series.


Roy Franz (17):
  EFI stub documentation updates
  Add proper definitions for some EFI function pointers.
  Move common EFI stub code from x86 arch code to common location
  Add system table pointer argument to shared functions.
  Rename memory allocation/free functions
  Enforce minimum alignment of 1 page on allocations.
  Move relocate_kernel() to shared file.
  Generalize relocate_kernel() for use by other architectures.
  Move unicode to ASCII conversion to shared function.
  Rename __get_map() to efi_get_memory_map()
  generalize efi_get_memory_map()
  use efi_get_memory_map() to get final map for x86
  Allow efi_free() to be called with size of 0, and do nothing in that
    case.
  Generalize handle_ramdisks() and rename to handle_cmdline_files().
  Renames in handle_cmdline_files() to complete generalization.
  Fix types in EFI calls to match EFI function definitions.
  resolve warnings found on ARM compile

 Documentation/efi-stub.txt             |   65 ++++
 Documentation/x86/efi-stub.txt         |   65 ----
 arch/x86/Kconfig                       |    2 +-
 arch/x86/boot/compressed/eboot.c       |  582 ++---------------------------
 arch/x86/boot/compressed/eboot.h       |    9 -
 drivers/firmware/efi/efi-stub-helper.c |  627 ++++++++++++++++++++++++++++++++
 include/linux/efi.h                    |   50 ++-
 7 files changed, 767 insertions(+), 633 deletions(-)
 create mode 100644 Documentation/efi-stub.txt
 delete mode 100644 Documentation/x86/efi-stub.txt
 create mode 100644 drivers/firmware/efi/efi-stub-helper.c

-- 
1.7.10.4
