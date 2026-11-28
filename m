Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795828329;
	b=l/kaHQoKlmChaHBVE1h71qc5U2DlxTQd7W7PgKU+VkaGH+C4tGIoQY6KnrOjryXff0ik
	 DJFMojgmV9KizMsbFzaJ1rz+OWw6VJpHZa22SMZNfLslXbsV2EG3pnMDoVfGR476h1XPC
	 B20uQExOp9WWr8UjMfuLn+3Emqca9AbeKVQ8icdfNeWx0VhTO8QhMlUtwTxYfZ06lWE+N
	 MD2VP5/0iNp8llVE7Y64erqUFBonYI4p+zrZ92hF9iemLeFVnox1R8p30UzbxP0bSdMbj
	 sySuV/VSLFFsuq2tfUOuqJt2bjnwGBR3XTFguYo+YsCJ41amP05VJBgnKdEuiJ+ecng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828329;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=d+pQFpRQs5oDrjGbRHfXhVFeJrx2IO0P+8h/4Gnd3Ug=;
	b=Y0N3qUsafT41wjHIJlnpbldRpFbKFPmrAkwGmtqrVXs7QAZnb+cVzXGN5LFVARfk144O
	 xfcpd2c4sqAICjZ3VahoqB2EvyfzMwKS1da1oNB1wwVO+t9HJIL1g8KGqXFj6OESE5FTh
	 7kWCPR0oULSl+TyomS1SxsDsDNUkE3IvYUbPi7uusFiLZBzWShxAa8Iv8/7uTZTiQyHMO
	 +4CNsVW6w9sGhIUTH/1CvhzpehEyv8E5NEZQ1JrmJSRIsjY9SeHVy6UU4JF90tgsL5ZSO
	 yZL8OiHcNce0DDyHAXPXW3AMYZo7NfhXwqluAOMj8WV5uhA266jjttAnGwrWVwzJ4LQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W+xZ1Uyo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE1B606A31E
	for <linux-efi@vger.kernel.org>; Sat, 28 Nov 2026 01:12:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DE1B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W+xZ1Uyo
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1b59dfe466bso1002083c88.1
        for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 17:12:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795828327; cv=none;
        d=google.com; s=arc-20260327;
        b=pJ/RaUx7eOwwE4yfVKiVWQoGg62XbuYt/umCRYXewTas4udUOTYYs+mo8uZqarAY4o
         XguyDR7kEMgwEQ27oZr05GarveH/4DiOblUWmlDJUNISAYt/iJFn7TmzOKQc4r+N7OLt
         ORyR3QffjkdtfoUBShzudUo5p4pOfPqDewDQcQO1W5f4E1QvKRIxAySmtGGdLJ/3riDU
         Swt6AsVKFcdYG2Xm6BKnxYIMYswFrm0h3zcs0j0asV0/9Z0yHSuiQnY3m4hGvEV6cYMV
         JnTgct8yh2IopfuFJiHNPnEi/tGdG7f8VX5qp5CoC5lxNGt6dMW1nfZee6BpWJ/DXCK7
         J/zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d+pQFpRQs5oDrjGbRHfXhVFeJrx2IO0P+8h/4Gnd3Ug=;
        fh=MwSyf9KvgEitmiXCGRolA02ZmlYxDXYweqPktUyTwE8=;
        b=AiPs4n8eb0Rm27FQ4+G72d48g9MQDnw32OGNYfhE0a97RDh3MuwU22BexOHMBaZ4xd
         lLziacN1ZUmHoVwCMddqF6Wn2JO7bV/r+YXjjpziSQs4nNOAJVhcqG7Z9AiMm7MtxnzH
         R+ygvjqht5D5oY4Sc79NUWhw67CD5IDyTGewSSwDCIqErrXIpJzX6ZqfhL9Yn/a4KRiU
         LvvOLEjUWWtbZRltcVLXqhuGR8SafJOb8siGqWJTyIEy9AdD1NnstYKxgDQh6vLgmxvy
         X+tFXNttV8D4z/+/x3IcNGiAThLR5XSXjCSnEIv9VLrOVvSqnMClNjFEFdZIG5Y1atHz
         Zmbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795828327; x=1796433127; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d+pQFpRQs5oDrjGbRHfXhVFeJrx2IO0P+8h/4Gnd3Ug=;
        b=W+xZ1Uyofg9bKPP1dQwl/jvrpGvnic8TMIEwPzumzChpG1KkHJFcM3o2AB4O0vD8Vl
         /tDUnHimG4klsY99Vblzd49aXxtF7oTD03l2dMxbBwzQrNJSAj046onPeWJ6w712Q/jJ
         qV7OwM0npTBk7cr9NyNbjxBJq1vHzm5RwJkxx98D2t1KuESkxdDEO4tilD2iFz35knob
         k1H9qMjwULGzemWMswhmisEaSQIADb0MP7HQ5J2Jx/aY7B7aqIzcDk3zUxuPjFttCo/z
         fXkbP9NI+R6Asq7dwhA7hKmlQGTG/5hOIBDq6OOhJ7DhO6WathENJ8qgu6cAyJXTQKqC
         6FoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795828327; x=1796433127;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d+pQFpRQs5oDrjGbRHfXhVFeJrx2IO0P+8h/4Gnd3Ug=;
        b=e/LPSNGRWjJC/PknKq2e3cItSHtVIKBUk8tdOSnF0dlegz8VOfxWKiDXN1V7mlZJOR
         koQRJ4xxvYV2njtjCXLNq0HDSS/wSB8iFlFUt9FcTa6iiQDiVbKOosqW0N0aZ9qpzwGF
         BHMlGpvnWTEzfNaBwwytxl8OHGUwrbd+r0qDHydPt6BEsEy+smzfMXfB+4UzDkJ2+sbc
         6s8j1bFmq82upXOW/gizHj5AREhG6iOJDvzkJYGRq+h/ukrWitNxuFqzjme0xjIxJQmU
         7/QxlYCYSDOc4oEFnYS8FJ4P2oaR7DjCxN8x9x90b47DUN2mFaSOF9AeVr56eTiGixqg
         2Wwg==
