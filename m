Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424654;
	b=uD4O8gehbtHCOATx9YpB/JEKkoTRtcsBLQMdM2eomSoNvMW3mJZf4AWz3UnTsynPcryl
	 T1jsMAUW/7LJHGmLOBq+lq8Zjn6jFecyf0w9lDUyEkus5d/Ehbg4ywpWdKxgVdAAJr7AF
	 Tn2v9WD09CSuV5fa+BgdoX/b5dA2T+voaUwufiShdZT116hOldmahCNE60evaokBGw9Lk
	 bcosn3dgmQJ6Y/nlybu+VYOcF674bqym2vCVyFRNrR6JCJH10alOysuEoz9epV+hKl24p
	 n8CSlj17yG7FZLYESy6Cv8Ia+YdsWL4ayAsLn+WfIey13EjMdnrACCZkZ3+uyjDaUWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424654;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ubH/wDYbw7Fd9wr/tfPO5iv8DCgxe5KvwjuUYrTL8XQ=;
	b=l9nkJG22VQURaoc1KexW5Yi/70Uw1Vs9N8HtiKhjm3mPM1J7lGvKtGaE9nJfAonQLZfe
	 RBCxasguiKoPMOTA5mWXO3xs893tolUSxvhYcNsojFOA8z34AGr2xww+/WsGeUYGOiRHb
	 Eyg4d3J+Q6Ov3SHbZ4wo3TAN73/GFTgOd9cm8ljLm0fTKIe79aTcXkg2fyQAxbhqSO5el
	 BkQvhUkhl05uZ2KQwgDQxvboNrtz8ubTooaPaH5NwERnqKuiOZ84uTl7iZDp4zQLfjevs
	 nyXri3qIwe7j8c3+OjukxdCWLuhrfNAVTMNXT++zxVB9gXboaTomOTQhMp6ImHFMeEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=baylibre.com;
	spf=pass smtp.mailfrom=baylibre.com;
	dkim=pass header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=IlrFfHDW;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D719606A31A
	for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 09:04:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D719606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=IlrFfHDW
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb77a462c6so30148455e9.1
        for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 01:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1795424652; x=1796029452; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ubH/wDYbw7Fd9wr/tfPO5iv8DCgxe5KvwjuUYrTL8XQ=;
        b=IlrFfHDWSp8DLfWGlviLzyh6Dn82uiSv3Ls0lwA2HBdpDjlOggL2ye9u/dEY8oBOnq
         RsEc+n3QVP8uIRgR81y78v9ZfFm/ZbcoLkJBhOxFvIk1EFIOucNBbapJTBwn3H2QFx5E
         +hi4hBG2xn1dzRaajJaXzUBjHTgwfrGZyvVPG9nxNBkhsmI6dnhVnRbCbTmZDysgjH4z
         F+MOyE62sUXvyIT3NcOFuOLDFI2q/UHt6cKea7j79RM4mNALPK+vnEEUaU5iU+H+b/aA
         iRhbNRoenxctcIJULCbKqtBbGIzPim3toyj8v5bv5V0xKGaidzhF0s1/Bqrz5lLhkPLI
         OO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795424652; x=1796029452;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ubH/wDYbw7Fd9wr/tfPO5iv8DCgxe5KvwjuUYrTL8XQ=;
        b=ovkjfGOQ+b7ni9tcMbJY7pstrpvTr5ibw7yLW+hiW2aczXsDQSzvMCc4oAZp3brCi5
         clI9EpuwUmX2ISymKcq9Eic9x46bKs1ykRrfdHMb7aFrtAzhEmkWyBcPIvqNtCwMxxwj
         mMdn9ckxo0tMN3LLKCsFXMpQ76C4GHgQtI/pArAv/zrl/tUqwjTgkZshqQKlKDDB49q9
         Fp35mHN+VXi/yiQ8IXtpXDyx3T8YpoGePeQ8BjsDxMaAJtXwUDRDVHRQXgnVsvKWRkQb
         BDDV5O23NKl1q8xFkmRjf0YBipgHwjbDkQQ4jSedSQfurCiXcPv0hLu8gKOQRSgM/9K/
         nr9g==
X-Gm-Message-State: APuU4Z+WUMfaiqNxao916sDfxRhxv7kIv3/wdCPCNQEfaYFQoRYr129f
	SFVsoVQR//8gHYKgghzNWfJVe9KiGxFq08SlqFsWOXy0XDtD8PGufJXarA3gDkE/oDD75nnS4cv
	o5wLg
X-Gm-Gg: AZFdTZcUMfHduwYtwbJ04R4zzNPkvgAJVbv1JNEdQC/ezpg18qfPScTXyBfritMALtA
	i0cV6zGGLbMr+vLmskXHShyeMPZGgVe5WJ3YLy4HzTjCyt5zJmA3l8FKJrKWWc5qrKi8eSxT5cM
	e94gGmxqJXHuiDoxchDUAZ/r8kC+QP1aXY5/lzrt8lRdLxngjzKQoXZmwGbOo710rg+RZvrlBIU
	SmC2WlVYnnpg9PDoXBXE/otzPDz+oBFFLFEND77swdqDb11icDRbeWvJKiAA5MhkiLhOPJXr+tH
	MKKYKXs00T5iF1DUAgHFWWaN+Z/XDSwO4r/yoSas+fwh9DUsrIvd88mA3eRBAnsY5s0lIE2068l
	Y3n1jDXkMgoXMZoO2i0A/KHeJcZ+nrzo8Q899Q3fdwuuVkf7UfF3tq8d4Jbbi87WnUSteaa/Ds+
	/mVfZvcw0y1ivkQd5DoRo+wa2ysDkfkrd6DcFkHWnTmZYoKgOjCDcWO3OCu+hWHFKWNy3nX312z
	62Sr8hRZn4rPgm9yfpe55co4OGNAHdzI29u42rkm7GPGmp8/Q1DfDYKQ5OrGLasplDngMXr4T0l
	N9Y2Udf7FAXEN7Ih5Tvqttzajlv4dtVtTc14urx3iDojeqGLZ0pQtkF5nvzmN+gGxeXNImDlwYh
	Esa+daKrNxs6v/MvE
