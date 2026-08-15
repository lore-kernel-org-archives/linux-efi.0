Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD1A2DF6F4
	for <linux-efi@vger.kernel.org>; Sat, 15 Aug 2026 07:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786780138; cv=none; b=a0/2+Y8sRWRuk4F/S3fphhUC74yKxXzHH14bftAIpNsLQ8hAJHPLuZGUIdWzvNKIRYcg6e6vS3rNUGmM7yEq8NnR7xL/n5emQlbOy4gWTRQD4PCMdYPPWj/4uCLza+Jk8gi35u6jkMhE2L08GoWGbwf9HPhqysj3Hd+wKoHVe2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786780138; c=relaxed/simple;
	bh=swc7XMUYTTg5ROXXdkfp8pSofnKbro08bK3LJE2L7+4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BSkEATRBwumfPZLkjP2pXVIG5e7i963Z3ZVeH14nkp2mzm4JPkzg5OFwYyT9FkhpTtdsNntVJNIsn4Y+M7gaOxK1ztoRdvviL03wY9iw0tR02GRk2DcgjWup/MvXv7x/pLTkF/sw2bFhmnxCAe/9TarJxopiaFr2/ni0MlTGfOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5msqjyt; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5msqjyt"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso16794305ad.3
        for <linux-efi@vger.kernel.org>; Sat, 15 Aug 2026 00:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786780136; x=1787384936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fu6awsi3jox/O+EssjSYPFSh+y27qDP2OcehO/CZe98=;
        b=V5msqjytl7SHtiyq7cHj0vG0sw2FfPVJBOyNztnCcigP+DpZPQP7ueNQWJV89v5j9x
         dQk6bDhKWLulO1PGhrwnfEvHxdX16kD77NrxJZEGmTKLfQhUItZVUAADjitiftm9FSLj
         4i+9HLt8IPLJ5yqb33p1Dc0zZXnJ+YC5OK4V8DB0BdoBHdB1PYDLnF21d7TiAO1HRdr4
         JzTOUNJVXyJ/PEm8HcoUuTVUkOawTI0CjQjI4IX5Skr7dEwlHZMQtpx0JcjVPAlF5rcN
         //Ks6XGwVUs1NKsFX3lZ448ee/8yxcQLXZ1VYlUB8fjG+JPggGc5MxeS2cu7J4JLf2zm
         CdBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786780136; x=1787384936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fu6awsi3jox/O+EssjSYPFSh+y27qDP2OcehO/CZe98=;
        b=P8AiyEmrvfGbYrA5pSaOvqvrXK4It8GqJhgGFa9uRCYwtUmTxXRnHTWBYOsbymntAd
         ovoDnmHN3vGBjviDOelwDqkFhwRfZZiIxER0eg2TMq2aHPjGvR8fQSZ6W6s2wP6GcMeB
         xNLXCwGjdIzJ2hjupPJAv55TYxciXwZp6EC4AKWx8BBthHMAOQg8V+mLGD3i3p8s0oxg
         7Xf/1BPWtf6UKbMZXTMS+4+lLHPHc0w89sIJ0d8uUmNF4FLm+/zTXVuJRW4iX5fzNTLi
         /iurLlC6UopzWar26UpbIJYg7iXl1PGjikwI4gBwEkSts3ALFVHEYyjlq6RRoqQ3P7QI
         FaDw==
X-Forwarded-Encrypted: i=1; AHgh+Rp2TmDu7ZEbZaQAEC9FsUc0ASWLP2jLsjEL9+Sbp5o5iMVbv/v6fPA3YCRPjC1GsvP6r1tA2Yt9Epo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/6yv6T8+QNsRDza+GcYCRfSDcVMp6LJaWrBUNl1sOQgG06ruE
	XzFGqKRMZt/eMVd1QySf5lqWTPJvVLeiEJ44YtSbYPCXMV+pk2tiNtt57LfSKpgY
X-Gm-Gg: AR+sD11t6reisPcn4DCDJSG87SzN/6bmPEYgP1DcadE8kDKTxgh+6y9Az7lehm0Whez
	WvTGO1hGDzK8eFYy4sdnscTm1Fvps9+0IrXmgr2WKj4awQt1ilzZOEe4DzDx9Hj67DziuZniDQI
	eqrY+Xkv7ukcc5u0SXjiw/R219M8BmFjv8JZiTXn8ddo/4mIh+iuaki068Og2GcQZ4FxwU5AFzk
	09V0ErGaSh4VD0ksfc67Bazpi8vlofAgxjpCRxuKZJskpgqN+/cMZBcHXm+nwxz//xvi7RFYePz
	mqTlZbqXG4WVVxDjjlRSbCKqbrttBf2xwgEGBYKH2eg7c1iqicEmKpQWsHlt/E98zbKzXiyhWS7
	PNaWP9hXm3qJD9WLxZ1gAlk8F6Q/wyoGTmOzTW5r9gbtrZLLMX4XfOVpAxhlT5wHPd1r7ogfLzN
	0AOv9Fy9Oyq/tTorLi5n1oBDoNVO6jNigvhJG4ugmErEK3La9LdN0bqBkNxk8315qEhtTX1bXu0
	7sBjCSjTtiY5gm+DeZEELs=
X-Received: by 2002:a17:902:ef50:b0:2c9:f44e:9942 with SMTP id d9443c01a7336-2d3b0d133aamr128225275ad.13.1786780136087;
        Sat, 15 Aug 2026 00:48:56 -0700 (PDT)
