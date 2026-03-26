Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967DC33F8D4
	for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 13:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774531641; cv=none; b=cY75htTHQn/yFjiRDbzdP2oKVVhTUuRPmAGgIEVzG+vtiZt8zGmHHgTXM/e33Mk1pGfsuiXDx8mlh9qbumH1qChk6rmmWFOJTTgA0BzLijheCJNUpm4AJ6guthgoBnavitgrX/zKFHo4K/0u4y4GyKpyEYzLAwJ03AdcGsSPFWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774531641; c=relaxed/simple;
	bh=w0gWF+fnU+EyIm0hi+wVX5jP3BFK5kjYtXeIFBo8VfY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PfO8zTv+Akqxa5xYETNuPe9+ojGVn74bdJVSQmvQv6+euyRQiR7EeM21JwWA1QcXw/+7h/xLds7ecJJomEwvU4oJDeMdOoCgFhwPt15rHDYu6JlAY+BJuuEpoe4AP6scKq9jIlhScXmD4wZiVImEPEKm9WH/Ai0aas+7lTzE1Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L4ttQcJP; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L4ttQcJP"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-486fb142205so15113705e9.1
        for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 06:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774531639; x=1775136439; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GHIQwAWhL9cMJE4WuFrzIdPhFDdaY3JclpZnGu+ZbFk=;
        b=L4ttQcJPdzQesZ0KRvq7QIjZJVSVHBbfaDLRHuD3Jv159MtmCkNrmR87dQyqj8Txue
         qvUhNyD52sgaPT/M6hdk2RZV6RnK6026ANdZ9nQztsmjBsHTEHhC5vytjk7IVhOOx3YO
         FwzFe8meXrgzXIma4md+gDNKCQcXrRBLQHH7m4Wc3lnxSBlw2YX8StnlOSgN9BpMo3RB
         5GZ5lN99101JCPtQxm+s5JnJKWHgjdT+ZMz3BwbGajacNiI0P6crjONzMvdtNjzZEFRp
         JWVnPrcYXJyLc0vif/VFMPo6Wb+abPPter4oww1ntJLv1qKULQmC5ZogRvBjQk3joCyd
         xRiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774531639; x=1775136439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GHIQwAWhL9cMJE4WuFrzIdPhFDdaY3JclpZnGu+ZbFk=;
        b=agUTYqtohxP/Z162uhSYLxkJIAMzZ4/HgctPNyrLGmwgu3d+PlLdVUL49gRWWFTWQS
         qZS+PTPLCE4+n53XTO7w/0wwYQiqtKQQ4vRr/m0jQa2SU+Ir+TEDGHHADV63Wwr2q2if
         NX9Xc0IEuCuDAtb5YR/dSL1XYizb7CJMGb4YlHjB0fTXHxJMR7E1QMOlDoeHI3aS+tsb
         LzUz3w0yO6lJcfAR3nq8vb0h5uICAHwbV45Ud+KoKy9wT26i/nXOopJ7/ZD+eWluIfO6
         CzBRDw71qozhxv5Qz0LaUoWybfuGd1yRca03I+/jTKEJpNVzctICJNEvcNgM389lUJd9
         +UuA==
X-Gm-Message-State: AOJu0YwrXiy5rnlDavSDsaAhdnBYA98D42aZI4uNyJYOx6EEhF4TtT8S
	9ZPyOT15FePfX8SrDbQMilwKW4MtXuHfaLfcGggVdoR2btmR1ihUEC9BLSnhktbLSh4vQKUgeZM
	a1N6XDReZusoh3VYOHq0cOi17mYIiH+PFFuHD7gvq0YsFWF1bZVXQCdT4Ga74sI73Ylk8WWkLkJ
	syY3KNrhrVynKReYJGJA1Cm4x5Jx/UVA==
X-Received: from wmjv19.prod.google.com ([2002:a7b:cb53:0:b0:485:2ff0:b4ad])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:890b:b0:485:6ec7:2df
 with SMTP id 5b1f17b1804b1-48715fd50abmr89023025e9.8.1774531638838; Thu, 26
 Mar 2026 06:27:18 -0700 (PDT)
Date: Thu, 26 Mar 2026 14:26:59 +0100
In-Reply-To: <20260326132655.1733873-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260326132655.1733873-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1578; i=ardb@kernel.org;
 h=from:subject; bh=dWW9mhL2BAGt3mcyh6Fj0ZP76AqTMt2tFZlrnJvD3Uc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOoiYrV7Z89zbnNE6ezfVOKjP12Z75YAN9hgSlemSyJ1
 w7aqxR1lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIl4PmVkmBmwUrrgJO+KSwbv
 xWdVPqu8ZWqess+t/nOi2+5Pc1ZMYmNkWD2pM+SWqKnpNe9it7bqJaYvwtef61Oe9fbDtW+5Nzq YWQE=
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326132655.1733873-10-ardb+git@google.com>
Subject: [PATCH 3/5] x86/efi: Defer the call to efi_memattr_init()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, Gregory Price <gourry@gourry.net>, 
	Usama Arif <usamaarif642@gmail.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efi_memattr_init() should call efi_mem_reserve() rather than
memblock_reserve() to preserve the memory contents of the region when
the EFI memory attributes table is loaded by the firmware.

However, efi_mem_reserve() can only be called later during the boot on
x86, due to the fact that it may need to memblock_alloc() memory for the
EFI memory map.

So move the call to efi_memattr_init() to a later stage when building
for x86_64.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 2 ++
 drivers/firmware/efi/efi.c  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f32276bd8d4e..107dcdf354ba 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -167,6 +167,8 @@ static void __init do_add_efi_memmap(void)
 
 void __init efi_init_reservations(void)
 {
+	if (IS_ENABLED(CONFIG_X86_64) && efi_enabled(EFI_MEMMAP))
+		efi_memattr_init();
 	efi_find_mirror();
 	efi_esrt_init();
 	efi_mokvar_table_init();
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index b2fb92a4bbd1..d28ed1ce9a33 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -761,7 +761,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 		}
 	}
 
-	if (!IS_ENABLED(CONFIG_X86_32) && efi_enabled(EFI_MEMMAP))
+	if (!IS_ENABLED(CONFIG_X86) && efi_enabled(EFI_MEMMAP))
 		efi_memattr_init();
 
 	efi_tpm_eventlog_init();
-- 
2.53.0.1018.g2bb0e51243-goog

