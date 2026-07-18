Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54F51C3BFC;
	Sat, 18 Jul 2026 17:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784397052; cv=none; b=Do9C8bjoixW3D3WZ8TwTtseF/TU/t51VWg1/jbJG0+2YTafB3xPHDCWIbRoCSADF05H6AYORzcfysd3WcjvdLREPFbGbfI2FbFX08AHDnuOsQL7rT4EeAq3tFVB82XwF86mrxTj+xpRrgqq2Kln3oxEqGWiTDXWk7imenkr8zJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784397052; c=relaxed/simple;
	bh=zj4qSNDtULYDhnhA07hGtlgRFL5SaSzumHLu5l9GxG4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UTWMJAgAuEIlHy5ypAS+nYOiYCmOxqp0sMZRoeTqZgXCaP8LOFtp/+ycgMJmSYu6tEkYN7HoKYZrrceOxtsQM+P334LldhKW/A8rwElL+QtD0VX/Qmumq5g/5n1+ShHr1dZ/GBOTOozozuG/thvuwsB1AmRnG1FiNj76OiQun1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=UjRGUH1e; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Y3DZm8us; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UjRGUH1e";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Y3DZm8us"
Date: Sat, 18 Jul 2026 19:50:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1784397042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HnCRoTidLdTf7uGb5+cyEo3j85yiTiGjdgCJTfUNd9A=;
	b=UjRGUH1ewnXDB+7bA3vY6bllDRkAsrRs0EJiAw/WLA8f8siIUfzo2kcwtLuilIO16djMt9
	vyKB0nvQ51/ASWbhyRPEEywx9XHjDyGmn/cAaneOGvH9pWseHX1wHgUbsGXmz9O1s4UhWB
	He3WU+uQL79LQt5RQ0Pr7Ra7ckplXiZw4qjQOy41x66R9GlggrEP7CkWmn9r4W7REjUlW2
	ZdhtWGPRQ+StUxCM0E4uaRc6+OE7ab15WIvTzRfeZRHm7RgWsN2RvkUWNnlzDz7AxV6zF1
	IGY3Hh1WVeqKrgzjBdg2RK3g+gOS/ubuP76SSQhzE+CYpxPgkoQqQHN32pY5Tg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1784397042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HnCRoTidLdTf7uGb5+cyEo3j85yiTiGjdgCJTfUNd9A=;
	b=Y3DZm8usu39GZQIHABG8FHwW08JUSpfhXzvxxmIvKt0c/W5XTtRbzRJc5w25addlSNighs
	AMwxxIkmKgs3rKDw==
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
Subject: [PATCH v2] Documentation: Extend the real-time hardware bits with
 some firmware bits
Message-ID: <20260718175041.QXn9iOFK@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I have been reviewing how OP=E2=80=91TEE is implemented and how secure=E2=
=80=91world
invocations behave. The goal was to determine whether an OP=E2=80=91TEE cal=
l can
delay the Linux side and introduce latency depending on the time spent
in the secure world.

Similar latency effects are already known for EFI runtime services, but
this was not documented. To mitigate the impact, EFI runtime invocations
can be restricted to specific CPUs so that real=E2=80=91time workloads on o=
ther
CPUs remain unaffected. This mechanism, however, is only described in
the commit that introduced it.

This change adds a firmware section that documents these behaviours
explicitly. It highlights cases where firmware can delay the kernel,
information that may be unfamiliar to some users and surprising-or
concerning-to others.

Assisted-by: Microsoft-Copilot
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

v1=E2=80=A6v2: https://lore.kernel.org/all/20260701091226.7SWW4TrT@linutron=
ix.de
- Rewrote the OP-TEE bits after some feedback from Ilias and Jens.
  Added a link to the TF-A/OP-TEE documentation. The main difference is
  that in contrast to my initial belief, OP-TEE can disable
  normal-world's interrupts and it is not guaranteed that normal world
  can always preempt the secure world.

 Documentation/core-api/real-time/hardware.rst | 104 ++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/Documentation/core-api/real-time/hardware.rst b/Documentation/=
core-api/real-time/hardware.rst
index 19f9bb3786e03..9f95e75e6aa18 100644
--- a/Documentation/core-api/real-time/hardware.rst
+++ b/Documentation/core-api/real-time/hardware.rst
@@ -130,3 +130,107 @@ https://github.com/Linutronix/RTC-Testbench.
 The goal of this project is to validate real-time network communication. I=
t can
 be thought of as a "cyclictest" for networking and also serves as a starti=
ng
 point for application development.
+
+Firmware
+--------
+
+The firmware often plays a significant role in system operation because it=
 can
+perform tasks that the kernel cannot directly access, and in some cases it=
 can
