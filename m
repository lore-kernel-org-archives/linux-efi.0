Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352003DAAD0;
	Tue, 15 Sep 2026 08:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789462482; cv=none; b=gSgCI4rHVlYLvzPdGp9TlhB2Iql1KlMASpv/fEDF7wFcyakvDZLSqH/vAt0hvt73CJfvj6xwVZr87UWdX5Ir1tzwgdlSkKfXAqy+eHXNGHDGwFb1xj9n+Za9LmGDXjHPadP5SNisjgwAme7y94+LON2MNZms6wyK6jKM/csp0pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789462482; c=relaxed/simple;
	bh=TrFy84WFLihamQ2UtPEIp9cWrnbixhLsx/cx/JOsURw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Gwt4J9BJ21kueYZ6sw8cWxnQruGt+nMmD0NCOT9JiWGooP9zDApwclP9IhjwmMEwiL0geGEbIr2MUOYCwgsgPOItY2qj0on2lHENyGJ++QchgU/uUtSaMOgdRsGdp4ZdVnq4UR4jZtKfa819jIQQqCt7PlXVRnjP/T6JeVLkSkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Xody1oJN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Fr6fJyQZ; arc=none smtp.client-ip=103.168.172.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Xody1oJN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Fr6fJyQZ"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id 0CFA21380347;
	Tue, 15 Sep 2026 04:54:35 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 15 Sep 2026 04:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789462475;
	 x=1789469675; bh=l+Dca6AU7f0s7A11m75QKiePhth6dKEUN646ZUyOcxw=; b=
	Xody1oJNWEMViAMOHPbGMbFFJWDXAlekhcwJV2SoNNjV3Itz044FXU72K/NOTqui
	dGNVaAbLlZulA5UBbJ7XisJ4/Tvb8vxRSHZgr1rg86rZaW2N6A20pRXX6CjuJFzZ
	qN4XhD+zqJj7G6GzdewHzc9Ub5bvOnhXRm5+AIgWAw6aKT926nad1Knuxbpc675A
	AzTOl0hJn/NZF15+dJYlH0kXOE9oaDD1dkmsAcj8fBTRb96rHKlGhQLyQSuMNDH/
	4VAddWv+NRh+YnPkx2GOowIODOGAueKi2AxYNKtoPrv0OBaFTazekFo9yS6tBLOp
	1Q82whhHv8fjGkGI4JpxpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789462475; x=
	1789469675; bh=l+Dca6AU7f0s7A11m75QKiePhth6dKEUN646ZUyOcxw=; b=F
	r6fJyQZ3B1K5YtWjMoTp/fRKQnkOGDNwUteDe4nSuymkyvq2WsfTel5mLEsiIniB
	Q8Mg3SaUa+hsdJwDYad3RVOHqY6wVuGBbRMXj+q0YdMMGPUOsGRVwT87zBxsoxES
	RO9e/Kk1iPvbMNYiJPlnyVnmhvk9iZJMC0Hl8RMrWAZ2w+CFpRVPeszShBh7jyY4
	8pafu94pmoPvJ37O6z8ACe0BUJ66rCCYt+VIRpYGoi+zNkUwBU0gu7mu7AArH7H1
	kfhRzCurvSNdhnOouyFcmOZ/aEYZowpWKOguKfCcIqTeATR2Y52GrsDRnY4YlRT8
	4mvRCMtRoq3C+WpdMDmrA==
X-ME-Sender: <xms:vgepagxIogvlk792euZsMnA2AD-07upm7o1gQScllFz15_5556isuA>
    <xme:vgepavFIcm_1MvsAOmz2-JbwyBuNZNrMJpYsNzJOlp3FsY8ocFhn_i6RRbVtbI_xh
    1ZW5w582V70b24GHPa0lC4s3Vi_hKlkZoAkL5CnvbECiIVQRZ2bC7IS>
