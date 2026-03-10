Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BBD3B894F;
	Tue, 10 Mar 2026 20:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773176326; cv=none; b=Tni4qOVlJ+ijsIC6AjlrToqJrVMxRnLhKPoptNJpAX7XuA1PHQX02mvlWw7g/AyfRqLSZBNSobyrrVHZs38iMPNI1lu0FcUtS8wTHZ+w2qeHFUdnJJ2ZJfYdb1ewFEuUQsLkRnvOrR1jrmZzWXqE0XTOPBk5u8v1Hz4EYthGouo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773176326; c=relaxed/simple;
	bh=SiM3sT1tVIOKRhnic4ae/2/gsw3LGLx44BPZELkSoRM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=X/itjkC4jomv/5xXAcDl02b7d7a6mVOvk6Dr2af/az2rqnOj2X+Qb2aSbpJVpOvNJfuvzogJku+JEg/B8ewleCEJVKXkA56WsuzzVJA7kvcIWRK0/Hiz6PjeAHAstIlPpI/rdli/TqO8JVUVuj6vtRi4I4bFLIpG+ACtJ3YLOho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9SilIVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9SilIVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A061C2BCAF;
	Tue, 10 Mar 2026 20:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773176325;
	bh=SiM3sT1tVIOKRhnic4ae/2/gsw3LGLx44BPZELkSoRM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Z9SilIVu9C95u7bsx05OnOwYhiDbU8uSIskRcpMLceVxqgAhQS0vLmGXEQX90Fm64
	 c24UJb1ynQXW/nXj61xIHgT4MzQX2GgI2pK53EXKrJGGImlqF1vFTtvMt6SMXLZKct
	 vY8jzlsRI1fP632bZjt3YFBg5IC1lKuHqyzvf85tAmSvTDCemT2PKtG/wOaCZaX396
	 T2gUGXpw0nGFZD6XGoSGzt/OXKLFVV6KXlPFXiPpVqa96bMvvQKGCxCgMPuAZ/GbO4
	 H8J5o31U0sKKXHPf9VZieyB0/FjoWb/dnkL/KIvOWSppnnM7AAUYlTC80GH+y00OKY
	 FDE957C5A81cA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4B244F4006A;
	Tue, 10 Mar 2026 16:58:44 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 10 Mar 2026 16:58:44 -0400
X-ME-Sender: <xms:BIawaVMNFs26QUr6XhGbTPzdMLa6-wHpismXh-5hAVPSoY5KRUq25w>
    <xme:BIawaSwSb0BON1A5ChL9Klshn_67Ymkdf8U0Rzu3hq4CgCYW44qBX85_-3ZMSdOb6
    kyg7djBnHMRHv5DNPDEKeWo_etiKb_o3dQxOlLtaBSwPvKi0hCv42k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkedvtdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeefhefgtefgkefhgfdvffdukeejheeuvedthfdtiefhleejhfefjeffieeu
    jeefteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    hedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhkphesihhnthgvlhdrtghomh
    dprhgtphhtthhopehmrghrmhgrrhgvkhesihhnvhhishhisghlvghthhhinhhgshhlrggs
    rdgtohhmpdhrtghpthhtohepihhlihgrshdrrghprghlohguihhmrghssehlihhnrghroh
    drohhrghdprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdho
    rhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrd
    horhhg
X-ME-Proxy: <xmx:BIawaXYOepG2f_vEiHZYvlt52p7uTwx6cjD6i34HN5m7A39Ckntpqg>
    <xmx:BIawafWFukY9jMURSCLsnr6ykegAqysRV5qODmN4ny0CGdEQB6mfwg>
    <xmx:BIawaVhv2vvX70TjUqBd4h-JPmVTBa_aFxQ08y318sM6wITkPygsyg>
    <xmx:BIawadu5m2iPwn8bwbTdvZvEyl9NFiCunHz_D0nBcrme_PZiRNuCrw>
    <xmx:BIawae4-8PuhnH9d3v9oDqZSzMCFe6n45aJPVEU-yZ-FLX2JpVAOlbYT>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 233E3700065; Tue, 10 Mar 2026 16:58:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Aml41XUTo7wZ
Date: Tue, 10 Mar 2026 21:58:22 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: 
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
 linux-kernel@vger.kernel.org
Cc: "kernel test robot" <lkp@intel.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "open list:EXTENSIBLE FIRMWARE INTERFACE (EFI)" <linux-efi@vger.kernel.org>
Message-Id: <bcacc202-2df9-4c95-85ed-cbb47d7726e3@app.fastmail.com>
In-Reply-To: <20260310190753.273425-1-marmarek@invisiblethingslab.com>
References: <20260310190753.273425-1-marmarek@invisiblethingslab.com>
Subject: Re: [PATCH] efi: fix type in efi_mem_type()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Tue, 10 Mar 2026, at 19:56, Marek Marczykowski-G=C3=B3recki wrote:
> Drop const, as use of efi_mem_desc_lookup() will modify the variable.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes:=20
> https://lore.kernel.org/oe-kbuild-all/202603101851.bAhG7uGN-lkp@intel.=
com/
> Fixes: 5992265762e6 "efi: make efi_mem_type() and efi_mem_attributes()=20
> work on Xen PV"
> Signed-off-by: Marek Marczykowski-G=C3=B3recki=20
> <marmarek@invisiblethingslab.com>
> ---
>  drivers/firmware/efi/efi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks, but i've fixed up the original commit instead.

