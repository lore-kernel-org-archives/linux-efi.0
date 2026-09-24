Received: from mta1.migadu.com (out-237.mta1.migadu.com [95.215.58.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4865541D21A
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289410; cv=none; b=jq3s3CLb7D54+om6SCUgLbffXYYSmf9KkXZV+olnurOI84GuqCpuD5ED+3n9boEH8foVPqaJ1sbZfJ75bvfYCLGQqXI29bgf0zuyrTm71FBN7slMnsR1X14ouJRViokBQSwf16HTXKkAqt75enf/iRdGZ31dlPwQepeC108oAtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289410; c=relaxed/simple;
	bh=kvklvMQb5bIcpXnAuNRAqEBY7d8GE0zlY/tQCrHSqxg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oc8fwEPwZKXXNGfMbOotJ3okK3Y9mDifwuHsxNDbhBhILXZ4XZL4mBSk6Hg4UyBr1JhhLiL45c/ILgPnbC+opyMhfvP55Yg4oazUd0GR1ex4OBZac9Hlyr0PRKurr3yPzLVat/K/VeMguTcXCclYxb3DdaDfN4ZG7stSf3nMba0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KqrZAsZ3; arc=none smtp.client-ip=95.215.58.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KqrZAsZ3"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kvklvMQb5bIcpXnAuNRAqEBY7d8GE0zlY/tQCrHSqxg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790289406; v=1; x=1790894206;
 b=KqrZAsZ3GkIUJfeBg37N2oappBHp7z1XSnGbX5m/UfSQE9Acya1iCfOm7w5+x6YXud5REi3p
 35T5a6xYk1LQgdTRMgKNdzDXGc09v65ClUZkcxCh0MM4VfZT8phh6xjjsVLtA5KjWsMmR16h4zP
 aWrreiOHkqkOJcEa9gVtsqhM=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2f823245de1bd7fb;
	Thu, 24 Sep 2026 22:36:45 +0000
X-Mizu-Trace-ID: 2f823245de1bd7fb
X-Migadu-Flow: FLOW_OUT
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Date: Thu, 24 Sep 2026 22:35:47 +0000
Subject: [PATCH v2 3/9] scripts/sorttable: Make the arm64 before_func
 offset configurable
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-b4-arm64-callops-kcfi-v2-3-587865b6d991@linux.dev>
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

sorttable hardcodes before_func to 8 bytes on arm64 (two prefix NOPs).
Make it configurable from CONFIG_ARM64_FUNCTION_PREFIX_NOPS instead.
kCFI kernels with CALL_OPS need three NOPs. The symbol does not exist
yet, so no functional change.

Reviewed-by: Ben Cressey <ben@cressey.dev>
Reviewed-by: Florent Revest (Anthropic) <florent.revest@linux.dev>
Assisted-by: LLM
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
---
 scripts/Makefile    | 4 ++++
 scripts/sorttable.c | 7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile b/scripts/Makefile
index 3434a82a119f0..daad9b9540b8d 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -51,6 +51,10 @@ endif
 
 ifdef CONFIG_BUILDTIME_MCOUNT_SORT
 HOSTCFLAGS_sorttable.o += -DMCOUNT_SORT_ENABLED
+# 0 or unset (no prefix NOPs) leaves sorttable's built-in default in place.
+ifneq ($(filter-out 0,$(CONFIG_ARM64_FUNCTION_PREFIX_NOPS)),)
+HOSTCFLAGS_sorttable.o += -DFUNCTION_PREFIX_BYTES=$(shell expr 4 \* $(CONFIG_ARM64_FUNCTION_PREFIX_NOPS))
+endif
 endif
 
 # The following programs are only built on demand
diff --git a/scripts/sorttable.c b/scripts/sorttable.c
index d8dc2a1b7c312..925382bb23dcc 100644
--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -281,6 +281,11 @@ static int add_field(uint64_t addr, uint64_t size)
 /* Used for when mcount/fentry is before the function entry */
 static int before_func;
 
+/* How far before the function entry a patchable entry may be recorded */
+#ifndef FUNCTION_PREFIX_BYTES
+#define FUNCTION_PREFIX_BYTES	8
+#endif
+
 /* Only return match if the address lies inside the function size */
 static int cmp_func_addr(const void *K, const void *A)
 {
@@ -899,7 +904,7 @@ static int do_file(char const *const fname, void *addr)
 		/* fallthrough */
 	case EM_RISCV:
 		/* arm64 and RISC-V place patchable entries before the function. */
-		before_func = 8;
+		before_func = FUNCTION_PREFIX_BYTES;
 #else
 	case EM_AARCH64:
 	case EM_RISCV:

-- 
2.52.0