Received: from DESKTOP-M1337NB.localdomain ([211.241.115.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3ae753fb8sm17741015ad.9.2026.08.15.00.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 00:48:55 -0700 (PDT)
From: Jonggeun Park <jakejgpark@gmail.com>
To: ardb@kernel.org,
	jk@ozlabs.org
Cc: kees@kernel.org,
	tony.luck@intel.com,
	gpiccoli@igalia.com,
	ilias.apalodimas@linaro.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonggeun Park <jakejgpark@gmail.com>
Subject: [PATCH] efi: vars: commonize the 512-byte name buffer quirk
Date: Sat, 15 Aug 2026 16:48:44 +0900
Message-ID: <20260815074844.1330-1-jakejgpark@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some old UEFI implementations reject GetNextVariableName() calls with
a name buffer size larger than 512 bytes. Both efivar_init() and
efi_pstore_read() open-code the same workaround of resetting the size
to 512 on every iteration.

Introduce efivar_get_next_variable_safe() which keeps this quirk in a
single place, resolving the TODO in efi-pstore.c.

No functional change intended.

Signed-off-by: Jonggeun Park <jakejgpark@gmail.com>
---
 drivers/firmware/efi/efi-pstore.c | 16 +++++-----------
 drivers/firmware/efi/vars.c       | 21 +++++++++++++++++++++
 fs/efivarfs/vars.c                |  4 +---
 include/linux/efi.h               |  4 ++++
 4 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index a5db3534f..a135d6e2f 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -164,16 +164,6 @@ static ssize_t efi_pstore_read(struct pstore_record *record)
 	efi_status_t status;
 
 	for (;;) {
-		/*
-		 * A small set of old UEFI implementations reject sizes
-		 * above a certain threshold, the lowest seen in the wild
-		 * is 512.
-		 *
-		 * TODO: Commonize with the iteration implementation in
-		 *       fs/efivarfs to keep all the quirks in one place.
-		 */
-		varname_size = 512;
-
 		/*
 		 * If this is the first read() call in the pstore enumeration,
 		 * varname will be the empty string, and the GetNextVariable()
@@ -185,8 +175,12 @@ static ssize_t efi_pstore_read(struct pstore_record *record)
 		 * store varname in record->psi->data. Given that we only
 		 * enumerate variables with the efi-pstore GUID, there is no
 		 * need to record the guid return value.
+		 *
+		 * The 512-byte name buffer quirk is handled inside
+		 * efivar_get_next_variable_safe().
 		 */
-		status = efivar_get_next_variable(&varname_size, varname, &guid);
+		status = efivar_get_next_variable_safe(&varname_size, varname,
+						       &guid);
 		if (status == EFI_NOT_FOUND)
 			return 0;
 
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 3700e9869..8e69f3632 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -265,3 +265,24 @@ efi_status_t efivar_query_variable_info(u32 attr,
 			remaining_space, max_variable_size);
 }
 EXPORT_SYMBOL_NS_GPL(efivar_query_variable_info, "EFIVAR");
+
+/*
+ * efivar_get_next_variable_safe() - enumerate the next name/vendor pair
+ *
+ * Wrapper around efivar_get_next_variable() that keeps the 512-byte name
+ * buffer quirk in one place. Some old UEFI implementations reject name buffer
+ * sizes larger than 512 bytes (the lowest seen in the wild), so this always
+ * requests 512 bytes; callers must provide a buffer of at least that size.
+ *
+ * Must be called with efivars_lock held.
+ */
+efi_status_t efivar_get_next_variable_safe(unsigned long *name_size,
+					   efi_char16_t *name,
+					   efi_guid_t *vendor)
+{
+	BUILD_BUG_ON(EFI_VAR_NAME_LEN < 512);
+	*name_size = 512;
+
+	return efivar_get_next_variable(name_size, name, vendor);
+}
+EXPORT_SYMBOL_NS_GPL(efivar_get_next_variable_safe, "EFIVAR");
diff --git a/fs/efivarfs/vars.c b/fs/efivarfs/vars.c
index 6833c3d24..ee55a26cb 100644
--- a/fs/efivarfs/vars.c
+++ b/fs/efivarfs/vars.c
@@ -398,10 +398,8 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 	 */
 
 	do {
-		variable_name_size = 512;
-		BUILD_BUG_ON(EFI_VAR_NAME_LEN < 512);
 
-		status = efivar_get_next_variable(&variable_name_size,
+		status = efivar_get_next_variable_safe(&variable_name_size,
 						  variable_name,
 						  &vendor_guid);
 		switch (status) {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ccbc35479..f36505aa0 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1076,6 +1076,10 @@ efi_status_t efivar_get_variable(efi_char16_t *name, efi_guid_t *vendor,
 efi_status_t efivar_get_next_variable(unsigned long *name_size,
 				      efi_char16_t *name, efi_guid_t *vendor);
 
+efi_status_t efivar_get_next_variable_safe(unsigned long *name_size,
+					   efi_char16_t *name,
+					   efi_guid_t *vendor);
+
 efi_status_t efivar_set_variable_locked(efi_char16_t *name, efi_guid_t *vendor,
 					u32 attr, unsigned long data_size,
 					void *data, bool nonblocking);
-- 
2.43.0

