Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684530;
	b=UkN8AlZcGa6LvKhSUVXvP7uTfw8ClIPTx56fAfsju59+bECbw3sntcVD9wKEHdY549AA
	 FtYvtmseCpV9TBwHiYq/soduMwfwHmsJCBfSWyU1xjkqOXiXKpAUl12EcripwE3QktZ3b
	 GGfNgLnQ6t8As4p1IH7gSIvzyKO5R5KuguBuDoiRKIm1QdjOv0CBICRRoKJi62qdCBf2v
	 fEddy28eJ7EsTL1ebz/qSa87ceYhbpY9nqPYwOZnw1XVtrHHrizAZADUEsRk5scYff9q1
	 1ZydVmYx6EYFg1Vq3qCR/QwKAnTAY3ISG2b80NbIj8jxvcfMMGqMDKs2A5gzZAa4Bcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684530;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZAb0YOayIPGTB5WHH3L2EnJ+sh+Go4NLg8MF443ztgo=;
	b=jzIbOcjGXaQ/nkX7FCC1/kD32QYPc6WYVqH3Lf8GylTWOCuO2qDlxOf2UvAdKdI3z4U8
	 KoMI12eynCl8ZMxDUAzDmkY4kHtRXvapYswYzfB68p74vVjjS+W5aBjGudhqRrLihXklC
	 Tk63Oa6tNvH+hAs4SdZ+ah43A82YhbSzUyIhOhvxchI6/nGEWW73oPiaRejglr+p8x7tm
	 UTjzKPnp/FVco3ijuYyX/7nx9hvnNc9YYnbzgD/WQ9mi/+67u3bZnO6ajovblU1feId3I
	 WH/HE5TDzuQa3RS99muPeSrqlKb1NQrgJODGvRrzT0Qtvdz905cakMzb4/1wAdbhB4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eR8MHj5g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B32606A319
	for <linux-efi@vger.kernel.org>; Thu, 22 Oct 2026 15:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eR8MHj5g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D491F01825;
	Thu, 22 Oct 2026 15:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792684529;
	bh=ZAb0YOayIPGTB5WHH3L2EnJ+sh+Go4NLg8MF443ztgo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eR8MHj5gp1LmYwJu8G7UqVdEMjGKOGY8vtOshgz+sDXynh6WgMSKo4MCHq5toCJDB
	 Z2nGLkrGlrpTM3gUW7jQq4t8EyNY32PDPoF1ICEKiXUbQnXIOIWEcRrORKWcDiFL+u
	 m4hkxlW67tT+PO19hRR/15Dmcnm+L7/EK/aNpSez9nAyLPtxFq4DOIL0biFYefeyoa
	 E12L+2vo6tQQxnA0Tc6lbr+acr8FQkC0OuVMXQctSMZcd73yRO0QdhALZu+gUIhRVa
	 LzPtO44Wit2BtprUPz1WuaysqHnh3CuTcaqRZngwucrkv69UU3ioIIHffHRQNhRsfn
	 X73mR4wZc8CVQ==
Message-ID: <sashiko-outbox-181738@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] x86/efi: Drop stale INITRD table entry on kexec boot
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jaehee Park" <jaehee3park@gmail.com>, ardb@kernel.org
Cc: sebastien@wenske.fr, ilias.apalodimas@linaro.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, linux-efi@vger.kernel.org
In-Reply-To: <20261022153954.51577-1-jaehee3park@gmail.com>
References: <20261012133712.618913-1-sebastien@wenske.fr>
 <20261022153954.51577-1-jaehee3park@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:55:28 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] x86/efi: efi_reuse_config() skips INITRD invalidation when data->s=
mbios is 0
- [High] x86/efi: incomplete stale INITRD table invalidation in efi_reuse_c=
onfig()
--

commit 475363733715c59cee77eadc0fb6905b395409e1
Author: Jaehee Park <jpark@coreweave.com>

x86/efi: Drop stale INITRD table entry on kexec boot

This commit invalidates the LINUX_EFI_INITRD_MEDIA_GUID entry in
efi_reuse_config() on x86 so that a kexec kernel does not consume and zero
a stale EFI_LOADER_DATA table address that may now overlap the new
initramfs.

> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirk=
s.c
> index 02c56a02eb9bc..d7f4b985b2794 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -615,6 +615,13 @@ int __init efi_reuse_config(u64 tables, int nr_table=
s)
>  		if (!efi_guidcmp(guid, EFI_MEMORY_ATTRIBUTES_TABLE_GUID))
>  			((efi_config_table_64_t *)p)->table =3D EFI_INVALID_TABLE_ADDR;
> =20
> +		/*
> +		 * The EFI stub allocated this table in loader data, which may
> +		 * have been reused. Kexec passes its initrd in boot_params.
> +		 */
> +		if (!efi_guidcmp(guid, LINUX_EFI_INITRD_MEDIA_GUID))
> +			((efi_config_table_64_t *)p)->table =3D EFI_INVALID_TABLE_ADDR;
> +

[Severity: High]
Will efi_reuse_config() in arch/x86/platform/efi/quirks.c still skip
invalidating LINUX_EFI_INITRD_MEDIA_GUID when data->smbios is zero?

Before mapping the configuration table array and entering the loop,
arch/x86/platform/efi/quirks.c:efi_reuse_config() checks:

	if (!efi_setup)
		return 0;

	if (!efi_enabled(EFI_64BIT))
		return 0;

	data =3D early_memremap(efi_setup, sizeof(*data));
	if (!data) {
		ret =3D -ENOMEM;
		goto out;
	}

	if (!data->smbios)
		goto out_memremap;

On UEFI systems that only provide a 64-bit SMBIOS 3.0 entry point
(SMBIOS3_TABLE_GUID) and no legacy 32-bit SMBIOS 2.x entry point
(SMBIOS_TABLE_GUID), efi.smbios remains EFI_INVALID_TABLE_ADDR. In
drivers/firmware/efi/efi.c:systab_show(), /sys/firmware/efi/systab only
emits SMBIOS3=3D and omits SMBIOS=3D:

	if (efi.smbios3 !=3D EFI_INVALID_TABLE_ADDR)
		str +=3D sprintf(str, "SMBIOS3=3D0x%lx\n", efi.smbios3);
	if (efi.smbios !=3D EFI_INVALID_TABLE_ADDR)
		str +=3D sprintf(str, "SMBIOS=3D0x%lx\n", efi.smbios);

When userspace kexec-tools populates struct efi_setup_data from
/sys/firmware/efi/systab on such a system, data->smbios is left as 0.
When the kexec or kdump kernel boots, efi_reuse_config() takes the
goto out_memremap path before reaching the configuration table loop.

On x86, the kexec initrd passed via boot_params is read through
boot_params.hdr.ramdisk_size in arch/x86/kernel/setup.c:get_ramdisk_size()
without setting phys_initrd_size:

	u64 ramdisk_size =3D boot_params.hdr.ramdisk_size;

	ramdisk_size |=3D (u64)boot_params.ext_ramdisk_size << 32;

	if (ramdisk_size =3D=3D 0)
		ramdisk_size =3D phys_initrd_size;

As a result, phys_initrd_size is still 0 when
drivers/firmware/efi/efi.c:efi_config_parse_tables() runs:

	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) &&
	    initrd !=3D EFI_INVALID_TABLE_ADDR && phys_initrd_size =3D=3D 0) {
		struct linux_efi_initrd *tbl;

		tbl =3D early_memremap(initrd, sizeof(*tbl));
		if (tbl) {
			phys_initrd_start =3D tbl->base;
			phys_initrd_size =3D tbl->size;
			tbl->base =3D tbl->size =3D 0;
			early_memunmap(tbl, sizeof(*tbl));
		}
	}

Because drivers/firmware/efi/libstub/efi-stub-helper.c:efi_load_initrd()
allocated tbl in EFI_LOADER_DATA memory during the initial boot:

	status =3D efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(initrd),
			     (void **)&tbl);

that physical address is reclaimed as normal RAM after ExitBootServices()
and can be overwritten with 16 bytes of zeros when efi_reuse_config()
returns early on !data->smbios (or when !efi_setup or
!efi_enabled(EFI_64BIT)), corrupting whatever kexec or kdump segment now
resides there.

Should data->smbios only guard the SMBIOS_TABLE_GUID assignment inside the
loop rather than returning early from efi_reuse_config()?

Also, since non-x86 EFI architectures do not call efi_reuse_config(), could
a kexec boot without an initrd (where phys_initrd_size =3D=3D 0) on those
architectures still dereference and zero the stale EFI_LOADER_DATA address
in efi_config_parse_tables()?

>  		p +=3D sz;
>  	}
>  	early_memunmap(tablep, nr_tables * sz);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022153954.5157=
7-1-jaehee3park@gmail.com?part=3D1
