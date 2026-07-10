Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D853DD50C
	for <linux-efi@vger.kernel.org>; Fri, 10 Jul 2026 07:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783670038; cv=pass; b=uxd8Ut+tFPYH02bnJDbCxv/vPbSvyDeLF3zvHcNZ7QQqmCW39SlO1hlxkHJCzOG/s96b0ZWkq4MsBpEwxBBy022nNOAL0kvK71ZtzwK1XD88WFx6f7wtUbq397EanKlemQmsRJZedcB2Tc4rHAbgLGkD2TR2BFnLUdLAWDJyOc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783670038; c=relaxed/simple;
	bh=VOWM6CrABsSE1ZgAmtTX+wv+twEBAQ/PjFUZeWerkIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O7aY3b9GQJejqbuweJp4vTABFyp75Gu1pjwqGSnsqL/mbn1OZQfomWnoc5RT4SXlIB4EK0fXBlCBJ5VFHcnj8DU39XXglMl4MHZw8XDnFLwyj+WvEcPq37v7nS9hoFnqXDZnZ09V4L7e5zS6BqoO37sx96OGc0A1i8uGgufKp1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=agy5y87k; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="agy5y87k"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-667971437d6so873393d50.2
        for <linux-efi@vger.kernel.org>; Fri, 10 Jul 2026 00:53:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783670032; cv=none;
        d=google.com; s=arc-20260327;
        b=fBBoYvgnuVjdyl3wg26Gw9PpnIkJfT5+3TTzsgW858KpZm57PpQpXkSmKPtgmCc6Re
         8l20vDUS5wJGfcLKRgoYgyt1ajxIP7Zc63bUXal0hIx6lyyps/dVyqj78UaYy7viSRR2
         pWCAh3kgKDouHHLqMLYI0vlQIxppR6JwfSja8CV3OLIzdCaqoBd5Wk3H1RywizI0dbWJ
         wGmLIuE8di4rWBDxKsJ0h0C0BgCddzHK+ycbCA0fQXYBWXsfkbqVrePYm2w3TDDSV40g
         N7cOeCfTyyTK2yMWqTTar3iMvHbhJ2vKPYCYxR4tyEFQkjpCqorXP9YDnv/jSAgGXuye
         pOXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VOWM6CrABsSE1ZgAmtTX+wv+twEBAQ/PjFUZeWerkIA=;
        fh=lb3yKWWIcbhNMwcXkdycxrmEjsWs/vwF2rxJSICHOqk=;
        b=c1K9KCK+yXw2WkWGTT9O0GBHUTBDN3WBslDSQF4XQImTbBvJzTXU6MGXiiQGBUZjXJ
         RB3pP7/+o6joHwnvnoQbLjBOhoQYv7uhUx8toZ+IQjd5Qmf9wJnrA61E7aUUN5CgyUET
         DGmPKMuHbH8Y2ZZZLVnXCa592CvFKFMKARpnkgCfyztQhBuZZReK3YvvCi55ibPfkbhl
         hOc8yVRrlFzihbHLyrlGWPoOneCvcEJmRNzcf3wBL9Mc54aQ1owOaf/NnHACq1+akDX5
         r1XwqPThthGVh21uY/u9ILJdQklNI5WnPMTYHbU9kE9LnltsNe4r+udOZBwKdbP/7usx
         J8Ww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1783670032; x=1784274832; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VOWM6CrABsSE1ZgAmtTX+wv+twEBAQ/PjFUZeWerkIA=;
        b=agy5y87k6QtFdYk3VEFbVKK55qX8ShfHQMzH3Np+fbUaFiFRryYSWd8YEb9agj0cvM
         fRs1+OY0xUd4ep/fxa+/wyGEmAzljXBMXjPZdU7OGtfx62UY3xHQVD261Nf+i7867S/b
         wCCSbXdUQhJIWYra8wymkmzZyWKUfrYfpu1jVtLZWtmRKcfv3S/CkfYR5PvqghJhe62w
         0An/CixZg0WjiKUX717fuwqs71AcomVSXL66A1l2ksTnder/G4oAPSn3TdEuhAZ7vqhX
         dDArfrpLG96ER2MCqs52IFi3YOUR1p3QMnBkQtGIw5aWA/rkzfJ8y1Lu8nm2QzXVgWdz
         JYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783670032; x=1784274832;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VOWM6CrABsSE1ZgAmtTX+wv+twEBAQ/PjFUZeWerkIA=;
        b=AMSqjZidpla/npJBz8k/9+1pUNOZe4WU4s9cqkwwRUFNuqZJFpW/2KzeQDrIlmKIHQ
         9Kxrbj4SsXXNOTEf9Pisq53TwtEMRnQp/7HVYShVil/uqhqtA35qLiXpn/upnV9NCiPD
         99kz7/xnp9iXALAMrS9HbKOxqEjFbpfzE1hQjTylTG6fFAFSEVJlRVliM8mnxMgOHLkt
         0P0henN1s9Ue0x6jJkn814CiZ3rwgoy3F5+YGF8ETyFx/TueXF7HpoLyttOcCKT47sHv
         8aDlfpZsfFBPNLcbSoY6Rqgf+Bx2i7mF0ZZUq5NipOolIy03QHNbE1XtI0YaZVfno+qc
         eByw==
