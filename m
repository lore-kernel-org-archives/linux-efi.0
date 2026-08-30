Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866922C21E6;
	Sun, 30 Aug 2026 10:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788085851; cv=none; b=V6Q0/0Zz0LMy4kodxlIdQxDVqZeIFfaPl1bLvDN1NQwF9Y9pUoqXkMf5pa8NJA4HYu07QgOa0jKLuETGKInj1gF/Yog0s699ZJjc6lBfe9nLyT+OaIrwXeGYaxFLIRMVPFYscM8EPvDRioXt0QIliUxAbry5+lXb4tnhCvZlpJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788085851; c=relaxed/simple;
	bh=UXHFCXNGSFw6KzVoYejqH5qoRCF2QrwOWVuOLFlsBWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQ7EbqYwBSzNKeSoOqsoJFNZryGwjSAqO4Kdv4lmZxyKRHsOs/6806qsS8g0pcJ0UapkgCyd7H8rwZo00O8sa2rTslnN66NUrKGfbyO4PiMt/kPosNGDZEBsHBUSiLl+Xtf8RYPsDEJfrIZNxLHJFyji65qUkSO04ajeKE9tceI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KefzdNpJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KefzdNpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47F11F000E9;
	Sun, 30 Aug 2026 10:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788085850;
	bh=wKx2dhlUDycVLgdWo8frEreASkURA93J5bEzH5pl9MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KefzdNpJjHEQV/l3cSzO8L3ZUAXOv9ISb8N0svos1I4Ep15HGDCUBGmmAa/wtj368
	 AMYwISNdsK/oNTLZGqIFyxLv+zQy3+q26QFMEB63htdWb2MBUDNtvz5vsLcpHUIOmj
	 iuDhJ6U56aa2WSoHaZG/RUMqY2hs/9njKuyVj9lO0F+0G87rWwIpi/574RV2ny0CFG
	 s0JQEtoHQBZC6FYGWVJ2/515LIkai5WYYZ3vSOyT2PxV+IySJGNCFaxPOnfceaGKDC
	 lDR9P9KYMknOc8kTFlvOKtGrWQ47EQnRYYouhd1smgynCVdXHxSbiX9pGgL4jzxGNr
	 00JNGzVzPZtrQ==
From: Thorsten Blum <blum@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] efi/libstub: Fix grammar in efi_kaslr_relocate_kernel() comment
Date: Sun, 30 Aug 2026 12:29:10 +0200
Message-ID: <20260830102911.345357-4-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260830102911.345357-3-blum@kernel.org>
References: <20260830102911.345357-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1477; i=blum@kernel.org; h=from:subject; bh=UXHFCXNGSFw6KzVoYejqH5qoRCF2QrwOWVuOLFlsBWw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlT2NhZju/c6JNzwF+s1eX92e8vFz6asOjADIYD+UcZA 6NmsOlYd5SyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBE+EMYGc63T97w7qPeyyyB RKU7cW2fH6b+un7RetmFk7O8HLtbm1cwMuzUUyhbely6S3vn75pdn4zsl/jtvfXtqNjNi1PFH68 sKeADAA==
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Fix the grammar in the kernel-doc comment and indent the @image_addr
description correctly.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/firmware/efi/libstub/kaslr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
index 17549bf3dc3e..b26227aa2c7b 100644
--- a/drivers/firmware/efi/libstub/kaslr.c
+++ b/drivers/firmware/efi/libstub/kaslr.c
@@ -82,7 +82,7 @@ static bool check_image_region(u64 base, u64 size)
 
 /**
  * efi_kaslr_relocate_kernel() - Relocate the kernel (random if KASLR enabled)
- * @image_addr: Pointer to the current kernel location
+ * @image_addr:		Pointer to the current kernel location
  * @reserve_addr:	Pointer to the relocated kernel location
  * @reserve_size:	Size of the relocated kernel
  * @kernel_size:	Size of the text + data
@@ -91,8 +91,8 @@ static bool check_image_region(u64 base, u64 size)
  * @phys_seed:		Random seed used for the relocation
  *
  * If KASLR is not enabled, this function relocates the kernel to a fixed
- * address (or leave it as its current location). If KASLR is enabled, the
- * kernel physical location is randomized using the seed in parameter.
+ * address or leaves it at its current location. If KASLR is enabled, the
+ * kernel's physical location is randomized using the supplied seed.
  *
  * Return:	status code, EFI_SUCCESS if relocation is successful
  */
