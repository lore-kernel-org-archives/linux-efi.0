Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD393ACA5B;
	Tue, 28 Apr 2026 11:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374451; cv=none; b=edx2/TcCCZ2qXtMiT1a23jp/l7bH+kwkSzgY1/VoZPL8EEca1CtvaalevywBX+orgQ/oHKdM82hXHnfMuNi5qdQkLyjuHGbQ/vBbFrI3wVt+My2F3zg3l+Nc5t3/YS54rYN3NcgNpstkYV5cWwYcrYfU7i7x2ormDeAdlRXlq+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374451; c=relaxed/simple;
	bh=0812KctsMNtN9wpQc9Cj6/ewH0R7OaJycPWHucN+MCw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=TMrsQIUftsz4kRnNrco3dBzfTq/B3sN9GbryY5rjGkQtRaU2pxxU8aWxhR2Brf6FnGt/PvmzwzFsjTPG+HTKMVYLWtUb3FmjlLVtg3lUZbNXXE1NRsmMnsct90mZ+axI4CpCC6woLqZYm8qdOuQrEd04ADBLg4qw+SPMKqmL3L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lwhv+DyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lwhv+DyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B7FC2BCB8;
	Tue, 28 Apr 2026 11:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777374450;
	bh=0812KctsMNtN9wpQc9Cj6/ewH0R7OaJycPWHucN+MCw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Lwhv+DyZreRfj6LM+z1TrMmVm2BsQ4AY/dTfl2XEfk0h9pkgDxlLElxS87rZHME7L
	 ob3r08gHM6nCjYgJEnylNbcI+WRT7R873XC5SmDT3Xj7DNGURnS+yfgSXT9L6F9TYJ
	 l1KuOAVahMjj268E1emxJW/R55ac0wOXGIMDoI1bI18u5cmKdqwF+eIi+fePhkMV8I
	 2Ibq2XcxjcGei3Tn9Y/aChM22cN/czRUN3AvxZcNOz9fI5AYSoJawUqVLgdVi6RMUt
	 OG0xq21CbfzEzMdwUx/AUQ8EjBou3cYy39LP4c5duE18oaCiV2arNZwp4VDPjAjIKm
	 gPxVMfKujrV2g==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9ED10F4006F;
	Tue, 28 Apr 2026 07:07:28 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 28 Apr 2026 07:07:28 -0400
X-ME-Sender: <xms:8JTwaSwH2vJinZbjX63b369yr5vu7XNHc_-wRAdNEfvzC6vy7fNU-g>
    <xme:8JTwaZFpZekq5KD7b9-WdlVat9kTysFaMGJ9JyQGeTPwijKO0q080fwXi7M7lUZRi
    -zfLJH3RIAYc_ObNfYSbI6XVf0jSmj_fz1GZj8lHMLTJA2OLizEvv8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekudegtdcutefuodetggdotefrod
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
X-ME-Proxy: <xmx:8JTwaS3vmETeW2d89FduGFy7LIOBrAU1_SGe_NQ85SNo__tz2A2usQ>
    <xmx:8JTwaUI_5a2Sw3mFmvExIy_89OKC8SEYbqpYM1eK76WT7ubSvsTgRw>
    <xmx:8JTwaRH51SFbmYFjscMLfGOp2AxmQZL3Ekz6gh5DPpKEuxih4PFIPQ>
    <xmx:8JTwaQVwdXRmpVs2HEEYR5dlYjQu6EloC2c4EtBAorBgX7LEl139mg>
    <xmx:8JTwaZy-f9vTxSPAWNOdkLSjTlirBHY2uFjljyLkzqLRqhbVno2nEnRQ>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7FB29700065; Tue, 28 Apr 2026 07:07:28 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 28 Apr 2026 13:07:08 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "WANG Rui" <r@hev.cc>, "Huacai Chen" <chenhuacai@kernel.org>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "WANG Xuerui" <kernel@xen0n.name>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev
Message-Id: <e631d1e5-3f05-42ab-885d-4bd660612d63@app.fastmail.com>
In-Reply-To: <d7197b01-9b7e-4f0a-bcd2-9d6d894e8cd9@app.fastmail.com>
References: <20260427084721.40535-1-r@hev.cc>
 <d7197b01-9b7e-4f0a-bcd2-9d6d894e8cd9@app.fastmail.com>
Subject: Re: [RESEND PATCH v2 0/2] efi/libstub: Ensure instruction cache coherency
 after kernel relocation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 27 Apr 2026, at 18:11, Ard Biesheuvel wrote:
> On Mon, 27 Apr 2026, at 10:47, WANG Rui wrote:
>> Changes since [v1]:
>>   * Move efi_cache_sync_image() after check_platform_features(), matching arm64.
>>   * Add "()" after function name in the subject.
>>
>> The EFI stub relocates the kernel image by copying it to a new memory
>> location using memcpy(). On architectures where the instruction and data
>> caches are not automatically coherent, the copied instructions may not be
>> visible to the instruction fetch unit without explicit cache maintenance.
>>
>> This series adds the missing call to efi_cache_sync_image() in the generic
>> relocation path, and provides a LoongArch implementation using the ibar
>> instruction to ensure instruction fetches observe the updated contents.
>>
>> [v1]: https://lore.kernel.org/loongarch/20260427034451.717817-1-r@hev.cc
>>
>> WANG Rui (2):
>>   efi/loongarch: Implement efi_cache_sync_image
>>   efi/libstub: Synchronize instruction cache after kernel relocation
>>
>
> Queued up in efi/urgent - thanks.
>

This breaks the ARM build.

Since LoongArch is the only remaining user of efi_relocate_kernel(), I'll move it into drivers/firmware/efi/libstub/loongarch-stub.c first, and fix up these patches accordingly afterwards (no need to resend anything)

