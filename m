Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B864E53E0B
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777303785; cv=pass; b=c65Rs/KZioQoCNsV7IWnTNqxZ1biweZE93PCHbAlStIhBUDBb2t7AX+QBy0gxEThet0Kceil2+/9kEVPolHbG/qD393TdhmVrzgQHcl3VEAajM8RfEnyFWgOkRnl+D2q46twdyGe2Icsu3h7lMg6d/9oM8n1mfzMIClhq3LAiVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777303785; c=relaxed/simple;
	bh=Eh7zr/BqVsQKOgqqfc20nbSQ8t2vvAKGnTHPEyknoz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U5NPALDUiWH2TShlud5IcyewRZkzFHHy6By1k34EqViEH96rqntWJQqfmitNKvVogBq6sO8kdgI9EjKeCk/rZCMVp2JQtl+C7HcfUWhh8w7XzBLSV91nJ77B7EDtnYh4dIViVXdOPgv0n24XofLCyoRFzMpHwLdOoH1IsshVUjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=I8YzZF3l; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="I8YzZF3l"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-65075c2ba66so8309387d50.1
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:29:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777303782; cv=none;
        d=google.com; s=arc-20240605;
        b=S8i9CXFLpXsGUOgPjgJItmv/giuq35F2aG7Ok492ENTyWY8Fz9aNTgYYpR0ysvTxub
         zqUnCXxJ0oY6Uh+p3Qd0FliKjwV0KvX9VaSqr2cTRDeoxDCddB7JT0lYRZcVDj4nFW9J
         SUjoO1jwxtA/vR+MTrmVSsI/GAQJ20LIvygvXjd05ACLEN2bbDmwTFV08L848C4QnHVl
         aGDf5/sXkUgGOhyFd6eN0IO97u4eAt+BJMQoivwSe3CHwbvuHJU2SEb8XE/x5BOWcpDp
         SnnEv4VxcUzRELwLK8TumF7nFGDFz2lVcFW/zP9QLvS/aB14+FvP9OkTe4sMkv/QyBZu
         077w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5xMIHn3yDcdr8mFbJMP8bbSm+7dOmoozq1bIImHRXXQ=;
        fh=W7vpF3A9XU/bOrqbXy1kzn64zHEpJ+8f8roVagiClbI=;
        b=h4j2w1+nx39oFCH62fFYIzyb7m/vNFquCDUYao68cqfUZ8bWEuRZQT8nHQzKPGNqbx
         tONe5fTRJDCAXfQwHOWZeOC8424AjwwYUFc4mnVSj8zBp8pTN18yYtqKmWgxPs74GsPl
         kqrecK0u1IVdjMhN14WumQ7AP2N1iPTjiLaPjv4pz0+h1IjPtT2pnUYMlZLBHJJcQlBw
         JBJo3zXj72/LIG+3xCJCt3fnDATTmlCMtRivNWZYg8XXitgsun4lJGcMZEVybIN0OXA2
         1wnFhpyxC2/taA6OHfy9Qmb29INFmWn8Yb2LEIvK7XXbvWUC2+2Y5zGme2ipu1G8BXUo
         E4yQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777303782; x=1777908582; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5xMIHn3yDcdr8mFbJMP8bbSm+7dOmoozq1bIImHRXXQ=;
        b=I8YzZF3lPpkydGo3iheBTXiaEH/x4oddCVdTac/xdidgLU3nN8nIDFRWOUl5kAveiE
         5FAnblb1nyjHKu57kExoW3W5Gb5uVJ6cOg7QzkkIAZ2bGkRcsDIPBReWnGHhkA2M0PHw
         Sd3iguxsJ8f7+UbV9JRsVmNyurCavl+g0j08Q4eU0Ua4NT493jRrxjFkQPGdPWsHkNAO
         oEOXI9gVeGUFsP1R1Ce5wNET3+vA4YwCX4QRwqdqadXtghZdsN17y0F8KPtioWuGuim2
         p8qHvsJQi2oQLvmjp+YJe6dgsh5VelH2/SsX3khqEmGOTuZ3+ulHmvMOFW1ycHq9XClX
         zGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777303782; x=1777908582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5xMIHn3yDcdr8mFbJMP8bbSm+7dOmoozq1bIImHRXXQ=;
        b=qtch5LSRvTdWBHFwPMCUbJOnDG3yGvjo9fj2HKsbLtmZH6Z2pCAQgN49hYidIXhE3l
         VuexMHIcpUpUUlwa0T9kM/+2jrd6FnECRe9wcRhgq1TPPx+zp8s4qs3RZ6LvmXwhk/Yw
         0OzI9oXFEwN+/aCCIXr1DrCM4hxkq7YGR2D+fCwG1SBc9YVv87rWOLrSpi8TdCNXfXKB
         JVU6QF2tAbadsABrjW34CvKjk8YOPgX3A28SyDFxmDAAjGZiGCE/MWMPO7dJhi+dHGlJ
         1stPJe87z1zRk6rYaKEzk+z/dpvlqVRSxP2bSIxR+IqEVbXVus5d7ZAQh0+MCnB7RY4H
         9v3Q==
