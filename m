Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2568534D910;
	Mon, 27 Apr 2026 16:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306340; cv=none; b=D6YaqVgfkGxUW/iaKySPrO3ti6Oo/VXhYTECQCzjJnTxHnbhU2zbRsEUDFIi1jy+WHgezFlqf5r1EXG9hmA5rsXJa3R+9ttHMhGpV+Gns/HqEjGTMiZgLqE5cU6NuG1SZr5SYM8oY6Ub9anJ6fQwRR58TWn4K9BYDQAfiYCJWNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306340; c=relaxed/simple;
	bh=1nULXbFIw3Osbf+VK6+O2ffVIezdHJ8OBpXhfIbc/mY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=nr6mMnCIvcXWQXfYZNl9essCPrZfSSg8bzVgpE7b0Cg4rdHKwWbUCq9HhVQzee4dYa98uOeHlMzmyoaBp78NbODBzP5nI9Zcthd3qN3f1WMZfH3BjvAUQamkPFS0xrDc7CHSCega9ucQohxCES0S7UjT71KPblxcQ9L1RHYjp9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+/gufN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+/gufN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647CBC2BCB4;
	Mon, 27 Apr 2026 16:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777306339;
	bh=1nULXbFIw3Osbf+VK6+O2ffVIezdHJ8OBpXhfIbc/mY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=S+/gufN0fzLU42M46yz18n9XlEWfPO3BqRI7HZYAoHDT/V9N7ZnU2f7VKMzC6HYsW
	 I6H4Muccn41sGfbXa8cCcZZZ7f94n0XDOAgKAVRFwwk/4opaJJOv79i1dnFHMJ+AGz
	 fL6/6wBSrhsLQbl0I8HazXgmmD9QDIyEtoJrnfZjeFZdohIRwLWq/yoAHyjs1D2shi
	 otVA5WpgLMyNoIExyXeQwIIAayuCZxlC2U0WNV1/hww8tqXRVxh1DKDiAOznHMFz8H
	 QHXW+3Gt8rA7ZJpoXtPznUXP5U5gWstDzlfSFQTFjW9lJ0XmP0T87wJrrYqxY+RcHz
	 SASOye6dUzq4Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7BC1DF40070;
	Mon, 27 Apr 2026 12:12:18 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 27 Apr 2026 12:12:18 -0400
X-ME-Sender: <xms:4orvaTD3yp50_ZGxO8aqwZtOeYuFby8Dlozy5E65q2aUtO7Y6II3nQ>
    <xme:4orvaUUzT1L0Yk0HHgWLg21iyBnCocRza7wbwXgu1XZwBAui7ZuYBa9ZpoAhY-J8u
    Fpiwv4Y1S9j6CQoKpVKm6UTFQSJtlLIiJDY-ZVBN2SO4nPoPVU51w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejledugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepkedvffekhffggeevkeeftdeifffhleegteeivdeifffhkeefieekteeugeet
    teetnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhguodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieejtdehtddtjeelqdeffedvudeigeduhedqrghruggspeepkh
    gvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurdgtohhmpdhnsggprhgtphhtthhopeej
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrsehhvghvrdgttgdprhgtphhtth
    hopegthhgvnhhhuhgrtggriheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhlihgr
    shdrrghprghlohguihhmrghssehlihhnrghrohdrohhrghdprhgtphhtthhopehlohhonh
    hgrghrtghhsehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidq
    vghfihesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvg
    hrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhes
    gigvnhdtnhdrnhgrmhgv
X-ME-Proxy: <xmx:4orvadFbQ9t4bJnw0uzp_8KlH8U-p375n74icQ5uVqavUixK_LBvYQ>
    <xmx:4orvaRbZQFEEuPuAgtRnSzj5QTwJGjEDMWSTY7sZPYfVcqwSsh_dyA>
    <xmx:4orvaVXweqNjDt471yid6gOKOLFK9UdTztAOOpjiqyNc0LpX0-KtNA>
    <xmx:4orvafnPici49MeZnCwY3DhGL-oHKclRRTfNFppHdbcjl_sUkt7ZWA>
    <xmx:4orvaYDRUQOpZhTJ2s_eQk5yo3dsp7KC2AE2Pi1rYHqt8HlvrToN45Ju>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 60CE8700069; Mon, 27 Apr 2026 12:12:18 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 27 Apr 2026 18:11:48 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "WANG Rui" <r@hev.cc>, "Huacai Chen" <chenhuacai@kernel.org>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "WANG Xuerui" <kernel@xen0n.name>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev
Message-Id: <d7197b01-9b7e-4f0a-bcd2-9d6d894e8cd9@app.fastmail.com>
In-Reply-To: <20260427084721.40535-1-r@hev.cc>
References: <20260427084721.40535-1-r@hev.cc>
Subject: Re: [RESEND PATCH v2 0/2] efi/libstub: Ensure instruction cache coherency
 after kernel relocation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 27 Apr 2026, at 10:47, WANG Rui wrote:
> Changes since [v1]:
>   * Move efi_cache_sync_image() after check_platform_features(), matching arm64.
>   * Add "()" after function name in the subject.
>
> The EFI stub relocates the kernel image by copying it to a new memory
> location using memcpy(). On architectures where the instruction and data
> caches are not automatically coherent, the copied instructions may not be
> visible to the instruction fetch unit without explicit cache maintenance.
>
> This series adds the missing call to efi_cache_sync_image() in the generic
> relocation path, and provides a LoongArch implementation using the ibar
> instruction to ensure instruction fetches observe the updated contents.
>
> [v1]: https://lore.kernel.org/loongarch/20260427034451.717817-1-r@hev.cc
>
> WANG Rui (2):
>   efi/loongarch: Implement efi_cache_sync_image
>   efi/libstub: Synchronize instruction cache after kernel relocation
>

Queued up in efi/urgent - thanks.


>  drivers/firmware/efi/libstub/loongarch.c | 5 +++++
>  drivers/firmware/efi/libstub/relocate.c  | 1 +
>  2 files changed, 6 insertions(+)
>
> -- 
> 2.54.0
