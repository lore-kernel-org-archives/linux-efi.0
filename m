Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DA038C414
	for <linux-efi@vger.kernel.org>; Sat,  9 May 2026 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778335853; cv=none; b=gQvgTD/Rrk68LnbrlMBsZ7tpwdkg0aqahFu1LDDE0dfclN55HOICYL7rbxw1xX0cDZoBuoXc9JZBN41IBUaIlm948ATl0If/meHLApldnCOoMZ9kL+01Ydfq2AzTbA38gfPhKBjKyKGgNgIgYpHqB6fzCQo502usJ2juxAORO3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778335853; c=relaxed/simple;
	bh=UeQXTH2Hl6E7ZPb1ttdaJuQX0gSzaAcJcdC0k2iGNI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M6BWMOnshcu9+z6exW1hLy3IBPuWNOlNgLZOGU/1VaQ7zvoNm9KtBiLOWuRiSgAkdq5Bmem8Wz3poPfxyedUo+OFn/+vpVGm3YMKi9hjNDLg9vpvaWZ+hQ18gli+bQPqfumokED9Cmj/iaSlSPsuICdf61biWuqQsmtfQUdDeYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TItH15u/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TItH15u/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BCAC2BCC7
	for <linux-efi@vger.kernel.org>; Sat,  9 May 2026 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778335853;
	bh=UeQXTH2Hl6E7ZPb1ttdaJuQX0gSzaAcJcdC0k2iGNI4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TItH15u/YYbNaiKC00+xtaMoZ+Qq+yK/BRS5in/vSxPMW+HV1ubm3zLJoluaFIDd7
	 ncDd552pM3epY0ZJzqMOumbrB91rZeJzndA3OVoc2IVyox9IkGQGMH0S4Kg2lkgE8W
	 ucyJo6RYUZW0NpzM1ABQ1C2cEbVQTwBf+sIVORzW8U/wcaOH+tKkDYnIv53+mlt4aL
	 iOOTnmmmk8EzGDhXI5qwJaf4GcU4GzJ46eT7xvHq0iSZqWq3G08TG3jLWko4J07fls
	 AkklqWN+Jnos6mmQzHb7HXNVHZXYgfC8BQAW9emwZDJpdoq9IPENdTE9/dDX4ebvKU
	 FI7lIhi093xrw==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67c2b4809baso5552068a12.3
        for <linux-efi@vger.kernel.org>; Sat, 09 May 2026 07:10:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+whbCKDhjJKnVdIJBpuJXbXfCCgSFnw8Kir+0UAHm8g17K2BUyy/7JPunWfgzIzYWA5Sw/YT25Cz0=@vger.kernel.org
X-Gm-Message-State: AOJu0YydBBiUe2h02MukW5LclFvnE5aZURiEpwIzmFDg9S25vDrXQBtL
	WI44TCi0VlE3MCCmEcJkydP5nWnoURHNGaeiENLIa1CNidqnH67wLiHplht5X1/ukuPi6i50ANT
	m8wwGWBz6MAhw4D5Fxxi9zhLZtfz3WOk=
X-Received: by 2002:a05:6402:540c:b0:66e:43ef:2951 with SMTP id
 4fb4d7f45d1cf-67d638ae7d5mr8896993a12.4.1778335851883; Sat, 09 May 2026
 07:10:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429120300.1786210-1-r@hev.cc>
In-Reply-To: <20260429120300.1786210-1-r@hev.cc>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 9 May 2026 22:10:40 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7yU4Vf6K+f164_QWBkvNn4MzyzFDrCXsOmS=NnA9YmqA@mail.gmail.com>
X-Gm-Features: AVHnY4LXCZn7F2RcOp_hxC3GcHBxrmo2RdvstXmHYlz8-c1bcgasMesHiyy5XJs
Message-ID: <CAAhV-H7yU4Vf6K+f164_QWBkvNn4MzyzFDrCXsOmS=NnA9YmqA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] LoongArch: Move KASLR to EFI stub to avoid initrd overlap
To: WANG Rui <r@hev.cc>
Cc: Ard Biesheuvel <ardb@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Haiyong Sun <sunhaiyong@loongson.cn>, 
	Lisa Robinson <lisa@bytefly.space>, loongarch@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.

Huacai

On Wed, Apr 29, 2026 at 8:03=E2=80=AFPM WANG Rui <r@hev.cc> wrote:
>
> Changes since [v3]:
>   * Minor cleanups based on review comments.
>
> Changes since [v2]:
>   * Add a new patch to prevent initrd overlap during relocation.
>   * Revert changes to the CONFIG_RANDOMIZE_BASE_MAX_OFFSET range.
>
> Changes since [v1]:
>   * Drop the patch "LoongArch: Allow rdtime_h() and rdtime_l() in 64-bit =
builds".
>   * Use random_get_entropy() instead of rdtime_l().
>
> This series addresses a potential overlap issue between the kernel
> image and the initrd when KASLR is enabled.
>
> In the normal boot flow, the bootloader is responsible for loading
> both vmlinux and the initrd, and it can guarantee that the two do
> not overlap in memory. However, this assumption only holds as long
> as neither image changes its location afterwards.
>
> The in-kernel KASLR implementation breaks that assumption. When the
> initrd is placed close to the kernel image, randomizing the kernel
> location at runtime may move it into the initrd region, leading to
> memory corruption early during boot.
>
> To fix this, this series moves the KASLR logic out of the kernel
> proper and into the EFI stub. With this change, the final placement
> of both the kernel image and the initrd is determined by the EFI
> memory allocator. This ensures that the two allocations are
> coordinated and cannot overlap.
>
> Functionally, the kernel still supports KASLR as before, but the
> randomization now happens before the kernel is entered, rather than
> during early kernel relocation.
>
> [v3]: https://lore.kernel.org/loongarch/20260429051318.1581350-1-r@hev.cc
> [v2]: https://lore.kernel.org/loongarch/20260428040159.1065822-1-r@hev.cc
> [v1]: https://lore.kernel.org/loongarch/20260427104721.47724-1-r@hev.cc
>
> WANG Rui (3):
>   efi/loongarch: Randomize kernel preferred address for KASLR
>   LoongArch: Skip relocation-time KASLR if it has already been applied
>   LoongArch: Avoid initrd overlap during kernel relocation
>
>  arch/loongarch/include/asm/efi.h         |  4 +-
>  arch/loongarch/kernel/relocate.c         | 49 ++++++++++++++++++++++++
>  drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++
>  3 files changed, 68 insertions(+), 1 deletion(-)
>
> --
> 2.54.0
>
>