X-Forwarded-Encrypted: i=1; AL+hErFhgs+Fw/7cil7HFbgiAj/chlcyeZlSt3hJRg3NExshqf3sq+zauZgDmoUmuyxU6U+AqFcHOH+LLZ0=@vger.kernel.org
X-Gm-Message-State: APuU4Z8t0qdzVK2lIr842CIluOsGuJ+NfrBKE7l5NHHH/YlSdMgBpjew
	hj3AtZfXIIhGazDEiII4U0VeHUwy5W8RRyO8f9fmlvnR/87Jqm3lSpaeWuNLPiVQgVaYBsNiKa2
	eCcJ91tbYfQwNgLjor0B2lzAKYj98rAQ=
X-Gm-Gg: AZFdTZcDhpJuTLx9WiR8TP9ObPpr2CfJVV2yq/JciS24ZBc20bYwJkK+NAfzEHjNcNg
	EhH5e5uxT1ullgtbABk0MkXoOdoRn89HHXGH3i4KS7kdbdt42c29kTkslsOvfh6iFjiweEHKXgE
	3uwJfK1hWreCuz1sHlYOULhO5TChjO8B6mgxs5YnbVzDG1R3IEo3skuJgVtoaOBMihDXPMyUBt6
	FhHAKrC7iOpObF5gJLfYge4Iv/tCfQ5+1zZhZU4B5aVq6hccCAwSkX2KFpIiXye8CQoWFBtnK9c
	Z75wojAziIuBaPBycGxQJEbrHQSFTNs3ikuA8GnffQ+z7PvCes2qypRtDEVAD34ThPwlfgKC6h3
	RGx3qbjPvCTG1Dwu/gewGX8fyn4nR2FPuQyWR
X-Received: by 2002:a05:7301:6083:b0:386:a01f:a36b with SMTP id
 5a478bee46e88-386a01fa8d8mr31179998eec.35.1795828327239; Fri, 27 Nov 2026
 17:12:07 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260815074844.1330-1-jakejgpark@gmail.com> <20260903115516.32495-1-jakejgpark@gmail.com>
 <5b13119c-105a-4197-8f5c-711acc47ac0c@app.fastmail.com> <20260903222830.213089de@pumpkin>
In-Reply-To: <20260903222830.213089de@pumpkin>
From: Jonggeun Park <jakejgpark@gmail.com>
Date: Sat, 28 Nov 2026 10:11:55 +0900
X-Gm-Features: Aa3M54qCJwm-mygX_BgRmUNUXDh62GubqfQ1bS9LfhMfezk7aV08_bKS0lx_C7o
Message-ID: <CANFjs8t79dAZe5szPghV=3cTgfOZnqsL2XNNudTqGwAjwm3r=w@mail.gmail.com>
Subject: Re: [PATCH v2] efi: vars: commonize the 512-byte name buffer quirk
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Laight <david.laight.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ard,

I'd like to kindly follow up on this patch.

Could you please let me know if anything else is needed from my side?

Thanks for your time.

Best regards,
Jonggeun Park


