Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4B330BBAE
	for <linux-efi@vger.kernel.org>; Wed,  6 May 2026 13:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778072707; cv=none; b=CVrcUIhF9mFC7RQq4Kd2pzkcB+8d/LA7pV3d6X0Mr0cmKirRfIeWjNTGMfXmNfnFIyoEeDwmBIhob0Q8yndZ26mUtToRAizTt1vgTR9Q8Z5HaoT7kWl9AppTZKfIPw/vXglT2QD7OWMzvcwBCAlrgA7nKMFaOJiDHbdErnW6U9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778072707; c=relaxed/simple;
	bh=7B/rf7mBPXeO6/oHVDrDWTT6iPa1X+MAB58WOg1TZW8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bA1HF0IDYZBpjqdPOSBkJCVG4xpAIczGDpXTPVmAy1uF66Prmzk0htKVQlJuxlM1KQhSGxEY3DfINBE7ft5ryCxQS5rlRWAo16ky8kWbinreg3WLOfs7Wht7KjNH6m2oD33k6FqiNcL5LZMSG4smwX/IDouUK35lATjiPxn3nNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+uSuO9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+uSuO9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC31C2BCB8;
	Wed,  6 May 2026 13:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778072706;
	bh=7B/rf7mBPXeO6/oHVDrDWTT6iPa1X+MAB58WOg1TZW8=;
	h=From:To:Cc:Subject:Date:From;
	b=X+uSuO9RHKTha9vDRixLi1w72A8smq+9kaDVwAneB21OHcNqcr5vTADjHkgJmzPDd
	 2yeuEO9irN5+KvxeR9smug1U2412Olq8wiDFRR0ORiVQywr7xP10JidVM53+yH9JOh
	 dfZ+NZ4Mdt3ftLQtbcqg0Npazd8YApJ9Y1czbMO44RiV2R9onADNLUTnWrsPgC4aR/
	 7HOAx9J/Gp+01rJD0satcIiGCVJOwFuGcORld6iu3df7qHkzdF8+WS1weIYIttisv2
	 F6gokjak+iKJipQ93+jkdffxlVfoNWbiQXY598eEixpQ87S89byUp2CZX/GUQoLT2+
	 FAQFfWsMtpjEg==
From: Ard Biesheuvel <ardb@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-efi@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [GIT PULL] EFI fixes for v7.1 #1
Date: Wed,  6 May 2026 15:04:28 +0200
Message-ID: <20260506130427.1761-2-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2265; i=ardb@kernel.org; h=from:subject; bh=7B/rf7mBPXeO6/oHVDrDWTT6iPa1X+MAB58WOg1TZW8=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfO3TfSsL6z71kXuZV+yh0vD84pGr0rS8V365S9jWI03S v3bsy+lo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEykl5Hhn9qDlQZ51x6X/Gpw t/8lrsKpc+D7p+DfwspVffY7Dt3b7s/IcP/bxIncu6++2rxpdtSHb7mKYTOMWu9f5J20Rd21e1l MIisA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Hi Linus,

This is the first batch of EFI fixes, most of which are -stable candidates.

Please pull.



The following changes since commit 254f49634ee16a731174d2ae34bc50bd5f45e731:

  Linux 7.1-rc1 (2026-04-26 14:19:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.1-1

for you to fetch changes up to 2c340aab5485ebe9e33c01437dd4815ef33c8df5:

  x86/efi: Restore IRQ state in EFI page fault handler (2026-05-05 09:31:28 +0200)

----------------------------------------------------------------
EFI fixes for v7.1 #1

- Fix issues in EFI graceful recovery on x86 introduced by changes to
  the kernel mode FPU APIs

- I-cache coherency fixes for the LoongArch EFI stub

- Locking fix for EFI pstore

- Code tweak for efivarfs

----------------------------------------------------------------
Ard Biesheuvel (2):
      efi/libstub: Move efi_relocate_kernel() into its only remaining user
      x86/efi: Restore IRQ state in EFI page fault handler

Ivan Hu (1):
      x86/efi: Fix graceful fault handling after FPU softirq changes

Thomas Huth (1):
      efi: pstore: Drop efivar lock when efi_pstore_open() returns with an error

Thorsten Blum (1):
      efivarfs: use QSTR() in efivarfs_alloc_dentry

WANG Rui (2):
      efi/loongarch: Implement efi_cache_sync_image()
      efi/libstub: Synchronize instruction cache after kernel relocation

 arch/x86/include/asm/efi.h                    |   3 +-
 arch/x86/mm/fault.c                           |   2 +-
 arch/x86/platform/efi/quirks.c                |  13 +-
 drivers/firmware/efi/efi-pstore.c             |   4 +-
 drivers/firmware/efi/libstub/Makefile         |   2 +-
 drivers/firmware/efi/libstub/efistub.h        |   7 --
 drivers/firmware/efi/libstub/loongarch-stub.c |  80 +++++++++++++
 drivers/firmware/efi/libstub/loongarch.c      |   5 +
 drivers/firmware/efi/libstub/mem.c            |  82 +++++++++++++
 drivers/firmware/efi/libstub/relocate.c       | 166 --------------------------
 fs/efivarfs/super.c                           |   5 +-
 11 files changed, 186 insertions(+), 183 deletions(-)
 delete mode 100644 drivers/firmware/efi/libstub/relocate.c
