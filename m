Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6133D351C3B
	for <linux-efi@vger.kernel.org>; Wed,  7 Oct 2026 04:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791346688; cv=none; b=q6vzbVBWP4DaH+UIbzvvntaBdNBcqnMePW2DzPeX8VuDsZ9fesTplvNn3IJnw6YKwk1ZB8Dc7fU4B5tdQK+xCdLje7AeoDgkuW9oCqE7jaeOy86/rblhOhs1VXe06eTTZrKjfQZ51qDiCi3QQ+4YRNf6WnM4CAJB4sXW5ONI89I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791346688; c=relaxed/simple;
	bh=9S5NccjG3n1fFQc9t/+Xwyj0iezJs8kEGC0cyk8cO98=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=e7a2qeuwVreJYJR39+SLlNHhfth1u8Dwg7l6TuqucqARtarr1l8H+cVdCn+SLjpptqdu/DMKt42YU6bhcMdTwefZRts6Qh86WyiU/C665nEybPnkIeh8ewCIT0+oE1Y6G12LHHoCdGVvbn9mG2dzmQD4aOs2Bk08LBktBFMA5ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wolber.net; spf=pass smtp.mailfrom=wolber.net; dkim=pass (2048-bit key) header.d=wolber.net header.i=@wolber.net header.b=IQZA88iK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OBqaJc0A; arc=none smtp.client-ip=103.168.172.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wolber.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wolber.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wolber.net header.i=@wolber.net header.b="IQZA88iK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OBqaJc0A"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 8680F1380414
	for <linux-efi@vger.kernel.org>; Wed,  7 Oct 2026 00:18:05 -0400 (EDT)
Received: from phl-imap-03 ([10.202.2.93])
  by phl-compute-03.internal (MEProxy); Wed, 07 Oct 2026 00:18:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolber.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1791346685;
	 x=1791353885; bh=9S5NccjG3n1fFQc9t/+Xwyj0iezJs8kEGC0cyk8cO98=; b=
	IQZA88iK7AJYt5pzO6v4OKlxB3zQGobNkO7OIHqiX0niMzVRTeE15KVD7DwHdhm1
	T3hBM2Guz9u/tqjqQ07x9VU3Y/njy5jetotWs8uJZzcUFYiG9NCTgVA8/RiIovrD
	x/gAoeKpTtuRHaAhb6qMBxMHOkNCnvd7+9IfWvKpillkzcdHW6pf/pQV3mbawk9r
	rDrlamaA0yKnZPHZBED087B4lbSvZDyGStLi9VJ+sobUyguSNc+zEIUb+db9eDQR
	8l7fU9lR06hYhSJITZPxvuoWEFczbVQfGS0iLr0rEb5apEhUffLfVFepmJ51JSXJ
	0VsXCAY4xXjLdLupZPS49Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791346685; x=
	1791353885; bh=9S5NccjG3n1fFQc9t/+Xwyj0iezJs8kEGC0cyk8cO98=; b=O
	BqaJc0AxDCjGpknaYYzeKKbnfIkl50X1+ZQBb60RCaPciCQtFpBBRu42u9/seknA
	246dvLoNBUIPtHPCJE2SnUPA6zr0i7qmjp/XcS85wRcqBBRohJ3nWiEYakLe7wDy
	GkIBMxHS1P3gvF76xpM6edc+7jqcrhRVUCnJYdw6eX/i5ObvLhRXNs8GJzKpLpJa
	7ZZ+T+773L2DXaBLaQqyXPwwsMaBQgWy+lcXd2aU6FQoeu08kPgFmpAYcpvr7Opi
	QSPRfLpoE8pV4+mBPXHIF25nYhxHofGRgt0UyzAy46jc8K/3DNfsgKi0FmNGah4e
	PyzQy0wRu7aWDswkueJXw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=wolber.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791346685; d=wolber.net;
	mf=PGNodWNrQHdvbGJlci5uZXQ+;
	rt=PGxpbnV4LWVmaUB2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:h/f5tR1ToSffUJKXm2jJYuvxQWB1ACBdk2QQoTnEBQ/Jsnu
	3g9mqGLpmICIt8u5FdUimIbT/k0oD0p1b0vpUcJ2lhlae9DytvB2VJmgiRSWIGut
	SkAFk7kLl9Dzz9St3apPq1tHwWXMtOO7DVQbAMQyPdfM8S4UmHXuyREvYTblW3tK
	HhhGz/XxZQkeT7CU7lqgVkeWw8dm7TA4bgJ//VYZicUSfCLQ/8yEIVXPJ27r6kLE
	ovRsjtVLwuF8RjSjOQeIOwdmNpFfRYeC3WQsE+beMXMuxlSH5ZehyuTHBoYhMbsU
	xvlBBVGTHIdTmBJqwJQNbatbieiFbZTVPOjLvng==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:69WtHAdzzGt++L0dmN+dpT9JdF3kbS7Kh70yb3qik2c=:9S5NccjG3n1fFQc9t/+Xwyj0iezJs8kEGC0cyk8cO98=;
