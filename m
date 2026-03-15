Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0CB1B81D3;
	Sun, 15 Mar 2026 22:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773614855; cv=none; b=EA44bX6LoxzV5Y8/wIniHFNOge4huiYNc/W+mtUSUHCPayBIjcmmrX55UUs1H5ckbK3/zazF20lVQ/GgQrHKwxsJgU0C8DcYpMDP4YhdJG/zZxfD49iH46EpA/lHQAxsdGh0j3zZGzF1/7NEPDsCIksUuqiD3YrmyOSFhgpGZSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773614855; c=relaxed/simple;
	bh=qCd0mzfTyx9kSm0CTmwDgmXX3my8KnJ1XBHs59mm93A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B9YtxR9R5pM1ak+XWoCUJ4xUS5pdaW+LvJ+2ehA/qLG/m1JnjEJ2MlAb15XDwiMa7lynm4Ia2tLWiWYcgvSoEZUZj1Tt66wPgDd0UhPxq9c9Cxs8xw/Rf3qh+WbiM6VZP07Juf29Od0Fbp6qgid+lpb/2XMdE8gCDNdt566NB/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UUBfNrz3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UUBfNrz3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=HD9oZHYyldQTz8nJeqJW1FoNAd16YVBd9jooVkYzrPU=; b=UUBfNrz3wtT9+/tlKlWhgynlFW
	ziwn1sqTMoOX6Z3LeQaERhi7CjU4poCk96YRDx4iF9tdttRyl9NukeAhdI5WxTU3HeLbhbtcslkwK
	zE3FA8rzbIM+FtVfuXFAlzBVTqa/jk5kACFrGuUs02x8f/LdjXiPU6Esx45Npw4w94dLLL0dpaQxc
	o3vlLpj+dclJibe7H7fOW6RC7ASepjuKTh9bHQxPEpv4KOawvrtNNqj4i1ZX3Q8PogTnV8R1eTTkJ
	g+in0hjMPlSwNygH9vqTGiqZ4gMLCfMa9fkb1YXJBzty5RJP+ybKESBriaByiuJarjyQ6fUm619+Y
	Llok3j6w==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w1uF7-00000002yY0-4ABl;
	Sun, 15 Mar 2026 22:47:30 +0000
Message-ID: <f6447530-821d-49cc-b8e4-f7a21d1305f6@infradead.org>
Date: Sun, 15 Mar 2026 15:47:29 -0700
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] efi: Save Brightness using EFI on Macs
To: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>, Ard Biesheuvel <ardb@kernel.org>,
 Hans de Goede <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:EXTENSIBLE FIRMWARE INTERFACE (EFI)" <linux-efi@vger.kernel.org>,
 "open list:X86 PLATFORM DRIVERS" <platform-driver-x86@vger.kernel.org>
References: <20260315222020.24341-1-atharvatiwarilinuxdev@gmail.com>
 <20260315222020.24341-2-atharvatiwarilinuxdev@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260315222020.24341-2-atharvatiwarilinuxdev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/15/26 3:19 PM, Atharva Tiwari wrote:
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 29e0729299f5..dd0a9c9a772a 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -167,6 +167,16 @@ config APPLE_PROPERTIES
>  
>  	  If unsure, say Y if you have a Mac.  Otherwise N.
>  
> +config APPLE_BRIGHTNESS
> +	bool "Apple Backlight control for EFI"
> +	depends on X86
> +	help
> +	  This will save the brightness level to EFI, so brightness
> +	  level is preserved across reboots and shutdows. allowing

	                                        shutdowns, allowing

> +	  for improved support of Apple hardware.
> +
> +	  If unsure, say Y if you have a Mac, Otherwise N.

	                                      otherwise N.


-- 
~Randy

