From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL 0/2] EFI changes for v4.3 (part two)
Date: Fri,  4 Sep 2015 14:11:40 +0100
Message-ID: <1441372302-23242-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@suse.de>, Catalin Marinas <catalin.marinas@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Folks, please pull the remaining parts of the EFI changes for v4.3.

Nothing much has changed in terms of code since the last version of
this part two pull request was sent on August 12th,

  https://lkml.kernel.org/r/1439396234-22863-1-git-send-email-matt@codeblueprint.co.uk

The main difference is the improved commit message in PATCH 2, which
now contains much more information as well as the user visible
side-effects of the issue that the patch fixes.

There were also some improvements to the comments inside PATCH 1 as
well as moving the function out of line at Ingo's suggestion.

The branch is based on tip/core/efi.

The following changes since commit 8d446c8647c9ab8fcb45a8fc7dbbafe1f83aa2f3:

  arm64/mm: Add PROT_DEVICE_nGnRnE and PROT_NORMAL_WT (2015-08-08 10:37:40 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git acpi/ghes

for you to fetch changes up to 404f03dbebede4d0ebeabd06e4b9120b481ae536:

  acpi, apei: Use appropriate pgprot_t to map GHES memory (2015-09-04 13:39:31 +0100)

----------------------------------------------------------------
Jonathan (Zhixiong) Zhang (2):
      arm64: apei: Implement arch_apei_get_mem_attributes()
      acpi, apei: Use appropriate pgprot_t to map GHES memory

 arch/arm64/include/asm/acpi.h |  5 +++++
 arch/arm64/kernel/acpi.c      | 29 +++++++++++++++++++++++++++++
 drivers/acpi/apei/ghes.c      | 10 +++++++---
 3 files changed, 41 insertions(+), 3 deletions(-)
