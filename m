Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492741A6820
	for <linux-efi@vger.kernel.org>; Thu, 16 Apr 2026 07:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776323422; cv=none; b=W51ncIBO1Z+/56HoYFBFrb8sXKtWRm0anmou6Jm5rO51oXlVtVpJjbmgv306oG4XWVo2NNHmk0lcWJsorZl/FfTlqQew+K+ICJN4o55EW+io4Z7TycQlRWeVPclwsmIQlrA+XlHFZGh2mUWoztrNOlo+EAUNFt/vhvQZpisNA2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776323422; c=relaxed/simple;
	bh=+Xi0uTP4qtK0XAZ0Cnd1PfZBHg/o5e+8TyIe283kMA4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Jb7dzzsjRt8Msyc+NjrNSQxG3PbBre90N9LVRFBe95Drs8q1ug8Hd/HCpdsnsK6W+A3d9+OghM6oBb7KmCK+1LU5zZmO9tLEQ53oCIrvLqTTpnBty953rS3Ksea1DYsnUS0OzDWbVHxbiw9TXl0M4Kd5fD6z7uH5T63QdZy8bIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a9uXzgSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9uXzgSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F0BC2BCAF;
	Thu, 16 Apr 2026 07:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776323421;
	bh=+Xi0uTP4qtK0XAZ0Cnd1PfZBHg/o5e+8TyIe283kMA4=;
	h=From:To:Cc:Subject:Date:From;
	b=a9uXzgSFwsqpH528c309NoytYLPDpd/OperqgFQdWw3vWPIDfqUbHhFGPIm9OxTWD
	 LiSpqzx+Rkq0OmBDMtVgF+dr+h+plC7+iPORHAckcdZkTiD2+PPiwJ/G62LBRCqm66
	 JNNzBwCpKKb5eORiy6RrXK0jVwe//MAVAfW5RFHVFkao6OW5LokRgT0JstGm+Ied3P
	 UEvUpMBfclh8TtfCPJOl7vMrchfdWnisx3foLCAD5aJ9uKORfTDSY69LLEDI2kAMT2
	 Nil8CGswkr1tQmnGxFZJRNeKptnA7s7MAX46xEKq71ilG2mpLFvemaSehVm7XW9Vhj
	 fbzZFIPmHpiqw==
From: Ard Biesheuvel <ardb@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-efi@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [GIT PULL] EFI updates for v7.0
Date: Thu, 16 Apr 2026 09:10:02 +0200
Message-ID: <20260416071005.421896-1-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Linus,

Again not a busy cycle for EFI, just some minor tweaks and bug fixes.

Please pull.


The following changes since commit 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681:

  Linux 7.0-rc3 (2026-03-08 16:56:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v7.1

for you to fetch changes up to 48a428215782321b56956974f23593e40ce84b7a:

  efi/capsule-loader: fix incorrect sizeof in phys array reallocation (2026-04-10 18:14:21 +0200)

----------------------------------------------------------------
EFI updates for v7.0

- Enable boot graphics resource table (BGRT) on Xen/x86

- Correct a misguided assumption in the memory attributes table sanity
  check

- Start tagging efi_mem_reserve()'d regions as MEMBLOCK_RSRV_KERN

- Some other minor fixes and cleanups

----------------------------------------------------------------
Ard Biesheuvel (4):
      efi: Drop unused efi_range_is_wc() function
      efi/memattr: Fix thinko in table size sanity check
      memblock: Permit existing reserved regions to be marked RSRV_KERN
      efi: Tag memblock reservations of boot services regions as RSRV_KERN

Ben Dooks (1):
      efi: libstub: fix type of fdt 32 and 64bit variables

Marek Marczykowski-Górecki (2):
      efi: make efi_mem_type() and efi_mem_attributes() work on Xen PV
      efi: Enable BGRT loading under Xen

Thomas Huth (1):
      efi/capsule-loader: fix incorrect sizeof in phys array reallocation

 drivers/firmware/efi/capsule-loader.c |  2 +-
 drivers/firmware/efi/efi-bgrt.c       |  7 +++++--
 drivers/firmware/efi/efi.c            | 31 ++++++++++++-----------------
 drivers/firmware/efi/libstub/fdt.c    | 12 ++++++------
 drivers/firmware/efi/memattr.c        | 37 ++++++++++++++++++++++++++---------
 include/linux/efi.h                   | 21 --------------------
 include/linux/memblock.h              |  1 +
 mm/memblock.c                         | 15 ++++++++++++++
 8 files changed, 68 insertions(+), 58 deletions(-)
