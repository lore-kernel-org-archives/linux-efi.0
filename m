Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE3A277C96
	for <linux-efi@vger.kernel.org>; Fri, 10 Jul 2026 06:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783665034; cv=pass; b=C/Dz6Md7wklKhb+VF6OI/LgBN0LwWdvR9QEVtFYRPUTr4yn+mU60RAJcHGABr0xRskLkpN+ryEd29sUHoXBrVtsczGnwen5A82dqyeIxBeYp6X1Yxy9Rjz4pPOKhEhD5kJDwKBwg9qy5opmuVDU5wA2yXz+y3yGyjgq7pxNTVqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783665034; c=relaxed/simple;
	bh=6X4b53rZef1KKZD4TQJDBFQHHBhHup5eeeap5U4K8mM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DX99XYcdtzws1jA1k8619Z/gLesAAbc0UfhJLu2NRx64MD1ukqMatAL238XRhp2/hj4zBffiqBQ867QwE0rddxCYfMotf7St/oq0t31fB3FWiB7zDYRfm6zddChRx0MWEM8Qbc9WC108PI+2hWTrrYHrCLRlPAQ2Kjd+fJ5hpeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o0tFKQK1; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o0tFKQK1"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-66493875766so1009397d50.0
        for <linux-efi@vger.kernel.org>; Thu, 09 Jul 2026 23:30:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783665031; cv=none;
        d=google.com; s=arc-20260327;
        b=KyAVxFR9xL0zPTp2NeSj1Lv3zvziq6tQ+7IA4W8KJQm5pqjGkeneFuxlr0WELOtIom
         EusTj9KdR3Wtw4TmwpP+a0p77UWSyCQAb0bel8/y5ruU0/PdxG9EVHNRAj0B3EtL2oO5
         xsEwXgoy0Ei7pyr3a8q14vMPeWP4Apl+si6zweZAqnutdgeHe4WyS8So3qGNe7UVAiLI
         GPwxkw7uH7MKZKexgtKcQFVIgSJLr1lib/mnNX4sYkWdnSa9I145aaCyekOGCKKIhJhW
         WzAZJtbmydtpzuZqugHj92XVkHG7BibSpzXOULKS2qml+x0C0VkSVe39qkRncRBJ4qcu
         OQjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZT819g/Oq6qSvxizAhqmr/HnAVYEmomTbXe1mM2C/vA=;
        fh=TjxTq2u63MupgwIGoxn6VdoVNXmBXagZl7chY/4ygg0=;
        b=fxWH4J2mUU9Q49NceVimP+H8OLd0IK3SB9xftrteOniwymNUKyPCexKtd2oihVw6bL
         ubYUptF86BwqoOKVHhcl7Pnn+VsbBb/7qJtD+hYTtixL0VtVsPfni8K/rdXOPHqQ9Djq
         Y8GBvy71BUVBbh1IACosxCCjo8oH79gDNVfuUCqQVc1zFSbeW0qx8Ktumsfgq7jrCCyp
         tCOHIGxUxrDa25b38JQyw848HFKSy94gA++pnsAwoAMSDIcF3VfjV/9Ys8a0uDABmVoe
         UxWqz6un1lxivC1osFCnzHKGmrBW64a8v7G01/jFfF8j5IKEf/+TOXm2ytMiOYjUTwJf
         3rQQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1783665031; x=1784269831; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZT819g/Oq6qSvxizAhqmr/HnAVYEmomTbXe1mM2C/vA=;
        b=o0tFKQK1nTrmzcKqPrvzT2BSemjMZQsacDQtokEmpGpWSMMvYwxssxtW2cuGpLuKku
         k+pVfIlyh63KxnrGpDdjKfF7tPPJBijGVEMe+iPJg74B9IxLfMbsN9pua2CEBk11Gv9G
         FFq81A6uuF3EICXeDedAPOHLV9WwNYHlNM2DVcwJ0Txzz/Tthpb0Xov72UIoy3a2tYEV
         y8C8n5PrBgDvUWir8CjEk4oIizpkWkrcrA7leWzERsbqYNfRMrJaUBd8xLKzNZ3m7qhl
         kDsqdUmaOqBgzLlMwtQeHGYZHourdgtGVl+oSOWD8MRLN5q7BBxSB61KISycMMGrCukj
         4p7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783665031; x=1784269831;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZT819g/Oq6qSvxizAhqmr/HnAVYEmomTbXe1mM2C/vA=;
        b=sE5MvcqrYg6MEQVtkiSpg8agK+FydHHq9l2i5qT/P2fIO72C6gk1mymZ6Fdt8zjEDT
         ukGBPyEt77biCknNBZ8VxBV4b0fNNvC6fO8+O1eWOrEF/ECJKlJB3SU/5fIxaVKkfwcc
         cd7XpRCzlfyUWPFJLbup0Y1aDukV1ROv8kyEs9k+FS9rwF4xSzZ8dgDRxA9/L/u1CBZU
         Xfp86264Sl45fBTl7XB14wL4BRjjDG8RTlm+7dKT3K31JJdzovMMJ956lU0exz53RRlo
         QEC3bAfdJV5HZ4A4A9JWyHMlww+UxsS7C90IaTVY90aRVCy3+JB9uzmCInsfx7WX+mBf
         908Q==
