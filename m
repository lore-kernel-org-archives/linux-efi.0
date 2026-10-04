Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0472E414A04
	for <linux-efi@vger.kernel.org>; Sun,  4 Oct 2026 07:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791100753; cv=none; b=MIY1KJj0QSXht+2/k/gTBQJnek8W6DtXifyd/Eh2rOjvk+fcD89xHcEszN/kr1R76uS1zTT28vnu2+fUIEYMpKbarjFXvLOTkdDLRFzvggMtcSKdhqv+oEzL6VUa5bWgMh4cfy4aXvnbGMX5gIH40Vggrq3XGSCKjY1fXbkwIzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791100753; c=relaxed/simple;
	bh=ip5zwZmfrhsFTFJJSlPPKEZZ+EmEl88CikM38xxmG+g=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Pw0qTzJ9hhajvtCwYaRAot1ButzNFVqKXa2VU4+3VXUMCwRb30B+VrrzCVKwAnCpss+uToYN9dX6pP2k+8UkejJvEsJb51KR5Sam7M/Gi3jx9bUeEn47VcgbTSbLEgx23cE9Wo0Zq4J6eIfT6FvrFJuZQ+G+3l26dkMGI02PvQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eTIY7hjK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eTIY7hjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBC31F00893;
	Sun,  4 Oct 2026 07:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791100751;
	bh=ip5zwZmfrhsFTFJJSlPPKEZZ+EmEl88CikM38xxmG+g=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=eTIY7hjKl6/ZEFLqsHkTJZfahJrWYIhbkVRAtXOQZnxggiX+r1VbgU6aR+qSzp69T
	 HPZhLNysQoNXZI/VUt4xhevnzGmbvd3qGHpnrs3Aob4coSNRQGfFcQrAoUTSSdqRo7
	 gnjOGwwkW8xHiMdktBH3cIjVOQUBbuN/pPhuoU/PpT7tqkT7LU4ppu8C3a1en6Ge5i
	 fzQ79JE6bARUNP3HqejO7VJiemYT7O8i6DkykDJ+mBrv6h5tTwuniM3tKlBDr5S0Jn
	 iSGRg2Xdi6eMrvYoFugiBjlB85c9JhiViIlB4/LU0+7/oBzXY1Ms9YKjFQ9Bm8juws
	 FrTigHwsKHx5g==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id E26DF198003A;
	Sun,  4 Oct 2026 03:59:08 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sun, 04 Oct 2026 03:59:08 -0400
X-ME-Sender: <xms:SQfCap6qTSTVetAJBUV8gdXl9JhptjSuK4NWLF2OzYPImCobNmJMQA>
    <xme:SQfCahttkmV9PZoaZLcGPxAa9_lpSOWAIszXqlwor--k032meahulYqFHOcxOg42e
    casPIKhOkQyTc4aRWyQnbdZn7wV_ApxjmX6u7vDBRFvhBYRxTg5a2g>
X-ME-Proxy-Cause: dmFkZTGcfh3kb6i3UZvVBmS3UPTh4zYgtegthaQzX1uGiLADSMtq8j1AbGaOmxoTrrlmkL
    sQwsJ7+WXfIEVRZYxb+1XrepinD4fxRoREBJuZwfE4l3nIcCaNg43EqxpVBclLJeIpXR/w
    4vfOKKVzmBldF2SNSvypKRJ+eItI3rzAmsKdWlNoi3lEoL1ek8QppdLQNN7aN7BX/hsGhL
    7hjll2pb1buxolwdq04sgfey1ognkma879vWRNTga7zK4/wP1HGVw8bougW0bBc/UZsZmo
    PMfLcQ/OAQe7K/Bmy21dQHZWvwbnfjmHnGmJO56ie91GWlhMtaxon/qiU3x93hIHtgXsTe
    Z+p6rUHxORFmbmaphIxW2xzG9eZB40SC/v7Hnzh3xRhXgUMC3Y+4znbIQDtNSmcjzfP+aG
    E/1Fsnv4WoQIXPG0mZMhRJ70rsU0p/8c4eBDf4Kvp3N62cppUcWrdBW8gb7h3pgAJL3kDJ
    8PTHKCTfsywseebdNy76QsBQ1F/28pAVgkgoBEtVyhAshX+ic6bt0TCFPRKXUvEbLh+DW7
    1gknJlECY3tTspLKHiSU8lk54fyrRy293EeoKXgQI5ejnpx7RAjY08opmGFy796T2OnKws
    XXbXs30tXvqgPVMQRlxbb2up38w4aW4OH+fNwESJI2fd09DWZlRC8tFZ9Vdw
