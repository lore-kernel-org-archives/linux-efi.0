Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68F335B653
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 07:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777276176; cv=pass; b=XxLnRQ6bFSn0KhmaL2/EZ8FkTqR2i5TsvqncB1/kCxJ5xoUoSvF1wpR8M6d8d6pbG6DKy82ET4NAYBkA/Uyuo2vGcN8F4P+T0hmUg6B5TTSgJFkaXcxUTk2jRZITMtn5FkemJbw1tGsdhPeomyVIz3g/4FWLq9fzlxfvvzfRY9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777276176; c=relaxed/simple;
	bh=wkYbww2o5xmCP3bgyEgxz6IUQJUNogIt6RMdvCb7Ykw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qvgOJhne1393FxQwow9ha+gaZ/R9VQ2YXFypEaeQ2hYQL+G9aTKiO2F9H7m3fejPwuzb0ai/oEMGRE02yJAQstieLj81e2un/L3wwNVKOsY09SsUbDyoFyA32A9HAwzu1NG2zp+bi7wL8+9cc57E2nwZUYn/ZoROx4fsp6EqwMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=ek7k4mRe; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="ek7k4mRe"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6501725d888so7908479d50.0
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 00:49:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777276174; cv=none;
        d=google.com; s=arc-20240605;
        b=isaTcMgL4A7xSRYgSS8LY6OTdew458o8AJl4GgA3n9BZJ/AJ433T5o7lROxMzfjkwJ
         sASDSD0XX/9zA3fGz7+xwarDwr/z9PUv6u9q1wghRKnAnewr/daeR4+RnTJ73hLIqbjd
         IuvzCm3TeOFAdSeDoKHfq9Q7CIzw7HdZ39QF4J5bSPpzdr0nxxvg4UeT6mhhp8kwaPgn
         EKzKfaCa4iyJxr/2e4/mr/jkmXoI9PSXVuHGiu0+Hlr/drpXL9f4I5dEzopdGn8ORFBb
         f0VbEbXNSMy3TvMfvN+Dk+pDgtW9Pj50xpHsmnv3zRMOEwNULOVVUVZ1ewHP0saltjzC
         Uafg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ek9ChqVeqeA30OwQ3fqBFJmD6gbZl8V4G3Ph/Tn1DBw=;
        fh=HEcGAwdruEJRa34aNOQvJ4OdwlRlcijuT//GWXOl5RM=;
        b=cWLf3xXXrwoyuY4tzXQZXiTbeaO6eelHxAowQ8vNXUoHiXfDBALYR0tYm6e1yQ2w83
         ZhM+WZNERlUik94B9daAMR0LHgRj10POXbllbn9BXRehXWe+2A7PgvrgAj1ByPDpe9j/
         MYi/I7qin9/GmrIZzlOAzA57xGolXruKENIJnCERYPrI3pm94nXC1YpaK8BVxH5QcHti
         LP4kCHylHrBaqxtPg7pK75CH5LTEBEgBvby6bfnD4r4r2D12LaFHllFlBkNcvl0jlJd2
         ZVTS221LEeMdsJFpW8p5milen3Cwi5U88r/t2wXzGHZWl0gvYOjMfsIhuj5dOjaJdACL
         twKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777276174; x=1777880974; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ek9ChqVeqeA30OwQ3fqBFJmD6gbZl8V4G3Ph/Tn1DBw=;
        b=ek7k4mReJh2RUTf4BGmy7/x/Q4JKsxcj59Jfy2DevFmtCZvN67/U4Q58JfO4nyjP/2
         tW0+rX1zFbpEw97gS1maSx4KkRbksIGiD6mv1UzIEfaBxgP/3k5wdEcHXInoeFgv4f70
         sCutSh7J+ggOOOgpk4B2iX1Ten2kdvKIREoPxDDvejYCWwPqXXier1784v40wL88dN2S
         FC6Tb1zulrZA/ssOUzID6PPCxT4F8duBj5mcArKoCPcU+VCCkO7VuPsOMm5LHocfL8HR
         n6JI8sVXR1HwflaQbzpGeIAKl7RTML3IbSgpTxlVvWdeQ1YTrmDPnWXkVNF4EjyNJypb
         u9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777276174; x=1777880974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ek9ChqVeqeA30OwQ3fqBFJmD6gbZl8V4G3Ph/Tn1DBw=;
        b=KmMAz3WtLprzrlyS92V+xI7MEe6b9987bDgqHwXt+yAYihMXJXYSGm5FEpKVc7Lj/h
         NVxdHIiIG9hw3Gq5SO9lrzknmxBSOtOOXKj/SU6iZ1S5ZfOAlT9yF56iYWRvXJut5MKh
         3hbvGhFlWOhTQY9vcatOGU63qmAV81mk39Q2fiOKoOT7cCCThnhybSpzU509prfDxrR1
         8YJIV8IjiQGbRhzWOtAiuBcmNbfZHVc9Y5yeIsHLNtY7mpHBdj6KRnp7iMT5Pt+dytmc
         QpwARG2Ihg+0jih2yHc0a2YyIi7xThyqJg1MILdMBvXMmHLTCSwckwD/elUcITrzSyon
         w/tA==
