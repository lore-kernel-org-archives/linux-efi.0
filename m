Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022846;
	b=i562sN60nfGBcUa8OFIGGLhFOrb4QP7km6cbNBRddo9W8SeL8uqmLEYxD9r5/mTjvVht
	 OyxQnCelowjPhreVzzu62qEQYMIGbORqjbXV06ocFfY2bcNLY/XrnwBYLE430FndfqA71
	 pjofUmQEEFL74w1agt99NozE4bUDl+RDszoBT7zNMMryleH9bcWQ/B6GIhSb3v5L12IXC
	 wM2cZrsnnY/gtbc3Y1r/OvZkxp3Jf42o6/sPfw1o45vDIpjs5S+7yJvMAjr2Dzk8GWiI4
	 RjBV6PEQpOoxqiAb+ua+ORKaclrx6jPZ5YbOIjfO7n3bfoOaDVtUzBIDKTVxHTajN+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022846;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=acayD4eA9QXjK1btYfC0a6QQYYh1dspOe0k0FO3qiKE=;
	b=ODAPWcoQ994JB6joDQFnnSxRbOIE7n25lXNH3d8tfIIwt7gFn0aaEf0d7129MtxHFy+R
	 Z7ccwtwOoBZSzMxifNCy0YRuI9Dml2nbFBHLkZyXM9jM0qCLPJ0Y2kLBWA6fFDhO0BKR1
	 FaxwHGl2eMBfVRb5XjY0TnezQ0jJMrPd7+m/x+CSBRS0hw4fJi2gIjJD678JawkNx8U7L
	 rxVS9EDol1d8oL0gho4Id4YcB/DKfoiIQm3N9AdoHHFS84m6TpwzkKuzROCsuPO24F4gZ
	 sTduU5u2oaswiJ0vV5MZD5/LR5G/Chu3vNDKN3qHLQyIdrkEwPpP7m+/0yMzvHw5q4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8uHZ8uA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC22606A754
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 17:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8uHZ8uA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6B81F000D4;
	Wed, 18 Nov 2026 17:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022846;
	bh=acayD4eA9QXjK1btYfC0a6QQYYh1dspOe0k0FO3qiKE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=C8uHZ8uAUw824fLRd7K7/rfchN8t6tKdMtOjQub5qpvwwQaPljmBHtPj3Yh34Cg+E
	 iAYnL24FylaTm/RJggi08Hte+7SaWthQ8Fnn00qhUp4GmVt32rmhFrLeV/k2Vf2DK1
	 FfCPWoLcOfEULUTRj84/H6iSH392ZEEYI+fquwp5sF7l+TN0++aRCDqZ0hTXXnFBV5
	 D9MI1EFWxfXQ54Py2D/eH4gWMZdaduT9arZn89bXTyPRD64EVCA7gO3Ct6l+y8x4UM
	 o8XR7Hrf7Bm9e6IFx9djt7w4vhYu60w1VPmVHyjjaeYKf7FHd5eE5zmD3eyIwY+85p
	 a1WKqnhVhO3Hw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 12D541980066;
	Wed, 18 Nov 2026 12:27:24 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 18 Nov 2026 12:27:24 -0500
X-ME-Sender: <xms:-t_9avPPRruetExUby2EW5K3Px9CCq9870v_6jPvmrnXTFAemwufdg>
    <xme:-t_9akywjaWSTvKLt7sDyHQZW7OpOZkJxm6M2_Dfn7kkMvbvFN_Fbe4YdzuOK9wxk
    rvoJiO3MIwT7cVhNXM-jAjBAcqrptfPKD1nXf93BKMBajkK3dHeVZCF>
X-ME-Proxy-Cause: dmFkZTFAuYDLuiPadRyT58CtafKhETAH7m8A0s737VBf6FaFIqyDnrRV68dZG+P2aHINxh
    GV9Yt3gyHtOG6fJ0HHvcOFDe+iz6ttE4lgRmvGi9Wjtab6d2Pb8/S8ZLHZ/hb76A8koykN
    Q7LtI+0XJ+dX2AB+LBfhAgbKwZLklzZ31HJ/uSYZ00gSZ1Ns215xDkmjrRliuj2+TW+FSc
    IYdhHrgV0KLFGjdCeoP7l2rYN0U/nOt3ywN8L6FerKBXo3qUS8sni3g0YO4A6S07g1Y75J
    VYxk7lVBGWKfNCWFTST+UEvyH1VnsvdNc0ONd5EfieGpFu1qFctXaPPDD2vUwwzAE7D0O8
    DZKDyESH3cm9whQ5gkO1ZT0BER6GV/c5w8evVdGbcYwuLnxI/vonJY+QSAfXJNUgetRK+I
    HUQ6xRHjVYoeaN4AnJV7B0wkHJoF5iwmMg75wXI78GIoFRn7kGJY6E4deTjWcSGwRg6cB6
    cX2AygbQo2z2dkV9OJA1eVCkOqcC1MQDthfTsEVVqY0+3zPTKoq1K5Zj3ucLh5x+DZ7fiQ
    vOT5XyMm7PRQHQ/Ncirg16Q6Sz0i3GOx5nxtXyUYpiSU0CSZmaU5lX0Rp2VfmonCt/zMPD
    SLGIo76kWPSNuqympI22eyIUioOHPQ9Y/JWuTGQ4zuD5VuX8LusmbDUbzpuA
