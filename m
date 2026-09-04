Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968C4371CE3
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 01:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788484824; cv=none; b=cu6xlsa1U2YK1Wtgkng989Uhn40gi+ex3+Ynde9iD+fjHOrjiRXZf2QZ9Y1FgjcdtKpbKY/byac4ECTAp62jcma7Jh600TYpunpJ9Ig2ASUla/U4HbOojVU1UXdUBJzwU5MFJPYsCM4jM/Kd51D3iLs8d22BKEtHLHK13bHDgFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788484824; c=relaxed/simple;
	bh=M6XnvhA4rjE605z85iDm8WmXcwxnNbnZIjOfAAtGoPY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b7RYCpFRb+aVaf3NMHB4gt+txGyUBA6vx/e4zV6XNC58UMJiupmt9W1fNeM7layI4x+b3TfVc7vLZtq4xYgo9xLoj0Vaug+EmXsC+6Efc7IpyU8JsJoJ/ri4LvVrSsfnFgxnUHsrmYwBSH6nTbNifbWeBf7w5TnSLrH651sVvUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Avmuc2U4; arc=none smtp.client-ip=91.218.175.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Avmuc2U4"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=M6XnvhA4rjE605z85iDm8WmXcwxnNbnZIjOfAAtGoPY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788484818; v=1; x=1789089618;
 b=Avmuc2U4dYozcSnZV5pcQVQPwwxmCVFJSFW8Gt2ki3XgcgEYARCvp1OWWQfrWPUM0Jxzii9l
 moDrXdfjIpJCpkX1cxhQ0IksB6JzZJj8TT0tKqOr3GanRdWxIx54uzJ5wT+Xa/QWZJCMqVlzH21
 47lxeHyc1psDSMGlmJSrRU5w=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ee407d14cd0d7041;
	Fri, 04 Sep 2026 01:20:12 +0000
X-Mizu-Trace-ID: ee407d14cd0d7041
X-Migadu-Flow: FLOW_OUT
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Date: Fri, 04 Sep 2026 01:18:39 +0000
Subject: [PATCH RFC 7/8] arm64: ftrace: Use five prefix NOPs on ThinLTO
 kernels with BTI
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-b4-arm64-callops-kcfi-v1-7-ce6687739b0c@linux.dev>
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

Default CONFIG_ARM64_FUNCTION_PREFIX_NOPS to 5 on ThinLTO kernels with
BTI. Many functions there have a landing pad but no hash. That moves the
entry point 4 bytes. The 8-byte slot lands on the landing pad and ftrace
refuses the site. With five NOPs every function has a slot.

Commit d3359af21fc9e ("arm64: bti: Disable in-kernel BTI with recent
versions of Clang") keeps BTI off on clang 21 or later, so this default
does not trigger on a mainline build today. Josh Poimboeuf's series to
bring it back is under review [1].

With five NOPs the series costs 7.4% of .text on a defconfig-based
ThinLTO kernel with clang 21.1.4:

  Kernel                 || .text bytes | Delta       | Delta
  =======================++=============+=============+=======
  ThinLTO kCFI, base     ||  21,466,256 |             |
  ThinLTO kCFI, M = 5    ||  23,047,312 |  +1,581,056 | +7.4%
  -----------------------++-------------+-------------+-------

ftracetest results match with and without this series. The three
failures on a ThinLTO kernel are pre-existing. The BPF trampoline,
struct_ops and kprobe_multi selftests pass with CFI enforcing.

[1] https://lore.kernel.org/all/cover.1786768375.git.jpoimboe@kernel.org/

Reviewed-by: Ben Cressey <ben@cressey.dev>
Reviewed-by: Florent Revest (Anthropic) <florent.revest@linux.dev>
Assisted-by: LLM
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6e5fa009c11af..afa566e0fa86c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -290,6 +290,8 @@ config ARM64_CFI_PERMITS_CALL_OPS
 
 config ARM64_FUNCTION_PREFIX_NOPS
 	int
+	default 5 if DYNAMIC_FTRACE_WITH_CALL_OPS && CFI && \
+		     (LTO_CLANG_THIN || LTO_CLANG_THIN_DIST) && ARM64_BTI_KERNEL
 	default 3 if DYNAMIC_FTRACE_WITH_CALL_OPS && CFI
 	default 2 if DYNAMIC_FTRACE_WITH_CALL_OPS
 	default 0

-- 
2.52.0

