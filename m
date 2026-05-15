Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC223ECBFC
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879678; cv=none; b=Tizs59sxM0L3DkaSPCiYgxPF6opC67lvEN8h4gJdeeJp/qxbMQy8KxMPDlpngVSVB1RF21oc3/fkGp04atejv2nxs0ifIILA9HBkCkHrNALhGQ6neVCHM04AFgVfDHsYLBvUimKzUHKqYvcjccuGys+1RbU/nrs22tYD55LQ5JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879678; c=relaxed/simple;
	bh=53lrliy0YE81pqMpILWMlkkyv1qPCSWN//0gQcdAdOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bqn8wYsXwOn0FuE+BG3DWWNEYcSN2aQhmAgiYXnzuK90QwfzxyomDL/ham4JFsqj/pg8EfaDlQ5/qb9xSqovmNVsF4Fv0LiRnzNpDm+cOEFntb+vF5Jv9Lcyma+xymvXMvc00Q1QvIKDihzPLi5vXksmaOoDFNrW8/39GksFBVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=coZxNLUV; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="coZxNLUV"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1354403c610so388936c88.0
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879676; x=1779484476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zaLNJCVWymRzHzAosL0l4Cb63oV8tVc7xKx597eZEkQ=;
        b=coZxNLUVyrcW4+qDpIm9h5KsdOEZWCz2mv/nyyNz6xPun9i04yI7IEbuqeCcEA0Qvo
         CgivbygcWx0y7mhjfCmX18Xhzn5RGGCZG5QjQIefM2kR6VCGk53vZyK+JaK0zwk7Gx1d
         chHzp7T1pf3t+s/JLVCigdlmd1eGo8/R3hfUzaSHyYJZRe2droz6Mi23YqCkEtxhCJfQ
         PINrqjyV0NTayQbZmjsA83XgxsDWW8qAyI3BP3aBYfb6/nnQnY4uOxlSs9Nllt9hD8tF
         d65Lj6T5vP8vOXD9/vzC8mh30K9mShaK4LbuVvMpojiNuar0rgHSi7GT1nIGWUpwBUDM
         jK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879676; x=1779484476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zaLNJCVWymRzHzAosL0l4Cb63oV8tVc7xKx597eZEkQ=;
        b=mjlbcsRicfqK0/Y6sODPGHiNleGfyp8j3q5WRTl28DrhL/KCSHAncxtRbbjqYcS5M6
         YxZB2D04wDrEhpwqNjQTpOWvrqR9/Ii1myInwPIcT5cptFz4DeMTs9hYrKmUDicZhry8
         W8E1yJE8F21rbl4tPEH31YD8A4rObOo65A+DXJtKTx6vUuYQZ5nHbrfNF64FIpZNDtEF
         xVp2H7938H5lqbaM64/H1uQXpEe6fWWn1utvGSoPf7kX2+fyQMCyVqzqW4dJzIaOvVpI
         aCxYwT/oS7hIWfAMUP3ZOwgZUfETyP57vtJonksoMHPErOYKMMALCx4mhNZcGuOgrfX9
         QT5Q==
X-Forwarded-Encrypted: i=1; AFNElJ/qi2jvgjuZE9ezgB6ghzZBVzVrGC/oDv9vnqHoJgQWkC4Rh5LpFThtvE0yu3MUbEi7TF/lj0KO9DI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy51vR6Jr2u6RwlT1EyQzt/8f8Lj+OO2/TJrVmatNZm3XbuThkr
	SJgUxIGFz1jGe3VCxz3saFdxg/4ba24FGZxGe0/JlhEeptzpbjktrVCP
X-Gm-Gg: Acq92OEaaGTI/oGed8DIRFtxK8j2w7izrS4CxqZ0VKeA76yqWqbTIlIwib3y+Nm6TE/
	6IJpO7f0s0tZRhnD9yCbKvGjjh75OwlaWlZdJvUuhzqAAzrDLikyITS+SU+cHfckw8YXDbS/21y
	JJEacABZTkrQMxMcskAhj7XWpHjRWHoFO6NCGaBw3SvaFBrTAdHZvqm3gfnk1NCbx8Qwvq/GCib
	41eoVt7iF6iciA5pwY8aohwi1mgAYmBsLeN7whBRLAyGwDoN+DqKUqsLVHvoK4O6b4QK/H7KmYm
	DLpXL5QhG3vFyjn6EDsRDGVGHDNSXwr9QjPOeLfVHYOSrHA+UrNT8pHUEseXedDFP4Q/WJSU65H
	Wh6h6MPK20eFctI0n/+It+95AcnSAeHIJDYngsYK4diXp1ArlC5T9qrL22And6OiymlcKVBi41c
	yKetvpMf9MpabqY5pVdKpDQQ7Rhi9Z6Co=
