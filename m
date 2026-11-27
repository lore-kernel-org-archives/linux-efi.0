Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795820458;
	b=N6PP0+ZCombNK/Eb411HQt6g7vo6Knn5eXAiyEE96xm+CTb6XdckZ5AgJvxn7KN+y9lI
	 k23pkH662NNrHOl1WgwQcjMU3ZIkEHte2ZTx7OEzXxaK55zAQWVFEZ1KY6YTNt75R6cv/
	 xhfOakkxl6Vp2STr2PVuXxXiWyjN89mP8+p5aLpmAoEfTqZ3qlJXaja4dgfR4XFGmOZ1H
	 JzTfkRXcuKecHlyOo7kQuP3RzQxPhl9QP0rPjJ8knhTVvfzo9M22920ZwlVqccSENiaNS
	 c3pdl5oIdtO1Amaj853heElmTfXAt5JuknmMVEUhkzlX10I6KJGismdnvZojx/OtGQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795820458;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=BPbTyAzEzHxCDiGG/3X2Fo2RppnXecaVt/UO+C5djGs=;
	b=myS6Om4rIo2Wc+i5EMPTzfmIY9lZcd0j7vQRYUWbSJedt4Iw2CXqY3g7ieV7XRXn6TNy
	 THquoOzPtRyG0ejpG8PfP+dbF8no0wVC4TpXnRs66tMK+z67oGSLEQCVePMJ11mtjaMtU
	 b1FW59nZqJ0cERNqBoeL9JszkYAal4hMisrSPsWjS4CGF4o1M4KGYQnqW8Abvck05vV5C
	 4IR6OUM4Ai5VnPG+t41o1ujLj4XIBPEfSR1KH6QliYyulLiDq38OrEZbFoYo4C/uxwUeG
	 oCqwIGdy8OmAyBVbvA38rfLRtY4NoLa7bsx6QPws3t2UPxUiXM4LJse8f7GsPQLOhQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dXozzMR6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D51606A31C
	for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 23:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dXozzMR6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36ED1F00898;
	Fri, 27 Nov 2026 23:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795820457;
	bh=BPbTyAzEzHxCDiGG/3X2Fo2RppnXecaVt/UO+C5djGs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=dXozzMR6DQIYCcRANZ8aGR4FABdPfSHFNGuZJ9A2GuClP3XIu63uIgYrCZX1I+y7t
	 BOWs3/lih6yzg1JGlOIzxtVL/RFJhNVEq5t8rsDBSjfPXYg82hPWjU4HEM1DGV1SqQ
	 iCsEKHX5zv/llycivXU2LbENXopOZeyezHJxpROz1wWZzORjY21YVs2sm4UI0STD5u
	 e4ODWdFCz77EqmgF1v3Pnr2gdqCxlMoPhnjeg6WzXFTRX0MmL+0mGhiZt/uJxEMzoJ
	 MY8w5BYwLAEPmsk+KyA+xAZoxnQ/Hp6f1yENWL1WT6nlrBQGZDs4yDbcB8mEbGqjQE
	 HOEkAH+0Q7/qw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 081F7198006B;
	Fri, 27 Nov 2026 18:00:55 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 27 Nov 2026 18:00:55 -0500
X-ME-Sender: <xms:pQsKa4So9z-ks4gOz-NaqFCrfSn8dwbNHdrdXtvltqCnbVVzwEGyhw>
    <xme:pQsKawksGGv2TzrodgJBBfxvE25D6kFRdb5e5-zgjuntR8C2nJ3sK09Kr3nPjDbsP
    alH4LEM-pir45PBjBDRoTQDa-Rl90BGP2_ElMdavhipZk5WMyr0xcmtvg>
X-ME-Proxy-Cause: dmFkZTE4L2vK7tD/P1jrTgLLmvzgDWNNWIbLo6u62gWBmILXHnkOfUyAj83dsJ8MlK1IHy
    pRoYBWPPbL9hycFP3ABDeDnR6RIynu+t56XlWW/3hbXorW9amskvUbUiHkEDXaXPnPWv6X
    KxnsZaHoBzKCBkuFRPRrmnLcRLbC8/QgKdQKUiSLDLnamrHGYyvzLhraPy+YUz0JcKqyeu
    aeUuHNb4rDHF7L/phY+xwETq7Lm5OMGuoBP7Q8Ne9XTXVBVrTXNWDEI/+3NvGw1luAa1zw
    LfddLudV9HCOAUQLg3JM6xtvR7sYpHqhnrWHbfdPw4C6X0aWhq/2Iajk0xu6xot2rFFcCz
    MDgS7z1eqB+3BzqVA2f5fepoV6FSNCw6UcGqoEJmX3PVk84MX+cXMruhVtSrCQhokvyOsx
    qj1yXyKuEKCE2LKPUcx1MfEM5sifZZER3EA0tURfnGoRtoitLHzaVKyTIyNiLQk7VqWmQM
    StCs2baOiQ4NfOEppejV1XM5Y+3uA/+Ml6GaOobAFh/OQf7QhEStvqrXYCMjXy3PR0+kPQ
    71LSmpyCTpF7ePQ8CwxQ3odW/voT2nAcxlcMFX1qtu3iL9DSyEj66lhV25cYkOLSqK/MRk
    Laq6rl+PiRlsUnf4nYm9mFjT8mGUHcD23hHMFW59f6UIub47TZB0ldI0hNCQ
X-ME-Proxy: <xmx:pgsKa3Wke3591CzgyRXqePlj3QO1jDek4nt1OH24bHucpP0_gP8MSA>
    <xmx:pwsKaxFO44cXCwTIhjbuaK1VgqQCn9yT0RTSCpPv4OVohMdjzFYdIg>
    <xmx:pwsKazdArf5GSkFacHexCt8UWsqKfyBAhlCqQzO3uuhOFiatVVETJA>
    <xmx:pwsKayIbJgDBtrnaXMgF-Onlf9JPSiAmKDUeylFYT5P3wthocElI5w>
    <xmx:pwsKa4FhKyJgknSz5NHyr02-AjFCuYfkC_UkuDmRwefnA96AWfSlBtUl>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 75759F80093; Fri, 27 Nov 2026 18:00:53 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: A-OdZpdhPtTw
Date: Sat, 28 Nov 2026 00:00:33 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, "Kees Cook" <kees@kernel.org>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Message-Id: <fec0a391-08d2-4b2b-bd2f-c56a39825b80@app.fastmail.com>
In-Reply-To: <ac3f8708-a3f3-cf99-15c8-e94c3fe7942e@igalia.com>
References: <20261124172811.2580784-7-ardb+git@google.com>
 <ac3f8708-a3f3-cf99-15c8-e94c3fe7942e@igalia.com>
Subject: Re: [PATCH v2 0/5] efi: Fix pstore runtime en/disable
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 27 Nov 2026, at 23:08, Guilherme G. Piccoli wrote:
> On 24/11/2026 14:28, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>> 
>> Fix buggy use of /sys/mode/efi-pstore/params to control the module at
>> runtime
>
>
> Hi Ard, thanks a lot for looking into this issue.
>
> I've tested the patches on top of 7.4-rc4 and they're working fine / as
> expected. Tested the full matrix: pstore_disable={N,Y} X module/built-in.
>
> Feel free to add my:
>
> Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
>
> to the whole series.
> Cheers,
>
> Guilherme
>

Excellent! I'll get this queued up.
