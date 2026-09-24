Received: from mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C15D44065E
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289382; cv=none; b=SfdunP5+toSCSa5nOPEcYovm35frIH/uMSCL6VYLJngqTQUO7Iac50+g+WZCgm2LKog3sTWj3tYU1Fau0RVK3lgceFeb0r5w2H3dmaa7aDpSoD2bDbfO0XFTH/nDvaMmgVQpP3Kjc21V/eyo8NiHyiZjx31d4hsW9bLuMJk3gp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289382; c=relaxed/simple;
	bh=xNT7k5QgT4/7eKTlA0ENHVnts3VLHMBXpxpx4Y3InhM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q8qF7pADAfGFSWQq1MzIHtR90VbT7uE8VffFckdYjRwVD+PKjCYL+ytmZb2Sy4L3nwIErVYh/4UAag7mqCdu4bYrx/S5tZKv1kI4KAllWoNObEOo02IS6TlwdkxcASX5D0S/nG2A48HjGNFlZwb8j++ODKlBWUqjQNX1qBUHtoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gSSaijsf; arc=none smtp.client-ip=91.218.175.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gSSaijsf"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xNT7k5QgT4/7eKTlA0ENHVnts3VLHMBXpxpx4Y3InhM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790289377; v=1; x=1790894177;
 b=gSSaijsfZ94ooowZwBkT73DhgjJI1icNFvAP+pqyxi/c0DBZAjsMoGntRw/rLKVVq46CJw3y
 UmDVI/OWPjwmBqIyFLNucftN725ch3D2+f3N5CLLXfEcM7pB40wrkSwynY0COPXqA/HfRbUsWnl
 8AtJs0iJclK0bqMfwwk7IHIk=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 02b280c8d858c0fd;
	Thu, 24 Sep 2026 22:36:17 +0000
X-Mizu-Trace-ID: 02b280c8d858c0fd
X-Migadu-Flow: FLOW_OUT
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Date: Thu, 24 Sep 2026 22:35:45 +0000
Subject: [PATCH v2 1/9] ftrace: Do not leak a module's empty page group
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-b4-arm64-callops-kcfi-v2-1-587865b6d991@linux.dev>
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
 sashiko-bot@kernel.org, 
 "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
X-Mailer: b4 0.15.2

When every mcount_loc entry of a module is skipped,
ftrace_process_locs() leaves the module's first page group linked
with no records. ftrace_release_mod() matches a module's groups by
records[0].ip, which is 0 here, so the group is never freed. While
it stays linked, ftrace_free_mem() reads pg->records[pg->index - 1]
with pg->index == 0 on every later module load, as lookup_rec() did
before commit ee92fa443358f ("ftrace: Fix invalid address access in
lookup_rec() when index is 0").

Unlink and free the new page groups when none of them got a record.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260904013350.5141B1F000E9@smtp.kernel.org/
Assisted-by: LLM
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
---
 kernel/trace/ftrace.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f9d80c7bd9f16..2cc2d41353c10 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7689,6 +7689,20 @@ static int ftrace_process_locs(struct module *mod,
 		rec->ip = addr;
 	}
 
+	/*
+	 * ftrace_release_mod() finds a module's page groups by their first
+	 * record. If every entry was skipped there is none, so unlink the
+	 * new page groups and free them now.
+	 */
+	if (mod && !start_pg->index) {
+		ftrace_pages->next = NULL;
+		mutex_unlock(&ftrace_lock);
+		/* Need to synchronize with ftrace_location_range() */
+		synchronize_rcu();
+		ftrace_free_pages(start_pg);
+		return 0;
+	}
+
 	if (pg->next) {
 		pg_unuse = pg->next;
 		pg->next = NULL;

-- 
2.52.0

