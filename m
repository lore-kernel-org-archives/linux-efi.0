Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1295A23A99F;
	Fri,  4 Sep 2026 02:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788488326; cv=none; b=a/pe6n0qPJzxXX6fQIu04064jKVj2sKP9DovzNpcZqHxi/zqC3f/oc0d3rSDxyy6yRGdLCp1aQCAAfDUtOFv0qty99XQwyRj6I7zjgcIkO3rzH9g6uq6SrleNCjRCZuUaNXSdC+ZwUxT332RsABbKnOcx+Z6bWdfFoHV46zL/18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788488326; c=relaxed/simple;
	bh=2vKe9SIi+kPaJ1tVSsMdPJXsUYHXEKmpAMEhFm5m/DQ=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=p41Nd0BGClOdlVEKQpgBCOPSktCrQZZoxeuKWmnCL92SmNzbw+wcpUNn2Ee+VC/+NXy9ZtGEdvL/fRzVxL4M76xmXGEXunqZf5MrZ7eiAujb3tZ/GElRzJzkHGeFGGlqn5aCqNA404HccN7quL6ARMsGkmuf+t1Jkw+Pcjf4tyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UaIEeWtP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UaIEeWtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFD61F000E9;
	Fri,  4 Sep 2026 02:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788488324;
	bh=sIxQ5O7GKOzHUKEwaHhaIsAgRdz8hmxCkdwAf/qbsnc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=UaIEeWtP0MTyKMO/GNHiv4Wvgcfwe4hPIjFDflStZurM/OvSbo3fenkDz7Ehwgp79
	 G9/pfgkH6pE65dmGECFPdS2bZitrApxkMcsZK1/0w25Hf38ZhwLGzEG50F8Z4rVpRv
	 H0jbV+2Dy8eY2QYwK4IMNwxF2sr+qpWmNu0DnP8vTi3Ewa919MKWJ9zvJ+SsH2WSP7
	 ZsRlpy5+XyspMsuFwx6PcaNGE4Bnw6fZwQ4NLNIHJpa4o2TyOsBwcdSpEUGUSlEX0J
	 ro8vMzcp3mH8wiYFcZFWXLsTNrno3uufDEg9oWMkQZQmILE++Ms1tsfHicVRQrcPMY
	 jTjyGVfl+KmPQ==
Content-Type: multipart/mixed; boundary="===============4734120382397292463=="
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <f8a2bae9bd33842b276cff7f66ff799aefbd803f05ac6abc06dbdb486f6a0778@mail.kernel.org>
In-Reply-To: <20260904-b4-arm64-callops-kcfi-v1-2-ce6687739b0c@linux.dev>
References: <20260904-b4-arm64-callops-kcfi-v1-2-ce6687739b0c@linux.dev>
Subject: Re: [PATCH RFC 2/8] scripts/sorttable: Make the arm64 before_func offset configurable
From: bot+bpf-ci@kernel.org
To: jose.fernandez@linux.dev,rostedt@goodmis.org,mhiramat@kernel.org,mark.rutland@arm.com,mathieu.desnoyers@efficios.com,nathan@kernel.org,nsc@kernel.org,ndesaulniers@google.com,morbo@google.com,justinstitt@google.com,catalin.marinas@arm.com,will@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,puranjay@kernel.org,xukuohai@huaweicloud.com,ardb@kernel.org,ilias.apalodimas@linaro.org,ojeda@kernel.org,boqun@kernel.org,gary@garyguo.net,bjorn3_gh@protonmail.com,lossin@kernel.org,a.hindborg@kernel.org,aliceryhl@google.com,tmgross@umich.edu,dakr@kernel.org,daniel.almeida@collabora.com,tamird@kernel.org,acourbot@nvidia.com,work@onurozkan.dev,samitolvanen@google.com,kees@kernel.org
Cc: leon.hwang@linux.dev,ihor.solodrai@linux.dev,jpoimboe@kernel.org,live-patching@vger.kernel.org,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-kbuild@vger.kernel.org,llvm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,bpf@vger.kernel.org,linux-efi@vger.kernel.org,rust-for-linux@vger.kernel.org,ben@cressey.dev,florent.revest@linux.dev,jose.fernandez@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri,  4 Sep 2026 02:18:42 +0000 (UTC)

--===============4734120382397292463==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/scripts/Makefile b/scripts/Makefile
> index 3434a82a119f0..366c6a35141a6 100644
> --- a/scripts/Makefile
> +++ b/scripts/Makefile
> @@ -51,6 +51,9 @@ endif
>
>  ifdef CONFIG_BUILDTIME_MCOUNT_SORT
>  HOSTCFLAGS_sorttable.o += -DMCOUNT_SORT_ENABLED
> +ifneq ($(filter-out 0,$(CONFIG_ARM64_FUNCTION_PREFIX_NOPS)),)
> +HOSTCFLAGS_sorttable.o += -DFUNCTION_PREFIX_BYTES=$(shell expr 4 \* $(CONFIG_ARM64_FUNCTION_PREFIX_NOPS))
> +endif
>  endif

This isn't a bug, but would it be worth letting a configured 0 through
here (or noting why it deliberately keeps the historical 8-byte
tolerance), so the block doesn't read as honouring a value it actually
filters out? As written, when CONFIG_ARM64_FUNCTION_PREFIX_NOPS is set
to 0, the guard treats it the same as the symbol being absent, so both
fall back to sorttable.c's built-in 8. This is behaviour-preserving
today and avoids passing an empty value to expr, but once the symbol
lands with a default of 0 for the non-CALL_OPS case, the one configured
value that differs from the legacy constant is the one the guard
discards.

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/33826319138
--===============4734120382397292463==--
