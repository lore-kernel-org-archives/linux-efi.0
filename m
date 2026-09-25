Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76759472F6C;
	Fri, 25 Sep 2026 07:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322728; cv=none; b=PQbeX4FK1Z5evzJcSJpXnB0a2j5e5A2gm7lNhOn9cgRYKtuPQRmgpbQSeYJ15uQdslex5pd+ee3N9nMZ3cmRK8/7am4gHCsFFQxYfDy6Uioyho+xsZk6NzaEHQJQSCwFowHBphbID+OqUkX1dCupsy7orEkTqSx05x2BuFi8iYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322728; c=relaxed/simple;
	bh=crAnev32KuLVSJVQjGvR5L9UQnWQcWYK9AIZ7Pe38lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sK0X27NjTm3sJKshxDSwPV88cTaPKohsSZcPqPRcg5FcoIp3rEGbfCLTFWh2JT0IqU844iY2Rg5TfLUgHxkUl0xY95z710OJnDXI2KEDSOlJqihtsXbRYf5IJhvLorEg/NVMnyq2ZdPXg0Psy3VAVuQ0WyJwbSysaJvwqNMkr2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N6SHolFL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N6SHolFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3A21F00893;
	Fri, 25 Sep 2026 07:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790322727;
	bh=nAjjmueqCXIzlMRnAfqoy03r2hmAnD29o4maM9aKTQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6SHolFLa6lDebw2ouaPOAOdlejWz6gwgUhmD/Jgm0NlWcTI3hnfdGHS3iUHgqVA5
	 ibx29oHhnQRxwTBSAfGXg4wDjHlXMued0VACvY5KHkxkbX5PRIT0cNjJwwrYiZQauW
	 EFRY0nY2kJKahqLIjAfkyKj3BboAjvJnNbQGETq/PJSqHlxOGgrBZxDfjCV6+I31x2
	 G9P9WX+C6R8pMk/wpuCGM9ADATuwWzudS/B/j3RVHPx8EN73va/ZNzo3526cw4Ve1H
	 GbK15wqGPZ2YtdrNgqeFqo1cD6rGAC62VQzWZh/Jly02dZuL0nUY655J3+5X4FuyNs
	 7ymINlBRO8YQQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: [PATCH v2 3/3] x86/boot: Drop unused implementation of panic()
Date: Fri, 25 Sep 2026 09:51:41 +0200
Message-ID: <20260925075137.44298-8-ardb@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925075137.44298-5-ardb@kernel.org>
References: <20260925075137.44298-5-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1687; i=ardb@kernel.org; h=from:subject; bh=crAnev32KuLVSJVQjGvR5L9UQnWQcWYK9AIZ7Pe38lw=; b=owGbwMvMwCn83sBh/rljoYmMp9WSGLK2aXDZhea8PxooGarCsD3HZJOv29J9n9nO7pzwfDHjZ dt/HcGfOqayMAhzMsiKKbLsVM7pfu0i+k5foTIHZg4rE8gQBi5OAZhIuBJjQ5vR0S3TuxnqVmR+ TC4t0PP5IJDVsUL3VmhM0o44d1aW2ElrtR+uE/QSthCo/6yxclIFY8Nkry0nlzIfnVdkFGS9+lt 3JkvkAYEZystUpjw6caeDqVmfqzw19f+W468MXD+3ahkFrQAA
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
2.53.0

