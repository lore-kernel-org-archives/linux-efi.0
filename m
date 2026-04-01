Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ABF361DDA
	for <linux-efi@vger.kernel.org>; Wed,  1 Apr 2026 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775055577; cv=none; b=kHu6AGfnPfQ+crkidItwZDKOrLKBllXcqj4mw+umk/dtEmbEJPVTBBvjMMj5PuiTcdBXhi72z6tO3hOaaSGcOpkexU1UPVrRW7rfw4V9a21o7pFzTObUHBtr4tnSoJHLGqt2UGlLGZF7dVR9qnHKeMkbKQixvGi7r/54P/a8t2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775055577; c=relaxed/simple;
	bh=hM9KRS35rH2XHLASFtngACOiPbUjIYVi+in8ZuJP6lo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=eYfgOOtYNS0GYYX9zs0cV1hosJ/cHkkRsRycIcpKeVomb9mDlKo9z7OCxScQt4p0MmpX8kZt/85rmn7Y/KQHZTS0DLBOInwh4t5xc8LRTCDD5jKsqD8lNUGmoBR2b/NMpcNG5kPCcP4etOkOtdND+Ef2dH/z9ccc1aFxDlPXErY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q33tR8gA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q33tR8gA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4611DC4AF0B;
	Wed,  1 Apr 2026 14:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775055577;
	bh=hM9KRS35rH2XHLASFtngACOiPbUjIYVi+in8ZuJP6lo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Q33tR8gA0cGdo6WTgPzN67IKzTAGpdeEwMgCJI36Qrb9LBrD1yjQsFIO7+X3/12D9
	 z40Z3RaE48ly6ukAmywZ+NYZZCGHHSs98QFR8SCOcwfDbzSYu0e6FMK6Rq2Nzocrf2
	 02SZ+l2+519moDvfH1OyUtIfWhYMv/L/PEgZcz/82ZdaAdTf0I92dp8c5etoC3VwlB
	 j2z1ESSDiuNsc1stK8eU9ChEA2T1R7minOKZfWmeTVJG8I84cy+JtzaUQGTWC6hImv
	 FVNCs+xjM/nQZsLdug2/9i3aSHrO7Bt1n2FTGaZffIx3FgzL6LSh75mfiEU0FaaChu
	 o4QwuznxKjLoQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4E3B0F40072;
	Wed,  1 Apr 2026 10:59:36 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 01 Apr 2026 10:59:36 -0400
X-ME-Sender: <xms:2DLNaS-i3lvr4jUnsCGu0kgaYOjwG3ASzw19ZYS9Loi0eu75Sz-WSQ>
    <xme:2DLNadgbZEQvcbt9gt40jHSjjdZSb0FFPhXWwr5NDXmILeY34Y468T_qNM9H_BCdL
    jTdf7nAAJ0C5yOcfGx9eqaHUDiNa2EPc4EaocSNsDUMZAV0imiShEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefgedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcuuehi
    vghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeeijeef
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    guodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqdef
    fedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurd
    gtohhmpdhnsggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehlvghithgrohesuggvsghirghnrdhorhhgpdhrtghpthhtohepuhhsrghmrggrrhhifh
    eigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghruggsodhgihhtsehgohhoghhl
    vgdrtghomhdprhgtphhtthhopehgohhurhhrhiesghhouhhrrhihrdhnvghtpdhrtghpth
    htohepjhhirhhishhlrggshieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekiees
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepugihohhunhhgsehrvgguhhgrthdrtghomh
    dprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:2DLNaVOrmRjHpY6PQRub17OkTdzTWoB33dTGLMsjUuQAicUuJwL2KA>
    <xmx:2DLNaYY6gIUFeENTz3sUr3_9R6vt3KhLFbrUTKT7CbMFi4RIeNxxfg>
    <xmx:2DLNaU9LvPxXJZqUNd-HX2qoJGc8VI87AHAjC2DyEw_0MJ-8Sxr75A>
    <xmx:2DLNaZTxdC5SHyQyT0RjUMi5P9NHmHepsKy1DWtJfPzGhq44vgf2aw>
    <xmx:2DLNaecM7Fj88DMOEYwEzZhjauSmXWQYjsoKPtWdlsd-_8sFK16I9RJC>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 2BCFB700065; Wed,  1 Apr 2026 10:59:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A63xBQArpFko
Date: Wed, 01 Apr 2026 16:59:15 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Breno Leitao" <leitao@debian.org>, "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 "Dave Young" <dyoung@redhat.com>, "Gregory Price" <gourry@gourry.net>,
 "Usama Arif" <usamaarif642@gmail.com>, "Jiri Slaby" <jirislaby@kernel.org>
Message-Id: <a60db247-1112-4737-8553-ac584d9f1215@app.fastmail.com>
In-Reply-To: <ac0wIbJiTvHigfaU@gmail.com>
References: <20260401122351.2058145-7-ardb+git@google.com>
 <20260401122351.2058145-9-ardb+git@google.com> <ac0wIbJiTvHigfaU@gmail.com>
Subject: Re: [PATCH v2 2/5] x86/efi: Gather initial memory reservation and table
 handling logic
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 1 Apr 2026, at 16:49, Breno Leitao wrote:
> On Wed, Apr 01, 2026 at 02:23:54PM +0200, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> Move the back-to-back calls to various EFI routines related to
>> processing of firmware tables and reserving the associated memory
>> into a helper function. This is tidier, and will avoid the need to
>> add yet another function call there in a subsequent patch.
>>
>> Reviewed-by: Gregory Price <gourry@gourry.net>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Reviewed-by: Breno Leitao <leitao@debian.org>
>

Thanks

>> +void efi_init_reservations(void);
>
> Do you neeed __init here, as the declaration below? I know that
> "extern" is not necessary, but isn't __init?
>

No, it's not. Initness is a property of the definition not the
declaration. It decides which ELF section the code is emitted into,
and a declaration does not produce any code.

The section attribute is permitted on declarations by most compilers,
and I can see how it may be informative, but it can also easily get
out of sync so I prefer to omit it.

