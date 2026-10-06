Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234C549D583
	for <linux-efi@vger.kernel.org>; Tue,  6 Oct 2026 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791304063; cv=none; b=P8CRBg+x6+qrKRe3MPNR84tqdJ+fsnvAWBNn2qUpm7kC0yGkUoZcMgSaLa0KdzEUFkbfA+q+OmJnZF9JI26ICa84EKP91nn/HTEF5bGPgMBZKO7ZRfuUQrchQ51rWxzKfG34+dyqNhDKw2GWkeUjj3teX13c60yg7PsujQvIDF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791304063; c=relaxed/simple;
	bh=JaOT2qccNi/eJCcGFKpQPyFgrQUtWBfNjazKR4huGJc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=fkW+OGL8FWyxcgwqWs1AP51JWfYj2uN7MOWYuT/nDSu5/OOrCUM0i1DFX9O2Lgn+rk4LT89N8q7cFFoEGsQRqeDHKlgQcJoem0Vtvm1x57AVDT2iHCwUMpuTGSFQ+NgA4ryrjAyrvvYmeyEt0jtxlw/aHKO2bjamKzXli9tpz1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wolber.net; spf=pass smtp.mailfrom=wolber.net; dkim=pass (2048-bit key) header.d=wolber.net header.i=@wolber.net header.b=aDJ0OTHC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fBLlzhf/; arc=none smtp.client-ip=202.12.124.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wolber.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wolber.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wolber.net header.i=@wolber.net header.b="aDJ0OTHC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fBLlzhf/"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 5CD9C130095E
	for <linux-efi@vger.kernel.org>; Tue,  6 Oct 2026 12:27:41 -0400 (EDT)
Received: from phl-imap-03 ([10.202.2.93])
  by phl-compute-03.internal (MEProxy); Tue, 06 Oct 2026 12:27:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolber.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1791304054;
	 x=1791311254; bh=JaOT2qccNi/eJCcGFKpQPyFgrQUtWBfNjazKR4huGJc=; b=
	aDJ0OTHCchnO4w6/CsJuj3/fyrPyNJFY4ttnZJ32SPYQ1baaTFGfKMO9PA/8DtHV
	AsNd8Xsu84MUJmBFv5/ll9m+VcCPPgxqsSJT2n+TmbcmG6fD4QNVtpqhPT7Q4TOz
	WTiDe6Lq4M1G6UjTKlQhaXAb09dBds0JAgfMd2zBhDs0nAwWOhjrNyhvGleNZe7y
	gv2D+1qn6q4ZhtNXKj2Gf9bd1/cucl15+nnvNYNbFIeG1Ityus3JxcU9s/6Yq09B
	rvUaskoGk8zZ/9UluAUKyH887JgkJ3AgCu3mmn5Pz+2uAheFZUt1bGNnsWBTrI8s
	esQMOdnFBRIRZ0x2NygQJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791304054; x=
	1791311254; bh=JaOT2qccNi/eJCcGFKpQPyFgrQUtWBfNjazKR4huGJc=; b=f
	BLlzhf/ACw2DnbRA/f0NFj/mSJdBV3nRoBDnYx0ZhOUCdVHCeVj6hFriIZUcll4y
	HYVAhQJ/gnOC0Ye0ISQTWcG5vtU1Gkw0/1cJzG3YGxWj7mVmOmZpFzfFtgmSSU4p
	2zIlVn2Awy7dvBu4dEzk7gpDC2IH/Ui8fad90Cn/5T8/cQz0sRwoyQhl/c3WT6vM
	QeSUVmdTUYmyh1pgv5fkCka+NPaQY8yY1pDNukujWG1DBBmMXRhQ3cmPJx7egwpQ
	5SSKHDSGFhca+orYJ6al39eGSm4jB6wPvueYsX8/+8FVKGO1vL/ruK2ntGDv4w4k
	SihsKkwdF/NX3cIJy9R1A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=wolber.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791304054; d=wolber.net;
	mf=PGNodWNrQHdvbGJlci5uZXQ+;
	rt=PGxpbnV4LWVmaUB2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:MIIqhAU1Cf1WX+e4FZN+1LvGOBNBVXyBaTi0+bkcrjlFo32
	F5AF3CWK9CGO7Ds95QuieoufpXD/c0q2NmIa3JlFV+AgqU1hwCnuxFVIKPo3MCZ5
	r8iSsRRmzDkdehf1k1GZTpx6yR3kw7Peg2K9Tkt3K5wC/+w0xVsAOGhqFDpewXjT
	wjgWZ4QnGQ6nawu1PONemXPRbPZQQvP2ApColIsA+E0Y8veTr1NEgkRAZuR5vc+G
	ZXezLqKVIcd30xdeiKUpdI1mYhk1e2U1yRHACy2d2xVcYtJl8cnvdj2rDsPynfHE
	7FNnoWrgXP358hKJFrIp2mTc7vyUPfLrX2MSq+A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:9OT84S2nU/0nZ1U64BlOetYjb+/mK3i5jm+AZt7+BvI=:JaOT2qccNi/eJCcGFKpQPyFgrQUtWBfNjazKR4huGJc=;
