Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56D434F25C
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 16:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306257; cv=none; b=EY+HPqgqwD5J8xx4aVIlU2Ki1REZG4B7C5su2GjiDimsTma0IBHwloL/fj3ZgyZaY4EiqHH92fKpRltjxeDc0LAMZXhHpPx9GgLm5KG1IPBSnL8ugjzb/wkyML+cRh7tfuCHORCozO7BBj4AtnQkFhY/Xjt1sWqUzsgut9QiJbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306257; c=relaxed/simple;
	bh=49O/JuRz24126MSZOWrumK+UCnU3jIs/tlkDUgcjbc8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=G3i6wywmUZNGkDrpYrg9GBXiOqEXz5IMIW3de0RePA8qagJtRLTLbkI4yb/a/hZmU5L7+jRJjlCnUHCiTw3dY7B6tybadK30JhQ3TsqLXEemTK5mtgkM67n+E18LTlUvRnvWd5+eNMmZJH1PAeUBCviDwWGjU7wqf5sSzRa1gck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RuMBBCr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RuMBBCr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9420C4AF09;
	Mon, 27 Apr 2026 16:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777306256;
	bh=49O/JuRz24126MSZOWrumK+UCnU3jIs/tlkDUgcjbc8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=RuMBBCr8Z8iPD+gN53j7BcDSQKXEQ+I2hbKYhOloO3ncWqhNbWhej3Q9QpQWFFK+y
	 TEYWY1vs+0KR+ntflTjyrVtBjmhAFEAyzQ3bD5Y81NpF6+A4N0PFctR/CpQMLc3o9e
	 kqOxWFZdeUsDdUYC7FbLcG8v03Pja/YHOb+9EmJvazQNI9zEFbw9nqAFK3XNtQ+Bgh
	 Lk1PEUQ5cq+IfynDxWfr3JIOGsjCUKVAcjmfG8LzhlFq5JNgjgEzdA2jzyT605j1q0
	 jL8zfAletrxxNCNC/b/O+pGm2s2y6I7GV6jptmrZDfWq2f9gTrxNDOgn2hj/aWTGrr
	 FVADH//5na58g==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C94B5F40084;
	Mon, 27 Apr 2026 12:10:55 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 27 Apr 2026 12:10:55 -0400
X-ME-Sender: <xms:j4rvaW0JC5MzB2SjhpmrAR-NbYAaDy4Rjs4wuQCUDrgSxCfbm9Xopg>
    <xme:j4rvaT7FNZhh3mbRly8OczZTkUlE20ik4ea5zzK2YuSwGh1ldyzxfKJamdD9SbPF0
    gwPoX_k55c3Hxy_nSzRMfWLhiZyeyCLr29aLEu8hc9yNLvaXRlhJY4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejledufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepjedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepghhpihgttgholhhisehighgrlhhirgdrtghomhdprhgtphhtthhopehtohhnhidrlh
    hutghksehinhhtvghlrdgtohhmpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehilhhirghsrdgrphgrlhhoughimhgrsheslhhinhgrrhhordhorh
    hgpdhrtghpthhtohepthhhuhhthhesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhi
    nhhugidqvghfihesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuh
    igqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:j4rvaYfb9b2QMdnqnirWRU22-VxhZognKAVC3JtF29-fYRgvI-Cq3w>
    <xmx:j4rvaUQiq4k8U1gevJAXazcvfDlUt6oE20-CLmoAHA9E_QvNq5gzTw>
    <xmx:j4rvaZYKMWHi8L__oqsWaBKseYBeN0Lm_xijiOCKIiFcpxS-wd3MCg>
    <xmx:j4rvafdAFdYK6DBkfYlGXjX6fF1qFHs_LmDXwNg1rRuF_mOlKyvcXw>
    <xmx:j4rvaSJRq-g6djPAZc3zDEGFtdZh1p6hEHXqWrsJ95Nokz_H54954Qsq>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id AB454700065; Mon, 27 Apr 2026 12:10:55 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 27 Apr 2026 18:10:35 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Thomas Huth" <thuth@redhat.com>, "Kees Cook" <kees@kernel.org>,
 "Tony Luck" <tony.luck@intel.com>, linux-efi@vger.kernel.org
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org
Message-Id: <5b4e6b16-3018-40ad-b66a-a228e342c679@app.fastmail.com>
In-Reply-To: <20260427155630.1966791-1-thuth@redhat.com>
References: <20260427155630.1966791-1-thuth@redhat.com>
Subject: Re: [PATCH] efi: pstore: Drop efivar lock when efi_pstore_open() returns with
 an error
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Thomas,

On Mon, 27 Apr 2026, at 17:56, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
>
> If kzalloc fails, the function returns -ENOMEM without calling
> efivar_unlock(). Since open() returned  an error, the calling site
> in pstore_get_backend_records() won't call the close() function, so
> the lock is never released. Thus drop the lock in case of errors here.
>
> Fixes: 859748255b434 ("efi: pstore: Omit efivars caching EFI varstore 
> access layer")
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  drivers/firmware/efi/efi-pstore.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>

Queued in efi/urgent - thanks.

> diff --git a/drivers/firmware/efi/efi-pstore.c 
> b/drivers/firmware/efi/efi-pstore.c
> index a253b61449459..a5db3534f0a63 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -60,8 +60,10 @@ static int efi_pstore_open(struct pstore_info *psi)
>  		return err;
> 
>  	psi->data = kzalloc(record_size, GFP_KERNEL);
> -	if (!psi->data)
> +	if (!psi->data) {
> +		efivar_unlock();
>  		return -ENOMEM;
> +	}
> 
>  	return 0;
>  }
> -- 
> 2.53.0
