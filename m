Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0547404E;
	Wed,  7 Oct 2026 04:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791348665; cv=none; b=JcbQCC79l17AZgA+vvTIikUAGncJmf8m2M97AtWm98BgvBas3aG7mpOhH/Y760ZCI3rUYckra3dn9zfM9zsACAOF03kCY3G4o9QAa0eVAxHLlw4dbrBFkOlNsN3Z7sT75sQWX5XO0b6umm9MUQzp+xfsz129uaASSPs6fXLrQ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791348665; c=relaxed/simple;
	bh=SRXAnyoTwVbaKw5DdyoF0nZjfpXM9Peq19YZng+OWAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-Id; b=svzFNZC34s8IVz3UJgv0pNTsXSeRvJ96wA/wB2c8AOymXacm9pbLoUHBetf1TslpScXjYdpjXFCRkxDUq3js0KV/ulADg5abB33pHxbhQmHutiNmpqxXVYpXZxOSID/A+8v6V54+3tR0dtj5LHXSf4tuRHmGGW2Hqc97kA2qW+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lRq/cv3J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lRq/cv3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601511F0089B;
	Wed,  7 Oct 2026 04:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791348663;
	bh=YfZUOyUfb3wd5BZD5cwO1pIKgms+v7U6RGWL1mBY3dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRq/cv3JeDXOU7UAotnpyWzkc5IyRNKfUTmp/K9D+Lvv0ReiYLI3VHi2G6fPb9Fe6
	 7hMSRWZiJzioAzkgYeQ4OZlo46uV7DUJzNK2T/BSEGGy8WuhUDq7EGYxcz6mf1AzO1
	 edgEZI5EJtHT2BuB0W6X9LHDsshHEijdDUpm+qzeHYEQ4f4TLLsoDqqregETx9niGK
	 6VutLbFMjj+zfDEKx43onqPWM3GpcsQStQG0HYQ6GlJQkLLe7R88X2ck4BZu+ONvqc
	 7eCfuniZGMkIRBclQDfx2EL8TK1Cidt28FtIWDSMXLSMYWKmrELbdvaeU+ORXcvP6L
	 uzWlvJbA5sDeA==
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: chuck@wolber.net
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Marco Elver <elver@google.com>,
 kasan-dev@googlegroups.com, nathan@kernel.org, akpm@linux-foundation.org,
 anton.ivanov@cambridgegreys.com, oberpar@linux.ibm.com, ardb@kernel.org,
 arnd@arndb.de, bhelgaas@google.com, bp@alien8.de, dave.hansen@linux.intel.com,
 dvyukov@google.com, hpa@zytor.com, jinghao7@illinois.edu,
 johannes@sipsolutions.net, jpoimboe@kernel.org, justinstitt@google.com,
 kees@kernel.org, kent.overstreet@linux.dev, linux-arch@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-um@lists.infradead.org, llvm@lists.linux.dev, luto@kernel.org,
 marinov@illinois.edu, masahiroy@kernel.org, maskray@google.com,
 mathieu.desnoyers@efficios.com, mingo@redhat.com, morbo@google.com,
 Nick Desaulniers <ndesaulniers@google.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, richard@nod.at,
 Steven Rostedt <rostedt@goodmis.org>, samitolvanen@google.com,
 tglx@linutronix.de, tingxur@illinois.edu, tyxu@illinois.edu,
 wentaoz5@illinois.edu, x86@kernel.org, peterz@infradead.org,
 Sasha Levin <sashal@kernel.org>, Aleksandr Nogikh <nogikh@google.com>,
 Taras Madan <tarasmadan@google.com>, Alexander Potapenko <glider@google.com>
Subject: Re: [PROPOSAL] Replace gcov and kcov with llvm-cov
Date: Wed, 07 Oct 2026 04:50:47 +0000
In-Reply-To: <c84149c4-26c3-476e-93d5-4fe72f7c708b@app.fastmail.com>
References:
 00ed0b57-ad05-4c5d-b152-7c81df94b23a@app.fastmail.comCANpmjNOaykC4McAj=gZghqPSQc9aGBP_CjgKmp3n2yjeJTxDSA>@mail.gmail.com<41913a77-5c57-4967-8166-765dd5dde1bf@app.fastmail.com
 20261007023045.04BD71F0089B@smtp.kernel.org
 <c84149c4-26c3-476e-93d5-4fe72f7c708b@app.fastmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <20261007045050.601511F0089B@smtp.kernel.org>

On Wed, 07 Oct 2026 04:17:42 +0000, Chuck Wolber <chuck@wolber.net> wrote:
> On Wed, Oct 7, 2026, at 2:30 AM, Masami Hiramatsu wrote:
> > On Tue, 06 Oct 2026 16:27:11 +0000, Chuck Wolber <chuck@wolber.net> wrote:
> >> On Tue, Oct 6, 2026, at 4:10 PM, Marco Elver wrote:
> >> > On Tue, 6 Oct 2026 at 17:14, Chuck Wolber <chuck@wolber.net> wrote:
> >
> >> >> If there is a desire to take this in pieces or implement other
> >> >> intermediate steps, let me know. Otherwise I can generate a
> >> >> monolithic set all at once.
> >> >>
> >> >> [1] https://lore.kernel.org/lkml/20240905043245.1389509-1-wentaoz5@illinois.edu/
> >> >>
> >> > >> > llvm-cov is generally useful to have; llvm-cov is closest to
> >> > >> > gcov, so that might make sense to replace.
> >>
> >> Swapping llvm-cov for gcov to start with is pretty straightforward,
> >> so I can aim my initial patch set there.
> >
> > Hmm, is it necessary to remove gcov? Would it be difficult to simply
> > add support for llvm-cov and enable (make kconfig selectable) one or
> > the other depending on the compiler?
>
> Not strictly necessary, no. And what you are describing is what our
> original patches do.

OK, let me check it.

>
> The concern was why we would want to have three separate code coverage
> tools in the kernel. Each has their own way of doing things, and they
> can all live together in the kernel harmoniously.
>
> But the concern was raised so I am trying to find a way forward.
>
> The llvm-cov approach gives results that are reliably tied to actual
> lines of source, so that is the one I reflexively reach for any time I
> need code coverage. I am at a loss (but definitely willing to be
> educated) as to what value gcov style coverage provides in comparison.
>

I agree with llvm-cov is better than GCOV. But since gcc users can
NOT use this feature, for checking code coverage in the kernel,
we still need to keep it for gcc users.

> I also found some interesting possibilities using intrinsics to enable
> boot time tracing with llvm-cov. That is, of course, experimental and
> not something I am considering for the intial patch-set. But it got me
> thinking about broader configurability that supports more granular forms
> of coverage that _may_ address kcov needs in the long term.

Ah, that's an interesting idea :)

>
> I have been working on this off-and on for a few years and still really
> want to see this idea succeed. Any guidance on a workable path forward
> would be greatly appreciated.
>
> Another option, proposed by Sasha Levin[1], was to use a single
> /sys/kernel/debug/coverage interface, quoting him here:
>
> "To clarify, are you suggesting that we'll have something like a single
>  /sys/kernel/debug/coverage interface that is producing the same structured
>  output whether we use gcov or llvm?"
>
> I am not sure it is feasible to use the same structured ouput, but it
> would isolate things down to a single interface with KConfig knobs being
> used to select which coverage data one can expect to find there.

Yeah, that soulds reasonable for me.

Thank you,

>
>
> [1] https://lore.kernel.org/lkml/aba_HgSbzLGm6VBQ@laps/
>
>
> Thank you,
>
> ..Ch:W..

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