X-Forwarded-Encrypted: i=1; AFNElJ8C0c4Nh7YjpKtOCV2zCasTjHQxH9gGtARHtgUWxHnoF9lja81o+w0KkT8pFi/1AkVHG0j1V6WBxkg=@vger.kernel.org
X-Gm-Message-State: AOJu0YypN3/UnaEVhDTsldozzVPglz6uuXz56s2LWK4HQjc5zmIoQvj/
	/XMR7c+KC50we+Pmx7reEVl+RXdr+VsFW+ITkiJj9+PYhVqKnHpolQyynGoMrVWxsnm3ufdJh4f
	wXHgDlXj88nko64qdoT5TullAqeVZN14J+j0aLLPfew==
X-Gm-Gg: AeBDiesX3Coz6NSmwCrm6YVL14kpx0qjebS4dWn8Zk0qsrj7CeYD2haJjkR2zP/b4+M
	2mqP6oW1OnW4wzc1Np76lwvFZ1NUj4hNqsi//MbgRUc2rAE0KdiuQt/Fs3wqE8JFqHhZgph5CIH
	0bkeNHd0zpEClicE48Z7GsRm86pQ4USqvDBb4eZ5KgwEUenH+LK/xEDqTe3ki7V2vrapJe7k6QK
	TE2P5IPE99O3pAVf8Q/U2y+ulSKiep3FBMwNLh2GDGgL5t4DNFnHlqLSkgsXddcA2VrFoo/rWco
	pxIg+CsZXd021p+pXIQueY6wvgT1ag+2AVqt4Ffvb6Sk6yG01lyy
X-Received: by 2002:a05:690e:4192:b0:64e:a335:95cd with SMTP id
 956f58d0204a3-65310a427edmr30609822d50.41.1777276173956; Mon, 27 Apr 2026
 00:49:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260426120231.532644-3-r@hev.cc> <20260427050735.3410-1-lisa@bytefly.space>
In-Reply-To: <20260427050735.3410-1-lisa@bytefly.space>
From: hev <r@hev.cc>
Date: Mon, 27 Apr 2026 15:49:21 +0800
X-Gm-Features: AVHnY4LBFt0fuBq3TwLhwZHYG4J8y27cuFb-KgWDFe-BpI0G6t-52Sf-oj0Bl4A
Message-ID: <CAHirt9jfnSFQfRHEANGeNGE2JowTcPV1Tz8L4cX=boJ6vSOa7Q@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] efi/loongarch: Randomize kernel preferred address
 for KASLR
To: Lisa Robinson <lisa@bytefly.space>
Cc: ardb@kernel.org, chenhuacai@kernel.org, ilias.apalodimas@linaro.org, 
	kernel@xen0n.name, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Lisa,

On Mon, Apr 27, 2026 at 1:08=E2=80=AFPM Lisa Robinson <lisa@bytefly.space> =
wrote:
>
> Hi Rui
>
> > diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmwar=
e/efi/libstub/loongarch.c
> > index 9825f5218137..80ba7d69e1b3 100644
> > --- a/drivers/firmware/efi/libstub/loongarch.c
> > +++ b/drivers/firmware/efi/libstub/loongarch.c
> > @@ -38,6 +38,21 @@ static efi_status_t exit_boot_func(struct efi_boot_m=
emmap *map, void *priv)
> >       return EFI_SUCCESS;
> >  }
> >
> > +unsigned long efi_get_kimg_kaslr_address(void)
> > +{
> > +     unsigned int random_offset =3D 0;
> > +
> > +#ifdef CONFIG_RANDOMIZE_BASE
> > +     if (!efi_nokaslr) {
> > +             efi_get_random_bytes(sizeof(random_offset), (u8 *)&random=
_offset);
> > +             random_offset ^=3D (rdtime_l() << 16);
>
> random_offset &=3D ~(efi_get_kimg_min_align() - 1);

Thanks for pointing that out.

Aligning to 64K here seems preferable. Otherwise, it reduces the entropy.

Thanks,
Rui


>
> > +             random_offset &=3D (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1)=
;
> > +     }
> > +#endif
> > +
> > +     return PHYSADDR(VMLINUX_LOAD_ADDRESS) + random_offset;
> > +}
> > +
> >  unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
> >               efi_loaded_image_t *image)
> >  {
>
> --
> Lisa