X-Forwarded-Encrypted: i=1; AFNElJ/eJC9jpU4aej/R/rn2PnYIb0IzTQYta9DzULjjs5zQ8zcP/ma+QDka4RUKPf4RNtjmAFJa/RIsK2M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi4M6uvxIu4fJSmStJ6s7qpl05cWyeDNcMX2/4535Gmk8bGh1k
	2a6fbVxESA8RhKbGmLqPfMBE/NOOt3UxYlASkBMbiRmIPzGNvAy0wOweGCqAgGBX8taJUpo3cR8
	i9mktforELhGszsT3Z6GLAcRhzRxNYe9hQvkI8AeNwA==
X-Gm-Gg: AeBDiesfgWzz5c2VlXojTwVC/GtNy//pIttMgxJWrFb6OXaN4MVJ8UC30dV8bfgvIdd
	nhkVktKrQATTNmzJdigIoszmguQCKpbKfPMMPaeCLgA08PXlzXOIFR4dD2lOl8GFDP89HxjBLKl
	hnogcuizdthnBaaTTk90A3mI27LbzCA1G9xiBQjdjFc5VVkXaKaQVImHiBGnegJK/mWVlnHRoqM
	+16xisagRvbDUvrxxfdD7EOJchHiTLDHgwbzpt3M1sqFiA++Kd7faCWw8/Iuxy9AdU0XZu4I+7V
	GsQMhv8si0jKxCB8Rv7BpCk2Z7AoOYNE7pn2TNyP+CZBo54/s6U=
X-Received: by 2002:a05:690e:1a82:b0:650:18e3:d917 with SMTP id
 956f58d0204a3-653109fa086mr30305155d50.41.1777303781714; Mon, 27 Apr 2026
 08:29:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427104721.47724-1-r@hev.cc> <20260427104721.47724-3-r@hev.cc>
 <CAAhV-H4CTAZT9pChSqv_j+ZT9VXUmYh7FoBS9gKmP95BzdPB-A@mail.gmail.com>
In-Reply-To: <CAAhV-H4CTAZT9pChSqv_j+ZT9VXUmYh7FoBS9gKmP95BzdPB-A@mail.gmail.com>
From: hev <r@hev.cc>
Date: Mon, 27 Apr 2026 23:29:29 +0800
X-Gm-Features: AVHnY4JF9ErHRW973tnO9UWMquw3bXMZZrTd8v187moO4nH0MzzyEz9_0zfvkLg
Message-ID: <CAHirt9i9XAYKuDmDmpHvrHGOfT7TAnzk5Rna9h4+Hy2aCdSDDg@mail.gmail.com>
Subject: Re: [PATCH 2/3] efi/loongarch: Randomize kernel preferred address for KASLR
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, loongarch@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Huacai,

On Mon, Apr 27, 2026 at 9:27=E2=80=AFPM Huacai Chen <chenhuacai@kernel.org>=
 wrote:
>
> Hi, Rui,
>
> On Mon, Apr 27, 2026 at 6:47=E2=80=AFPM WANG Rui <r@hev.cc> wrote:
> >
> > Introduce efi_get_kimg_kaslr_address() to compute the preferred
> > kernel image address dynamically when CONFIG_RANDOMIZE_BASE is
> > enabled. The function derives a random offset using EFI-provided
> > randomness combined with the timer value, and constrains it within
> > CONFIG_RANDOMIZE_BASE_MAX_OFFSET.
> >
> > Update EFI_KIMG_PREFERRED_ADDRESS to call this helper so that the
> > EFI stub can select a randomized load address when KASLR is active,
> > while preserving the original base address behavior when KASLR is
> > disabled or nokaslr is specified.
> >
> > Signed-off-by: WANG Rui <r@hev.cc>
> > ---
> >  arch/loongarch/Kconfig                   |  2 +-
> >  arch/loongarch/include/asm/efi.h         |  4 +++-
> >  drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++++++++++
> >  3 files changed, 20 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> > index 3b042dbb2c41..a5afb70f73d9 100644
> > --- a/arch/loongarch/Kconfig
> > +++ b/arch/loongarch/Kconfig
> > @@ -730,7 +730,7 @@ config RANDOMIZE_BASE
> >  config RANDOMIZE_BASE_MAX_OFFSET
> >         hex "Maximum KASLR offset" if EXPERT
> >         depends on RANDOMIZE_BASE
> > -       range 0x0 0x10000000
> > +       range 0x20000 0x10000000
> Why modify this?

The reason for changeing the lower bound is to simplify the
random_offset calculation, making sure that
(CONFIG_RANDOMIZE_BASE_MAX_OFFSET - SZ_64K - 1) is always >=3D 0.

>
> >         default "0x01000000"
> >         help
> >           When KASLR is active, this provides the maximum offset that w=
ill
> > diff --git a/arch/loongarch/include/asm/efi.h b/arch/loongarch/include/=
asm/efi.h
> > index eddc8e79b3fa..f831320efd41 100644
> > --- a/arch/loongarch/include/asm/efi.h
> > +++ b/arch/loongarch/include/asm/efi.h
> > @@ -30,6 +30,8 @@ static inline unsigned long efi_get_kimg_min_align(vo=
id)
> >         return SZ_2M;
> >  }
> >
> > -#define EFI_KIMG_PREFERRED_ADDRESS     PHYSADDR(VMLINUX_LOAD_ADDRESS)
> > +unsigned long efi_get_kimg_kaslr_address(void);
> > +
> > +#define EFI_KIMG_PREFERRED_ADDRESS     efi_get_kimg_kaslr_address()
> Can we reuse something in drivers/firmware/efi/libstub/kaslr.c?

This aligns with the kernel's built-in KASLR, ensuring the random
range stays within CONFIG_RANDOMIZE_BASE_MAX_OFFSET. This is also why
we didn't reuse kaslr.c.

>
> >
> >  #endif /* _ASM_LOONGARCH_EFI_H */
> > diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmwar=
e/efi/libstub/loongarch.c
> > index 9825f5218137..df67ef8c68ab 100644
> > --- a/drivers/firmware/efi/libstub/loongarch.c
> > +++ b/drivers/firmware/efi/libstub/loongarch.c
> > @@ -38,6 +38,22 @@ static efi_status_t exit_boot_func(struct efi_boot_m=
emmap *map, void *priv)
> >         return EFI_SUCCESS;
> >  }
> >
> > +unsigned long efi_get_kimg_kaslr_address(void)
> > +{
> > +       unsigned int random_offset =3D 0;
> > +
> > +#ifdef CONFIG_RANDOMIZE_BASE
> > +       if (!efi_nokaslr) {
> > +               efi_get_random_bytes(sizeof(random_offset), (u8 *)&rand=
om_offset);
> > +               random_offset ^=3D (rdtime_l() << 16);
> Use get_cycles() then the first patch can be dropped.

I'll use random_get_entropy() here.

Thanks,
Rui


>
> Huacai
>
> > +               random_offset &=3D (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - =
SZ_64K - 1);
> > +               random_offset =3D ALIGN(random_offset, SZ_64K) + SZ_64K=
;
> > +       }
> > +#endif
> > +
> > +       return PHYSADDR(VMLINUX_LOAD_ADDRESS) + random_offset;
> > +}
> > +
> >  unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
> >                 efi_loaded_image_t *image)
> >  {
> > --
> > 2.54.0
> >
