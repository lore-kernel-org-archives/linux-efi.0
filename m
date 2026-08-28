Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305044315F
	for <linux-efi@vger.kernel.org>; Fri, 28 Aug 2026 07:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787902031; cv=none; b=NF8JHS6me95KzW3osLDqdA1C6FMm2yqjyv7L6qbdG5yxCgDqCRlcUFJHK8xkErsaerm3eBTc8chiotJXtfhyEz/J3pP6cx/6M5UUdx6pXPCXp1RQgbHAEU83UanlmZbZasKMh3UO7RprnLQr1n1ZwqjllilNHWXWkVpnloF/66o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787902031; c=relaxed/simple;
	bh=YOaIooRmfC3FPrSaNswv8niRo3TmeCLk0mVieo8uMrg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=WtuzLu0Jlfx3qauLeC7IMxAu/3rIZy6PbAf1iT+//BBqf2Hrw20T7peowv3Sty8zlA9sqJpzi/K28zfwBgmCUIAgGvT5y54ucKj9S5VyRXyJuRVN7dp9QPBgaHVnuFMD1Vis68501FbSxYlzZrGbcEdAVtskeDt4oERNfqbvDwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UCZXgkRk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCZXgkRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5481F00A3D;
	Fri, 28 Aug 2026 07:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787902030;
	bh=k2vBzac2CbGqM8xG3fuwgDkMdJk6+vPRFv4ESM0iG2E=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=UCZXgkRkaVoCKi6cqhTTht5sj4zu9m4OQOFWX2DoWgC0qg1gkwXIaCSGH+2fyzP+7
	 3s/x5NoMx5k5/gC8MJReFfTF311TTKDP5zVAkbJaRWDVHeOHGVyneejjJ7IPn+tXVB
	 Da5fdWmd9wD1vI99E3DEQc4HN/Hmeqr1Op2jBDacl8mpE9a8WSxvkPQO7JJOzLsRVo
	 ENAz2ZO28XfjrJKy44m6TlcuXwfWAIsCZCzfvzvddc/TLP62rarcJgTjsNh97tKEZh
	 A9g35DyrU+Oy2Ub9WxIbnL1Yqi2FLjGk6O2Uq3NzPSRaZtnaz5YRzznU3C3vDDqCCW
	 cDgMXXp+3XZ6A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id D230C1980064;
	Fri, 28 Aug 2026 03:27:07 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 28 Aug 2026 03:27:07 -0400
X-ME-Sender: <xms:STiRaia9Ciez7K4pbTqGUVwLHqU_BF33HqNYPdYeHXfZjiht_CTozQ>
    <xme:STiRagOBGXQQ5SRiZyoswm-pBOz1TE_qYBaYD0YCOfxSuyZle5PSOGkcEbkomF7Ey
    gPqJk-7ZsNAYPNktBnXclxgbHMVdL_NiPzwb4dt8gyTAb3eTdKMDttr>
X-ME-Proxy-Cause: dmFkZTGKC7MJVsVhwe7apdyGUvleWgqZguDJI/SNNS1FzJ8hsWOiVRzxWnmF1rq8Soikfy
    7XeSva86wvoFj9ysLgkIXIHOStH/wOg2Qtg6/mFUw+KMM0kXNfbmQd69Hg54MJpR6RDrNM
    vevQjW+cPRY83Rgxqpf9OXBIqmVIz9jO8n1uR0PbB3o3NT4kdH7SRMIOcbVlVAPKpetbTb
    1pDIlJU+36zzvnRN83CTlYVuENfUI9AumZk5Q9NTZQmngHrB8hzBaYIshl3qtl660SqHsc
    Q688sfFJAx4XoQq1ej0WiN9ft6VgIgTq4pohWiJ54KHagKZE/dHFvzRtZUeOg0uX35lmoV
    /09Tzt/Eof5BGhbi+ri6wdOx26pZutZrjBwFIfwK+v3+FzVcjgLwQB4lWRMujVjmDa8Xhx
    mtE87RcmGaOsNdd3n0gZi7+mKPk5zrbMEbSvFMqWLp6H7QkKI09EK7bWWfL6qwvAWWOkCe
    EXx2u3cWnckVPjYU61rfm10XSFIAun7OFox3eeSiib9fmJIszqznWyNus+9v/B96Uu9scZ
    zdtwOX0GIBBGObYfvjqHbi48YWYPebOofCETaw1dQa1KwS/+6BJdhgjnU8O8VFU99MrzdB
    +5jErgjGqngQwyJOzIHrg14MHt9n0mWY5bYNkDYeLHGxxls6wK15SnGBD4LA
X-ME-Proxy: <xmx:SziRat52uZT2BCr3C9JgVfiDWACDjBoSbGZ7aJ2BOBMNPkDFxSK6ug>
    <xmx:SziRat8R4Dy_GetnS5wUUESZFg35g_bdiQgZJX8gZgAx4Gr0p9nO6A>
    <xmx:SziRavHNJ3M-C-ORrA84t3bd7hkLiidTKkuIvNkjrnQR39ZqPcmUTw>
    <xmx:SziRaiWtJ3yRDFOwVAdaiH57LWDbBgcAq9wiEABtXxoPQX3BDUj4-w>
    <xmx:SziRar9fUMrXh-pahspJ38xn5qi0RxWTqMyCEfPVxuCU80gr0o70gQ5A>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id A8123F8007B; Fri, 28 Aug 2026 03:27:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 28 Aug 2026 09:26:42 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Johnny.Fan" <johnny.fan@cixtech.com>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 linux-rtc@vger.kernel.org
Cc: "Feng Tang" <feng.tang@linux.alibaba.com>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, cix-kernel-upstream@cixtech.com,
 bob.zhang@cixtech.com, jie.fu@cixtech.com
Message-Id: <549999fa-4b1a-4f53-872a-9036a377f8cf@app.fastmail.com>
In-Reply-To: <20260828031519.2749354-1-johnny.fan@cixtech.com>
References: <20260828031519.2749354-1-johnny.fan@cixtech.com>
Subject: Re: [PATCH] rtc: efi: restore alarm support with runtime capability probe
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Johnny,

On Fri, 28 Aug 2026, at 05:15, Johnny.Fan wrote:
> From: "Johnny.Fan" <Johnny.Fan@cixtech.com>
>
> Restore the EFI RTC alarm functionality (read_alarm/set_alarm and
> procfs output) that was removed by commit 18a3510bc87d ("rtc: efi:
> Remove wakeup functionality").
>
> The removal was motivated by the observation that many EFI platforms
> lack RTC wakeup support while also omitting the RT_PROP table, causing
> the wakeup capability to be incorrectly advertised.  While that is
> true, removing the feature entirely also breaks platforms where the
> wakeup runtime service actually works.
>
> On CIX SoCs with an I2C-connected RTC, the firmware owns the RTC and
> exposes it via EFI runtime services.  Using the native I2C RTC driver
> under Linux breaks Windows, which relies on EFI runtime services to
> access the RTC.  rtc-efi is therefore the only viable option for
> shared RTC access across operating systems, and it needs working
> alarm/wakeup support.
>

Why does it need working alarm/wakeup support?

I'm not saying we shouldn't bring it back, but this deserves a bit of
motivation, no?

