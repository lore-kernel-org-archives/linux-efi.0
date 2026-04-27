Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4393E3174
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777303861; cv=pass; b=cTyORqkmf+VarnTacjvh/2wr+pbpBHJ0831tH3P0Xg+pwJlvZCKXYthlPTRflWJLStYrquSpNSyOeDN61Ct7GnisJS8G38sYMR3dXjN9gDJZq1v1gKEBWy+0hcgEYI1Bjqqv9n2meo3yuIDuRPRMjQTbrAfLraY0CUEa9Oh+Mto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777303861; c=relaxed/simple;
	bh=4HiY4AYN/EGxobzB/5kTY8j2JpTsW2nMz6JrZtmNerw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZhiJrHCQTS6HPBKQoYi+SuSOLgdBHPF5iPoIHPwGIJUOlHfuFwlHAwyr1H0SFdRNSRWwyOLy+VRNsHu55STIgNZDFh+8B4SiUJWQp53mkXGao1BybENBsHiWZM616OBWrtqhbSMFXYFeSGuy/52B/cmYtfyj3SMGB4RfZ20+zuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=b4ESHNPf; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="b4ESHNPf"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6530287803cso9939042d50.1
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 08:31:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777303859; cv=none;
        d=google.com; s=arc-20240605;
        b=QqbgpD9ahAvVV2exV4VR/qOO0LT8SpDkp5XOmXuL3D58Z11FofFBEjUR3Mxhz4DTQw
         GVAk8XRwGKJYvrBt6zxz2rmsXZYVgHxaZD4eqUj5n74s69HAR2t+CeAsS+2elYrWk4wv
         2QsfF8bRQFlrg98WeyyExqWAB6qL67HzOzIkEnhfhk3fh7kQNc0MrQ9wCS4Uc75yWELR
         FxSa9bxDvGHyjj90XFfpsqLW7vdqpbsyWnFHoMTosV7dl9AGQQqkTA7N9WSUDqqfPsuZ
         zOMIt9gJWkKUeA8UF/UqOQPhVlRaWUlWwYx7z1T8bECD7o2V30NXk3e+iTT9beFRJc1x
         A0/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tt+/kkN9TN5tQPCLUwGv3Fxj5QDbNx41eb7po+8Opjg=;
        fh=g/y9o/atsQmYbz2yIGZSq74CykYMIbMZsMs+DOOQedE=;
        b=L+cab7+z9Qie0i3PA5fYwifcsoSVfP0gs/KQp5lRAFwY2YJyUGp4A9nUp89lmpw1Rs
         lNkxOXl+rb1Zj59O5BLXve4wXE/qpTTFunfHXqg6bVViphR09lxGlUDosmwrRK+0vj6O
         nY+F3JdeyW7Rl90EvWdWqRT9Ss/IA25GXfrVnUhub6nZ4ZaVSl5HPsvjokSnKUtVCv7P
         Fb7F8ry+szL3/cNtpvaZvOvAqdbbif/bdKCJ5ltfcSD0iIKR705TNKVxJMIW3AAhwG8a
         +Nd2iITtYqyPeK6RaGEBzIoH/UONmw1PoLRk+o4QSD+Et/u72COV7tM6rGveeSlY33dK
         r6nQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777303859; x=1777908659; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tt+/kkN9TN5tQPCLUwGv3Fxj5QDbNx41eb7po+8Opjg=;
        b=b4ESHNPfvqrhDwXa4sJK7bo5T3yoN/5XGg8v6nDEAv6zHIijIn0qrbNTKLnFS7qi7h
         oSWoPXv9bJ8L5UaJ9s86MwHyz9oSJLzWGdKdc0cI2B9/zMFmubLuWp2bBd0PdGKUBw62
         +3rDsbtaadoJ7CohtJXGUxlOcU2sSwemEqhZYSWRUr856eF7XPIj4TmrE8KKnvVeUE8s
         KNhNno+tY5Nkw8mY7F4OIYz+ssLHbeQNUKt44yfPlrqmSjXw13fOj1CX+Va1ds1L+/67
         7UTzn8LqWWB0iEFkey5e8JG2POJ0nIToqpR6fTnnWyXHMfi4+XnT2ha1lm+Z8CtcwYPI
         wlLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777303859; x=1777908659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tt+/kkN9TN5tQPCLUwGv3Fxj5QDbNx41eb7po+8Opjg=;
        b=dlbfbLngzE2NaXtvIqDvwLYLm1Vo31jjl8Xz63vytxWVqeubwhNEoIRRpd0qHMJgfq
         J7Wouj/FDd6Liyf7I/YgIndwvrgAMACOxwKMWzogbxOVHjkAoY53mgwkILviq+C6c6EN
         MorkDLU0uNyXK6iE42ZL6lflXji7poXzdN1gpXeeopeZyxzAAeNCJxlvYOj6e5CtYazB
         PdenSOYypGJUcdPR2TPYVJarXhIhOLIwQGsUaZJ3qf8LARg/++HdzfwfNuHDgfpb+5yP
         PH5MHQxYxAUfPCrRI7aeqkHzgaH+CtQe33bMj6ivZMOdWzfdokNugDZC3LcvIvKsfQat
         oJTw==