2026=EB=85=84 9=EC=9B=94 4=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 6:28, Da=
vid Laight <david.laight.linux@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On Thu, 03 Sep 2026 22:03:18 +0200
> "Ard Biesheuvel" <ardb@kernel.org> wrote:
>
> > Thanks for respinning this.
> >
> > Some additional thoughts below.
> >
> > On Thu, 3 Sep 2026, at 13:55, Jonggeun Park wrote:
> > > Some old UEFI implementations reject GetNextVariableName() calls with
> > > a name buffer size larger than 512 bytes. Both efivar_init() and
> > > efi_pstore_read() open-code the same workaround of resetting the size
> > > to 512 on every iteration.
> > >
> > > Move this workaround into efivar_get_next_variable(), which keeps thi=
s
> > > quirk in one place, resolving the TODO in efi-pstore.c.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Jonggeun Park <jakejgpark@gmail.com>
> > > ---
> > > v2:
> > > - Move the workaround into the existing efivar_get_next_variable().
> > > ---
> > >  drivers/firmware/efi/efi-pstore.c | 10 ----------
> > >  drivers/firmware/efi/vars.c       |  7 +++++++
> > >  fs/efivarfs/vars.c                | 12 +-----------
> > >  3 files changed, 8 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/drivers/firmware/efi/efi-pstore.c
> > > b/drivers/firmware/efi/efi-pstore.c
> > > index a5db3534f..4f2594d08 100644
> > > --- a/drivers/firmware/efi/efi-pstore.c
> > > +++ b/drivers/firmware/efi/efi-pstore.c
> > > @@ -164,16 +164,6 @@ static ssize_t efi_pstore_read(struct
> > > pstore_record *record)
> > >     efi_status_t status;
> > >
> > >     for (;;) {
> > > -           /*
> > > -            * A small set of old UEFI implementations reject sizes
> > > -            * above a certain threshold, the lowest seen in the wild
> > > -            * is 512.
> > > -            *
> > > -            * TODO: Commonize with the iteration implementation in
> > > -            *       fs/efivarfs to keep all the quirks in one place.
> > > -            */
> > > -           varname_size =3D 512;
> > > -
> > >             /*
> > >              * If this is the first read() call in the pstore enumera=
tion,
> > >              * varname will be the empty string, and the GetNextVaria=
ble()
> > > diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.=
c
> > > index 3700e9869..0f95fc60d 100644
> > > --- a/drivers/firmware/efi/vars.c
> > > +++ b/drivers/firmware/efi/vars.c
> > > @@ -191,11 +191,18 @@ EXPORT_SYMBOL_NS_GPL(efivar_get_variable,
> > > "EFIVAR");
> > >  /*
> > >   * efivar_get_next_variable() - enumerate the next name/vendor pair
> > >   *
> > > + * A small set of old UEFI implementations reject sizes above a cert=
ain
> > > + * threshold, the lowest seen in the wild is 512. Set the name buffe=
r
> > > size
> > > + * to 512 on each call.
> > > + *
> > >   * Must be called with efivars_lock held.
> > >   */
> > >  efi_status_t efivar_get_next_variable(unsigned long *name_size,
> > >                                   efi_char16_t *name, efi_guid_t *ven=
dor)
> > >  {
> > > +   BUILD_BUG_ON(EFI_VAR_NAME_LEN < 512);
> > > +   *name_size =3D 512;
> > > +
> >
> > This should really be
> >
> >   *name_size =3D min(*name_size, 512UL);
>
> You don't need the UL suffix.
>
> >
> > so that a smaller buffer size provided by the caller is respected.
> >
> > That also removes the need for the BUILD_BUG_ON().
> >
> > No need to send a v3, I can fix that up when applying.
> >
> > >     return __efivars->ops->get_next_variable(name_size, name, vendor)=
;
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(efivar_get_next_variable, "EFIVAR");
> > > diff --git a/fs/efivarfs/vars.c b/fs/efivarfs/vars.c
> > > index 6833c3d24..5a01833a6 100644
> > > --- a/fs/efivarfs/vars.c
> > > +++ b/fs/efivarfs/vars.c
> > > @@ -391,18 +391,8 @@ int efivar_init(int (*func)(efi_char16_t *,
> > > efi_guid_t, unsigned long, void *),
> > >     if (err)
> > >             goto free;
> > >
> > > -   /*
> > > -    * A small set of old UEFI implementations reject sizes
> > > -    * above a certain threshold, the lowest seen in the wild
> > > -    * is 512.
> > > -    */
> > > -
> > >     do {
> > > -           variable_name_size =3D 512;
> > > -           BUILD_BUG_ON(EFI_VAR_NAME_LEN < 512);
> > > -
> > > -           status =3D efivar_get_next_variable(&variable_name_size,
> > > -                                             variable_name,
> > > +           status =3D efivar_get_next_variable(&variable_name_size, =
variable_name,
> > >                                               &vendor_guid);
> > >             switch (status) {
> > >             case EFI_SUCCESS:
> > > --
> > > 2.43.0
> >
>