X-ME-Proxy-Cause: dmFkZTFl07Cd2pNoRIcz+Y9DRXa9I+CAUbyY73IeYUKFyinqRYJWqvWva9WPMlSrUtrXXQ
    4Ce7uDNbLSoFWkhxcsl23fov82rHUN8DJQrUSxcE/UGH5WEDUUFVVGsxSlX9y1C16y1ikq
    1Hzd/K8lu3qfyVrj+2Esn9a+9urCLgaUn1/Hd12DOGJvXPGzYSt8nJENaQptMkY/jEyE+u
    S9faTEM6ZNXS1Rhf+11JTufpU/muQclYTOYI+iNfCTdQIpuxlsrqU2hRdRCR3my42gTIci
    foRjjuFQi3I4plLW/2yjK9qsVn6rhO1nfI17QxL4uXxeeZVrN1VwQjZE4ge9q8fo1rM0X9
    rhiOoth3vgfsKc6+FhKiMgmD69qMeWJU5dx0D71/c9CvyFGUfnl5G7No2fZi2vJmcmsWv/
    +UST0qDeQsCHTDbJGGyedoSdHZ7/3mF5Q1wzNjHqpNnUUAF7MF/RhXwaQA8Qj3bpXpRWZk
    WM2pUx2qPAmh1y6xmTh8nd0xCpzZHILt4JYJprl0AWZ62t80PI4UgOxCQLgGPoRTb8KlzB
    7SSwnrEvKdcy0NSaAHG069l+OP4bVIt5jLLqs+Vt+azYtoLHe7W+0DYJTzaj831I7mO2gR
    af3uM0A9HNtxo2qLYSmTeYYtjD/xXjNAVQ8rRDyPxRvaGwqUBq2NMVTlab5g
X-ME-Proxy: <xmx:xAepagJ83hBWhUGi-qVtm002tZ6nTUV_OQ9QV71wb8cZ5sDkjqBMPA>
    <xmx:xAeparBNN9LUMZgDPwhes7U75oqanecICHjUTVaE1k1UIFiw3-JoVg>
    <xmx:xAepajlQfJFGq9Ujz61CsXpfe6X8ZyU-XYpSbmHIXAFjLrnSj5AGjA>
    <xmx:xAepanETL89xwgdJrVvqYbWpq6B3LGj8dODqxwt8wrzrZnsIIpowVw>
    <xmx:ywepaiFG3kexiM5eVna2DP0CZbgBhmkObpO3qC-5-C8A-WnmgHPjeTq->
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 268F432A0081; Tue, 15 Sep 2026 04:54:22 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AGrkui6Nx9zw
Date: Tue, 15 Sep 2026 10:53:51 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Kees Cook" <kees@kernel.org>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Nicolas Schier" <nsc@kernel.org>,
 "Nick Desaulniers" <ndesaulniers@google.com>,
 "Bill Wendling" <morbo@google.com>,
 "Justin Stitt" <justinstitt@google.com>,
 "Masahiro Yamada" <masahiroy@kernel.org>,
 "Alexey Gladkov" <legion@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>,
 "Ard Biesheuvel" <ardb@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>,
 "Gary Guo" <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 "Benno Lossin" <lossin@kernel.org>,
 "Andreas Hindborg" <a.hindborg@kernel.org>,
 "Alice Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 "Danilo Krummrich" <dakr@kernel.org>,
 "Daniel Almeida" <daniel.almeida@collabora.com>,
 "Tamir Duberstein" <tamird@kernel.org>,
 "Alexandre Courbot" <acourbot@nvidia.com>,
 =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 "Jonathan Corbet" <corbet@lwn.net>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
 Linux-Arch <linux-arch@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
 "Jens Axboe" <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Message-Id: <7646eb0c-7c4a-4ec2-9562-66a74c4d9858@app.fastmail.com>
In-Reply-To: 
 <CAHk-=whB0X28MNAg71it=1SfFyV7rB+PK3qajpRyWoxXHW81fw@mail.gmail.com>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <202609140833.88C0E16E50@keescook>
 <CAHk-=whB0X28MNAg71it=1SfFyV7rB+PK3qajpRyWoxXHW81fw@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] kbuild: significantly speed up kernel builds
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Sep 14, 2026, at 17:53, Linus Torvalds wrote:
> On Mon, 14 Sept 2026 at 08:41, Kees Cook <kees@kernel.org> wrote:
>>
>> One area I think might solved via an LLM is the 3-pass kallsyms stuff.
>> If we could get a deterministic kallsyms build in 1 pass, that would be
>> very nice. A lot of people have tried, but it has eluded upstreaming.
>
> Even the three-pass one hasn't apparently always been entirely
> deterministic. We've had random reports over the years of it failing
> in some circumstances.

This tends to break whenever a linker (rather than the compiler) starts
creating a new type of symbols that show up in pass 2.

> Maybe we've fixed it all, or maybe the failures just go imperceptibly
> rare. Regardless, it has definitely been fragile.

The rate seems to be once every few years, looking at the list
of exceptions added to scripts/kallsyms.c (now scripts/mksysmap):

efe6e3068067 ("kallsyms: fix nonconverging kallsyms table with lld")
516d980f8541 ("scripts/kallsyms: skip ppc compiler stub *.long_branch.* / *.plt_branch.*")
b9b74be163a2 ("ARM: 8555/1: kallsyms: ignore ARM mode switching veneers")

I'm sure there are other instances on architectures that get less
build coverage.

     Arnd