X-ME-Sender: <xms:cyHFav2-FXDCSQuCl4UvdwZDw3DXvUGCTqrIBXFwQjqh8CIUBrV_ag>
    <xme:cyHFao5zpJVZ_b_VN1729xUOenCfieF6CzFcNFgMSngnQ20-3uZ_0r7V7QV9GBhep
    oO-9X6fCh-9B98DlBKwcYnQwcjIoa_CrHgVs_8OaTQKpi1fe8iciKA>
X-ME-Proxy-Cause: dmFkZTFmiYJcPEGs0A/qYvq8C4MVW3CyXeGEtkOmNDhmCvIFflxFleW7ny57bnBIuQlD59
    cWped2LiQiXafwA6rH6Ez7xNTRfmFYqjWZDEOCaTaZ+Z4syI7a6O9pxCiwEuqUzZdAJDx0
    9cWIwLNy/t9fQal6PAMxVsKLkQvvtnsbOBBlUQGL+vOqAn4RFaEl2GHR2b4L1cq9s/UcOt
    fSVio0w3i/g32nR140kVw61B5rztlTHebHqHKh60OEO7PQ5ZJXf+jeu/CrVryWbHaULU5f
    OwU38sNMeIhs7opS8zYCEwfGqY1WbgnZ0lsOM1x7qOw1aVGpBTx6LXlr7kO60t15lxjcJQ
    Xoz6jr0j4pjIR+O+PZ9nKQoFOT41zfg/kPlJYxlgE0wkci+XoTiX+ZZ4/HdymIYC0wObkn
    HaaEWy6CzVlyLPwlfBUMXcf7/ewqCKLgGcnZKpY7u8A8P13E+O9DUKSqLvkXaNFv3Ep0lA
    8lCIbxA7dKgreq3nvVhgNUZmHcJ62jED4uvNreTSgAxMWJyV4LIJjvEg+Tau6puOkMEW+Q
    yF3ikUrkFhHlmZykAc1jvQujIO8vFRGIPKWU9ZIhTUDXcVDmBiqvVDBuwrsYHt6OcsEW9k
    jBh0wc2IwF7idYt+Gc1PXZUsdyXHFZGint2G86631DLv8ttt/eLnmgSc73pQ
X-ME-Proxy: <xmx:cyHFalRulfrI0gOe5n2wt8jZZ03L3H4VPYS_luBEHa_EpwUN4qkbtA>
    <xmx:dCHFaoRUoLvWxDt5tWh7AqecATopVRbeseTkPnbfbMcmvQLU5qEIMw>
    <xmx:dCHFavHAlYNEcqam7lbTPA14JbY0ZXtQKXHVkmiSR5gfzrc-urkg9Q>
    <xmx:dCHFakn3xNzhke-YnOSwSFwDAIfvsCGSwfRjOky3Yk59ZEtY7qv9iw>
    <xmx:diHFapqJCieSCu-f8Lh0CzmaIrjuMtsndrKAb-WlzuewQeP1weUcPRy1>