X-ME-Sender: <xms:-sfFankfTAViNMv3UaVgC4c0bF7lgovEdmDD_sRDZXzkQMDkyDLGqQ>
    <xme:-sfFalrwynIQj1LZPsQuJfCtOgQDOh3qGJL5Ht1D6bxg3tkZmYGYqz8Wls_ixoI4W
    yOq9NoxMqduXWAUvGFM9Q1Oez4If0imMVPLeXkTdr2Q-0pt4Z7WhNUE>
X-ME-Proxy-Cause: dmFkZTGMWFIAehxsmdq4ynFlrmrbbKja5RPgzcPokhGUAyn4XwkA+/i+RzCPcfSVyyv1sF
    pvH5x0fdtSQTSOL1Ie1RGCryBqw4p8+JTrlkCzXTJjeB2LTHc2y/IhYfsZc/v7gKPn1GgF
    LOpV9hAc96CGDI3kIaAH2g4lcCJ8eJO8UaW8jQygRRjRzdD50EOOrRpyv399w60Bpma9hG
    dbJ/PQRa6wxx5LBjtxjhrUYNvUmb1w23fhUz343gRmuzl0ey4+vwOyNSWO5QE2Gbxpeim3
    chPU/Ad1oAucTj/8Ox4TZLoFR9dmZED//6gQojakDPoH3DJ6dB4s/Zn7buUz1WHEl0ItdQ
    jTXho14WghAZB50Nxe0TxBDRIEJ/JOXdG4tdfo59QeG5vvEZmcpCDhr1AGb4rJEVoiKbRA
    M0C8QvLxZ1tHd8P6Va810oBmIt53Kpqwt31IOTWoV3VKEJR7OshUBbuXxpPJHEcKKeAdR9
    PMIE1XUDGOXkuBoLXxrnR/Yu7d9M2SJhsr0vP+BEBtSODX6lrEZXZ9fkj4pnyAbFaEtA2k
    5jZ3Jz2FekmPVGRVXixhFSNiw1uZUCuk6ZD1oj8kcaWlofoxAQzrwvVhsALXOoqfYYXmm9
    tjR8Q2NiaTcJkwEjLnuU9tBRlaZk8a0X45tOls3RbVeE1JQX1mky/6o+kELg
X-ME-Proxy: <xmx:-sfFarCebjcIJ7C8C31f800cCyhpG0g0wAfK8PHBEUXN3qDPePrWsw>
    <xmx:-sfFaq3dnhm_VNN38CWghMHp1GOfYjtWJ93pIek88XAgz6KQD2XU9g>
    <xmx:-sfFalUbx3PLJSGF---EunyZ0kdq-Sf0NkmApNCdzh0FQlay8lnzmQ>
    <xmx:-sfFaoxRjhTrC2EHqQUkWimeN4LBGAmXHVrYSa1EOoATTC8ALNDmKQ>
    <xmx:_cfFajZ_NsPKILnROCJCcMFnrB-e_Q_hRFyKz_eQdfYJutKOPj4EfuIp>
