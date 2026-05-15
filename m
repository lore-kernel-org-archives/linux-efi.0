Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C783EDE64
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879700; cv=none; b=aXxKrPuc44CVaCTIgFkwlxBGCOVi+T8+DmqRyNXS020RngjPFKhoRgz8I982kuxO0dOsjWgygaTlqfqV6lB9LjDk/VM9HdJBn6zaVkcPoDrLqud8CaO1ERA2Rcmf9SH6wuXmYY89JTI34FbNm/s0+G+fvooIWDI6Kr3M+rZ2xzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879700; c=relaxed/simple;
	bh=/w4xIQd+FodWBf21xbEabPQcoqxxR+rnVAOAKm/PKP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTWQylY8aZ+sVlGQJvAEquF6rMdIML+mnoWeJQq+hnfmoRIvfRJFB923Z0dlgsr16N8tSGPQwgOFkfn0onQBonCLS5Xgbd/f5YkbEvSCMvVQVHUe7XdWo/GJn30u1+oupez0cfJVGoUj9jaLbc5VmUEzG1PoSQZ/UezPLdQd+lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NAUkQYe1; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NAUkQYe1"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-30246cfd41aso1511244eec.1
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879698; x=1779484498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFOHDGCsOHbtZzrbMRrMDpLy4uq6fKhTRLiSKMVovBw=;
        b=NAUkQYe17YCwOkozqdU8CpMHWdUFgHS6zfI0Ca2ILTLzMf2tiipFVvSkcGZcm/Vgv9
         f8KEgse7WVm8d40kJddfU5qHJ7TbmtZZ9ZkaGR+rzkMct56vQpK5+h3Fsjqf42Di81AP
         zXblzjiLSj9yR7kZYhaSZlfFC+m78FgXqQNMD2x7IUyePyMWN5Ejv6UozaIP747+A4Af
         olt8sJ2zM8qz67HNBxVo8J3K33CGhOndM/yfhuS40Pm3WRAfEiYHCe+zPCzvX2U0wWSz
         ZRjNUNmR1iPXSD1f82xgt6JlXOYaYMNiuh0+zcrN7zOI6ZQzCGbFqcQipX9Qf8piThzb
         ybFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879698; x=1779484498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aFOHDGCsOHbtZzrbMRrMDpLy4uq6fKhTRLiSKMVovBw=;
        b=BLy2K1FT5v4b45VTCrE+oyiyCugBVYz7U4sAsBdNtIMEHCkDXhC1jpggFR0+4ANJ7p
         dvW/f2OgLgheRdQ0dR1CKIdAXvxGnvYPr8lPAt0AJRnDd18wbvy4olSvm01Tk4bBcDd0
         B45wzSvLXpFD2rmHFD7sh8qa7isFJ/M+h2PDo6Uoxz5zDvzyZvOjRrsVRlHZNlqSXkie
         jmPzmBjraGJZfKphBS1z/41jtgPfrgQ6+nOzyXkoDrsycq+TCIMbQlkdns8V5Oze0Gxo
         3wjF9bTVtEfft5imZu+i4PIFIh/zI3FpjQ1qp7wQLeBbeMLvR1zA7o2YeCdc6xu/U+oW
         1olg==
X-Forwarded-Encrypted: i=1; AFNElJ+mgOYXvgK9W59LQi81JQdfET0oymt2HFCr+fxrvQZ4sYVxNjhbMmviiuOm2gFCMFZSAGR+qL9o02M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE2BITlWl8X+S5LZjp+mobOr75vMPgjqfKuEWUG/7ocqzNJu6e
	7pBpmc390H65+YXTIXC4yqi8iw2tnzpFe+lPEv80VAOY+YQS+/nLMTw/
X-Gm-Gg: Acq92OGDUxgqCHGRVLuzmaDco1UlcejbUNNcgz1vEM6YZOC0yF3NCSgaM13i5ZrbKHw
	pOb+I0j1R5m755nWYWk3olWLTKFXdXVdzHUhPwUsTQzOAv8cA7I7BuNFm3DZ6Cygzu44RXG+diF
	FS159uRiB2dxOmm+gZF/GccYHHpvpfFBFe4oxgjOs3wYCn/XskbgpCCUZ83yJXLS1+pOCkc2HLI
	JhbuStCTv416i2WhItH469wM03SY4/l1+wi3jVQKI9PwLg/ogcZ+saM9v0g8OwelBc+ifaGNdzv
	Qt+33Xa7rup7u+2bEzIA7JktRlPQczxrvyDw9eolXJk17IrY0KfTieaAi/lE9k/npXu/dlNETIX
	H2KcGaC61tNQYJOr7b/uITrQYwFslIeTVidGC9ils39NXh4IvQsD+2GzN/CgL5mkPsYefMW88nd
	XEvwjPPl5DxPE/8xIoeVmGvvnHE1VQYLo5cIaJ/Ga0fA==
X-Received: by 2002:a05:693c:8386:20b0:2df:919f:ce59 with SMTP id 5a478bee46e88-30398678a48mr2108609eec.19.1778879698427;
        Fri, 15 May 2026 14:14:58 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302973bbd50sm7961724eec.20.2026.05.15.14.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:58 -0700 (PDT)
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
Subject: [PATCH v16 16/38] x86: Secure Launch Kconfig
Date: Fri, 15 May 2026 14:13:48 -0700
Message-ID: <20260515211410.31440-17-ross.philipson@gmail.com>
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

Add an x86 Kconfig option for compiling in/out the Secure Launch feature.
Secure Launch is controlled by a single on/off boolean.

Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 arch/x86/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e2df1b147184..fd9edb0651d9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1989,6 +1989,21 @@ config EFI_RUNTIME_MAP
 
 	  See also Documentation/ABI/testing/sysfs-firmware-efi-runtime-map.
 
+config SECURE_LAUNCH
+	bool "Secure Launch DRTM support"
+	depends on X86_64 && X86_X2APIC && TCG_TIS && TCG_CRB
+	select CRYPTO_LIB_SHA1
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
+	help
+	  The Secure Launch feature allows a kernel to be launched directly
+	  through a vendor neutral DRTM (Dynamic Root of Trust for Measurement)
+	  solution, with Intel TXT being one example. The DRTM establishes an
+	  environment where the CPU measures the kernel image, employing the TPM,
+	  before starting it. Secure Launch then continues the measurement chain
+	  over kernel configuration information and other launch artifacts (e.g.
+	  any initramfs image).
+
 source "kernel/Kconfig.hz"
 
 config ARCH_SUPPORTS_KEXEC
-- 
2.47.3

