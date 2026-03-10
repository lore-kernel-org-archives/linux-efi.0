Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8BD2FE59C
	for <linux-efi@vger.kernel.org>; Tue, 10 Mar 2026 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773153508; cv=none; b=LufDY+FxsvgM9+D3Puv88Y/YK2tyx8x1BuyTqptSf9WVfOQCM759Nd1wPBjSp7pjt/c935jJurgQER6D718zaROJWvSoOVJKr+qMjfXS2Vkie5bdcn4F3W1GyhY7kewVDIAzZH4aq36xL/61HGz0KC4KnHokcJvo+bgFVSl30J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773153508; c=relaxed/simple;
	bh=etEcqajdb2iUerrWFH9k8ilmQRlu8m7ghh1gldt22aY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=gUgYTsEryuVNi/a51zY3dmjNMh++5Shh0I7WBd+ELJMlrHMOW5zKLoZ0ID4p2KB2N/TxP50RgzhNbbyJMI+R8R7r19WULcU6xH8XfMI1UTPwnIPGoH5HtRL5j1TBNPnqt4dngWTDToWR0yNx0pBmtDGOutSNxB91NKY4d3Y9x5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=af0IjtJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="af0IjtJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0CAC19423
	for <linux-efi@vger.kernel.org>; Tue, 10 Mar 2026 14:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773153508;
	bh=etEcqajdb2iUerrWFH9k8ilmQRlu8m7ghh1gldt22aY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=af0IjtJk798mtF+xpu1cKSeWkn4BLfCkjk1sRnFSvcVsV9lYKp6xeg0jAWYUIjOFc
	 Ba1Pk/oP7AZirnJd1DILQyWl0wFDoO1ZsydZnakhotLhh/L9S83BPLbfmZy3XSS1vZ
	 kIXzGw0Mg6l0wM+wOWXwI7q1fv2ttIx15ZGZDR43BXwpyHXgGRqm7DF3B3mHW9cq3r
	 YxrL2t6oBJHzXM0MU3Ft5TYgBM6UGjDXin5vhkr7/O5ZH3DGLjiOdFKSiT8BbDpTtF
	 OWdwTneKCx9WHeFiTMpZxNyykYWAA5Ayoxfrmq+x9xVe/fuTVnPfF7nwQgyyj/+OQ8
	 c1GJIFmXnHR3A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 145E7F40069;
	Tue, 10 Mar 2026 10:38:27 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 10 Mar 2026 10:38:27 -0400
X-ME-Sender: <xms:4iywab4Nxq4Gs8GfNQqRXYGmM-kI2ZYH5oZHLGqszSxFOjIlJstarw>
    <xme:4iywabthY6UZZI8UzXnRub331frqn4ivvvl_RxsiPoq613kryqusMDzPmQ7y-KuAi
    b3Xa7Frk77nGtDCxCBUsdBnowP8u4lwdpLCpnq-obS03NRT1XOCppwB>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeduvdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegsvghnrdguohhokhhssegtohguvghthhhinhhkrdgtohdruhhkpdhrtghpthhtoh
    epihhlihgrshdrrghprghlohguihhmrghssehlihhnrghrohdrohhrghdprhgtphhtthho
    pehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:4iywaVnfDS9DnK22ZaP6GuLYSRzRJfJppT6pZzPqW483dJkHkgzajw>
    <xmx:4yywaXv1yq42o3lD1wPzhD9AZ8YcWLz0PDJPHic48PQhTAaj0o99xA>
    <xmx:4yywaT-abV_6Q_hWA8XlUvkHfztFEHPloMHH_FNPO9LFNcRhGaKC8Q>
    <xmx:4yywaRNx9HMbIsWwvV8QRnzDHhRS1mOFsHrfK8QsTwYnYcCi23fo_g>
    <xmx:4yywaRH0ROmQWqrvTrkyBFoFmvKebZSmt9AgA0PjjHemk7DnvRkVUh-W>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id DAC5F700069; Tue, 10 Mar 2026 10:38:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A6MfMNWqR43g
Date: Tue, 10 Mar 2026 15:38:05 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Ben Dooks" <ben.dooks@codethink.co.uk>, linux-efi@vger.kernel.org
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org
Message-Id: <1679cc1e-df84-4067-905b-332ea0a92aa9@app.fastmail.com>
In-Reply-To: <20260309171012.2909693-1-ben.dooks@codethink.co.uk>
References: <20260309171012.2909693-1-ben.dooks@codethink.co.uk>
Subject: Re: [PATCH] efi: libstub: fix type of fdt 32 and 64bit variables
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 9 Mar 2026, at 18:10, Ben Dooks wrote:
> In update_fdt_memmap() an update_fdt() the fdt values should be
> of the fd32_t and fdt64_t types. Make the relevant changes to
> remove the following sparse warnings:
>
> drivers/firmware/efi/libstub/fdt.c:97:19: warning: incorrect type in 
> assignment (different base types)
> drivers/firmware/efi/libstub/fdt.c:97:19:    expected unsigned long 
> long [usertype] fdt_val64
> drivers/firmware/efi/libstub/fdt.c:97:19:    got restricted __be64 
> [usertype]
> drivers/firmware/efi/libstub/fdt.c:157:19: warning: incorrect type in 
> assignment (different base types)
> drivers/firmware/efi/libstub/fdt.c:157:19:    expected unsigned long 
> long [usertype] fdt_val64
> drivers/firmware/efi/libstub/fdt.c:157:19:    got restricted __be64 
> [usertype]
> drivers/firmware/efi/libstub/fdt.c:163:19: warning: incorrect type in 
> assignment (different base types)
> drivers/firmware/efi/libstub/fdt.c:163:19:    expected unsigned int 
> [usertype] fdt_val32
> drivers/firmware/efi/libstub/fdt.c:163:19:    got restricted __be32 
> [usertype]
> drivers/firmware/efi/libstub/fdt.c:169:19: warning: incorrect type in 
> assignment (different base types)
> drivers/firmware/efi/libstub/fdt.c:169:19:    expected unsigned int 
> [addressable] [usertype] fdt_val32
> drivers/firmware/efi/libstub/fdt.c:169:19:    got restricted __be32 
> [usertype]
> drivers/firmware/efi/libstub/fdt.c:175:19: warning: incorrect type in 
> assignment (different base types)
> drivers/firmware/efi/libstub/fdt.c:175:19:    expected unsigned int 
> [addressable] [usertype] fdt_val32
> drivers/firmware/efi/libstub/fdt.c:175:19:    got restricted __be32 
> [usertype]
>
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  drivers/firmware/efi/libstub/fdt.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>

Queued up in efi/next - thanks.

