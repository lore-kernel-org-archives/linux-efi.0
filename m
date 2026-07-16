Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DEB3F9F5D;
	Thu, 16 Jul 2026 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784218449; cv=none; b=lFKb3m2OS+/qXWnsEpLapEFaTPGvuyxYuvkj08i/9MRNnr3CUWS0vXBcAX4cLT6wYGNv1aoJN5O3BA93a/nqQG9oPau4m21YbZexGAB48CdP7yI2SuX21AOj5k5MxhEZOROSh5RHyPnzV2CZgpsybfyPOJgH29qhjT9iHxxWJdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784218449; c=relaxed/simple;
	bh=11dkd9a6fOYpgckoYMT+1yqLwGQ/0K+tAEuaW5yiSLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hT+EY5HkDqmvgk7lUGPkMsMBc27EPWlkEV/kpVS0LAB9mJIInnz9HQ4huUT80LHOFb6WgFMQnr7VoKgK1IeVXPzHXs2dGSvWwpwKQIZFWrbSxZSIyAb/o9c+kWRYnaakCMyZlARRiWnB5b+Z+TsAgv4E+5WZLuNbXZvSbRmdioc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=OsSzBiRA; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=SqB0YgUN; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="OsSzBiRA";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="SqB0YgUN"
Date: Thu, 16 Jul 2026 18:13:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1784218437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yqr4tN1JGvsPCmphorpsdltK9YCq4rU4faJZdR9qcJI=;
	b=OsSzBiRA1Z/gX3y2IWVwk8mZtsGZIrLDfxAhugZefES8pnSsoxM65HWeXMRPzSeFVCVYXc
	ES9VS2zDw80kW5D/QBeJ2pRqLDNk7Z/w18Fd7kV6OsZZXY42XrjwIuEMsQ7N+XAge8csZs
	aNSpZkLEleEq5DwZTy4YmzEHWZp7AzPhuh2qBRBMr3GA98BNz6jHWXMMOZif+t0vQTVVtR
	CFxsgBkPcAS6B/IlEievbVyJblmMKVOLOtsEDTf9FNfmKhEZJBI/DOKYVQ3P/S1odMITB1
	31iYTwHOSIiVMxHLMRGp4Noei5dMBcecwvwV/Vo1Hg08RpU53weecYSFriPt4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1784218437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yqr4tN1JGvsPCmphorpsdltK9YCq4rU4faJZdR9qcJI=;
	b=SqB0YgUNkJnhO66BVHjL1+yHZYUPaVdzPjJcs+OWj3NLDpeIKmXQ/Gy3dMod8S7/QQg7IP
	m1NHvEhBqxOzz7AA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: "jenswi@kernel.org" <jenswi@kernel.org>, linux-rt-devel@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
	op-tee@lists.trustedfirmware.org, Ard Biesheuvel <ardb@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH] Documentation: Extend the real-time hardware bits with
 some firmware bits
Message-ID: <20260716161355.r2ZIoTxM@linutronix.de>
References: <20260701091226.7SWW4TrT@linutronix.de>
 <CAC_iWj+xDErhPeKGtsLK=nvPB7P8cQE3g9XCkaWf-d_j85FxCQ@mail.gmail.com>
 <20260710073147.XJAJbIwc@linutronix.de>
 <CAC_iWjLO3CAAFXE3s15Xcy3pWFK3ge5sWYmHHRBtcccKM2e1hw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAC_iWjLO3CAAFXE3s15Xcy3pWFK3ge5sWYmHHRBtcccKM2e1hw@mail.gmail.com>

On 2026-07-10 10:53:16 [+0300], Ilias Apalodimas wrote:
> > > > +Execution flows from the normal world (Linux) into the secure worl=
d (OP=E2=80=91TEE)
> > > > +through the secure monitor at EL3. Linux and OP=E2=80=91TEE cannot=
 disable or mask each
> > > > +other=E2=80=99s interrupts because both run at EL1 in different se=
curity states.
> > >
> > > That's not always true. It depends on a combination of OP-TEE and TF-A
> > > configs iirc.
> > > The most common though is that IRQs and FIQs are directly delivered to
> > > S-EL1, in which case OP-TEE can mask IRQs.
> > > There's also a difference between GICv2 and GICv3 in the way
> > > interrupts are delivered.
> >
> > You are saying that OP-TEE can mask Linux' interrupts or if OP-TEE
> > instructs TF-A to do so (via config)?
>=20
> OP-TEE can mask Linux IRQs

So what I got so far:
- linux has access to the normal world (not secure group 1)
- OP-TEE has access to the secure world (secure group 1)
This is for routing. And only secure world can manage secure and
non-secure its non-secure.
	https://developer.arm.com/documentation/198123/0302/Configuring-the-Arm-GIC

But then we have ICC_PMR_EL1 to enable/ disable interrupts based on the
priority and non-secure has limited priority range while secure has a
wider range. It can disable non-secure interrupts. And it took me a
while to get the right document and find this section:
| The GIC security model provides Secure and Non-secure accesses to the
| interrupt priority settings.The Non-secure accesses can configure
| interrupts only in the lower priority half of the supported priority
| values. Therefore, if the GIC implements 32 priority values, Non-secure
| accesses see only 16 priority values.

Good. Let me update so it matches the reality more closely=E2=80=A6

Sebastian
