Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9FB3A641A
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911180; cv=none; b=uhgNR4OoCxJFIQUhwHsaAyFnbdCis3bJJtnwPevnsgT0jcc6eHg03+HnI94GUmfaSQ/U0xEGvZk6ipN6Fql5JDhQS2/qNWo1Hx4wWoJvMfA13RxU++XKvBTD0Fpc2qnokOqNJ+RUC85Bw1aYlT89BtnICMTqzdrGfFBSeI3Z0MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911180; c=relaxed/simple;
	bh=K4sZ6Y4U9VrKzKj4K3DstnUJLlIlrJWHRBRpbne44zM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tNQfslKtiQt/rDwAUe7WiHW/F127TvGtT+ADt3GQqrtXRSMFxp7RKlwqMhX5LRuCrZ2+xY026Ji8mCwavdXd3waq+ysoQ7zh5rkKi1nG8HCUn/hVIGfApm3iPxT+qPvr5uxgIhyth6oGgh4Qa0Q7TZAWV5NrLqlS7ZDcttBdJy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z5JbIPMm; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z5JbIPMm"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43b3d3d2d22so339428f8f.0
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911177; x=1774515977; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UOQi+adgpvbqtFGURNDthC/99Udxt3gsOjaHUFmz4zQ=;
        b=Z5JbIPMmeWZIMpSOafsGwcyGaSrSYoy0QomyMqala4Oj9BNqg6QawnS02olzZeCrAW
         iWLvTX1orvzTPhzTH63TpPCoqP9DQ+AW9CjvTUMWCm3dBlGBdwgrymQtDf+XsbtBukZO
         9HSmN8YkSMdsjJBtj9adzCbz0guvyKrGDCFtDlXc1hNqybWI/rRsnazRz23Eyw+8h0Z5
         UW4rk0DN3JiSniPdjyAdqXpcbShDpeT3ceX9AO5YB5ZZci/9bNIMHzv8u5tCxbmRLg0x
         vIqOC+C5UGg2gK7gnNjRq+MVUDQDR6pGdnyJHm/PhymUJ5vYHnPpVUJEa8NSqucOlNet
         osAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911177; x=1774515977;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UOQi+adgpvbqtFGURNDthC/99Udxt3gsOjaHUFmz4zQ=;
        b=C0/3UBzFYi8kKnEtlhioKWg929zRpnYQ9v2q9RZZLNRMUpISy/LU46sc3xUvUD4tE3
         /bTOTZDSosPMjGMvf/5U6P0N5s86nL5CHRxImUYcEFWk5V3JZrZRiwWc4bab0vDKjN32
         PMtNtl+BqlvHrEyABhcHR5b9qKBOXW8pg1bF6zcXhRY3pschc6wxzMoCnP0/eiO4DzyK
         Z3TL4wlV6gZ5j5YlBuFiJTbn/HUCpJeR3OgX8jiUKq2B6QQdwJRAv9O+DhrSmWgXZa0A
         WfGbVa8DGi/bnlumhpWTb+u9vyNONdHWmEEAthPsTXm7IBNYllEs37T06tgIohhHjWZ2
         ZqKg==
X-Gm-Message-State: AOJu0YxrMMTo60yMlK1fsm0Qcexk5260u/hraSjFg+wSQ4fEqz3U5LB6
	XsoSqNbxBbxWxtDMyZktakwBg2HhrYFgdgiVlQHda2FKam2LH+AtCL8nJeSuCbbInK4pVYcS9A=
	=
X-Received: from wmhf4.prod.google.com ([2002:a7b:cc04:0:b0:485:4553:1a97])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4fc6:b0:485:2ce2:4c87
 with SMTP id 5b1f17b1804b1-486f442e58dmr105683935e9.4.1773911176439; Thu, 19
 Mar 2026 02:06:16 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:43 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2411; i=ardb@kernel.org;
 h=from:subject; bh=eOPgqP7IEm50GkDKbe7ob4juUFD7i8TXH31+J/KxfWQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3niyvPbz/lto67V0jIdPpov9+79H5S2dUsYvuOxtyl
 2//l8ufO0pZGMS4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBEOn4xMvxgbZrcx3jTN6LJ
 J+Pp0U1PPUzXS2ZMm2Fy4cahCgW/+Y2MDH+mLC85usql3fVG0fE4mbifwlttl7boT7CcuYdfY9H 5Tm4A
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-34-ardb+git@google.com>
Subject: [PATCH v2 13/19] x86/efi: Clean the memory map using iterator and
 filter API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Instead of open coding the iteration logic, use the existing iterator
API to iterate over all valid entries in the EFI memory map.

In addition, break out the logic that iterates over and conditionally
suppresses memory map entries so it can be reused later, as something
similar is happening two more times during boot.

Note that actually reinstalling the EFI memory map, which involves
unmapping and remapping it, is no longer needed, given that the number
of valid entries can only go down. So omit efi_memmap_install() and just
update the number of valid entries.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 30 +++++++++-----------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index a6081e3f1b88..e9b84ecc859b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -266,36 +266,32 @@ static bool __init efi_memmap_entry_valid(const efi_memory_desc_t *md, int i)
 	return false;
 }
 
-static void __init efi_clean_memmap(void)
+static int __init
+efi_memmap_filter_entries(bool (*callback)(const efi_memory_desc_t *, int))
 {
 	efi_memory_desc_t *out = efi.memmap.map;
 	const efi_memory_desc_t *in = out;
-	const efi_memory_desc_t *end = efi.memmap.map_end;
-	int i, n_removal;
+	int i = 0, filtered = 0;
 
-	for (i = n_removal = 0; in < end; i++) {
-		if (efi_memmap_entry_valid(in, i)) {
+	for_each_efi_memory_desc(in) {
+		if (callback(in, i++)) {
 			if (out != in)
 				memcpy(out, in, efi.memmap.desc_size);
 			out = (void *)out + efi.memmap.desc_size;
 		} else {
-			n_removal++;
+			filtered++;
 		}
-		in = (void *)in + efi.memmap.desc_size;
 	}
+	efi.memmap.num_valid_entries -= filtered;
+	return filtered;
+}
 
-	if (n_removal > 0) {
-		struct efi_memory_map_data data = {
-			.phys_map	= efi.memmap.phys_map,
-			.desc_version	= efi.memmap.desc_version,
-			.desc_size	= efi.memmap.desc_size,
-			.size		= efi.memmap.desc_size * (efi.memmap.num_valid_entries - n_removal),
-			.flags		= 0,
-		};
+static void __init efi_clean_memmap(void)
+{
+	int n_removal = efi_memmap_filter_entries(efi_memmap_entry_valid);
 
+	if (n_removal > 0)
 		pr_warn("Removing %d invalid memory map entries.\n", n_removal);
-		efi_memmap_install(&data);
-	}
 }
 
 /*
-- 
2.53.0.851.ga537e3e6e9-goog

