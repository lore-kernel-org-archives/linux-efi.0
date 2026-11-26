Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795688787;
	b=Bs3uZTSemLjrDxVr9RlsfyDhj0a6NF1ij5fKMwXGhX85NP3WnXjzP8bgh+uSS4NnTd0+
	 zKP3FjQvcOgwFoWztfcY3rdXl4O7IawhZMCLAtT0O2dWJhxaNTdGzoUTU2HpJnAMXd4NN
	 Zs5zrdcpIIQbzCFWfJnEBbc2fK6CEtBE0H9tUzO9QeUnLzEISM3hcl8XlTfKldJg0qecz
	 7TW/ahv4WhVZPzTXWOOX0/logSD6wveKsMQPCq2G62GCzpmHgEvCUMvokkKrulGKSJLw7
	 h+Xec/nMPUBaBfGmD/SpjuRli8p1wObV2A6kPqH3G684obSJl9HmIri4n8uMt/yXAJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795688787;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8HqJpgTjLqsIB9FlJU/8bUc0XIA2qV5grQp8N4UJ5IQ=;
	b=lGkp45GR4D0K3bJockqhBNr/J3rcFxPSTfwU6vec7a2A6DNGkW4nyhImdprfaK777tk7
	 9YO/Acld5HL7utQXAJ89hDFEEUQaktJv3001GnlTRMDWFq+8+sQBoB77eoZ6H6V4M5Ygm
	 K9W0XQk2W345KOGWwxbRYuBGyzJjLkuAYOPo4oHSuYCu1AmCqNU87hLfohaLODrTXsRT8
	 u0w66kHcxnvmTPRv9vTkIq4U3rMyXSIhEkW9iRvOcFCL81WXdHLaWreDXkVZHNkKUtJlh
	 y2vhD9WJlljrmKlK8XCIU7N6yqvi4SAv93o6IDNUOt1a4XZ0O2vmOJLef3cOd1zH6Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cpg2D4ew;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8F1606A321
	for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 10:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cpg2D4ew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553F41F000C4;
	Thu, 26 Nov 2026 10:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795688786;
	bh=8HqJpgTjLqsIB9FlJU/8bUc0XIA2qV5grQp8N4UJ5IQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cpg2D4ew0olmBE1ZEcoPTWHXzb7ETrTYJlGtBGxJH7IwVCOHznFeQpQBX67CANCJs
	 NCDGUhcwXfQw2IrmIFrxE6BcKz/QViyh7m9b8Yh3yeXQXoXGsPtN2eMZte/SuqSYoF
	 0niyVfXz+hne1yRKkGvS7HuwiEuDFC7CNW3rR70OWxHU+g7XkGf2EC5JfJAYyK/0Hi
	 PvALOQBebdHFLeEUXanxOJrICr3kHEqqf2tiGwYtDPIwoy+08rjZhc7pZjVFrAonL6
	 X3lqJdboyS4DIW/Axhts4FE/l6z3ByP9UdzoB7zc85IxyaWVnqnNnaGrob7JkTd8t8
	 u2HsuUOhY6BbA==
Message-ID: <sashiko-outbox-235286@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] efi/libstub: fix building loongarch32 without zboot
 enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dmitry Antipov" <dmantipov@yandex.ru>, "Ard Biesheuvel" <ardb@kernel.org>
Cc: "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>, "WANG
 Xuerui" <kernel@xen0n.name>, linux-efi@vger.kernel.org, "kernel test robot" <lkp@intel.com>
In-Reply-To: <20261126101452.590895-1-dmantipov@yandex.ru>
References: <20261126101452.590895-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 10:26:25 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] efi/libstub: dropping $(zboot-obj-y) breaks all
  CONFIG_EFI_ZBOOT builds
- [High] efi/libstub: removing shift helpers breaks riscv32
  CONFIG_EFI_ZBOOT link
- [High] efi/libstub: removing lib-clz_ctz.o breaks ZSTD
  CONFIG_EFI_ZBOOT link
