Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA01368D42
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 01:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788484793; cv=none; b=KwlDs7IVFND2A3HhH98GwG+EbYXn/xfyuOBnktjFHeWsqtULMM8sUozl6YB23jUYskeKQhVuC8VWhsWjAFSNhnwH+gMM+AkhtLzLGjI92uJXuQuFC1geWf61F9TNiMPZOXO+wo3KiEflT1n7t1bh0I2GeVX3seMwxKdz3+bRZXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788484793; c=relaxed/simple;
	bh=tZJ/wAc28PZRoYc+gt5SIvQmNZsWYF2NkAMRmp4Gagw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OH8GAaLLsIy+4LRIeWI+UUf8JnWiGGH2zTF2n3t9JSKOSrvTKWP0DS28hqZBcn8Qw0OZcg/huEN8IaCL1EfyBe2iX7+XIvm/ocL1HWIIUEpR4RXQNiqfSfu37d9CABU4MbkpvZwJU/hKJBJR+Tii/jHnDB9ngl/PpVU5klxBm6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CAcNyetq; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CAcNyetq"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tZJ/wAc28PZRoYc+gt5SIvQmNZsWYF2NkAMRmp4Gagw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788484789; v=1; x=1789089589;
 b=CAcNyetqaazfxAVAGIey67Drt9MFWmgPJr00fFuD8Hz+q+57PDqfOyK8CmjQ+AoW76PA9rqC
 TiYtLJ762snnKZOX6W/8uHyD4M8z4Odh8UZvVNhpsS2Nupyldq1KEZLqRoBqaCE5FKXpwOd7fGw
 40p0CobkOQkJv3hc4acdtVtg=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6e30568ac1ea25fe;
	Fri, 04 Sep 2026 01:19:49 +0000
X-Mizu-Trace-ID: 6e30568ac1ea25fe
X-Migadu-Flow: FLOW_OUT
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Date: Fri, 04 Sep 2026 01:18:37 +0000
Subject: [PATCH RFC 5/8] arm64: cfi: Use CONFIG_ARM64_FUNCTION_PREFIX_NOPS
 for the type hash offset
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-b4-arm64-callops-kcfi-v1-5-ce6687739b0c@linux.dev>
References: <20260904-b4-arm64-callops-kcfi-v1-0-ce6687739b0c@linux.dev>
In-Reply-To: <20260904-b4-arm64-callops-kcfi-v1-0-ce6687739b0c@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 Puranjay Mohan <puranjay@kernel.org>, Xu Kuohai <xukuohai@huaweicloud.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Sami Tolvanen <samitolvanen@google.com>, Kees Cook <kees@kernel.org>
Cc: Leon Hwang <leon.hwang@linux.dev>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org, 
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 Ben Cressey <ben@cressey.dev>, 
 "Florent Revest (Anthropic)" <florent.revest@linux.dev>, 
 "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
X-Mailer: b4 0.15.2

Make cfi_get_offset(), SYM_TYPED_FUNC_START and the BPF JIT use
CONFIG_ARM64_FUNCTION_PREFIX_NOPS instead of hardcoding four bytes. kCFI
kernels with CALL_OPS need three NOPs, or five with ThinLTO and BTI.

CONFIG_ARM64_FUNCTION_PREFIX_NOPS is 0 on every CFI kernel today, so no
functional change.

Reviewed-by: Ben Cressey <ben@cressey.dev>
Reviewed-by: Florent Revest (Anthropic) <florent.revest@linux.dev>
Assisted-by: LLM
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
---
 arch/arm64/include/asm/cfi.h     |  8 ++++++++
 arch/arm64/include/asm/linkage.h | 11 +++++++++++
 arch/arm64/net/bpf_jit_comp.c    |  8 ++++++--
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cfi.h b/arch/arm64/include/asm/cfi.h
index ab90f0351b7ae..03f02d4614c23 100644
--- a/arch/arm64/include/asm/cfi.h
+++ b/arch/arm64/include/asm/cfi.h
@@ -4,4 +4,12 @@
 
 #define __bpfcall
 
+#ifdef CONFIG_CFI
+static inline int cfi_get_offset(void)
+{
+	return 4 + 4 * CONFIG_ARM64_FUNCTION_PREFIX_NOPS;
+}
+#define cfi_get_offset cfi_get_offset
+#endif /* CONFIG_CFI */
+
 #endif /* _ASM_ARM64_CFI_H */
diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
index d1f7a16729d25..14bc3c67c38b3 100644
--- a/arch/arm64/include/asm/linkage.h
+++ b/arch/arm64/include/asm/linkage.h
@@ -39,6 +39,17 @@
 	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
 	bti c ;
 
+/*
+ * The compiler emits CONFIG_ARM64_FUNCTION_PREFIX_NOPS NOPs between a C
+ * function's kCFI type hash and its entry point. Callers check the hash
+ * at that offset.
+ */
+#define __CFI_TYPE(name)				\
+	.4byte __kcfi_typeid_##name ASM_NL		\
+	.rept CONFIG_ARM64_FUNCTION_PREFIX_NOPS ASM_NL	\
+	nop ASM_NL					\
+	.endr
+
 #define SYM_TYPED_FUNC_START(name)				\
 	SYM_TYPED_START(name, SYM_L_GLOBAL, SYM_A_ALIGN)	\
 	bti c ;
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index c18e005a41dbe..7ad14d9847138 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -185,8 +185,12 @@ static inline void emit_bti(u32 insn, struct jit_ctx *ctx)
 
 static inline void emit_kcfi(u32 hash, struct jit_ctx *ctx)
 {
-	if (IS_ENABLED(CONFIG_CFI))
-		emit_u32_data(hash, ctx);
+	if (!IS_ENABLED(CONFIG_CFI))
+		return;
+
+	emit_u32_data(hash, ctx);
+	for (int i = 0; i < CONFIG_ARM64_FUNCTION_PREFIX_NOPS; i++)
+		emit(A64_NOP, ctx);
 }
 
 /*

-- 
2.52.0

