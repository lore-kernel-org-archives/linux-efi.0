Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B18479893
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 11:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790251169; cv=none; b=tdImVt5zj/FWJBKcXjLu4dtM+XMZMcCQqxiYQ3w5HvLrGyuf8OYm9qW2fe4AOql9nKMq5mKX6ZdkxbXVewJLyFO/i3RPMpfY97iRwEnp6cPitI69VZ4Qu/stlTruNDEPIrHhRyOKktgbnU/neqGuS1yRsH7j/n14hveB3QV/KlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790251169; c=relaxed/simple;
	bh=774qvqqgMWYaywwJKJV4TivlBOUbwJtduazkCcl5ayc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=sGEWoLvWy8DsDYQecB+dJdbcePG3K9U1Mv3/aiCU9L3hv0M7npxtWZ2PyitIgtrfrdrADiUf/KuldpbNkczNWw7p5h+9Neo4GkOBlBHEMJVLQNoO395HUBxSCGhc4m2R60HRchWREy7o0tfEvCix7TunNUBwWhiqZWtIjbWzN28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvE8rhzN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvE8rhzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB861F000FF;
	Thu, 24 Sep 2026 11:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790251168;
	bh=rX/taSxhg8kPgoMfcN59II2ZF85nZaKfk+f+Anft+tQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=KvE8rhzNZMx9lfkitufzNhcoXcZyJaNPnIqNlpW1VttZUmWAsNk6K7Yq59+l4wJXy
	 d9gSJ/YQlZTkngyLFxXjXSjenTxuacL0hNaLt8TdNzSYLhUVviiQOiZrub6tR0z0KI
	 ZEVSwLzVD0fodZvRqv7ZaVxOC7rZqEci1UoUHOA8wwCLTq+NiDIZE4u0jx/XCvLS4V
	 YY33z6kzAZ1Nhr+KmXHUTDVD81pigLKbBAm3VlE3JPda2jw3xX8lZTI7UwYF28s/fc
	 6eGzvGneVSs9oHZEPeKuVCtauDyTflr+HAM/crf9Uq6/+0XnF6tv/jlsCw1anL3B1L
	 Mo1p9houxL+Jw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 1570B198005A;
	Thu, 24 Sep 2026 07:59:26 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 24 Sep 2026 07:59:26 -0400
X-ME-Sender: <xms:mxC1avZ5pjoMf61qaJh0Ulc5TcHJQhbJUW1MK18F7PbvuujisVx-_w>
    <xme:mxC1apPFyyjXBRqMdKrlNhUSkjylay1PY8xcvZsxV_XAleVLgwHVez0FHN9TpqHMX
    y-ayHfeg6aqGYGWMc-QkaXQ-40kNJf-NTB4EC2zXORi7xP0Glusdn_H>
X-ME-Proxy-Cause: dmFkZTEuyhnv88R/Au/UH9DUc7Nhr6CsqiYYSGJM4wjUlhaSYLJ7g7XkwgeyemxfEiyzL8
    H42xGZZ5eWVOXyi//ON5parv4gESfkNHKLLmwLfG31oSsvg7cpu+6/Qwnl+vPWUB6J4a0P
    84k+E5qWn7XSQQAZPMJYIAhHc8a+/ZXw25yicXrYcXjLXS1sSrmSbwhwK8mS2N0hMoKu2Z
    X3JIjCCXd/r/28hHTqrvEOr+Cl4lNs6TVbxSWBfBlNyL/NGo8dcHxHLLw6R2r+9TlmTkKH
    8hCCqEZo4la4zzbod5D5X51Tf8s9P0zc/XupezqoiWTGwegagUFNnPi0CMdl6F05MXboi7
    OC+x2TpLR2MrzWudFLUVJTQtaZExhpSAGW4b9EcYiyovN8rxKD+BlKu9/Vd8BuFBT+Yua3
    /9zXWdhX/sE5qSEL6vXk1F6XGLpUwmj9FyAsomDeyEd9FDT9KD8kfKT/yQhDsMzgPiMKaX
    oT/ZjVjfVxck32Ap0hhEH46eo8Iukq0oYdYZ9BRJ2N+BYO6Hl+fGuY6ZCD3n8HpCw4FbTj
    VhiDihInc66wqF0Ln80mbDAxBWZbNVS3lf2Zab0RP03u9ceIsVbJOxj6HtfslptSkdtmVC
    xtm5Xh3Mmpm12Jd4fjEZoia0CsNiRqh1Jai5JcMedJk4+dcqkh8hW7i+ciNA
X-ME-Proxy: <xmx:nhC1ajq-bj2cj5aj5YKe2qClgbxG7kRTZWbCS1gaEjXD1Rd42H9Agg>
    <xmx:nhC1akK69LVllif-Y_rzzXhx2RKq2h9OIuBjRXTLmxTp_EMKqIzr0Q>
    <xmx:nhC1auOkTOLscj12UTNZkMLYdjC8nmudanxpQA_guQljjuRvwxFFPA>
    <xmx:nhC1appytB9vBRtU9xBBkM0AMkZ4cpXsS4AdcAv9QjEGjY9ue0oGCA>
    <xmx:nhC1apIKsUpszBUllvRXzQbzCexKZOXwQcz9nOmBtkiow1ZuYZO2q5ob>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 6B422F80080; Thu, 24 Sep 2026 07:59:23 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 13:59:02 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
 "Steve McIntyre" <93sam@debian.org>
Cc: "Prashant Singh" <singhpra@juniper.net>, "Jeremy Kerr" <jk@ozlabs.org>,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Jonathan Corbet" <corbet@lwn.net>, linux-doc@vger.kernel.org,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev
Message-Id: <0d23d4f2-b5b8-47c3-a676-f6ec72ecf45d@app.fastmail.com>
In-Reply-To: <arULLk3ERQmADDBU@redhat.com>
References: <20260919044124.8268-1-singhpra@juniper.net>
 <arUD_p0Vn4qyBH_e@redhat.com> <20260924111913.GN3447081@tack.einval.com>
 <arULLk3ERQmADDBU@redhat.com>
Subject: Re: [PATCH v2] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Thu, 24 Sep 2026, at 13:36, Luis Claudio R. Goncalves wrote:
> On Thu, Sep 24, 2026 at 12:19:23PM +0100, Steve McIntyre wrote:
>> Hey all,
>>=20
>> On Thu, Sep 24, 2026 at 08:05:34AM -0300, Luis Claudio R. Goncalves w=
rote:
>> >On Fri, Sep 18, 2026 at 09:41:24PM -0700, Prashant Singh wrote:
>> >
>> >I tested the patch and was quite satisfied with the results, but upo=
n a
>> >comment from colleagues I ran a few more tests and noticed (confirme=
d their
>> >hunch) that fwupd complains about not being able to get the free spa=
ce in
>> >efivars:
>> >
>> >  # fwupdmgr get-devices | grep efivars
>> >  =E2=94=82     Update Error:       getting efivars free space is no=
t supported
>> >  =E2=94=82 =E2=94=82   Update Error:       getting efivars free spa=
ce is not supported
>> >  ...
>> >
>> >I was not able to establish whether that would prevent specific oper=
ations
>> >due to the HW I had available for such test.
>>=20
>> fwupd will refuse to do some of its updates if it can't read the
>> efivars free space, in particular updates of the secure boot keyrings
>> like KEK/DB/DBX.
>
> In this case, corroborating with Sashiko findings, it is necessary to =
have
> a way to override that default in kernels with PREEMPT_RT enabled. To =
be used
> where this is required for firmware updates.
>

Indeed.
