From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL v4 0/6] EFI page table isolation
Date: Fri, 27 Nov 2015 21:09:29 +0000
Message-ID: <1448658575-17029-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Dave Jones <davej@codemonkey.org.uk>, Denys Vlasenko <dvlasenk@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-efi@vger.kernel.org

Folks,

This patch series is a response to the report that the EFI region
mappings trigger warnings when booting with CONFIG_DEBUG_WX enabled.
They allocate a new page table structure and ensure that all the
mappings we require during EFI runtime calls are only setup there.

It turns out that it still makes sense to share some page table
entries with 'swapper_pg_dir', just not the entries where we need to
allow security lax permissions. Sharing entries is useful for memory
hotplug, for example.

When writing this series I discovered a number of bugs in the existing
code that only became apparent when we stopped using 'trampoline_pgd'
which already mapped a bunch of things for us. I've put those bug
fixes at the start of the series.

Further testing would be very much appreciated as this is a
notoriously funky area of the EFI code.

Changes in v4:

 - Drop the PFN_ALIGN() patch in favour of the linker script change

Changes in v3:

 - PFN_ALIGN() _text and _end when calculating npages to map

 - Drop the hunk that mapped the stack in efi_setup_page_tables(), now
   that we're mapping RAM we know the stack is already mapped.

 - Update the wording in Documentation/<..>/mm.txt to make it clear we
   carve out a 64Gb *size* of virtual address space, we don't use the
   first 64Gb virtual addresses.

Changes in v2:

 - Folded PATCH 1 and 2 together because they both fall under the
   umbrella of "making sure cpa->pfn is really a page frame number".

 - Fixed some checkpatch warnings about mixing spaces and tabs and
   made some stylistic changes per Borislav's comments.

 - Moved efi_alloc_page_tables() earlier in __efi_enter_virtual_mode()
   so that we fail early if we can't allocate memory for the page
   tables.

The following changes since commit 8005c49d9aea74d382f474ce11afbbc7d7130bec:

  Linux 4.4-rc1 (2015-11-15 17:00:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-pgtable

for you to fetch changes up to 73e727544ad2d9e1bb7421396b9043b776e3fcf4:

  Documentation/x86: Update EFI memory region description (2015-11-27 20:57:21 +0000)

----------------------------------------------------------------
 * Use completely separate page tables for EFI runtime service calls
   so that the security-lax mapping permissions (RWX) do not leak into
   the standard kernel page tables and trigger warnings when
   CONFIG_DEBUG_WX is enabled.

----------------------------------------------------------------
Matt Fleming (6):
      x86: Page align _end to avoid pfn conversion bugs
      x86/mm/pageattr: Ensure cpa->pfn only contains page frame numbers
      x86/efi: Map RAM into the identity page table for mixed mode
      x86/efi: Hoist page table switching code into efi_call_virt()
      x86/efi: Build our own page table structures
      Documentation/x86: Update EFI memory region description

 Documentation/x86/x86_64/mm.txt     |  12 +--
 arch/x86/include/asm/efi.h          |  26 ++++++
 arch/x86/kernel/vmlinux.lds.S       |   1 +
 arch/x86/mm/pageattr.c              |  17 ++--
 arch/x86/platform/efi/efi.c         |  39 ++++-----
 arch/x86/platform/efi/efi_32.c      |   5 ++
 arch/x86/platform/efi/efi_64.c      | 157 ++++++++++++++++++++++++++++--------
 arch/x86/platform/efi/efi_stub_64.S |  43 ----------
 8 files changed, 181 insertions(+), 119 deletions(-)
