Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F73F3C8737
	for <linux-efi@vger.kernel.org>; Sat, 11 Jul 2026 16:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783785695; cv=none; b=XPdrHpqzZG4MG664MaGJHvuafwWRlTWo1VGpjyVw2N2KASJ+9ZBwNLrOmE5oqJxc4GKNhq1/TDm+GQDqxaYTWkVAINSzcdmwhFTlX/1bU3f8dBYrt97D6gG4LQEH5w6DCJzPm3fwI2WrmU7xkT3XUfMSaut6fa7HKg/sYRW2Tpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783785695; c=relaxed/simple;
	bh=SWTmQxbm+O3CiuFQm/Zj3X9aRzkg0EYTJlhP8g+50ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcVaRm4OilFRaUNpW163GbRit61oOXflH7DfXTCfT16AFs4c3BySXRsSTjVOZseyu0oVXN1+QnNL+hE0OrF4Wht3HpIFXLY5TT/EOlSKyU3WIljW33MEhYHBqFDaFGgt9HAAakbHSA4FgWOHJ1ocGqZuIhdOdS7UkYXLW9CWN08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8t864WG; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8t864WG"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c7cfa17fedso26790425ad.3
        for <linux-efi@vger.kernel.org>; Sat, 11 Jul 2026 09:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783785694; x=1784390494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h8PdlfVA45gq99DCqpKxVhIV4ifAok/KN5VEGME0LcA=;
        b=g8t864WGg/9SeihPvThSlxO6aPm1JKP+lZV5uqf4SxOGm5cSaLmszjo+qTr6W6Mk4i
         i14kRKNOH832Rpk8M5BB5PtKC7VLJXcSEJRneJywRQLIH7R+XR6FXOCnazpwyzxwdZ/T
         gnRXjR2omx7pImL8ZekUjMxErBXvDvNakGBHgedgE8h3Z7I6OZjO083vHKk4ULtAcUt5
         kCG5ZtX94y7CNTHg+Rdj6YLPfn0RFSmlQ7bbXidPQJxboDwLUtlaijiOD12HagX4tLKe
         njOr4SDL/GGhi9XkSB3VneKsmO+ngrX2jI9elAcoD6bzhp4TAGfNTFDyTAjci6Myf+dn
         byUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783785694; x=1784390494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h8PdlfVA45gq99DCqpKxVhIV4ifAok/KN5VEGME0LcA=;
        b=Tc+aZzt7t6lTJz1ADL9ETUOZqQIxcK+Wtnl2oDqn8P/FqNmHwPwPCub00uNPtXjgL3
         iBRTWcUJRkiy2SSsU6Lh1GIsIWVzFvghWwgzqnJ7wCZcCvfiRWs8CK6XL9wPJgwFoE6Y
         jycIAGaxrGdoxV7ILmFgogwXw5kXDlhXfF1mN8eTDOMff5ML6Hg4rI6Sjpzndo7DDq26
         3Bpa3PfdzPuG++/v3QdvMYi5AR8xJlCq7EazQ/zy0eT8QpxmP/dnQVQgAuX8uV51PZ/l
         0b82SWNFabrAT+n/1JEY+D4OrQFSUb33wem6+pBux+SVIUuO+plAAeRRWd4SzmRv52Q8
         RmcQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpd2TFHD5mv3JMMIrvFyxCfAzxB2MjbCUSM3eOoVSaoBw11KnwFB1vtvEdT4c66/6/22VxuOUAFp3I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpbjGSd1F9hLnsxV8m34aXAWz6ZPXmeG2NpcT/EZqUw5N8VYao
	U4LUp2iF+1XxpH+SnUIkaxl9nJg/+hyKdnsgIDc+2JYWWdzgZNjm8EbL
X-Gm-Gg: AfdE7clnFYLPeI+rUejc0FgJJcyxVHfKM3WMGfLimItNn9HEpzhWAONSG+L4jPmtftv
	E90DPrNxlDMdUyEbUTxZ/8L6LJx7KecR7Bc3uEgN8b6eLoGT8GgxzgshCKzlaBTWpRJRJhHCAEK
	KUlUda0J61YbzHrswG4gDFw1PWtwogDJW2EuOaSNqyJcBcWBxY2tUVrLBpxGlB0xtwDhRpt4RJv
	abbXFarFnvbXFPyie2t1bVBjyDgzR0+3PGzGDdZwf6jVwdEhwycg7ylmTEcE99j/w/3S/CJgJT4
	sH2xcALNDGWEBLzaTpgYR34drQUm6XYwpw+lo+aQQ3F2rMpW8uHiZCfQ+gQTAwafb5BlYMD7f5X
	2LhiqQ4y/IK6LgcEWWZW42tzrs2fg6KoojT0E54qpcsjHc9M6UQYyQmrmW+ZOFM6j0dpXvHRZ8B
	q1kY3UUBogI8B02JbqrS3L
X-Received: by 2002:a17:90a:da83:b0:384:d509:7274 with SMTP id 98e67ed59e1d1-38dc75f63bemr3176054a91.15.1783785694020;
        Sat, 11 Jul 2026 09:01:34 -0700 (PDT)
Received: from titan.lan ([2603:8000:df01:38f7:255c:dd03:30a6:e57b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3118ee6091dsm54498068eec.14.2026.07.11.09.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 09:01:32 -0700 (PDT)
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
Subject: [PATCH v2 06/10] tpm: Remove main TPM header from TPM event log header
Date: Sat, 11 Jul 2026 09:01:06 -0700
Message-ID: <20260711160110.267780-7-ross.philipson@gmail.com>
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

From: Alec Brown <alec.r.brown@oracle.com>

Allow the TPM event log functionality to be used without including
the main TPM driver definitions.

Signed-off-by: Alec Brown <alec.r.brown@oracle.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 include/linux/tpm_eventlog.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index aff8ea2fa98e..40fe92eb7deb 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -3,7 +3,7 @@
 #ifndef __LINUX_TPM_EVENTLOG_H__
 #define __LINUX_TPM_EVENTLOG_H__
 
-#include <linux/tpm.h>
+#include <linux/tpm_command.h>
 
 #define TCG_EVENT_NAME_LEN_MAX	255
 #define MAX_TEXT_EVENT		1000	/* Max event string length */
-- 
2.55.0

