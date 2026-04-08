Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EAD38C434;
	Wed,  8 Apr 2026 11:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649033; cv=none; b=PEqsYDCmGlxGRKZ/2s9EtUDgJQvK4UCOTBa/DgKWbPyRzOdvmPAE6tUnrsQr+/tOefK2CIj1Av5uxWZPKJVbtXSUKTbeVlGSGwtzS9WIxcAaSk7xsIMj+uxYhyMqAS3T0NFQ1eezTMKZj4hWE9Fl6wCTAX0+BlWR9e+aHszxHMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649033; c=relaxed/simple;
	bh=8fZDPM3xiCftkDHiJn5TV/jH0Spm1UGKJBtbZuNzyCs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=VuuS0f6Hs0gnk9aauwEfToc0P+HMbBbhCBUFAYCxdPj+jPjpsfVPLpPFW5izd9sNoDCR6HBp/7PSwExvgY1cZaxwvMa/qBsMVcoJxg3lC6m22MS4gu134IQnFFc3zRhcMAwGPi24C5e0DXcUg2A+/dpwJMgeYCf0mhgRtufWc0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OFpx77or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFpx77or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1B9C19424;
	Wed,  8 Apr 2026 11:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649033;
	bh=8fZDPM3xiCftkDHiJn5TV/jH0Spm1UGKJBtbZuNzyCs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=OFpx77ors7Pxe9MRBKwd/lyTM3pvQWAw/Fwj+EfynYkfkNg2UlOCeS8d6/4kgVxIT
	 9zrVATTkHEZYh4rKxMyPqpMBsp4vWiVCpJCbftKWQEtY13chhEshM9gbAddvr81Fs7
	 yxuRNP8TTudXP3zMuwM9ars54QZ48wVStzKp8KvLDjIJEwaANEB7HZvK2ROccq7AF+
	 CDc+41zSKzNVnyyQ1FBYh/vTxEwy7RFihXSSPnCjtBm9Lw9j1Fj9czXqhKMHKt9dFW
	 q5883bq107gt3wV6Uy3+ZjYgtwYALAk6gdgBApkpOqEvT0eOr2H6bhYlOFfB5DU4Y4
	 CyPEVQx4KnFHQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id D913AF4007C;
	Wed,  8 Apr 2026 07:50:31 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 08 Apr 2026 07:50:31 -0400
X-ME-Sender: <xms:B0HWaZ9JGTWB1vMrUx8_LpaJLSTmewY1NaB5Pki2wo6cmXCsAGYBMA>
    <xme:B0HWaYgGDPAx_SzVeBDw2uBc4j-5gDREjnHoZ3LuWvTGdUNYE44h2j3l2MyRXdefe
    TGyL_0YADLYSDn9Va9JK5UBF9eGC9zFNUe9fjlJmr5QHKusGbIdt9o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvfeeglecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertd
    ertddtnecuhfhrohhmpedftehrugcuuehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgv
    rhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpedvueehiedtvedtleekuddutefgff
    dtleetfeetveejveejieehfefhjeeijeefudenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegrrhguodhmvghsmhhtphgruhhthhhpvghrshhonh
    grlhhithihqdduieejtdehtddtjeelqdeffedvudeigeduhedqrghruggspeepkhgvrhhn
    vghlrdhorhhgseifohhrkhhofhgrrhgurdgtohhmpdhnsggprhgtphhtthhopeefpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopegthhhlohhrsehstghhohhurdgukhdprhgt
    phhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:B0HWaVj79lCpD-JXqGP3ZpxR8JHcMfZk00K31AnA31SivicZTtxi_Q>
    <xmx:B0HWaaKVq25IuFylhcJhLx-XihpTrXZfaMOKfgfATBTLizrzGpqVcQ>
    <xmx:B0HWadBLqSJoFvlBGR0hs8Hkx2mAlW9tK3NDF4CF-1UrCRfuVZeHcg>
    <xmx:B0HWaSjoIIPjsocm7sneGg9_2jJNcIMtIXcw_bkAcLtsSa_qMS3Hug>
    <xmx:B0HWadnWYIji57ZxSTARTrvC6ommtXtuZNKZbsts-te9BuqY5VRDY4kC>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B746F700065; Wed,  8 Apr 2026 07:50:31 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AhAuoRtCUE3w
Date: Wed, 08 Apr 2026 13:50:11 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Hans Schou" <chlor@schou.dk>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <85ad7864-6ea6-4d78-97aa-f67cbe4eb22d@app.fastmail.com>
In-Reply-To: 
 <CAApBw345j80D3hvYzc47Wc9aDpr+HBJPQDpyeVZhvQ4b98a3QA@mail.gmail.com>
References: 
 <CAApBw345j80D3hvYzc47Wc9aDpr+HBJPQDpyeVZhvQ4b98a3QA@mail.gmail.com>
Subject: Re: EFI stub: WARNING: Failed to measure data for event 1: 0x800000000000000b
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Hans,

On Sat, 4 Apr 2026, at 12:54, Hans Schou wrote:
> Hi Ard
>
> This message has start showing for 3 seconds when booting:
> EFI stub: WARNING: Failed to measure data for event 1: 0x800000000000000b
>

This is a harmless warning from the TPM code in your BIOS.

> Afterwards my Linux Mint boots up normally.
>
> Linux p52 6.8.0-107-generic #107-Ubuntu SMP PREEMPT_DYNAMIC Fri Mar 13 
> 19:51:50 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
>
> GRUB 2.12
>
> This warning occurs only in several different events.
> It can be eliminated in different work arounds:
> 1. Having too many kernels installed. 19 is too many. 4 is few. 
> Solution: Remove some old kernels.
> 2. Enable/Disable secure boot in BIOS (if posssible)
> 3. Having Linux/Windows dual boot. Work around: add 
> "CONFIG_EFI_HANDOVER_PROTOCOL=N EFI_STUB=N" to 
> GRUB_CMDLINE_LINUX_DEFAULT in /etc/default/grub. 
>
> Only "1." is my own experience.
>

3. seems implausible to me: putting those strings on the command line has no effect, those are build options that must be taken into account while compiling the kernel.


> It seems like this situation happens as a combination of GRUB and the 
> kernel.
> The kernel should not be able to see I have more than 4 kernel 
> installed, as at the time of reporting the warning, one of my the 
> kernels are already about to boot.
> So it could be GRUB which gives some extra parameters to the kernel 
> when booting. How else could the kernel know there are "too many" 
> kernels installed? In that case the bug is in GRUB and the kernel is 
> just reporting it.
>
> By searching internet I found:
> * First seen year 2023 (kernel version not reported)
> * OS reported used: Mint, SuSE, Ubuntu, Ubuntu MATE, Kubuntu
>
> If it's due to GRUB, I apologize for the inconvenience.

You can just ignore this warning. I wouldn't recommend turning off secure boot just for this reason.


