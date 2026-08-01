Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C010327707;
	Sat,  1 Aug 2026 13:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785592058; cv=none; b=EhUgsOO9nixYBTQiiFMhz2M5oj7nNtSgV+4nsSLI26OF9/GH6SkkKnBoxhVy6M+aDLcwOMSEnZ3uYna+VQNOlQZbhtGM/XltWQu11kwq2VwF2+NJJl7edf4kwiHPFXoI98KPBgTcqTTy10BRkO0zSE4nocwC9w1UEBnIJYejPCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785592058; c=relaxed/simple;
	bh=BmR8BvDLGQawpWu6SDAdqGH+HM8BZzGn9O10ZoOIdxk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=DEBWhL6ZnEyB8hyJRJh/JZuVdG/tZLHAWL+sbpvPqg87e2mIx2eiL8ilteLJ2mgLR9/LwID8PWVSu124TSbGniOpZS0WiW+zbq+KmD7f2ag5Gp1djxKipvmUvZUoXzDCS/ZdZ+PnH89M4csA0g8DCigFW01InU8fGIBk+148qg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BvJgqoCc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BvJgqoCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376FE1F00ACA;
	Sat,  1 Aug 2026 13:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785592056;
	bh=BmR8BvDLGQawpWu6SDAdqGH+HM8BZzGn9O10ZoOIdxk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=BvJgqoCcjzK0my+V6zthd8Cf7+8frrmBjl5SmbnBrzidEZgUxLJPwCA+vd+Mj1Ib7
	 HfIh5geClKeWho/6/B7zzg0XwV9LaB7dV7aPdBFZ0LPhSlIR2ptAcFsiBp96nRHypc
	 cYqne1tVNBf9srVX0UZXcWzPESjmCi8W/amSbOsREWnfsGcqIpZD8yxlqu/G4s+5/o
	 MUG2m1drMc71sN+bCwUB9P+RiTWg2Xe1+SrCdWpPfVTXvuQqQgyO/0SaqOkwFUgEzD
	 SLL9ChmWnfJJzlzaBc70pKalBlZmUuyPOa4lgIw3qi8Qchm6PzkoE1SuT83f3QJbfZ
	 FUgEeMlyBq47Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 580ACF4006B;
	Sat,  1 Aug 2026 09:47:35 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Sat, 01 Aug 2026 09:47:35 -0400
X-ME-Sender: <xms:9_htagXB4GiEAlvio3dNBfM0SsiC8r_DAY5ajsEROzcC_tsRDdQa4Q>
    <xme:9_htavaAR7dfnAQhj6knBdwPsf11S2hZOSdbFREGDgPDzkiw3fRjJNkYWmXYsh0B1
    Gu69FpgieFsL6KFCGOUHA_jJoLXBdFhLyivQw_KbjO4moSYArrk699T>
X-ME-Proxy-Cause: dmFkZTEDwg3yV68t36/NM1bZaHcUarLhsIfdyumGS1EqvAM50BJMZmr7ytOb8H1PaI3/G8
    /BG+Eru8/uVSDplKOOR4apA2xiRt5k+ancRT/frMcRZH6NR6XekVy1j1BQy/NCkDsIlM+e
    vXPZfMWtHRdCqBwYSHWhimj4spZ+p4WL4BKJ0UnBDNqUwOFgppcvBLI3OHzM9xNr0ZRXeX
    NUvHcAa5Wa5Np44YIgDeQHZBhfvc4r9dqqHmxDgCIh8d0fGkqZVspqa/06gLR7Y92IwKbO
    RQZ6U1jFETgYxYfJm3Ps+KSL3VNP34xxV/xS9uPP/wc0CRkTFb8aod2+WWVXm3BLiDc1tT
    8wLfK/rMcmDL3If8tsFIsSPQlE8puPROfTc1mY6XCpvjdDb77fyyTOxLf988vGdcAV5yVv
    fx/Y+X8hh83rgnECZQAlXGO/MKPYHWFBGkeRMKZ8jt5A0YLfd9KpyDKDfUy9iUfCFfXzDQ
    jhmK44AhNHTs90qr5DqLv7QMOy1XYx1JHv8C2r1V7bp4/xzaQESeAaaY5er3ecJHEp+fpJ
    5VlHvnmfu8sojFSBOiT6AN4lg3BTIeRw5rg1sEF7LCldB/8Z6iMgOBFYViICvEICMQONxX
    R/gLgWtIu2wYieLiDPaBrYrzFUq4IoMe9ckVQ1DVsUyn7OqKTwbEyo7Z8NqA
