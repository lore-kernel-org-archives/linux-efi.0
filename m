Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795746520;
	b=Cxj5oFHXjbn/lJeXVQ40t1nPulkqPNSClKH26fyDFb0zOu1xK0JnctlIAjOkUKSwyD2V
	 sBanQZuPmPDeF0gHn9GvoEpux6gA8TYAp/tHDAqtSYl2Hs9wS25TykjpyR+8N4kHEOKwe
	 6DvkEFg1PmMvoB/BON+PExCVH2QhfXsSPjWNVpU/bAnG+cWQLTiiBi/GKlYFiqguDieHg
	 WtYVEjL6rVJnKsCMXbb2B8N/pVfRPWvpwG0NCZ2NxYy6thIf7R6AB/Px3dNkYbeQyzrpx
	 FiKlAIYeuzXBLjfmp4Uepksuq14YEc0GghT6DM1l9d7yB5xw8KpwubHNtl3IEZSIPPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795746520;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=YVNe8mhn9QJyILwYcZB6LPXFhX67aWAwXGkyrU4Q77s=;
	b=t4wdrH+SfcsVx3XA7xnOluFGMxnR/z1+WgENKzzUzGCx3DN0k6wX0U5viqSVdE0/aui2
	 1AO0BqCxkkPmaiz1PGzkmVy+coqHs8t26eLt/dZpMFQcDAF1wb6IZzGhuOyi5XgpkNFHq
	 vgp1s8126xVV/ZH3b/7ZwhpMn5r/ATjbGk726whTWSBbdwoeEak37zQqpFLso3xT1GA5I
	 VdoZWY80854y08cDLvOGEZUxFJvAQvmqPNLRIZqlsHuoa3n5pCzzXnCTNifcUpBIIi4/C
	 s+qFOi+gCbNBoAv0p329LmAM1L4r4Wc1kDa7x+y8KI6bTCRbdBxNKZie+UzADSE/SMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=neJ+s76E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E424606A323
	for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 02:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=neJ+s76E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A581F000C1
	for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 02:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795746519;
	bh=YVNe8mhn9QJyILwYcZB6LPXFhX67aWAwXGkyrU4Q77s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=neJ+s76EAm8N5xVxBerE1c05QvCUlG1/uHzUSpKPavJn0uuO8ImccLGclbxdfbyA5
	 aRYyQ/k2Y9drH6EdR5EUqwDxH543w01GHl51T/e+FOaInoFQA0v5Bt7i3InC5i/Aic
	 lmZIq/UjUF4qETQRO+TM2qpSFrfFYReZocqu+EfZ9aGsBbYZfDs01GrsM630r13qor
	 yguDfwGFA8Dsk4+RaC3rI2bSpe7ZEtXUvf6tGpO0ASpIJdYWFbCXZ3JFIUHH2QQz69
	 3p6gpAfJ8mAAmMSTLvgjoHrlnvfsxSxs44Ulzrg+9UCeIoNuLENrVtyp+8DApI7RuT
	 jZh1JenUAF+VQ==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6ba38c41804so9064867a12.3
        for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 18:28:39 -0800 (PST)
X-Gm-Message-State: APuU4Z+/Rmv21LZA65WxHUTdRhyItRbOypAsGK9BUEF5nYB1q2VCV5Em
	0xeM7lhP+6O5S349A12kpfq/y1izDBCjBYesKkNpNLg660DctQ3dntK5qP67Y9Vim1wQZykpd8P
	mPdwcNkObRMFIyQ2A+H6na5DBoANXxq0=
X-Received: by 2002:a05:6402:42c8:b0:6ba:9b7c:d897 with SMTP id
 4fb4d7f45d1cf-6ba9b7ce6c6mr11754961a12.33.1795746518388; Thu, 26 Nov 2026
 18:28:38 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126155017.2401147-5-ardb+git@google.com> <20261126155017.2401147-8-ardb+git@google.com>
In-Reply-To: <20261126155017.2401147-8-ardb+git@google.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 27 Nov 2026 10:28:27 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5fd2K4WTPRSe7bdX3fgqxcC_MkOzwrxfMk1xnJdBW=Yg@mail.gmail.com>
X-Gm-Features: Aa3M54oGQCKOCzrSK42tCJtjPGACWm64JVdOahutBp8ppxToRuoy47-brnsnqk4
Message-ID: <CAAhV-H5fd2K4WTPRSe7bdX3fgqxcC_MkOzwrxfMk1xnJdBW=Yg@mail.gmail.com>
Subject: Re: [PATCH 3/3] efi/libstub: Provide library helpers only where needed
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, loongarch@lists.linux.dev, 
	Ard Biesheuvel <ardb@kernel.org>, Dmitry Antipov <dmantipov@yandex.ru>, WANG Xuerui <kernel@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Ard,

Does this series wan to solve the same problem as below?
https://lore.kernel.org/loongarch/97a95c9d-6736-4eee-ac9d-cbfb47d60492@app.=
fastmail.com/T/#t

On Thu, Nov 26, 2026 at 11:50=E2=80=AFPM Ard Biesheuvel <ardb+git@google.co=
m> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Now that dead stub code is being eliminated by the linker, the only
> remaining user of the 64-bit left shift and clz/ctz helper routines is
> ZSTD compression, and only in some cases:
>
> - the 64-bit left shift is only needed on 32-bit architectures
> - the clz/ctz helper is needed on all RISC-V and 32-bit reduced
>   LoongArch
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/firmware/efi/libstub/Makefile | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi=
/libstub/Makefile
> index 20b5b77956d1..ba6d67e5cd78 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -98,14 +98,15 @@ CFLAGS_arm32-stub.o         :=3D -DTEXT_OFFSET=3D$(TE=
XT_OFFSET)
>
>  zboot-obj-y                    :=3D zboot-decompress-gzip.o
>  CFLAGS_zboot-decompress-gzip.o +=3D -I$(srctree)/lib/zlib_inflate
> -zboot-obj-$(CONFIG_KERNEL_ZSTD)        :=3D zboot-decompress-zstd.o lib-=
xxhash.o
> +
> +zstd-obj-$(CONFIG_32BIT)       :=3D lib-ashldi3.o
> +zstd-obj-$(CONFIG_RISCV)       +=3D lib-clz_ctz.o
> +zstd-obj-$(CONFIG_32BIT_REDUCED) +=3D lib-clz_ctz.o # loongarch
I don't want to use CONFIG_32BIT_REDUCED outside arch/loongarch, can
we use CONFIG_LOONGARCH which is similar  to RISCV?

And it seems the first patch can be folded with this one...

Huacai

> +zboot-obj-$(CONFIG_KERNEL_ZSTD)        :=3D zboot-decompress-zstd.o lib-=
xxhash.o \
> +                                  $(zstd-obj-y)
>  CFLAGS_zboot-decompress-zstd.o +=3D -I$(srctree)/lib/zstd
>
> -zboot-riscv-obj-$(CONFIG_32BIT)        :=3D lib-ashldi3.o lib-lshrdi3.o
> -zboot-obj-$(CONFIG_RISCV)      +=3D lib-clz_ctz.o $(zboot-riscv-obj-y)
> -zboot-obj-$(CONFIG_LOONGARCH)  +=3D lib-clz_ctz.o
>  lib-$(CONFIG_EFI_ZBOOT)                +=3D zboot.o $(zboot-obj-y)
> -
>  lib-$(CONFIG_UNACCEPTED_MEMORY) +=3D unaccepted_memory.o bitmap.o find.o
>
>  targets                                :=3D $(lib-y)
> --
> 2.56.1.839.g22a8290db9-goog
>
>