--

commit 903c012d44a1b7b277bbfa82862bc5644c32ea38
Author: Dmitry Antipov <dmantipov@yandex.ru>

efi/libstub: fix building loongarch32 without zboot enabled

This commit moves loongarch32 shift helper library objects from
CONFIG_EFI_ZBOOT to CONFIG_EFI_GENERIC_STUB and removes the riscv and
loongarch zboot helper objects from drivers/firmware/efi/libstub/Makefile.

> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi=
/libstub/Makefile
> index 0c5fbc21d2a29..6b569b648e374 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -97,11 +97,11 @@ CFLAGS_zboot-decompress-gzip.o	+=3D -I$(srctree)/lib/=
zlib_inflate
>  zboot-obj-$(CONFIG_KERNEL_ZSTD)	:=3D zboot-decompress-zstd.o lib-xxhash.o
>  CFLAGS_zboot-decompress-zstd.o	+=3D -I$(srctree)/lib/zstd
> =20
> -zboot-riscv-obj-$(CONFIG_32BIT)	:=3D lib-ashldi3.o lib-lshrdi3.o
> -zboot-obj-$(CONFIG_RISCV)	+=3D lib-clz_ctz.o $(zboot-riscv-obj-y)
> -zboot-loongarch-obj-$(CONFIG_32BIT) :=3D lib-ashldi3.o lib-lshrdi3.o
> -zboot-obj-$(CONFIG_LOONGARCH)	+=3D lib-clz_ctz.o $(zboot-loongarch-obj-y)

[Severity: High]
Does removing lib-ashldi3.o and lib-lshrdi3.o on 32-bit RISC-V break
linking vmlinuz.efi.elf when CONFIG_EFI_ZBOOT is enabled, regressing
442082297e3d ("riscv: fix building compressed EFI image")?

The aliases in arch/riscv/kernel/image-vars.h are only included in
vmlinux.lds.S when linking vmlinux.  Makefile.zboot links vmlinuz.efi.elf
as a standalone binary using zboot.lds and
drivers/firmware/efi/libstub/lib.a, where efi_zboot_entry() ->
efi_handle_cmdline() -> memparse() still needs __efistub___ashldi3 and
__efistub___lshrdi3.

[Severity: High]
Does dropping lib-clz_ctz.o for CONFIG_RISCV and CONFIG_LOONGARCH break
CONFIG_EFI_ZBOOT builds with CONFIG_KERNEL_ZSTD=3Dy?

zboot-decompress-zstd.c uses __builtin_ctz* and __builtin_clz* via
lib/zstd/common/bits.h.  On RISC-V without Zbb and on 32-bit LoongArch,
the compiler emits calls to __ctz* and __clz* that remain unresolved when
linking vmlinuz.efi.elf against drivers/firmware/efi/libstub/lib.a.

> -lib-$(CONFIG_EFI_ZBOOT)		+=3D zboot.o $(zboot-obj-y)
> +extra-loongarch-obj-$(CONFIG_32BIT)	:=3D lib-ashldi3.o lib-lshrdi3.o
> +extra-obj-$(CONFIG_LOONGARCH)	+=3D $(extra-loongarch-obj-y)
> +lib-$(CONFIG_EFI_GENERIC_STUB)	+=3D $(extra-obj-y)
> +
> +lib-$(CONFIG_EFI_ZBOOT)		+=3D zboot.o

[Severity: High]
Does removing $(zboot-obj-y) from lib-$(CONFIG_EFI_ZBOOT) break all
CONFIG_EFI_ZBOOT builds?

zboot-obj-y holds zboot-decompress-gzip.o or zboot-decompress-zstd.o and
lib-xxhash.o, so dropping $(zboot-obj-y) leaves
__efistub_efi_zboot_decompress_init and __efistub_efi_zboot_decompress
undefined when linking vmlinuz.efi.elf from zboot.o.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126101452.5908=
95-1-dmantipov@yandex.ru?part=3D1
