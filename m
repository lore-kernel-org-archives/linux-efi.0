Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86238386C0A
	for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 13:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774531643; cv=none; b=GKGfv5cB7Zz6RpzaZViXLDNlDpBhmxs8TnFlbWbZfuULw96gS1DnTuodNNcB+2bRW6iKYbICyd7wrSPFsdoPubNSfrP+T4oAaY9I9SFK5lHGDgqRvKmOhdXEJr8k61daiPi6b/k/KnGxT447/iEn6Q6IwrgKtOPXmBfrSzFdjs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774531643; c=relaxed/simple;
	bh=rIk1R7y8NoaK+vucCth0wMIHQJyh4Ht8VsH1WDQOKj0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JK6H1vJoB4Tp3qYNhWcMriP/9VLBDuk0aG5IP/7eCO4+Fb+4VQVs5xL80xcagLP+S7f/oyIYiAc66euuz6v+dJjBbuZhPAJaHYQK7LF8ONdyNIIexE1KabzLUdwW6un6gMrGgblvoF+WvaF0YPyLU4ue4jXAfokV4jtpjlzu+Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W3sta5gC; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W3sta5gC"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4871fc50fe7so6189305e9.0
        for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 06:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774531641; x=1775136441; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yCzf4aZhl663HYafsBCQA23EEnogYYWjlMdO1fVHwXE=;
        b=W3sta5gCcAcCeKhrIaC3gDcyhaoPp50EgyamzebY6vN3PzDlBwKCKqnktjlVh+fnaD
         1v2EMVHi6lhspFlUpLAXYBfEMpQ6mA4mztHclRifxLMZYUjDYNikvG1f93rWdKR0sTsy
         1ZFYcOEXWrOX83EsZQfebmwPt1nbhfp/Ptyt5U0fmUJa3SrCHK1bKk6x6MftGhhfVTg2
         nujQ1TU8sjGNLohgqfPKRQGu2trsWTvYhopRIzPjmMG3xGxZB1oQzIFiEfJUQXXpXIlE
         LtCNOVhXKsxkn1IU+huUYqd+2YzJJdRTB9z163e+3SeWc7F/NTLL9fv3/UuxXD+QBk1y
         bydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774531641; x=1775136441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yCzf4aZhl663HYafsBCQA23EEnogYYWjlMdO1fVHwXE=;
        b=W8a57hYCZRLHjbwuCJAz04GbwCQV3ifohv23q3OEn6zY1WXas+vOx40Z+8LtniWngZ
         7PffnJ9D76wH724Y83g60BtZQDShFAgmZi2iGJE252Z4ZYo0h0ntG4Ke/pZtNycgLubR
         eca0XZgQ+MBf1tJ5TBrGEiOiozzahvwsh4hbkiC+tBrWQj1grs6JOq8hYZoyW+rR1qk1
         t48OZnmBWJOQSeB4B6TkbUOp5rwriKlzVZQiFEP31/yO4IkF3o2Wjrz01T+gmIVYDuGU
         8u2Cme5guEV8VsDxsVdjuHZuvczMMzd2KQeaI+cfjtNK0S5r+/feX25GpWJjVgey5pTT
         rgwg==
X-Gm-Message-State: AOJu0YxiqosggCalebsPIQ5xJ7YXWduiCEwpyght1/TUsL+edfgYSZZ/
	IbfAsEa4ZxBlSEKsiWVK/phvDmW2+RnuWJxWRkfGwnxOsOmQH+sfFjeyppxgEa/oFQhvy/iPbXT
	sKpdmZHhq6Y8J47gmkJuV9UPwCWTDvKaGmyhe1spR2+4/REDFpIt4z27w0b8R7nlpg+ku+vs7vQ
	RLIjfZF1ntsW0DYusOfk9rWmH8floU+g==
X-Received: from wmcq23.prod.google.com ([2002:a05:600c:c117:b0:480:4be7:3f3a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3309:b0:487:219e:416
 with SMTP id 5b1f17b1804b1-487219e0550mr20341805e9.8.1774531640788; Thu, 26
 Mar 2026 06:27:20 -0700 (PDT)
Date: Thu, 26 Mar 2026 14:27:01 +0100
In-Reply-To: <20260326132655.1733873-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260326132655.1733873-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1261; i=ardb@kernel.org;
 h=from:subject; bh=9/p1gplyiVkCrjGlrbWLto/adyUX/ujHd1AFZTagrlM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOoiVpW2xyxydyfz1+q+cdayjs5xtukQrfgz8S+R8fnP
 Cldu/JnRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjI5umMDN8uWemEikyrXcjE
 qyPyQu7h7mt3Lii5XvS70nY5+OHXzR8ZGb7UalSv5eM5liUjFPFu2sXvEy8pMQbVeCV2TZ5wfYv WXw4A
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326132655.1733873-12-ardb+git@google.com>
Subject: [PATCH 5/5] x86/efi: Drop kexec quirk for the EFI memory attributes table
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, Gregory Price <gourry@gourry.net>, 
	Usama Arif <usamaarif642@gmail.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that the EFI memory attributes table is preserved properly, and the
quirk to detect corrupted tables has been updated not to result in false
positives when the number of EFI memory map entries is low compared to
the number of EFI memory attributes table entries, there is no longer a
need to ignore the latter when doing a kexec boot. So drop the
workaround.

This reverts commit

  64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 79f0818131e8..98641c621e6c 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -611,10 +611,6 @@ int __init efi_reuse_config(u64 tables, int nr_tables)
 		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
 			((efi_config_table_64_t *)p)->table = data->smbios;
 
-		/* Do not bother to play with mem attr table across kexec */
-		if (!efi_guidcmp(guid, EFI_MEMORY_ATTRIBUTES_TABLE_GUID))
-			((efi_config_table_64_t *)p)->table = EFI_INVALID_TABLE_ADDR;
-
 		p += sz;
 	}
 	early_memunmap(tablep, nr_tables * sz);
-- 
2.53.0.1018.g2bb0e51243-goog

