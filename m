Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EEC202F70
	for <linux-efi@vger.kernel.org>; Thu, 27 Aug 2026 16:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787849793; cv=none; b=SuYC4j55+HGd4xlcnF61AnSlQEf2nDM2b/8FDqgRg+D35ktkBzd0H5eCGABIkCMlKdY51CeTWhsno+sB/OW1iAR+p+bs1WrEvKarH9863+ikP8qpczM9WCUEOs4+yGhMdB6VLnZ59KFPZRpOEmOJ36+ld3AjxO9JKxKjbQv/el0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787849793; c=relaxed/simple;
	bh=Wx8ZuaPdOk0CUD+4O2fpoWYPaklYZrXNxnA+Ab2hPY8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=b6Fpk3SaRwGfiluGLjvfTz3/rXeU8KaZwcuE4lBKdputqfXt6Rxqvmrof1sSWnSp2Wg+w8f14HaIKaGNdCvO8KHnFhjW4JpzDY8rX/E0TByX1lTp16o/dcdpAKuTqcH52pKi/tMS2NiACyhjGSDuT3Oqr6nY/En+EDa3RQ7JUhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gpFNVGfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gpFNVGfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803E91F000E9;
	Thu, 27 Aug 2026 16:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787849792;
	bh=PbiTD6lzL8qqMsoKt5E4d4Ayp91dEtIczbslfDTernQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=gpFNVGfHXO/gCOfYA2cLuKJbDlfK0Mxqsd4xCT9qdunvj7WZ2h6c60fB0g0dlrK45
	 YndQkehYxUQr1yQuTlC4NTWkurCx331FzaYrVk5mOL/mUCrpl6VoCL9edgaqZNHljF
	 INYlQmIvJixWtD5EyDRfm3iOUw6388dpbWABRKNJwxG6DKKXI3dNhbXYoHCouahaLj
	 5o10IUghnnhTeA5JpRz9+k8GK37VSWgyFUAHreYN8+sNX4tlqWPlGaRbzMyvBUmxYZ
	 +gIYdpYdCeBRti8+tQnmlDxlQlqUgdemgMz41wIPtDnKCysUFLTHbBX0YkHw7ol0pj
	 t6IpRQeSUtlXg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 03D231980076;
	Thu, 27 Aug 2026 12:56:30 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 27 Aug 2026 12:56:30 -0400
X-ME-Sender: <xms:OWyQan4WD-YjUbHh6nbpXq9Z6FGE0Wu3BCx7HveKiEDwpOi5YnbdhA>
    <xme:OWyQanubWF67u4o-E7XSuoCe9vO1ODalpxcTOiKExUM8px81qtKTHBdOaiefgUMiK
    Xy1ZhpaUYzJobCfxLSwA-0CM5-sXjSHiMZHti2uELT8iUiooe8RSjk>
X-ME-Proxy-Cause: dmFkZTGDLpveOOxF6h8KGY3t4+bTyWJouTCSmu9bofi2/ONhA+GjJ171fe+Abs3vV4Sc9e
    XewEnlNATcru2t36sA6e8F8bHdzyXdv3OY5dRS4H6Dqa6nNroOz4cmAX3Bg5tjLZejz3eS
    wHM5fzNAqbNNRc8hBW/cEgB7IQlkRkZ04yVCb6WZyJdrrvqE/xoxEveb0AgsHGdsb6ojdh
    D/GlFlnGbplLnEDTFnu/f40vQaV1pVHFE8dV5xtTcHZ31a26IP6Us94m8/KEwZSoDlcg27
    bdY7h6OWdH7WqAJvnrRL6uEYIPCw8fdv4Du+Yjzocz4y2xrIwKu4BeAA2CVGV3RSqMBwa9
    HOyqUNkCn1ZAMi/uLPBBLyiTXUGyAQELvFqCwF+HMt+1pK6glz8FxVAB+T+UfZaolTdDC5
    RsPJWaUUOUndtuwG4lzQkt4GUnSqVigRnLOqBVElQr1vb5ZNCt0njEJqyBCMVQYJOvXK9D
    9wTsNgQdxEcoP/hXBWtyPHioP0prl9Vk5xCfW5G+UXnWc2r5wT2HQWGU2gNpQLy8Hu404v
    B/irtfrYX3kd2QeGdr2jo29cSxwzeaD32mgqrcLY6eC4HO7C9roQ3N+uqAU6JihtoVSgTI
    RL1IWZE8MpNp56P6GA8ad4hSJ4oR86dOfq+FkE/dh7XORw9SiXyqVgnv8dOQ
X-ME-Proxy: <xmx:PGyQaiw4R3y9UG18vT5r0i-yruqCVrF6N-IvVhe896wddsf_wObsKw>
    <xmx:PGyQamZEWQLQT9R2DxaMotC1tcl9qeJ-xC4U-WvYpGw0fY5T11OthQ>
    <xmx:PGyQaj3RFn_t4zxFQ550xBRuAnVcx38jUiN6buQTmpLjxi9yT3T2Lg>
    <xmx:PGyQaodjWrl02KoFmJK6amxLvxGZqymVF_kkzgw0nrFn4U38XCP-xA>
    <xmx:PGyQagLMS3D2Dtq7amJUyUvF0rMNSdrt8iT5hHT1jCnTww9Pv-ZbQI6G>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C7774F8007A; Thu, 27 Aug 2026 12:56:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 18:56:05 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Thomas Zimmermann" <tzimmermann@suse.de>,
 "Javier Martinez Canillas" <javierm@redhat.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Jani Nikula" <jani.nikula@linux.intel.com>,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org,
 "Simona Vetter" <simona@ffwll.ch>, "David Airlie" <airlied@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev
Message-Id: <6b778c42-577b-4df1-a364-d4123f45080a@app.fastmail.com>
In-Reply-To: <20260827140726.420734-1-tzimmermann@suse.de>
References: <20260827140726.420734-1-tzimmermann@suse.de>
Subject: Re: [PATCH 0/3] sysfb: Fix display output on Lenovo D330 (and others)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Thomas,

On Thu, 27 Aug 2026, at 16:01, Thomas Zimmermann wrote:
> The kernel mis-interprets the display geometry given by the Lenovo
> D330 as incorrect. The values are correct, but the display output
> is rotated by 90=C2=B0. With the kernel's firmware quirk applied the o=
utput
> is garbled.
>
> Remove the firmware quirk for the Lenovo D330 and let DRM's sysfb
> drivers set the correct panel orientation instead. To make this work
> for any display mode, use the panel size for looking up the correct
> orientation.
>
> Tested on a Lenovo D330-10IGM IdeaPad.
>
> Thomas Zimmermann (3):
>   drm/edid: Add drm_edid_get_preferred_size()
>   drm/sysfb: Use preferred panel size for panel orientation quirks
>   firmware/sysfb: Remove rotation quirk for Lenovo D330
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
