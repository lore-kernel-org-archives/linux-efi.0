Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780E24BA9E7
	for <linux-efi@vger.kernel.org>; Thu,  3 Sep 2026 14:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788445853; cv=none; b=lI766FLTMHPwH7oJk7S6MLLWe+BQR8GKU697KuLoOissCcW/mDAltBvy5ilRBn8GUmC7shz/LZob/Jy6sBrIiY2SsJj20N5q0s00u9VWZZY3jw8oGEulmSlsxsM0MAfInfntOW/6SAixaS+3OgfROt/Q4tskEVPyx6ulIB1XeZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788445853; c=relaxed/simple;
	bh=4RmvyYzsnNP3pW0btebvjEbTtN5cAxfs/47s7tajBZo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=i9zgdq/m2MOmHh5PgT1TAmQJqDuGPN6W5R0x+nER4a2mCRWdd7rdt4RngTsUUu0sdPAKpx3UKyH2rSzYZd/juDGtSHku2DQkOZIAFvBwECGM1tcVIWHZGczV7B1p2EweMisE+tzuRMWkWA6eYqPKR2+Z46gp9qVVtdSZxaOicQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4El62E2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4El62E2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BC61F00AC4;
	Thu,  3 Sep 2026 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788445847;
	bh=yr9VEKF3amJuy7pbkO0vq+lPvoLFNuFDsi5DRMmpSVk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=c4El62E2uNuqjnfuo77sgR+QUkmrq2a/P8WBso+WUW1nU9B4SSmaU56Gnz8FfGD7E
	 BJ5RqwSZQFFdrZ/RtkG+cbQ18sGQKuWPhtuFUQGx81dIHYgByV3FLlGQg0fb4HEDp2
	 695wujgm4csUFRi+CwJ6IO4MKq6s6fwS+aMPldz7JTEHpaeEDkhDAj1Ff4e9NQ+BOQ
	 4M5/0f+1cmAvuf0uL17w39Bo/+Ej05dPO3M7WQBEkr5WOeLHico5nc8xpXQK6Rlzu4
	 057WswzWVcfsb78YnMpxtMa13omdybgOCtB/xUYid5qOrx2Ty1BK/qLYfl9pLVBotD
	 5GJGo8wYJ4bHQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id E56C8198003A;
	Thu,  3 Sep 2026 10:30:45 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 03 Sep 2026 10:30:45 -0400
X-ME-Sender: <xms:lISZauISCXxwrlqf-LS7Vb-pfts7YmSieSMzZV0RdrpJD_y0UaUmhQ>
    <xme:lISZag_qujYKPkEGitu10YBR6FNfMRjypHW6vCmsZLsTfvb0rOQCDPeJOrm2fVEQg
    Jn3KBGT0644MaYyx-lKzisaODxE4kwsIcg9lb_yV0jTv28xCuiA6yZgTg>
X-ME-Proxy-Cause: dmFkZTGqH/m0k0GH0fPGqch2QPbBB9gnBhhGEEYIr/OjFY0atwaSaAzTSkP9nFUNronmya
    GKw8Em9qcH3YggllhOgeGV//fscvhyXTLTswaEffnsT7/WNKNJeYRQWCpU6rK5aA3KqkST
    9DRFLEHj+x4B5ZlClyjO2SYNV7cAvtHG9o+Gp1yVACxy/tOpQirFO47wSr9Azs888WkO+Q
    2i2U57utOQEXhrKVJG3b+u4gNzAz/N8csFhR3xB8xWsA7Itt22PdLObEAKy7ymN+gCWOUI
    YqmE5Vd5Ih1dz/NEA72uEvDX930T561WmoLhw496YLiRK3YAEXojcluiuUoszKGstBzkbp
    ROqoeCOmCW4VuRxRaveuqwEnU52AVCPSyExe5hXB90qnCTkmvTd5AC+ze3wX/NBXaDgklk
    u753b+eek8NVP6Dm1U2O3XjPPGKPC5LAfqHyQdqUJ3H+34OgX4zDkRZ9zaZpwjuKVoNlgo
    6J3QyqOwEtKiiO4NYbSy9HlBoEeLemyvlnfRT+B7RIXBorsiRYDpUk9LbLL7ZPaLAsCn7c
    TOxKrvK4LXBaMwZi1FR5MsdvB76y4xUuM1euEPe8pjqzTwk4aSryanSRLO9ee9LqqwSiOy
    y8Q2n9EyGIDvL3K6UlBLeV8wZPYDZsnQpYbbEdKuYETxHh9qDktp+tosar1Q
