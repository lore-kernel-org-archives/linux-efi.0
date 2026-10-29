Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793295049;
	b=ukMS3VQH7e4VXZj3u5jRycbGP9meeCwwoT7wsGTyp7CTLKAqXaBsOIdMqvLaW5xze4nn
	 ZI3vMzI/E/IV/8SBfLnsa3h6wd1jYD5C9A38LcFNx3gWzBv5/uZVX5Ha8Zfp+6nkkYl/a
	 va0HLpdJRoM5hRpJ8C08twAyML5fmLg2qPij5bRmHCUTV58QeQwDOxz/4LIhE+bKTWiHG
	 NtTkf1vFsyUW3D3qOp6QPFiWUh/BzbHwxhnjLPA9PgyPOE/tO2xEFilEehpURWkxXQzz7
	 WybO6Gkj5VCOjWi+Y+Tjha+CRPI5WcUghRzTxC5017twDaXQkZDDJPadUOi/X0IY61w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793295049;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rBVVW3tHabgwrKT2QwycDYkPKCsMYjmGYVvwfvGvrhE=;
	b=wF4BJEQKdo2YVjEpOIUPZMYrDKnJqq1rD5FLsW8cpLprRhMv+7LssoddxhZjaZEa+szc
	 qLgXe8DtyWMYstwsFvZRx9uNj4yeAEwGOWJDNUgSdChILRtH9puZcEsnMLvRiBF2BMvqR
	 FD5ul6gyBy8jXaI5YHPPBA8TikBd9zq3jW9GiHUCr+pRhuZANAA0scpnsZHAL8lZ7aWPR
	 WKpdpUVPpqvCgmy+NM34g7Y+KaYC+stGenavEvoBrUTpw/EFKpXC+wHDFC2XMSz4Xc6+p
	 fi2Thw2UrII0JksT10jeFycSgVtmd7xwKb4Ikyk6OsY+h+L9xPw1oDCes393C0k4uLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HC6izpFB;
	arc=none smtp.remote-ip=95.215.58.226
Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3539B606A32F
	for <linux-efi@vger.kernel.org>; Thu, 29 Oct 2026 17:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3539B606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HC6izpFB
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7EdBEd5XL5wRdZvYlylGxvVrrhD/K6K3u333eKYP51c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295047; v=1; x=1793899847;
 b=HC6izpFBgx9Os0a9ApbmT2Glk501euie4yvJGNNb7zQBjlxydSGvilwWczTel/QZIX6ywO4n
 MTUMT5QvMBh0ouFgHp4Nv4X3nrI2oItKbxYRkNG+LllR7xNIV3QSufQWwP14HJ5/bGcN9HFVUX0
 L2/ocLWMVGp1/+3XWj/tMaXk=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 155dc8602c7bb9c2;
	Thu, 29 Oct 2026 17:30:46 +0000
X-Mizu-Trace-ID: 155dc8602c7bb9c2
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v6 4/8] kho: Add kho_disable()
Date: Fri, 30 Oct 2026 02:29:51 +0900
Message-ID: <20261029172956.20791-5-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029172956.20791-1-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: George Guo <guodongtai@kylinos.cn>

On LoongArch, KHO state is passed to the next kernel only through an EFI
configuration table. Only the EFI stub installs this table, during a cold
boot.

A kernel entered through kexec does not run the EFI stub, so it cannot
create the table if the previous kernel did not provide one. Without
the table, it cannot pass KHO state to the next kernel on a subsequent
kexec.

Add kho_disable() so architecture code can turn KHO off when the EFI
configuration table is missing.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 include/linux/kexec_handover.h     | 3 +++
 kernel/liveupdate/kexec_handover.c | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ef2b188c8ed0..6f80e1b0ccd4 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -15,6 +15,7 @@ struct page;
 
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
+void kho_disable(void);
 bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
@@ -54,6 +55,8 @@ static inline bool kho_is_enabled(void)
 	return false;
 }
 
+static inline void kho_disable(void) { }
+
 static inline bool is_kho_boot(void)
 {
 	return false;
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 74c4633f5afc..3280533eaebe 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -82,6 +82,15 @@ static int __init kho_parse_enable(char *p)
 }
 early_param("kho", kho_parse_enable);
 
+/*
+ * For architecture code that finds, after the early parameters are parsed,
+ * that it cannot pass the KHO state to the next kernel.
+ */
+void __init kho_disable(void)
+{
+	kho_enable = false;
+}
+
 struct kho_out {
 	void *fdt;
 	struct mutex lock; /* protects KHO FDT */
-- 
2.53.0

