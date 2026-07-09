Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3B337FF5A
	for <linux-efi@vger.kernel.org>; Thu,  9 Jul 2026 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783616619; cv=pass; b=d9dvyU2zSWRiTZ2bh/exBXKXdAYqE7avLydpjIYPlinZa32un0MxIWCJ8aA5oFmaDbLj+BZh4GpfAjSpJOlUX0x5uf95jjC7s8SUFNX9d6tKryTM5ISQgmM0sSY6878i9AWUulS5FEcNj5Y8rntmwauW+s1qrPxclqXTk46c9oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783616619; c=relaxed/simple;
	bh=YewI3WK0FI+k+A8vApRuZn3wTz1R19tXNTxrVUVVf90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tfMLNlZNit1OC+KMA78TM15asVo2EYvU9fO4nKBa1NpWKxvAvlflMrLw7aRkTWIsit5QNV6QSez6AlYU6DndLJYROQFrVUfXPC6tIPzpJ9zGtfWXSciuiYrFirMrsUuJeM5lDCLNdAuLPtMvN5kAggusLG5hCINaHdrM5PJap6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l3iLdhWm; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l3iLdhWm"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-667bae10ba3so1569d50.2
        for <linux-efi@vger.kernel.org>; Thu, 09 Jul 2026 10:03:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783616616; cv=none;
        d=google.com; s=arc-20260327;
        b=KAKCoz/8RTAVahX/5rKZo7OhTP7JL7O5BPLU98lBB0bH9y7Mez3NMy0OlYjcCXthez
         /k57Ugy4JCTFIwoLd+aW11Og/IdgNVz/xIPn4p4rdCgeVxUirSwy/QJ4WlLrV6eUQmHU
         A3UchkUg+NhafBv1Oe2dwXrQ6RA9Ngup5pR/zGN4qoxfUQkNeCVOLBHvHCDJoxotPJ2d
         UOZ47UIqxEWEtWFQH9Mhyyg9SeyMVOAXWFKEIGDieaWv9Rqp5McgEhGyjL0B/1ZKjqz8
         coGsJ8/uJwVXOWzHAAaUl6Wy9c9YXCU7ZfLXI1wIjOa8JTl57tWFI4G7ehZPlj0wNi8g
         3E4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yR14oOjUi6OI2bUfX4NS8nwAQpf3oK/jBWo0jGsJb5s=;
        fh=yNvpP/vmt8GjhosF/YuuarXT99/AKJo/UHCkkWmBZN0=;
        b=MVPxj6ybo7RQhpkeWD8sPExvpfQ3PyzVfOhNIFDF0Q9vawBbuHU2r2QEpOiMEKI+zJ
         0lv8iVMAwFRLZAOzvzbsGffbynstVch9hnEpKy4A/zkfemAeC8Y2EDLQGUlc9MOyb+fU
         rQKxttOtQZ6zuehz8rFlBPLBlymj/l3AIABPF8VsgigY6tQnUWnC9aSmHV5exS6M+wli
         VjAIQsF5Ty87Ejf6j2Ckhk9S0pYOZ51HEZEWWU+L8F2OB/zUqv2kh0lNt3Txt5M+EQfc
         kfUJPY5IQNTwsGy/I4p0/Tb3cdkSafnhVdnCgZZ2RrwDfwrYMWkcvp64+2VZMk4LPRnf
         /2VA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1783616616; x=1784221416; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yR14oOjUi6OI2bUfX4NS8nwAQpf3oK/jBWo0jGsJb5s=;
        b=l3iLdhWm4Lr6dqmAXx3obxcvhPOTqgHUIv8dY1C7gxY+yRtL8Vp5yTkiHFol8CtjUQ
         28Az9pmVs530WZFTRWqEykBpSZX7/fmz6n/7z3GbEl//Gra+5f8kvCieYpThdRx0u3+E
         lYi2DiqPDKNfyKV0lC6z72YlC2UUObjea40RmRXh8NjEIVgLBbDEJaov7fccpa2Dzb6k
         5zIZMdJMsp/UOCbfTPUwKEVWIz4cjyV3Mr8mlqh18Ou1O5Le5ubZuFPHq76RXE6FX0W3
         gdEvzB2+RCWeJcgPeDAS3yVihAgSZQNo0AwaTVSRgIWMsjVRwsKhfrnuWB+Hyp+CUAJZ
         6QjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783616616; x=1784221416;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yR14oOjUi6OI2bUfX4NS8nwAQpf3oK/jBWo0jGsJb5s=;
        b=H307WsvmjZLK4fHqtO2fFqrtQ97ofVhSSOClw7zpL300N0BsGGR9vvX1VAcVbWAuLH
         QEfZMI/RFG4XNuYSouwqEE2tLN9j/ywX7UJ8VrAnfhCue8sIcbBtr6eXrZ0p0fjIeKG/
         aFP8CWRo+TcAX9KJfmStgk979fQUsHhkA2/GMVuamPlXSqn9c+unty7XZ3/oqrPDv88w
         XfuUGkH1nT/1t8XJHmT7c70czYo76KT6y7NsrQx3vCx3nWZ8mcKWI3e+GykSuM+nkRKL
         x27kROYHdYzR7NY3+/bljG4Dt1wMPUO/8Jl3fiIsQmWjv5Os2KnVLsKsBwPjdq9HGYQX
         Br8g==
