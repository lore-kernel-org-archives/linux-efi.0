Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9316D43DA38
	for <linux-efi@vger.kernel.org>; Fri, 14 Aug 2026 08:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786695981; cv=none; b=pHbfvAV30XlRYS8r7/NK7ZvHh3kWEvmTffolXSQVAgAlSgyifB9q2ufqEc+dtXTuc9WypzKANrV1pb6nnUzOLTl9DpDn58FMc5iyACxkDCgQ86D9KTq5/W0PcRE4PjoBEQQo0DFl+SmpZUhl/Bkx24ra3JEUteytuF/Kc+BWRAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786695981; c=relaxed/simple;
	bh=HzfuefgkK3WPcRfwY7Hz2vbYJ7GWlbeQ4YKi4tvt5RM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y4nOKOBAB8Du0DAxQwGYGe7sQBlCEEqfTdNXRO2a88bhTXWeHja0EvmXCkXMQwggv/R+APL61jx/7T1+93P0DxIW6+vKNFfpxg4/gw+RlbGba5mu0DxgLUm1WQj8sDIIfGMyCWHp+ckXjB43QlTLOS6a6vkXoQylP1LJtjvDw1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMgOxtmN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMgOxtmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7338B1F00ADB
	for <linux-efi@vger.kernel.org>; Fri, 14 Aug 2026 08:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786695976;
	bh=+WNFzfxSWW15fOIdnEaHeTYbpQjdQsx6jTbj9dE4ksY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SMgOxtmN8Vf5EkQdQSMB+lyU6zdP5E/rVzeaMaT5tG37DvvceG22rBwtS4b3YBjJP
	 LHtiprxppMxk76P3Tqs4D2P3wkaJoyHFi9y3e8+bupmb/8bQHh0OKCECOJLmpMa6ES
	 X2ZxouX3gnn7Ahe/4T/D86o/e9/V4HlxSBV8rGnm8XQQxx/9GgKKxaVF97SzsJNfUj
	 gs8dlFaRo7VPgUqJWmlibmGcv1jTfIVtSk6ZmDdMsIfFszF5GC+uTcdNJ/OHcED9f/
	 m/dz0wP+llgLEZCa7RYZ8APKi76J7sFVFVR+Z31p4fgNuL0bbNFOjkMSjwOq5MBuEq
	 DGiLti1auW0Dg==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a3819e8be8so1306269a12.0
        for <linux-efi@vger.kernel.org>; Fri, 14 Aug 2026 01:26:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpUlMtRAUrd81cYwOtqBMUOf9XmXyckjUS8mRxNq/j9AXjkBbrN2xz/INRLjbaMJf0g0Js/qTNd3r0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqUgl0fCYvsc9OmMKKVwRurnh1XkOfNx43QDj9T54f9RwO5KLS
	ITViEJzVC7mIXLZdr1U44cHYl/CfE5JXihsznnbedG0Ze86cmudZLBLSEmlOrHJfD38zMHwfjZ9
	QEMwcn7ANTGiJi5cZYN2j3EeWLSj97CE=
X-Received: by 2002:a05:6402:324d:b0:6a1:332a:83c1 with SMTP id
 4fb4d7f45d1cf-6a38aedabdamr1544094a12.6.1786695974968; Fri, 14 Aug 2026
 01:26:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhV-H7+1bv6ULPO1+SZ5R=XFxNTh+54rqnYQUAW26kF83kiMg@mail.gmail.com>
 <20260813160307.15130-1-dongtai.guo@linux.dev>
In-Reply-To: <20260813160307.15130-1-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 14 Aug 2026 16:26:41 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7XKFj93fSPcKAR9AR6Z4O28pC9va243hVccvPNOxH3qg@mail.gmail.com>
X-Gm-Features: AUfX_mxWy0zifyMkCT_MNsH5vELQu4FCKCmOeWL2rt6IE_4N76SZIZUTr8aX0ys
Message-ID: <CAAhV-H7XKFj93fSPcKAR9AR6Z4O28pC9va243hVccvPNOxH3qg@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] selftests/kho: add LoongArch vmtest support
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	shuah@kernel.org, ardb@kernel.org, guodongtai@kylinos.cn, kernel@xen0n.name, 
	graf@amazon.com, liukexin@kylinos.cn, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 12:03=E2=80=AFAM George Guo <dongtai.guo@linux.dev>=
 wrote:
>
> Hi Huacai,
>
> On Sun, 9 Aug 2026 at 12:16, Huacai Chen <chenhuacai@kernel.org> wrote:
> > You never answer me why in your test you should disable i8042 from V1
> > until V4. In normal use we use a single kernel for both host and guest.
>
> I owe you an apology: I did not actually understand your question. I
> thought the commit message had already explained the reason (the
> i8042_flush() panic), so I treated it as answered and never addressed
> what you were really asking. Let me answer it directly now.
>
> You are right that this is not just a selftest detail. i8042 is built on
> every LoongArch kernel: arch/loongarch/Kconfig selects
> ARCH_MIGHT_HAVE_PC_SERIO, and KEYBOARD_ATKBD and MOUSE_PS2 (both default
> y) select SERIO_I8042 under it. So your "single kernel for host and
> guest" point is correct -- a normal defconfig kernel has i8042 built in.
>
> On the QEMU virtual machine there is no i8042, so PNP finds nothing and
> i8042_pnp_init() falls back to probing the i8042 status and data
> registers (I8042_STATUS_REG, I8042_DATA_REG) directly. On LoongArch those
> registers are memory-mapped, and on the virtual machine they are not back=
ed
> by any device, so i8042_flush() takes a page fault and the kernel panics
> before userspace. A normal LoongArch defconfig kernel booted as a QEMU
> guest hits the same panic -- the "# CONFIG_SERIO_I8042 is not set" in
> loongarch.conf is only a workaround to let the KHO selftest boot, not a
> fix.
>
> The real fix is separate from the KHO series: make i8042 bail out on
> LoongArch when ACPI/PNP does not describe a controller, so the direct-por=
t
> fallback never runs. I have prepared that as a standalone patch -- the
> relevant hunk is below -- and will send the full patch separately. The
> selftest workaround can be dropped once it lands.
You nearly answered nothing.

Does your employer use different kernels for host and guest in KylinOS?

Huacai

>
> diff --git a/drivers/input/serio/i8042-acpipnpio.h b/drivers/input/serio/=
i8042-acpipnpio.h
> --- a/drivers/input/serio/i8042-acpipnpio.h
> +++ b/drivers/input/serio/i8042-acpipnpio.h
> @@ -1633,8 +1633,14 @@ static int __init i8042_pnp_init(void)
>  #else
>                 pr_info("PNP: No PS/2 controller found.\n");
>  #if defined(__loongarch__)
> -               if (acpi_disabled =3D=3D 0)
> -                       return -ENODEV;
> +               /*
> +                * LoongArch legacy I/O ports are memory-mapped and are n=
ot
> +                * safely probeable when no controller is present: a dire=
ct
> +                * probe faults on the QEMU virtual machine and on any FD=
T-based
> +                * boot.  Do not fall back to probing them directly; if A=
CPI/PNP
> +                * did not describe a controller, assume there is none.
> +                */
> +               return -ENODEV;
>  #else
>                 if (x86_platform.legacy.i8042 !=3D
>                                 X86_LEGACY_I8042_EXPECTED_PRESENT)
>
> Thanks,
> George
