From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI changes for v3.16
Date: Sat, 19 Apr 2014 11:06:53 +0100
Message-ID: <20140419100653.GA26088@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi folks,

Please pull the following changes for v3.16. I'd like to get these in
early so that they've got plenty of time to bake in linux-next. In
particular, the ARM folks have had a hard time getting the generic EFI
cleanups/improvements picked up via other trees.

Obviously by taking these through tip we're creating a dependency with
whatever tree the ARM patches live in. Do we need to inform Stephen
Rothwell explicitly of this dependency? How should we handle things when
the v3.16 merge window opens?

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to e33655a386ed3b26ad36fb97a47ebb1c2ca1e928:

  efivars: Add compatibility code for compat tasks (2014-04-17 13:53:53 +0100)

----------------------------------------------------------------
 * Generic EFI cleanups to help with the pending ARM/ARM64 EFI boot stub
   by reducing code duplication - Roy Franz, Leif Lindholm, Mark Salter

 * Swap to a single efi_call* implementation to reduce code duplication

 * Perform full FPU context saving/restoring where needed before making
   calls into the firmware - Ricardo Neri

 * efivars compat support to allow 32-bit userland to access the EFI
   variables via the sysfs efivars interface when running with a 64-bit
   kernel

----------------------------------------------------------------
H. Peter Anvin (1):
      efi: x86: Handle arbitrary Unicode characters

Leif Lindholm (1):
      efi: efi-stub-helper cleanup

Mark Salter (1):
      efi: create memory map iteration helper

Matt Fleming (7):
      x86/efi: Delete most of the efi_call* macros
      x86, fpu: Extend the use of static_cpu_has_safe
      efivars: Use local variables instead of a pointer dereference
      efivars: Check size of user object
      efivars: Stop passing a struct argument to efivar_validate()
      efivars: Refactor sanity checking code into separate function
      efivars: Add compatibility code for compat tasks

Ricardo Neri (3):
      x86/efi: Implement a __efi_call_virt macro
      x86/efi: Save and restore FPU context around efi_calls (x86_64)
      x86/efi: Save and restore FPU context around efi_calls (i386)

Roy Franz (2):
      efi: Add shared printk wrapper for consistent prefixing
      efi: Add get_dram_base() helper function

 arch/x86/boot/compressed/eboot.c       |   3 +-
 arch/x86/boot/compressed/head_64.S     |   2 +-
 arch/x86/include/asm/efi.h             | 100 ++++++-----------
 arch/x86/include/asm/fpu-internal.h    |  10 +-
 arch/x86/platform/efi/efi.c            |  48 ++++-----
 arch/x86/platform/efi/efi_stub_64.S    |  81 +-------------
 arch/x86/platform/uv/bios_uv.c         |   2 +-
 drivers/firmware/efi/efi-stub-helper.c | 144 ++++++++++++++++++-------
 drivers/firmware/efi/efivars.c         | 192 +++++++++++++++++++++++++++------
 drivers/firmware/efi/vars.c            |  30 +++---
 include/linux/efi.h                    |  12 ++-
 11 files changed, 361 insertions(+), 263 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
