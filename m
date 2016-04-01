From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL] EFI urgent fix
Date: Fri,  1 Apr 2016 20:03:14 +0100
Message-ID: <1459537395-4523-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Langsdorf <mlangsdo@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Mark Salter <msalter@redhat.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

Folks,

Please pull the following fix for an arm64 boot crash reported by Mark
Salter with 64KB granule kernels. It is also tagged for stable.

The following changes since commit 591b1d8d86074ac3a3163d89bcfe7b232cf83902:

  x86/mm/pkeys: Add missing Documentation (2016-03-29 11:21:17 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 7cc8cbcf82d165dd658d89a7a287140948e76413:

  efi/arm64: Don't apply MEMBLOCK_NOMAP to UEFI memory map mapping (2016-03-31 21:33:50 +0100)

----------------------------------------------------------------
 * Fix a boot crash on arm64 caused by a recent commit to mark the EFI
   memory map as 'MEMBLOCK_NOMAP' which causes the regions to be
   omitted from the kernel direct mapping - Ard Biesheuvel

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/arm64: Don't apply MEMBLOCK_NOMAP to UEFI memory map mapping

 drivers/firmware/efi/arm-init.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)
