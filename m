Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712C748CD5E;
	Fri,  4 Sep 2026 12:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526007; cv=none; b=Sq6LyeTfc+suyVeb7ACfia124ttEZCvvCONw1tbL0r0XuhNzrkXRbJuql3xR9IxSdcKTVrqC8TSJ0gKYZVqTnLXAN3kV97H2uYo7n3flMEcNLJ1gNs4QFJuXDS7ciq5+NfxkH5BdfFE5L3AgFecQhrt4I24BH2EdUtKNDsuj09c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526007; c=relaxed/simple;
	bh=As8XxMMmUVQ6vU2afjgBis2r1SCVwnUYWmZavRxoyqU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jn8X9K/O9vPg3ebeYAI/hKFJbqpJg4z2E1TcEq37m6lXcODNOoSPc/g69PdVHAPZRuT5mPqfBZ5IHZ4p/3ClIyBcsdK7OWVhfsX6MquXbZuTZnbdSsnpIZwFAsLELDEglPDl0Z5f/WL7JMtrzINA0Y34GXyDU9f4KCKJphFonIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b=NPdhDsXt; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b="NPdhDsXt"
Received: from omf16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EAF3C120861;
	Fri,  4 Sep 2026 12:46:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 9BA072000F;
	Fri,  4 Sep 2026 12:46:23 +0000 (UTC)
Date: Fri, 4 Sep 2026 08:47:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau
 <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song
 <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis
 <emil@etsalapatis.com>, Puranjay Mohan <puranjay@kernel.org>, Xu Kuohai
 <xukuohai@huaweicloud.com>, Ard Biesheuvel <ardb@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich
 <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, Tamir
 Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?UTF-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, Sami Tolvanen
 <samitolvanen@google.com>, Kees Cook <kees@kernel.org>, Leon Hwang
 <leon.hwang@linux.dev>, Ihor Solodrai <ihor.solodrai@linux.dev>, Josh
 Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, llvm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org,
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, Ben Cressey
 <ben@cressey.dev>, "Florent Revest (Anthropic)" <florent.revest@linux.dev>
Subject: Re: [PATCH RFC 1/8] ftrace: Let ftrace_call_adjust() reject a patch
 site
Message-ID: <20260904084728.6d2ebcc8@gandalf.local.home>
In-Reply-To: <20260904-b4-arm64-callops-kcfi-v1-1-ce6687739b0c@linux.dev>
References: <20260904-b4-arm64-callops-kcfi-v1-0-ce6687739b0c@linux.dev>
	<20260904-b4-arm64-callops-kcfi-v1-1-ce6687739b0c@linux.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oo7jr9m9z6jjp57k8xucfg4kjueaxsfh
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 9BA072000F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18YuV40KmwbrX6ibO0kN1K+x6irXRzKExI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=QaHLNrSIOC0AXa1uJvhFJRMc8GEchbvlX2qvJDmaOvM=; b=NPdhDsXtjyaUMzMA7BQ1IUmN2ClbmLVpUQk/XNTBg4AXNwKSmhvpVdoCLxSbMPJUYrTQkJm8rjuBWqwtcQrN+dnpSw/MTzpEXQryjRIwuo1AHZ9Cn3hsl3hc2lsNlGJBQgi5KY0YSc6iraUWlUhcAydwjDl8WMwfUS/r3zFQnC0=
X-HE-Tag: 1788525983-132897
X-HE-Meta: U2FsdGVkX18t68M7ClrpuwNfMkqgpVsFcoI/sjyjLj3Rj9zo4g6cHAKPRoTEn7iqHMIvC7xF3POXtibnasp7h9/k0RFP/0yKOtn6TVOi8VVb7mGMn0zl0EWK1KLT1h+WhC3Lnd9oYxTXCNf5qKeUNR6xuyEmDQMrF/LjQa+5dSKOd9rcmfh5CFMc+u9fRYl+NOJxaDWkYH/w34kQvyOyqomLGDOtmaqrat7/jVAI/ME4n13QGxwuyrAA2GofGsXAPtDTYNKROvBOI9SKkmbe4hMKocbXXV1wASFNGLdydjcZRo3FRqartvezELQ2dl5E

On Fri, 04 Sep 2026 01:18:33 +0000
"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev> wrote:

> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index f9d80c7bd9f16..394f82230e0c3 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -7676,6 +7676,10 @@ static int ftrace_process_locs(struct module *mod,
>  		}
>  
>  		addr = ftrace_call_adjust(addr);
> +		if (!addr) {
> +			skipped++;
> +			continue;
> +		}
>  

The above could use a comment to why addr could be zero (I didn't even
realize some architectures do that).

	/* Some architectures may return zero for mis-aligned addresses */

-- Steve
