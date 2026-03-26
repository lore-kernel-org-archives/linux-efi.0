Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821982F5328
	for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 13:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774531640; cv=none; b=eHijmuBgpmReHovr3vY59kguhDssV3pR4NiO3VzaOCFfNQPtll0Hlt/3T7Jo48dl5sXRtSm5PnXMDjUacxxSNehQ6PZZSrnjFATQ0cXt00X4t5UA6l//zWXf8WQPIuwNOCbAsCioScp6uyTTkkNqs+o4nxc4oM8NSpKvhsQWQ2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774531640; c=relaxed/simple;
	bh=WbNrFRXlNX50+SwMQqetIvGIhoch9/Q4vJfpPel7DPU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Aq031AI5bTC2bvuk9ab20NNlP/Hmm+1BFL0cEmIa0UMQBBmvF0l0QoYlhMd+vmLphRNjkyG0Lz4VrROmAkmWovolB66+TzmK822RXtmx1guaYD6IS8sRWALPnzz3+CDjsgRFitD6BUbqYEErbLqjJMkBu7hzGxNCsAouf1uj7tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SaNs6d2Q; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SaNs6d2Q"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b97d66528c9so85797866b.1
        for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2026 06:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774531638; x=1775136438; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qqjJgWZvGe+GH9cTzgYDDSkDUy3ExwqWXbelQXjht+k=;
        b=SaNs6d2QY6Fj4A9RqHAxC0LcQchcDzTN9Mnm/lvrJgkeeJRV/CyV9ebbqu/JWfOPna
         XcukaWcJGvG8CbT+mAN4NqFF4M/oD2INDU2HoD7t55V+n7J9DOlr7G6zI7l2lq7BfxBH
         dPwYhDffdBcRe00y3cLmLsPR/ZWYEWTPY/Su5SLb7qLmRgh7Wb3ikyubR290OtRt5Vbp
         J9w32nxmqbPx8ly9e3WrxpodTw+RkrjZRz5sAHUxN7txcyE6sZLKX0hrTX+m2psIxkfL
         RanySP2fm4IA11JnfKJWOsxspbwKPApGl1zP9f+wmEZow2nC/XUYHgyEudW613Vbd8aZ
         KE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774531638; x=1775136438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qqjJgWZvGe+GH9cTzgYDDSkDUy3ExwqWXbelQXjht+k=;
        b=jryFDtFt0nJIv3cm/AtmhaWWN15Ns7srmlAiD23VPXLblKPyKtsLPzgJXJwmUz0D7g
         xeQ8ALpCS0qDh4znaNDRiWRSo94fJdWDUcIGxlztkXHHsuDm1qpUP4k1zxW1VLiHBqlu
         8sf+pR6Qr3LvYpOiWYrkntrCQoKPY0uYzjWTMmaVGn5ab2hRPIgLhm7tKQ0XFdUpR35L
         xL1FLU5qstlXN8c8nRCHqYv3Len4PzC66suaEAj2CD+iR3YcGLgTc7Jj2GBlWACjq6A2
         tNHu/Lth8mTkWZ2QrCgYJfJiDLzekqa/E9cagXXh+QK6oCtvLvj8jNC/uO1Svc/aSOoU
         vmXA==
X-Gm-Message-State: AOJu0YzsTkirpPQmSeSBw17CCYCNwpTMBfAGmhta/INePeHY5Eox9+K1
	Kmlm+5iVYtktqGsbrofdMS3v9fLlvFwZxuOiphghKKnnb8naibsBjWzyPGU4XyVrmYH6LjshwZb
	lVvnUXta7Yt/L+xp/ZJxWtFezdg9I7zkP2ztIetPtPnjGoAZBMlZw9joSMjrjh/28kG6X0hUjIJ
	xt8H8bB1D4Jpwk2mIonA3AGemtTPVW+Q==
X-Received: from ejcji12.prod.google.com ([2002:a17:907:980c:b0:b93:58ba:e1d8])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:4fca:b0:b94:82e:55e7
 with SMTP id a640c23a62f3a-b9b2eb254b3mr105037166b.25.1774531637697; Thu, 26
 Mar 2026 06:27:17 -0700 (PDT)
Date: Thu, 26 Mar 2026 14:26:58 +0100
In-Reply-To: <20260326132655.1733873-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260326132655.1733873-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2488; i=ardb@kernel.org;
 h=from:subject; bh=A55998XzokyKWlEuNht3NSD6O3K91gXWoI+V5wOS36Y=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOoiVISI7fkc6Fnun0ie7Yt2nHP91K2Z4fVa8uWXXobu
 eWSF/N2lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIkETWb4w8U957z2x6vX5Ze5
 uJiFbqmIS3zbmsLfnHWiVePUrZIVuYwMa50e/GZuPv77716rf163QvlMN7DZSbzLunStLHZSgJM 1JwA=
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326132655.1733873-9-ardb+git@google.com>
Subject: [PATCH 2/5] x86/efi: Gather initial memory reservation and table
 handling logic
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, Gregory Price <gourry@gourry.net>, 
	Usama Arif <usamaarif642@gmail.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Move the back-to-back calls to various EFI routines related to
processing of firmware tables and reserving the associated memory into a
helper function. This is tidier, and will avoid the need to add yet
another function call there in a subsequent patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/include/asm/efi.h  |  5 ++---
 arch/x86/kernel/setup.c     | 11 ++---------
 arch/x86/platform/efi/efi.c | 13 +++++++++++++
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 51b4cdbea061..3dcb137a49ed 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -387,11 +387,10 @@ static inline  bool efi_is_table_address(unsigned long phys_addr)
 {
 	return false;
 }
-static inline void efi_reserve_boot_services(void)
-{
-}
 #endif /* CONFIG_EFI */
 
+void efi_init_reservations(void);
+
 extern int __init efi_memmap_alloc(unsigned int num_entries,
 				   struct efi_memory_map_data *data);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index eebcc9db1a1b..9f5f50bff16d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1083,15 +1083,8 @@ void __init setup_arch(char **cmdline_p)
 	mem_encrypt_setup_arch();
 	cc_random_init();
 
-	efi_find_mirror();
-	efi_esrt_init();
-	efi_mokvar_table_init();
-
-	/*
-	 * The EFI specification says that boot service code won't be
-	 * called after ExitBootServices(). This is, in fact, a lie.
-	 */
-	efi_reserve_boot_services();
+	if (efi_enabled(EFI_BOOT))
+		efi_init_reservations();
 
 	/* preallocate 4k for mptable mpc */
 	e820__memblock_alloc_reserved_mpc_new();
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d84c6020dda1..f32276bd8d4e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -165,6 +165,19 @@ static void __init do_add_efi_memmap(void)
 	e820__update_table(e820_table);
 }
 
+void __init efi_init_reservations(void)
+{
+	efi_find_mirror();
+	efi_esrt_init();
+	efi_mokvar_table_init();
+
+	/*
+	 * The EFI specification says that boot service code won't be
+	 * called after ExitBootServices(). This is, in fact, a lie.
+	 */
+	efi_reserve_boot_services();
+}
+
 /*
  * Given add_efi_memmap defaults to 0 and there is no alternative
  * e820 mechanism for soft-reserved memory, import the full EFI memory
-- 
2.53.0.1018.g2bb0e51243-goog

