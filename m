From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL 0/2] EFI changes for v4.3 (part two)
Date: Wed, 12 Aug 2015 17:17:12 +0100
Message-ID: <1439396234-22863-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Folks, please pull the remaining parts of the EFI changes for v4.3.

In this pull is the arm64 arch_apei_get_mem_attributes() implementation
with the changes requested by Ard. The final patch uses the new
arch_apei_get_mem_attributes() in the GHES driver, which means the
driver now maps the GHES region correctly on arm64.

The branch is based on tip/core/efi.

The following changes since commit 8d446c8647c9ab8fcb45a8fc7dbbafe1f83aa2f3:

  arm64/mm: Add PROT_DEVICE_nGnRnE and PROT_NORMAL_WT (2015-08-08 10:37:40 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 4cf8e8af8ac0a810f05ecc3fce440626b4dcb7e3:

  acpi, apei: use appropriate pgprot_t to map GHES memory (2015-08-12 14:44:46 +0100)

----------------------------------------------------------------
 * Additional patches for arm64 and to the ACPI GHES driver to allow
   architectures to specify which mapping attributes to use to ioremap
   the GHES region - Jonathan (Zhixiong) Zhang

----------------------------------------------------------------
Jonathan (Zhixiong) Zhang (2):
      arm64: apei: implement arch_apei_get_mem_attributes()
      acpi, apei: use appropriate pgprot_t to map GHES memory

 arch/arm64/include/asm/acpi.h | 30 ++++++++++++++++++++++++++++++
 drivers/acpi/apei/ghes.c      |  6 ++++--
 2 files changed, 34 insertions(+), 2 deletions(-)
