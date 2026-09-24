Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407474746AD;
	Thu, 24 Sep 2026 11:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248364; cv=none; b=Kw0P9uQD/i9p/jEYGS5y+KXCEG0FKCCmpK5UiLn69uEgISh/4IwCjxcEYDfgL0pI7+2J72nu9KH1TMLotxFZSaT/cEqHzoNidfmMNPSH8dm8aNSUHVj6oRG70y9kosybtAPhM29wYcMi+kypytyx5xMn32QQU/qW2w983uI//M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248364; c=relaxed/simple;
	bh=h7v9i5BwXDpIwVukaEFMvXBYp2ISY3XxRln6ml0HgWI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=sdUKQiox+bfXxzuAhZrGxyL7EA/lgC+lbx2302puHY9yuhJ/iaJdxTaqBQygjitWvv/qJG0vJhNZoU7wXv1t2LYW7nuWSqom+0N4WFdP/4wLayQkJic1ps/YBn/uNW1zgXfXBPqTlXZyip3dhey9MtN4rhLAK1x74XnexO0Rzvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wu8aBbaK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wu8aBbaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077F61F000FF;
	Thu, 24 Sep 2026 11:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248362;
	bh=pZ9RcrwyyIc5YkWnQ+0jGoe6Toe0k1NcM6yfWeK3efA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Wu8aBbaK7t+K26nrAMs6ftExUc03TtIXLZ46FKoDLp6vhbMp0soViBrlXuz4nk6lY
	 awIyqHskPQ9aomVVkfIVe/exeYAKUDrh8cq68wGngDHcJHlkCz0Vlm5JACigFbIGLv
	 tayhrLyJyfxzQmU5lH4XSHKnEfE1sTrZgBT9PR/3xe4UK+HqhWWTblR4bQcoHkLIi5
	 w3OAuz6yJyuq8m8PKi6NUWcDCWeFEMpNqAMvmB4Z7LqYNpeDOJ9m2nTDwc63XnnuX0
	 ymkQdo95j+YMZ13ygE5u50Iod7y1//tXobNafdcqTKWAQ4TMB4Q4UWM5umRrl6kI+B
	 2jw2kJSYagbCQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id A7FBB1980058;
	Thu, 24 Sep 2026 07:12:40 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 24 Sep 2026 07:12:40 -0400
X-ME-Sender: <xms:pgW1aiZ1_7bwHGjfBYIxAxAy2WB6Z3tzV_sWKuXVQTssEuJJuIaflQ>
    <xme:pgW1agPZmzwlixfBX9a015lGMQyv-j9vsyBelrqE0MN4XqbVUB54ees9didMJSk-p
    VzjtH21wYKyYzUFHq2DCyMSZItTqyXiERE-sv8hQxYAtT4c7GZko5mW>
X-ME-Proxy-Cause: dmFkZTFHZQewR3/mQNk76XuylpN7LPhPVW8iFs2lcgNqvDHiNOWVSAvgUL2qa6a/RNHLxo
    CyLsXURwqMYj3L7l57RlQh5wMdZikK5/IqwrEJbUPpFt/jJyFsMSQb008srMD49COeOvdf
    3SB4bW9aYMUHoyUyGmEuFpIG4mYCzCNHdf4mwGzDyzrIXtDhm/f69pBmhR5mQZdDurp4ES
    pmMB8OdFwCRoWhNtwnRO1G0Iq5raWx8Ncf4lEKGR4gkjF9y1KJ4iCLSHMe+Aw+hL3VmKi/
    vKfPx8/Wg0AL0jtKuvXc65rVvi+HS9ggjDHmaoLOJdhkiAjnYPt/VraZwh1MP1i1dq0FOW
    EMVV46SGZWPq9tWEGuylV6UD6hrbAwwXrii0o7hCTewB08iR56hJ3av5Ky2MtBDMUDThhn
    TFuxvUJCTSTTCy8k75OtUM5AiLlipbpZ9hivC0nTCJqEwemoEjOjJQFLxBOQKdgZDFq6c8
    U5HNqElj2DF/AYNCH95ekqT2e9MLs04it1bPyTkVUAD/A8dfa2vKUz43us+1JvOPBqDZrN
    f52fw94BtX8H7gxGq9MOOxRcNPZxaDRRx4X41pIVe6fbAsAfCxCpBAm2xgEhoKXCRBBi2x
    J60chuz9+XnxvxyLl5CJ5CRevXZi3h2dcQHrw6+U9Yq8Q9yG9CGWWCY6P2yA
