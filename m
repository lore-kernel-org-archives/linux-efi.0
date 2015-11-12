From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL 0/6] EFI page table isolation
Date: Thu, 12 Nov 2015 15:40:17 +0000
Message-ID: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
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

The following changes since commit 2c66e24d75d424919c42288b418d2e593fa818b1:

  x86/efi: Fix kernel panic when CONFIG_DEBUG_VIRTUAL is enabled (2015-10-25 10:22:25 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 278a4c3c13f6b24f4e18aeabe4135fff7fc703d2:

  Documentation/x86: Update EFI memory region description (2015-11-12 15:03:08 +0000)

----------------------------------------------------------------
 * Use completely separate page tables for EFI runtime service calls
   so that the security-lax mapping permissions (RWX) do not leak into
   the standard kernel page tables and trigger warnings when
   CONFIG_DEBUG_WX is enabled.

----------------------------------------------------------------
Matt Fleming (6):
      x86/mm/pageattr: Ensure cpa->pfn only contains page frame numbers
      x86/mm/pageattr: Do not strip pte flags from cpa->pfn
      x86/efi: Map RAM into the identity page table for mixed mode
      x86/efi: Hoist page table switching code into efi_call_virt()
      x86/efi: Build our own page table structures
      Documentation/x86: Update EFI memory region description

 Documentation/x86/x86_64/mm.txt     |  12 +--
 arch/x86/include/asm/efi.h          |  26 ++++++
 arch/x86/mm/pageattr.c              |  17 ++--
 arch/x86/platform/efi/efi.c         |  41 ++++-----
 arch/x86/platform/efi/efi_32.c      |   5 ++
 arch/x86/platform/efi/efi_64.c      | 174 ++++++++++++++++++++++++++++--------
 arch/x86/platform/efi/efi_stub_64.S |  43 ---------
 7 files changed, 193 insertions(+), 125 deletions(-)
