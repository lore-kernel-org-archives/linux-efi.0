Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4B63A75A2
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 11:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788520817; cv=none; b=QttT/p5omS1nc341DccP9DiDGQ+6XMM1EfLGBelECigtOgqGZwd+DQvBuqSm+tA8ghgIynevBfChjaTPtgTFz/RxTpPTK+T8UiyICoUtSYkmwA8+AftV+kkRKcICXlGGWWIdrf9LdRHdJvB8RHcDXGX/Iu+ghPs/q9nBFVS2EP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788520817; c=relaxed/simple;
	bh=CF0YCed2WtdqEGRqOM9y1KcRf8RpN7O6C2r0lIoiiMU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dD9ZgIRceujwKTzl8W6ZpaT2oFNJzSf9mKbG821IwSVsv4iYnNNuwgKiwRKZ2BCjEqq672AX5gzaSzs6EGZxz9MoAENOujhd+SrTX0fQgQSueV8C/YL29+TnuZcDX0LxdyZo9RRv5PLlxzhBBTtMi14saRIiLwQrXIu/WCpEMAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QcFWjEWW; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QcFWjEWW"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6b1497f0453so654491eaf.3
        for <linux-efi@vger.kernel.org>; Fri, 04 Sep 2026 04:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788520814; x=1789125614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JeAXB5jcaMUwlkcazxMxNc2XuQ65/XFpmGAtCnFbJ/Q=;
        b=QcFWjEWWDMPYbUncK+culUVNnMhrbVb+ENLGAAEcN8+Di9teJZYCJcTXbdkODRqf7G
         x77sbkrR19vl6szy+g2LaE3OqUR2VOpUcinX9q6WoTfZ6bUsu0RoCwASVLyPmOpSEyuo
         bnO3nlL7SIRC9/hWfJYpyjW8GTs13PpDloaIrksLRnL2EQ4oWEJN9exu9ircfhC5PFCI
         PwVCVTZ0O8QV8Qy3Sn8V5iQPUJT+4dIHRyqdLpjz+PnvKAvJorEkg+TelWXRZv21SuyD
         LTA6C/uGoaAnOZ7DqqISV9pVb5aJ9RfWWIL72EQfGzqyAy/kxkFw0mACa1EB7f3gBDL9
         qgtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788520814; x=1789125614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JeAXB5jcaMUwlkcazxMxNc2XuQ65/XFpmGAtCnFbJ/Q=;
        b=ESs2bHcBYt7PM6fi53HcekZJ8MIFsDD87K+bma2/N+pGtg5ppjMLi5sfmu/J2eoTp7
         /HBMt6TD+Dr/akqlO/3K7oM9TqAkrfuz9WHi6Fyh1qryRwBFlrTq+dOtbQv9kstyKNIa
         o9fYmyPnQ712e/pZUhexmfP3ROcB+wxoXQyRWcgIwXdk03GjwNVZUs0ZmYEj6J8Tkldx
         b5QNh2y4Sb/n2pkExCWyrT6boTymNp9wtgHKbAYvqdxcqynhvCHpZZtkiaopsSHurYt6
         HIuCnwZ2nZKN09Kc2gevOlfOeabX5YW/nnBE+lAHCSMVGwgQ7Ak/UqspQQwx1aFW4ReA
         jYYg==
X-Forwarded-Encrypted: i=1; AKwUvBxyaNApn+QB4trEH9pkAKwQUxIzP99PMkjgnMoHOBE1bcq9RCxGE0QAE/a+oG84lwKEDIuofuzYL1o=@vger.kernel.org
X-Gm-Message-State: AFuF++m5ANRB8v39m9Mmgu7E5/CRArJJNL4/LQsyaBQXz7zAWz9+djEa
	CzV4ZF95BycFYe/9b6kX4Y0E6a8lPmHJOR1JGtRaELpR3IesVtmiGhLP
X-Gm-Gg: AYBFou2iP+/VYivjW1ife16vfvBcKmNkkEx3qLXTJl8zCLF8oAYdnvShXO8c+IWWPMw
	v7OdcJ/3kIToy2QIbbo3iFzYi4SX3QZ2P69hTwK5w01RsezePJvJJ8kWbX2383H/sj7f98M8mjC
	x97E7ek9bAHzD6RxtoPD5/Y9BIJwUaCCICpCwCJfn+DjUEkCFsO3/WQTB4XOiQzkG/Z6Ns48aWO
	FqX0HrnTCMYP1W/4QlsFMgLHOx2I06oVNczvbHFu2Z9tNEpAqfAY5XNRf1uI0N1NDNU5tN0ybQm
	wVKp+kDKagJ6gVMnl3kImS82wywH5zCSjAz1fOhkGHRuygR6g6sEgP3NU2P5beBN6WRCMZ/tXy6
	FVL+aXI43qlRXItalfa9t86nHMqwXWeeFglqNa7Zj6dOYr5kPj6OYIzUrvLCccBH8s8CTSRp+9r
	vu7CBNOkABY3A1ETXRBkZNHhuuafopVRYms6FV+OLBM2a2ja+DG/aH12fWzZZL+a/H+QEErndHN
	VhaZ/Em8vHF1MU=
X-Received: by 2002:a05:6820:190f:b0:6b1:8a16:a3f1 with SMTP id 006d021491bc7-6b6fd3d772emr3600103eaf.27.1788520813778;
        Fri, 04 Sep 2026 04:20:13 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339aa36b37sm5900541eec.14.2026.09.04.04.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:20:13 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH] firmware: efi: fix typo "existance" in comment
Date: Fri,  4 Sep 2026 16:50:08 +0530
Message-ID: <20260904112009.33620-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "existance" to "existence", reported by scripts/checkpatch.pl using
the misspelling list in scripts/spelling.txt.  Only touches comments, no
code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d31fa..846179b23160 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -8,7 +8,7 @@
  *
  * This code registers /sys/firmware/efi{,/efivars} when EFI is supported,
  * allowing the efivarfs to be mounted or the efivars module to be loaded.
- * The existance of /sys/firmware/efi may also be used by userspace to
+ * The existence of /sys/firmware/efi may also be used by userspace to
  * determine that the system supports EFI.
  */
 
-- 
2.48.1

