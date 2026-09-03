Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF588448BB6
	for <linux-efi@vger.kernel.org>; Thu,  3 Sep 2026 21:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788470916; cv=none; b=Cfi2sLZLrJtM4yosuQ5xuEqF96oAEvNc1IwtexyvnZtK3DnTY+UkWS9aLsi72XDHq2rTwQP+Z5ch2i1bb6rMW4JO8HDDgupyoibZKs9UoRKQSndiZHdLWfONbUXqvpcukVHF1Tpu7bvZ4byZafTWQ0I/IY5LkSb2xhSP0cb5syI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788470916; c=relaxed/simple;
	bh=nok8G7oxwUEBJDJKwyMkjMRptrnZ4yc3CBKyB4ujpZE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hFI1eKdf6XvXy8B0Hxz3mS9jGF+K/MSIFHt8CMXLRWMFxudp8zRaUC5knTVGgFcs7CnE6ruUxO+EV42ZCtmcx/BgJAq5obXEHGfXn1gYjSBPZf6+Grmr1Uk4d1TGWjq4oPs5UI5vvuBzsqcoZKayJB2Q3Y2+UJ5/COCXKFYL9/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=epaPrEld; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="epaPrEld"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49b8ce9b733so3209925e9.1
        for <linux-efi@vger.kernel.org>; Thu, 03 Sep 2026 14:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788470913; x=1789075713; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dWXttQx2iDCjHaH8p4UqIGs6d00YewL+6MGN7cegYBM=;
        b=epaPrEldT9/kEWJ58yENBYKJmgWSMjhAA0ohEvKvodrR5MOWPdRmhrpDFlE0J5GzaS
         dYPpkKy4KVc84KQq8q1AoVVZrXsorAPr1KNJNP8I6/zzeqXKnI69c9JuQVIUQ/oiSDsl
         h996WkiQ3BdLEbwyifXy8+L655Vao1OS5HGSfjkthb7rkEhhXgOLrovuaHiTiO6hGtMV
         9c9EuYi7NiS/WYpAimA59Z/BNtWeMeihqUNL2AnBDszkdebbEE5705n/gGHOH0wCzWcM
         dPxP48YwiqFSmqfoy1tZtggSfRH01Fb8QlBtF848NVel3fRSLswlSRMo+KW0EovowSYZ
         cX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788470913; x=1789075713;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dWXttQx2iDCjHaH8p4UqIGs6d00YewL+6MGN7cegYBM=;
        b=pHI7eMxODIKy0HLvsvZ16i/GagR45LkYn51xYXoSvXLwW/hrSuK5s4YyKjftgPoH91
         3ud9ta3zZGFmhZ6KPB7uU030TQIYG+0Zh36DgJ1OnTOhJ07X6FbcjF71ufbODfe4q2cq
         mqXbUzB8QkyfDF4hr6qGlQRAvmgLgcb1IvH1ZEIkEq4SShYqjVo4xF+oyjBfBmNtMdaF
         FEYK9EDoNJCiz2DRkFbwJaPhCL5fw8pt61pzkm7k+wm625bRTN8ybyls3QIIJHoP9Q2a
         dMrB5gmnmX0BcZGCvIZ+3KouzyoFlfaHLgbNlbJNgt7KHNRX8Bv+aqL0JhLTKK7Kh96f
         NIOw==
X-Forwarded-Encrypted: i=1; AKwUvBwac9nkz4ls5rvssojGgg/wnBmVNFmJPBvPcgAXZUI7vevL4Lrd0HJ003n6+MvLi+tiEjbVpKs7JNU=@vger.kernel.org
X-Gm-Message-State: AFuF++mF0EWiQRL8/qAknhT/w9KOjDsBBeDwelrT9QuOgL8q3tXqbFtT
	aKhstIsEvokaS5eySvSiANvuPqYscNIezwJx6pyGvSwCW3YLfCnJ4Whz
X-Gm-Gg: AYBFou0awfZeyxW60reUAxUY9DrZpd+RDKDJBxBe2EtcYg48GL1+F04ncSw3X+QHJ4D
	y9tOHhmV56WfXaTpMALa5tbO9p+61MUbGbOptQ/Nh2VoYjscwHPv7Oc/bouPdNZSquSmrP3PkDE
	Kbidcgvn5uUiUsP1rYZGMQkvjzSAjxtgpWd5Fdq0Td60fMLExDdT3piCiHm+yTbr/6w6RgaY6kT
	34KxIZtzBUHdsXKn6U9KqXse2ook/5qxiQO87kgN1zCDbflVmM1FEbyON7j46m69z81mpEYNord
	3gArcRk5t6EHROxW/2+VKIXIMLWu7LF3OJOcKTwDqRns9b2C3FohCIReLa48Vr3shxK4c6EjQhp
	v36lywmr0fpTsH6sISVWG0OGB18ETQQAnbPg2nNC5r6T3/8hBFNOPxiv/6BTpXF0y41P+/fYaqU
	OXn5d72kFhDNl6JzjohA1D/8NWO+6pZ3GpVeiEJtaetVdNmj2zgmlnZcNvHJvKQjllIYuqEy17M
	tTMgPIuuQUlFIYyMgvHclAhKqjyGgy6EyeNqjOKT4SWOZ/P
X-Received: by 2002:a05:600c:3115:b0:49c:e1b5:b2bf with SMTP id 5b1f17b1804b1-49cf7f48645mr14077965e9.0.1788470912493;
        Thu, 03 Sep 2026 14:28:32 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee6023d6sm100551075e9.8.2026.09.03.14.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 14:28:32 -0700 (PDT)
