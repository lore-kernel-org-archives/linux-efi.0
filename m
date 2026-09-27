Received: from mta0.migadu.com (out-168.mta0.migadu.com [91.218.175.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AA23F1079
	for <linux-efi@vger.kernel.org>; Sun, 27 Sep 2026 14:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790517965; cv=none; b=IUtXK5s7H+46ZyxSqBVQivpnE0rgqdhz+HFNFR6BUDpL1xVkcT8HbuomR2NRVnenn7o3tdk5JMUfbW+6PBZ/JOrGJPm6VYxnL03ZZRe6NgSXSUNw+RXdGHk8EN85aD0wqLih4R+3wWUso/8eyqeCrwD95nxMBSTaOA2stX3T5dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790517965; c=relaxed/simple;
	bh=JE5rHMFVp1ASSitG2+LEzV8irkI3ba+nPxRmpmzRXKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Esgb03OFk9iRaTjNsF+UbPjnG9BZK/QsyTCNmk6ffQZZgT5mSdWrMyhwn6uS/+TJ9mxk2+815qU2GwNtZ5WC48tTMri+DVwR65yWJK2hi7fNu1yC86n9M/3mX7HIg8PJ5r8J224WfReI1tdSaFa6/4v2L3OPVCHvAIhHZKrWyWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uzI0Cl/R; arc=none smtp.client-ip=91.218.175.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uzI0Cl/R"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JE5rHMFVp1ASSitG2+LEzV8irkI3ba+nPxRmpmzRXKs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790517961; v=1; x=1791122761;
 b=uzI0Cl/RyPSp9DtXGDQtJb0EsKwZiygL70woO0KClZPbNgzOd7KoYzXh90i5veAqBFlMsVac
 dKpybu3tc1uHncsMPfXrVsuHh6MtpvAT1G5sh8beLUAt+Pq9y769HnxORE/y2DAKzr3vWv7NX26
 6TxKJ1XA9960gwu8uaPtFcDM=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9e0e383a7683fddd;
	Sun, 27 Sep 2026 14:05:50 +0000
X-Mizu-Trace-ID: 9e0e383a7683fddd
X-Migadu-Flow: FLOW_OUT
Date: Sun, 27 Sep 2026 14:05:38 +0000
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: Bill Wendling <morbo@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Justin Stitt <justinstitt@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Xu Kuohai <xukuohai@huaweicloud.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, Sami Tolvanen <samitolvanen@google.com>, 
	Kees Cook <kees@kernel.org>, Leon Hwang <leon.hwang@linux.dev>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	bpf@vger.kernel.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	Ben Cressey <ben@cressey.dev>, "Florent Revest (Anthropic)" <florent.revest@linux.dev>
Subject: Re: [PATCH v2 6/9] arm64: cfi: Use CONFIG_ARM64_FUNCTION_PREFIX_NOPS
 for the type hash offset
Message-ID: <arkimpxRmauCfcn8@linux.dev>
References: <20260924-b4-arm64-callops-kcfi-v2-0-587865b6d991@linux.dev>
 <20260924-b4-arm64-callops-kcfi-v2-6-587865b6d991@linux.dev>
 <CAGG=3QVs=e5JtAs-D98vDsj2ax9H0gH-_rPc0oKhx-vNpq_RyQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QVs=e5JtAs-D98vDsj2ax9H0gH-_rPc0oKhx-vNpq_RyQ@mail.gmail.com>

On Fri, Sep 25, 2026 at 12:17 PM Bill Wendling wrote:
> > +       return 4 + 4 * CONFIG_ARM64_FUNCTION_PREFIX_NOPS;
>
> *drive by review* Could you explain the two fours in this equation
> with a comment? (Feel free to ignore this if it's obvious to
> developers.)

The first is the type hash and the second is the size of a NOP. For v3
I'll spell the second one out and add a comment for the first.

	/* The 4-byte type hash sits before the prefix NOPs. */
	return 4 + CONFIG_ARM64_FUNCTION_PREFIX_NOPS * AARCH64_INSN_SIZE;

- Jose
