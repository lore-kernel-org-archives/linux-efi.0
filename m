Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF74C33F8A2;
	Mon, 14 Sep 2026 18:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411089; cv=none; b=SvdmDMw1fbqx5QOktU36UWQ2lYitlnR1Yw2fxwZlNMIOxmvAKK/4pMuOvVrdEuDiXY/fWYoGDGzTqmS5QF1j1+xjvT4PN3elH2iM3iRWcbIsPj5FNq+25AKxaJBtmxbF3CmGNAoGfjwJuYe/X6rQy0KkNCxUJbXJ1N3gg39/3PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411089; c=relaxed/simple;
	bh=izFpT7OKTB6r+ynqk4XSI+BCN4X4wbUJThWU2dts0e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euCSmN9q/d81U3IsZNpERRaYVhg0xEteks001Ew8K92+/6/8cJCcHjOsmoYoPIHyHLczOQM2uswOXT28JvCxd+a64IxG6oq8hP4jwE+u62QEcF/kNdJjbC25CyC5w8GDkc4q7ZG242AV28cA6Ef1v9vL2VpWAsh7rwXctvglLBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LIQWcpns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LIQWcpns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5761F000FF;
	Mon, 14 Sep 2026 18:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789411083;
	bh=lNSqTRjMqES0isAYw+Wl1SDBpLhQQrsFrzQ9FNYBg58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIQWcpnsFpMkp156ePnWQFJOTMRdzrNkCkW3X31h5RM6FPKiECEytomqll4ZOziJ1
	 HJvSoQ+Ih7qjlVoD58JX36qRlsokNAtSYrSib+vcWaUkWYalhZ9MQf+o2Pr8CGb38/
	 sH+6g6oWc75KtbE0xSbnxK4qfBqd5QvyuZm4b3VpeZlduNCv2vUosnqCjKoX8Z0fhp
	 AfVYFwAJKDIUbKNTXHDK4IfLhPa/Xu+x4wUIXdpzagi/nd88ua7Qf3cg9OqbQ7+xou
	 J6hipRzlM6RKkvJbNg5cB7KdWStUeKfLH5ck3BgdFyMGHNmt48fzA1SO5xjEb/rimG
	 eXr4wXH9zNJsA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>
Subject: [PATCH 3/3] x86/boot: Drop unused implementation of panic()
Date: Mon, 14 Sep 2026 20:37:49 +0200
Message-ID: <20260914183745.37538-8-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914183745.37538-5-ardb@kernel.org>
References: <20260914183745.37538-5-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1687; i=ardb@kernel.org; h=from:subject; bh=izFpT7OKTB6r+ynqk4XSI+BCN4X4wbUJThWU2dts0e0=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuF3U+e/P8KzNGWWnvyA4WmrGQ0/B3s/CZGeumi7Z9+n dSJmL6yo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExk+yRGhjvZ7EbeK+wnuCoo /VvWX/kvYMHOgq/2R2f5nqpdz774qQgjw+Tr3V9LxLfvtTMVmFOnuqKL767CqmVv5mecNnsw56r 5MXYA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

The decompressor has its own implementation of panic(), which is based
on the vsnprintf() routine provided by the EFI stub.

The decompressor's panic() has no remaining users, and is implemented in
terms of the EFI stub's snprintf() implementation, which is going away
(and relying on the EFI stub from code that does not execute in the
context of the EFI boot services is a bad idea in general).

So drop it.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/boot/compressed/error.c | 19 -------------------
 arch/x86/boot/compressed/error.h |  1 -
 2 files changed, 20 deletions(-)

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
-- 
2.47.3

