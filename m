Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3903ED127
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879674; cv=none; b=JshOoafWDfaxqpwhFKafONX7Z3JUVSESNwNE9bTO20ugY8DdiIAvIbqcvm5t4nXgLHBpLAwFI96OBl96WtfJe1Q5JZE5o93uTiVPwQNRygaMddQTGpTlhCrDoGkq2jlWf7KiB8t7vreGpmcwZpwCSky5IJAmcUptfy1gzmjEp1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879674; c=relaxed/simple;
	bh=tgSnXEl/4HoRNelt6PM6wKCfW7tff83XdCqIyzj9aek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jm/Au3SdixwbcVLU94bnZsPm41LFtdxQgd7gV6TpZ/QyOzOqALGILDBZ9Aq313QPxPXr6Dd3J5nzR1jeykABDltstWUMe5qM7Xh++/IW6CHYX/GWSoZLLtLX87DhGZAsE7Axh1wxHf2XIXUTlbsUEnTnRbq0pPpvQc//wKaNSA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ObM+UCfj; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ObM+UCfj"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2ef2a1cc06dso1354203eec.0
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879670; x=1779484470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vsy43cKdjjquhJVv3pJ2fPEZtWZ9VhRxjDQaQqinW+s=;
        b=ObM+UCfjlsSeq0ZhH2iSw6wylKUn+YVk5t13OqFDfdGfbbozLB7YQAsohbocEPamxg
         M666walSMK+bu4f9T2c4JE6zuA0wm5Y0MWQOtYn31jq13dsxCJ/7NExqYnPmw9UFYFXQ
         2jco6BxXkT3ocPurrRUjIjfmO7d89AGKLRV8X+sqGZKOUFMmy/yBJb9OomC8c/MAGGnk
         X8ynJploJbAVYG+Xn47zvRjtY8LTzBd1R4jxcs/PqocpOqwbu9iB++n3gkB/tQL5OmWN
         1UE8UNEZ/yHl5DMhrOWCIFuJnOO2hJR7uO7iBYQfjIo8Mj3biG8SazcBNV75QEM79d/o
         r96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879670; x=1779484470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vsy43cKdjjquhJVv3pJ2fPEZtWZ9VhRxjDQaQqinW+s=;
        b=e8VtO/k0WkwnHuBOvXNzniIRefGtx2PCw+cq0b110bJ1OC0Hg2ugMaEk1egSXo4wVs
         elPtRhucXYQFey/yLVif31WO8zGMQs1Lt0kb1CPdxh+ws/ExIgi7duV9AHIv902esGIJ
         vCDkxAWoRaHZynv+fNbfxY59UaQoQZyUD10HVh/0gDwWctK17kOv3vTRWz7yN53S/USu
         fMPrimbBEU81uUKcScwA9volIRj5vJNBPyZ5ttRAAkBruH/6hEkpVv5ugoWYr5uwcKa/
         s5+eQPBtQ1F3wx4ed3dFXiWBAi3jJb0yywF2Hd7rBoM0QFfdPtT3cQD2DXzLaRiXJdr6
         L9oA==
X-Forwarded-Encrypted: i=1; AFNElJ/eUBZ/rN3ottq+zt0KMrnyx7yF1uTf3SBnPiWZvAAtO1WMZgyASGU3V4mEl9ccm3nkeEiGR+SAtGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUXhUfSF2x1bnOMEzbyjcJpEW6Okfx2T59XXSfyvj6ASfOFn+R
	qw3OJHe4Li3LHyhskjdwHnhRwbM+kHyndlOEe09+n5qB8Y4n8FfNgiBH
X-Gm-Gg: Acq92OHl7wRhMc/9zPEqLkKHkzvkMKgaXREADVbWOVzo3yqxTsxSekewhb36RgTBReT
	Xws0XbvsAjX9UyfyrIRUFUc4ufP97zp39poCXS50DMu/E613RvDewUeCym52lN13evjvL3Mw+FK
	Wr8PgglmzRX0T6TpFKfWAYfsrEaOQLifBVe0PGb0BVLiyZVAeUXSSSYfLWlByl94qQ3QWuTHrzJ
	DlRW1B1DVwTC6iSUpW/Xyyu5lzUjdP0ilqR1BKAUGvyaJJu1FilguH1RyaIV9BSSY2WQbHZswTG
	Vi5u3JDRH/uGz5MSyXGsrVIXPICWTggZ/E88mbn+hy0IWNK/yEdgVWVxAGwUDgI2GhOHGJ8owlA
	RdovnL8Oj9xvFsjZmplMlZ4UTURLhRbK/eXCEMHaTSYNEokVPpmW0f0KiOma/5nlk9SRf5wolUi
	g0vxxXyDM+0ZUk+CfIpeRhxzFG9n21ZaA=
X-Received: by 2002:a05:7300:e6c4:b0:2ff:c84d:44d2 with SMTP id 5a478bee46e88-3039815cae2mr2917959eec.12.1778879669685;
        Fri, 15 May 2026 14:14:29 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302978b3cb2sm10323215eec.30.2026.05.15.14.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:29 -0700 (PDT)
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
Subject: [PATCH v16 06/38] tpm: Remove main TPM header from TPM event log header
Date: Fri, 15 May 2026 14:13:38 -0700
Message-ID: <20260515211410.31440-7-ross.philipson@gmail.com>
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

From: Alec Brown <alec.r.brown@oracle.com>

Allow the TPM event log functionality to be used without including
the main TPM driver definitions.

Signed-off-by: Alec Brown <alec.r.brown@oracle.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 include/linux/tpm_eventlog.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index 891368e82558..367b70ecc4b1 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -3,7 +3,9 @@
 #ifndef __LINUX_TPM_EVENTLOG_H__
 #define __LINUX_TPM_EVENTLOG_H__
 
-#include <linux/tpm.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
+#include <linux/tpm_command.h>
 
 #define TCG_EVENT_NAME_LEN_MAX	255
 #define MAX_TEXT_EVENT		1000	/* Max event string length */
-- 
2.47.3

