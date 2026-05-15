Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6A23EEAC6
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879689; cv=none; b=OvoGlbIFJrs/YzakApJADVZPfm1lu63tUMKmZNSv6SJeP5dsvc8XX9paq9QsCZktJTgse5MHR5FZyfcq62EkW6lpixlaKijGM7X4l+iSU37m41K4uRqZ+4gAioOFXJ3PiNnRfLjNLuDIGP/hy1Ag5N+s2NT3KnxvUZwofqsfiSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879689; c=relaxed/simple;
	bh=YM/w2wtPzdX3RmdPxAtDTeVwrQxqc/8DXfB4OKpz4wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqhAX5wKgJZMKB98MGSbKZYVw+nbLk7HpyQgLodr7kdCSZeazNagjVWZyQthe6cjt2RArHY6Nq0EXYb3+KfEsy/dIFVdvlqt9zXlgaUkOvQJDWrMBNhUScI5Yvr91/F1GGgX8ucn873/2vT82upmkkZlxYzwX+7ZKK0op/lMHT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=os1ZZCh1; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="os1ZZCh1"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2f0d3e07e30so1350273eec.0
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879687; x=1779484487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4LfQsLm4zjgCBkokqW/LNO8kguAx5+WYTFTmZDrk46E=;
        b=os1ZZCh1Md5gOjiBCwlPZ8Xc0AtQRHNjZE2TTlYHhwXTWbiGH1LZ28DRDrwvDjkTCh
         RF2iReOYGP8hfSbbsgWHpDOgJMDFZrrqDRHbWAZVz6+qRHDE5VimMybaJqXfo7iwu/Vu
         bL2pEabGzP2Py4vEGE+SnI+eS7oK2Z6USfzb6tHMs7uFzrK/5kqdxByPrvaKakbqzah3
         utLW/Fz+u7uCZeaSZr9GkdYoovYiDGMfK3prCTQc0Vk9DwkaxIRZct14h5X+5fvWjZd9
         4rLtBS9EMiO8Y0RlqNuQ+ckh4OomzPGg1JQ99NjlNsWLLm/r9IqF/T7RCt3ZzIRU71QN
         Y0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879687; x=1779484487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4LfQsLm4zjgCBkokqW/LNO8kguAx5+WYTFTmZDrk46E=;
        b=GK1c0srThum1GtKOyYvjdpQR6ZCd6Gp21dVXkUjAXRD0dW+TpIKc/9nxn+E1XMzbGu
         bHbAa8B6Qht6QVDGX49STTDB91bEldZqV3Y3WpkLnPbegHeJdgPJXdQn2Zb+LahyLHnH
         atCKL4MHVcBnIgcl5HF9+RflZfYawLEPdhIClkMW2kfl0NP3DwL6VXr32pNrtm1HKUG1
         CwAnKzuvD2lNPkgd0YRwHfnDcORw0FY9Bev1iiSh9N4nrhqU1STlazUltNQ5XI4Jmy2D
         bB166Q3sucCtKTz+DvSc5lEuUHnnJNNUIRhaFPs91Bv7FBV0EWlzUlA4Ojo+J8YrW5ro
         eO9A==
X-Forwarded-Encrypted: i=1; AFNElJ+AcgXBBuHQuZ79rW6MrcBh0AAi9BOyrdKLvyUE1mhdsx5009h/aZx8dTq8GVZduCv3qMYBOhfTa5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpZ7AW4P1lsO29shfC9f2QpBVpmeW+6sxQtsZuJZRrWCVn3uYS
	VdSagZzTtaB42fxaUghAs8PnZnZAUB8ZaPpyGnBSlV+OuW8duzNf7vmd
X-Gm-Gg: Acq92OGR/TwQj0iLyamEOuRy+LGuc0i8Lq9m2PAzDlzbm2kxC6bLGpRJUG2kc39Zfwc
	uEG0xIrKCA3XtKiCeLQrS82jdLmFh+dpNI50ZqlxuQDhlHEJk9tpI5lqtRGLZKJSnrwQMz007N8
	/IR8tjFjELQbgNDBGEx/UBSq75vTuwsDdzjJWNA0XjuAmHa+qCBI/HVzIrDy6dyT/lD5+X3Ibgh
	lvh9fSRYF66Phz+64k40bfO/dUTwswk7L4Oh5fW9PwpjFbjoq30l/amyQVLobChcEspQVkMWaOz
	7NO3j8nqelCgG8QFyYzZV2LyeooT0NfDn+1hDNyVPttqh3T4cwbzYKjdepYkqVT4cpBwGt2cPoi
	JpxA2L2YeqKum5syDSXDk2pAUXJsF5/gNvzM4gwAdTIIDc0wfJZ8NPWGmxavWS767+GeGTu57+J
	fDMLQvO8b08kWAt9Ix93yvwWWPwwVLZdQ=
X-Received: by 2002:a05:7300:a907:b0:2f0:c8b5:3dc7 with SMTP id 5a478bee46e88-30398680c36mr2863934eec.22.1778879686973;
        Fri, 15 May 2026 14:14:46 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30296dcb6c3sm9740068eec.19.2026.05.15.14.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:46 -0700 (PDT)
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
Subject: [PATCH v16 12/38] tpm/tpm_tis: Address positive localities in tpm_tis_request_locality()
Date: Fri, 15 May 2026 14:13:44 -0700
Message-ID: <20260515211410.31440-13-ross.philipson@gmail.com>
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

Validate that the input locality is within the correct range, as specified
by TCG standards, and increase the locality count also for the positive
localities.

Co-developed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm_tis_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 1fbb74a565f4..70aba05f4ee1 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -179,7 +179,8 @@ static int tpm_tis_relinquish_locality(struct tpm_chip *chip, int l)
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
 	mutex_lock(&priv->locality_count_mutex);
-	priv->locality_count--;
+	if (priv->locality_count > 0)
+		priv->locality_count--;
 	if (priv->locality_count == 0)
 		__tpm_tis_relinquish_locality(priv, l);
 	mutex_unlock(&priv->locality_count_mutex);
@@ -233,10 +234,16 @@ static int tpm_tis_request_locality(struct tpm_chip *chip, int l)
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	int ret = 0;
 
+	if (l < 0 || l > TPM_MAX_LOCALITY) {
+		dev_warn(&chip->dev, "%s: failed to request unknown locality: %d\n",
+			 __func__, l);
+		return -EINVAL;
+	}
+
 	mutex_lock(&priv->locality_count_mutex);
 	if (priv->locality_count == 0)
 		ret = __tpm_tis_request_locality(chip, l);
-	if (!ret)
+	if (ret >= 0)
 		priv->locality_count++;
 	mutex_unlock(&priv->locality_count_mutex);
 	return ret;
-- 
2.47.3