X-ME-Proxy: <xmx:qAW1ak_vLuk2Bre-hJ1J7HIzQrxqJk0MHkSQTs3c5SA214hDSdsLjA>
    <xmx:qAW1auQbf8WwtJ85-GyPXRU_MdCFyIwNwR5SEglZXOMdwa0ARTNQjg>
    <xmx:qAW1apRO6P4hwZ4LgA9b1Spo3KJOma2OmnKf2th5N9Rd8A-LoBVdKA>
    <xmx:qAW1aq4-8TJCRHUltNfzHNmsPCltmgMUvc34_biyOSFrRN5FEFSVwA>
    <xmx:qAW1auURCeUmUEkoTGw2UdIk2C0A0oIoGItOehzzQ6ldMIR-UmzgfVDC>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 2F81BF8007E; Thu, 24 Sep 2026 07:12:38 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 13:12:17 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
 "Prashant Singh" <singhpra@juniper.net>
Cc: "Jeremy Kerr" <jk@ozlabs.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Jonathan Corbet" <corbet@lwn.net>,
 linux-doc@vger.kernel.org,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev
Message-Id: <f7a04536-61e8-40df-8876-260dd2ef4fa8@app.fastmail.com>
In-Reply-To: <arUD_p0Vn4qyBH_e@redhat.com>
References: <20260919044124.8268-1-singhpra@juniper.net>
 <arUD_p0Vn4qyBH_e@redhat.com>
Subject: Re: [PATCH v2] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Thu, 24 Sep 2026, at 13:05, Luis Claudio R. Goncalves wrote:
> On Fri, Sep 18, 2026 at 09:41:24PM -0700, Prashant Singh wrote:
>> QueryVariableInfo() is an EFI runtime service that, on some firmware,
>> takes tens of milliseconds and runs with preemption disabled, stalling
>> the CPU that services it. efivarfs_statfs() calls it (rate-limited si=
nce
>> commit b2326338dc68 ("efivarfs: Rate limit statfs() handler")) to rep=
ort
>> the variable-store used/available capacity, so any statfs(2) -- e.g.
>> every "df" -- can inject that stall into unrelated latency-sensitive
>> workloads on the same CPU.
>>=20
>> Add a "nostatfs" mount option: when set, statfs(2) skips
>> QueryVariableInfo() entirely and reports zero used/available. It is s=
et
>> by default on CONFIG_PREEMPT_RT so real-time kernels do not take the
>> stall out of the box.
>
> I tested the patch and was quite satisfied with the results, but upon a
> comment from colleagues I ran a few more tests and noticed (confirmed =
their
> hunch) that fwupd complains about not being able to get the free space=
 in
> efivars:
>
>   # fwupdmgr get-devices | grep efivars
>   =E2=94=82     Update Error:       getting efivars free space is not =
supported
>   =E2=94=82 =E2=94=82   Update Error:       getting efivars free space=
 is not supported
>   ...
>
> I was not able to establish whether that would prevent specific operat=
ions
> due to the HW I had available for such test.
>

We might have to teach fwupdmgr to check the efivarfs mount flags and re=
mount
it if it requires this information. We should check whether that is poss=
ible
with the current version of the patch.

> One idea that I have been musing over is whether or not it would be in=
teresting
> to create a static view of the efivars statfs data when first mounting=
 it
> and updating this data whenever efivars is modified (create/write/dele=
te).
> Does that sound reasonable?
>

efivarfs is not the only component setting EFI variables. You would also=
 have to
hook every caller of efivar_set_variable() as well as efi.set_variable().

