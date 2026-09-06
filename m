Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7603CDBC3;
	Sun,  6 Sep 2026 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788700125; cv=none; b=Z0pmwX8wylOKnt7vK08kefKHw9YSWH+olPD5x4sYw20xDoIxPPQtlTa1iexTLaFFhg9a+fgBL/jt3B70+OzW6oAL5stjHArANEPTbqdReJvO/q88yRn+o5SDR1QD711wR65KO+I21SaN9mCIQy2qhnva31iHWOTaYEk9zOg75ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788700125; c=relaxed/simple;
	bh=6Jy+fsLEkRLfCSUAx6Uz1rko/nvUdEtvDWVFGbNxBuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rbjc6MhGGp/+WQoPX3ArQKU5GIlAl1EBoFEK67LXIozUZjhlI643NcptvKD7i/Nw0AJnmk3M/1ko1enR0I2NbTtz/1admPK591MW4r6dGLEY/DtbRk/uhcbTVhGpfGNdfTLvbjwiHwFpUlEEMRax+GJq7dLnaqZexchjRrvdpx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+pIYcN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+pIYcN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADB21F00A3D;
	Sun,  6 Sep 2026 13:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788700124;
	bh=GioO1TjVhWaD4hx3LEmglO1WHROdxiVW7/aupMqAvvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+pIYcN01GJPuSSy1m6gWE+609HW68oj3ZqUrMz8qZyuOdvIP6UTwXm4q/mjfJ7fO
	 Abn2U3IfFOm0DX4P19lMeXS9ldPhtDRhn130iVLi56AWnLR8VzRKsoCAJ5h2b57XXp
	 O6Y2N2LucMoxK7SdTH0rDqYVBz0itOO4fNURqJIM1zD1AcIlCS2E2obP2GveV3t63h
	 Jwg+SZ4Gx3fCCVOOOcFbfWTi+v958D9Iq7tYe8NnuteYhFIHDmIyGaMtS+TNKesaat
	 +1r7FSPDbYXbRCO11lCgQJLYWPpHmFyoyXAvcM2MJ2NcYsT0q91bGrhIPlwCTl3YxL
	 3vMJaFR4ncE7A==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Vincent Mailhol <mailhol@kernel.org>,
	x86@kernel.org
Subject: [PATCH 4/7] efi/libstub: Avoid efi_puts() for compile time constant strings
Date: Sun,  6 Sep 2026 15:08:22 +0200
Message-ID: <20260906130817.1151961-13-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906130817.1151961-9-ardb@kernel.org>
References: <20260906130817.1151961-9-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2145; i=ardb@kernel.org; h=from:subject; bh=6Jy+fsLEkRLfCSUAx6Uz1rko/nvUdEtvDWVFGbNxBuY=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWtu6qnYlGz2vUFxgrdEGlSWWHL+e/9Fpuip6YUe3ZsFP dkVe/51lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIkEtDMyHL3K8+LDll1bvdmF 58bXHm5JdT9attzKqybs4UzRTxmrNjMyNCS2Jq64uE3sndyXyBOXy+cev7ji67cXRvvk9KUFX8w y5QUA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

efi_puts() performs a UTF-8 to UTF-16 conversion on its input, as the
EFI console's native character set is UTF-16.

This is pointless for compile time constant strings, since we can
simply define those as UTF-16 to begin with.

Note that efi_puts() also performs LF to CR-LF conversion, so this needs
to be taken into account as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/gop.c    | 6 +++---
 drivers/firmware/efi/libstub/printk.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index 80dc8cfeb33e..6919e28ba92b 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -309,12 +309,12 @@ static u32 choose_mode_list(efi_graphics_output_protocol_t *gop)
 	efi_status_t status;
 
 	efi_printk("Available graphics modes are 0-%u\n", max_mode-1);
-	efi_puts("  * = current mode\n"
-		 "  - = unusable mode\n");
+	efi_char16_puts(L"  * = current mode\r\n"
+			 "  - = unusable mode\r\n");
 
 	choose_mode(gop, match_list, (void *)cur_mode);
 
-	efi_puts("\nPress any key to continue (or wait 10 seconds)\n");
+	efi_char16_puts(L"\r\nPress any key to continue (or wait 10 seconds)\r\n");
 	status = efi_wait_for_key(10 * EFI_USEC_PER_SEC, &key);
 	if (status != EFI_SUCCESS && status != EFI_TIMEOUT) {
 		efi_err("Unable to read key, continuing in 10 seconds\n");
diff --git a/drivers/firmware/efi/libstub/printk.c b/drivers/firmware/efi/libstub/printk.c
index bc599212c05d..f36639886d00 100644
--- a/drivers/firmware/efi/libstub/printk.c
+++ b/drivers/firmware/efi/libstub/printk.c
@@ -136,7 +136,7 @@ int efi_printk(const char *fmt, ...)
 		return 0;
 
 	if (loglevel >= 0)
-		efi_puts("EFI stub: ");
+		efi_char16_puts(L"EFI stub: ");
 
 	fmt = printk_skip_level(fmt);
 
@@ -146,7 +146,7 @@ int efi_printk(const char *fmt, ...)
 
 	efi_puts(printf_buf);
 	if (printed >= sizeof(printf_buf)) {
-		efi_puts("[Message truncated]\n");
+		efi_char16_puts(L"[Message truncated]\r\n");
 		return -1;
 	}
 
-- 
2.47.3

