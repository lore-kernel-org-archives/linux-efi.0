Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0299416842;
	Thu, 13 Aug 2026 08:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609445; cv=none; b=uj7juC9bPsJMx1UGi8Nlm89KRKJjW3opqleKWlg4L25yWYDCJIwRXmD3Wj1wwe1IgQlD15+fF/NEOOXpIk/tLcYTUGp6oaTzAlWHvJ7tBUBDGO5uS3lRyGeMYa+7KNiuXZZ5ZcwfA8GuONrgzyAPQafEynJOpwy/hTNSC8jkFDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609445; c=relaxed/simple;
	bh=ww8uoNQD3JIBD+QBt/Ffb6zloN8oV6rZBUALO/hFyEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I6QCv4OEFiSu2dqtiSzpnPCGKaIEdyxZ55Jlsiw64X+ogvJqlKADJvBaoWFcig68avZUaZc/TRx3fHYW9aKxz23YoCx9zICvg+j9IwepBhuUC6R5ad4Tv4QH7mxFZoRarLvwUggXu5pZOqpDvgFlJtL6sADre8+F6pnfqsgcqyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=HPBFkWdQ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=QqoGeluW; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="HPBFkWdQ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QqoGeluW"
Date: Thu, 13 Aug 2026 10:24:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1786609441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WgGrLejC/Wl2+WhXMuuc0iT3zV3dVs7KdU/reo4Z37o=;
	b=HPBFkWdQ2XeGEQL/UgiUcUbqKUCKwfNQMUpfU5SKlRxONkIg53Jz5yokbV/k2wmKnvUbZS
	xD9xG7reIeqh2a7MQzJfdZXc8I0LQ5tiKK22mXbuhKpX1t3AcdS+aFjfRtQNOAl51jAqvg
	mnv6QzpEFcXXYhFMXE+lvAbeuqu/ciBaLz5YaL8psJ4BZ4sPSatc2kqFt2TEWt3qecprDu
	DPogx+PLFyBbDwGQBpyeo/yE4/7ZWoDBRkH8ZimyJTp9TbRVDsiIT1HhTNjJB9OJ+jCWA1
	zUz2BUCQhqpK2PCdROCynHzVgSm2bNkJSfQR8ibUVT2LcM7aofx1RVCFdtG2Qg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1786609441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WgGrLejC/Wl2+WhXMuuc0iT3zV3dVs7KdU/reo4Z37o=;
	b=QqoGeluWujyf4fFkVD0/6xNXp2XJiOFBZhubgQuFJ+l1sGRMqYpi9L0yNbsZZqE2hJL7xo
	NCofQLSwcnkz/4AQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-devel@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"jenswi@kernel.org" <jenswi@kernel.org>,
	op-tee@lists.trustedfirmware.org, Ard Biesheuvel <ardb@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v2] Documentation: Extend the real-time hardware bits
 with some firmware bits
Message-ID: <20260813082400.h3MRgRPg@linutronix.de>
References: <20260718175041.QXn9iOFK@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260718175041.QXn9iOFK@linutronix.de>

A gentle ping.

On 2026-07-18 19:50:41 [+0200], To linux-rt-devel@lists.linux.dev wrote:
> I have been reviewing how OP=E2=80=91TEE is implemented and how secure=E2=
=80=91world
> invocations behave. The goal was to determine whether an OP=E2=80=91TEE c=
all can
> delay the Linux side and introduce latency depending on the time spent
> in the secure world.
>=20
> Similar latency effects are already known for EFI runtime services, but
> this was not documented. To mitigate the impact, EFI runtime invocations
> can be restricted to specific CPUs so that real=E2=80=91time workloads on=
 other
