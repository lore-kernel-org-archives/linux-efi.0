Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DEE3C9894
	for <linux-efi@vger.kernel.org>; Sat, 11 Jul 2026 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783785710; cv=none; b=Jt80GpakGpCna7JNCIXBTaAn7aH3BoEDuvssmCzpx6BU1OVK8uzipi19qf26MRQyPbY7Sd1+4U04rxjPL9MoqZo1TtaCABveeKIo/EOeuLuo8jwnRbEAJID9jRacdgCYjTGEvOhxIbpSQEYTx5DXdaKO0CCqjYSQLI/CM9Y/psQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783785710; c=relaxed/simple;
	bh=mmmPhL/ghHf8mTlJKqyHo4h/T0ggIZB9mghCUZZIJHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRdYHuARw+SYD3F7gGEfDIda+ns5aY84aMePhcBGoT4BfbJgHiWDTeIZ1GuIlS1PhubMvsL4A2LiIbDcqVcArzcySXNRjGFJL8Pt1PVO4j7sKlH59srbyC4ea1fciZbDZl0Qi8mlj7kas0nlk2J+mM3baPxrm4hHPdePo4kiPus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iT6fCAG2; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iT6fCAG2"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso1823448a91.3
        for <linux-efi@vger.kernel.org>; Sat, 11 Jul 2026 09:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783785707; x=1784390507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O3xupweIjZun88NywNw0fLBjpCQuWDRT98MUrOXcsbg=;
        b=iT6fCAG2Jd3dSOYBchOLSK/BQ9vx9aWtc1KVgu4SOG/c2Gb7VKJdJ4vTizFIO91aoS
         IRAIyhoZzYx6BVN1A0kEQBL2/8XVEfZtiZfDPGfE1zssb/XDBpB5Eya2J4rQAfU23xox
         8X1aA/FF30m6mUiWrTmUtMrt1ZuyCgOzunjMy5Xs+pm5jxT0X+wNS6PpnuNdl3mDXZBP
         Yp7RN24Y049nVyWV1PY9rUOmwmwWuFQ9rn9AtKN3t84jG4L2AgIktsLeErpmyG3prNmd
         +4hlPR5w3dPVCwPHX9+Hl+FDM9nQWUEXc+5WB9xWcXgKPTt8laSU5PrpQIOPVTmkiGUI
         gQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783785707; x=1784390507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O3xupweIjZun88NywNw0fLBjpCQuWDRT98MUrOXcsbg=;
        b=sa/d2/Cdhfzuyig9uP7GDZZSbT7TlqjbGb9d2Pz72GKyGTLfn2bm1UtpQsl7230b3b
         yAK91DMc97Z1gfgl0g4EQGimEUB/X49GmDeN1TC7/exdVRxCkEcPIgU39GnCEfES8zLU
         IiadqrACN8DX6GMIQoac/ezGVbPVezn3rXovQMIF5yREeb0AvCSMLid+Z/dAMls9ZzDG
         74Den4nxSh9uWgGv5DvyIP1vQ6oqt6Awlo3sYjgEv7gA8vm9/dhefNl8F72HF5tgoC/R
         V66uDnTpeU2BThkvSEuHYCCwOCBHvcejPyjNDkYvFCcTUFoo3bQ6wAxizhlYgcQ6CrKt
         xRsA==
X-Forwarded-Encrypted: i=1; AHgh+Rr4QbXeOaMYpunENDClIqRarfK0wwnhwxKT9DU7ZGA50EvZbh7CuQ4vcou0JrpUwZ8B8VAOldnKCQ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyntJqRPcbsbR9h9EglYVJL2NeXFrgkYVHNqQF03VcIEuc0+KBk
	glo/EycmBGiqVCNt2wy3OZ/eJtUM4oHm4goYiNjGwur2LUNGD8R1cM8m
X-Gm-Gg: AfdE7cnTSJqq8PP8EhgXMmoUcWVuPLQezicx9cGZGpi41UD5CrUNK7/OrJ4981PO878
	a8FLHSW0RsB+Yk50KVzHCRt7vuCi771rffOIcHo9mxv1gOZE6Pu6mU51X7ESVuQE85GuBP6t/c5
	r/mQ+2aIVVTNX+uIP31qCXSVFi9YTDBR/3e0S90nwnUunJQY9Ahja2qCwbc4GARKoKofb7+y7J4
	ZHSBOIJeIMQtRwjQWSPLPzdFUoX0raZtGHU+QNZEvNhGlt2iB2KCrJ4GUBEb5q1HLgGZzytwE0J
	KZE1d/3d6I0b+K4Lg8TlWT/IKGDpuibl9AEqXG4or0U+wm4ZPIX0uCQ0UgFAOPgsuhoVsau4hL3
	K9Sey52/BU/e3fWipUxdzD5d9J2d8olmic0tRGGnHd7Aea7BHB3Jn9HZhm3v1J9n6v7y9mB20m5
	egYSnPVeOz5JfV3PacMp0a
X-Received: by 2002:a17:90a:c106:b0:381:20b:a9ee with SMTP id 98e67ed59e1d1-38dc74cf96amr3305712a91.14.1783785706827;
        Sat, 11 Jul 2026 09:01:46 -0700 (PDT)