X-Forwarded-Encrypted: i=1; AHgh+RqiqY1Wl9O7QYTwK7KKHyHfHUGvF1Xn6TPnYkufHj297asPjSO2Bpx15xldOF+4DgZcsDipJdhZ46s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdPEqLlRc+1qqIZRmG4P3ULfd0Ic8jkohEAzh77N8Wa5smo0hz
	pXLxjnYimbyszMNsdEHXcke0Ya8k+8g7pN7zImpExnZDlG1TK61CQk31rQyA621C8RKfYp1r/kg
	XXA/5UnJEjFvakkotKJ9ngadwX+JsV4/G0xc0v7BaA2ipWUyhIEUSTE8xGg==
X-Gm-Gg: AfdE7cmHyBE0UrQNe+fAQdB4cAML1sKCLC7AbmosvTiv3RkjBBzhFh1Bfxv2JbC8FFm
	YCIZwFbnlNlRmEJkYDnexrpVawzq0R1U25rrKKRJK4Rf6j+IVAM4rYfQRaNhr5d331X3PxW/7An
	4AbCQ9beZqHRh7S6PKosyoHJByB4NizYFht64nDdyobTJEwfJ+yUHj1c/6CpZsI6OD1QaZsiNUn
	ZegK8UjlzOVQ5ATcldyaZdFqUR/bnJaQC0Om5Te/2exfI5KXPGvdXxNh2MaqqXvMV9iCiRPVD6N
	8SNLr1TCsO9r/ojkKM6BboyhoSEy6ufkEBGy3FcaBr+bQQ5iL3leDXd6EYThIX/E/FCn6lWA+h3
	A/f0Q30KW25szhj13HD2Qlg9jQ8TgCpLtzSichS33k7pHMlmXCWEN8M3OHNB8YzA8YQX8lgzpci
	ChZzBLv0xw/uEZ9QMI6BlRMQ10/OPpb2D6cvQpZg0M4J+OSUpi1byY0OdQW9lbh6P6x4EjjsbmC
	/bTfYQLdnTuyEqvQTARAxbqtQezdTszIb0e/H6ZrgtXBIhkAjBXhsZsqIHv9pjtGqksWjuPHqt8
	ijUAwS/lL+fGPfbdybhUUeM33WxPqlM8IWi9qp9jz+uirIJykufLeyjjkhj85yd+k0TClz2xELb
	R/yV/6w==
X-Received: by 2002:a05:690e:43d4:b0:664:99a3:34a7 with SMTP id
 956f58d0204a3-6679f1ac64amr4926164d50.60.1783670032531; Fri, 10 Jul 2026
 00:53:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701091226.7SWW4TrT@linutronix.de> <CAC_iWj+xDErhPeKGtsLK=nvPB7P8cQE3g9XCkaWf-d_j85FxCQ@mail.gmail.com>
 <20260710073147.XJAJbIwc@linutronix.de>
In-Reply-To: <20260710073147.XJAJbIwc@linutronix.de>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Fri, 10 Jul 2026 10:53:16 +0300
X-Gm-Features: AVVi8CfEoTWISJnCnc9-eLJA2a3H9SubdRhk1-OoqodnM6Xg_e0TDYWFCpSokGU
Message-ID: <CAC_iWjLO3CAAFXE3s15Xcy3pWFK3ge5sWYmHHRBtcccKM2e1hw@mail.gmail.com>
Subject: Re: [PATCH] Documentation: Extend the real-time hardware bits with
 some firmware bits
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "jenswi@kernel.org" <jenswi@kernel.org>, linux-rt-devel@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-efi@vger.kernel.org, 
	op-tee@lists.trustedfirmware.org, Ard Biesheuvel <ardb@kernel.org>, 
	Clark Williams <clrkwllms@kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, John Ogness <john.ogness@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Jul 2026 at 10:31, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2026-07-10 09:29:55 [+0300], Ilias Apalodimas wrote:
