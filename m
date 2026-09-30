Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A8F3750BD;
	Wed, 30 Sep 2026 06:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790748584; cv=none; b=GXLHnhOQA7Tsz8JSTvtKslIObDc7fohCZWLpebXl+tGM4J/IKKhMiYqlRbVNF7D12SN03nrQZbFSKdqEEFhdJ4iyQzuIAmCHOLlkXhdxehq5U1sRLLeoKJR3hMVxoL3DI5ihSaJcpoK4E7GrHojj45fQo/hz+Arn+1KV+3HKwpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790748584; c=relaxed/simple;
	bh=XCROvOlzC8UhROXRYTXlDPWwk3VZngkaabZb74KjKB0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=p4477w+/6WLI9FakgvAwM1rspYWEOjoaQonvA1tGRMjZIgEOPjHjcbDUnncRGS5y9MZi/b/SobOYGskzwf3q8H0DbFO+fh9x/v9n+UjjRMmzfrn5rWK1/3F2x067NWLS4T2Twf3xa1KEWDkJJNqkYoRZS4ocOPmV8ghou8nl6qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0aJiqgl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0aJiqgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572AC1F00898;
	Wed, 30 Sep 2026 06:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790748583;
	bh=6h7uN8oZD3fZpgLOnuO8jNg+qNPB0aHlC6LIXgLd8rk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=C0aJiqglHpwJMphJCpT4ly83kzzULfY86X8xWEmDOq2pBqy67AgGL3YFrPGG23MJn
	 +NdNlUw4P8giMvqQn7RtDXuMPWeeVcikY5m2YWr6kMg+4wVWa+UPkc5jwXydWohbDJ
	 m1c9edqBNk11B7ekSoG2SEQ0V/nzgkRivO/gfmpyo3N9nQg9+VqqvepB8bIQixjhji
	 4OwbXUrRlI3Gm0w+uWhO73vcwKl4h+6U3tBZCPWp/tYSLWXt4OflukSgruJAnw9iiP
	 A6w9/5A9ck7io/2CopLIL+AEXeb1TIVNw4WF6IoHXZY4uZCctKvgwlxY1UzAe/ZGCQ
	 Ohlvcemt1XFxA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 94480198003A;
	Wed, 30 Sep 2026 02:09:40 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 30 Sep 2026 02:09:40 -0400
X-ME-Sender: <xms:oae8anI4GVEbKvhVlcjR8-LzUjW6OI8pIX4xwdE5AShm-xYggBCfzA>
    <xme:oae8al9IGvGGArTgEiF5YPyEty4h9752h8j-gFFQveVwEoIfCoJuIO9iAa0OslTxH
    UawP56YQYeryMLbKnajVAnkDQ1a_qJcmZKTe2KpbEm_S_Gb9hOhMp5x>
X-ME-Proxy-Cause: dmFkZTGH3CDWrAOgFb5M8dKUdw7jBdaLrB2Pwt8r3855AuHOEEYS9lNyfJml3e2Dw82aft
    4NyxgO+2wM2f2o/0MofBREoFjUlN0fcXDbSg/pS7qRRU5oDw78l4/t2gvNPUQyexhSycSt
    NaVeHCiWHN4+JISu6xqaJJt6mTDAIaQvkHd63LyqxXLYaoOYjOh0tslHUgOuNZpfYZFw/g
    LZ7QLONu1oyh6dS6HIpxt1l89FRI6Eacrsv4tm7E3MPWo/RE03KKbe0p3wSmJMTB9jGcuH
    iNbSFAozKIM6ijzfRf92WbPAwKQzsczw4VH6i0WpOVq4lJ2zHYqfIovQJgYd/cfjVlKhjk
    e1jP+aUIjrqaEucWf5QX3yzd8oJlT72RfwsYe+lbigeYlQ+U+oQHDoFJ3wAWpJsSmBW3B/
    DGDwMN85cq94oVGZI1g8e0AWPYXoeKoki8n1/ZW8B9YDmAWj2GEk9E5VGmOt9oSn33ATc5
    BxSU+h4nkzK4CWLKrE2as1Y0YmXAl98LF+LYWUd8bHl2eAK+HIAH+exjmJe6P6F++r7pQ0
    o8dz94tGnjB/3dBhU2rWSZVqotQzJE3GcbPy7X4OqQrmm6RVTQDWp41ttcQ81UqGwb1rfh
    bYWBVh6a4Qr0moEAa9JpdxaEgtXF2BwKI1qH8xboZknig3xSe//xi7zCRiUw