Feedback-ID: i5cf64821:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D087518E0071; Tue,  6 Oct 2026 12:27:31 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A8p1gvDKPv03
Date: Tue, 06 Oct 2026 16:27:11 +0000
From: "Chuck Wolber" <chuck@wolber.net>
To: "Marco Elver" <elver@google.com>
Cc: kasan-dev@googlegroups.com, nathan@kernel.org, akpm@linux-foundation.org,
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
 mhiramat@kernel.org, mingo@redhat.com, morbo@google.com,
 "Nick Desaulniers" <ndesaulniers@google.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, richard@nod.at,
 "Steven Rostedt" <rostedt@goodmis.org>, samitolvanen@google.com,
 tglx@linutronix.de, tingxur@illinois.edu, tyxu@illinois.edu,
 wentaoz5@illinois.edu, x86@kernel.org, peterz@infradead.org,
 "Sasha Levin" <sashal@kernel.org>,
 "Aleksandr Nogikh" <nogikh@google.com>,
 "Taras Madan" <tarasmadan@google.com>,
 "Alexander Potapenko" <glider@google.com>
Message-Id: <41913a77-5c57-4967-8166-765dd5dde1bf@app.fastmail.com>
In-Reply-To: 
 <CANpmjNOaykC4McAj=gZghqPSQc9aGBP_CjgKmp3n2yjeJTxDSA@mail.gmail.com>
References: <00ed0b57-ad05-4c5d-b152-7c81df94b23a@app.fastmail.com>
 <CANpmjNOaykC4McAj=gZghqPSQc9aGBP_CjgKmp3n2yjeJTxDSA@mail.gmail.com>
Subject: Re: [PROPOSAL] Replace gcov and kcov with llvm-cov
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Oct 6, 2026, at 4:10 PM, Marco Elver wrote:
> On Tue, 6 Oct 2026 at 17:14, Chuck Wolber <chuck@wolber.net> wrote:
>>
>> Stemming from some hallway track conversations with maintainers at LPC
>> 2026, I propose replacing gcov and kcov in the kernel with llvm-cov.
>
> I know the origin of the discussion, and wanted to chat, but I guess
> that didn't happen and instead we get this proposal. It would have
> been good to understand the requirements of users of gcov and kcov
> (more below).

No problem, I still plan to seek you out to discuss this further. I just
wanted to get the discussion going in case there was a broader set of
opinions on this matter.


>> We have a set of patches [1] that implements kernel based llvm-cov.
>> They need to be updated and some additional patches are required to
>> address some stubs that are missing noinstr annotation. But otherwise
>> I should be able to send a full set of patches (including taking on
>> the maintainer role) to remove gcov and kcov and replace it with
>> llvm-cov in fairly short order.
>
> The hallway chat was supposed to figure out if there's a way to bridge
> some of the gaps, but jumping the gun like this without having
> addressed the requirements of kcov users does not make any sense at
> all.

I totally agree, and I am still up for that discussion.


>> If there is a desire to take this in pieces or implement other
>> intermediate steps, let me know. Otherwise I can generate a
>> monolithic set all at once.
>>
>> [1] https://lore.kernel.org/lkml/20240905043245.1389509-1-wentaoz5@illinois.edu/
>
> llvm-cov is generally useful to have; llvm-cov is closest to gcov, so
> that might make sense to replace.

Swapping llvm-cov for gcov to start with is pretty straightforward, so I
can aim my initial patch set there.


> KCOV, however, cannot be replaced by llvm-cov. KCOV isn't a coverage
> reporting tool for users, it's a low-overhead interface for fuzzers
> (syzkaller/syzbot and many others). llvm-cov has no equivalent of:
>
> - per-task and remote (kthread/softirq/USB/vhost) coverage collection
> (to avoid polluting coverage with concurrent tasks);
> llvm-cov counters are global and polluted by everything else running;

Correct, and I have pondered some ideas for doing exactly that, but they
would be quite experimental at this time. The patches come with the
ability to clear the counters so that specific tests can be run, but
that is still monolithic. I would love to discuss the potential for
other methods of masking coverage so we can get granular results.


> - ordered PC traces (edge signal) and comparison operands (TRACE_CMP);
>
> - performance: a per-task mmap'd buffer reset with one store, vs.
> reading/resetting
> megabytes of global counters after every program;
>
> - GCC support (we may want to keep at least one GCC-supported coverage tool).
>
> It's also UAPI (include/uapi/linux/kcov.h), with existing users.
> syzkaller heavily relies on KCOV's features above to achieve good
> performance and coverage; there's no reasonable way today to migrate
> to anything else.
>
> As-is, NAK on removing KCOV. Consider replacing gcov with it.

Understood. I will focus on replacing gcov for now, and I am interested
in exploring what else is possible.

Thank you,

..Ch:W..
