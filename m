Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F36929D288;
	Mon, 14 Sep 2026 18:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411086; cv=none; b=LaYyMlbh38r5CKqB0KdAD70K6gEJs3As9Eo8Vc+zu9LMRqXRF/4bFgH8j0L/tqYBvtPayw4Zx1/1gVyLmwt/dZH/qAFMy8BCJtebZNKE2sHo1CgxbPyfw5VyBKtHBosgxAysu7cwfEo/pkYVaz0lg/c5wFP0rkYCfdH+jl9K5bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411086; c=relaxed/simple;
	bh=7fvC6tmPvvZsBWIGboxc6DT6cqHkjbJK0VVLs3h7yDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmCGrSdOitHsJeRG6jUaBzLySNV87RjTDIMefpvpIPX56U1z1geUc7AbFBb6rKRg4KNVz1uA3LHnSZuKnhR9/CHB+Xp7Ts0eguR1eBaNQdIs6x9Cj4C2m+iVS8GydyE4YNej8PR9oxKKuP3B6WpSlE4jPyl883i6lcxZmAslWhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RK5wGDAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RK5wGDAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5881E1F00899;
	Mon, 14 Sep 2026 18:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789411079;
	bh=FmTL5XnLGOB37Jqo77v/tK8G9e1D//jUg3LVsiExQKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RK5wGDASsW564l8HO3NFw1zgso2Etn9WyhYEGIAznQ7TE7Uc94prp/oh0m5wd1tzX
	 d8i0GcAi99rBEKb+MqKkduZcnznTTI7KWKvgCyFKvMdhu26jEcGm5lyiKcAin2sHMU
	 LM7PUMr5UWrWLcWpBU7P/HRSko/yNGvEpyLuluLMfsj0cZEvOyJXYQ9PrbM9FBSk5W
	 P8mrSRcBv3BMm2GE9KZnDFrYAxqZeQU4qG8pJVamwTMHUJCHd/9fj3F/4SGoOXhdCk
	 unFcJ3055lDJeUkHVqyW51nBevHAF00h7kDAD/yeMFfOeVHJp7A9Rq2i4CbcvsmF7r
	 jp5E1zn0Ta4ww==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>
Subject: [PATCH 1/3] x86/tdx: Share tdx_panic() with the EFI stub
Date: Mon, 14 Sep 2026 20:37:47 +0200
Message-ID: <20260914183745.37538-6-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914183745.37538-5-ardb@kernel.org>
References: <20260914183745.37538-5-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4390; i=ardb@kernel.org; h=from:subject; bh=7fvC6tmPvvZsBWIGboxc6DT6cqHkjbJK0VVLs3h7yDs=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuF3c+pxyXfpN3JUFCTUfrXdWVLpX9MJavS0znGyl9Ff 59z4ODsKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABMxUGH4p9jW0TL5bMlEO021 2l4zjjd76/4tdlw4schMQPWaXqSjDsP/GoMv5vfaTix3iv71/mHr76WPN14R9+VjeTLF5k+VoXo VMwA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Move the implementation of tdx_panic() into the source file that is
shared with the decompressor and the EFI stub.

Use memcpy() and strnlen() instead of strtomem_pad(), as the latter does
not exist in the early boot code.

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
 arch/x86/coco/tdx/tdx-shared.c    | 35 ++++++++++++++++++++
 arch/x86/coco/tdx/tdx.c           | 35 --------------------
 arch/x86/include/asm/shared/tdx.h |  1 +
 3 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx-shared.c b/arch/x86/coco/tdx/tdx-shared.c
index 1655aa56a0a5..5fc36c8b35db 100644
--- a/arch/x86/coco/tdx/tdx-shared.c
+++ b/arch/x86/coco/tdx/tdx-shared.c
@@ -89,3 +89,38 @@ noinstr u64 __tdx_hypercall(struct tdx_module_args *args)
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
+	union {
+		/* Define register order according to the GHCI */
+		struct { u64 r14, r15, rbx, rdi, rsi, r8, r9, rdx; };
+
+		char bytes[64] __nonstring;
+	} message = {};
+
+	/* VMM assumes '\0' in byte 65, if the message took all 64 bytes */
+	memcpy(message.bytes, msg, strnlen(msg, sizeof(message)));
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
2.47.3

