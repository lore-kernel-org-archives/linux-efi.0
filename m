Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1531402B81
	for <linux-efi@vger.kernel.org>; Wed,  1 Apr 2026 12:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775046251; cv=none; b=iT5NiP92jriJd6cmQD7GvyJpveN14toERLnjcUreyPzcbonUEj25DpAp30nfIeNe4tkkXXtNzy/UEfabLhSyQf7RLCxL9ouqrdf/g5nNN/OZXuJBu/hW0lLIch/RodGG5vMKk0qkWHYVwySPOyUKbJq+di9Z2igs9Jd4iKVYolY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775046251; c=relaxed/simple;
	bh=au8J3JXx6lFCqi6g4FwJRLjfxSQilVzeMKUqA5NPysc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KzgN413V24WQ4XH2sU/H1OUwI8TzINLbvorEVya2CN3pxjRBn3oWlRgs9/V/ROpJPGik/ZOjo3zmhRmGCK3O0C405SIBrPX/X/6P844bU9FbQhZCQvlrLuG4T4GUcdxog9/LU5atmnBjBZMykFRxqPhl8PD0ZUTrP0Zsa2kJXNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PpjIhqX4; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PpjIhqX4"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d034589d0so2369682f8f.1
        for <linux-efi@vger.kernel.org>; Wed, 01 Apr 2026 05:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775046247; x=1775651047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iB38xTc/lCZzgKyu5iU+XvCVBzC17imd+nlx2vvhAIQ=;
        b=PpjIhqX4TMBPfrztk9Z2oJMEzAPLuVtO4UR2/MHJsiBxQ9jO7xMpZmN5pM1tcGv6uW
         //GP4bYPInWetAdYx+gYltVs+VBcfPbasN8DyZrAsLsXCVhqtXAO/g21u6UL3tcpFCbS
         uMePNOWbl0eNpDQbHlorBkGl4TaHw+oNeffOD2oFKHbItQvRHaMVu2LihTiFGiRPW63E
         fgD+TWr/vFSmPLIZGbgHxda4I0cNwlhgv3oPRZP8E7SmVgHWUK2TEwA73qSoRT/bvAfP
         r6C4kG9P7Df50C1LAMy8r/Z+Nr1Aic9QU9exeLnV50sW443FGXg8JrijBNM87naoBeT/
         XKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775046247; x=1775651047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iB38xTc/lCZzgKyu5iU+XvCVBzC17imd+nlx2vvhAIQ=;
        b=JXXb/FpbRBjIjqz5tO+uQ+k/kU/MpF3luUiKY/9bZlgIW28qNv646GlZzhG65J47x8
         sfYyL/TR0T4Wzq6Awu2mRO0KRr8F5k/3XHkw8rHoT4nA/6+1Aq1hK9oD92j+FaizmA90
         9/5olAizKBPDDGQ2CgX1MbH9UIUx0K0EDqpyjiRo+sSMHStnnpF2HMYc6VkOj83DZ+IE
         104HBue54uukz2XeGWfq+Jr/ahdt4r2Tba+N0c7Y1TaR/0h4oAvuTTNBI7XyFnwJB6g+
         r1TT86nvS4WLoqsLA7Umt0zO13qKQmqwBvklpVRa7512LqJFlIoqezGpKooEl2ioVTQ6
         OVGQ==
X-Gm-Message-State: AOJu0YygAuBTWTNTgQ5kfBXxWj3u1g+oEDzSGNo4ynNi8o67p8you4jC
	KTWYxnb8hU5K6ybuM5im9zM2SGdPQiYPdsCXYewaGE7/nB/WvZiXnNj8v9I7B91u7i7AISAv+2s
	inYHcRygOq0LVOZhipr+jFElyIa1J3oi3gzNUnb6YhNExz7JF2x2SaxHMJyUlEejjfj83FI+D1d
	gkwZz42/IzalvrV1jcW23nPOUfPl8YVQ==
X-Received: from wrwa7.prod.google.com ([2002:a5d:53c7:0:b0:43b:86e0:73aa])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2c06:b0:43b:86f7:2ecd
 with SMTP id ffacd0b85a97d-43d1504b96fmr6007216f8f.8.1775046247121; Wed, 01
 Apr 2026 05:24:07 -0700 (PDT)
Date: Wed,  1 Apr 2026 14:23:54 +0200
In-Reply-To: <20260401122351.2058145-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260401122351.2058145-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2536; i=ardb@kernel.org;
 h=from:subject; bh=r4Z6Kbm7Kzgsq337UXgzByJyJH3oiBiclKceTmwE7e8=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMsX/S5GaszfuvX3PjzOnu1IteDqpU5nfnZKi3LMlMvc
 H43eMfZUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACay/ibD/zxrrYIZXt+VdbzF
 hc4llNjPeGy7WtR72cstb4qOWr+O1mT4X5Yoo8f82PfGef3q4M2LqqvvbVrB4aQUlnGQX7Azs6K cFQA=
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260401122351.2058145-9-ardb+git@google.com>
Subject: [PATCH v2 2/5] x86/efi: Gather initial memory reservation and table
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

Reviewed-by: Gregory Price <gourry@gourry.net>
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
2.53.0.1118.gaef5881109-goog

