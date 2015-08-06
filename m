From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL] EFI changes for v4.3
Date: Thu, 6 Aug 2015 21:32:32 +0100
Message-ID: <20150806203232.GH4332@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following changes for v4.3. The biggest changes
are the memory map querying updates in the ACPI GHES driver and the
revert of commit aeffc4928ea2 ("x86/efi: Request desired alignment via
the PE/COFF headers") which was reportedly causing errors when users
attempt to sign their kernels with Signtool.

The GHES driver changes touch a mixture of ACPI, x86 and arm64 code but
all the patches have been ACKed and/or reviewed by relevant people.

The following changes since commit bc0195aad0daa2ad5b0d76cce22b167bc3435590:

  Linux 4.2-rc2 (2015-07-12 15:10:30 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 8229722e29da369a4e9512a5c18adb4028a7626b:

  acpi, apei: use appropriate pgprot_t to map GHES memory (2015-08-06 15:44:41 +0100)

----------------------------------------------------------------
 * Add support for the new EFI memory map attribute EFI_MEMORY_RO that
   was introduced in the UEFI 2.5 spec - Ard Biesheuvel

 * Lower the severity of the invalid BGRT message from pr_err()
   to pr_debug() since it's legitimate (per the spec) for the firmware
   to pass the kernel a BGRT with the invalid status bit set. The kernel
   just simply needs to ignore it.

 * Revert the optimisation of using CONFIG_PHYSICAL_ALIGN in the
   PE/COFF header SectionAlignment field of the EFI stub, since it
   violates the PE/COFF spec which says SizeOfImage must be a multiple
   of SectionAlignment, and because it was causing Signtool to fail.

 * Update the ACPI Platform Error Interface (APEI) GHES driver to query
   the EFI memory map for the correct cache attributes to use when
   mapping pages accessed by both the kernel and firmware. This prevents
   stale data being read by the kernel - Jonathan (Zhixiong) Zhang

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi: Add support for EFI_MEMORY_RO attribute introduced by UEFIv2.5

Jonathan (Zhixiong) Zhang (5):
      efi: x86: rearrange efi_mem_attributes()
      x86: acpi: implement arch_apei_get_mem_attributes()
      arm64: mm: add PROT_DEVICE_nGnRnE and PROT_NORMAL_WT
      arm64: apei: implement arch_apei_get_mem_attributes()
      acpi, apei: use appropriate pgprot_t to map GHES memory

Matt Fleming (2):
      x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid BGRT
      Revert "x86/efi: Request desired alignment via the PE/COFF headers"

 arch/arm64/include/asm/acpi.h    | 27 +++++++++++++++++++++++++++
 arch/arm64/include/asm/memory.h  |  1 +
 arch/arm64/include/asm/pgtable.h |  2 ++
 arch/arm64/mm/proc.S             |  4 +++-
 arch/x86/boot/header.S           |  2 +-
 arch/x86/include/asm/acpi.h      | 24 ++++++++++++++++++++++++
 arch/x86/platform/efi/efi-bgrt.c |  9 +++++++--
 arch/x86/platform/efi/efi.c      | 18 ------------------
 drivers/acpi/apei/ghes.c         |  6 ++++--
 drivers/firmware/efi/efi.c       | 39 ++++++++++++++++++++++++++++++++++++---
 include/linux/efi.h              |  1 +
 11 files changed, 106 insertions(+), 27 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
