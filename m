Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9643F329E7E
	for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 07:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789026708; cv=none; b=ppb1IjJH8ePFMohA3c8frEiCp2Yz00yGlwSQrPqLir0KMef0UQHJd2nQ9IPWPA/GmYfUjB5VgdQXQ6OVNOTPyTMLLNSllCIDOTZI8yHTnnsCbaPjVloF4CzFZ/xiWbbK/umv5rO/hEPkjGFryxVJkPek8ENDPvYRz4lXU40a82o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789026708; c=relaxed/simple;
	bh=1ZmSzFG0Fu7fOjSZErepfnaJ3qxrPkB8O4EXS1CbYiE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=D3FkfabR7RBlR4yrEwhdJ+GP0Dm87lbLxLwVrztRGow3RIzSZ4F+1jz4tLNdxypOHgKehdn+v4SCXo0L0Ai62+VgJ1QbHgNX961CiJtESBwgEcjx3c+3TowiM90LW3MvUqv5afnwgbrXiiTjUJwjZsNS6HzpGkJzT8Y/o8OPceo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/20Tw7I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/20Tw7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94E01F00893
	for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 07:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789026701;
	bh=fTV1Bf4xq71rXT5Ktql6Fl2ucqZaiTmwx4EnmVZxpco=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=d/20Tw7IbtXipyJONWRVddV2uIcd3EospKzvsLDa9PH3WPkqR16uz8GUnSdDiuGUg
	 FrqMmaWMVhpPS+JL3q3miVL9oJuQQzFBPJ8xtXidKietUwv99l3DuZBFpfYIcQUKsS
	 cQ19S+WyB294RWRd0+dm14Eo686eJ0uuUNHJJViITrt+IBHY9jytvK0ixoYVvqtNS9
	 5mMzflHUAoRPkTmxMNhjJv9IZRGeFyBorvfP9RBJRfpwzeTaRRA/6/QiLxKUPx7umf
	 spT/dRIs8U7f2nzW0kPw0zHAZ04cYWJGdo1PNtUzMht/MocESIZy9uOF2zgRJRxSSu
	 kHwRYXI+5ctgQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 30B58198003A;
	Thu, 10 Sep 2026 03:51:39 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 10 Sep 2026 03:51:39 -0400
X-ME-Sender: <xms:iWGial0YfZzz8NyxwzBMeERTmoAxSgY4w2u99auDxQRB5qbXcD5LOw>
    <xme:iWGiam7BcfxEi_byOHLYgCHwOaOIyO-98lLXuMykxBw9DKtEYPmAd4yzrLUYV3u9N
    PMvoxyjbJZazs7BWy1o5ZsA14bRY7SbX2muiAOfAn7VCW64Jb_7Cbw2>
X-ME-Proxy-Cause: dmFkZTEPvKawiz7mUAL92o+4JCXIIMD++sKyAcjqH50tYYm8waV6VzHYz24+KXS1F7Dg/L
    HNUVRMF4DZqFUzwh/ocSTUIjyb9axva+h1Zu+FastzH7GinRY1IJgNW1AqRl2TO8bcAzgY
    lbDQxZdVODYOFHvOSWcUXi6Knq/PpENCpwa58g6cNC9zkPPWyJeS1RW+hKwaro3nUcMKiu
    PM5gGnNGef+OWSg9pgnTVcxbKPF4Q1ubRb0lSFGhysR2gVKf+9y9t9yp4iSH1S63DydaMJ
    kjxxY1Fti8H8Iq40IW9ymYmO6E2X7Q1CTQgzhUJo8G3bW7LKRLnvckD3HHsm3+kd+6C6TS
    9qAZ0SvjLedrYw9LrLLX8GMv75eodafHzOrMFPD7idiZGHt5oKAO5rCH/38Mq7ONhW4Bli
    CB0O9xZgMUwepV8ao38M3nnq7JrhrQCSsP5+LvN5h+vDsMi4jQTVOsyc3Otbe9ALwDfFcr
    Zze91vJiERX28NMq6Zr44DVWmzxHBa/mgErtialwY0GPw3vm2WylTKFwodikV3YpL7Cjba
    iXcWVZPiP08yjc17gbxTxIZvRiFPrvETn8Dxn3fux23zpKRlpgwrWIFevaqD7giWfEb5hd
    vB8BRrF51zQj7MvIO3pYu3BLRN1XNVHBhDbEUoRLg3IyBaCysgp3ZfDTg0DA
X-ME-Proxy: <xmx:i2Giau-YPQZ-qalpUhABGqn9-FpE8kMKaEG7WcYC_4Qg6vxrchd79w>
    <xmx:i2GiaqIli4zudZJ8i2oghNPm4J98FlR3Xd5t80ivZufWnVaKMY0ILg>
    <xmx:i2GianilUZDZO0-in8vd_sJq0P-6jd6AvTh8g0xwuTvSdtp4BPxPdA>
    <xmx:i2Giaq4qOoNFs_L8xHm3ByGUOKQT9BUYt2BWObq-lMiTLUDUjZZNKw>
    <xmx:i2GiavYSlwHjNRo-wuXnzN99O5R0mY0C8CiKra7Z3ggoldYsawzuQTkS>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id D633BF8007E; Thu, 10 Sep 2026 03:51:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 10 Sep 2026 09:51:17 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Thorsten Blum" <blum@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <e41fae7c-9a09-4ae9-aef2-ab4a59d974f0@app.fastmail.com>
In-Reply-To: <20260830102911.345357-3-blum@kernel.org>
References: <20260830102911.345357-3-blum@kernel.org>
Subject: Re: [PATCH 1/2] efi/libstub: Simplify check_image_region()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sun, 30 Aug 2026, at 12:29, Thorsten Blum wrote:
> Drop the local ret variable and the break statement by returning the
> result directly. Also use unsigned long for map_offset, since map_size
> and desc_size are both unsigned long.
>
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/firmware/efi/libstub/kaslr.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>

Both patches applied to efi/next - thanks.

> diff --git a/drivers/firmware/efi/libstub/kaslr.c 
> b/drivers/firmware/efi/libstub/kaslr.c
> index 4bc963e999eb..17549bf3dc3e 100644
> --- a/drivers/firmware/efi/libstub/kaslr.c
> +++ b/drivers/firmware/efi/libstub/kaslr.c
> @@ -59,8 +59,7 @@ static bool check_image_region(u64 base, u64 size)
>  {
>  	struct efi_boot_memmap *map __free(efi_pool) = NULL;
>  	efi_status_t status;
> -	bool ret = false;
> -	int map_offset;
> +	unsigned long map_offset;
> 
>  	status = efi_get_memory_map(&map, false);
>  	if (status != EFI_SUCCESS)
> @@ -74,13 +73,11 @@ static bool check_image_region(u64 base, u64 size)
>  		 * Find the region that covers base, and return whether
>  		 * it covers base+size bytes.
>  		 */
> -		if (base >= md->phys_addr && base < end) {
> -			ret = (base + size) <= end;
> -			break;
> -		}
> +		if (base >= md->phys_addr && base < end)
> +			return (base + size) <= end;
>  	}
> 
> -	return ret;
> +	return false;
>  }
> 
>  /**
