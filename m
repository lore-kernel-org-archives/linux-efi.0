Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0460A47126F;
	Fri, 25 Sep 2026 07:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322722; cv=none; b=sk3XF341bfvkwpU11TIhQ+wXf754VAZ11SvY2tW4psqEvjFSBTTovGHIBu/Zkeh4vgjSE9xLPbCBVycSJfhIiOt5fGtUwlxL2ziRzSgMI1AYkGZ18eZThkHu567x7JeSgJxB/NkLJmzhec4eIfEWNRDnoR0OTQejP0XsITHtgOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322722; c=relaxed/simple;
	bh=kPoD8lW44V/3nDhlhS9xwNQIIUT/HfnBMhIn+AWS5GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJxQd2cXdeXCfFHUqA62OlE05/Q+7Xa0cDgq4cqTXSWdIFtorxS/MpIA16q76o4DocR1M9rXiyZ2RuhsNDgjM2g5mH+L/stH6Yom640xEzeZ/dKYEeBdFUd7FPnqhYOosb0g3HOBKQXOeddHmhsCsfvN62yWqJ1rXXjzEMSOeUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbeBSiCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbeBSiCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA201F00893;
	Fri, 25 Sep 2026 07:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790322720;
	bh=YUwUc3UZFCV/1P38S16BL8NaNwjtsKwGSQSNoePmnDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbeBSiCDx0cTzIJu00Y9sAjeh/+TfJy7jpND+2F1lnqrHNflzayPdLsbnUI0m2cdO
	 XiLhwnlxl39EdKHBXCx3K72rFOlvQPgbzzExdxOEcgshx067Dn29Q7Z2nrrySPjVnw
	 Vc9nfUjXiZHYmaLMYVRaDMGzBwXw+1+sqWyWXuSq9DgnAY2NzS3Oph7eRSfXaxe2VQ
	 JhGiu8lZZMnESJ9GGMGMpAeMu/zNOYcecw6quZ4sE4SKDfmbVdI+mU/ZurUQJF9vxU
	 63sd1+Ni48RQ8WpwSmcquhMR/TJD+pZW48vO6IBBIPjEXZVYgMU/2Wterk/7jdpmia
	 Ngn5wE64TjHoA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: [PATCH v2 1/3] x86/tdx: Share tdx_panic() with the EFI stub
Date: Fri, 25 Sep 2026 09:51:39 +0200
Message-ID: <20260925075137.44298-6-ardb@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925075137.44298-5-ardb@kernel.org>
References: <20260925075137.44298-5-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4835; i=ardb@kernel.org; h=from:subject; bh=kPoD8lW44V/3nDhlhS9xwNQIIUT/HfnBMhIn+AWS5GM=; b=owGbwMvMwCn83sBh/rljoYmMp9WSGLK2aXAZZD2P7l6TF6cw03tfbqx7c8qXeecnKGqVi15ks M5nT6zvmMrCIMzJICumyLJTOaf7tYvoO32FyhyYOaxMIEMYuDgFYCIs3xgbGhZssJVXZ/0Uo5Vy f8s7pqvFCqI2ETWalzgTuc1bI9a+/hHC9z6+8YXBiY2fz51ONolmbJjQypv485Ck+fnMvZMaTp8 yO3v2+McbRxI4Jj74Zn2zvkXg1u2+l7lvzlZcdNxo+KW7WBYA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Move the implementation of tdx_panic() into the source file that is
shared with the decompressor and the EFI stub.

Use memcpy() and strnlen() instead of strtomem_pad(), as the latter does
not exist in the early boot code. Avoid fortify instrumentation in the
decompressor/EFI stub by #define'ing __NO_FORTIFY before including
tdx-shared.c

Note that __tdx_hypercall() may call __tdx_hypercall_failed() if the
hypercall returns with an error (while it should never return to begin
with). __tdx_hypercall_failed() calls the decompressor's error()
routine, which prints a message and then loops forever.

When called from the EFI stub, this error() call may attempt to use port
I/O to the default serial port rather than the TDX hypercalls which the
decompressor uses normally to print diagnostics to the console, but this
is fine: given that this situation only occurs after a catastrophic
error, and a subsequent spurious return from tdx_panic(), whether
error() uses port I/O or not is rather moot at that point, as long as it
never returns.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/boot/compressed/tdx-shared.c |  2 ++
 arch/x86/coco/tdx/tdx-shared.c        | 31 +++++++++++++++++
 arch/x86/coco/tdx/tdx.c               | 35 --------------------
 arch/x86/include/asm/shared/tdx.h     |  1 +
 4 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/arch/x86/boot/compressed/tdx-shared.c b/arch/x86/boot/compressed/tdx-shared.c
