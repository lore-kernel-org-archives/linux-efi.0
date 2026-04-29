Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4564425A357
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 09:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777454183; cv=none; b=cC+CWbonP8lw3tV8jcPFw9dkneb2wFAlBAALQsB1eYKJvZ6lJ89dMoCPkp4B1EcDhRF7QcL5bwyKryHbF/XV2t4pktGkPW9jUSYcmMw1EWq8lW2mf18mGTkVjBoTBWGmuHh5zdxeZqX2ARYMIWYG4KtGUW1bGX6P3gZKG1Q7Vh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777454183; c=relaxed/simple;
	bh=57VidyFDMnUkKTf1XSAs7qNB3v/LFxwT6C+kurTc+NM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=tNO4skgSg6hCfVlxd3kfA0Vt5Qwk8+19q8VoFCXYp+WGORRTaeLZXH6ESk2WiCYwDpeXQpnn2i1IgDmmw0r7leDydPd6qHysWLxtXcG2hwTG22gGz3vOVGAeCUbiL1Bok+6CgoWmzPae++6cimaGt6TkYzz29WjM77amfrH8J2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gG9dJ83G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gG9dJ83G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D461DC2BCB3;
	Wed, 29 Apr 2026 09:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777454183;
	bh=57VidyFDMnUkKTf1XSAs7qNB3v/LFxwT6C+kurTc+NM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=gG9dJ83GtCuhV8OZwi5JUsk7dfUVtDHMjMUglni1NwUsf+2rcLbpENc7MIJs8yWAW
	 lF4h6wj75fenFmn/1wrCrqQOBVllugUOdGu+GrnfeNnKb8W03eqy+W5RsUm3kjbmrY
	 ysq/TT51jThNMIoMfhue/dN4i/YSN2M3mx5A7dQNaeYaMqiALx/bY0NprWCoUOMstH
	 XENE4C9nbIJZQGFbkwHkKO/yWzw2MQOsJM0V8GvN4aM7qjfAqo9vpswkaTHTDQ+rrv
	 tE+tqAo3ojNLHny3k80y8inu5vn+o66SxjRKgvcw+zEEJjMByh+4GiY/F+hYxURNGT
	 ph/Jej2sa6Teg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id E53EFF40068;
	Wed, 29 Apr 2026 05:16:21 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 29 Apr 2026 05:16:21 -0400
X-ME-Sender: <xms:Zczxae60Z2_Xu7xlUnQKmgbezT2-TbBWW0F5hA-HMW6rFegvqq_D4g>
    <xme:ZczxaSuxrKbOBgWObIGYpYLOOYnREThqjQpi68gzJdcSIjAN3bPjNozo6_hpnnIqT
    KmOP_916gCJUkaEiPEl27dLYuA-1WpCR9X1t51_vOu5_NotdpiVXkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekgedthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepkedvffekhffggeevkeeftdeifffhleegteeivdeifffhkeefieekteeugeet
    teetnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhguodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieejtdehtddtjeelqdeffedvudeigeduhedqrghruggspeepkh
    gvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurdgtohhmpdhnsggprhgtphhtthhopeel
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlihhsrgessgihthgvfhhlhidrsh
    hprggtvgdprhgtphhtthhopehrsehhvghvrdgttgdprhgtphhtthhopegthhgvnhhhuhgr
    tggriheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhlihgrshdrrghprghlohguih
    hmrghssehlihhnrghrohdrohhrghdprhgtphhtthhopehlohhonhhgrghrtghhsehlihhs
    thhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepshhunhhhrghihihonhhgsehlohhonh
    hgshhonhdrtghnpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhesgigvnhdtnhdrnhgrmhgv
X-ME-Proxy: <xmx:ZczxaTaJO3DKW_8WlSE0bKoFag6z-Qq8cy7r3Slya_bxTJRZe6d1Bw>
    <xmx:Zczxae_WMxDnt8oZdI3pPkZq8C8ToYqmlLXh9RUlCA-NiTfM1kKTLg>
    <xmx:ZczxaaZ2J1MmHegRq_8Iv96GAJoSx2UMIWPeYdk7D8OuMG8n8P_tAg>
    <xmx:ZczxaQeq42E-e5a1SnelKzHi07znBMVbaUcKvXVvdsUwL9Pw7OAwBQ>
    <xmx:ZczxafmGQ2UDLYqxdbM2t47Iswo3IhycUPSRg4qCkx_YmaI0SaFTx8eG>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C80B8700065; Wed, 29 Apr 2026 05:16:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 29 Apr 2026 11:16:01 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "WANG Rui" <r@hev.cc>, "Huacai Chen" <chenhuacai@kernel.org>
Cc: "WANG Xuerui" <kernel@xen0n.name>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Haiyong Sun" <sunhaiyong@loongson.cn>, "Lisa Robinson" <lisa@bytefly.space>,
 loongarch@lists.linux.dev, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <7efff830-06c6-44d8-a613-f230253c014e@app.fastmail.com>
In-Reply-To: <20260429051318.1581350-1-r@hev.cc>
References: <20260429051318.1581350-1-r@hev.cc>
Subject: Re: [PATCH v3 0/3] LoongArch: Move KASLR to EFI stub to avoid initrd overlap
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 29 Apr 2026, at 07:13, WANG Rui wrote:
> Changes since [v2]:
>   * Add a new patch to prevent initrd overlap during relocation.
>   * Revert changes to the CONFIG_RANDOMIZE_BASE_MAX_OFFSET range.
>
> Changes since [v1]:
>   * Drop the patch "LoongArch: Allow rdtime_h() and rdtime_l() in 
> 64-bit builds".
>   * Use random_get_entropy() instead of rdtime_l().
>
> This series addresses a potential overlap issue between the kernel
> image and the initrd when KASLR is enabled.
>
> In the normal boot flow, the bootloader is responsible for loading
> both vmlinux and the initrd, and it can guarantee that the two do
> not overlap in memory. However, this assumption only holds as long
> as neither image changes its location afterwards.
>
> The in-kernel KASLR implementation breaks that assumption. When the
> initrd is placed close to the kernel image, randomizing the kernel
> location at runtime may move it into the initrd region, leading to
> memory corruption early during boot.
>
> To fix this, this series moves the KASLR logic out of the kernel
> proper and into the EFI stub. With this change, the final placement
> of both the kernel image and the initrd is determined by the EFI
> memory allocator. This ensures that the two allocations are
> coordinated and cannot overlap.
>
> Functionally, the kernel still supports KASLR as before, but the
> randomization now happens before the kernel is entered, rather than
> during early kernel relocation.
>
> [v2]: https://lore.kernel.org/loongarch/20260428040159.1065822-1-r@hev.cc
> [v1]: https://lore.kernel.org/loongarch/20260427104721.47724-1-r@hev.cc
>
> WANG Rui (3):
>   efi/loongarch: Randomize kernel preferred address for KASLR
>   LoongArch: Skip relocation-time KASLR if it has already been applied
>   LoongArch: Avoid initrd overlap during kernel relocation
>

For the series,

Acked-by: Ard Biesheuvel <ardb@kernel.org>

Feel free to take the EFI changes via the LoongArch tree.
