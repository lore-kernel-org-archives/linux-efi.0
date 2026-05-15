Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B384C77A6
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879717; cv=none; b=ZwrfKQUAn7p/Micyu/LtdB59k6nRA5AC3H9pLH8bA99dz6iM+EwDMvm2v9fyKpmChs1Zh/QtvpBIg2lgMqtDibtl8G31hJbuN1UfTyJBwpZWE7kPWjflnyfswAd+Jg5FPqZ+QvQaC2KqnWoK5yE3GABv5tz1VP9GtoFfDw2rv+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879717; c=relaxed/simple;
	bh=7BAv62SCJAZd+nbTYMXdF5QJlgc01qXtbND56r+tijw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNJcCsdun2MRF/kjlkExLmXWh891G0pHUTbK6GIWxW2ssQvnEt8eVF2rcjH+z/e+rtl7+P7t0yE5H6H8sjfM36/knTmUAuu3/bYde55QwnSES0x6TJUbeXDeetMgVls8JdYm0FtQrNKsMrqnmrmXRYS7nOgNQJnDm2FuD3SV9fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NNLKh2Ja; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NNLKh2Ja"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2f3c623322bso1044653eec.0
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879715; x=1779484515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpW1a/fScKIJOJjIsuP4+bGqNlbA4fQX64i8+rdO0zg=;
        b=NNLKh2Ja78Xg7YtTOJnXXrJO3+1web4zIBvPZyZZjN3nXzCs5iNssEUVficdqe3NQq
         2Ch+FsviA0JHGUNEUHj+op4que+AYQY/kcO4XMy8ivf7STGAi/zNN7UAI1WDYx2IpkP+
         1zR5mNKwxB8V3nOiJEX9J+BtjNGEaIHEG61Dx+niQlhjaLnEuIvtCbpsgAKmOhjjN0IG
         D6TQMwFOq+D1z/OZiCdR6jvuxrrutyZQw+tIvLXkxIG4SMJSnB6TDS+xa4qiKGC36DCW
         oFs+Vt1gpdouFFwNzklH2Q1Dw2UlB/cUvflsjn2gEjePUqb2JIt1EPxSjNxsOp3LTwGZ
         IU2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879715; x=1779484515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RpW1a/fScKIJOJjIsuP4+bGqNlbA4fQX64i8+rdO0zg=;
        b=nL/8o6CLbVQ6k11/ckVrwnvj56+8MKTzxYX4n/B5jX8fIOu5GEpC40WUh1olPEESnR
         cLPs53U2xPbYrbvELwxutd8ya/bE10A31InddszYWPeWNbkHEkscMdc+UI8aJzQ0eO57
         4E74kVbjVV0ivZVI1evfEa1DHbHWih7hlUwtGMuG32sAbvNiifqPKVIUXNSCPDv/aw4N
         i+3haMwmj6yXwq+JJ380nbvyVuIK/J9IUOBPhWV+Fi3mU7Qtm4xN2OQ3igHRFDBsxn6L
         467djL4jF/jRx6Q57ihYD92/nexINB4DGrvrC8gal1QCMBMNDsIypMfQiIiOeSQ6gRxE
         t87A==
X-Forwarded-Encrypted: i=1; AFNElJ+rd/Ep3e2z/ZF2piW2lqzXA7gjfzC2SiqM7P77tw9T6XSe7cwzMsXnXlX0H6Ay06YwdWgxOe7ma0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlBYACNX7+3OuzRO3odu539/CVKr6R8Gzhbvc3z1x6J6MGupOg
	wXXxQ6UxHxq3wZ0K/U7rK/Pzlg53oxa8lVc1PSNb5C9m1P3BNEwrodTl
X-Gm-Gg: Acq92OHICGVIkraQzrjlu65gZUuujHBT0/HtZucPD1eDugPcKF1S5gzIDCT3zwkMx/q
	/uk+3/cC8zoDtcyxFghe1N6CgJehaA10IjrZ87uVjQ0rwhX8cgNVxKeI4dd7+ygT649MK8ESXBh
	FeJAAtK4fFWcmXwgsYpSckP1Ap6rh/nTQ/0Dgai7RWGS8Oyg6PZV3OxAUdHDPcBVLIVl+TxKYBZ
	bJ9bSKcmTPiKXtLvVWMa/rB8ka4JrVy5m77NALG5C/RQceuscnn7+WW3mX+uCmZmnM5e+U6GyHr
	/dhxVyhh+b+p8RgBUZU7gjgyhCj+yi6rJxESG0VuWpI8nDYbCNbGj3091ZojuULcg91VKoChpdL
	lVBlZphEegF2ympfFXFlj+V3U1GmbpyE2AdlUWOeyMaMuRt1Q4uTgHGpPls91pjGPGGM5GDHNTl
	pNojnqV83/QQQzDsW3oB7DPoAJdjpZfk8=
X-Received: by 2002:a05:7300:a94b:b0:2be:142f:d499 with SMTP id 5a478bee46e88-30398678a39mr2873251eec.16.1778879715061;
        Fri, 15 May 2026 14:15:15 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302978ad18asm8003208eec.26.2026.05.15.14.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:14 -0700 (PDT)
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
Subject: [PATCH v16 22/38] lib/crypto: Add SHA512 support for pre-boot environments
Date: Fri, 15 May 2026 14:13:54 -0700
Message-ID: <20260515211410.31440-23-ross.philipson@gmail.com>
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

Allow the SHA512 library code in lib/crypto/sha512.c to be used in
pre-boot environments. Use the __DISABLE_EXPORTS macro to disable
function exports and define the proper values for that environment
as was done earlier for SHA256.

Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 lib/crypto/sha512.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/sha512.c b/lib/crypto/sha512.c
index 605eab51aabd..160e81d86da6 100644
--- a/lib/crypto/sha512.c
+++ b/lib/crypto/sha512.c
@@ -133,7 +133,7 @@ sha512_blocks_generic(struct sha512_block_state *state,
 	} while (--nblocks);
 }
 
-#ifdef CONFIG_CRYPTO_LIB_SHA512_ARCH
+#if defined(CONFIG_CRYPTO_LIB_SHA512_ARCH) && !defined(__DISABLE_EXPORTS)
 #include "sha512.h" /* $(SRCARCH)/sha512.h */
 #else
 #define sha512_blocks sha512_blocks_generic
@@ -250,6 +250,12 @@ void sha512(const u8 *data, size_t len, u8 out[SHA512_DIGEST_SIZE])
 }
 EXPORT_SYMBOL_GPL(sha512);
 
+/*
+ * Pre-boot environments (as indicated by __DISABLE_EXPORTS being defined)
+ * don't need the SHA2 HMAC support code.
+ */
+#ifndef __DISABLE_EXPORTS
+
 static void __hmac_sha512_preparekey(struct sha512_block_state *istate,
 				     struct sha512_block_state *ostate,
 				     const u8 *raw_key, size_t raw_key_len,
@@ -406,6 +412,8 @@ void hmac_sha512_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 }
 EXPORT_SYMBOL_GPL(hmac_sha512_usingrawkey);
 
+#endif /* !__DISABLE_EXPORTS */
+
 #if defined(sha512_mod_init_arch) || defined(CONFIG_CRYPTO_FIPS)
 static int __init sha512_mod_init(void)
 {
-- 
2.47.3

