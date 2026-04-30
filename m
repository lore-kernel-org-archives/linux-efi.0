Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAA93A1682;
	Thu, 30 Apr 2026 08:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777537877; cv=none; b=rSDLoaqH86MqSXoumnjvaHWrm0PBYrSRy3xB50Tb3eb0/0fTHXi84QTZ5T1nOoso/SYtJTJNQ6Xf+33jbi7taE4wuAO3ODPy5sEIu0iHdJ1H8h/qK/VP1DuKh/vSQcshscEZdnWNbCMNmk2vUKYjNTbRyYVwQRWnKIrUfTKrLWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777537877; c=relaxed/simple;
	bh=/5VDn9x3IrvP+1kxl5YY6zg3ZXtH4wCPjCJnOMJodyM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=GIC4p2OKN+0h8mDG1IJzSz9R3krAbO8H8Lp6ULuwwqtrV9Za7OIXbDJImEIrOH0C8pkCuWZ/GKg14UZEwtoNKbHGWi6sH8614bKvTVkaCfo63dv+eQHRAVl3ydGTnsEDwO/ltZUtOmI+fvSlA9DK/xpltw9hlCpF3SC2MA1uW4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKNFKzoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKNFKzoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FFDC4AF0B;
	Thu, 30 Apr 2026 08:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777537877;
	bh=/5VDn9x3IrvP+1kxl5YY6zg3ZXtH4wCPjCJnOMJodyM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=MKNFKzoJRMGx6AUmzt6v5XrwW4Vp0pwog4q4m0+mz1WNh9vTYW1Q1kFSk1U7xjM2S
	 VTufDjdM7P0UsuOVQT1JgF3cJFLBnjQOghnLF+Qd4/LaHop4RF1jb8BvXpXZwteDlg
	 QsgGhL0ZvKe7IiSOj9U0jzEokcx638Pi8WIC8kDZMhz1YUaqDyhK1N1+DADx48ms8z
	 MNSx0IcZ6fS//kKB+sGioE4Hrb07qCg10gwFXqpH/LZlRSFnAEC9nehdohJ36bPzGh
	 V2td0l58DCk9O6jUsG+6FpnWs4QRbKyQAuoAmXjITq9AgFBTMLDpjRGEfAuMrViRtO
	 GWtBWbT62XbGQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 931B6F40068;
	Thu, 30 Apr 2026 04:31:15 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 30 Apr 2026 04:31:15 -0400
X-ME-Sender: <xms:UxPzabWpob4qOM-DXOIVHifopIfrKplhZwo3PEENDKMTHyoNhFAzvQ>
    <xme:UxPzaeazuK15f72U971UIwQGxV1e42V1ItV2uWZlTrOAsYrYLBZR93Vi7HMOOnk8c
    sFYUBrlgyx96jjpIJv8ZCb0SePypkCeGVv0OFBaDgEzKFliZT6AWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekieekgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegsphesrghlihgvnhekrdguvgdprhgtphhtthhopehivhgrnhdrhhhusegtrghnoh
    hnihgtrghlrdgtohhmpdhrtghpthhtohepvggsihhgghgvrhhssehgohhoghhlvgdrtgho
    mhdprhgtphhtthhopehtghhlgieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekie
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhlihgrshdrrghprghlohguihhmrghs
    sehlihhnrghrohdrohhrghdprhgtphhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuh
    igrdhinhhtvghlrdgtohhmpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhm
    pdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:UxPzaedWRdbsgwnQJVhJUZ6SCg-EI4V3Bh5NbThzpZwbzST7UPJ73Q>
    <xmx:UxPzaUD1vrPOLf0dhnvUcp2etK2jGs8f0xfRtmhbdPRQReeWCY9HdA>
    <xmx:UxPzaa4l93dca9j2Hx84nSOmwuVbVTVdGkGUEGxnydELPlce20yQkw>
    <xmx:UxPzaVecK_N3mdUpblVIeGbM--7RRjQIB3QHuGq2EZXG07FA-6IvMg>
    <xmx:UxPzaYtRxpDpDi4TJwHPd_RcuZYeRHfCBnjzj-wVCnmuBOZDcwb7i9Tq>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 649BA700065; Thu, 30 Apr 2026 04:31:15 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 30 Apr 2026 10:30:54 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Ivan Hu" <ivan.hu@canonical.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, dave.hansen@linux.intel.com,
 "H . Peter Anvin" <hpa@zytor.com>, ebiggers@google.com
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <6793bc4e-fa30-42f5-adea-98250b51f1ff@app.fastmail.com>
In-Reply-To: <20260430074107.27051-1-ivan.hu@canonical.com>
References: <20260430074107.27051-1-ivan.hu@canonical.com>
Subject: Re: [PATCH] x86/efi: Fix graceful fault handling after FPU softirq changes
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 30 Apr 2026, at 09:41, Ivan Hu wrote:
> Since commit d02198550423 ("x86/fpu: Improve crypto performance by
> making kernel-mode FPU reliably usable in softirqs"), kernel_fpu_begin()
> calls fpregs_lock() which uses local_bh_disable() instead of the
> previous preempt_disable(). This sets SOFTIRQ_OFFSET in preempt_count
> during the entire EFI runtime service call, causing in_interrupt() to
> return true in normal task context.
>
> The graceful page fault handler efi_crash_gracefully_on_page_fault()
> uses in_interrupt() to bail out for faults in real interrupt context.
> With SOFTIRQ_OFFSET now set, the handler always bails out, leaving EFI
> firmware page faults unhandled. This escalates to die() which also sees
> in_interrupt() as true and calls panic("Fatal exception in interrupt"),
> resulting in a hard system freeze. On systems with buggy firmware that
> triggers page faults during EFI runtime calls (e.g., accessing unmapped
> memory in GetTime()), this causes an unrecoverable hang instead of the
> expected graceful EFI_ABORTED recovery.
>
> Fix by replacing in_interrupt() with in_hardirq() || in_nmi(). This
> preserves the original intent of bailing for genuine hardware interrupt
> or NMI faults, while no longer falsely triggering from the FPU code
> path's local_bh_disable(). This is safe because softirqs cannot run
> during EFI calls (they are explicitly blocked by fpregs_lock()), so
> they can never be the source of a page fault in this context.
>
> Fixes: d02198550423 ("x86/fpu: Improve crypto performance by making 
> kernel-mode FPU reliably usable in softirqs")
> Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
> ---
>  arch/x86/platform/efi/quirks.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

I'll take this via the EFI tree unless -tip prefers to take it.

