Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C455369990;
	Fri,  1 May 2026 06:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777617557; cv=none; b=uFCAs3jaAZrEWskLyA5RHzr36eUjwy2mSdovoxPl6K3gaNdKGp6U7w+D9vVpK3OlvpxCKrgWibkLLBzTkQ9kQFjG6o0oNFviPLT/mG9vhc2yxRmeJKgbEkQUGeI5Ac+3AKdr2GtrId/4yPMrh3Rs93lQAZx87KFy9ZI4V6bBtJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777617557; c=relaxed/simple;
	bh=KCijw0y+7xXvDZzpwLCXiMBJyDLdqoM4yIkwrrDrmfE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=r06/YqLrIGB7mfxFu5TENuFEZmpB4KVXG3koBzSvRFXSDSE/YJHPIQdTlMGI//ZdR/+p1HNmWuMPMPK2IHLOUy21nJzrZEqDohtgAG1xBIvQ1OeaVyhZ+/Qb1cZbYFKz73p8QWV33/ZPt4TTaH9nWxyxGLXc0V2yBMPM3IpFBbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehyVBRPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehyVBRPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF144C2BCB7;
	Fri,  1 May 2026 06:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777617557;
	bh=KCijw0y+7xXvDZzpwLCXiMBJyDLdqoM4yIkwrrDrmfE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=ehyVBRPO+Xizl4mYQYTp+eTr6AQZSEMsqjiEIDeEFIHEMJ9paeMundH9tBmzT73/s
	 cciSXVvHpjbnhC3v0kuQiVnYUCE+Z/LNfoLiKp759UJxj8Q6UnioVwSHIEtM5pvllZ
	 253+7juNtH/7dtNbex6rPGyj6yIRan8dNRjcv4NYyLHmq3RKHzYCz9PpQZcjhdMUo+
	 TklpYYZAYXYEcmm48D5U7px4F/3TdrBD920dmwwjh4du8Q7KqqDDE7Hi87oRkapxfI
	 6xE9HELgsiSvWQaxHwkDqOmTJqZLrFzf1qzlVMElOlzxfagcXq0jrgdrqqi2pwJmha
	 NM3P69ivuYITw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C3A49F40078;
	Fri,  1 May 2026 02:39:15 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 01 May 2026 02:39:15 -0400
X-ME-Sender: <xms:k0r0afUDDZ1fMduecBedKvcFXanDbeExHWzgsZdz-XKvOTUH7FDeMw>
    <xme:k0r0aSahg4duWZb1gX6LRg3-6HisYtqp2eePQeiz4n5CWP5Y_T6DHYG1PqvEYPDzu
    PMwP6VI3_LX81MYCymRvJ97XI-JtVvODUWdwO-TFGo1vIKFOZS2cWnb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekleehtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepkeettedvteffhfegueetvddvffekgedvkefgleeiuefhkefftdekjeelvddu
    teehnecuffhomhgrihhnpehsrghshhhikhhordguvghvnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    uddupdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsphesrghlihgvnhekrdguvg
    dprhgtphhtthhopehivhgrnhdrhhhusegtrghnohhnihgtrghlrdgtohhmpdhrtghpthht
    ohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieskh
    gvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepihhlihgrshdrrghprghlohguihhmrghssehlihhnrghrohdrohhrghdprhgtph
    htthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghp
    thhtohepmhhinhhgohesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhinhhugidqvg
    hfihesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:k0r0aSdjTlpqKC7EIu6C-m7ClRReQRWQA5elb1PCHchqp8aEkvWCCQ>
    <xmx:k0r0aYCsmtf40QfBSkuOU7cZjFNWJwdqtf6VfaRHN9igMr0Bt-WXHg>
    <xmx:k0r0ae6rJ5I9dESDOLdn3KXgAuH0eVZPK3-bgaH5Ib6M11RihS9-fw>
    <xmx:k0r0aZdFcvW3QyT4rqtVtakK-iZ3XHlG9AgBTlAszX8viPF1eTwGAw>
    <xmx:k0r0acvh64tO4P6_yZXloVpSh9rBwCTxeOEcbMrYMNYs8YHBymZxtxSA>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A07A1700065; Fri,  1 May 2026 02:39:15 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 01 May 2026 08:38:55 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, "Ivan Hu" <ivan.hu@canonical.com>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, dave.hansen@linux.intel.com,
 "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <473c0e62-3cb3-4302-8f53-9c020c6ed37d@app.fastmail.com>
In-Reply-To: <20260501055252.GA35316@sol>
References: <20260430074107.27051-1-ivan.hu@canonical.com>
 <20260501055252.GA35316@sol>
Subject: Re: [PATCH] x86/efi: Fix graceful fault handling after FPU softirq changes
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 1 May 2026, at 07:52, Eric Biggers wrote:
> On Thu, Apr 30, 2026 at 03:41:07PM +0800, Ivan Hu wrote:
>> Since commit d02198550423 ("x86/fpu: Improve crypto performance by
>> making kernel-mode FPU reliably usable in softirqs"), kernel_fpu_begin()
>> calls fpregs_lock() which uses local_bh_disable() instead of the
>> previous preempt_disable(). This sets SOFTIRQ_OFFSET in preempt_count
>> during the entire EFI runtime service call, causing in_interrupt() to
>> return true in normal task context.
>> 
>> The graceful page fault handler efi_crash_gracefully_on_page_fault()
>> uses in_interrupt() to bail out for faults in real interrupt context.
>> With SOFTIRQ_OFFSET now set, the handler always bails out, leaving EFI
>> firmware page faults unhandled. This escalates to die() which also sees
>> in_interrupt() as true and calls panic("Fatal exception in interrupt"),
>> resulting in a hard system freeze. On systems with buggy firmware that
>> triggers page faults during EFI runtime calls (e.g., accessing unmapped
>> memory in GetTime()), this causes an unrecoverable hang instead of the
>> expected graceful EFI_ABORTED recovery.
>> 
>> Fix by replacing in_interrupt() with in_hardirq() || in_nmi(). This
>> preserves the original intent of bailing for genuine hardware interrupt
>> or NMI faults, while no longer falsely triggering from the FPU code
>> path's local_bh_disable(). This is safe because softirqs cannot run
>> during EFI calls (they are explicitly blocked by fpregs_lock()), so
>> they can never be the source of a page fault in this context.
>> 
>> Fixes: d02198550423 ("x86/fpu: Improve crypto performance by making kernel-mode FPU reliably usable in softirqs")
>> Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
>
> Sorry for the trouble here.
>
> Can you check the Sashiko review at
> https://sashiko.dev/#/patchset/20260430074107.27051-1-ivan.hu%40canonical.com
> ?  The two things it found look legitimate.
>

Ah thanks for bringing that up. Yes, those concerns seem valid (as
usual for Sashiko :-))

So we should be using !in_task() here instead, to ensure that
in_serving_softirq() is taken into account too, or we might
trigger the EFI page fault handler inadvertently.

I will send out a patch for the other issue it identified separately.


