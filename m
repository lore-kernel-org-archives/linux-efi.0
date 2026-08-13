Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2098237755D;
	Thu, 13 Aug 2026 07:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607119; cv=none; b=XuOHoXWvIPXxnY27dp/iP8jJB4bgYj6Mx4rguFmFDP8+n1DpfiCBB5DGxfkPQojhXsNN9c/eWyuXbFd+3jcmptHMWWFRPzvQiX+xPniIfjvl40WZh+9v1AdOSdyhL+LPEDVIWVKw58Mm+aJgG41jCr8fCHLSxAQL/0lf/40hKTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607119; c=relaxed/simple;
	bh=MmFnoyH6IBM5J1QaHpDDaxU2xgzbd3BB99dcCccK0w8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g6CUkiQM41yrtVG1xYrWUaMBlWSXdLvNtL6Dfb+iHZI5NzIxVX0Fyq8aANC7OxyC37I0s+o7Lmxr7Cp7VQZlQcHNf8RBBbkLv2saOcqqR6wRiJ3Eko2giHf2j/PkgYBF79MxqYh+iN+bRRDVikgITBC0bdvi/TpldCwB6mRaEO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izd5rmAb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izd5rmAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564C01F000E9;
	Thu, 13 Aug 2026 07:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786607117;
	bh=5nYEuEHetJaYS/wsB7dUCYJ99YTlt2b/K2HrzA8zt2E=;
	h=From:To:Cc:Subject:Date;
	b=izd5rmAbVRl5xG+TWj8gdsSAL8bqhLaOU0ROhKiYvWdd1s69rEdS+Cn4hSsHE0MYD
	 iQzLT4QVj0rkgIRoHg67IQT+ifyr9DzL6QTOe1Bryy3RCtnK3T3d75iQHLlhwCOlvU
	 iTj7GcaTse0qQdGBCRdsBq7/dmWnHkPCaft7WfJ2VUX50H7vTQjCdtjVgZju21XMKG
	 BmEAgNZ2eJBbgSsvh4p1YgqHrbHKK+k7WmeKpKu0OetNs7rdCxKYFMoFCcBCil6GdO
	 c0oOsfc3uPYfQ1Qxadeqgd611AmgHIJ0x1JyEhvHern4TQPxrfthCMQiypRo4ZKFjd
	 bvS6HvolxBryg==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev
Subject: [PATCH 0/3] efi: Simply DT handoff from stub to kernel
Date: Thu, 13 Aug 2026 09:45:07 +0200
Message-ID: <20260813074506.643472-5-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1156; i=ardb@kernel.org; h=from:subject; bh=MmFnoyH6IBM5J1QaHpDDaxU2xgzbd3BB99dcCccK0w8=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIau2jFnQTFzk7q7r/v83MoTFVHJ/mmk/p7xl7tOH01b+3 WC9qYC/o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExk411GhikqBUIM9xafuh4b 4X1I++7KfzF/t1j1cq8sFdf+pvL0wi+G/8Fsfe+drC0epYVzf9OLZyxc/2Om8bfZOXIvgm98lJ5 xlQkA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Currently, 4 separate DT properties are used as an internal ABI to hand
over the EFI memory map from the EFI stub to the kernel proper.

This information is redundant, as the same information is already made
available via a EFI configuration table.

So replace those 4 DT properties with a single one that carries the
address of this config table, and make it optional, so that it can be
omitted in cases where the kernel is able to locate the table directly
via its GUID.

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev

Ard Biesheuvel (3):
  efi: Turn boot memmap handling into shared code
  efi: Pass EFI boot memmap struct address to core kernel
  efi: Make the 'linux,uefi-boot-memmap' DT property optional

 Documentation/arch/arm/uefi.rst    | 10 +--
 arch/loongarch/kernel/efi.c        | 10 +--
 drivers/firmware/efi/efi.c         |  4 +
 drivers/firmware/efi/fdtparams.c   | 77 ++++++++++++++++++--
 drivers/firmware/efi/libstub/fdt.c | 40 +---------
 include/linux/efi.h                |  3 +
 6 files changed, 84 insertions(+), 60 deletions(-)

-- 
2.47.3