Date: Thu, 3 Sep 2026 22:28:30 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Ard Biesheuvel" <ardb@kernel.org>
Cc: "Jonggeun Park" <jakejgpark@gmail.com>, "Jeremy Kerr" <jk@ozlabs.org>,
 "Kees Cook" <kees@kernel.org>, "Tony Luck" <tony.luck@intel.com>,
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>, "Ilias Apalodimas"
 <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] efi: vars: commonize the 512-byte name buffer quirk
Message-ID: <20260903222830.213089de@pumpkin>
In-Reply-To: <5b13119c-105a-4197-8f5c-711acc47ac0c@app.fastmail.com>
References: <20260815074844.1330-1-jakejgpark@gmail.com>
	<20260903115516.32495-1-jakejgpark@gmail.com>
	<5b13119c-105a-4197-8f5c-711acc47ac0c@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 03 Sep 2026 22:03:18 +0200
"Ard Biesheuvel" <ardb@kernel.org> wrote:

> Thanks for respinning this.
> 
> Some additional thoughts below.
> 
> On Thu, 3 Sep 2026, at 13:55, Jonggeun Park wrote:
> > Some old UEFI implementations reject GetNextVariableName() calls with
> > a name buffer size larger than 512 bytes. Both efivar_init() and
> > efi_pstore_read() open-code the same workaround of resetting the size
> > to 512 on every iteration.
> >
> > Move this workaround into efivar_get_next_variable(), which keeps this
> > quirk in one place, resolving the TODO in efi-pstore.c.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jonggeun Park <jakejgpark@gmail.com>
> > ---
> > v2:
> > - Move the workaround into the existing efivar_get_next_variable().
> > ---
> >  drivers/firmware/efi/efi-pstore.c | 10 ----------
> >  drivers/firmware/efi/vars.c       |  7 +++++++
> >  fs/efivarfs/vars.c                | 12 +-----------
> >  3 files changed, 8 insertions(+), 21 deletions(-)
> >
> > diff --git a/drivers/firmware/efi/efi-pstore.c 
> > b/drivers/firmware/efi/efi-pstore.c
> > index a5db3534f..4f2594d08 100644
> > --- a/drivers/firmware/efi/efi-pstore.c
> > +++ b/drivers/firmware/efi/efi-pstore.c
> > @@ -164,16 +164,6 @@ static ssize_t efi_pstore_read(struct 
> > pstore_record *record)
> >  	efi_status_t status;
> > 
> >  	for (;;) {
> > -		/*
> > -		 * A small set of old UEFI implementations reject sizes
> > -		 * above a certain threshold, the lowest seen in the wild
> > -		 * is 512.
> > -		 *
> > -		 * TODO: Commonize with the iteration implementation in
> > -		 *       fs/efivarfs to keep all the quirks in one place.
> > -		 */
> > -		varname_size = 512;
> > -
> >  		/*
> >  		 * If this is the first read() call in the pstore enumeration,
> >  		 * varname will be the empty string, and the GetNextVariable()
> > diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> > index 3700e9869..0f95fc60d 100644
> > --- a/drivers/firmware/efi/vars.c
> > +++ b/drivers/firmware/efi/vars.c
> > @@ -191,11 +191,18 @@ EXPORT_SYMBOL_NS_GPL(efivar_get_variable, 
> > "EFIVAR");
> >  /*
> >   * efivar_get_next_variable() - enumerate the next name/vendor pair
> >   *
> > + * A small set of old UEFI implementations reject sizes above a certain
> > + * threshold, the lowest seen in the wild is 512. Set the name buffer 
> > size
> > + * to 512 on each call.
> > + *
> >   * Must be called with efivars_lock held.
> >   */
> >  efi_status_t efivar_get_next_variable(unsigned long *name_size,
> >  				      efi_char16_t *name, efi_guid_t *vendor)
> >  {
> > +	BUILD_BUG_ON(EFI_VAR_NAME_LEN < 512);
> > +	*name_size = 512;
> > +  
> 
> This should really be
> 
>   *name_size = min(*name_size, 512UL);

You don't need the UL suffix.

> 
> so that a smaller buffer size provided by the caller is respected.
> 
> That also removes the need for the BUILD_BUG_ON().
> 
> No need to send a v3, I can fix that up when applying.
> 
> >  	return __efivars->ops->get_next_variable(name_size, name, vendor);
> >  }
> >  EXPORT_SYMBOL_NS_GPL(efivar_get_next_variable, "EFIVAR");
> > diff --git a/fs/efivarfs/vars.c b/fs/efivarfs/vars.c
> > index 6833c3d24..5a01833a6 100644
> > --- a/fs/efivarfs/vars.c
> > +++ b/fs/efivarfs/vars.c
> > @@ -391,18 +391,8 @@ int efivar_init(int (*func)(efi_char16_t *, 
> > efi_guid_t, unsigned long, void *),
> >  	if (err)
> >  		goto free;
> > 
> > -	/*
> > -	 * A small set of old UEFI implementations reject sizes
> > -	 * above a certain threshold, the lowest seen in the wild
> > -	 * is 512.
> > -	 */
> > -
> >  	do {
> > -		variable_name_size = 512;
> > -		BUILD_BUG_ON(EFI_VAR_NAME_LEN < 512);
> > -
> > -		status = efivar_get_next_variable(&variable_name_size,
> > -						  variable_name,
> > +		status = efivar_get_next_variable(&variable_name_size, variable_name,
> >  						  &vendor_guid);
> >  		switch (status) {
> >  		case EFI_SUCCESS:
> > -- 
> > 2.43.0  
> 

