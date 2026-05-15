Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A743ED127
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879714; cv=none; b=mvtLzXKWXfGi7SfDsAHCIvJz6ONxMOVvdv3Bo2CrNuJ1SJ8Fqbc+pJFEhhqnjbABMqDLaYtkemNl1GIPLku+sfWR9L8LEIBl3UHht5JwKwYD/NfvXnn4Z3kR88tyQNsnlL1vZpm7mEo106wBkr5G5wwsCeNa7HKOhHFk87CSbxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879714; c=relaxed/simple;
	bh=9qOiZjuMb85ewhTujam6wtmPKlWhsGUjRgHlaJ5hOXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpLQO8WKtiGJ2Z87LqRnb+0oVeNXxaTVvPpmGDe58D7sN1so0DXJK/QCy8MmC0Hp7wXbd4ncRfFkBh04lik6ZjJ9oeBgrysIU1fp4NL5Qqer94SuzP59zN8ZJOJDrbdA7GAoCk+XQthJSlrVzZKvf3CcZ4NxB8Ru9zU/gtlhHRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hbS/LYf2; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hbS/LYf2"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3025d725a05so926266eec.1
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879712; x=1779484512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EseM1chjBypSoW0cp1ToXZvQ5KcO5EkTarmMMC63WUM=;
        b=hbS/LYf2dD1jw9aPBJqPXtrlyu6t+yl4dboWGs4zK1tvEQi2kZV761lDWhXi9oqxw0
         LNnhI6Sy7QZcjjWWYFWuIdyhAFkaA3nrxxjFNi7qNxEkKRTQ2ey/HdhWvQ4ibAQ+TECl
         82EVN3y6kfnl0qtvHMP1N92u42OmIb3325YRnwq4IiX45yedpdB//tKR8L1ZCZRE9o60
         AffvmAizY573rtdjdT/VDLfMPJAaG8NCM3KhKh7K18UD2Qv2f4pOJ59SI4OfkA3F64cK
         fxRnpyaanO93DB50OAou6rWfvNG5Y/qTtjqt51dmW5FsRtx4Yef0RtxYOT/qa24UJRdN
         0Ipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879712; x=1779484512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EseM1chjBypSoW0cp1ToXZvQ5KcO5EkTarmMMC63WUM=;
        b=NC/qDNj6WvLJT5k+z1k9frtNnqXcXSO537wU0CSml4PBxYaIkqCJ5CXHqPLH9uuLTv
         tvvlWOezpfzXfOP3OXCAypcWJiKjKnxg4/07K75V+t8qvhrmv7UjIOqqcVESzzFBH/Ve
         sdGf+BF8yn7t2ZKUxiAtx2gVD69HV/XAmM4Vv0+gh5mZ+JFQ6n7muFXcpGfCQwnNAkzR
         BZVCaUpQV1/mLoD+IQi9V9/9P06ErCjzmf7QDg/68jfBZ+tBuT+zLHC8HxNHjoXnuC+V
         aYguDzG06dyz+yDNPuU6IF1+/dQ9JKUcEJ7LwQLbhzJU5d4sfICWhxPeLYbaGTUAAEIz
         kwgg==
X-Forwarded-Encrypted: i=1; AFNElJ/wiBe8S7RGOtXLWyZizd+KFFtWI0KmzV8K1tyZk3Wa76uPWgGibZqQgPmvpogeRIaLOFS1nOkYRi4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPLxK1w7K1xIQ3uwm46Nzi+Q/0euVV4qO5fEouAu7T0PmWoOyr
	FHp5oL9VQuDvxONpDQd9uySdN3ztax6y9Vx4o8UQmIU7fr9DyNktdMes0HJZsHDm
X-Gm-Gg: Acq92OEn9iBzNeNELpUri80J5mbEYTrsxE6E9Q9mSNc7SBH4ORUNPD1jlpLtOjDEZE5
	0e8YSiIUIsGii9Wer1AjDQ1SlwsuXhZa1kf6FP76RvczKMjDbjC13Q0Nk6c8xz/0y/pf8i5FdY0
	Th1qhkxXjNvIWZ5KSGUxF4apZLgj9Hy8AlApVEEkFdgkdZ8bmE1nSQwOTBxNQcqil0wouiV8M23
	yCVSXUP52gATpyuF8FD1HNPOvMzSofDoOyQAE5Te1EcAYfIAheIDjJkwWZnmnUxnPWHIl7aILit
	bL4v0tQ7SdYiIsSstZM11iWwqtViss9D458139lS0RkrOjJcif8k8fFAgR1MGzNQvzCIv74/uoS
	7LFvctwWWfKX62STy9VezHFq674zwdLUGIDo7yyBJzaD+iTkMlgC2CzC/mZNYZom1FTNbagqk9a
	T68CfPZ9KIwZy9AqkFGWj5ygi0YPNwLLg=
X-Received: by 2002:a05:7301:19a5:b0:2ed:e17:d50d with SMTP id 5a478bee46e88-3039868c8bcmr2807177eec.32.1778879712290;
        Fri, 15 May 2026 14:15:12 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302978ad18asm8003129eec.26.2026.05.15.14.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:11 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 21/38] lib/crypto: Add SHA1 support for pre-boot environments
Date: Fri, 15 May 2026 14:13:53 -0700
Message-ID: <20260515211410.31440-22-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow the SHA1 library code in lib/crypto/sha1.c to be used in
pre-boot environments. Use the __DISABLE_EXPORTS macro to disable
function exports and define the proper values for that environment
as was done earlier for SHA256.

Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 lib/crypto/sha1.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
index daf18c862fdf..f30b5ff3b31e 100644
--- a/lib/crypto/sha1.c
+++ b/lib/crypto/sha1.c
@@ -125,7 +125,7 @@ static void __maybe_unused sha1_blocks_generic(struct sha1_block_state *state,
 	memzero_explicit(workspace, sizeof(workspace));
 }
 
-#ifdef CONFIG_CRYPTO_LIB_SHA1_ARCH
+#if defined(CONFIG_CRYPTO_LIB_SHA1_ARCH) && !defined(__DISABLE_EXPORTS)
 #include "sha1.h" /* $(SRCARCH)/sha1.h */
 #else
 #define sha1_blocks sha1_blocks_generic
@@ -207,6 +207,12 @@ void sha1(const u8 *data, size_t len, u8 out[SHA1_DIGEST_SIZE])
 }
 EXPORT_SYMBOL_GPL(sha1);
 
+/*
+ * Pre-boot environments (as indicated by __DISABLE_EXPORTS being defined)
+ * don't need the SHA1 HMAC support code.
+ */
+#ifndef __DISABLE_EXPORTS
+
 static void __hmac_sha1_preparekey(struct sha1_block_state *istate,
 				   struct sha1_block_state *ostate,
 				   const u8 *raw_key, size_t raw_key_len)
@@ -302,6 +308,8 @@ void hmac_sha1_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 }
 EXPORT_SYMBOL_GPL(hmac_sha1_usingrawkey);
 
+#endif /* !__DISABLE_EXPORTS */
+
 #if defined(sha1_mod_init_arch) || defined(CONFIG_CRYPTO_FIPS)
 static int __init sha1_mod_init(void)
 {
-- 
2.47.3