> > Hi Sebastian!
> Hi Ilias,
>
> > > +++ b/Documentation/core-api/real-time/hardware.rst
> > > @@ -130,3 +130,95 @@ https://github.com/Linutronix/RTC-Testbench.
> >
> > [...]
> >
> > > +
> > > +OP-TEE (ARM)
> > > +~~~~~~~~~~~~
> >
> > That's RISC-V as well nowadays
>
> I did not find much here. Their architecture isn't the same as on ARM is
> it? But the overall concept is the same, right?

I haven't checked the IRQ vectors on risc-v, but I assume they have a
similar logic since that's an OP-TEE design decision not a per
architecture one.

>
> > > +
> > > +OP=E2=80=91TEE uses a global serialization mechanism (the "big lock"=
), ensuring that on
> > > +each core only one OP=E2=80=91TEE thread executes secure=E2=80=91wor=
ld code at a time.
> > > +
> > > +Execution flows from the normal world (Linux) into the secure world =
(OP=E2=80=91TEE)
> > > +through the secure monitor at EL3. Linux and OP=E2=80=91TEE cannot d=
isable or mask each
> > > +other=E2=80=99s interrupts because both run at EL1 in different secu=
rity states.
> >
> > That's not always true. It depends on a combination of OP-TEE and TF-A
> > configs iirc.
> > The most common though is that IRQs and FIQs are directly delivered to
> > S-EL1, in which case OP-TEE can mask IRQs.
> > There's also a difference between GICv2 and GICv3 in the way
> > interrupts are delivered.
>
> You are saying that OP-TEE can mask Linux' interrupts or if OP-TEE
> instructs TF-A to do so (via config)?

OP-TEE can mask Linux IRQs

>
> > > +
> > > +Architecturally, the secure monitor can mask or reroute normal=E2=80=
=91world interrupts
> > > +before entering the secure world. In a correct OP=E2=80=91TEE/ TF=E2=
=80=91A implementation, it
> > > +does not do this for the duration of secure calls. Normal=E2=80=91wo=
rld interrupts
> > > +remain deliverable, and a normal=E2=80=91world IRQ will preempt OP=
=E2=80=91TEE via EL3 and
> > > +return control to Linux.
> >
> > The 'sane' case is indeed where IRQs are delivered to OP-TEE which
> > exits back to Linux immediately.
> >
> > > +
> > > +Secure=E2=80=91world interrupts (FIQs) are possible if the SoC route=
s a device's
> > > +interrupt as secure. Such a secure FIQ will preempt Linux immediatel=
y, trap
> > > +into EL3, and transfer control to OP=E2=80=91TEE's secure interrupt =
handler. Linux
> > > +cannot mask or preempt this. Secure FIQ handlers must therefore be e=
xtremely
> > > +short to avoid introducing noticeable latency.
> >
> > There are also 'fast SMCs', which run with IRQs disabled for their
> > entire duration.
>
> can their be distinguished somehow from normal SMC invocations or is
> just a consequence that the secure monitor does not enable interrupts
> during transition for some of the "functions"?

They can be identified. There's a function identifier defined in the
SMC calling conventions doc [0].
Bit 31 is always 1 for fast calls and 0 for yielding.

>
> > > +
> > > +The transition from normal world -> secure monitor -> OP=E2=80=91TEE=
 and back introduces
> > > +additional latency due to world switching and context save/ restore.=
 This
> > > +overhead is typically a few microseconds and usually remains in the =
noise
> > > +floor.
> >
> > That's correct.
> >
> > > +
> > > +If the secure monitor masks normal=E2=80=91world interrupts during O=
P=E2=80=91TEE invocations,
> > > +or if OP=E2=80=91TEE uses long=E2=80=91running secure FIQ handlers, =
then OP=E2=80=91TEE can introduce
> > > +measurable latency spikes.
> > > --
> > > 2.53.0
> > >
> >
> > Overall I think this is worth documenting, but infortunately there's a
> > wider range of configs and corner cases we have to describe.
>
> Okay.

[0] https://developer.arm.com/documentation/den0028/h/?lang=3Den

Cheers
/Ilias
>
> > Cheers
> > /Ilias
>
> Sebastian
