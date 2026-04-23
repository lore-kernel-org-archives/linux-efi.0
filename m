Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3064833D4E2
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957670; cv=none; b=ijwvkTGCQOd20E55+Gok19j1aCqfUNflIuo87K51R6zh1eZPmO0EG12HCrrVoeoFWxPRd2izoDsXvVtTvbhI0gcYe/A4htUxeXkW5GJ/OAmGRlGAukROLAKR7MRA3LedMpth4D08zY/ZVHN7IJQD6TlLAYw1/mIMMW7B99+3738=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957670; c=relaxed/simple;
	bh=ecAmlKD2UQkybmDAzI1zpd+FbZQvA7blVj9VpuIkWTM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O7a1WMW9lzhTa7dd/LNDtJNKq9jOsg31K19WBQkzAoLyR6ioNdgyDKtCsWzjoGAbpKMeThi+ZNIH4uACcnsfcbWSrEExAWR1sUQiOJ2DjYHvarhQFUYSzArGSjUotdk8JfGjsN80o/a7FbWYlNtzoVKDAt+iKwoDKTeGv0k1PoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gk2xpW4a; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gk2xpW4a"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48a55ecc249so24415765e9.1
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957668; x=1777562468; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DgaUOuQsmpy7UIfoAx7B9eDC63iILUiw+rYZIcX3QCg=;
        b=gk2xpW4aUvoCoxkbWddnq6+8kD3lZ4Q+JYipR16IYpa61dOY+DNMXSqNhOXQTCjLGM
         SJ5wyBh7Kl3uC0CiXJNRoQ7TYhVG6S0S8ve9lPclWJ3TYkOZWrHZg87yDnb5atDcvQL4
         8oKFocZOgFGlrH9A+a6LrVgKAYDmd/qUILRxxn6X8bTaJx0maLiFHk56gsj7MiuFRzMi
         6qLuyPQdR9H6tRE7d90ALDoW98xM8nVe8hskMOTutbio01dXpcWRl/shf3clbo6r9ZaN
         w7u1dQre1a/2ZKkincbOyxGp8g1DN7X4m/7DT0xk3+MAe+boIaTVvYIWsBHu+xXNswVC
         HfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957668; x=1777562468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DgaUOuQsmpy7UIfoAx7B9eDC63iILUiw+rYZIcX3QCg=;
        b=dvqX4izF2tdfpSs/kUHnKhkp0JO6iky1or2V73sQmgioteaZlvdvroIUE4DrbvdqlG
         0vprspzZD2HARcosjS6oa3NmPWJWmMm9vdAg8/sEiu+WlirM58fPCdKTXPabIiOBkyxv
         X84ChUfca2KyeH9QjgewrQacn32DSrbOT+oEXATsaeC3pBcZlIuujl+hYoMXZeuclury
         HZyuRBQcCmMaQwAyB+YEqPWr6bD3qNhtxBRwFq9y41x7mMb9ApsIa9Ya/25wksUmzmLW
         eKgRVfZXQI579hDP9sGjMDrl3hghal/HcxNJsthrsRRAMpW6/wJwvf25t95MQaCbpDbt
         m/Gw==
X-Gm-Message-State: AOJu0YzZIMN1mcQ7jgnGd95Jx0SbPT0vNiIPFDe0UXYwDdvSIJo0YDmX
	mT3TkbH0cjtgAhFvUIhofLqGhf423ZAdcyU74XTQuKGiLh+DlRUTi4xwVwviGQAVinbX1r2qvA=
	=
X-Received: from wmhn18.prod.google.com ([2002:a05:600c:3052:b0:489:1ffd:15c7])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f8c:b0:48a:58ae:993b
 with SMTP id 5b1f17b1804b1-48a58ae9faemr164289565e9.16.1776957667506; Thu, 23
 Apr 2026 08:21:07 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:32 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2080; i=ardb@kernel.org;
 h=from:subject; bh=gwbvKwBOjjoC55cL0c8AdYcFSGCt7/IeToq2a8GYrj0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxWFuHveZf6acvvI/YuI/zXVJW1mrpuceY9u3RO4Ry
 +3zV/c96yhlYRDjYpAVU2QRmP333c7TE6VqnWfJwsxhZQIZwsDFKQAT2X6N4X+cUe31Ov20qx6X
 kiwefOOt31zFq9Ngadf3errrtCcJc+4zMvQVz54wUfOrC//J7MNebvvmhGy7tj9xwbYCRkMf3mw +bk4A
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-26-ardb+git@google.com>
Subject: [PATCH v3 07/17] x86/efi: Drop EFI_MEMORY_RUNTIME check from __ioremap_check_other()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>, Tom Lendacky <thomas.lendacky@amd.com>
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
 arch/x86/mm/ioremap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 12c8180ca1ba..50377423d422 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -124,10 +124,12 @@ static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *des
 	if (!IS_ENABLED(CONFIG_EFI))
 		return;
 
-	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA ||
-	    (efi_mem_type(addr) == EFI_BOOT_SERVICES_DATA &&
-	     efi_mem_attributes(addr) & EFI_MEMORY_RUNTIME))
+	switch (efi_mem_type(addr)) {
+	case EFI_RUNTIME_SERVICES_DATA:
+	case EFI_BOOT_SERVICES_DATA:
 		desc->flags |= IORES_MAP_ENCRYPTED;
+		break;
+	}
 }
 
 static int __ioremap_collect_map_flags(struct resource *res, void *arg)
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

