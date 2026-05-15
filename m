Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBC74048AD
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879734; cv=none; b=t7ilKixUyz/vg6zK5/uh8p3y5v2zBLjCJ6gqKMontu8gGyOh0lAPI8A5MdWs+xdjg8nylGo2wo2+StD0zkze9wDVk7oqrEJ970uWzT3vL3WcnnSwyZSsfya6rg9dC/PVxwuIRMEHsrK/u7tL11gMlWhkA2pswPzfvEzappop8DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879734; c=relaxed/simple;
	bh=ILT1qaKW78nRQkC/CMCLSzr2h8dTPOcGoDMHkPnSKzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9OyhjR63ixrI5ybHRrtV0Ggo9oh5A5dMo2O4d7TF8rkhfFqJMURybQ9Y/Ym0pQVnUhT380FJjQ1vo0NoHGTU+mdrONsL+q5KicYxCwGuE3XRcNRtTr6dhWoKPuCv+eONr6jRQMKGfZNipJtgzROeuaOiiyHhRBL7RA+ZBAY+Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IYL3YWM0; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IYL3YWM0"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12c1a170a50so288785c88.0
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879732; x=1779484532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aF0BH6dZpM5RACWLo6N4NcvxHw87HpE9a7jatFY2Xnk=;
        b=IYL3YWM0K72+PKBjUIotlkyudmp1jTzkcWSk+FsrFVXzSnegkXpcBDTHvkmgtyv013
         1Fz+1cDxxzxpwH2cjTMD3XcK8OrL3KyPSBFqH8USMoVoBphH/PDfMppdjjf5WM9Uu+zw
         zdblTDDlg3ILJFwS88bKz+DpkkC4R874roDAz+B70ThKNQTz3lnAY6Vm18brrdmeKYlL
         nrRDow22yM9/5xyVwtbnB/WqwizcqZ8UTLFg96EIfVlIoQZejH3ZXpbdDCcTFwuaBYDe
         SBIe7CCRHOt+kHRuouqHqrJpRS0HE1SBm0toraK+5jwMRSnRo9h+dKmUj5IEOAw9IoLh
         DUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879732; x=1779484532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aF0BH6dZpM5RACWLo6N4NcvxHw87HpE9a7jatFY2Xnk=;
        b=iDaznLNNQhHg3crqJFpJnDxNcUxlly4likimkT+l7aKpOSYAPNQwTNb9B6WdWQh5xS
         R2O3IvnewGlCg3q6kpdKKjhchCCNFc+QsDgH1qXniRb1dketMp2+NnQVp0uT7bukGfsK
         mtrN6LaXBCGx9mBx+80vtF9FxjUpOZuH35zBYGflNSnfPjNDM2gN81SwMMiCl22mM4qp
         8er4a+DZaW+1/ReBvFOyZwm2UXMXhuCJ6ZLkPOpCEmFg9NyC7WIlZmCCa+Ah/cFcVXd/
         E57H7XgOg0Icop92mfZyQGeg7t0xSh93XbiQo6WRLAJvY2Ke/xK31peW5mdw2KLYrfxf
         Dt8w==
X-Forwarded-Encrypted: i=1; AFNElJ9SLF9FZhOLU30UJ29xfu+uYKlaCUfweaTUm3o++1Lc9hMrUmfjTHU0tuDxv71j8xhyaZE0X72S2w8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT0MBtRUu7oxHAKbbIumD3AoOBBHvY5XtBF+3pOX7pboIAAGAM
	IQVpjf57OSQm57C8Y21RST3va+ZaeXLZz3tOTw2TOlikj0pFehrysLt8bW17SNMU
X-Gm-Gg: Acq92OGky7L3gcuV1OWGwNQaR/4Jkrm4tIRtcFejd3uVC2AUSkUTXCODIxr894joZzV
	sYH8NZGmSQZ3nbutiD5A+76ofPA9mWtZfErG4PBDgjO+ZVCNkH8VmZQCZCUCA9zB2Fp8ahBFp5P
	V/kHTk/6nG+81LBsib2gSjgWfTm4FG70RjwhgGnHbzi46l2Lqx8rX8Bd72Qvk8LDkA7vrD8r7HD
	iBqeE99Cg2kjlHGLBlVmTWwx0NfyCWZJD2rQHoLALK1fKreZgc111DUjuzQOWo2nQfHbHVS67GR
	Oe9DWKwcNnyInmT0aSP2u2w8Gy2e07oezYcjUxVhxwyTxQp2w13t1OgnnB3S0XFdEpHSJf6uYvE
	wHX8zdwnCy/JrOf4dtjD33RLi8by0q1kSd6pxCdXtBeedpFazsz3Ok9ui3tOBhxIb8dewWJli7x
	ps8zE37YTpLkMaRlvjNbZIGz4g034xLOVknAoucaL3Yg==
X-Received: by 2002:a05:7022:6621:b0:134:a710:d908 with SMTP id a92af1059eb24-1350451887emr2398095c88.13.1778879732067;
        Fri, 15 May 2026 14:15:32 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cc33a618sm11245224c88.12.2026.05.15.14.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:31 -0700 (PDT)
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
Subject: [PATCH v16 28/38] x86: Add early SHA-384/512 support for Secure Launch early measurements
Date: Fri, 15 May 2026 14:14:00 -0700
Message-ID: <20260515211410.31440-29-ross.philipson@gmail.com>
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

On newer TPM 2 implementations, SHA 384 and 512 banks may be available
for use. If these banks are enabled in firmware, they will be used for
the Dynamic Launch. The DLME will also use these algorithms to measure
configuration information into the TPM as early as possible before using
the values. This implementation uses the established approach of #including
the SHA-512 library directly in the early boot code.

Signed-off-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 arch/x86/boot/startup/Makefile     | 1 +
 arch/x86/boot/startup/lib-sha512.c | 6 ++++++
 2 files changed, 7 insertions(+)
 create mode 100644 arch/x86/boot/startup/lib-sha512.c

diff --git a/arch/x86/boot/startup/Makefile b/arch/x86/boot/startup/Makefile
index 071a90f23ae0..527cba7e4560 100644
--- a/arch/x86/boot/startup/Makefile
+++ b/arch/x86/boot/startup/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= sme.o sev-startup.o
 
 slaunch-objs			+= lib-sha1.o
 slaunch-objs			+= lib-sha256.o
+slaunch-objs			+= lib-sha512.o
 obj-$(CONFIG_SECURE_LAUNCH)	+= $(slaunch-objs)
 
 pi-objs				:= $(patsubst %.o,$(obj)/%.o,$(obj-y))
diff --git a/arch/x86/boot/startup/lib-sha512.c b/arch/x86/boot/startup/lib-sha512.c
new file mode 100644
index 000000000000..2afd5c5935cd
--- /dev/null
+++ b/arch/x86/boot/startup/lib-sha512.c
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Apertus Solutions, LLC
+ */
+
+#include "../../../../lib/crypto/sha512.c"
-- 
2.47.3

