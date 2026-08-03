Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3B5434E30
	for <linux-efi@vger.kernel.org>; Mon,  3 Aug 2026 18:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785782872; cv=none; b=rf5UwO+0XV3c89PXRrqRTowTpJa0zt+tUggO0PM7F+sijgLvsJ1k6vySgz4juwmQKgmjhKfpgf1ReD5XMC0q1tgsdK9utzBt8c1U+lixw4PPnBNaX0ewu/AmSbuggxAxICfqpNwnlSoOu+1dCDF7gXCNwtf0cpgNpdEF2gG7F88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785782872; c=relaxed/simple;
	bh=WPQyGfb63Bekyh3yVKQi8GyrOE/HBTKAetArbg7zeuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m7Wu6kawuTZil/UUmLQ51M3aXmS2Ie+La2JLfDWN/mU3bAg44UWCu9P7acCFTdokamdGQqpMGiuAwZx1IXSt5BuT2DDiRQ3d3xOnMJVyrk/AFWjj42lY50KMXaHJQ2dYKXIJE03xFXL+SkifZpZtZ/1tKAwwPvboxsN2DG9Mz3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T5kwyX+1; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5kwyX+1"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f84023916so3700455f8f.3
        for <linux-efi@vger.kernel.org>; Mon, 03 Aug 2026 11:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785782869; x=1786387669; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1nlAxRhk4xKY8oaGvci9bYtVTMxPXDjgswhVEfq9D3o=;
        b=T5kwyX+14hG3vJ/5jCXCIl/V78nIaRYhuKYfYWtE9EBZIYRC0ZAw/q1TO+9lWRFYqh
         SiOVGbzEDfXZaS4GmGLFx/yNfhsZtdIvEGOMBgD7WEEjML2RykE6BUbtKPtFXz+y8MYD
         12dodJlTauj3VzS+jchLUgpekz/5NC3PG+B7hPBBZotmSE4dF5lSRR8meajDx0FroUsK
         6gD5IyuvnQnwGAZDKNybTv+CIYsSiNNltS5D+aD/mYNIba/uaiSivHPf2V2tMvGouwBa
         4hy4FGTcfAqZDPTxP09ztpRUJplwfGsa/MYNlFMQzdrVCQyyDIjp8RN7memDUt6K7W1A
         Tg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785782869; x=1786387669;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1nlAxRhk4xKY8oaGvci9bYtVTMxPXDjgswhVEfq9D3o=;
        b=V/dBAWRwHwR2y4RDSWed9wzjmWiuSOJp/dVxBR17CMKWnFzsoJpZxvSUItscTzGPSN
         WqEmoMycFOGcB7wokPOZGGZVyk7L9Ah5mbVwT7uTtgjy8IeUQXmMarndMjX7ia0B20GT
         rVlOFYsoNjRyrjg29PYSpteePyh4rbQdH3DGxbSntSB5N/qg3TQE5+kOwRD9QVGpzo3m
         3NSnczLNGCkiJblIbfHZGz1+ugQwcHIJ5nW38c8UJ/j8dFWOoSaCTluAAm7jzflTFwFz
         LrpvXHeJoGcSMurgmhPpmMjvlYW6/jY+1qdzu/zbDRv7V19FmXqW9CpvPL4hq9S/YMhv
         dUVg==
X-Forwarded-Encrypted: i=1; AHgh+RoyBHMlTgxormEuPnUJjEnXD/whpuVilPhC12fVtR/Jib33KbFmnbNE0FiDX3+8NqaNJmQIXpEISCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHz+8ffi3FQPf5Tc8BOoI5rEpZgrsWvK4GZqDSBPZIBMBWmg2X
	T0X4uRe/eRtIQxyLnFFS5QOaZIjgipUiG+myYzpFeLV7VnE5s8iEn+/UlqFwPNo9
X-Gm-Gg: AR+sD13lUHfwYtDBDhU0CRVOkcb8mXEUekf4/otSS7/OVCMTxTz1uHoAkriD8ikAuBk
	HRafppNCE1TQHAlyI36HiU8OnAg6MIa0qzhOgnZSz/lc9saPLU5MzK+0gnQh77TtoYJfu5++1Gv
	0oKmtI1RenL9Yr5fnrg51SPLZpcIhYf2fEfwPbA6e+FotcHCYQ7jDqp8bkE3muRavcKI7uscZBt
	+8U3acp5iSSX7GgK4JDHn0l09pIe2nU+Oqbi8dZDNVWxL6/QyN2BFruDQoSV8iqP6U3Yr3w3pMh
	OTQTOkXWK3pbf52TDtfXdqFXF/hfiO3vvIKIOQHyu1oTtIIl0XNaaDIbxEUniXQH0H0MXwZO6ns
	noxzCzpZB6pnqWOTfWjS6Hphvr9uFY7Deok6jOOswkdxaqujtsz//owseb1ikVfdcFEeGPrnyWJ
	x0MWoBWDkbBqT/6fA9vIB1EN+UmfBgXBlzbbj4AEEZFp23GhbVyJE9SiGA3Sr1VVL1ovX3g4XYr
	/PhYSnUTqg3gbM4G8bPWBFQGg/ocr2sDoURJk+MIs21FBvTP+wdOsJ0HAxM9xUeE9e86F2wvA7p
	fb3B8ARbTwlzEYEwU2x2pBBQxK3XNFC5AjBqWykvEk9ZUhvLHM5Nkh0x3lC7rTVGeQ==
X-Received: by 2002:a05:6000:25f4:b0:47f:8f8f:db74 with SMTP id ffacd0b85a97d-47fd72bba4fmr29878393f8f.12.1785782868524;
        Mon, 03 Aug 2026 11:47:48 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-b3d4-c101-2c67-9805-4069-c4eb.310.pool.telefonica.de. [2a02:3100:b3d4:c101:2c67:9805:4069:c4eb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41cfde0sm33136363f8f.3.2026.08.03.11.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 11:47:48 -0700 (PDT)
Date: Mon, 3 Aug 2026 20:47:47 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, 
	Russell King <linux@armlinux.org.uk>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, Dan Williams <djbw@kernel.org>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, linux-kernel@vger.kernel.org, 
	Kevin Cernekee <cernekee@gmail.com>, Gregory Fong <gregory.0xf0@gmail.com>
Subject: Re: [PATCH v3] ARM: set !LPAE MAX_PHYSMEM_BITS to 32 and remove
 supersection mappings
Message-ID: <anDh-ltx0AFUP3cM@gmail.com>
References: <20260725133122.2723-1-kmehltretter@gmail.com>
 <9f7fb591-3d56-4354-afa6-8d1fdf5a038f@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f7fb591-3d56-4354-afa6-8d1fdf5a038f@app.fastmail.com>

On Sun, Jul 26, 2026 at 10:03:16PM +0100, Arnd Bergmann wrote:
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> 
> Let's give others a few more workdays to comment, if nobody
> has any concerns please add this to Russell's patch tracker
> at https://www.arm.linux.org.uk/developer/patches/info.php
> 

I've added it now:

https://www.armlinux.org.uk/developer/patches/viewpatch.php?id=9486/1

Thanks,
Karl