X-Forwarded-Encrypted: i=1; AHgh+RrfGgA3BiGlgi2nI1zvdmv+be0oPtTGSQMSSdvBtXlL983hNXz39AC+RH5XP+KCzc1Wv9SuSsPLAHA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yygp1o/Fbduvu1Ymjh4R6EvbbkGZE42AHBPM7A6NnZ79Km8+Tcc
	zqDTumBoBJYjEYDvIUGvStLmsvU7CZQiPO6yKNLZe48EBxZzxBNGRAhVZv3qzWUGsGz//xCoZBT
	wmM5xh4x23oqRZ+6PYHcltk6oqY8augh2yOyX8WUf5Q==
X-Gm-Gg: AfdE7ckFt//gSa0GUXTkqUG19NtJYEfKAmabsO6D4B5zyGTuJz7+R9RzBZtckQ0z9Fo
	22twgqpF2+rgO7lGak715ph+QGBRIXiT/FxQGsdu4aFIi1eyPJQ6lTk4f37hSlPAztV7ZC6z/nx
	Pg01PKsuy+CCbe7cNIU0Ktgds9XEZZD7gtMEkl1c7ry1YckijsbAkG7mavIwuE4cvpFD+tGAZKw
	ErNoNJT4TRTg1KeHxT7VyNtHH7V8nBuUPGmrqwXzHuCIPSp0ips+d0/GdA19j+WMn9lLeMhTvT/
	s/qYAW/rOBohIaJKI0lRhUBdGrgMTSbINodd+yDhOB2120iJJLTavojXP9rOuTL+/b4S5xn8YZr
	gnQw3Ysbt+gnae/GyryUnMIjPL1qTp1tUjrtBy2BHjuv/HSvE0QCc5Xei6KmxCmHW3ZqICzKRLR
	NMg/8cHhGRNMB3pI46LjYfiLMS6sKxbarYwslWrSumWhollXMyFqo2NFCemQ19FXiq0rD/9TOS/
	sHvU+BipIDBtn+/xey0io29uDQ5bRzosxUkir9LJszSoFLu1z7KXWctjaZ6RaLeuObdAEERLwGW
	5SmDJNljzs431rP/E8tDJFzpwlBhrqLaibpnIgUZ2MhS7AigDzaKUKTD1o8H/1eV+/1S1q8=
X-Received: by 2002:a05:690e:1609:b0:667:9eb2:8ffd with SMTP id
 956f58d0204a3-6679f25cc74mr4981051d50.90.1783665031305; Thu, 09 Jul 2026
 23:30:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701091226.7SWW4TrT@linutronix.de>
In-Reply-To: <20260701091226.7SWW4TrT@linutronix.de>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Fri, 10 Jul 2026 09:29:55 +0300
X-Gm-Features: AUfX_mxLJVuqDQuycLYMMiskfwdItuud7PupTjy9MFHq6Q3HmuV1dekuQzstXtk
Message-ID: <CAC_iWj+xDErhPeKGtsLK=nvPB7P8cQE3g9XCkaWf-d_j85FxCQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation: Extend the real-time hardware bits with
 some firmware bits
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "jenswi@kernel.org" <jenswi@kernel.org>
Cc: linux-rt-devel@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-efi@vger.kernel.org, op-tee@lists.trustedfirmware.org, 
	Ard Biesheuvel <ardb@kernel.org>, Clark Williams <clrkwllms@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	John Ogness <john.ogness@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sebastian!

