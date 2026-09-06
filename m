Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056C73CCFD2;
	Sun,  6 Sep 2026 13:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788700121; cv=none; b=lsZXGZ2HZmrgQdEO/zIf7zV7UucWlEk885aq8Dry2MwhxB9NwxqTytmyxMMr7Yp1iv5puoY8/0QHeSPKSNBYV3CxRDvqUhMqBTrts5dZ60iE2bwYVg/M5/7VwZQ3/qj4PvQddi9OzNyt6EaKh/n3a5QYpVxfJGcKyjCU6wxlhwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788700121; c=relaxed/simple;
	bh=u/lZldW/Cm68+dTChkN5vlteNqFXMe+bpIYz6xSd9LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daZdjlTNUeaZKElR7sGQbbH+zAA7BnOYqujPRdi7h4g51TOurP1shADWixGg4t57owyaPK6jZSKPaZofJm52/kM8Ytl6XysUgXqVGYHqelWOWeOMH2RaFQWr1VOXR+eXUjFUwNOFEDKtOvXGC7iB3zNh1QIyMZ7F+PpTWdz6118=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a8qUPKqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8qUPKqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9921F00A3A;
	Sun,  6 Sep 2026 13:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788700119;
	bh=0AGX0kN1kzsoE2xguvYOGm/uBS4C2JYRFcF18NAWHsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8qUPKqzxPDptup6MRdxoRq0iardEBfVqF3GpKfoguYn7N2kmoGN8Ymq6CNlsmTj1
	 QzN9gwKM4U1qutbx3b9tue8RIYvh9uqZuZ6aWhHgivLXgZSvn+cI047dMk68GrCnBO
	 QMyACk9hV6Mc1a5qieLrl6cNcJp521s1okoU2jY7WGcoba4tmYTwz2lxGQ2duQyP34
	 09BcXYTQJG6tAGjiGKDcnddrkfGAXW0LfGSaImiShiOMEG1p9BZGd9+i36yBaq/bu/
	 JozHWVXy6ryhsNSpsWAmtKHXAYt/MfGT6RcKQYjDtFtmmLuWKCFNljaiEGA0AdQU2W
	 KGmLNLqUU+55g==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Vincent Mailhol <mailhol@kernel.org>,
	x86@kernel.org
Subject: [PATCH 1/7] x86/boot: Drop pointless re-implementation of panic()
Date: Sun,  6 Sep 2026 15:08:19 +0200
Message-ID: <20260906130817.1151961-10-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906130817.1151961-9-ardb@kernel.org>
References: <20260906130817.1151961-9-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2515; i=ardb@kernel.org; h=from:subject; bh=u/lZldW/Cm68+dTChkN5vlteNqFXMe+bpIYz6xSd9LU=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWtu6pG1+6oumTF5z7nybepbmWDOmQF/OperLX96+W/AB +Z3a8IPdpSyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJcNcxMhysO5Fe9euvzPL/ U9mOvzHfaVijInxH5ubq+hnpRxe/nPaL4Z9+2+qW4usasZVuC7fxvtwicCdqaWXWxG8VPM5KLzr TTnECAA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

The decompressor has its own implementation of panic(), which is based
on the vsnprintf() routine provided by the EFI stub.

Relying on the EFI stub from code that does not execute in the context
of the EFI boot services is a bad idea. It is also completely pointless
in this case, given that the only user of this version of panic() only
passes a compile time constant string, without any printf conversions.

So use error() instead of panic() in that case, and drop the panic()
implementation entirely. This is needed so that the EFI stub's
vsnprintf() can be modified in a manner that is incompatible with the
expectations of this caller.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/boot/compressed/error.c | 19 -------------------
 arch/x86/boot/compressed/error.h |  1 -
 arch/x86/boot/compressed/mem.c   |  2 +-
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/arch/x86/boot/compressed/error.c b/arch/x86/boot/compressed/error.c
index 19a8251de506..ce5ed7d8265e 100644
--- a/arch/x86/boot/compressed/error.c
+++ b/arch/x86/boot/compressed/error.c
@@ -22,22 +22,3 @@ void error(char *m)
 	while (1)
 		asm("hlt");
 }
-
-/* EFI libstub  provides vsnprintf() */
-#ifdef CONFIG_EFI_STUB
-void panic(const char *fmt, ...)
-{
-	static char buf[1024];
-	va_list args;
-	int len;
-
-	va_start(args, fmt);
-	len = vsnprintf(buf, sizeof(buf), fmt, args);
-	va_end(args);
-
-	if (len && buf[len - 1] == '\n')
-		buf[len - 1] = '\0';
-
-	error(buf);
-}
-#endif
diff --git a/arch/x86/boot/compressed/error.h b/arch/x86/boot/compressed/error.h
index 31f9e080d61a..87062dea9a20 100644
--- a/arch/x86/boot/compressed/error.h
+++ b/arch/x86/boot/compressed/error.h
@@ -6,6 +6,5 @@
 
 void warn(const char *m);
 void error(char *m) __noreturn;
-void panic(const char *fmt, ...) __noreturn __cold;
 
 #endif /* BOOT_COMPRESSED_ERROR_H */
diff --git a/arch/x86/boot/compressed/mem.c b/arch/x86/boot/compressed/mem.c
index 0e9f84ab4bdc..e1c017b55184 100644
--- a/arch/x86/boot/compressed/mem.c
+++ b/arch/x86/boot/compressed/mem.c
@@ -37,7 +37,7 @@ void arch_accept_memory(phys_addr_t start, phys_addr_t end)
 	/* Platform-specific memory-acceptance call goes here */
 	if (early_is_tdx_guest()) {
 		if (!tdx_accept_memory(start, end))
-			panic("TDX: Failed to accept memory\n");
+			error("TDX: Failed to accept memory\n");
 	} else if (early_is_sevsnp_guest()) {
 		snp_accept_memory(start, end);
 	} else {
-- 
2.47.3