X-ME-Proxy: <xmx:pKe8avxvzVXMRxvxUY17jp02351u8li9Z1gpWAe66HMral07sMde8A>
    <xmx:pKe8ajG2K4xMzY109hxeYHL0r-CTQ38UceHkzldI8BgzF_caUDzCDA>
    <xmx:pKe8avy834KnGQ6bfDnmXxYhl1jweaX-Bv9PTRe3wpd6gEVc_evBAA>
    <xmx:pKe8amPkiBGuQigPfbr0JHSSKaV1s4LLxnrYpnPprTJvZKh0pJTnTw>
    <xmx:pKe8alajaA18p7dGKstTDxtDh6LxrbscDldnMaDcLrfA4cWhwVkImsYX>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 74AE3F80086; Wed, 30 Sep 2026 02:09:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 30 Sep 2026 08:09:17 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Prashant Singh" <singhpra@juniper.net>,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Jeremy Kerr" <jk@ozlabs.org>, "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Jonathan Corbet" <corbet@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
 "Steve McIntyre" <93sam@debian.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Message-Id: <2219f7bb-62a0-496f-a311-8eb651fb76e6@app.fastmail.com>
In-Reply-To: <20260930013500.10273-1-singhpra@juniper.net>
References: <20260928203445.72318-1-singhpra@juniper.net>
 <20260929074312.v3jT8uel@linutronix.de>
 <59d5452c-42b1-4784-a593-5e549a2a0f12@app.fastmail.com>
 <20260929151401.doOQX7D0@linutronix.de>
 <20260930013500.10273-1-singhpra@juniper.net>
Subject: Re: [PATCH v4] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 30 Sep 2026, at 03:35, Prashant Singh wrote:
> Thanks Ard and Sebastian for the comments.
>
>>Please don't respond to questions by respinning the patch without
>>having any discussion at all.
>
> Noted, and apologies for sending v4 without first finalizing the v3
> discussion.
>
>>I asked you an honest question, and it seems Sashiko spotted an
>>issue here too.
>>Is there a problem with how the current code deals with uid and gid
>>on a remount?
>
> No, I checked and did not find a problem. I mentioned this in my
> response to your query on v3:
> https://lore.kernel.org/all/20260925113145.7396-1-singhpra@juniper.net/
>

Apologies, I missed that.

>>This until the end looks extremely verbose.
>
> I can drop the strace data from the commit message if that reads
> cleaner; I had included it to highlight the issue.
>

Yeah you can trim it a bit but git commit log space is cheap and
only people that care about the patch will read it anyway.

As for the docs and code comment changes themselves, please make
those a bit more to the point. People can go and find the commit
that introduced/updated them to know more about the background.

>>could this be, I don't know something smaller not including the
>>commandline where I would expect that people know how to use it.
>>
>>===================     =========================================================
>>(no)statfs              Control whether ``statfs(2)`` reports the variable-store
>>                        used/ available. Disabling it skips the EFI runtime
>>                        service call, which might block the CPU for a few milliseconds,

might block all CPUs for a few milliseconds.

>>                        reporting 0 for used and capacity. Enabled by default on

Instead, report 0/0 for used/available.

>>                        PREEMPT_RT.
>>===================     =========================================================
>>
>>It might make sense to add this knob to Documentation/core-api/real-time/hardware.rst.
>
> Thanks, I will use this wording and move it to
> Documentation/core-api/real-time/hardware.rst.
>
>>Here and below you add a comment to every change you make. What about
>>focusing on the important parts, that deserve an explanation why a
>>change has been made. For instance why nostatfs has the READ_ONCE/
>>WRITE_ONCE accessors and sometimes it does not.
>
> Apologies, that was a miss on my part, and I saw that sashiko-bot
> flagged it too. I wanted to gather any additional comments before
> addressing it.
>
>>Yeah the most severe issue is that entering SMM requires a rendez-vous
>>of all the cores, and so whether preemption is enabled or not is
>>actually kind of irrelevant, given that all the other cores just
>>disappear.
>
> Yes, I observed the same behavior. I was not sure whether this is
> x86-specific, so I refrained from mentioning it in the commit log.
>

It is x86 specific but that is the main reason we need any of this.

>>Right. So if anything, there could be a data_race() in one place
>>instead inconsistent READ/ WRITE once as we have it now.
>
> I would use data_race() on the write for nostatfs. Please let me know
> if the below looks OK:
>
>     /* nostatfs is read locklessly by statfs()/show_options(); the racy 
> update is benign. */
>     data_race(sfi->mount_opts.nostatfs = new_sfi->mount_opts.nostatfs);
>

AFAICT, that would potentially leave KCSAN instrumentation on the reboot
path, which might trigger and interfere with the reboot. So instead,
I'd like to put this in efi_reboot_required if we can. If it is needed
in more places to address an actual KCSAN splat, I don't mind. If it is
just to make Sashiko happy, then we shouldn't bother.