> CPUs remain unaffected. This mechanism, however, is only described in
> the commit that introduced it.
>=20
> This change adds a firmware section that documents these behaviours
> explicitly. It highlights cases where firmware can delay the kernel,
> information that may be unfamiliar to some users and surprising-or
> concerning-to others.
>=20
> Assisted-by: Microsoft-Copilot
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>=20
> v1=E2=80=A6v2: https://lore.kernel.org/all/20260701091226.7SWW4TrT@linutr=
onix.de
> - Rewrote the OP-TEE bits after some feedback from Ilias and Jens.
>   Added a link to the TF-A/OP-TEE documentation. The main difference is
>   that in contrast to my initial belief, OP-TEE can disable
>   normal-world's interrupts and it is not guaranteed that normal world
>   can always preempt the secure world.
>=20
>  Documentation/core-api/real-time/hardware.rst | 104 ++++++++++++++++++
>  1 file changed, 104 insertions(+)
>=20
> diff --git a/Documentation/core-api/real-time/hardware.rst b/Documentatio=
n/core-api/real-time/hardware.rst
> index 19f9bb3786e03..9f95e75e6aa18 100644
> --- a/Documentation/core-api/real-time/hardware.rst
> +++ b/Documentation/core-api/real-time/hardware.rst
> @@ -130,3 +130,107 @@ https://github.com/Linutronix/RTC-Testbench.
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
> +In contrast, some systems provide hardware-based memory scrubbing, which
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
> +Unless the firmware is well documented, it should be thoroughly tested to
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
> +Invoking a runtime service may require the architecture to disable kernel
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
> +kernel. They can still be enabled at boot time or via a Kconfig option if
> +required.
> +The native EFI runtime service implementation (where both the EFI servic=
e and
> +the kernel are either 32-bit or 64-bit executables) uses a wrapper mecha=
nism
> +that invokes the service through a dedicated workqueue. This workqueue i=
s named
> +efi_runtime, and it can be restricted to a housekeeping CPU using the
> +``/sys/devices/virtual/workqueue/efi_runtime/cpumask`` sysfs file. Assig=
ning it
> +to a housekeeping CPU ensures that potentially long service invocations =
do not
> +impact the real-time workload which is restricted to other CPUs.
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
> +Execution flows from the normal world (Linux) into the secure world (OP-=
TEE)
> +through the secure monitor at EL3. The transition is initiated by the `s=
mc`
> +(Secure Monitor Call) opcode or the `hvc` (Hypervisor Call) opcode toget=
her
> +with a function identifier. The calling convention defines two types of =
calls:
> +**yielding calls** and **fast calls**:
> +
> +- A **yielding call** unmasks interrupts before handling the requested s=
ervice,
> +  allowing normal world interrupts to occur.
> +- A **fast call** handles the requested service atomically, without allo=
wing
> +  interrupts from either the normal world or the secure world.
> +
> +In addition, the secure world (EL3 and OP-TEE) can receive interrupts ro=
uted to
> +the secure world. While a secure world interrupt is being serviced,
> +normal world interrupts are masked and cannot preempt the operation.
> +
> +The transition from normal world to secure monitor to OP-TEE and back in=
troduces
> +additional latency due to world switching and context save/restore. This
> +overhead is typically a few microseconds and usually remains within the =
noise
> +floor.
> +
> +It is worth noting that the normal world cannot mask secure interrupts, =
while
> +the secure world can mask normal-world interrupts during execution. How =
OP-TEE
> +affects real-time workloads depends on whether secure interrupts are ena=
bled
> +and which OP-TEE services are invoked.
> +
> +A practical concern is any fast call that runs longer than expected, for
> +example a function that occasionally performs a long-running cryptograph=
ic
> +computation. Another example that may block in an unexpected way are OP-=
TEE
> +drivers that issue RPC requests. An OP-TEE service in the secure world (=
RPMB
> +for instance) may need to issue a request back to the normal world (the =
Linux
> +driver) in order to complete the operation. While Linux remains preempti=
ble,
> +the thread that issued the request stays blocked until the RPC completes=
 and
> +the secure function call returns.
> +
> +The TF-A project provides documentation on interrupt management:
> +https://trustedfirmware-a.readthedocs.io/en/latest/design/interrupt-fram=
ework-design.html#interrupt-management-framework
> +
> +The OP-TEE project provides documentation on how interrupts are handled:
> +https://optee.readthedocs.io/en/latest/architecture/core.html#interrupt-=
handling
> --=20
> 2.53.0
>=20
>=20
