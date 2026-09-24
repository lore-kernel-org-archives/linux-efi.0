Received: from mta0.migadu.com (out-154.mta0.migadu.com [91.218.175.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027DE41D21A
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289490; cv=none; b=tzyVOzvFAPtXIu/Fqu25Ul0/7gS7j8JmrgzVPNxmMuhFJQp5hM/HH1VBzdUrML1w0ZtmelY6ZXCfuATo++IuZB32QGgD8I8LJLnNlpki+7OSaZqzc3UfDBiGTWtZ6bDO2PDcgj88cNfVU/koviW0t7H4vGCBZdMT3+fp/LXtR48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289490; c=relaxed/simple;
	bh=vil181D960QvjzpQda7p1iELcQx+1UUMUXoKj0Sxk4U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kSaHkxIGClivJ3O+D68VOTojM8wkY+o7t3sBM5s/cjz8o0MfKiBj1TntbQymWMEK1etrZfPIrINqHW1f9+qRu9LCZtIEXlwuBpj8NQyZWBn2VIZVTkf14SKoruDefZTPLEVExBXTUNQvKQYrjbJKXtGR4zHLQy1KmwBAyoI+plU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kfhNpjwN; arc=none smtp.client-ip=91.218.175.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kfhNpjwN"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vil181D960QvjzpQda7p1iELcQx+1UUMUXoKj0Sxk4U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790289486; v=1; x=1790894286;
 b=kfhNpjwNZnN1jdo2y4Mf+IT97SRfjT4PX5j0UpZrUdK/jQ3roq7fo2R0TSSYzqmERGiES12h
 4TC8e9xCQw/uE9uPeL+7DxJyMdDPFn94wK8nRiwnd6uN7p1lXhZxXgKWhbZpfmaJ4CWhXRkC7Ca
 zSwV6sBZwkV34eU0CWfvRhkk=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f8d638709f166d64;
	Thu, 24 Sep 2026 22:38:05 +0000
X-Mizu-Trace-ID: f8d638709f166d64
X-Migadu-Flow: FLOW_OUT
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Date: Thu, 24 Sep 2026 22:35:53 +0000
Subject: [PATCH v2 9/9] arm64: ftrace: Allow CALL_OPS on kCFI kernels built
 with Rust
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-b4-arm64-callops-kcfi-v2-9-587865b6d991@linux.dev>
References: <20260924-b4-arm64-callops-kcfi-v2-0-587865b6d991@linux.dev>
In-Reply-To: <20260924-b4-arm64-callops-kcfi-v2-0-587865b6d991@linux.dev>
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
 rust/Makefile       | 7 ++++++-
 3 files changed, 15 insertions(+), 2 deletions(-)

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
index da1a7409d9845..b402ab768f729 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -511,7 +511,12 @@ endif
 # prototypes for functions like `memcpy` -- if this flag is not passed,
 # `bindgen`-generated prototypes use `c_ulong` or `c_uint` depending on
 # architecture instead of generating `usize`.
-bindgen_c_flags_final = $(bindgen_c_flags_lto) -fno-builtin -D__BINDGEN__
+#
+# Do not pass -fpatchable-function-entry to bindgen: its libclang may not
+# support the section argument (Clang >= 21), and removing the flag does not
+# change the ABI.
+bindgen_c_flags_final = $(filter-out -fpatchable-function-entry=%, \
+	$(bindgen_c_flags_lto)) -fno-builtin -D__BINDGEN__
 
 # `--rust-target` points to our minimum supported Rust version.
 quiet_cmd_bindgen = BINDGEN $@

-- 
2.52.0