index 5ac43762fe13..dc38047647cc 100644
--- a/arch/x86/boot/compressed/tdx-shared.c
+++ b/arch/x86/boot/compressed/tdx-shared.c
@@ -1,2 +1,4 @@
+#define __NO_FORTIFY
+
 #include "error.h"
 #include "../../coco/tdx/tdx-shared.c"
diff --git a/arch/x86/coco/tdx/tdx-shared.c b/arch/x86/coco/tdx/tdx-shared.c
index 1655aa56a0a5..29661d8dfe8e 100644
--- a/arch/x86/coco/tdx/tdx-shared.c
+++ b/arch/x86/coco/tdx/tdx-shared.c
@@ -89,3 +89,34 @@ noinstr u64 __tdx_hypercall(struct tdx_module_args *args)
 	/* TDVMCALL leaf return code is in R10 */
 	return args->r10;
 }
+
+void __noreturn tdx_panic(const char *msg)
+{
+	struct tdx_module_args args = {
+		.r10 = TDX_HYPERCALL_STANDARD,
+		.r11 = TDVMCALL_REPORT_FATAL_ERROR,
+		.r12 = 0, /* Error code: 0 is Panic */
+	};
+	/* Define register order according to the GHCI */
+	struct { u64 r14, r15, rbx, rdi, rsi, r8, r9, rdx; } message = {};
+
+	/* VMM assumes '\0' in byte 65, if the message took all 64 bytes */
+	memcpy(&message, msg, strnlen(msg, sizeof(message)));
+
+	args.r8  = message.r8;
+	args.r9  = message.r9;
+	args.r14 = message.r14;
+	args.r15 = message.r15;
+	args.rdi = message.rdi;
+	args.rsi = message.rsi;
+	args.rbx = message.rbx;
+	args.rdx = message.rdx;
+
+	/*
+	 * This hypercall should never return and it is not safe
+	 * to keep the guest running. Call it forever if it
+	 * happens to return.
+	 */
+	while (1)
+		__tdx_hypercall(&args);
+}
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index f904a636d449..a9a16d0fb5c2 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -198,41 +198,6 @@ u64 tdx_hcall_get_quote(u8 *buf, size_t size)
 }
 EXPORT_SYMBOL_GPL(tdx_hcall_get_quote);
 
-static void __noreturn tdx_panic(const char *msg)
-{
-	struct tdx_module_args args = {
-		.r10 = TDX_HYPERCALL_STANDARD,
-		.r11 = TDVMCALL_REPORT_FATAL_ERROR,
-		.r12 = 0, /* Error code: 0 is Panic */
-	};
-	union {
-		/* Define register order according to the GHCI */
-		struct { u64 r14, r15, rbx, rdi, rsi, r8, r9, rdx; };
-
-		char bytes[64] __nonstring;
-	} message;
-
-	/* VMM assumes '\0' in byte 65, if the message took all 64 bytes */
-	strtomem_pad(message.bytes, msg, '\0');
-
-	args.r8  = message.r8;
-	args.r9  = message.r9;
-	args.r14 = message.r14;
-	args.r15 = message.r15;
-	args.rdi = message.rdi;
-	args.rsi = message.rsi;
-	args.rbx = message.rbx;
-	args.rdx = message.rdx;
-
-	/*
-	 * This hypercall should never return and it is not safe
-	 * to keep the guest running. Call it forever if it
-	 * happens to return.
-	 */
-	while (1)
-		__tdx_hypercall(&args);
-}
-
 /*
  * The kernel cannot handle #VEs when accessing normal kernel memory. Ensure
  * that no #VE will be delivered for accesses to TD-private memory.
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index f20e91d7ac35..e5785258e547 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -171,6 +171,7 @@ static inline u64 _tdx_hypercall(u64 fn, u64 r12, u64 r13, u64 r14, u64 r15)
 	return __tdx_hypercall(&args);
 }
 
+void __noreturn tdx_panic(const char *msg);
 
 /* Called from __tdx_hypercall() for unrecoverable failure */
 void __noreturn __tdx_hypercall_failed(void);
-- 
2.53.0