Feedback-ID: i5cf64821:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6407D18E006C; Wed,  7 Oct 2026 00:18:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A8p1gvDKPv03
Date: Wed, 07 Oct 2026 04:17:42 +0000
From: "Chuck Wolber" <chuck@wolber.net>
To: "Masami Hiramatsu" <mhiramat@kernel.org>
Cc: "Marco Elver" <elver@google.com>, kasan-dev@googlegroups.com,
 nathan@kernel.org, akpm@linux-foundation.org,
 anton.ivanov@cambridgegreys.com, oberpar@linux.ibm.com, ardb@kernel.org,
 arnd@arndb.de, bhelgaas@google.com, bp@alien8.de,
 dave.hansen@linux.intel.com, dvyukov@google.com, hpa@zytor.com,
 jinghao7@illinois.edu, johannes@sipsolutions.net, jpoimboe@kernel.org,
 justinstitt@google.com, kees@kernel.org, kent.overstreet@linux.dev,
 linux-arch@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-um@lists.infradead.org,
 llvm@lists.linux.dev, luto@kernel.org, marinov@illinois.edu,
 masahiroy@kernel.org, maskray@google.com, mathieu.desnoyers@efficios.com,
 mingo@redhat.com, morbo@google.com,
 "Nick Desaulniers" <ndesaulniers@google.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, richard@nod.at,
 "Steven Rostedt" <rostedt@goodmis.org>, samitolvanen@google.com,
 tglx@linutronix.de, tingxur@illinois.edu, tyxu@illinois.edu,
 wentaoz5@illinois.edu, x86@kernel.org, peterz@infradead.org,
 "Sasha Levin" <sashal@kernel.org>,
 "Aleksandr Nogikh" <nogikh@google.com>,
 "Taras Madan" <tarasmadan@google.com>,
 "Alexander Potapenko" <glider@google.com>
Message-Id: <c84149c4-26c3-476e-93d5-4fe72f7c708b@app.fastmail.com>
In-Reply-To: <20261007023045.04BD71F0089B@smtp.kernel.org>
References: 
 <00ed0b57-ad05-4c5d-b152-7c81df94b23a@app.fastmail.comCANpmjNOaykC4McAj=gZghqPSQc9aGBP_CjgKmp3n2yjeJTxDSA@mail.gmail.com<41913a77-5c57-4967-8166-765dd5dde1bf@app.fastmail.com>>
 <20261007023045.04BD71F0089B@smtp.kernel.org>
Subject: Re: [PROPOSAL] Replace gcov and kcov with llvm-cov
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Oct 7, 2026, at 2:30 AM, Masami Hiramatsu wrote:
> On Tue, 06 Oct 2026 16:27:11 +0000, Chuck Wolber <chuck@wolber.net> wrote:
>> On Tue, Oct 6, 2026, at 4:10 PM, Marco Elver wrote:
>> > On Tue, 6 Oct 2026 at 17:14, Chuck Wolber <chuck@wolber.net> wrote:
>
>> >> If there is a desire to take this in pieces or implement other
>> >> intermediate steps, let me know. Otherwise I can generate a
>> >> monolithic set all at once.
>> >>
>> >> [1] https://lore.kernel.org/lkml/20240905043245.1389509-1-wentaoz5@illinois.edu/
>> >>
>> > >> > llvm-cov is generally useful to have; llvm-cov is closest to
>> > >> > gcov, so that might make sense to replace.
>>
>> Swapping llvm-cov for gcov to start with is pretty straightforward,
>> so I can aim my initial patch set there.
>
> Hmm, is it necessary to remove gcov? Would it be difficult to simply
> add support for llvm-cov and enable (make kconfig selectable) one or
> the other depending on the compiler?

Not strictly necessary, no. And what you are describing is what our
original patches do.

The concern was why we would want to have three separate code coverage
tools in the kernel. Each has their own way of doing things, and they
can all live together in the kernel harmoniously.

But the concern was raised so I am trying to find a way forward.

The llvm-cov approach gives results that are reliably tied to actual
lines of source, so that is the one I reflexively reach for any time I
need code coverage. I am at a loss (but definitely willing to be
educated) as to what value gcov style coverage provides in comparison.

I also found some interesting possibilities using intrinsics to enable
boot time tracing with llvm-cov. That is, of course, experimental and
not something I am considering for the intial patch-set. But it got me
thinking about broader configurability that supports more granular forms
of coverage that _may_ address kcov needs in the long term.

I have been working on this off-and on for a few years and still really
want to see this idea succeed. Any guidance on a workable path forward
would be greatly appreciated.

Another option, proposed by Sasha Levin[1], was to use a single
/sys/kernel/debug/coverage interface, quoting him here:

"To clarify, are you suggesting that we'll have something like a single
 /sys/kernel/debug/coverage interface that is producing the same structured
 output whether we use gcov or llvm?"

I am not sure it is feasible to use the same structured ouput, but it
would isolate things down to a single interface with KConfig knobs being
used to select which coverage data one can expect to find there.


[1] https://lore.kernel.org/lkml/aba_HgSbzLGm6VBQ@laps/


Thank you,

..Ch:W..
