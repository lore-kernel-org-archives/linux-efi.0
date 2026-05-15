Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B173EFFCC
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879694; cv=none; b=Mveg6vlLtmA7PBYx0MojriS1XRB/t50Fs8JCp9gLUMIrYGIhd4gJgupJrooj9h7ObtUuX7TZXBM5CMCo+eIrUk4jWn5hwuDnTz89frmE5rbuasQFqBKGFMqqh6v0K/mfVUJpgPA8al3/X/M/naaaZj6zxbnyDvtMWI6O+UYMZ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879694; c=relaxed/simple;
	bh=1PNKH8ntc5kC54kp2fuFbfDzJKv8jvUIR3tksHCBOAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9hwunb1I10daaGcCbd4dvpIOkEMitQrONzKw6lNQVlddGIdImNDtn3rlt0TbEHw4g15liWU03LTM3D83gSZE4rYxBEUNX3zY7+ohlxeHv1zaud/apvHZjNsNcdK+godVYTlTixVnSZs02TNdrwd8pgRrUh5NmSXRh8rTb/VoZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n4B9AeC9; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n4B9AeC9"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-132c338a537so1026644c88.0
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879693; x=1779484493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Web2s5uVg47aYyCtELeKAMQeYbkPbYPk/ttB5U3wMg=;
        b=n4B9AeC9zDx0FEy61vxCAx34bh29XmU3Z5BLbMHLAWE6O/wVfLEQ7FP3ZxbJ1AoO+3
         Q4IHV3iLrro6B9OWZyJ0ySCAfr2ANN3nJAxGRaz1CK03Eoyc8cXXyFDi1p4zrIbByLoF
         G/cWmmNLtCXFwLtotFmS8RwPOGBQ8Im+/5o1GAj6F/uWiCeG+pViN8+NaZVMMiMIq38q
         cMdvzU+l67iNywwvtRHAUcUPuYfZ6kAu9H14D7UOnAwYg1752Zphkw9oNYZwOz3VTv+A
         VXOCI69Ejr5PPmdrz6GB/RqJEsB8H1kWK3SuoRQfFy01STwODufsTeKZq0c9so5S+Zxy
         guMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879693; x=1779484493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Web2s5uVg47aYyCtELeKAMQeYbkPbYPk/ttB5U3wMg=;
        b=WbCEXNu5Z6WD+0NaTe6d7G9z22dnp97dC4w9KFQdyQNc7bbCR56/HMDEfowYVmFX9Z
         jVx5DPXjW2e8m6a1lWrgIhxcAxO8+z+ba5XM2vwr9aOND5pGTorMUuM54mAp1X2UgyKO
         VYqQmTMsrhNDxKQlIml79rDyKiPkbjj2vHIr7EIvDbPsrkzP0uBtv0FWKBbEJJLbp8Mp
         bRasBV/lcZpVAeswbqMYTVskb9opFF/VLwx9wqbZOFTIeet4jP4N2ho1Y8sHeXCGUSIX
         Aj348HsAfQlKUWHffHPqmVUvAuM36KrFOBhBmdEEjwsO4KSS5T9zk6dYwE56nDJmf/ij
         vN1w==
X-Forwarded-Encrypted: i=1; AFNElJ+dOFF8iu7AFKI3SKqOWHVPUHly36xML6nVSwYQLdnFUnyasYHth5xu4wYCbF1NMsU2eMBz/2KqdT0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsNXvGJW+ExBkI9C9cVEcw+V8U5Ax6HxGu9tO8K5DfPVoh7AAL
	ALfJImwpjJMXFYG5+AJ9cB9MvSrQDcwBb6rVuKGS6D3BpOkzsIlBAXgr
X-Gm-Gg: Acq92OH/oa0bfV9UsXVubRKCHph43RJNPcKDKW6tTi2cveOxJtF96c/LOUKS+LUeYW8
	falyrCTZbGiL7tHJ6LSXsYv4vduY0lKLOwfsGhjw1WLzARvTojAp4seIby0jEOGdwyNHm+eFM/0
	CEhaTqNna0tOIBP/WradTcpxFXM7qdfzlBHMjR7s6rnwtp0I4gS3QGIkVp4QzNqWuPtMJPjYnl+
	yVV5H5JOgK2R2Su/tnrHUkDr1XtCzRTgOL5rW3+XzKN5c6v1/lQLWtqny4Cfj8ouYENsMTJbR4l
	e/fmLpWlURSXShDDz6DHSnI/pEDuq31c9EWf4O/m8oRi8vUAIDzRcVvj/h9pfAE6Rtre+EZwYXK
	OlpL8s9MMrRF4v119aShc+FGV3xQtQRzggKmKgCBawJZzoHEogoxf4sog3v44Zdzcvdca5G6uJ1
	dyHJPmedvCg8/pP3s0sacvT5bSLW9KQdM=
X-Received: by 2002:a05:7022:79d:b0:12a:6abf:ab1c with SMTP id a92af1059eb24-134ffe943c0mr2448441c88.11.1778879692592;
        Fri, 15 May 2026 14:14:52 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cc3490bcsm9740184c88.15.2026.05.15.14.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:52 -0700 (PDT)
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
Subject: [PATCH v16 14/38] tpm/sysfs: Show locality used by kernel
Date: Fri, 15 May 2026 14:13:46 -0700
Message-ID: <20260515211410.31440-15-ross.philipson@gmail.com>
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

From: "Daniel P. Smith" <dpsmith@apertussolutions.com>

Expose the current locality used by the kernel TPM driver via
the sysfs interface.

Co-developed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm-sysfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index f5dcadb1ab3c..772c4ae67957 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -308,6 +308,14 @@ static ssize_t tpm_version_major_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(tpm_version_major);
 
+static ssize_t locality_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tpm_chip *chip = to_tpm_chip(dev);
+
+	return sprintf(buf, "%u\n", chip->kernel_locality);
+}
+static DEVICE_ATTR_RO(locality);
+
 #ifdef CONFIG_TCG_TPM2_HMAC
 static ssize_t null_name_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
@@ -335,6 +343,7 @@ static struct attribute *tpm1_dev_attrs[] = {
 	&dev_attr_durations.attr,
 	&dev_attr_timeouts.attr,
 	&dev_attr_tpm_version_major.attr,
+	&dev_attr_locality.attr,
 	NULL,
 };
 
@@ -343,6 +352,7 @@ static struct attribute *tpm2_dev_attrs[] = {
 #ifdef CONFIG_TCG_TPM2_HMAC
 	&dev_attr_null_name.attr,
 #endif
+	&dev_attr_locality.attr,
 	NULL
 };
 
-- 
2.47.3