X-Forwarded-Encrypted: i=1; AHgh+RrQ1VcdpcxpIBJdUxjPi/Fos4Zhbw07YbqhZE+aBUNl19ONr0cm+o2EIVPFwbmpa6g+9aAYc9/oD4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNcj/evumBaMRKNLIr+QVunLt80wNbsh39o49+948dCaQj+KJ6
	vznbRX8ObfDf+k63u6aHOXkYM8vfNEn7JpJKapiUEOEd9zYhjAcosro9JkmSrq/6gO4djItJC2D
	zGQ6QHTw7MN3K3AwQvHroxyJ2sm3XGAIcknrJPulc9A==
X-Gm-Gg: AfdE7cnao6Mo8wTHebw315evYvHozgqMlIYUS52cTKFsbmgmKHVHQxdWbFTNvhm8tJ2
	Tc4sWXOcmRompbwDBpim0Ns0vYWjcsHG9ulLkOMv9nygBQA6hQpH4IL0luRw0+EXljkDdgsa25i
	CWo4SHlDuR4DzS3d0PHbic5bunusG/f67YGtKpr2/Q1EPxxhUdcUXm7m/C0ElyX9to8bNCVaqC4
	Xu6OOM/U9IApQM8ILX9pk5uDF8siaIxTGlr1NFmOpsslQlu/9kDJgV1fDa624moEYl4RW3eAF7r
	qNhv8qJ2Jg9MR5eT2O3gEyMqTyuFtW53fD+kFbOJ0NS+/wqKG4HN4V/4oO2TQjSJ0hxRaTxCiDZ
	c9PL59ji7GLVA7q0mfaKnYDS2rgs4j2eBUkkge2W9ViADa2vNipnibvMu+9yK7Nj8la7HfdUvJK
	cfSsBUT3eH/N/pGby2Up3pGBUIdg5X8TO9bO4u5dZ4fB1tVLNUeXwhh3WLTfJ3xC0euIKK6AUdi
	maRiNGoVopUu8AfOHdq1gS/NlNFvP7ZFwQQh9A0Lyk4tyt2B7bBp3wjjNkodInCIBGrP/HiLJwa
	7jl9a4wZjc0xaYnoGXlkGgs69sXFUchS7UdOOmatfwH7I1YpY6LP8O8t3Q8m+AYmLLKfUQbR
X-Received: by 2002:a53:5a08:0:b0:667:8b91:2439 with SMTP id
 956f58d0204a3-6679f26f7a1mr4147877d50.104.1783616616104; Thu, 09 Jul 2026
 10:03:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701091226.7SWW4TrT@linutronix.de>
In-Reply-To: <20260701091226.7SWW4TrT@linutronix.de>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Thu, 9 Jul 2026 20:03:00 +0300
X-Gm-Features: AVVi8CeGWVzdbJXgI7g1MhHGlIvtNbOsamz5SlMClo5-ZNqp3TXp_jMt7pChNFA
Message-ID: <CAC_iWjKEcK8Z2TGCAVNU+pHLO2QvKKTmA01d-EqhE6exaTKcsQ@mail.gmail.com>
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

