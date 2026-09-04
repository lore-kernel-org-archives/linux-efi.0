Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B868A36F91B
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 01:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788484833; cv=none; b=sF/jzGXrVKuWoy+k9VQx0arg7tL/BTSj9seBGprTY7Jygg+RgjvJlAg2IYaO5QEDFPYOcbR4WGdBrdFkBbdNVQW7os9TK/5GUIRqazOMviX2p2Y0d9N/sdpbT2MYnsFQp+pB5ZV3AfJHdPdEArzS+Br8R/ah84tR2qdcYHE9IY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788484833; c=relaxed/simple;
	bh=Ufq/i5RxOOSZfLeBtm9lDTBjR97/7RG5RV5oPvNgPrw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TJtq4trJB2+VV0NpNzsubbxW0+BrPUY53GKgPFURzFYaP/xGCeDNU/ao5x8PUS68uNO8w1gh4pBPdngrU6vMAPtbPGKr1fpxyBdFwESPEyIRwOXYSiZ7cfj0xKU2Pot27lactevkLxC8OlPLP1fcCb1R6Q0NemfRtml7nADm4hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MAbJA9Rz; arc=none smtp.client-ip=91.218.175.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MAbJA9Rz"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ufq/i5RxOOSZfLeBtm9lDTBjR97/7RG5RV5oPvNgPrw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788484828; v=1; x=1789089628;
 b=MAbJA9RzogsAnYG35GAkEbvPoWBLzxh+pCyXrG2y1vpmjxpj6PrqTNNvPJm0oocPjWf5t9V3
 Neju+RyphenP3BOAFfpzI23kaDYZ+7niWAaas43FclHTcXZRKPH7wXSGBfcEctCOdUw92pYz+Dp
 lKadYHrxFCsgTlrsRbaAm5Bw=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0b2fa0c76e2e4bda;
	Fri, 04 Sep 2026 01:20:28 +0000
X-Mizu-Trace-ID: 0b2fa0c76e2e4bda
X-Migadu-Flow: FLOW_OUT
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Date: Fri, 04 Sep 2026 01:18:40 +0000
Subject: [PATCH RFC 8/8] arm64: ftrace: Allow CALL_OPS on kCFI kernels
 built with Rust
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-b4-arm64-callops-kcfi-v1-8-ce6687739b0c@linux.dev>
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

Pass -Zpatchable-function-entry=M,M,.discard.patchable_function_entries
to rustc when CFI and CALL_OPS are both enabled, so Rust functions get
the same prefix NOPs as C functions. The section argument needs
Rust 1.98 [1]. Probe for it, and let ARM64_CFI_PERMITS_CALL_OPS
accept RUST=y when the probe passes.

[1] https://github.com/rust-lang/rust/pull/157445

Suggested-by: Ben Cressey <ben@cressey.dev>
Reviewed-by: Ben Cressey <ben@cressey.dev>
Reviewed-by: Florent Revest (Anthropic) <florent.revest@linux.dev>
Assisted-by: LLM
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
---
 arch/arm64/Kconfig  | 7 ++++++-
 arch/arm64/Makefile | 3 +++
 rust/Makefile       | 5 ++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index afa566e0fa86c..cad2bdf3456ff 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -282,11 +282,16 @@ config CC_HAS_PATCHABLE_FUNCTION_ENTRY_SECTION
 	# https://github.com/llvm/llvm-project/pull/131230
 	def_bool $(cc-option,-fpatchable-function-entry=1$(comma)1$(comma).discard.patchable_function_entries)
 
+config RUSTC_HAS_PATCHABLE_FUNCTION_ENTRY_SECTION
+	# The section argument needs Rust 1.98.0 or later:
+	# https://github.com/rust-lang/rust/pull/157445
+	def_bool $(rustc-option,-Zpatchable-function-entry=1$(comma)1$(comma).discard.patchable_function_entries)
+
 config ARM64_CFI_PERMITS_CALL_OPS
 	def_bool y
 	depends on CFI
 	depends on CC_HAS_PATCHABLE_FUNCTION_ENTRY_SECTION
-	depends on !RUST
+	depends on !RUST || RUSTC_HAS_PATCHABLE_FUNCTION_ENTRY_SECTION
 
 config ARM64_FUNCTION_PREFIX_NOPS
 	int
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 653c1ed6ef38f..b23430e2b8567 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -152,6 +152,9 @@ ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_CALL_OPS),y)
 			 -DCC_USING_PATCHABLE_FUNCTION_PREFIX=$(prefix_nops)
     KBUILD_CFLAGS += $(CFI_PREFIX_CFLAGS)
     export CFI_PREFIX_CFLAGS
+    # Rust functions are not patched by ftrace, but they are called indirectly
+    # from C and make indirect calls themselves, so they need the same prefix.
+    KBUILD_RUSTFLAGS += -Zpatchable-function-entry=$(prefix_nops),$(prefix_nops),.discard.patchable_function_entries
   endif
 else ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_ARGS),y)
   KBUILD_CPPFLAGS += -DCC_USING_PATCHABLE_FUNCTION_ENTRY
diff --git a/rust/Makefile b/rust/Makefile
index da1a7409d9845..0036cefbed76f 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -432,7 +432,10 @@ rusttest-macros: $(src)/macros/lib.rs \
 	+$(call if_changed,rustdoc_test)
 
 ifdef CONFIG_CC_IS_CLANG
-bindgen_c_flags = $(c_flags)
+# bindgen generates no code, and its libclang may predate the section
+# argument of -fpatchable-function-entry that a kCFI kernel with CALL_OPS
+# passes on arm64.
+bindgen_c_flags = $(filter-out -fpatchable-function-entry=%,$(c_flags))
 else
 # bindgen relies on libclang to parse C. Ideally, bindgen would support a GCC
 # plugin backend and/or the Clang driver would be perfectly compatible with GCC.

-- 
2.52.0

