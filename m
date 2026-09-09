Received: from mta1.migadu.com (out-119.mta1.migadu.com [95.215.58.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4EF2F691D
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 02:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788920816; cv=none; b=iKxQ3HVI+ZR/PiGsgs+R5m/xsp7CTDkfUdzhOpr2Twobkc36RlQrg4qJ4kEBGS2JkhPYGVCWzcoMNNlROqrgg+wJIUMmNpg90isBa3zXD0o1xMkksETY/rQ1XdVq3MltGiickfbZOz2Tbxzj4eKc13ZGnfqmjwvKdwyKnaY6BHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788920816; c=relaxed/simple;
	bh=hhi3c8zU+U+EE/Oqa9R3g7YzwauRmJN/Xy5b4xnh/b4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Phc4HaeSgOrdrGHqOOb3hxA5SSjJuw2JKXs99+IKtL3VjX/y346QCAJXMvwmbyQc5jIINM+m3s0Uuhb2BaOe7fbD+Wx96AzVt8nBv1kSyBB8nUrNHC73rpTmAdab8In8RKKptwltaj9F+RmHV27rMewPN24MI2EkLeS1anhXKU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AfNlsM7o; arc=none smtp.client-ip=95.215.58.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AfNlsM7o"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hhi3c8zU+U+EE/Oqa9R3g7YzwauRmJN/Xy5b4xnh/b4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788920812; v=1; x=1789525612;
 b=AfNlsM7o97Br2/sCy3LyFv1cglqrdHrc/mwfcaIcqTIcOatLtpd3zaOEr6eM0C7axcNcxvBm
 +7vOidl348F6u5exW8gV3var8GPZBMJEG6emqdXty5JT/TUT9NgM4adB8xs3szxpTkwa9sNvn+d
 I6NbUW9SyoJK4BTEtjt54v0M=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 23bb6d8fa3f5e24a;
	Wed, 09 Sep 2026 02:26:51 +0000
X-Mizu-Trace-ID: 23bb6d8fa3f5e24a
X-Migadu-Flow: FLOW_OUT
Date: Wed, 9 Sep 2026 02:26:36 +0000
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Xu Kuohai <xukuohai@huaweicloud.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, 
	Sami Tolvanen <samitolvanen@google.com>, Kees Cook <kees@kernel.org>, Leon Hwang <leon.hwang@linux.dev>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	bpf@vger.kernel.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	Ben Cressey <ben@cressey.dev>, "Florent Revest (Anthropic)" <florent.revest@linux.dev>
Subject: Re: [PATCH RFC 8/8] arm64: ftrace: Allow CALL_OPS on kCFI kernels
 built with Rust
Message-ID: <aqDCSBRtnH4wVQDu@linux.dev>
References: <20260904-b4-arm64-callops-kcfi-v1-0-ce6687739b0c@linux.dev>
 <20260904-b4-arm64-callops-kcfi-v1-8-ce6687739b0c@linux.dev>
 <CANiq72=xOrSXBBdmrKYfX1=qgF37LRAMzMJd4GJkXaYHMVe9yQ@mail.gmail.com>
 <ap3Z-YDtzmdtMiMk@linux.dev>
 <CANiq72mVXNmqh-RdOunFLBKRwMgYHFBqJOP7NbXrd8WHPb3sAw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72mVXNmqh-RdOunFLBKRwMgYHFBqJOP7NbXrd8WHPb3sAw@mail.gmail.com>

On Mon, 7 Sep 2026 21:33:03 +0200, Miguel Ojeda wrote:
> i.e. I guess I would have expected something like "...: its libclang
> may not support the section argument (Clang >= 21) and the removal of
> the flag does not change the ABI" or similar.

I will use that in v2, thanks!

- Jose