Received: from titan.lan ([2603:8000:df01:38f7:255c:dd03:30a6:e57b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3120c8e41fcsm20955490eec.15.2026.07.11.09.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 09:01:46 -0700 (PDT)
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
Subject: [PATCH v2 10/10] tpm-buf: Add TPM buffer support header for standalone reuse
Date: Sat, 11 Jul 2026 09:01:10 -0700
Message-ID: <20260711160110.267780-11-ross.philipson@gmail.com>
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

Extract all the functions and definitions for TPM buffer handling
and separate them into their own header.

Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm-buf.c |  3 +-
 include/linux/tpm.h        | 34 +--------------------
 include/linux/tpm_buf.h    | 60 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 34 deletions(-)
 create mode 100644 include/linux/tpm_buf.h

diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index 1e5c11c312a8..233e81d3f149 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -4,7 +4,8 @@
  */
 
 #include <linux/module.h>
-#include <linux/tpm.h>
+#include <linux/tpm_command.h>
+#include <linux/tpm_buf.h>
 
 static void __tpm_buf_size_invariant(struct tpm_buf *buf, u16 buf_size)
 {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 598dd53a10d8..0db277af45c3 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -26,6 +26,7 @@
 #include <crypto/aes.h>
 
 #include <linux/tpm_command.h>
+#include <linux/tpm_buf.h>
 
 struct tpm_chip;
 struct trusted_key_payload;
@@ -200,44 +201,11 @@ enum tpm_chip_flags {
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
 
-enum tpm_buf_flags {
-	/* TPM2B format: */
-	TPM_BUF_TPM2B		= BIT(0),
-	/* The buffer is in invalid and unusable state: */
-	TPM_BUF_INVALID		= BIT(1),
-};
-
-/*
- * A buffer for constructing and parsing TPM commands, responses and sized
- * (TPM2B) buffers.
- */
-struct tpm_buf {
-	u8 flags;
-	u16 length;
-	u16 capacity;
-	u8 handles;
-	u8 data[];
-};
-
 struct tpm2_hash {
 	unsigned int crypto_id;
 	unsigned int tpm_id;
 };
 
-void tpm_buf_init(struct tpm_buf *buf, u16 buf_size);
-void tpm_buf_init_sized(struct tpm_buf *buf, u16 buf_size);
-void tpm_buf_reset(struct tpm_buf *buf, u16 tag, u32 ordinal);
-void tpm_buf_reset_sized(struct tpm_buf *buf);
-u16 tpm_buf_length(struct tpm_buf *buf);
-void tpm_buf_append(struct tpm_buf *buf, const u8 *new_data, u16 new_length);
-void tpm_buf_append_u8(struct tpm_buf *buf, const u8 value);
-void tpm_buf_append_u16(struct tpm_buf *buf, const u16 value);
-void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value);
-u8 tpm_buf_read_u8(struct tpm_buf *buf, off_t *offset);
-u16 tpm_buf_read_u16(struct tpm_buf *buf, off_t *offset);
-u32 tpm_buf_read_u32(struct tpm_buf *buf, off_t *offset);
-void tpm_buf_append_handle(struct tpm_buf *buf, u32 handle);
-
 /*
  * Check if TPM device is in the firmware upgrade mode.
  */
diff --git a/include/linux/tpm_buf.h b/include/linux/tpm_buf.h
new file mode 100644
index 000000000000..f8c105d8b8bf
--- /dev/null
+++ b/include/linux/tpm_buf.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Following copyright information was take from the original file
+ * <include/linux/tpm.h> where the definitions were moved from:
+ *
+ * Copyright (C) 2004,2007,2008 IBM Corporation
+ *
+ * Authors:
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ * Debora Velarde <dvelarde@us.ibm.com>
+ *
+ * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ *
+ * Device driver for TCG/TCPA TPM (trusted platform module).
+ * Specifications at www.trustedcomputinggroup.org
+ */
+
+#ifndef __LINUX_TPM_BUF_H__
+#define __LINUX_TPM_BUF_H__
+
+#include <linux/types.h>
+#include <linux/bits.h>
+
+enum tpm_buf_flags {
+	/* TPM2B format: */
+	TPM_BUF_TPM2B		= BIT(0),
+	/* The buffer is in invalid and unusable state: */
+	TPM_BUF_INVALID		= BIT(1),
+};
+
+/*
+ * A buffer for constructing and parsing TPM commands, responses and sized
+ * (TPM2B) buffers.
+ */
+struct tpm_buf {
+	u8 flags;
+	u8 handles;
+	u16 length;
+	u16 capacity;
+	u8 data[];
+};
+
+void tpm_buf_init(struct tpm_buf *buf, u16 buf_size);
+void tpm_buf_init_sized(struct tpm_buf *buf, u16 buf_size);
+void tpm_buf_reset(struct tpm_buf *buf, u16 tag, u32 ordinal);
+void tpm_buf_reset_sized(struct tpm_buf *buf);
+u16 tpm_buf_length(struct tpm_buf *buf);
+void tpm_buf_append(struct tpm_buf *buf, const u8 *new_data, u16 new_length);
+void tpm_buf_append_u8(struct tpm_buf *buf, const u8 value);
+void tpm_buf_append_u16(struct tpm_buf *buf, const u16 value);
+void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value);
+u8 tpm_buf_read_u8(struct tpm_buf *buf, off_t *offset);
+u16 tpm_buf_read_u16(struct tpm_buf *buf, off_t *offset);
+u32 tpm_buf_read_u32(struct tpm_buf *buf, off_t *offset);
+void tpm_buf_append_handle(struct tpm_buf *buf, u32 handle);
+
+#endif
-- 
2.55.0