X-ME-Proxy: <xmx:TAfCanJI787GI1WvB8JnVrFUpc5M50bmnZYKZMRMXNLRXb2CIWiDgQ>
    <xmx:TAfCalhZRUM02qYes0s2xQarV8O9UT2WGVzWD1Jgd09Vit6UW_LfYA>
    <xmx:TAfCal26skyv5yIwCd1d0u5HewZtodtm2oFjHPRxsCYmR1wDywnE5A>
    <xmx:TAfCargLrMq9kb6n0h57JXF5dA8N3nFtevEYm6oY7R3rHtHH5-0W5A>
    <xmx:TAfCam9Sk8_ObNI9INf30KjmKxfaM0kOW_iTKe24d4qicTf2KcDv79L2>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id BE055F80086; Sun,  4 Oct 2026 03:59:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 04 Oct 2026 09:58:44 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Prashant Singh" <singhpra@juniper.net>,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Jeremy Kerr" <jk@ozlabs.org>, "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Jonathan Corbet" <corbet@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
 "Steve McIntyre" <93sam@debian.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Message-Id: <4491d728-64f6-4ab1-aae2-22bce34a9b18@app.fastmail.com>
In-Reply-To: <20261001012011.30525-1-singhpra@juniper.net>
References: <20260928203445.72318-1-singhpra@juniper.net>
 <20260929074312.v3jT8uel@linutronix.de>
 <59d5452c-42b1-4784-a593-5e549a2a0f12@app.fastmail.com>
 <20260929151401.doOQX7D0@linutronix.de>
 <20260930013500.10273-1-singhpra@juniper.net>
 <20260930063217.eWGJ_JpZ@linutronix.de>
 <20261001012011.30525-1-singhpra@juniper.net>
Subject: Re: [PATCH v4] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 1 Oct 2026, at 03:20, Prashant Singh wrote:
> Thanks Ard and Sebastian for the comments.
>
...
>>AFAICT, that would potentially leave KCSAN instrumentation on the reboot
>>path, which might trigger and interfere with the reboot. So instead,
>>I'd like to put this in efi_reboot_required if we can. If it is needed
>>in more places to address an actual KCSAN splat, I don't mind. If it is
>>just to make Sashiko happy, then we shouldn't bother.
>
> Could you please clarify what you mean by efi_reboot_required here? nostatfs
> is only read in efivarfs_statfs(), efivarfs_show_options() and
> efivarfs_init_fs_context(), none of which run on the reboot path, so I'm
> not sure how it would apply.
>

Apologies, I managed to completely confuse myself here. Forget what I said
here, please :-)

> On the annotation itself: an internal review flagged a potential KCSAN
> data race rather than an observed splat -- statfs() can run concurrently
> with a remount updating the flag, so it is a genuine (benign) concurrent
> access. I ran concurrent statfs/remount loops on separate CPUs under
> KCSAN and didn't trigger a report in a bounded run, which could be
> expected given KCSAN samples accesses, so it doesn't disprove the race.
> Since KCSAN only needs one side of the pair marked, data_race() on the
> write covers both readers and the reads stay plain. I'm happy to drop it
> entirely if you'd prefer to keep the benign race unannotated.
>

No, let's keep it as you suggest.

>>Please keep this description _here_ where you have it. Once this is
>>merged, you could send another patch, extending the documentation with
>>the statfs option (I think the workqueue change is in).
>
> Sure -- I'll keep it in Documentation/filesystems/efivarfs.rst for now
> and send a follow-up extending Documentation/core-api/real-time/hardware.rst
> once this is merged.
>
>>You still have the problem that someone reading the variable leads to
>>the same problem but this requires a privileged user. And if I am not
>>mistaken, someone sent patches to have efi-runtime runtime disabled/
>>enabled.
>
> Agreed -- the variable-read path is the same, but needs a privileged
> user unlike the unprivileged statfs()/df trigger.
>

Indeed - this is only about anyone with read permissions on the mount
point being able to trigger this. And looking at your results, the
rate limit we added recently might be a bit too permissive as well.
