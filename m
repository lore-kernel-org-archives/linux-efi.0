Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508632C21E6;
	Sun, 30 Aug 2026 10:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788085846; cv=none; b=Ob+J8jQR49unhkh4lJYQGPE517SuAUbl6tOQ1JSxCQUwS/jKAYqUW2Z0sMeVr1uyvyZ04VtBkKWyisRJ5tPyX/d4iKVwJWtsZY2sFWAM0Twx99WgSDh0yp/iSnk3nQRfsUBOpnwymPP87cAS0WtcoZpFda9w7vfucygnfnV74ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788085846; c=relaxed/simple;
	bh=ZgRPq/+Sgrc4sC2VvTD9OYI608yY7/+Yn6GVoll+1rk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lQVRFNK6lvwqTvrYQ3tOcX2K2Ih4Irlvnnlnpw1rTmluNCpayr9hAjN6HsmVyI3TYRCQbPThvBmYo7ZV6sTFwAjNDDid8kyJn3VulJK/Gfy44StwegFcGLtqrtBcI4hmhZSE4F+Uq5MbI1ZS6nSoOK4IvJ2GXhHRRQolhgxtllc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSITmhqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSITmhqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578771F000E9;
	Sun, 30 Aug 2026 10:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788085844;
	bh=ZtIhcUXB3xuMc2+u5/0ciofob1WH7dnuRdwdSoLIXNI=;
	h=From:To:Cc:Subject:Date;
	b=HSITmhqzVs1cgdcklkR1v/Z9h6SYz5AB+dTogKAAj/40DXgg1H6Kh3KH8VzqakIkX
	 Ux1omdAWxC5bWa6l+hOGN1Y0IKw2gm1RyjuCgtTTb37KbyaEPrkyMLqJPCClTNGgW9
	 exgs8e7tSLMpQfNfZhpfuV1INAAwZapd5J5MSePtiY8vKr54CFZYXf6Xf1E3Rf907p
	 s7lA+UuR4comFg9rOsHbw64tn56U1wBEw/mwf9vE/Rac8bE6Ye4O98BIXlpQPQMYpj
	 fJP9oEUKRhVS5gdlM5GTIaH6/DRfTsugO9TY5S2oVrVz2wwykYF5Jr0LMdJ28xEgF/
	 TmvO1AVf+WjOQ==
From: Thorsten Blum <blum@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] efi/libstub: Simplify check_image_region()
Date: Sun, 30 Aug 2026 12:29:09 +0200
Message-ID: <20260830102911.345357-3-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1268; i=blum@kernel.org; h=from:subject; bh=ZgRPq/+Sgrc4sC2VvTD9OYI608yY7/+Yn6GVoll+1rk=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlTWL+X3FZtrG+ckrzvR103Q/8SW2/1mz9Ds9Ymbn04y en3keQ9HaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjARP21GhlvtHm+vNq+zfnZU T4Z9ut2CKeHflt67MWPCwjkdD1YePOXPyHDf12uNRqvtHa5A/4gFB46sfaT95fzPb1erXm61C7M 8/JkDAA==
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Drop the local ret variable and the break statement by returning the
result directly. Also use unsigned long for map_offset, since map_size
and desc_size are both unsigned long.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/firmware/efi/libstub/kaslr.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
index 4bc963e999eb..17549bf3dc3e 100644
--- a/drivers/firmware/efi/libstub/kaslr.c
+++ b/drivers/firmware/efi/libstub/kaslr.c
@@ -59,8 +59,7 @@ static bool check_image_region(u64 base, u64 size)
 {
 	struct efi_boot_memmap *map __free(efi_pool) = NULL;
 	efi_status_t status;
-	bool ret = false;
-	int map_offset;
+	unsigned long map_offset;
 
 	status = efi_get_memory_map(&map, false);
 	if (status != EFI_SUCCESS)
@@ -74,13 +73,11 @@ static bool check_image_region(u64 base, u64 size)
 		 * Find the region that covers base, and return whether
 		 * it covers base+size bytes.
 		 */
-		if (base >= md->phys_addr && base < end) {
-			ret = (base + size) <= end;
-			break;
-		}
+		if (base >= md->phys_addr && base < end)
+			return (base + size) <= end;
 	}
 
-	return ret;
+	return false;
 }
 
 /**
