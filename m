Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B5E44065E
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289396; cv=none; b=SXesTJ+CFoC6z9HoXf8QeTGcFiC0+mlIEE6lUc1pUNTZFBMWeUXAep604UqoqqPaWIMGuLEQeFdXSC3OX+A0qEpP/lwch4dGCfXCTMEydIH9meekNPpoe4UwuYDBNd83XoJo65batKLUxC7ZZgXoLzCXB3LJD+LBPDOU9Zz6ALc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289396; c=relaxed/simple;
	bh=6tASAd8sUDq5Ftr41lemiI/nY6tO72VqXbeQ3Os+o5Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Jr7UHK6Yi339/XHDUZ5bk+pLEQqMhZwDgIJVADXj3lgprWxbv80O62qQ7HnT6SJoPZB0P58+llFa9PnsaKOBFrY/yx5xmxU0fTGi8TRtn7yaUC9Vy17jg8+UCwktetIiqpazLh9ZVjM1lSuFZXtvVInnWtD5ziM2X7f7phaedPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B41dXUOT; arc=none smtp.client-ip=95.215.58.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B41dXUOT"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6tASAd8sUDq5Ftr41lemiI/nY6tO72VqXbeQ3Os+o5Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790289391; v=1; x=1790894191;
 b=B41dXUOThndc05ma5tGSSoiI86LIS0CyB2WJBO9fEj/lP4Ztem5KgGOpxCzkYEfZE43IArqE
 bJial81CjDJBPlwt3GyBjQ8dC8IkZsN9Tr1yJHTFPB5ZfHFADwr0WomNwe/gIjlEbpn7CzSYPrO
 oQmAJnjiF4aRHimuno12lBbA=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e5a9a7017ca58495;
	Thu, 24 Sep 2026 22:36:31 +0000
X-Mizu-Trace-ID: e5a9a7017ca58495
X-Migadu-Flow: FLOW_OUT
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Date: Thu, 24 Sep 2026 22:35:46 +0000
Subject: [PATCH v2 2/9] ftrace: Let ftrace_call_adjust() reject a patch
 site
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-b4-arm64-callops-kcfi-v2-2-587865b6d991@linux.dev>
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

When ftrace_call_adjust() returns 0 for a patch site,
ftrace_process_locs() does not skip the site. The NULL test runs before
the adjustment since commit 6eeca746fa5f ("ftrace: Test mcount_loc
addr before calling ftrace_call_addr()"), so the 0 is stored as the
record's ip and ftrace_init_nop() later hits the BUG_ON() in arm64's
patch_map(). Test the adjusted address too and count the site as
skipped.

Reviewed-by: Ben Cressey <ben@cressey.dev>
Reviewed-by: Florent Revest (Anthropic) <florent.revest@linux.dev>
Assisted-by: LLM
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
---
 kernel/trace/ftrace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2cc2d41353c10..fa541d3e8784a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7676,6 +7676,11 @@ static int ftrace_process_locs(struct module *mod,
 		}
 
 		addr = ftrace_call_adjust(addr);
+		/* The architecture may return 0 to reject a patch site */
+		if (!addr) {
+			skipped++;
+			continue;
+		}
 
 		end_offset = (pg->index+1) * sizeof(pg->records[0]);
 		if (end_offset > PAGE_SIZE << pg->order) {

-- 
2.52.0