X-Received: by 2002:a05:7022:6b9a:b0:12d:de3e:86aa with SMTP id a92af1059eb24-13505642857mr2505039c88.40.1778879675567;
        Fri, 15 May 2026 14:14:35 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cc33a618sm11242540c88.12.2026.05.15.14.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:35 -0700 (PDT)
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
Subject: [PATCH v16 08/38] tpm-buf: Remove chip parameter from tpm_buf_append_handle()
Date: Fri, 15 May 2026 14:13:40 -0700
Message-ID: <20260515211410.31440-9-ross.philipson@gmail.com>
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

Remove the TPM driver chip parameter from the function
tpm_buf_append_handle(). The chip parameter is only for error logging
which can be done with other facilities like WARN().

Message-ID: <20260125192526.782202-11-jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm-buf.c       | 9 ++++++---
 drivers/char/tpm/tpm2-cmd.c      | 2 +-
 drivers/char/tpm/tpm2-sessions.c | 2 +-
 include/linux/tpm.h              | 2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index 61833b4d81f0..99811809a72a 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -146,17 +146,20 @@ EXPORT_SYMBOL_GPL(tpm_buf_append_u32);
 
 /**
  * tpm_buf_append_handle() - Add a handle
- * @chip:	&tpm_chip instance
  * @buf:	&tpm_buf instance
  * @handle:	a TPM object handle
  *
  * Add a handle to the buffer, and increase the count tracking the number of
  * handles in the command buffer. Works only for command buffers.
  */
-void tpm_buf_append_handle(struct tpm_chip *chip, struct tpm_buf *buf, u32 handle)
+void tpm_buf_append_handle(struct tpm_buf *buf, u32 handle)
 {
+	if (buf->flags & TPM_BUF_INVALID)
+		return;
+
 	if (buf->flags & TPM_BUF_TPM2B) {
-		dev_err(&chip->dev, "Invalid buffer type (TPM2B)\n");
+		WARN(1, "tpm-buf: invalid type: TPM2B\n");
+		buf->flags |= TPM_BUF_INVALID;
 		return;
 	}
 
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 1fa3e8a43c79..c9dc35b57687 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -198,7 +198,7 @@ int tpm2_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
 		}
 		tpm_buf_append_hmac_session(chip, &buf, 0, NULL, 0);
 	} else {
-		tpm_buf_append_handle(chip, &buf, pcr_idx);
+		tpm_buf_append_handle(&buf, pcr_idx);
 		tpm_buf_append_auth(chip, &buf, NULL, 0);
 	}
 
diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 3b1cf1ca0420..eb67ae14ad73 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -257,7 +257,7 @@ int tpm_buf_append_name(struct tpm_chip *chip, struct tpm_buf *buf,
 #endif
 
 	if (!tpm2_chip_auth(chip)) {
-		tpm_buf_append_handle(chip, buf, handle);
+		tpm_buf_append_handle(buf, handle);
 		return 0;
 	}
 
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 3c6a5bcc138a..b357f8971d03 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -235,7 +235,7 @@ void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value);
 u8 tpm_buf_read_u8(struct tpm_buf *buf, off_t *offset);
 u16 tpm_buf_read_u16(struct tpm_buf *buf, off_t *offset);
 u32 tpm_buf_read_u32(struct tpm_buf *buf, off_t *offset);
-void tpm_buf_append_handle(struct tpm_chip *chip, struct tpm_buf *buf, u32 handle);
+void tpm_buf_append_handle(struct tpm_buf *buf, u32 handle);
 
 /*
  * Check if TPM device is in the firmware upgrade mode.
-- 
2.47.3

