From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL v3 0/6] EFI page table isolation
Date: Mon, 23 Nov 2015 13:33:08 +0000
Message-ID: <1448285594-17617-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
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

The following changes since commit 2c66e24d75d424919c42288b418d2e593fa818b1:

  x86/efi: Fix kernel panic when CONFIG_DEBUG_VIRTUAL is enabled (2015-10-25 10:22:25 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to fac3e3c52017a5d974c7d8168e8e43c8f68af82a:

  Documentation/x86: Update EFI memory region description (2015-11-23 12:33:09 +0000)

----------------------------------------------------------------
 * Use completely separate page tables for EFI runtime service calls
   so that the security-lax mapping permissions (RWX) do not leak into
   the standard kernel page tables and trigger warnings when
   CONFIG_DEBUG_WX is enabled.

----------------------------------------------------------------
Matt Fleming (6):
      x86/efi: PFN_ALIGN() _text and _end when calculating number of pages
      x86/mm/pageattr: Ensure cpa->pfn only contains page frame numbers
      x86/efi: Map RAM into the identity page table for mixed mode
      x86/efi: Hoist page table switching code into efi_call_virt()
      x86/efi: Build our own page table structures
      Documentation/x86: Update EFI memory region description

 Documentation/x86/x86_64/mm.txt     |  12 +--
 arch/x86/include/asm/efi.h          |  26 ++++++
 arch/x86/mm/pageattr.c              |  17 ++--
 arch/x86/platform/efi/efi.c         |  39 ++++-----
 arch/x86/platform/efi/efi_32.c      |   5 ++
 arch/x86/platform/efi/efi_64.c      | 159 ++++++++++++++++++++++++++++--------
 arch/x86/platform/efi/efi_stub_64.S |  43 ----------
 7 files changed, 181 insertions(+), 120 deletions(-)