+even preempt or intercept the kernel.
+
+A common example of firmware assisting the kernel is when it provides a ge=
neric
+interface to a resource. Instead of accessing an RTC chip through an I2C h=
ost
+controller, the kernel may query the firmware for the current time, and the
+firmware then accesses the RTC behind the scenes.
+
+Firmware can also intercept kernel execution by providing services that
+temporarily take control of the system. One example is memory scrubbing, w=
here
+the firmware periodically pauses the kernel, reads back portions of system
+memory, and then returns control. During this time, the kernel is effectiv=
ely
+interrupted.
+In contrast, some systems provide hardware-based memory scrubbing, which
+operates independently of firmware or software. See
+Documentation/edac/scrub.rst for details.
+
+If the kernel is intercepted for longer periods then these periods can be =
made
+visible with the hardware latency detector. See
+Documentation/trace/hwlat_detector.rst.
+
+The kernel can also be intercepted in response to specific events, such as
+overheating. In this case, the firmware may throttle the CPU or shut it do=
wn
+immediately to prevent hardware damage.
+
+Unless the firmware is well documented, it should be thoroughly tested to
+uncover any unexpected behaviour.
+
+EFI
+~~~~
+
+EFI provides runtime services that act as a communication interface betwee=
n the
+firmware and the operating system. One such service is reading and writing=
 EFI
+variables, which are used, for example, to determine the boot source.
+
+Invoking a runtime service may require the architecture to disable kernel
+preemption or interrupts during the call. This means the duration of a ser=
vice
+invocation directly affects the system=E2=80=99s observable latency. There=
 is also
+nothing that prevents a service call from disabling interrupts internally =
while
+it runs.
+
+For these reasons, EFI runtime services are disabled by default on a PREEM=
PT_RT
+kernel. They can still be enabled at boot time or via a Kconfig option if
+required.
+The native EFI runtime service implementation (where both the EFI service =
and
+the kernel are either 32-bit or 64-bit executables) uses a wrapper mechani=
sm
+that invokes the service through a dedicated workqueue. This workqueue is =
named
+efi_runtime, and it can be restricted to a housekeeping CPU using the
+``/sys/devices/virtual/workqueue/efi_runtime/cpumask`` sysfs file. Assigni=
ng it
+to a housekeeping CPU ensures that potentially long service invocations do=
 not
+impact the real-time workload which is restricted to other CPUs.
+
+It must also be verified that the runtime services behave as expected. Some
+implementations on the x86 architecture pause all other CPUs while one CPU
+performs the service call. In such cases, the interruption affects all CPU=
s,
+and restricting the workqueue to a single CPU provides no benefit.
+
+OP-TEE (ARM)
+~~~~~~~~~~~~
+
+Execution flows from the normal world (Linux) into the secure world (OP-TE=
E)
+through the secure monitor at EL3. The transition is initiated by the `smc`
+(Secure Monitor Call) opcode or the `hvc` (Hypervisor Call) opcode together
+with a function identifier. The calling convention defines two types of ca=
lls:
+**yielding calls** and **fast calls**:
+
+- A **yielding call** unmasks interrupts before handling the requested ser=
vice,
+  allowing normal world interrupts to occur.
+- A **fast call** handles the requested service atomically, without allowi=
ng
+  interrupts from either the normal world or the secure world.
+
+In addition, the secure world (EL3 and OP-TEE) can receive interrupts rout=
ed to
+the secure world. While a secure world interrupt is being serviced,
+normal world interrupts are masked and cannot preempt the operation.
+
+The transition from normal world to secure monitor to OP-TEE and back intr=
oduces
+additional latency due to world switching and context save/restore. This
+overhead is typically a few microseconds and usually remains within the no=
ise
+floor.
+
+It is worth noting that the normal world cannot mask secure interrupts, wh=
ile
+the secure world can mask normal-world interrupts during execution. How OP=
-TEE
+affects real-time workloads depends on whether secure interrupts are enabl=
ed
+and which OP-TEE services are invoked.
+
+A practical concern is any fast call that runs longer than expected, for
+example a function that occasionally performs a long-running cryptographic
+computation. Another example that may block in an unexpected way are OP-TEE
+drivers that issue RPC requests. An OP-TEE service in the secure world (RP=
MB
+for instance) may need to issue a request back to the normal world (the Li=
nux
+driver) in order to complete the operation. While Linux remains preemptibl=
e,
+the thread that issued the request stays blocked until the RPC completes a=
nd
+the secure function call returns.
+
+The TF-A project provides documentation on interrupt management:
+https://trustedfirmware-a.readthedocs.io/en/latest/design/interrupt-framew=
ork-design.html#interrupt-management-framework
+
+The OP-TEE project provides documentation on how interrupts are handled:
+https://optee.readthedocs.io/en/latest/architecture/core.html#interrupt-ha=
ndling
--=20
2.53.0