++Cc Jens  on his kernel.org email

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
>  The goal of this project is to validate real-time network communication.=
 It can
>  be thought of as a "cyclictest" for networking and also serves as a star=
ting
>  point for application development.
> +
> +Firmware
> +--------
> +
> +The firmware often plays a significant role in system operation because =
it can
> +perform tasks that the kernel cannot directly access, and in some cases =
it can
> +even preempt or intercept the kernel.
> +
> +A common example of firmware assisting the kernel is when it provides a =
generic
> +interface to a resource. Instead of accessing an RTC chip through an I2C=
 host
> +controller, the kernel may query the firmware for the current time, and =
the
> +firmware then accesses the RTC behind the scenes.
> +
> +Firmware can also intercept kernel execution by providing services that
> +temporarily take control of the system. One example is memory scrubbing,=
 where
> +the firmware periodically pauses the kernel, reads back portions of syst=
em
> +memory, and then returns control. During this time, the kernel is effect=
ively
> +interrupted.
> +In contrast, some systems provide hardware=E2=80=91based memory scrubbin=
g, which
> +operates independently of firmware or software. See
> +Documentation/edac/scrub.rst for details.
> +
> +If the kernel is intercepted for longer periods then these periods can b=
e made
> +visible with the hardware latency detector. See
> +Documentation/trace/hwlat_detector.rst.
> +
> +The kernel can also be intercepted in response to specific events, such =
as
> +overheating. In this case, the firmware may throttle the CPU or shut it =
down
> +immediately to prevent hardware damage.
> +
> +Unless the firmware is well documented, it should be thoroughly tested t=
o
> +uncover any unexpected behaviour.
> +
> +EFI
> +~~~~
> +
> +EFI provides runtime services that act as a communication interface betw=
een the
> +firmware and the operating system. One such service is reading and writi=
ng EFI
> +variables, which are used, for example, to determine the boot source.
> +
> +Invoking a runtime service may require the architecture to disable kerne=
l
> +preemption or interrupts during the call. This means the duration of a s=
ervice
> +invocation directly affects the system=E2=80=99s observable latency. The=
re is also
> +nothing that prevents a service call from disabling interrupts internall=
y while
> +it runs.
> +
> +For these reasons, EFI runtime services are disabled by default on a PRE=
EMPT_RT
> +kernel. They can still be enabled at boot time or via a Kconfig option i=
f
> +required.
> +The native EFI runtime service implementation (where both the EFI servic=
e and
> +the kernel are either 32=E2=80=91bit or 64=E2=80=91bit executables) uses=
 a wrapper mechanism
> +that invokes the service through a dedicated workqueue. This workqueue i=
s named
> +efi_runtime, and it can be restricted to a housekeeping CPU using the
> +``/sys/devices/virtual/workqueue/efi_runtime/cpumask`` sysfs file. Assig=
ning it
> +to a housekeeping CPU ensures that potentially long service invocations =
do not
> +impact the real=E2=80=91time workload which is restricted to other CPUs.
> +
> +It must also be verified that the runtime services behave as expected. S=
ome
> +implementations on the x86 architecture pause all other CPUs while one C=
PU
> +performs the service call. In such cases, the interruption affects all C=
PUs,
> +and restricting the workqueue to a single CPU provides no benefit.
> +
> +OP-TEE (ARM)
> +~~~~~~~~~~~~
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
> +
> +The transition from normal world -> secure monitor -> OP=E2=80=91TEE and=
 back introduces
> +additional latency due to world switching and context save/ restore. Thi=
s
> +overhead is typically a few microseconds and usually remains in the nois=
e
> +floor.
> +
> +If the secure monitor masks normal=E2=80=91world interrupts during OP=E2=
=80=91TEE invocations,
> +or if OP=E2=80=91TEE uses long=E2=80=91running secure FIQ handlers, then=
 OP=E2=80=91TEE can introduce
> +measurable latency spikes.
> --
> 2.53.0
>
