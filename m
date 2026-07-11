Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DAF3CAE8D
	for <linux-efi@vger.kernel.org>; Sat, 11 Jul 2026 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783785689; cv=none; b=jc4lKEzWyrb2jQQXkv1uQ0gxEzOw+Ae29c/y+qnkcKGn3X0zQE4A6kR+xRIb/nXgXgHe/YYwJeQTJVFtuXER310rETmEa+VSZBjruJ7IcaEFBfzlILcO/DcmNDwWcg8aKBkL09dMLn3b9E1gyw0d+VTLTMsguwIb784C0uOyoJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783785689; c=relaxed/simple;
	bh=WAHXIWt/28rU2ug/gCEyKlRd6r6MFxAWKp1tyCUWz6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIPNfNanwZJar9pSlaGdnSHkZ6hol6Dj3pwuqvbMIHKOEHoGpkxBo6iHiLYLOzR+To1Hm/78zzh1RnwJ7WNldmWvwGjRNFDlzJLH0etsQ2zpv3B538B9yMdr5GEqYjUuRqSJK+O9tsciy7ZBG4dfrW6ea/xMfV9NWnOU+mqL4VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f8jtevj0; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f8jtevj0"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-382a3fe0d28so1894024a91.0
        for <linux-efi@vger.kernel.org>; Sat, 11 Jul 2026 09:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783785687; x=1784390487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EatEz12Vd+2xKsXS+ldmzV7vhTKPvC5kQIMvkNXC19w=;
        b=f8jtevj0J9ZaC1hzkGbg8CdL5PhA45UKMQ3DNyfQ43S6ls1Gh1Og+3nbhx7zRj2mNi
         u9RM82lZv9n0GkAoNJmGzm4DFv8P1aavxiEeuFBLwNBL0gctmZs/FCFkzhE9UzH9HrPE
         jMoinfycvDFpC4xndf2sqSghl7GOnddVdQrYLHv1d8JgQWo7iA1U+hyu75+w773siWEk
         8QgNwoJSn1hXYoQSbGRZ46mYetGs+N1TV/GCt4r7ENznCCfFNF5AwPofiwj/vWMx2RlY
         6eZcnlWkvUa7LnmQ3hcicCQVhq5FyKeNDsH7/tq4rchSFSMSlfqpDZWwsbjVsb0l4RJo
         EljQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783785687; x=1784390487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EatEz12Vd+2xKsXS+ldmzV7vhTKPvC5kQIMvkNXC19w=;
        b=iWj0sJXmsPfexPy8V7FIq7+WNEWhx1J5YOYam6w7FCFdUDRADDdCkZSXVfb9DOoyiO
         L+axqicHZf1EPBFBt7Xk1Ns40gv/5ij3A3rdraGm5q9H/8+MchKKZr5Pa8Kw/QCFwFvB
         MROSAriszsqNL3ZlKxLZpt5YpERU6BauYyB1hleDAQLx2I9CYX7UZovQV5AO5/QKk+3z
         biDhnOTMe32iYz8K0Q3TaZ/vVHK036GrR6RBaW4lfEWGqlZZBkbxU2o0fPPU5WsFHJk6
         hCwLxeaxjkC/V91w/lu9ND6v1FOhWdg4HBlnmibjx+O1RfmCEkV6UGli/MxHyYwFAKLa
         1ZEg==
X-Forwarded-Encrypted: i=1; AHgh+RrWM21g4ZT6V4CmVwkahggdBjuS+2rTL3PTSkOaLVuhNznz3RgMcR7MKhn5ZPCS3qNKYfKjlNncB+M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPjmowHCj6DMGMEkAg+d4A0Vz7Po9ut2T4+bYw9I5yxE8SA9ZY
	6RGvtSs6K+SR7zhOPYLbGBR9i/m+gMLl3lKJGqG4lXhg6KXRxUcu0XmK
