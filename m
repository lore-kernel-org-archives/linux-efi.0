Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A873AB286
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 08:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775808041; cv=none; b=XRg4m2QOsnTptJLUatCOfYoP1QWSO/UVjb3D6LrqcBOGXXPPbMuDj3bXvNKOpVGL3HTJ7diqePe7RGaDfh8mNxGA/Fhqnh2IRBXRwNfq00XVGhLe1/oMMbgiZHVGqS4U77so+qUjHzcK7KEIcktL0DpIVWJngHvq9woaVkY6LUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775808041; c=relaxed/simple;
	bh=iLen1aR102YuA/eT56ah2gSVgDvHfb0/X1KtXE0m5Oc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nld17z8zSOjI37JviSJkQw0Voif111ETilA2kWpPae9B8oe2Zo5SEXG+Q7hVbiNl3X5ngo5GsjBkDQudG5c5AjGm4uVNuJpX5vPDSn91s/aKHNLkB3VJfGmtZEvlcRi5RMAX40tAlJqCBCwt5CdjnKxA29HwSA4YqaljptfVsPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B8PuJzaW; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B8PuJzaW"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4888b17ffa6so11677655e9.3
        for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 01:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775808036; x=1776412836; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=634Dmh8NJpUnXMsTawnmCgoHk0n99s2/V3zN7QrSSpg=;
        b=B8PuJzaWsmK6L9j1ZyZDSjh5wodebeQUvwndGgtvjo0REvd7yWyCFhsD+cB5V+DHe8
         EgyLr+mTPlKhjtHN37g4SeMiFV2CYJK6dhwcJjaib89ZMf3mKkPsGO/l2tcmsEQ+yG77
         eGlFrYTR8jIl/QIPF2Rog5MJ8JgF1YnuCXroU0PjnAKvl3eOLZ6SkYR+py67XoHwSpuO
         akcrrnKbIRHQcfSJ5RJcbCoMHnH0em7URMZFD8d+ype13Sk5HSTMQKSSln0ss3PmFxuS
         3pZXS3ZcjxjflAxw9HYiD1l3GQG6/asHLI7AfVPjWB51OZhpwvslYshZ8iU7xOG3+msS
         6oOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775808036; x=1776412836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=634Dmh8NJpUnXMsTawnmCgoHk0n99s2/V3zN7QrSSpg=;
        b=hod7aiwx58/Tyx78fOmptxSwnNixh0J4yv0lfqcqQsSfh48rztqdE+Pm7d/kj+QnwK
         WZ84Xt958RbbjPwQcAaXXD8tY/Y+LRpxhE9EYthLd2PR3JY4lnJaj1v7dJuwrjQ5qlmp
         mkSFq/UvrHzoPufgwyw3hS4d3nhtZ2zaurjjcRTYc84A52pFbaugSNNkMrufhRGqfqSS
         yQFea3A84/QrblaX3YbSLoxegJ0WhBE92zIrgncHlCBCaXhiH23O4ujD2z6g7/8mssuB
         Q7hrKg+qoVdK9mGs2wCsWrLQvat8ay9MnZSoPsRegU06UNhkZWBz3BwiX7Gtf3Z7I6P1
         /lSw==
X-Gm-Message-State: AOJu0YydkqZrQQTCC31HscojvOcXEA+o2v4U5cJokqxERW0qAd1txk2s
	AXePhtVB5cj9pIc83CrKiR1VNsxeP/WjbTSDGjMhzG77vNQVtJn4Hwqc3qPPOwqtrRooBNP9FaI
	i1adeVqAq8f60YqlWOO+Gy/peRby7Xm7OOT9vsl3gRXjV+YkDmiHXd6Jl8N9IupQF+Q2Df+YHVT
	t9Bbidv741ObvSsdAiPsN4mFDxKvf+NA==
X-Received: from wrsh15.prod.google.com ([2002:adf:fd4f:0:b0:43c:f5f6:7a44])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6990:b0:488:a2ac:a34c
 with SMTP id 5b1f17b1804b1-488d67f5bf5mr23156855e9.12.1775808036295; Fri, 10
 Apr 2026 01:00:36 -0700 (PDT)
Date: Fri, 10 Apr 2026 09:59:57 +0200
In-Reply-To: <20260410075950.1687350-9-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260410075950.1687350-9-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2065; i=ardb@kernel.org;
 h=from:subject; bh=T5sTl7puRsqzLiSvOrabalA8+UTfZUouj5nq1Nh6ncg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfPGOqbPf2/szZBxtHmvWNeQzfJv/XSWl1E749IN7Fy6R
 er5g9M7SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwEQK9jIyTPNqv2Llc7Z5s9wl
 /yJmzS1P21Je+k+q8C+doxzVarbTnpHhZCrLqaYbfPEWVxxdbScyuF6wv32i8zBHuE/9le+ljj0 MAA==
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410075950.1687350-16-ardb+git@google.com>
Subject: [PATCH 7/7] x86/efi: Drop EFI_MEMORY_RUNTIME check from __ioremap_check_other()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

__ioremap_check_other() is called when memremap() is used on memory that
turns out to be reserved. This may be the case for ESRT or MOK tables
that are reserved via efi_mem_reserve(), in which case they will be
covered by EfiBootServicesData entries in the EFI memory map.

Such entries are created with the EFI_MEMORY_RUNTIME attribute set, to
distinguish them from EfiBootServicesData entries that were reserved
only temporarily, in order to work around firmware bugs.

However, given that
a) __ioremap_check_other() is only called for memory that could not be
   mapped using try_ram_remap(),
b) on x86, the EFI memory map only retains EfiBootServicesData entries that
   cover a permanent reservation,
the EFI_MEMORY_RUNTIME check is redundant, and can be dropped.

This removes the need to set this attribute in the first place, which is
desirable as it results in considerable complexity in managing the EFI
memory map on x86. This will be addressed in follow-up work.

While at it, use switch() rather than if() to avoid multiple calls to
efi_mem_type(), which is backed by a hypervisor call in some cases.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/mm/ioremap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 12c8180ca1ba..5be11e031b8e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -124,10 +124,11 @@ static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *des
 	if (!IS_ENABLED(CONFIG_EFI))
 		return;
 
-	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA ||
-	    (efi_mem_type(addr) == EFI_BOOT_SERVICES_DATA &&
-	     efi_mem_attributes(addr) & EFI_MEMORY_RUNTIME))
+	switch (efi_mem_type(addr)) {
+	case EFI_RUNTIME_SERVICES_DATA:
+	case EFI_BOOT_SERVICES_DATA:
 		desc->flags |= IORES_MAP_ENCRYPTED;
+	}
 }
 
 static int __ioremap_collect_map_flags(struct resource *res, void *arg)
-- 
2.53.0.1213.gd9a14994de-goog