X-Forwarded-Encrypted: i=1; AFNElJ/vmGMk+GviBfBsKShDo7bkeaa3YZTHBXOd2IuE8pqgB4GmNw5LzMFnqwajte8csvE2nGxGvTtKxLQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdztEnGQrF99Zcs4v1mOSIeGxBbQtCotK36uykFhd4JstLjEqt
	jAzSHRauDcDy8XYltC55ok7s1fFTMX8go12Q5hoVUbuRuSkVRjw+b9tx6NYt9lFyFfFgzNXkKpF
	vCq5q5hMQdXp1+lsKYK7TW5nvOzLtyZ1R59Jy0L2Tjw==
X-Gm-Gg: AeBDietkaNLeNiKmVz46KQw/8OkDzx7KMif3KR+TyJfveg3srjCXSZHRMBipO7a9unh
	rPMj4W7PFMDEhyhK7Jf4cTmmiY5f2dpSBp/r0EKZWa5jsRMIdr5qmhXdu7wsCbLfEZvCsHND2QL
	zPNUYAhZCF//zfNfkEHS3GoV5NX+TRkdq6DYZd5BT53j4Y/kzPtHANbkiaW0GCGnaI4epizxYyg
	ifyhjNkVeTojhowUL6JeFgwXL/+25iCh8r+2hNET3e3CtGMYSBMB58Tti8s9+ItoD38IYrau86i
	gaipXqq6dkVtJvBxf4oLZbzy3rprzvALXkYVRKm7wsBoTMjXs34=
X-Received: by 2002:a53:ac9b:0:b0:654:c28:551 with SMTP id 956f58d0204a3-6540c282024mr35236448d50.32.1777303859167;
 Mon, 27 Apr 2026 08:30:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427104721.47724-1-r@hev.cc> <20260427104721.47724-4-r@hev.cc>
 <CAAhV-H7+B6=Uf1ZDy9SLvWkR-ggTi3k9kFU8+B+JefWqPu4Uvw@mail.gmail.com>
In-Reply-To: <CAAhV-H7+B6=Uf1ZDy9SLvWkR-ggTi3k9kFU8+B+JefWqPu4Uvw@mail.gmail.com>
From: hev <r@hev.cc>
Date: Mon, 27 Apr 2026 23:30:47 +0800
X-Gm-Features: AVHnY4Jsizl5p24DvdxTsPYaW0zh8JaFfxWIPucZNRq4lEI0h18QkC9uiGKG4ls
Message-ID: <CAHirt9j-PMwKaLUYqR9qCOemBXCw3PfpuB5Ff1EbZozLn8tFqw@mail.gmail.com>
Subject: Re: [PATCH 3/3] LoongArch: Skip relocation-time KASLR if it has
 already been applied
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, loongarch@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Huacai,

On Mon, Apr 27, 2026 at 9:29=E2=80=AFPM Huacai Chen <chenhuacai@kernel.org>=
 wrote:
>
> Hi, Rui,
>
> On Mon, Apr 27, 2026 at 6:47=E2=80=AFPM WANG Rui <r@hev.cc> wrote:
> >
> > When the kernel is relocated during early boot, a randomized load
> > address may already have been selected and applied. In this case,
> > performing KASLR again in relocate.c is unnecessary.
> >
> > Signed-off-by: WANG Rui <r@hev.cc>
> > ---
> >  arch/loongarch/kernel/relocate.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/loongarch/kernel/relocate.c b/arch/loongarch/kernel/r=
elocate.c
> > index 16f6a9b39659..c36604a81d08 100644
> > --- a/arch/loongarch/kernel/relocate.c
> > +++ b/arch/loongarch/kernel/relocate.c
> > @@ -139,6 +139,10 @@ static inline __init bool kaslr_disabled(void)
> >         char *str;
> >         const char *builtin_cmdline =3D CONFIG_CMDLINE;
> >
> > +       /* KASLR is performed during early boot. */
> > +       if (kaslr_offset())
> > +               return true;
> Maybe the "kexec_file" case is also handled by this?

Yeah, it looks like kexec_file doesn't load the kernel image to
VMLINUX_LOAD_ADDRESS, so it will disable KASLR here. This aligns with
our expectation of disabling KASLR for this case.

Thanks,
Rui


>
> Huacai
>
> > +
> >         str =3D strstr(builtin_cmdline, "nokaslr");
> >         if (str =3D=3D builtin_cmdline || (str > builtin_cmdline && *(s=
tr - 1) =3D=3D ' ')) {
> >                 pr_info(KASLR_DISABLED_MESSAGE, "\'nokaslr\'", "built-i=
n");
> > --
> > 2.54.0
> >
