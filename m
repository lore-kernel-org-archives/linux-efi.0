Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F3734CFDD
	for <linux-efi@vger.kernel.org>; Mon,  4 May 2026 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777912779; cv=none; b=TiuNzGG9+M+pW8w4ZFcOay2KyWiP1fOf7WloVhnXfkLADMsBDoKQq1IHmbsfW54zmcSXWtiJub2Wt1Zn02Ga38bofMHRTlkisd5h2RLEXZH64Rh7ZiFP3UozlYv1e1migmOxF8UnV6IXAuZUSJQ5AJm6rUqNiDX88Sc+kQkVB+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777912779; c=relaxed/simple;
	bh=GBIwdDAloUqQCQuaTb6cBrYko/UifboBscLgrkkehqA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=RMzXxLKKCdhRhxJ88V2+O3XRPhnfqbH0/XsilK3cRtso41wM2xzihJbdlP5njocr9uy7BW76mt4cZrQghshXat8wUFT6eLZrpcHkvsEA9ZCefdRzp/oTU5CeVBAuJSfCqEubRn7H85SVGJ+dof/zH2qSPamp0dEFhiuQ/NFQrqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEtzo16z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEtzo16z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA576C2BCB8;
	Mon,  4 May 2026 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777912778;
	bh=GBIwdDAloUqQCQuaTb6cBrYko/UifboBscLgrkkehqA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=WEtzo16z9ZU+H9LWSSjo9Qcgb2lXrtMl0pGhZnYb+wxnG9f98MwtfJaE3aQo9Zy0i
	 JqKseSkdOIJwBqtL748kk9uaGkVgygmlwJtewcoA6cL7f5AAtAAyjtBPC/jTdFk6Xg
	 ZPQ6iaEwnuC0zrPD5HgTqOdlhydMvxotHUYTanXP9i8l5sUHlg+9xa5QAGiNpeB8rb
	 n7zNk25htIM9jOSb3CnuG5SMDNLgfc1i+eKo9hKd9+ATTdMMjIn3HVfYQgiWKMZOuf
	 FE8I/ugIZtXf2a20jHsgAcwThuBo2fGrMnoBOCBLzW6gi9QgeBvNy+MinuxsGE4SZj
	 vlhSOTCXZnaVg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id BF2BEF40082;
	Mon,  4 May 2026 12:39:37 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 04 May 2026 12:39:37 -0400
X-ME-Sender: <xms:ycv4aaNSWtUcvOV3pK3QeLpsgNRL-m23HifNbHaFRVj8XWwVLnPUkA>
    <xme:ycv4aTx1hmHFiHh4UU403vPiMr05gqax3vhWN0BGrMPIjaZjTGxEd7EoPkMk4j32_
    z_cmxWZ1go_B3lx7c4J3uPUc3Ol_d4NcR-nPYXuIxF3rX3lE3z6pZs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdelleefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepkeettedvteffhfegueetvddvffekgedvkefgleeiuefhkefftdekjeelvddu
    teehnecuffhomhgrihhnpehsrghshhhikhhordguvghvnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    hedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepihhvrghnrdhhuhestggrnhhonh
    hitggrlhdrtghomhdprhgtphhtthhopegrrhgusgdoghhithesghhoohhglhgvrdgtohhm
    pdhrtghpthhtohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    igkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgv
    rhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:ycv4aaxI4DMRsHAAS6unVChuMPnINVJJg1vWZMt4KvFl4JPG0f59XQ>
    <xmx:ycv4aXyj-kPdaBJ5m4JpaKh6OhOfqNwTfjPHoxkV5BQ5Vi4wYHYQ9Q>
    <xmx:ycv4acbA_pNDfSyltDkkzghJSiFA4rij3le74VXX41_HIwDiMAy9Ig>
    <xmx:ycv4aQVSLlMQ6K4buCSMrDuRej-NyzyCztj3YvfUY3a6G3vz9TF-Xw>
    <xmx:ycv4aSiyPlF4tFkE8bMxq_bneabVGsbfez93WxST6UO5vHfRqwnGEE51>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9E74F70006A; Mon,  4 May 2026 12:39:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 04 May 2026 18:39:17 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: x86@kernel.org, "Eric Biggers" <ebiggers@kernel.org>,
 "Ivan Hu" <ivan.hu@canonical.com>
Message-Id: <0d8e7abe-6134-451c-a564-5eefb93decc3@app.fastmail.com>
In-Reply-To: <20260501090311.2483809-2-ardb+git@google.com>
References: <20260501090311.2483809-2-ardb+git@google.com>
Subject: Re: [PATCH] x86/efi: Restore IRQ state in EFI page fault handler
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 1 May 2026, at 11:03, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The kernel's softirq API does not permit re-enabling softirqs while IRQs
> are disabled. The reason for this is that local_bh_enable() will not
> only re-enable delivery of softirqs over the back of IRQs, it will also
> handle any pending softirqs immediately, regardless of whether IRQs are
> enabled at that point.
>
> For this reason, commit
>
>   d02198550423 ("x86/fpu: Improve crypto performance by making 
> kernel-mode FPU reliably usable in softirqs")
>
> disables softirqs only when IRQs are enabled, as it is not permitted
> otherwise, but also unnecessary, given that asynchronous softirq
> delivery never happens to begin with while IRQs are disabled.
>
> However, this does mean that entering a kernel mode FPU section with
> IRQs enabled and leaving it with IRQs disabled leads to problems, as
> identified by Sashiko [0]: the EFI page fault handler is called from
> page_fault_oops() with IRQs disabled, and thus ends the kernel mode FPU
> section with IRQs disabled as well, regardless of whether IRQs were
> enabled when it was started. This may result in schedule() being called
> with a non-zero preempt_count, causing a BUG().
>
> So take care to re-enable IRQs when handling any EFI page faults if they
> were taken with IRQs enabled.
>
> [0] 
> https://sashiko.dev/#/patchset/20260430074107.27051-1-ivan.hu%40canonical.com
>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Ivan Hu <ivan.hu@canonical.com>
> Fixes: d02198550423 ("x86/fpu: Improve crypto performance by making 
> kernel-mode FPU reliably usable in softirqs")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/include/asm/efi.h     |  3 ++-
>  arch/x86/mm/fault.c            |  2 +-
>  arch/x86/platform/efi/quirks.c | 11 ++++++++++-
>  3 files changed, 13 insertions(+), 3 deletions(-)
>

If nobody minds, I am taking this via the EFI fixes branch.