X-ME-Proxy: <xmx:_N_9ahYrszeB9iWm62ebWCkvU81ct2gjqmMteAspl0ZIwb5qE4xRVw>
    <xmx:_N_9ahV2Q4Afmmf3QE-4jFGy4-gC5TPYWRZ7UpGzXCrffdj8T40gZA>
    <xmx:_N_9avhsZaB8p5mH1LJ_pBINHRw7VPMWocJ6hI6EwpaMUwY6s3lWhg>
    <xmx:_N_9avt2J-etCkvIcR3bSrkRVo0XGMUBYOYeR54V8ZO_u12LLQ4ekA>
    <xmx:_N_9ao6F2oKHA_xSF-hap7QqpoCj2-ZVXZLY01cZIqhgKBMK7xRM_Dpk>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 96DCFF8008E; Wed, 18 Nov 2026 12:27:22 -0500 (EST)
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
Date: Wed, 18 Nov 2026 18:26:57 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "H . Peter Anvin" <hpa@zytor.com>, "Ard Biesheuvel" <ardb+git@google.com>,
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <16b3f916-41cf-4ad6-bd54-45384051d4dc@app.fastmail.com>
In-Reply-To: <5E2684EC-0F34-4008-B043-F912FA1AAE6C@zytor.com>
References: <20261111091843.3621782-2-ardb+git@google.com>
 <FD1A5979-1504-4A96-B26C-D89BD362170A@zytor.com>
 <3522588c-9d7a-454b-afe8-c16c6788265a@app.fastmail.com>
 <F6E708AE-0476-4E9A-A39D-3DF15E91EB80@zytor.com>
 <ab8628ec-9476-4f3c-80fc-b68556803002@app.fastmail.com>
 <5E2684EC-0F34-4008-B043-F912FA1AAE6C@zytor.com>
Subject: Re: [PATCH] x86: Make the 64-bit bzImage always physically relocatable
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 18 Nov 2026, at 18:04, H. Peter Anvin wrote:
> On November 18, 2026 8:55:11 AM PST, Ard Biesheuvel <ardb@kernel.org> wrote:
>>
>>
>>On Wed, 18 Nov 2026, at 17:29, H. Peter Anvin wrote:
>>> On November 18, 2026 8:18:44 AM PST, Ard Biesheuvel <ardb@kernel.org> wrote:
>>>>
>>>>
>>>>On Wed, 18 Nov 2026, at 16:51, H. Peter Anvin wrote:
>>>>> On November 11, 2026 1:18:44 AM PST, Ard Biesheuvel <ardb+git@google.com> wrote:
>>>>>>From: Ard Biesheuvel <ardb@kernel.org>
>>>>>>
>>>>>>On x86_64, the physical placement of the kernel is independent from its
>>>>>>mapping in the 'High Kernel Mapping' range. This means that even a
>>>>>>position dependent kernel built without boot-time relocation support can
>>>>>>run from any suitably aligned physical address, and there is no need to
>>>>>>make this behavior dependent on whether or not the kernel is virtually
>>>>>>relocatable.
>>>>>>
>>>>>>On i386, the situation is different, given that the physical and virtual
>>>>>>load offsets must be equal, and so only a relocatable kernel can be
>>>>>>loaded at a physical address that deviates from its build-time default.
>>>>>>
>>>>>>Clarify this in Kconfig and in the code, and advertise the 64-bit
>>>>>>bzImage as loadable at any physical offset regardless of whether
>>>>>>CONFIG_RELOCATABLE is set. In practice, this makes little difference,
>>>>>>given that it defaults to 'y' and is a prerequisite for EFI_STUB and
>>>>>>RANDOMIZE_BASE, but it will help with some future refactoring of the
>>>>>>relocation code.
>>>>>>
>>>>>>Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>>>>>---
>>>>>> arch/x86/Kconfig                   | 40 ++++++++++++++++++------------
>>>>>> arch/x86/boot/compressed/head_64.S |  4 ---
>>>>>> arch/x86/boot/compressed/misc.c    |  8 +++---
>>>>>> arch/x86/boot/header.S             |  8 ++----
>>>>>> 4 files changed, 29 insertions(+), 31 deletions(-)
>>>>>>
>>...
>>> I'm going to vote NAK on this one... I was already thinking that it 
>>> would mess up low-level debugging too much,
>>
>>How so? The last time I proposed this, you replied that you were
>>planning to do this yourself.
>>
>>https://lore.kernel.org/all/3f2e8d7c-6029-49ef-8e31-a3eb5efb385b@zytor.com/
>>
>
> If we are going to get rid of it, we should get rid of it properly as 
> in removing the conditional machinery,

Which conditional machinery is that? All the code that reasons about the
physical load address needs to stay, the only thing I am changing here
is that you can no longer disable it on x86_64, as there is no upside to
forcing the 64-bit kernel to run from a fixed physical address. This
means the EFI stub no longer needs to depend on CONFIG_RELOCATABLE
(which also controls the generation for relocation data for virtual
displacement) for x86_64.

The i386 situation is different, but I left that alone on purpose.
Would you prefer it if that always became relocatable as well?

> not use it as a backdoor for 
> doing something explicitly NAKed (forcing PIC compilation.)
>

I know PIC compilation is a sensitive subject for some people, but
would you mind not framing this as some backhanded action on my part?

Once I get to resending that series, you will have ample opportunity
to voice your concerns and suggest workloads that will prove that
it is infeasible. Or even provide one now so that I won't have to
bother resending it in the first place.

> What you are proposing is literally the exact opposite.

I don't think so, but I'm still not sure what you meant by "it 
would mess up low-level debugging too much", so maybe you could
clarify that?

