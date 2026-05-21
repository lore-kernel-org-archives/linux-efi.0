Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CB33E275F
	for <linux-efi@vger.kernel.org>; Thu, 21 May 2026 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779370466; cv=none; b=kfflhRp8zRi3+U4MEz92ELbMDQi5dZUOx1OIxY72V1OWPiR7r5zo+1Totz8K22WyzRqNbXpCp4/brOGn59DrWRxFG8SagykVfxYToihOe11we95YZL4sHXIhwVi8REz81nL0+PwGQBYG8xPhCnStHJW2otM+9KTlNvzhdsPbnSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779370466; c=relaxed/simple;
	bh=E0rKsattX3JkwhOuHLwqhQu9cO+/sG9Kde45UsfFI6E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KGms9HYnM4Pmz/vjKrpi5c5u2VJFKA1xi/bpA48nAC6r1kqcm/zu++0ikIlygsQkjUXdunOiFFiFqlZqsVb+zvWpjKcIiXTjcc858euZiP1jhOCnLVVBjchdUohK2b/ngfc27rZm0Tm/rIMAl/yzd38Zf9TDjkL+qKkszuk0i84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLklzthZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLklzthZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113F11F000E9;
	Thu, 21 May 2026 13:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779370464;
	bh=O+N7JtBZl0kMFlocAcLwUFMKA7Rz7N0t187+S5hbFaw=;
	h=From:To:Cc:Subject:Date;
	b=BLklzthZxZiJ8YdVIoBwDO33G/6MoGyJtVZMNTKVsu9cbAZVdKF2hgIDaJYY/T+t6
	 N3KBKJvxrhZdHaGJr2kj8OfImQh5fKVccjg71HFWzBHvbp5eH06WaqHhAv5QZsTKmO
	 aAPznMi/TWRU2+50obuAnuB/SP0D2t5GL0nxJCLNXugBWkJZ/E+Wh5haCTqgD5vUZf
	 DLKzxIyKivi66rNwDLBfWpNLIKCi9fwwKet4aP7vnpcv9YCtb3AwehINJkIJE2PM8A
	 B4x986A5uAF6kL8qEBrmilmSwbeljjmArrJ/aTjPj2P8w6Ad/pnUmG/7B2fHHIdvh1
	 KMG050lazYhoA==
From: Ard Biesheuvel <ardb@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-efi@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [GIT PULL] EFI fixes for v7.1 #2
Date: Thu, 21 May 2026 15:34:14 +0200
Message-ID: <20260521133414.65900-1-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Linus,

Please pull the EFI fixes below - details are in the tag.


The following changes since commit 2c340aab5485ebe9e33c01437dd4815ef33c8df5:

  x86/efi: Restore IRQ state in EFI page fault handler (2026-05-05 09:31:28 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.1-2

for you to fetch changes up to d8809f6931065cbbf3554647a50a65a471ab5983:

  efi: sysfb_efi: Extend quirk to cover IdeaPad Duet 3 10IGL5-LTE (2026-05-19 17:27:15 +0200)

----------------------------------------------------------------
EFI fixes for v7.1 #2

- Permit ACPI PRM runtime firmware calls when acpi_init() runs

- Add another Lenovo Ideapad framebuffer quirk

- Cosmetic tweak

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi: Allocate runtime workqueue before ACPI init

Marius Hoch (1):
      efi: sysfb_efi: Extend quirk to cover IdeaPad Duet 3 10IGL5-LTE

Rong Tao (1):
      efi: efi.h: Remove extra semicolon

 drivers/firmware/efi/efi.c       | 28 ++++++++++++++++------------
 drivers/firmware/efi/sysfb_efi.c |  9 ++++++---
 include/linux/efi.h              |  2 +-
 3 files changed, 23 insertions(+), 16 deletions(-)