X-Received: by 2002:a05:600c:154c:b0:4bb:6a78:7c42 with SMTP id 5b1f17b1804b1-4bb887c3428mr229477635e9.1.1795424651910;
        Mon, 23 Nov 2026 01:04:11 -0800 (PST)
Received: from localhost (p200300f65f19a90438645cebc2ee104e.dip0.t-ipconnect.de. [2003:f6:5f19:a904:3864:5ceb:c2ee:104e])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4bb88442995sm341689635e9.2.2026.11.23.01.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 01:04:11 -0800 (PST)
Date: Mon, 23 Nov 2026 10:04:10 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Kees Cook <kees@kernel.org>, "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: Re: [PATCH 2/2] efi: pstore: Convert into a platform driver for
 'efivars'
Message-ID: <awQAaoPBSeaTC17N@monoceros>
References: <20261120131827.480055-4-ardb+git@google.com>
 <20261120131827.480055-6-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wxeycgg7tzr5ea3w"
Content-Disposition: inline
In-Reply-To: <20261120131827.480055-6-ardb+git@google.com>


--wxeycgg7tzr5ea3w
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/2] efi: pstore: Convert into a platform driver for
 'efivars'
MIME-Version: 1.0

Hello Ard,

On Fri, Nov 20, 2026 at 02:18:30PM +0100, Ard Biesheuvel wrote:
> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi=
-pstore.c
> index 19a7e4fe5b52..44571fa1dd88 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -1,7 +1,9 @@
>  // SPDX-License-Identifier: GPL-2.0+
> =20
>  #include <linux/efi.h>
> +#include <linux/mod_devicetable.h>

please don't add new users for <linux/mod_devicetable.h>.
<linux/platform_device.h> already provides platform_device_id without
introducing a big number of unneeded build dependencies.

>  #include <linux/module.h>
> +#include <linux/platform_device.h>
>  #include <linux/pstore.h>
>  #include <linux/slab.h>
>  #include <linux/ucs2_string.h>
> @@ -251,29 +258,53 @@ static __init int efivars_pstore_init(void)
> =20
>  	efi_pstore_info.bufsize =3D record_size;
> =20
> -	if (pstore_register(&efi_pstore_info)) {
> +	ret =3D pstore_register(&efi_pstore_info);
> +	if (ret) {
>  		kfree(efi_pstore_info.buf);
>  		efi_pstore_info.buf =3D NULL;
>  		efi_pstore_info.bufsize =3D 0;
> +		return ret;
>  	}
> =20
>  	return 0;

this can be simplified:

 		kfree(efi_pstore_info.buf);
 		efi_pstore_info.buf =3D NULL;
 		efi_pstore_info.bufsize =3D 0;
-		return ret;
 	}
=20
-	return 0;
+	return ret;

(though I think it's subjective if you like that or not.)

>  }
> =20
> -static __exit void efivars_pstore_exit(void)
> +static void efi_pstore_remove(struct platform_device *pdev)
>  {
> -	if (!efi_pstore_info.bufsize)
> -		return;
> -
>  	pstore_unregister(&efi_pstore_info);
>  	kfree(efi_pstore_info.buf);
>  	efi_pstore_info.buf =3D NULL;
>  	efi_pstore_info.bufsize =3D 0;
>  }
> =20
> +static const struct platform_device_id efi_pstore_ids[] =3D {
> +	{ "efivars", 0 },

Please don't initialize .driver_data unless you use it. Also ideally use
a designated initializer:

	{ .name =3D "efivars" },

> +	{ }
> +};
> +MODULE_DEVICE_TABLE(platform, efi_pstore_ids);

Best regards
Uwe

--wxeycgg7tzr5ea3w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmsEAYgACgkQj4D7WH0S
/k6cLwf/dm3ffrYv1p4IBxfa49Dkl2V+aqhKCf8DnX7DoAvRrIF+VN8MDJRXsPpZ
xUoI4Ib/e8HcJtWapt93x6HixNhhyJu+ER7R7XUr4Zv0nXQLx5hVBW+I1lEU0jm5
m5KU6kmVIpFOqonZkZTFybsarZxohCMjbFMtbULtrSfMyEoU45We6xZswM69CcJA
OvKrqfe3La8GQ0zcw0Su1m6uU/47tvgego6qiM2FxlRnWmZfol7fpxKLzbhkrbDS
T3K+HlNjsuoGFIl4LJUl18bvae0aQNAJlsHzX3RGO4HR/UnCodY4NdN8y3rnCCrT
RgCwA9T8hHJiqp8CDhVuy2qP30khdA==
=aonc
-----END PGP SIGNATURE-----

--wxeycgg7tzr5ea3w--
