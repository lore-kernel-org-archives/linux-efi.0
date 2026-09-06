Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088383CE49E;
	Sun,  6 Sep 2026 13:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788700130; cv=none; b=LbgQaFC1C3Ad7fzuJbBCnV4JYC3J5aVmbMnft1yH0IKpLspGKR67vvQ2PKFjWrqggaTM6NxINIa2f3ny4i8jknS0mdbBnCB0h+iLfBsoQ6paHWdxy8O3BEEPUQNzX1xNF6apVy6zg9HHkQRENejdTZAZZdmJavUy/xi9k3fldYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788700130; c=relaxed/simple;
	bh=h1rkn8iLXywePMTn/eVvCM8jJqNXN/zvpLjGK71QOc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akhG0oBID54jOj8LoM0NGtd3qdMddjInZTUPUyYjA+hGyjrJOP4S9a/jhih2xfBH7YaD5i+YPAgB2P03/0SQR+V6GRW/kL3LStfg8iIKNqVJbdltttuDji2pnrQT6BrYDP209tXncPQv6sSm06pDOIOK8XibGcMZ4wTLn5pt0UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0Qz3FWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0Qz3FWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC241F00A3E;
	Sun,  6 Sep 2026 13:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788700128;
	bh=rq+Ezv3ECindkaMlHExJ+Xf+msAjcLNpA2hBCU14dJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G0Qz3FWcjLgmTHp5OzHVXggaFaCPBF1KkIai60D5XNxIumDDGZhZz0ceK1rw0P5Dy
	 EWBzHaKIu72bl5S98rtKEn/ww+/ApZRkkE2NfRSZ0QpEdB/Q8jScGpWTjXnjiWarAK
	 s0xkuPx7Iv9Z/+++2DH8Fbi3oolevLo4kJjtBMaRTAWmpEXCeJW4/FbcTSYhTsm2UN
	 mENYE8aB7pjI2caxWPhE68s+5Y/o2WcY48DxMJbDeepBggKEGlhRt5stbmB5bjTYHa
	 GyPjs6vKCXxhTOW3XVgGp4UTQU9IGnngbCwP92kIumeK3Yjund1QpK/HuDUQQgt7d6
	 z76Tp5H9Wr3nA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Vincent Mailhol <mailhol@kernel.org>,
	x86@kernel.org
Subject: [PATCH 7/7] efi/libstub: Add efi_snprintf() to construct wide strings
Date: Sun,  6 Sep 2026 15:08:25 +0200
Message-ID: <20260906130817.1151961-16-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906130817.1151961-9-ardb@kernel.org>
References: <20260906130817.1151961-9-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1771; i=ardb@kernel.org; h=from:subject; bh=h1rkn8iLXywePMTn/eVvCM8jJqNXN/zvpLjGK71QOc8=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWtu6nmnh3tz1jQ9VzEy6+ObxqXJ0BV9oZND0Nq8z86P5 e7O1yc7SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwEScDzIyNCwsdS13Yl+zzqJ+ mqxotaXPBT8JhebGSyvnsuhtnDBPm5Gh/Y+DpwFvY3vGta0RMc8PPFzFNEn/xNRbKQmrffZ4b/v IAgA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

The native EFI character set is UTF-16 (or in practice, UCS-2).
Implement efi_snprintf() to construct UTF-16 strings using printf style
templates. This will be used in a subsequent patch to set the
LoaderDevicePartUUID EFI variable.

Link: https://lore.kernel.org/all/20260903-efi_stub_bli-v2-1-dbf7ba915117@kernel.org/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efistub.h  |  1 +
 drivers/firmware/efi/libstub/vsprintf.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 36056c624782..880c1d0c464b 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1084,6 +1084,7 @@ int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
 		  bool crlf);
 
 __printf(1, 2) int efi_printk(char const *fmt, ...);
+__printf(3, 4) int efi_snprintf(efi_char16_t *buf, size_t size, const char *fmt, ...);
 
 void efi_free(unsigned long size, unsigned long addr);
 DEFINE_FREE(efi_pool, void *, if (_T) efi_bs_call(free_pool, _T));
diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
index 4c11cee6c722..0c1000ccfe71 100644
--- a/drivers/firmware/efi/libstub/vsprintf.c
+++ b/drivers/firmware/efi/libstub/vsprintf.c
@@ -507,3 +507,14 @@ int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
 
 	return pos;
 }
+
+int efi_snprintf(efi_char16_t *buf, size_t size, const char *fmt, ...)
+{
+       va_list args;
+       int i;
+
+       va_start(args, fmt);
+       i = efi_vsnprintf(buf, size, fmt, args, false);
+       va_end(args);
+       return i;
+}
-- 
2.47.3

