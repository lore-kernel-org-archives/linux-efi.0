Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08DB433BCD
	for <linux-efi@vger.kernel.org>; Mon,  6 Jul 2026 16:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355958; cv=none; b=EPWe3M6n5esZbybFNin0J8s/mqviqgX57ecostX1R9veXdoyOBU1UNuo3OTciZOXCjZ+ZBOaiinypphGGXV1R9dMagyhpZucyfYgvjMfYb9A8a5lUk+eUovhJBN3/A8qvWWKz3gheSYUfz0W2ZlBVmKA8qDOdH0nJp/5gJqgmhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355958; c=relaxed/simple;
	bh=BTI/aAntiQ9xcx69tlVTSh2gnfDkXs2rdrTFgedaEpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwwdi2EWiHgJaGEEkQlZWK6PF+sr8JYn7DTfksFMRblQoQTzx/QVqoa+MYSHaVK1ahgFTqRH4Vod5G/3lmgYs4gNTHJ298jdTx68Jch9+nEah/csgk8edxN0l7LUi7zpgADPQ/FzO56sJiSNorkPal2YtrjvBBUeH6h1XiD/yec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ne7bMMZB; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ne7bMMZB"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cac59f8b64so38948925ad.0
        for <linux-efi@vger.kernel.org>; Mon, 06 Jul 2026 09:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783355957; x=1783960757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ln2AHNDCstBaUrT3DCw2JhDQU5MIDiC1ybsTRxhjJ6s=;
        b=ne7bMMZBz7DuDx/UcyHgEcjNO9sg9oXkkSJcy4Ro1v9/HNWoW5no/7MLPpBjx5gMdh
         /6VtiTEp0WHcGnRln5BbWkhQz0gQR4ATVMo8qfjH5qUbJQniwrzjYCPzBx5xu1Cr+6w8
         rUFGa/XlXhQE7oNvbR36Z03B+pK9zBhEKYj8iDJYHpDG4vxDYsIPHAXiU74dz1N6cuVm
         YaC9WUqz6yUADZBhBDtphmsRUweZJEUaEvt46JOGhAAMgVPMwFZ0c0W4XBezDIBzMPxO
         y77uTAzrkcZa4EFiC/LXWwUBz3rszeCoY2z2cLfR8zktbOfQbVQ5fNd/xGa5GP2KAS/L
         GkvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783355957; x=1783960757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ln2AHNDCstBaUrT3DCw2JhDQU5MIDiC1ybsTRxhjJ6s=;
        b=Sgz8b2l1jlc6da1EG2KTK+ZLLxC7l9ydt96X+B4BcfQNwbdwXigLwN3Ldf3jJ3se03
         tiSGyv0qWm7g+bAY57aEpcCoWk12L6XsNF9ldGwArC5wutHHVDVTgEVq8hWKHriQFsmh
         EhmKTPSLCrdmkpAmn5x+CEWV3mn0kMW3IfHH5gFSv9ijefswhbzOiezNc3YjlPmEe9vZ
         DGjv+8JhZ9b0lRJrMOMxcDSiW+ZY5MxBaLRLvqxYCw483gFbAMxf0/Te/GojqMJscR1j
         zjdAIS1tLmZZ6MQA/g6QjB+H1uDI6rYZMmtfP7wM4eODhM52RaOxLkNco1IlNzCWtpYP
         tyvA==
X-Forwarded-Encrypted: i=1; AHgh+Rp9DOZ44wJPZO1ZXkEZaSpamBYatYEqIukc90xK5mD9kKCUC8UHU99FA/X8O1ruqva+Bxjp9HQq6xM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvoHU9d3wGQytB9Um3UX/pZWv2e07InIm0PU1FugM9Pwgv0US9
	5Vki0la9ytp4ZSnwzQA3N8pydc6bLlkbchSNCcugF+zVRhIT11PpeLmm
X-Gm-Gg: AfdE7ckyQx900/ggGHsAWlKsXUS8oqTkPhbqQsj4aV15QgwDzlF1ChAIuPKReZoyWB5
	SUqk7LMloHFWnxxJ/C9W494m/uF3Hi8GeOFwZnXWsqUj+TBd1Sl5I2SyEaVLz2e4fSbAxNLwdQc
	R2IdoVxz4zlGpXCzZZnegnP0K+WiPaaF/fNAu8e5HEks29g7QwyH+CFTClB1wOWTxsfIDfN/l70
	q8ADVFPcSpM8Z4cLLLOfgF98dZ663CCdbZeGdlS0Ad+Y7QCRb/WalUF0Jns/uSuVrV1qirSFOJ8
	jf432ym22rsR9XGe7a+miW/BvinyTeD9BGp0D28S12ydg2rZmleqmz542oWxf1+Bj8VMG09MLyW
	zi6N0E3J7rQ8RKDOtgWL19fQq0wqanqG0XUlLK4wuSw+El8PNQZXD56ENL4n48A0Td7KDjFn6dP
	fztzKc3FY=
X-Received: by 2002:a17:902:ec88:b0:2ca:c84b:c4a4 with SMTP id d9443c01a7336-2ccbee245d5mr14321395ad.28.1783355956959;
        Mon, 06 Jul 2026 09:39:16 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad7893a8dsm53103305ad.73.2026.07.06.09.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 09:39:16 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Borislav Petkov <bp@alien8.de>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH v2 5/5] Revert "tpm: do not ignore memblock_reserve return value"
Date: Tue,  7 Jul 2026 01:37:53 +0900
Message-ID: <20260706163753.193875-6-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260706163753.193875-1-ekffu200098@gmail.com>
References: <20260706163753.193875-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit c33c28f9f6e017702374e1ab907dfa5a63db5301.

efi_tpm_eventlog_init() runs from efi_config_parse_tables() during early
EFI initialization, before memblock_allow_resize(). At that point
memblock_reserve() either succeeds or panics, never returning an error.

Therefore the return value check is unreachable, so restore the original
unconditional memblock_reserve().

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/firmware/efi/tpm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index cdd431027065..288bcf7a5b99 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -61,12 +61,7 @@ int __init efi_tpm_eventlog_init(void)
 	}
 
 	tbl_size = sizeof(*log_tbl) + log_tbl->size;
-	if (memblock_reserve(efi.tpm_log, tbl_size)) {
-		pr_err("TPM Event Log memblock reserve fails (0x%lx, 0x%x)\n",
-		       efi.tpm_log, tbl_size);
-		ret = -ENOMEM;
-		goto out;
-	}
+	memblock_reserve(efi.tpm_log, tbl_size);
 
 	if (efi.tpm_final_log == EFI_INVALID_TABLE_ADDR) {
 		pr_info("TPM Final Events table not present\n");
-- 
2.43.0

