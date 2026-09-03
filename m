Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2E74B514E
	for <linux-efi@vger.kernel.org>; Thu,  3 Sep 2026 14:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788445822; cv=none; b=qpLUw2UaeQdwOsGKy8N+aQQ5QwIS+OljhZs1USoqzeEAZ9SWiksQFYWAqfyXZFg1j7W1qbu3zs9PA8wwFwS613gHddaFqrFzbOMbDLAnViPonlaEljhwZ1q8NTpqW2f1WJu2oKb9V+cb6DbO0elK2VrvBl4rTPKzwedjUqIr6U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788445822; c=relaxed/simple;
	bh=4hO8hUtX2xJorYiGl+3XVXDqBA51gYmQ9gvWT1y0sVk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=g3IcikHaUdvE9tUWcYDj4h/V3/M5g9O+BVwoia6tg4rfWOkfDs/KgmZXAEpaKGk7hZk559BFEA0vcJYp+lcSOXD+OM4ieqakD66D8drf32w7wmdFWrIxTFNO5216ZPQcYxOdkFPJUr8xKylv1sUEnXkAL8avHZOMhgJoPZyAAHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkp1B6q7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkp1B6q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3146E1F000E9;
	Thu,  3 Sep 2026 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788445809;
	bh=7tu2A/3vWDsQ7scHWgfJRM6wBRgv8cpTvpUa+LaqfH4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=lkp1B6q7TjBmBCvVWOgPd1yzB1dLBQYTcKJ9bIERvcPjHoj4BCtG3eSJoEHU1EQiu
	 nKud0B84aXgh357zBAstAuvD25ogs/NpUlcjMGh2W1u0fDuKgeB6OIY4HSx2tWkpzL
	 Pcf421ViyEHUIZcOAJd5Vqyzjs1S7/ME+RSINQPcAPr5Xuc/bh04sGR/b7u4qQg7R8
	 HgMH5CtfwRBaqmFy1Hqsz7wmyaDQvMv3jOKwofn5aZfDEKnIeZxxKD+nmxB8sWsD2s
	 R7xVYAet0evYW5yN6NaxCDHVUvFsNJoKd1/fZz0G1gnLK45Vt0MxNczw9ATodAPT/f
	 AaT/U4jg/+79w==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id BEA07198003A;
	Thu,  3 Sep 2026 10:30:07 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 03 Sep 2026 10:30:07 -0400
X-ME-Sender: <xms:boSZarffwKCpC5096WHIv-vnRmEZgM-vmrxymx39dH2sCbEHoh-MUg>
    <xme:boSZasB-YIVR7JQo7agQK3b2IjP8q4pjMXjcm3JJSggc65tmuHmWXP0xszSOJwLFC
    VDg9J7FtVyxXmBa78Y8eJPkFX9Ho--DVwlcYrEvF0AUmq1pvR8aPBc>
X-ME-Proxy-Cause: dmFkZTGB5zgUQ5bm7kkCZfRmN/PosY4xl9uEUviJX0Ilof6sjHdv/KjCpNDjcdJT4OkRZ/
    RP+Nb+UpfZYB79/y8jXpc18zBdj0rPQeeyiFmduc8aLdz29Czckph4Cz+nVK116y8LK64S
    D+aFQQUL2UIq8JNQya3j4XXpPc232hbMCtjtuJMyqXvkxAEFhcRYy0CGYSR2eyPNLo7onA
    rgOTMVlhNtYSR0lL9yiRzIKBEaqZNylJh7/VMGJTp/q0BsPkkYSJ8dBazX2R6vaUaDNK9q
    JS4QRI5Bd7wnuO7z1Tpdbbk0FxfRJ0GN2SvzbCeWmj5NFcWNS5D2torQeIXIkHEN6VMasU
    7lJ9iGS+fswuPhXLxZxVw0SyNpFq1RuOzHl2WRrwbhYVqugc4ygLq6FNiWcwaqyv10myAS
    zt1ZdWJjEWk3uS+eVehfq9DvZAoL2+crpCLrwaotP5e80CqhApH2qhtnKKhtFxouZ8yLJy
    vLwD2+rAl9laY2Q5eqLVzUHEFtizH2RwOEfvtRH55NLez0i0XARxwozOx2X7HaQB67ZRXU
    BQIVBplDB5BICXCWbO8WMvZYcBjxv6zzaidhscOhP7BmLpLbxkIEJMV2SpiCTrB+kZi7e+
    kSfumvwXjigM56eip+NcT+hX6xBLP5YE1jDc1EhGQLuZcTtWB+iylvPkuc4Q
