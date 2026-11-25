Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590401;
	b=R8/gy0RXBc4NMZHhjozRN0ltLr+gDlDGaeJ1nMCcjTfW0MH2R+rAcAr5GdRAWbX34oPf
	 vcqiyxFA5cIr8uzzSHi2XYixVbu4mIQ67ibzQ5dLQYtQB6r4SR+YB1TF2oCrslZ3iMvxw
	 abxQllBImb1dwk+wVS7sNH3hFGC2X3TnEwGwUAvNVzKgJ/uqia3yIFRXcjgKHDLQJmNoL
	 1XTD7vFsESUp16wBnxtfRslWoXVuTcDtS6L9cNIHbFGQjJGaIW9KQVukUcTh1UF/KfEft
	 r1I3aYXHLMkftsrWHsnEcfS7LdGycKYYoX3okSV4I5BHZbd6by40BD0bYCGsVnAvXxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590401;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=HKNn4jNazmFqiSV3L8j2VorjtfabCulT82MAwWRHOlA=;
	b=zQeNus/qLnym/JYvvTqEcBdBqeDRs/L+qfovG5HGjaJ06O32LNsMmHtLsDFxNU7Z9R6q
	 Vp1jcyAzEo3PkWZwPjsHLyjtnrSorB9jtdu9zraavjT2oyRrQLyUszFr5X9uhCDvrifgD
	 KSIyPL76BjdBxgThiwWRljDX4yJj/pHvmcF3cXUEpsWtGdU2epRZZw67PMcv0X9Doga7U
	 ZCS4qBtKlsCBBjJjv6XT5S52TYpvFYwlaKRW8wLdInKzB2DenqohfNcbLps4/pKXC0g8k
	 ZJKdfKbrMLk6N1d9zYtrwoe6snv1MK6fn3+QNSnoVd2EmY0ZmzOgFZXdM2dJtNucgXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGrkgCi5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0931606A332;
	Wed, 25 Nov 2026 07:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGrkgCi5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078671F008B2;
	Wed, 25 Nov 2026 07:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590400;
	bh=HKNn4jNazmFqiSV3L8j2VorjtfabCulT82MAwWRHOlA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=iGrkgCi5dJbcikKJbxNIr/uSG60Ar4OQjXwvqpPYppMItQaNQ67d0WrZnyxJ1aliN
	 L6mzl2LicNyjT6M4ODiXcVfV7e1A7Rf+uwMfJhmuCsV/GL7xA/ADnkCBdjjTUoRIgV
	 6wSEIDhTK1qikHmTfSHUh6eNoBSpiPdRVJkrqtggmsrWdOHQwNqvr6VNZuwu0M5ilI
	 1oZGXqKFjZaZtZs/xjgnBrgbmyenwI86XP0+HYBIrN4LxavF6YSCNEOlnGgBhKixNJ
	 uuBiPVNYMAtyXnk3iWQLXyckixoj3l28f0NZ8sRgwhbS+q8UBFA6l/3vH9M9TJZ/YF
	 /UZUsRliiaJhQ==
Content-Type: multipart/mixed; boundary="===============8283234434561668137=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <90cc5dff45dcf69975704a288d8b264113adff52b3d7d70a3ba6727e192b1d7b@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-13-irogers@google.com>
References: <20261125061523.1540234-13-irogers@google.com>
Subject: Re: [RFC PATCH v2 12/30] x86/unwind: Add Minimal DWARF CFI kernel unwinder
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:06:35 +0000 (UTC)

--===============8283234434561668137==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> x86/unwind: Add Minimal DWARF CFI kernel unwinder

TL;DR: Nits only in the DWARF CFI unwinder: unwind_module_init() is reused
with NULL/0 placeholders, where a dedicated init hook may be cleaner, and the
get_scratch_reg() prev_regs fallback looks unreachable.

> diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c

[ ... ]

> @@ -299,14 +301,19 @@ int module_finalize(const Elf_Ehdr *hdr,
> -	if (orc && orc_ip)
> +	if (IS_ENABLED(CONFIG_UNWINDER_ORC) && orc && orc_ip)
>  		unwind_module_init(me, (void *)orc_ip->sh_addr, orc_ip->sh_size,
>  				   (void *)orc->sh_addr, orc->sh_size);
> +	if (IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) && eh_frame &&
> +	    (eh_frame->sh_flags & SHF_ALLOC) && eh_frame->sh_addr)
> +		unwind_module_init(me, /*orc_ip=*/NULL, /*orc_ip_size=*/0,
> +				   (void *)eh_frame->sh_addr, eh_frame->sh_size);

this isn't a bug, but the DWARF path reuses the ORC prototype of
unwind_module_init(), so it passes NULL/0 placeholders for orc_ip and
orc_ip_size and hands .eh_frame in through the parameters named orc and
orc_size.

The two branches are already separate IS_ENABLED() tests, so the shared
prototype doesn't save anything at the call site.

Could the DWARF path get its own init hook, for example one taking (mod,
eh_frame, eh_frame_size), alongside the new unwind_module_cleanup()?

[ ... ]

> diff --git a/arch/x86/kernel/unwind_dwarf.c b/arch/x86/kernel/unwind_dwarf.c
> --- /dev/null
> +++ b/arch/x86/kernel/unwind_dwarf.c

[ ... ]

> +static bool get_scratch_reg(struct unwind_state *state, u8 dwarf_reg,
> +			    unsigned long *val)
> +{
> +	struct pt_regs *regs = state->full_regs ? state->regs : state->prev_regs;

this isn't a bug, but is the state->prev_regs fallback in get_scratch_reg()
reachable?

Nothing in unwind_dwarf.c sets prev_regs to anything other than NULL
(__unwind_start() memsets the state, and unwind_next_frame() only stores
NULL into it), and full_regs is only set where state->regs is also set.

Could this use state->full_regs ? state->regs : NULL and drop the
prev_regs = NULL stores in unwind_next_frame()?  The kernel-doc also says
the register is recovered "from full pt_regs", which doesn't match the
prev_regs fallback.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============8283234434561668137==--
