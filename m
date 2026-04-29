Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10253A3E95
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 07:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777448410; cv=none; b=IZPD92PqJza+5kEMhZxXl3mOkOST9neXz/X/yAbGRjWc4CeG9iEfQDUbB+YvTR/gKAQSt53Y+Te6xirD/ZQejK8mftwM5SnlU8V36kBLUABc58ZdOJ4MSrHVzjvilbnSGIEcCwhXYAh6nF8Q5B50no+vWE4JSzi4SFp0zxmw9Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777448410; c=relaxed/simple;
	bh=UCqsery7FiA6RyPiYCqQcY4Ghv9kx/WIcmT3SR6KMc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PsS6Xeze3dLg+gxld46jzdmijTmDghm1DJ+cI6xnkhLqGYslUiNKlJ9b4sA5H5mjEAF7MOrGytRA4WTns+QB2RzTuFmOCnm6kmpzxRdvt5nXPQPujChlw4J0bWrVGykPbj0spySUAxFA6QQ1uqHASCHgqtuzDle3JSfjoDUxdSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tNyLMWtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tNyLMWtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D73C2BCB3
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 07:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777448410;
	bh=UCqsery7FiA6RyPiYCqQcY4Ghv9kx/WIcmT3SR6KMc4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tNyLMWtHHxMX32wH1sr1JsGiWopTNVvc58Cd7+44xWtaWt/lijjJLcWQYbiDOBkTh
	 he4jsJM+MM6revtzKLrcUBznAXfZdF0dQ/KOkUkO1rB4WcwTkyq1R415JbZIiKDlS2
	 IRIy4l+xblvKm/lcXYt6VnySx3KENAmdTOyRW1InQwZcc6jBb6tWL5po5m/QIam1er
	 mehDGDrfGWOap0PG93oZdE3zAsfMwr78jSuXlDRcBz1HLHKdEzmE6jD++LS4LIYYLf
	 JlnfvMnsxuchz2ouk1prM1Cbdei9+EJv8GSxIHVzIaXEyQpXF3pD6IYHzj/CawiX75
	 L/nSWXicbhKrA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ba699316b42so1555219566b.3
        for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 00:40:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+kIqVMTYV237QFoZmnz8ZtGvK78opBhnDbekxM/Pykj0lfzraVstn8xFxDSlgkdYwmdTiaOBHCXVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzeu5XepbWK7rvp9dscYzcm4flEg9PG1l0t0YmNWxMSy5A3IQo+
	HM/MMNkgeRvFxNwVyK4d7AlsT/LrsTPFuKaFbkn6WHKfxHxScZNY0fSIYeRA0jnu8ShhiHHdt7u
	Sxtwmitfmb0hlPEQMl3ztdmdARIm49e0=
X-Received: by 2002:a17:907:d40c:b0:ba4:a7a3:d03f with SMTP id
 a640c23a62f3a-bb93e066d64mr163199066b.27.1777448409166; Wed, 29 Apr 2026
 00:40:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429051318.1581350-1-r@hev.cc> <20260429051318.1581350-4-r@hev.cc>
In-Reply-To: <20260429051318.1581350-4-r@hev.cc>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 29 Apr 2026 15:39:55 +0800
X-Gmail-Original-Message-ID: <CAAhV-H60vUx8PyT6nhxbog3=sYFL+E5Hgt1aS+7HWHddtLdb7w@mail.gmail.com>
X-Gm-Features: AVHnY4JLOsGG2e8iu-uwVAKmkVo3T34CT_mm_oxUmbiwGZfxGaocSNq5NAMJOMc
Message-ID: <CAAhV-H60vUx8PyT6nhxbog3=sYFL+E5Hgt1aS+7HWHddtLdb7w@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] LoongArch: Avoid initrd overlap during kernel relocation
To: WANG Rui <r@hev.cc>
Cc: Ard Biesheuvel <ardb@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Haiyong Sun <sunhaiyong@loongson.cn>, 
	Lisa Robinson <lisa@bytefly.space>, loongarch@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Rui,

On Wed, Apr 29, 2026 at 1:14=E2=80=AFPM WANG Rui <r@hev.cc> wrote:
>
> Validate the relocation address against the initrd region specified
> via "initrd=3D" or "initrdmem=3D" on the command line. Reject relocation
> targets that overlap the initrd to prevent memory corruption during
> early boot.
>
> Signed-off-by: WANG Rui <r@hev.cc>
> ---
>  arch/loongarch/kernel/relocate.c | 45 ++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>
> diff --git a/arch/loongarch/kernel/relocate.c b/arch/loongarch/kernel/rel=
ocate.c
> index c36604a81d08..c303c0be8f06 100644
> --- a/arch/loongarch/kernel/relocate.c
> +++ b/arch/loongarch/kernel/relocate.c
> @@ -214,14 +214,59 @@ static inline void __init *determine_relocation_add=
ress(void)
>         return RELOCATED_KASLR(destination);
>  }
>
> +static unsigned long __init try_get_initrd(unsigned long *size)
Rename to determine_initrd_address() can keep consistency.

> +{
> +       unsigned long start =3D 0;
> +       unsigned int key_length;
It's type should be "unsigned long" because strstr() returns "unsigned long=
".

Huacai

> +       const char *key;
> +       char *p;
> +
> +       key =3D "initrd=3D";
> +       key_length =3D strlen(key);
> +       p =3D strstr(boot_command_line, key);
> +
> +       if (!p) {
> +               key =3D "initrdmem=3D";
> +               key_length =3D strlen(key);
> +               p =3D strstr(boot_command_line, key);
> +       }
> +
> +       if (p =3D=3D boot_command_line || (p > boot_command_line && *(p -=
 1) =3D=3D ' ')) {
> +               char *endp;
> +
> +               p +=3D key_length;
> +               start =3D memparse(p, &endp);
> +               if (*endp =3D=3D ',')
> +                       *size =3D memparse(endp + 1, NULL);
> +       }
> +
> +       return start;
> +}
> +
>  static inline int __init relocation_addr_valid(void *location_new)
>  {
> +       unsigned long initrd_start;
> +       unsigned long initrd_size =3D 0;
> +
>         if ((unsigned long)location_new & 0x00000ffff)
>                 return 0; /* Inappropriately aligned new location */
>
>         if ((unsigned long)location_new < (unsigned long)_end)
>                 return 0; /* New location overlaps original kernel */
>
> +       initrd_start =3D try_get_initrd(&initrd_size);
> +       if (initrd_start && initrd_size) {
> +               unsigned long kernel_start;
> +               unsigned long kernel_size;
> +
> +               kernel_start =3D PHYSADDR(location_new);
> +               kernel_size =3D (unsigned long)_end - (unsigned long)_tex=
t;
> +
> +               if (kernel_start < (initrd_start + initrd_size) &&
> +                       initrd_start < (kernel_start + kernel_size))
> +                       return 0; /* Initrd overlaps kernel */
> +       }
> +
>         return 1;
>  }
>  #endif
> --
> 2.54.0
>