X-ME-Proxy: <xmx:b4SZas9t8Qz7BNH3fCImaAQ5BJRO2r4CBQjsivlkys62HBhBNOZAwA>
    <xmx:b4SZavrZd7fWWTCR_RjRai-ZDJ-ie2v4FwUPxur1bwGbwVOHQ-zmTg>
    <xmx:b4SZahDiXpheKlor2K270HWUzLi9G8Z4osYg5slrHDKc_QxReskxfw>
    <xmx:b4SZahylDmXWrI6DVIiG8TVCn12yEBAwSum2zKPM3Im_E3ZocJR9Vg>
    <xmx:b4SZau1Qp5gLfzD-sW4WqS1wgfOaj5kVfIVHI77jVwqtqBrAEkF3OcZl>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 44731F8007B; Thu,  3 Sep 2026 10:30:06 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 03 Sep 2026 16:29:45 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Breno Leitao" <leitao@debian.org>,
 "sami.mujawar@arm.com" <Sami.Mujawar@arm.com>
Message-Id: <44097058-9fdc-4e9f-a277-d63e3876b035@app.fastmail.com>
In-Reply-To: <apl_29t7Jxr2mv9C@e129823.arm.com>
References: <20260903113238.2291844-1-yeoreum.yun@arm.com>
 <960e985e-b338-4648-a29b-1f8a31e00599@app.fastmail.com>
 <apl_29t7Jxr2mv9C@e129823.arm.com>
Subject: Re: [PATCH] firmware: efi: add a separate timeout for UpdateCapsule()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 3 Sep 2026, at 16:10, Yeoreum Yun wrote:
> Hi Ard,
>
>> Hello Yeoreum Yun,
>> 
>> On Thu, 3 Sep 2026, at 13:32, Yeoreum Yun wrote:
>> > On platforms that allows to update firmware in runtime, UpdateCapsule()
>> > may immediately write a firmware image to persistent storage.
>> > This operation can take longer than EFI_RTS_TIMEOUT.
>> >
>> > Use a separate timeout for the UpdateCapsule() runtime service. By
>> > default, wait indefinitely to avoid interrupting an ongoing firmware
>> > update. Administrators may configure an appropriate timeout, in seconds,
>> > through /sys/firmware/efi/capsule_update_timeout.
>> >
>> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>> > ---
>> >  drivers/firmware/efi/efi.c              | 41 +++++++++++++++++++++++++
>> >  drivers/firmware/efi/runtime-wrappers.c | 14 +++------
>> >  include/linux/efi.h                     | 10 ++++++
>> >  3 files changed, 55 insertions(+), 10 deletions(-)
>> >
>> 
>> Given that UpdateCapsule() is rarely used these days at runtime, I
>> wonder if we should just call it synchronously instead of via the
>> EFI workqueue.
>> 
>> I assume that would also solve the timeout issue?
>
> Might be. But it would make *non-preemptible* for UpdateCapsule().
> AFAIK the purpose of running runtime service with efi_queue to
> run it in indepdent context and to be preemtible in case of arm64.
>

No.

> Since most of UpdateCapsule() will be called via capsule-loader's misc
> device, if UpdateCaspule() is called synchronously, It would be
> non-preemtible in arm64 platform.
>
> But, some platform could be preemptible while updating firmware so
> I think it would be better that it would be called via EFI workqueue.
>

EFI runtime service invocations are preemptible on arm64, so this is
not a problem.

