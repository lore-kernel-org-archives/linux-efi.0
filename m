Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C2A3C945B
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 13:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777296589; cv=none; b=ANOO5kf/HFo0X5w0J0d+QAxdFAJuKMWb8hnvJNa+j0mbBPlgQAWARqsS6G2Iusf1ZiUH9TuWsnBhp3KfuxIYYXpZ0Bx4ml7NLXg+en1UD2KkePROneukFlP3CgaefLxzfK2Bbue3NFnIqKC8rikxJGuzGjwHoKtFF8iLOZ40LR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777296589; c=relaxed/simple;
	bh=TLxNiaHNlf+9dO1pX9aGtfhB+XX4h+RfaVxAutvDtnA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=chiDfwCQv61byyrYHfXPAFlYUQTtoKKLwY5ruXCmJp2nmz6qBtzMmeIhfAAeAyMYBBAIf3BoqDx9paThSAuIPV8Ijq39duZy4D1rOA/rDVKZlZ/YbXu4mlfzhV9vFL2QCOhakbuyzBi+TMWvD3S7NUPVMSI2mdcGEW6vo4u3OP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gn+/f9B7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gn+/f9B7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7526DC2BCB4
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 13:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777296589;
	bh=TLxNiaHNlf+9dO1pX9aGtfhB+XX4h+RfaVxAutvDtnA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Gn+/f9B70Wwp59Y/bAQcZFBwT61m5tozGxSsqnTpizhxc6isZhv6fP0FsSGSg50zf
	 s2kEEu7pZaqGs64LwsvPxzoqAoCSCXNQxaoeg/UCkwbZVgvNQ+S5/0WtRy4XNyf4e9
	 CACCtpwxwAGsDdGD8wgVe6KKHZcP+mHsZ0LaIZD3EZIXF+VQfyTsUfyn5z2mUbqrg8
	 dAIR9l5cIMZieLtrKDxJBaAwjx8wTzoIJZ0A5KyFEifVWPC7LPCjffGR8x03WKM+9v
	 n8niAZx3Ldy8CMQ/DkZ9gX+5TQQNciJC1r8Lt9GBxx1/RnOHYjg3Kklto4b4RfGnd/
	 XI2RIz3/zmN1g==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ba545100a13so1104442266b.2
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 06:29:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/nkI1Yi2allET9NDatum1uwxBN+zj4yjPvsSeZdCfG51ad3DlpVBUL1DhEe/YgLb+4ecMsEyEBuFQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLClCX6cWzhEE36aH17+DkVgoNE0/vomELbktLsV8CcezrtE3V
	jw/O7AN49b36nZ5Tn3cTKncQbZOfh0JimLeO9GYZcU3u7WY6wp8ipuBmik6Yjqn8569CzJ0LwkD
	B8+rmr6+fN22u8yN/rJj8/Wfhv2s3Sno=
X-Received: by 2002:a17:907:a607:b0:b9d:31c2:37f9 with SMTP id
 a640c23a62f3a-ba41828cbe5mr2220930666b.2.1777296588093; Mon, 27 Apr 2026
 06:29:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427104721.47724-1-r@hev.cc> <20260427104721.47724-4-r@hev.cc>
In-Reply-To: <20260427104721.47724-4-r@hev.cc>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 27 Apr 2026 21:29:40 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7+B6=Uf1ZDy9SLvWkR-ggTi3k9kFU8+B+JefWqPu4Uvw@mail.gmail.com>
X-Gm-Features: AVHnY4IYvt_kSTYJGzYTTtxR33DGrROhj_j3UUum_ag3Ft5Ju4cm05e1OPjl_0o
Message-ID: <CAAhV-H7+B6=Uf1ZDy9SLvWkR-ggTi3k9kFU8+B+JefWqPu4Uvw@mail.gmail.com>
Subject: Re: [PATCH 3/3] LoongArch: Skip relocation-time KASLR if it has
 already been applied
To: WANG Rui <r@hev.cc>
Cc: Ard Biesheuvel <ardb@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, loongarch@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Rui,

On Mon, Apr 27, 2026 at 6:47=E2=80=AFPM WANG Rui <r@hev.cc> wrote:
>
> When the kernel is relocated during early boot, a randomized load
> address may already have been selected and applied. In this case,
> performing KASLR again in relocate.c is unnecessary.
>
> Signed-off-by: WANG Rui <r@hev.cc>
> ---
>  arch/loongarch/kernel/relocate.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/loongarch/kernel/relocate.c b/arch/loongarch/kernel/rel=
ocate.c
> index 16f6a9b39659..c36604a81d08 100644
> --- a/arch/loongarch/kernel/relocate.c
> +++ b/arch/loongarch/kernel/relocate.c
> @@ -139,6 +139,10 @@ static inline __init bool kaslr_disabled(void)
>         char *str;
>         const char *builtin_cmdline =3D CONFIG_CMDLINE;
>
> +       /* KASLR is performed during early boot. */
> +       if (kaslr_offset())
> +               return true;
Maybe the "kexec_file" case is also handled by this?

Huacai

> +
>         str =3D strstr(builtin_cmdline, "nokaslr");
>         if (str =3D=3D builtin_cmdline || (str > builtin_cmdline && *(str=
 - 1) =3D=3D ' ')) {
>                 pr_info(KASLR_DISABLED_MESSAGE, "\'nokaslr\'", "built-in"=
);
> --
> 2.54.0
>