X-Gm-Gg: AfdE7cnoMbBhd0/FA3bFLXl/OeF9WmiY33zBFUzaVwLQ+sPBCZP/JpeZ0MVW6svKLYE
	Gu/8vmzyPV9KmLIL6boG6H/tmOsJGwqc0zlku3o87hWXuYD7ek+JXZzKSPacmbpBEi5hkNA85YE
	Y0EAoptRfV576xoKU8+1YEtaRWh07dwRxl57w3CC5kS2lW60AZ/u7OoJNS6yV4vR+ORqs8XMAxm
	iW4DmLiQ3fmZY/dKecSCQ0tcqLx70t2S/FrjomaAGA6kShxJacOGsVakPcSu34PanZzveZmpd7v
	VU5RVMVuHGzOrjL3e+iiwS7yF5d1EnASsiMvdKbHC8iaXvrYa50r5yDuqosD42vPvVQt2rG76iA
	xOHfPtOYmYd/fz+c5rhP7OXVXw4sMjiQBFtsNxdgKRnRFAooYt8caoW9ecT7OdwHbF7tGQ4ayV0
	DjP2joXFO252YS02tgefeA
X-Received: by 2002:a17:90a:d408:b0:381:50ab:1594 with SMTP id 98e67ed59e1d1-38dc774d1fcmr3402700a91.27.1783785686817;
        Sat, 11 Jul 2026 09:01:26 -0700 (PDT)
Received: from titan.lan ([2603:8000:df01:38f7:255c:dd03:30a6:e57b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3118ee6091dsm54496968eec.14.2026.07.11.09.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 09:01:25 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-efi@vger.kernel.org
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
	luto@amacapital.net,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v2 04/10] tpm: Move TPM common base definitions to the command header
Date: Sat, 11 Jul 2026 09:01:04 -0700
Message-ID: <20260711160110.267780-5-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260711160110.267780-1-ross.philipson@gmail.com>
References: <20260711160110.267780-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are top level definitions shared by both TPM 1 and 2
family chips. This includes core definitions like TPM localities,
common crypto algorithm IDs, and the base TPM command header.

Co-developed-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Signed-off-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Co-developed-by: Alec Brown <alec.r.brown@oracle.com>
Signed-off-by: Alec Brown <alec.r.brown@oracle.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm.h      |  1 -
 include/linux/tpm.h         | 50 +-------------------
 include/linux/tpm_command.h | 91 +++++++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+), 50 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 680f89d9c9f9..fa554c5ad80b 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -33,7 +33,6 @@
 #endif
 
 #define TPM_MINOR		224	/* officially assigned */
-#define TPM_BUFSIZE		4096
 #define TPM_NUM_DEVICES		65536
 #define TPM_RETRY		50
 
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 8551b24c2bff..3630b2ea6aef 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -27,49 +27,12 @@
 
 #include <linux/tpm_command.h>
 
-#define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
-
-#define TPM2_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
-#define TPM2_MAX_PCR_BANKS	8
-
 struct tpm_chip;
 struct trusted_key_payload;
 struct trusted_key_options;
 /* opaque structure, holds auth session parameters like the session key */
 struct tpm2_auth;
 
-/* if you add a new hash to this, increment TPM_MAX_HASHES below */
-enum tpm_algorithms {
-	TPM_ALG_ERROR		= 0x0000,
-	TPM_ALG_SHA1		= 0x0004,
-	TPM_ALG_AES		= 0x0006,
-	TPM_ALG_KEYEDHASH	= 0x0008,
-	TPM_ALG_SHA256		= 0x000B,
-	TPM_ALG_SHA384		= 0x000C,
-	TPM_ALG_SHA512		= 0x000D,
-	TPM_ALG_NULL		= 0x0010,
-	TPM_ALG_SM3_256		= 0x0012,
-	TPM_ALG_ECC		= 0x0023,
-	TPM_ALG_CFB		= 0x0043,
-};
-
-/*
- * maximum number of hashing algorithms a TPM can have.  This is
- * basically a count of every hash in tpm_algorithms above
- */
-#define TPM_MAX_HASHES	5
-
-struct tpm_digest {
-	u16 alg_id;
-	u8 digest[TPM2_MAX_DIGEST_SIZE];
-} __packed;
-
-struct tpm_bank_info {
-	u16 alg_id;
-	u16 digest_size;
-	u16 crypto_id;
-};
-
 enum TPM_OPS_FLAGS {
 	TPM_OPS_AUTO_STARTUP = BIT(0),
 };
@@ -127,7 +90,7 @@ struct tpm_chip_seqops {
 	const struct seq_operations *seqops;
 };
 
