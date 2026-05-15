Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD803ECBE4
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879679; cv=none; b=Pm8KbYRZX4Kj3W3FzfMDWX3YnsQEJdKDMI2BCCGb+rOPLzdOo+rvIaDyvaXioqequaKF0bcnMRHtdmjK/sxG+fdTpbARrR1OKd56cdfqky1gAM8KZ34sABiPDIku4La81LtN3TQbXbaNICrpUuWN6H+ZDG0mSZgl6TEcgs1dPy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879679; c=relaxed/simple;
	bh=WimTnPb5ErtUQ91diuLvqjTS3pHvP1bJ9GtZuSv1Bf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4EiY1DLeE23QMh+hOLWgO64HEy/HDWP2ACEfbAwNt1XPLLA+Rxgtn0u+vCf9P3E/lCbPH5yzDVJOv/+DRwyxkhjCAYWmv98sGX9rBWfgPc3xF7EtIDlRcvkRyv3TzWmxafnryEBb/rwxFGjxpL1NLOu5iWmInn9k3qq0d4JgwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E2hoNZqg; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E2hoNZqg"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2f33ae12f97so1053346eec.1
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879673; x=1779484473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q5U2oXqABMo/EXd3140iU8ar3y05m7m/a9rRtZzhgJM=;
        b=E2hoNZqgN5GeQniAK6QAmAIDiaAQH2EJOxOHeRaH/grCpZD4lI/gu2odWffRqbYJYZ
         1sIxrkPPh+Cnfhx872TUjUmDUxpUkhomW9fyAJ+UJyA+RpKuTXPGEpjA2zSiaF5LExjM
         L9QD5ZvK2t9AykShyNDdayeKU0x/q0ZFgcQJLXjs9nR5IfMq2ZOa6LRR3MmqlG9zoNQy
         1yMhV+f07d+NBwC/0L76ic4bVZ5dMiSgJzi5V6opIBYUhZtKmd0UaMvsOBA3yjyljZp8
         WAixMF0vVZZIOtan39WrvH2P2hKysqizEDojDDAWydGq1X2yeBI2f71KMD8Xsbl1X7tw
         ijuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879673; x=1779484473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q5U2oXqABMo/EXd3140iU8ar3y05m7m/a9rRtZzhgJM=;
        b=SsTW9GUtXMZCd2pIjye7giIL91U5FQJa6FTiQ7SAiUrqUCFSpMH6DNdv8b3GNXp/cM
         1X8ZcuO/SEZekeNp1jWX0Nboj74Cpc0u6KpIK2VEa11ECYdsQ2CAiO+uYSeObr+mdwBf
         yq1BdBMTQwgw5gtTPne21UqO7miLD1jN7cQjKReHc9aUfuaxnCWK/AgylqgTGol3VBrF
         mvHr3ve3VD/fGii3BqeWgqCmdV9ezmDawWrhyrEHEd8WcXLN71iiIXegOxFBIYo1j6J0
         Vo3n0e//CSgasooJNgNtHpTi/UOJPPB+63v03IO3leWREEp+vMxsPluxZMZAcon1EGH/
         s4vQ==
X-Forwarded-Encrypted: i=1; AFNElJ9mIovjhTZttiXgAh5ttdtPgJx2qkQq24oi18o0nhadpslp7K3fAWV7v/Dx8PN8ORS0FaBIe2MiY74=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMbltV7cffk7YL1Uo/XgC1RLQIsbk1m9PIx++/Lmi+1+nuNJvE
	g4c7Rgl9f/8i2zyEwyYycVdA6s53XYhDxsttnHvPEh/Ec8gBPacUWN58
X-Gm-Gg: Acq92OEGCWEisVP1R9RszwUGPvjd2keZ4eNiAKCCGt7TXHaoLSfIGmhAnMFba9kh5NC
	LajVKcAaLuDGeXJyD1xpkJYJxQg9p3Zv/LZJWSvuwPAyMt0UaduwXShITWidts7smqix8aCyUed
	UtqJnjLn3tOmPhSCyiTL5omsRQhQNdR7yo8q3dls9W2EAlHbJpnLOq9b1lp+Na8ohPbqmPq/ygA
	iMfZSHtouv98LcZYuvo4RTex9l4JF9a1yCDRJLVgmLm4vAM/OOIp+SrdD6hawU5yj0f5KocVJAH
	XA8Ntkw5wlNZ4TIbisQWOS3vFzrL8LdKfCsmHsxgd342F1TWH3Rd+5solgPej/4SsGkdexkLqk+
	gzOe7bzEtTpu5WCgRWEeXO+z7TNQvnnfePGsCW/9r9OixnA8aIZxpcUZsAWRBycmjxrRGzQ1OO/
	n+U0N5ljXVYDwxeGgY2UKVkLUnyZ3dZtY=
