Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD9222F388
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775837503; cv=none; b=R78WHLBLlJUP08ogRvE9YIA/vfYfBmRHF9DFQX0H32uOHkBghjpNP8YrqSdOJW0bR2dnuEzhBQ81YnDtnqfivS2auY1F9y1YFMEn+enA4PDl/m/n/QG8+KSFlHid1i8uWHKbFt39ZIW35pU+ujoEwSpx+lEoNKX+P4h8Av/qUgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775837503; c=relaxed/simple;
	bh=rl6U36i6r0/RoHfgYMakshoM4MLziVi9ADA5iFDBEP4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=pnKgo9T2DuC8JurkM87P5akudzgQCD9tLoI4Kk4zvPBMrLo6w2U62SZbPL8KRO+95vSg+83W0r7dznCP9Bk+dXO49jhzSkk07zx0D+6Y1JQTLaE4L1m2TYaKj+Y9tZk+1nhhD5SKRHoN7LPBP5aELPNiGbOWmJXbUF/xOSUEGnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wyu0CEWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wyu0CEWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C1FC19421;
	Fri, 10 Apr 2026 16:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775837502;
	bh=rl6U36i6r0/RoHfgYMakshoM4MLziVi9ADA5iFDBEP4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Wyu0CEWB/U7hATxo18PCt1MjMLG5krVG4XW/JMOGR45vFRPNRN6tsqcODTSgm/pqj
	 pOQoeELZpttySfNrwmeIqH5fwqOMqbWd9yBxNtKYMZuMR9IW5QBL7r4lF8fuZSz7EW
	 t6KlWdVtPEvzOe98PfQ7WLUGzt2pp/CXpGUgdmTSKEaqfamFTiPFyt5qkyxpSuQNqO
	 pIT+lJAnrSsqVUvo/PE4936BuUO0GZT2COiZUuWvNgPqEQJVihRM4Y2BfiL/8X3i+w
	 tqjxvletpEt14+kaACxb4r1YumkDfXBiGfUKZlCWB63i47c6V1oH4RfF6Vt1ZHvgkw
	 kPr04REjIfL9w==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7DAE4F4006F;
	Fri, 10 Apr 2026 12:11:41 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 10 Apr 2026 12:11:41 -0400
X-ME-Sender: <xms:PSHZacIEx2zQcJRwhZ2IylTqsa6_YYSsT-ho6uuJiqBlSFlyWMaVmg>
    <xme:PSHZaW8mapn-A6OsV8oJqDdENnkihXsX0LD9lBRebEfsdVy3CuEWYbOdCEggx4Ra-
    m5ZatOGKtY7MqeUJRWQ0EsskJlWMzsU4DQzYEOtszwHEfNlVLo4PY8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvleekiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepihhlihgrshdrrghprghlohguihhmrghssehlihhnrghrohdrohhrghdprhgtphhtth
    hopehthhhuthhhsehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdgvfhhi
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvg
    hlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:PSHZaQwmejgQIiIGgT8WHS0mizdtd5fKfctlII4S4TjLvEVSOxQqig>
    <xmx:PSHZaftI15OQP-Vo_hfH8G67Hx45lU1W7at93hjAqQ4xZmLLu6EEcA>
    <xmx:PSHZaV2oitccGIa2mLDS0MZiw-ITEBZ-4D68qpMxuK1SdQLKwpjPNA>
    <xmx:PSHZaS8kNlCb5yKsuSE_kKvBMJnOs6wxA9qjF1YMbiNwflNzm0Ct5Q>
    <xmx:PSHZaeM09osjKr6pIxfXsnpYyB0eu8to_Gam9DBUjx6PVJLDm8Chktol>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5BD7A700069; Fri, 10 Apr 2026 12:11:41 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A80jVRR4goAZ
Date: Fri, 10 Apr 2026 18:11:21 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Thomas Huth" <thuth@redhat.com>, linux-efi@vger.kernel.org
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org
Message-Id: <f7c9cc16-4b68-409b-818e-e5c107a5e27b@app.fastmail.com>
In-Reply-To: <20260410154637.42301-1-thuth@redhat.com>
References: <20260410154637.42301-1-thuth@redhat.com>
Subject: Re: [PATCH] efi/capsule-loader: fix incorrect sizeof in phys array
 reallocation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 10 Apr 2026, at 17:46, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
>
> The krealloc() call for cap_info->phys in __efi_capsule_setup_info() uses
> sizeof(phys_addr_t *) instead of sizeof(phys_addr_t), which might be
> causing an undersized allocation.
>
> The allocation is also inconsistent with the initial array allocation in
> efi_capsule_open() that allocates one entry with sizeof(phys_addr_t),
> and the efi_capsule_write() function that stores phys_addr_t values (not
> pointers) via page_to_phys().
>
> On 64-bit systems where sizeof(phys_addr_t) == sizeof(phys_addr_t *), this
> goes unnoticed. On 32-bit systems with PAE where phys_addr_t is 64-bit but
> pointers are 32-bit, this allocates half the required space, which might
> lead to a heap buffer overflow when storing physical addresses.
>
> This is similar to the bug fixed in commit fccfa646ef36 ("efi/capsule-loader:
> fix incorrect allocation size") which fixed the same issue at the initial
> allocation site.
>
> Fixes: f24c4d478013 ("efi/capsule-loader: Reinstate virtual capsule mapping")
> Assisted-by: Claude:claude-sonnet-4-5
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  drivers/firmware/efi/capsule-loader.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks for the fix - I'll queue this up for the next cycle.

> diff --git a/drivers/firmware/efi/capsule-loader.c 
> b/drivers/firmware/efi/capsule-loader.c
> index 2c628a1270919..8e8f81f0a5a0a 100644
> --- a/drivers/firmware/efi/capsule-loader.c
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -67,7 +67,7 @@ int __efi_capsule_setup_info(struct capsule_info 
> *cap_info)
>  	cap_info->pages = temp_page;
> 
>  	temp_page = krealloc(cap_info->phys,
> -			     pages_needed * sizeof(phys_addr_t *),
> +			     pages_needed * sizeof(phys_addr_t),
>  			     GFP_KERNEL | __GFP_ZERO);
>  	if (!temp_page)
>  		return -ENOMEM;
> -- 
> 2.53.0
