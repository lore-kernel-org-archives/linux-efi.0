Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1133B8939;
	Fri, 10 Jul 2026 07:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783668711; cv=none; b=aNgc5gBX1T8Lj84OBR/WNdwHj4QsH/UVcVUsPxREmyQeqgrz/3my2DerTbunT329Tj/Uj0QtxawatWfz2ZBZHyzdLoCGc+NddvfdwwbyJ7qZnKrpHbe1DNSxOMHGN2nvhTmXmKTPoMNJTx0LYqy/XPpLTzteZ5RDSb+MyxMpAGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783668711; c=relaxed/simple;
	bh=JneN2M9JbJqKy6qgUPNItB4lcaDHbu64RY5+o9oIB6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbHIOMPJhgmrIu2aZ43eU2TsqZAGpjDDOyxg5lhl9OVSemlsrtXgeYgG1Ckp/p4xYIV3Kt4MN08ZaK/dBXaK3B9JU3Q/Ei9bEzjLrawjr0jJX4Jbz5AYQwD9uK2kIRh7qHz8CSmFXvq3IUuMxgjnmLMeJAZw1SxajnH6/Mi4rPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CYWc2XMP; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=zkjkvLix; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CYWc2XMP";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zkjkvLix"
Date: Fri, 10 Jul 2026 09:31:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783668708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JneN2M9JbJqKy6qgUPNItB4lcaDHbu64RY5+o9oIB6c=;
	b=CYWc2XMP2kSKRhOqDExn2t5iOXHPKvWWyfoW0a/ze3JYCZ5vMi4FDPWwqUMQJ8/ls5rI9t
	Y6Sh03ZTfPt2czfIo/cFlYooQxO//Lxgj/5e0psGv+3tSOvph6UeW82CAhaI3j5mljprsu
	BldCShDzu1wd/eyS6Ol6IYrJEKqKkYsWOr0Ml3Ekkxzp5nIKzWRjGvi4aXfka6i3A6uSVi
	Y4Inty2gqa/naFDDlqJ1H/n42Jrset+NK18LImANbATiDgId3ZX0RTSqjlEUIyRAPDnbnk
	bad8x5VHi8Lno0MQnH0cbYzkMO+Dd/LS9J5crKezaviuSkRutX/5w0mfKtGZ9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783668708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JneN2M9JbJqKy6qgUPNItB4lcaDHbu64RY5+o9oIB6c=;
	b=zkjkvLixw+0vNVj1P8Y/gayysL+dJb4IuUxB5JvbUshMLYJ87X5OIZgQyRmbn7tYArod5m
	K11MxyLDpE7zzFDA==
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
Message-ID: <20260710073147.XJAJbIwc@linutronix.de>
References: <20260701091226.7SWW4TrT@linutronix.de>
 <CAC_iWj+xDErhPeKGtsLK=nvPB7P8cQE3g9XCkaWf-d_j85FxCQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAC_iWj+xDErhPeKGtsLK=nvPB7P8cQE3g9XCkaWf-d_j85FxCQ@mail.gmail.com>

On 2026-07-10 09:29:55 [+0300], Ilias Apalodimas wrote:
> Hi Sebastian!
Hi Ilias,

> > +++ b/Documentation/core-api/real-time/hardware.rst
> > @@ -130,3 +130,95 @@ https://github.com/Linutronix/RTC-Testbench.
>=20
> [...]
>=20
> > +
> > +OP-TEE (ARM)
> > +~~~~~~~~~~~~
>=20
> That's RISC-V as well nowadays

I did not find much here. Their architecture isn't the same as on ARM is
it? But the overall concept is the same, right?

> > +
> > +OP=E2=80=91TEE uses a global serialization mechanism (the "big lock"),=
 ensuring that on
> > +each core only one OP=E2=80=91TEE thread executes secure=E2=80=91world=
 code at a time.
> > +
> > +Execution flows from the normal world (Linux) into the secure world (O=
P=E2=80=91TEE)
> > +through the secure monitor at EL3. Linux and OP=E2=80=91TEE cannot dis=
able or mask each
> > +other=E2=80=99s interrupts because both run at EL1 in different securi=
ty states.
>=20
> That's not always true. It depends on a combination of OP-TEE and TF-A
> configs iirc.
> The most common though is that IRQs and FIQs are directly delivered to
> S-EL1, in which case OP-TEE can mask IRQs.
> There's also a difference between GICv2 and GICv3 in the way
> interrupts are delivered.

You are saying that OP-TEE can mask Linux' interrupts or if OP-TEE
instructs TF-A to do so (via config)?

> > +
> > +Architecturally, the secure monitor can mask or reroute normal=E2=80=
=91world interrupts
> > +before entering the secure world. In a correct OP=E2=80=91TEE/ TF=E2=
=80=91A implementation, it
> > +does not do this for the duration of secure calls. Normal=E2=80=91worl=
d interrupts
> > +remain deliverable, and a normal=E2=80=91world IRQ will preempt OP=E2=
=80=91TEE via EL3 and
> > +return control to Linux.
>=20
> The 'sane' case is indeed where IRQs are delivered to OP-TEE which
> exits back to Linux immediately.
>=20
> > +
> > +Secure=E2=80=91world interrupts (FIQs) are possible if the SoC routes =
a device's
> > +interrupt as secure. Such a secure FIQ will preempt Linux immediately,=
 trap
> > +into EL3, and transfer control to OP=E2=80=91TEE's secure interrupt ha=
ndler. Linux
> > +cannot mask or preempt this. Secure FIQ handlers must therefore be ext=
remely
> > +short to avoid introducing noticeable latency.
>=20
> There are also 'fast SMCs', which run with IRQs disabled for their
> entire duration.

can their be distinguished somehow from normal SMC invocations or is
just a consequence that the secure monitor does not enable interrupts
during transition for some of the "functions"?

> > +
> > +The transition from normal world -> secure monitor -> OP=E2=80=91TEE a=
nd back introduces
> > +additional latency due to world switching and context save/ restore. T=
his
> > +overhead is typically a few microseconds and usually remains in the no=
ise
> > +floor.
>=20
> That's correct.
>=20
> > +
> > +If the secure monitor masks normal=E2=80=91world interrupts during OP=
=E2=80=91TEE invocations,
> > +or if OP=E2=80=91TEE uses long=E2=80=91running secure FIQ handlers, th=
en OP=E2=80=91TEE can introduce
> > +measurable latency spikes.
> > --
> > 2.53.0
> >
>=20
> Overall I think this is worth documenting, but infortunately there's a
> wider range of configs and corner cases we have to describe.

Okay.

> Cheers
> /Ilias

Sebastian
