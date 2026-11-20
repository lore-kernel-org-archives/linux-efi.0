Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795181990;
	b=rxxdnsfClMlmfPRQM1n3fHCs3MDduQv6gbnz2TD1gFaHTc2hGwygdj4DHgrnVvsp+sbJ
	 IdmY4qHyUBmDD/vOkGGmFdUMqf58nqpGhlL8rRcAQeedreHBP9QbcSz9ld2BGofwlS/sa
	 YBi7p2I9e9Rve1yGAKJ7h110JBshj44YWyD859h9zkYE8ZiEoc64aT4pb0BJlh+jZx5RI
	 +H6E7FXsQuir/8owi3FzFIpGRbuUUwVP/aIX7LrUwRYxKgDMdFzJ59CPzeZX4DfzgYcAU
	 dvrLqale6lpSaZZ9AC7OSAzdZJIgGV/leJG0BWe3bf7I+RznQ4nXXWMb0eCLOpHp4UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795181990;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=A+iG8FFLNf317j5OCmej7mdTdbB2uwDAQbnIjRIUmuY=;
	b=JUY+/3y0ATkdUVaJyVw7QHNu2WARRvu+znpgxPsEFShfJU2eRjrAJLiXPc34ZYH0JrZX
	 DCsMCLm0f2Nb90PPlv3tbR/HxwSiCMLovIyUrf67Zp7cmjA9oTG067WDlEMApU5o7/Hgr
	 ETFAo7Z55jB1WOGQvplKjq7EWuTM1GA0xO1ly/EnQg/3E6d4GfjIuv4jeSw5l/oueoEk3
	 37k17R/uE6kkGWV3Vq37PwsfylIOS+XIXsg/itpVttu8OBdEMJvNcG7fMD34+qsQTFwwa
	 ye+nL+YvQhSZ3TBm9mKJ31xXx4MJoFBnDXM8SZyfJZbYtJn06B4IbRc+gh4q6ktTw5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eL+VrfHy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099FF606A325
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 13:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eL+VrfHy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427591F000C0;
	Fri, 20 Nov 2026 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795181989;
	bh=A+iG8FFLNf317j5OCmej7mdTdbB2uwDAQbnIjRIUmuY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eL+VrfHyyvu+vBxP2IvCcGQ2I91sfNoh/EEOOJZPOF1O7EsLHTB69uwbe/C3KdJiE
	 heldybTNR10ytjzJJyPy3OsDlpZaBNwRR5MxJK7BJRU5vumCeSYOVLE9t25PxEaTbL
	 iZgEtaFct4ScQA+YTkSRWJhhaAQW2jpKFDh4kNDEXqvzcU07Oj2OlmKuSgw4yd4zEa
	 SVe5tR82nE+N4CelT3ltKpa0JgPy7mL2gfaXsqS1zTX+R731eChWJiyloomCcGYSPh
	 6ba+0EkNH55Zkp1GL1K2RiHNFP13ZpeFF+b7P+prXSg6SdJaIaD9ifanxddqQeu6CA
	 nA0iFuIPLR1Gw==
Message-ID: <sashiko-outbox-225258@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] efi: pstore: Convert into a platform driver for
 'efivars'
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Kees Cook" <kees@kernel.org>, "Guilherme
 G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20261120131827.480055-6-ardb+git@google.com>
References: <20261120131827.480055-4-ardb+git@google.com>
 <20261120131827.480055-6-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 13:39:48 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] efi: pstore: missing efivars device for non-generic efivars
  backends
- [Medium] efi: pstore: stale efivars_pstore_autoprobe_disable breaks
  manual bind
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] efi: use-after-free in __efi_queue_work() [1]
--

commit ff714ad400a8da4c7c0e25c05fa514c713686cad
Author: Ard Biesheuvel <ardb@kernel.org>

efi: pstore: Convert into a platform driver for 'efivars'

This commit converts efi-pstore into a platform driver matching the
"efivars" platform device and only registers that device when
EFI_RT_SUPPORTED_SET_VARIABLE is advertised.

> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi=
-pstore.c
> index 19a7e4fe5b524..44571fa1dd885 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
[ ... ]
> @@ -228,13 +231,17 @@ static struct pstore_info efi_pstore_info =3D {
>  	.erase		=3D efi_pstore_erase,
>  };
> =20
> -static __init int efivars_pstore_init(void)
> +static int efi_pstore_probe(struct platform_device *pdev)
>  {
> +	int ret;
> +
>  	if (!efivar_supports_writes())
> -		return 0;
> +		return -ENODEV;
> =20
> -	if (efivars_pstore_disable)
> -		return 0;
> +	if (efivars_pstore_autoprobe_disable) {
> +		efivars_pstore_autoprobe_disable =3D false;
> +		return -ENODEV;
> +	}

[ ... ]

> +static __init int efivars_pstore_init(void)
> +{
> +	efivars_pstore_autoprobe_disable =3D efivars_pstore_disable;
> +	return platform_driver_register(&efi_pstore_driver);
> +}

[Severity: Medium]
Can efivars_pstore_autoprobe_disable stay true after
efivars_pstore_init() returns, causing the first manual bind via sysfs to
fail with -ENODEV?

If pstore_disable is set and platform_driver_register() does not reach the
efivars_pstore_autoprobe_disable check in efi_pstore_probe() (for example
when drivers_autoprobe is disabled on the platform bus, or when
efivar_supports_writes() is false during initial registration before a
late efivars provider registers), efivars_pstore_autoprobe_disable is not
cleared.  Resetting efivars_pstore_autoprobe_disable to false in
efivars_pstore_init() after platform_driver_register() returns would avoid
leaving it set past initial registration.

> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 9bc22de0d67ee..e98436a9bb9bd 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -483,7 +483,8 @@ static int __init efisubsys_init(void)
>  		error =3D efivar_ssdt_load();
>  		if (error)
>  			pr_err("efi: failed to load SSDT, error %d.\n", error);
> -		platform_device_register_simple("efivars", 0, NULL, 0);
> +		if (efi_rt_services_supported(EFI_RT_SUPPORTED_SET_VARIABLE))
> +			platform_device_register_simple("efivars", 0, NULL, 0);
>  	}
> =20
>  	BLOCKING_INIT_NOTIFIER_HEAD(&efivar_ops_nh);

[Severity: High]
Does gating efi-pstore on the "efivars" platform device registered here
prevent efi-pstore from probing on platforms that provide writable
variables through non-generic efivars_register() backends?

Before this change, efivars_pstore_init() checked efivar_supports_writes()
and registered with pstore directly without requiring the "efivars"
platform device.  With this change, platforms where generic EFI runtime
services do not advertise EFI_RT_SUPPORTED_SET_VARIABLE at boot, or where
EFI_BOOT is not set (such as Coreboot GSMI in
drivers/firmware/coreboot/gsmi.c, OP-TEE StandaloneMM in
drivers/firmware/efi/stmm/tee_stmm_efi.c, or Qualcomm UEFI Secure App in
drivers/firmware/qcom/qcom_qseecom_uefisecapp.c), never register the
"efivars" platform device, so efi-pstore cannot probe or be bound via
sysfs.

Conversely, if EFI_RT_SUPPORTED_SET_VARIABLE is set in
efi.runtime_supported_mask but generic_ops_supported() returns false in
generic_ops_register() (such as on Qualcomm systems where
efi.get_next_variable() returns EFI_UNSUPPORTED), efisubsys_init() still
registers the "efivars" platform device while __efivars is NULL, causing
efi_pstore_probe() to see !efivar_supports_writes() and fail with -ENODEV
before the platform-specific efivars driver probes.

[Severity: Critical]
This problem wasn't introduced by this patch, but if efisubsys_init()
fails [1], can destroying efi_rts_wq without clearing
EFI_RUNTIME_SERVICES in efi.flags cause a use-after-free in
__efi_queue_work()?

drivers/firmware/efi/efi.c:efisubsys_init() {
    ...
err_destroy_wq:
	if (efi_rts_wq)
		destroy_workqueue(efi_rts_wq);

	return error;
}

When a failure in efisubsys_init() reaches err_destroy_wq, efi_rts_wq is
destroyed while EFI_RUNTIME_SERVICES remains set, so a later runtime
service call through __efi_queue_work() passes
efi_enabled(EFI_RUNTIME_SERVICES) and passes the freed efi_rts_wq pointer
to queue_work().

[1] https://sashiko.dev/#/bug/linux-a1f302ad-3fdd-4e74-a0f8-c73ca89f1ff3

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120131827.4800=
55-4-ardb+git@google.com?part=3D2
