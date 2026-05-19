Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746E140800F;
	Tue, 19 May 2026 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779204364; cv=none; b=ZevhNHBNddjcNOL4dpI1xVTdSwPkybulS6TsvWmhcSo+tWJxwoegGenN5Q6jXDw5iQxK0q4S17Cw4KfyUOtRfBWealiSSA+NJ4DbyBNPNwQ3g2DxCc9Nt+X6RRQIYiAk7Ynp0nYoWsFPwMfULFC0pGY+CLhz1edNPsWS04scbuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779204364; c=relaxed/simple;
	bh=nng3lchtEiltmgibsnNMlShREbPl8qLmOTOSAYJ6qKs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=olZdjX/E8abycevVVy3TWDpo/ZMCJ7426BJre+BBosm8eCdOP/kY/f3VQ4iGsYOyU3vyjuodLknvKKK1pw/+RVIxcfSVrgvM9etgVYYnktijHPfA4LCY4E19CLzCSwi33KDF8bEDcBKjk3cJs05yWmqZ3+98x/J+7KV484oRQlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwpDAxQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwpDAxQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD46BC2BCB3;
	Tue, 19 May 2026 15:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779204364;
	bh=nng3lchtEiltmgibsnNMlShREbPl8qLmOTOSAYJ6qKs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=SwpDAxQeRjXhu9p1f4grdwIusa/gOEWahVO49ND6XB4GYRgAfwAmG53Q+WnURdJ64
	 DntddPiUBTx41bq171o8wf0Gfi5yamDxIcoHa66ZlqkUXEf91/YOJOIFp4MxcgynUU
	 38w0riPFRTSph/hvEy4/RoHYevfZPtaXl21w9aqxJKxu0I7b0n4uh+Ba3TGWkmh2LE
	 8IE9pHnqAiTQcM5VpuPs9B9AjnBxz9uDekG+IaexSKV+uLKAt/9kJptN9LQxRZx/SZ
	 80fd4MR5oz9vwTOsnBH2+aBaxg3NBMgTDSSfmkstqcwmQTsCvtvdyKDw8Ph+n//Nf0
	 Nd4vncUic23bA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id E90A0F4007D;
	Tue, 19 May 2026 11:26:02 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Tue, 19 May 2026 11:26:02 -0400
X-ME-Sender: <xms:CoEMal813gVYtxckPH_3VgLfYCX1DubRDWSxOkH5fkeDZShXvOK7yw>
    <xme:CoEMakjnspRhaWyB4EslAwCp4DR1YVBLqC4U15YHo_CGrP-WUI5ubl26yONGsQTcF
    9xU7T32B3jfIEDRA_1bGjHFP3TNNT-x7R3s0nvENFDdeMien1MOCH8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugedvuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehrohhnghhtrghosegtvghsthgtrdgtnhdprhgtphhtthhopehrthhorgigsehfoh
    igmhgrihhlrdgtohhmpdhrtghpthhtohepihhlihgrshdrrghprghlohguihhmrghssehl
    ihhnrghrohdrohhrghdprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgv
    rhhnvghlrdhorhhg
X-ME-Proxy: <xmx:CoEMakKBWx5xIWS5tvgY2hUYybsjCrNaGaaF6sCuHrVzfwXn8AKRQw>
    <xmx:CoEMatGu64vabz-DKUKulGAAZ2DBB-tpgUNgYXNtUxEGImxmc_N2Fw>
    <xmx:CoEMagR9Tg9sWlAuObW-mC6b6X7Qr9IlhcGgAU1AqSwWXc8QPSK2_g>
    <xmx:CoEMahcU3rcPiqzfYZsXXbqEQl54uepokTdKH3Gbq-XUefddiL463A>
    <xmx:CoEManqSko9RdE_qYDW1reEQ_3OAXxgoYCswOt2c5iSBSAYFcNFPRq9G>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CE904182007A; Tue, 19 May 2026 11:26:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 19 May 2026 17:25:42 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Rong Tao" <rtoax@foxmail.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "open list:EXTENSIBLE FIRMWARE INTERFACE (EFI)" <linux-efi@vger.kernel.org>,
 "open list" <linux-kernel@vger.kernel.org>
Cc: rongtao@cestc.cn
Message-Id: <b2eaed8f-efea-40c5-bcf3-6f3cecd38a6d@app.fastmail.com>
In-Reply-To: <tencent_270AE22BC7E81D6281019A105796C8E5AE06@qq.com>
References: <tencent_270AE22BC7E81D6281019A105796C8E5AE06@qq.com>
Subject: Re: [PATCH] efi: efi.h: Remove extra semicolon
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Mon, 18 May 2026, at 09:02, Rong Tao wrote:
> From: Rong Tao <rongtao@cestc.cn>
>
> Remove extra semicolons from comments.
>
> Signed-off-by: Rong Tao <rongtao@cestc.cn>
> ---
>  include/linux/efi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 72e76ec54641..ccbc35479684 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -61,7 +61,7 @@ typedef void *efi_handle_t;
> 
>  /*
>   * The UEFI spec and EDK2 reference implementation both define EFI_GUID as
> - * struct { u32 a; u16; b; u16 c; u8 d[8]; }; and so the implied alignment
> + * struct { u32 a; u16 b; u16 c; u8 d[8]; }; and so the implied alignment
>   * is 32 bits not 8 bits like our guid_t. In some cases (i.e., on 32-bit ARM),
>   * this means that firmware services invoked by the kernel may assume that
>   * efi_guid_t* arguments are 32-bit aligned, and use memory accessors that
> -- 
> 2.54.0

Thanks, queued up now.
