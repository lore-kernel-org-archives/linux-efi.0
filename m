Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEE23EDE42
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879685; cv=none; b=MAKEiiGGBpFGT1t5nVMtMzllrRr3Xd6aTe1c271NQBfSN/pB0C1cDBl0ieFhxT28YsKko/34HMEPdZQ6ApuSma/RSM4cHL8iSVBef9wUvWUdD2j/EcVwytCRriYHx75Aka9dcgIJFkMQbbp5pUMNdySJiNsTa1FREiU14EfT/aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879685; c=relaxed/simple;
	bh=nAjY4qir7F1ZCb9sP0iaASf/Q4ek1ELKrjEEDlH4RuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQoACya7WnqQmLX9r1Fes0cCprsnbuyhSHj1J4AQXHiRnsBH+nKWF6fJF0z4S1WVohUePQEPDXHbyda5YCUsXuUHMkJVaXoce/fVMH1mWJacSbev+Npklk+FeZvHhOFttMFISoLLt8GXrOfzNz61LWC/hxBM7EQ2o8ET+LTX3cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMt1JGv/; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMt1JGv/"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1329fc4bf77so360291c88.1
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879681; x=1779484481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6vamoagHMf4GbheCVmViNC3dNcySHzOx3Jk2wuZ+G0=;
        b=kMt1JGv/t/PApi4zH2l6JC0oM4q8sbVYdiieItDRPnWX+QyHj4LKYKASLJvT3cmuF2
         nM+4V2UwPx9QF6/jXnpo+pcpbNaXLlnKXK6mwGMGkr8iMr1662J4oytEX28j7ExSNnM/
         8pCnPslcCOEzkKQ8YPxxhpb4pz7/QVB4Uim61/HpKLM3ae2WHDGjAXzLR4u+U1N/hNn6
         nDmqqE0+yhabh4vtuMGgDF9iZmjkG0rieF0FUHMPowWyVr75Zxzvq5twUKlRkpBcxXNl
         ahg5tSd+BFQ5TkUfsOumYV+j4jKdfOOLWNBHc4A/yJ0XzQ93kDOv0S00WbN0DvK7pMb0
         3wsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879681; x=1779484481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n6vamoagHMf4GbheCVmViNC3dNcySHzOx3Jk2wuZ+G0=;
        b=GMWMc1qiY6K728hd3UVBmi3P6EYCE236a4K99PHuMSb/NRrEHwPRB8smSWRi9lfG4J
         me0ipD1s8zVOWhr51kdTNrGcAo2KBW8+GO3whXOGaakEHy8calzuuuoRLV3Jwt4EVCpE
         bDkFuI1ZRvWsK392iDvi81VjvirfcRl5vJ9bI5tkjbCT0u+zKCh8guzQVViCwRIJJ8qq
         Nu+po3vyvmjXpxC5xKH8GKvd7poG1SnpVIZdibprdhgtzV+HJT6Ap1FUW8Iv6lmqv0R4
         qxEund/LKfMhkrL46reEWwLrYimyy9wiRJogXhs4awvljl5ioehlzrjaL1rsiWhlQmgE
         MoCA==
X-Forwarded-Encrypted: i=1; AFNElJ8xXNMBR+OAO96AEQ7J7C7V5p02D/hfUaIe2D2+RHpO+udSI0I7xpLrHAZM+uLh8l4RNSLi/eMWIb0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq1ftiB6uDMQl0oxds1Y+U9AtmiNfIeQE0nDaIxLaffRpgzBgV
	8JeZTQXJpGdBk0R6AREZIlN2yErVE14CYUb4t6a7MRQqQKsEg6eifNsd
X-Gm-Gg: Acq92OFpzWbShNdP7a7ZVjsNYZ7yO7uK9P2U6MCsI1wLZPWrKH86LcvYisw2Webx5MW
	EFloVxQhrLjoxDIJU1LtOwcsyMHfoekBTwApWOhoIwGIjOt5RqduFpQ/u5UZVxWF8fsomvejSaz
	xC2odMHEE2FONtD64KVAnpvGVSEqxTevXq6riTH374ZNWdkv1EpuEYbhqGuA7+2wI71+hkvaQaY
	T7J7ak8VOO+VB1cxgI539VGBFaAtpNOwvqjWT/aNNfS/mFD59iHoJ2P53h5x6qHmn0WVCUDxXO6
	79K9cGVPJZHmj1T71sXorqMFTF4txyYT6F4atoOZnjBh8o6rPS+uoMQgiJ4Mh3sFIvb7LfXxOBI
	agaY/KlHMLgPKjPZLTVioqC2xK59xLqqh1bboflJ9kRKFxaFtrz3ifShzFAOypettu4DsmdclCW
	Q93O1J2Ppf5CXSnaIbAvbTuy52/mC2/Qw=
X-Received: by 2002:a05:7022:f10e:b0:12d:ed19:e6aa with SMTP id a92af1059eb24-1350494e78fmr2605508c88.33.1778879681459;
        Fri, 15 May 2026 14:14:41 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cbcb9ed3sm11076036c88.1.2026.05.15.14.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:41 -0700 (PDT)
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
Subject: [PATCH v16 10/38] tpm-buf: Add TPM buffer support header for standalone reuse
Date: Fri, 15 May 2026 14:13:42 -0700
Message-ID: <20260515211410.31440-11-ross.philipson@gmail.com>
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

Extract all the functions and definitions for TPM buffer handling
and separate them into their own header.

Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm-buf.c |  4 ++-
 include/linux/tpm.h        | 34 +----------------------
 include/linux/tpm_buf.h    | 57 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 34 deletions(-)
 create mode 100644 include/linux/tpm_buf.h

diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index e79a8071c9ee..e81ce7215b1a 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -4,7 +4,9 @@
  */
 
 #include <linux/module.h>
-#include <linux/tpm.h>
+#include <crypto/sha2.h>
+#include <linux/tpm_command.h>
+#include <linux/tpm_buf.h>
 
 static void __tpm_buf_size_invariant(struct tpm_buf *buf, u16 buf_size)
 {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 0a56f6c1ea98..0db277af45c3 100644
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
-	u8 handles;
-	u16 length;
-	u16 capacity;
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
index 000000000000..7f8abb59de24
--- /dev/null
+++ b/include/linux/tpm_buf.h
@@ -0,0 +1,57 @@
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
2.47.3