X-Received: by 2002:a05:7300:b913:b0:2f4:3a9c:8193 with SMTP id 5a478bee46e88-3039862655amr2733579eec.16.1778879672589;
        Fri, 15 May 2026 14:14:32 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302973bc8ddsm7829907eec.21.2026.05.15.14.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:32 -0700 (PDT)
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
Subject: [PATCH v16 07/38] tpm-buf: Merge TPM_BUF_BOUNDARY_ERROR and TPM_BUF_OVERFLOW
Date: Fri, 15 May 2026 14:13:39 -0700
Message-ID: <20260515211410.31440-8-ross.philipson@gmail.com>
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

From: Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>

Merge TPM_BUF_BOUNDARY_ERROR and TPM_BUF_OVERFLOW into TPM_BUF_INVALID,
given that they are identical (the only difference being the associated
log messages).

In addition, add a missing TPM_BUF_INVALID check to tpm_buf_append_handle()
following the pattern from other functions in tpm-buf.c.

Message-ID: <20260125192526.782202-11-jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>
Reviewed-by: Jonathan McDowell <noodles@meta.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm-buf.c                | 10 ++++------
 include/linux/tpm.h                       |  8 +++-----
 security/keys/trusted-keys/trusted_tpm2.c |  6 +++---
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index 4c4f450630df..61833b4d81f0 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -103,13 +103,12 @@ EXPORT_SYMBOL_GPL(tpm_buf_length);
  */
 void tpm_buf_append(struct tpm_buf *buf, const u8 *new_data, u16 new_length)
 {
-	/* Return silently if overflow has already happened. */
-	if (buf->flags & TPM_BUF_OVERFLOW)
+	if (buf->flags & TPM_BUF_INVALID)
 		return;
 
 	if ((buf->length + new_length) > PAGE_SIZE) {
 		WARN(1, "tpm_buf: write overflow\n");
-		buf->flags |= TPM_BUF_OVERFLOW;
+		buf->flags |= TPM_BUF_INVALID;
 		return;
 	}
 
@@ -176,14 +175,13 @@ static void tpm_buf_read(struct tpm_buf *buf, off_t *offset, size_t count, void
 {
 	off_t next_offset;
 
-	/* Return silently if overflow has already happened. */
-	if (buf->flags & TPM_BUF_BOUNDARY_ERROR)
+	if (buf->flags & TPM_BUF_INVALID)
 		return;
 
 	next_offset = *offset + count;
 	if (next_offset > buf->length) {
 		WARN(1, "tpm_buf: read out of boundary\n");
-		buf->flags |= TPM_BUF_BOUNDARY_ERROR;
+		buf->flags |= TPM_BUF_INVALID;
 		return;
 	}
 
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 3630b2ea6aef..3c6a5bcc138a 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -201,12 +201,10 @@ enum tpm_chip_flags {
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
 
 enum tpm_buf_flags {
-	/* the capacity exceeded: */
-	TPM_BUF_OVERFLOW	= BIT(0),
 	/* TPM2B format: */
-	TPM_BUF_TPM2B		= BIT(1),
-	/* read out of boundary: */
-	TPM_BUF_BOUNDARY_ERROR	= BIT(2),
+	TPM_BUF_TPM2B		= BIT(0),
+	/* The buffer is in invalid and unusable state: */
+	TPM_BUF_INVALID		= BIT(1),
 };
 
 /*
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 29d79c05ed6b..779a2e66ac20 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -312,7 +312,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	/* creation PCR */
 	tpm_buf_append_u32(&buf, 0);
 
-	if (buf.flags & TPM_BUF_OVERFLOW) {
+	if (buf.flags & TPM_BUF_INVALID) {
 		rc = -E2BIG;
 		tpm2_end_auth_session(chip);
 		goto out;
@@ -328,7 +328,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		goto out;
 
 	blob_len = tpm_buf_read_u32(&buf, &offset);
-	if (blob_len > MAX_BLOB_SIZE || buf.flags & TPM_BUF_BOUNDARY_ERROR) {
+	if (blob_len > MAX_BLOB_SIZE || buf.flags & TPM_BUF_INVALID) {
 		rc = -E2BIG;
 		goto out;
 	}
@@ -441,7 +441,7 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 
 	tpm_buf_append(&buf, blob, blob_len);
 
-	if (buf.flags & TPM_BUF_OVERFLOW) {
+	if (buf.flags & TPM_BUF_INVALID) {
 		rc = -E2BIG;
 		tpm2_end_auth_session(chip);
 		goto out;
-- 
2.47.3