X-ME-Proxy: <xmx:lYSZalLnYrfEPaTP4eGZMK7p5Q-LhHJJuANgG5JnzeJ5iid0iUqEbw>
    <xmx:lYSZasFIuNvprPc387mhRfUmdP5Li3ukrhjCnLUuRdqDfgJ9qdwQrw>
    <xmx:lYSZasvWyJya8mH8lUy-A1D1g-tOXC4cfF1M1BHfg10JSogCSqTYow>
    <xmx:lYSZarvabz6o_JfGvSDFcBaBafR4Qg0BBiuv9Q_PYdvRbIiAsgFkjQ>
    <xmx:lYSZaqD_y834MkBRdsIyrAf89uTYtyZAaRv6cJFXNG8VuvINW3H9R4O3>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 9E24DF8007B; Thu,  3 Sep 2026 10:30:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 03 Sep 2026 16:30:24 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Breno Leitao" <leitao@debian.org>,
 "sami.mujawar@arm.com" <Sami.Mujawar@arm.com>
Message-Id: <23ce2fb0-1002-409f-bb84-f592db9d0b89@app.fastmail.com>
In-Reply-To: <44097058-9fdc-4e9f-a277-d63e3876b035@app.fastmail.com>
References: <20260903113238.2291844-1-yeoreum.yun@arm.com>
 <960e985e-b338-4648-a29b-1f8a31e00599@app.fastmail.com>
 <apl_29t7Jxr2mv9C@e129823.arm.com>
 <44097058-9fdc-4e9f-a277-d63e3876b035@app.fastmail.com>
Subject: Re: [PATCH] firmware: efi: add a separate timeout for UpdateCapsule()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 3 Sep 2026, at 16:29, Ard Biesheuvel wrote:
> On Thu, 3 Sep 2026, at 16:10, Yeoreum Yun wrote:
>> Hi Ard,
>>
>>> Hello Yeoreum Yun,
>>> 
>>> On Thu, 3 Sep 2026, at 13:32, Yeoreum Yun wrote:
>>> > On platforms that allows to update firmware in runtime, UpdateCapsule()
>>> > may immediately write a firmware image to persistent storage.
>>> > This operation can take longer than EFI_RTS_TIMEOUT.
>>> >
>>> > Use a separate timeout for the UpdateCapsule() runtime service. By
>>> > default, wait indefinitely to avoid interrupting an ongoing firmware
>>> > update. Administrators may configure an appropriate timeout, in seconds,
>>> > through /sys/firmware/efi/capsule_update_timeout.
>>> >
>>> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>> > ---
>>> >  drivers/firmware/efi/efi.c              | 41 +++++++++++++++++++++++++
>>> >  drivers/firmware/efi/runtime-wrappers.c | 14 +++------
>>> >  include/linux/efi.h                     | 10 ++++++
>>> >  3 files changed, 55 insertions(+), 10 deletions(-)
>>> >
>>> 
>>> Given that UpdateCapsule() is rarely used these days at runtime, I
>>> wonder if we should just call it synchronously instead of via the
>>> EFI workqueue.
>>> 
>>> I assume that would also solve the timeout issue?
>>
>> Might be. But it would make *non-preemptible* for UpdateCapsule().
>> AFAIK the purpose of running runtime service with efi_queue to
>> run it in indepdent context and to be preemtible in case of arm64.
>>
>
> No.
>
>> Since most of UpdateCapsule() will be called via capsule-loader's misc
>> device, if UpdateCaspule() is called synchronously, It would be
>> non-preemtible in arm64 platform.
>>
>> But, some platform could be preemptible while updating firmware so
>> I think it would be better that it would be called via EFI workqueue.
>>
>
> EFI runtime service invocations are preemptible on arm64, so this is
> not a problem.

Ah wait - you're right, they are only preemptible when invoked from the
work queue.

