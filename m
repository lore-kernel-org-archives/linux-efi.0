Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795817299;
	b=f56I02UVwyzsrIpJsZIgsh4/rOjvthNWQqBKIN5Vx4WpNmqJ5eIdNyHteDfMeJSchzO9
	 H+l0Mj9JG1WEl2Nc9SAiBrFGDlE3rwhi9BpXeM3pU+9qEu8F5J4454Wv2k6ZZpTHvifsA
	 I5sWst2WcYLddiLm5fhWKixmWxMkU3Yl9zmY4+Sn1Vr/S+b8OtXVpA+eBLRJuE1yJLLzb
	 3IMfq8RcZoSiPfAv7QffaSQJ5Tpsqj+gzfd/ca9xcz4rXyc5Od3eKTUX5naHVeo5O/5YH
	 IMgQJQEMDgVBKH0njUIM19RDscHZQ7k+rgro0tgPlYh8MT5tcNMiAoMA8XnaX1XQmkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795817299;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=3G6m7ByTWxI59APa6EkwDFXHL/o2v01624m0ZAkBz+g=;
	b=ANZnCAbVhEtz5RE9QyW3aHjRsRkwjfCeI1obv3N8hy0H9UYI6nx5dYfAVY+jd8iycU/w
	 HcEwojILPpfDhy9nbJw5LHrjZuVgxu2lhRn9BIKDZlOIoYJ+cK0AZlJTpnrj2zmeHLiXD
	 6yS9/PPYqqrKY4mDt0XNTxXyabSvrRm7A/EZZBpVlC3OaF2I2pWTVg+7zA3UaDh514ACh
	 JIoy421Q0ANc40GQvQb9kneQoQl+vKcIwicW59yX6nFAzBsSCwvboKHcjdnXeMo+KVlmj
	 GqzHn6mrgETwZCMV9M9b7VMB1bgOAWEV1GF2K1miLcCXH3UPEExqWpkhyQ/61TKXe9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=PAlwiYUJ;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C514606A31C
	for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 22:08:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C514606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=PAlwiYUJ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:From:Cc:To:Subject:
	MIME-Version:Date:Message-ID:From:Reply-To;
	bh=3G6m7ByTWxI59APa6EkwDFXHL/o2v01624m0ZAkBz+g=; t=1795817297; x=2111177297; 
	b=PAlwiYUJr9MhIHJtaIww6iHWbLM+UCBG5S4pw6h1RjySiazy7uv97bb/qPvweC7gHkP03zYOSIg
	hX1WsA1bzBn9hRcygcIIsLK+vVfgEyV9Ms8OYdr6LOi/uejWznc0amsrDwqx5LeYYwf/bThikcZYC
	9hXBZOQa+Q83SZaqSg9y7re6a1EwpNLRsiYv/UL6GFQKw91C1VtocNu+gTeOq3BO5H2cxfDAosG9d
	f7xZldmpdM8c6nA2URSIwX7+hFi4yQ+TLYlaz7UT2yGzcik3SQ7UCMVx2sDL+TrPiVQ+dgQQm3y7D
	362g9wDkn+YKxvFq44iLpg/sHKR/bieHsVNA==;
Received: from [177.189.74.140] (helo=[192.168.15.3])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1xX46y-00000004x71-42JQ;
	Fri, 27 Nov 2026 23:08:09 +0100
Message-ID: <ac3f8708-a3f3-cf99-15c8-e94c3fe7942e@igalia.com>
Date: Fri, 27 Nov 2026 19:08:03 -0300
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 0/5] efi: Fix pstore runtime en/disable
To: Ard Biesheuvel <ardb+git@google.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, Kees Cook <kees@kernel.org>,
 =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@baylibre.com>
References: <20261124172811.2580784-7-ardb+git@google.com>
Content-Language: en-US
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20261124172811.2580784-7-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/11/2026 14:28, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Fix buggy use of /sys/mode/efi-pstore/params to control the module at
> runtime


Hi Ard, thanks a lot for looking into this issue.

I've tested the patches on top of 7.4-rc4 and they're working fine / as
expected. Tested the full matrix: pstore_disable={N,Y} X module/built-in.

Feel free to add my:

Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

to the whole series.
Cheers,

Guilherme


P.S. Thanks Uwe for the review!
