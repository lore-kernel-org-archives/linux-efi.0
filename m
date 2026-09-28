Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B6B4973BE
	for <linux-efi@vger.kernel.org>; Mon, 28 Sep 2026 10:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790590221; cv=none; b=HcrMsbnbyKWLWHO0WeQuQh8OOiV9YeESKTU7ZrZGiHsBepbVGSA+cl9kGzpajyys1FOM5bzfQncncUaLI3janiz3iF3xjrYFZYZSihpM6FDNcSY8EjY3AvGk6/M2tbcQvQkPsGXK288NNGimoSCxKIGMXtL1cjgibFwyiCTPMYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790590221; c=relaxed/simple;
	bh=txQ4KpuyJ7cs2vkk03a5vTTrtEUv5gVDltpopjXfHWc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Yb6lovtPqPCpUdvaQyl2hJDafLCo5/Pnn+F8Z8CvG6LwB22494aDqIEjnzAU5gF0FJqZ8V4zuJP/C2ebCBFdVu7bFwoivylqEjYoGjmFAraoNvc6UBscJvJGuqlSdyz3K7n76QNbWXmDlyIlBSqsslEboaZt2+Rz/lIiOcTRAiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ys0tWLWY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ys0tWLWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AC61F00893;
	Mon, 28 Sep 2026 10:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790590219;
	bh=txQ4KpuyJ7cs2vkk03a5vTTrtEUv5gVDltpopjXfHWc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Ys0tWLWY3v+ZQK28QG1pyHpAASLTw4aTWdLSkYQQFp63snezKRjWRWgymjkKv0YH+
	 mKJNFE2m/GTa32PiDKF9Fsxdwtv0QM2PtYymR2yNO+Ck+qzctZbQQWQhx4puoe7t7U
	 0T7/AR9YHS5t9fHxbqbqT7vtCYtXojQm66jXr3j+sNxPcdxJc5ugKL4L9V7opy8Y3D
	 764O5jY27T7taJpc8dugPxeCJ56lwk8IQZ3hDJrALkCCQFfu+Hl0Bb7A0fxV/oC4Su
	 S5HuLjNdLjFa5feSLC8ajxJt0hB2ASTv8z5qphaJd5TxB8Pq37GpEQ88kPtr+JV1Wr
	 Xt8mLpznvsPuw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 39566198004A;
	Mon, 28 Sep 2026 06:10:17 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 28 Sep 2026 06:10:17 -0400
X-ME-Sender: <xms:Bz26aloCG07u0U2myyaiNVhlzldhZEgSyEPmtjtA3bopu0UGB5Y4vQ>
    <xme:Bz26aiewI5iXGQvRRKIlms32ZgQ0OfDd1YUHiRbLi036iTWno-iX0pFc2wZsKN7Qq
    34ueYk_UUyf-0J7hChPlScO6fkVUiMqujFRz-Tbqsm1bpUOYvNVnZZ->
X-ME-Proxy-Cause: dmFkZTFWUO2MCgJ6y1ADJckI3qL7si/effMEkeNnaAKyB9B2DsqpuLQySpWC/xF1iJ3glJ
    SUam2bgDErxbIuvO7+XRIrYLYMwidztoDz5PU+B+uGPhuR8zJVmQqpHPvKhP99UMT5fA38
    0Ayu/jKm8+MPoz9cXpw1JcfW6l1L6D4tw0OVa1VZ5t/3MBM/k6/duU541d2zmgIeI6buVI
    n2yEEVp3V33dF0MeLdZXrkSMhypcNDHehf1ZW0s9TLaQp2Be2s2AtTCbmDsO+GiDop7zrR
    cVHa98L8lav/8IXbjBuYMPzFs+whl3ndFtgVhat4JA1up2w5dn9rZ9qSYSawCiPMAjLzWI
    hoaCU22aKoMEngDvlOyr3mOatFaj0U7HP36IzXdFrGFaVN/g8aT3IRwaaz1oxfDTI+HsfI
    0UxNK2PGMx2ilNCmukx4CX1CtFhShRfOzOXkvN4Xw/i41BxVRyjmka/QdDtqtWwBXFwRmv
    Sn6UuxvRgfcE4R7R21e4jHWcqIq6Sb3KuOqlMPAHZP5xhaUJ/ms4YYkUBRrWVrS9ABKjpW
    M/fyRSSJFmgMAzrAfuLreQomc0E0xFEy7qeVZFWhLtuFqFoXRM/fyaiogMRdfSkvqBYj+E
    vUGJ2gZfeppP48MIfGNP4ZrY+FTSUG94/X6uZb04U9BzK5agM5XjSBC2LZrA
X-ME-Proxy: <xmx:CT26ajSEJa3sXkqrXTb-RVdlYUcbUlR6ug3e25wzSAdyrua0egKX5w>
    <xmx:CT26au1h_bf-JEW-B8PUX2vPt_k_wjopoGWFC8FAS7M_aTB32jATOw>
    <xmx:CT26aov7Mz03Y7yeHt_drQh9GRojb76OnEK8OMk7JeNfUdzAtnlEnQ>
    <xmx:CT26akj3rb-m31mi0o6OpYY0CCsD7hfAhG6sHkW6L1aobOUr459OYQ>
    <xmx:CT26ap-3KeMJagQrnnBKf15aibtmS89xUZRs2hKxGAchTN0qyZrBwMis>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 439EDF80080; Mon, 28 Sep 2026 06:10:15 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 28 Sep 2026 12:09:55 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Vincent Mailhol" <mailhol@kernel.org>, "Borislav Petkov" <bp@alien8.de>
Cc: "Kiryl Shutsemau" <kirill@shutemov.name>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
Message-Id: <08f0833e-12fb-4d74-9d0b-beda435f7e65@app.fastmail.com>
In-Reply-To: 
 <CAMZ6RqJCMt3zoDQ2iWXWJvxSifB0cV20FayX=yxoG30QdJ8aQA@mail.gmail.com>
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com>
 <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
 <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com>
 <aqKrhNQ3mZMs5-Dy@thinkstation>
 <b24b9785-b790-476d-985d-e8c5405d192b@app.fastmail.com>
 <20260912061005.GDaqTsveevVkzxRJoI@fat_crate.local>
 <b259aff1-1fb1-4819-88ca-9b47dac036cd@app.fastmail.com>
 <20260912175410.GAaqWRwnz7bHUtXYSs@fat_crate.local>
 <862d50e1-2072-407b-882d-5e3074a3c225@app.fastmail.com>
 <20260913181105.GAaqbnOUDX2YNFW8iQ@fat_crate.local>
 <CAMZ6RqJCMt3zoDQ2iWXWJvxSifB0cV20FayX=yxoG30QdJ8aQA@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of panic()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 28 Sep 2026, at 11:44, Vincent Mailhol wrote:
> Hi Borislav,
>
> On Sun. 13 Sept. 2026 at 20:11, Borislav Petkov <bp@alien8.de> wrote:
>> On Sun, Sep 13, 2026 at 06:35:33PM +0200, Ard Biesheuvel wrote:
>> > The reason I want to get rid of panic() is because snprintf() is going
>> > to be removed from the EFI stub.
>>
>> Ok, I'll queue it into x86/boot and give you an immutable tag it doesn't look
>> like something urgent to me.
>
> I had a look at tip/x86/boot but could not find this patch yet, nor an
> immutable tag containing it.
>
> Just checking whether it is still queued on your side, thanks!
>
>
> And, by the way:
>
> Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
>

Thanks.

Latest is here:
https://lore.kernel.org/linux-efi/20260925075137.44298-5-ardb@kernel.org/