-/* fixed define for the curve we use which is NIST_P256 */
+/* Fixed define for the curve we use which is NIST_P256 */
 #define EC_PT_SZ	32
 
 /*
@@ -209,8 +172,6 @@ struct tpm_chip {
 #endif
 };
 
-#define TPM_HEADER_SIZE		10
-
 static inline enum tpm2_mso_type tpm2_handle_mso(u32 handle)
 {
 	return handle >> 24;
@@ -239,15 +200,6 @@ enum tpm_chip_flags {
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
 
-struct tpm_header {
-	__be16 tag;
-	__be32 length;
-	union {
-		__be32 ordinal;
-		__be32 return_code;
-	};
-} __packed;
-
 enum tpm_buf_flags {
 	/* the capacity exceeded: */
 	TPM_BUF_OVERFLOW	= BIT(0),
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index 9dd903dd6b5c..fc446a1282e2 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -2,6 +2,8 @@
 #ifndef __LINUX_TPM_COMMAND_H__
 #define __LINUX_TPM_COMMAND_H__
 
+#include <crypto/sha2.h>
+
 /*
  * == TPM 1 Family Chips ==
  *
@@ -427,4 +429,93 @@ struct tpm2_context {
 	__be16 blob_size;
 } __packed;
 
+/*
+ * == TPM Common Defs ==
+ */
+
+#define TPM_DIGEST_SIZE		20	/* Max TPM v1.2 PCR size */
+#define TPM_BUFSIZE		4096
+
+/*
+ * SHA-512 is, as of today, the largest digest in the TCG algorithm repository.
+ */
+#define TPM2_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
+
+/*
+ * A TPM name digest i.e., TPMT_HA, is a concatenation of TPM_ALG_ID of the
+ * name algorithm and hash of TPMT_PUBLIC.
+ */
+#define TPM2_MAX_NAME_SIZE	(TPM2_MAX_DIGEST_SIZE + 2)
+
+/*
+ * Fixed define for the size of a name.  This is actually HASHALG size
+ * plus 2, so 32 for SHA256
+ */
+#define TPM2_NULL_NAME_SIZE	34
+
+/*
+ * The maximum number of PCR banks.
+ */
+#define TPM2_MAX_PCR_BANKS	8
+
+/* If you add a new hash to this, increment TPM_MAX_HASHES below */
+enum tpm_algorithms {
+	TPM_ALG_ERROR		= 0x0000,
+	TPM_ALG_SHA1		= 0x0004,
+	TPM_ALG_AES		= 0x0006,
+	TPM_ALG_KEYEDHASH	= 0x0008,
+	TPM_ALG_SHA256		= 0x000B,
+	TPM_ALG_SHA384		= 0x000C,
+	TPM_ALG_SHA512		= 0x000D,
+	TPM_ALG_NULL		= 0x0010,
+	TPM_ALG_SM3_256		= 0x0012,
+	TPM_ALG_ECC		= 0x0023,
+	TPM_ALG_CFB		= 0x0043,
+};
+
+/*
+ * The locality (0 - 4) for a TPM, as defined in section 3.2 of the
+ * Client Platform Profile Specification.
+ */
+enum tpm_localities {
+	TPM_LOCALITY_0		= 0, /* Static RTM */
+	TPM_LOCALITY_1		= 1, /* Dynamic OS */
+	TPM_LOCALITY_2		= 2, /* DRTM Environment */
+	TPM_LOCALITY_3		= 3, /* Aux Components */
+	TPM_LOCALITY_4		= 4, /* CPU DRTM Establishment */
+	TPM_MAX_LOCALITY	= TPM_LOCALITY_4
+};
+
+/*
+ * Structure to represent active PCR algorithm banks usable by the
+ * TPM chip.
+ */
+struct tpm_bank_info {
+	u16 alg_id;
+	u16 digest_size;
+	u16 crypto_id;
+};
+
+/*
+ * Maximum number of hashing algorithms a TPM can have.  This is
+ * basically a count of every hash in tpm_algorithms above
+ */
+#define TPM_MAX_HASHES		5
+
+struct tpm_digest {
+	u16 alg_id;
+	u8 digest[TPM2_MAX_DIGEST_SIZE];
+} __packed;
+
+#define TPM_HEADER_SIZE		10
+
+struct tpm_header {
+	__be16 tag;
+	__be32 length;
+	union {
+		__be32 ordinal;
+		__be32 return_code;
+	};
+} __packed;
+
 #endif
-- 
2.55.0