I'll let Jens fill in the gaps. Some general comments below.

On Wed, 1 Jul 2026 at 12:12, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> I have been reviewing how OP=E2=80=91TEE is implemented and how secure=E2=
=80=91world
> invocations behave. The goal was to determine whether an OP=E2=80=91TEE c=
all can
> delay the Linux side and introduce latency depending on the time spent
> in the secure world.
>
> Similar latency effects are already known for EFI runtime services, but
> this was not documented. To mitigate the impact, EFI runtime invocations
> can be restricted to specific CPUs so that real=E2=80=91time workloads on=
 other
> CPUs remain unaffected. This mechanism, however, is only described in
> the commit that introduced it.
>
> This change adds a firmware section that documents these behaviours
> explicitly. It highlights cases where firmware can delay the kernel,
> information that may be unfamiliar to some users and surprising-or
> concerning-to others.
>
> Assisted-by: Microsoft-Copilot
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>
> I would appreciate an ACK from the OP-TEE camp that I got my little
> research right.
>
>  Documentation/core-api/real-time/hardware.rst | 92 +++++++++++++++++++
>  1 file changed, 92 insertions(+)
>
> diff --git a/Documentation/core-api/real-time/hardware.rst b/Documentatio=
n/core-api/real-time/hardware.rst
> index 19f9bb3786e03..fb113848c2f70 100644
> --- a/Documentation/core-api/real-time/hardware.rst
> +++ b/Documentation/core-api/real-time/hardware.rst
> @@ -130,3 +130,95 @@ https://github.com/Linutronix/RTC-Testbench.

[...]

> +
> +OP-TEE (ARM)
> +~~~~~~~~~~~~

That's RISC-V as well nowadays

> +
> +OP=E2=80=91TEE uses a global serialization mechanism (the "big lock"), e=
nsuring that on
> +each core only one OP=E2=80=91TEE thread executes secure=E2=80=91world c=
ode at a time.
> +
> +Execution flows from the normal world (Linux) into the secure world (OP=
=E2=80=91TEE)
> +through the secure monitor at EL3. Linux and OP=E2=80=91TEE cannot disab=
le or mask each
> +other=E2=80=99s interrupts because both run at EL1 in different security=
 states.

That's not always true. It depends on a combination of OP-TEE and TF-A
configs iirc.
The most common though is that IRQs and FIQs are directly delivered to
S-EL1, in which case OP-TEE can mask IRQs.
There's also a difference between GICv2 and GICv3 in the way
interrupts are delivered.

> +
> +Architecturally, the secure monitor can mask or reroute normal=E2=80=91w=
orld interrupts
> +before entering the secure world. In a correct OP=E2=80=91TEE/ TF=E2=80=
=91A implementation, it
> +does not do this for the duration of secure calls. Normal=E2=80=91world =
interrupts
> +remain deliverable, and a normal=E2=80=91world IRQ will preempt OP=E2=80=
=91TEE via EL3 and
> +return control to Linux.

The 'sane' case is indeed where IRQs are delivered to OP-TEE which
exits back to Linux immediately.

> +
> +Secure=E2=80=91world interrupts (FIQs) are possible if the SoC routes a =
device's
> +interrupt as secure. Such a secure FIQ will preempt Linux immediately, t=
rap
> +into EL3, and transfer control to OP=E2=80=91TEE's secure interrupt hand=
ler. Linux
> +cannot mask or preempt this. Secure FIQ handlers must therefore be extre=
mely
> +short to avoid introducing noticeable latency.

There are also 'fast SMCs', which run with IRQs disabled for their
entire duration.

> +
> +The transition from normal world -> secure monitor -> OP=E2=80=91TEE and=
 back introduces
> +additional latency due to world switching and context save/ restore. Thi=
s
> +overhead is typically a few microseconds and usually remains in the nois=
e
> +floor.

That's correct.

> +
> +If the secure monitor masks normal=E2=80=91world interrupts during OP=E2=
=80=91TEE invocations,
> +or if OP=E2=80=91TEE uses long=E2=80=91running secure FIQ handlers, then=
 OP=E2=80=91TEE can introduce
> +measurable latency spikes.
> --
> 2.53.0
>

Overall I think this is worth documenting, but infortunately there's a
wider range of configs and corner cases we have to describe.

Cheers
/Ilias