X-ME-Proxy: <xmx:9_htaurrbxZQTiFKw2GT6Y32gnzECDw6yfyKTVuT2YSgSc-UYlOPQA>
    <xmx:9_htaiDCPgvH3wdSIqdGyoN7Jp3Y5L5dgAgorGOvjz6Dx336BoV2uQ>
    <xmx:9_htajZOzvwX9zKeQgRzUoYWtAt14YeHb2LpwY1KSCGM2i50qsanOQ>
    <xmx:9_htat5j9o5zj4O4oeFwAS-hqVeBmzRSjbsqNBxAsG6zIEa2Yy3dUQ>
    <xmx:9_htasYj61aOu7GKgsnRzY0_dnCkFBXRGdrjETv9eM94ZvEdFxT_vjT->
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 38178182007E; Sat,  1 Aug 2026 09:47:35 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 01 Aug 2026 15:47:14 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Vincent Mailhol" <mailhol@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <0aad56b5-a650-49c6-a193-db65c4c4395e@app.fastmail.com>
In-Reply-To: <20260725-efi_stub_bli-v1-1-966e4748077f@kernel.org>
References: <20260725-efi_stub_bli-v1-1-966e4748077f@kernel.org>
Subject: Re: [PATCH] efi/libstub: populate LoaderDevicePartUUID
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Vincent,

On Sat, 25 Jul 2026, at 01:11, Vincent Mailhol wrote:
> The Boot Loader Interface [1] defines LoaderDevicePartUUID. That
> variable contains the GPT partition UUID of the device path from which
> the boot loader was loaded.
>
> This is used for example by systemd-gpt-auto-generator [2] to identify
> the disk the boot loader was launched from and automatically detect and
> mount partitions on it.
>
> GRUB populates it [3], but most EFI firmware implementations do not.
> Because of that, the variable is missing when booting the kernel from
> the EFI stub.
>
> Read the loaded image device path, extract the GUID signature from its
> GPT HD() device path node and publish it as LoaderDevicePartUUID under
> the Linux loader entry vendor GUID. Do not overwrite an existing
> variable, so a boot loader supplied value keeps precedence.
>
> Use a volatile variable with boot-service and runtime access so the
> value remains available to user space services such as systemd, without
> persisting stale boot state across resets.
>
> Install the efi_bli_set_variables() hook in both the generic efi-stub.c
> path and the x86-specific x86-stub.c path.
>
> [1] The Boot Loader Interface
> Link: https://systemd.io/BOOT_LOADER_INTERFACE/
>
> [2] systemd-gpt-auto-generator
> Link:=20
> https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-au=
to-generator.html
>
> [3] GRUB -- =C2=A716.2 bli
> Link:=20
> https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule=
.html
>
> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
> ---
> Here is a bit of extra context around this patch. I recently installed
> coreboot on my machine with edk2 as the payload. After booting the
> kernel directly from the EFI stub instead of booting it from GRUB, I
> noticed that some partitions which were previously mounted automatical=
ly
> were not mounted anymore.
>
> Upon investigation, I found that those partitions were mounted
> automatically using DPS [4]. DPS needs the LoaderDevicePartUUID EFI
> variable, which was set by GRUB but not by edk2.
>
> I first proposed a series to add that variable in edk2 [5]. The change
> was not well received because BLI is perceived as too specific to Linux
> systems. Upon reflection, I concluded that the kernel EFI stub is the
> best location to implement it because it resolves the problem for EFI
> firmware implementations in one place.
>

So it is the bootloader that sets this variable, and you want to boot
without a bootloader, right?

What about systemd-boot, does it set this variable?

