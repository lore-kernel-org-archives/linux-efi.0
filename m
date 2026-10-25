Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792934027;
	b=GGFAZsPX7kPXu+bJnyZdfhRmIZNaiGY0ZBxgDo9wbTUd9FPvJMYETZ38JOiYRgJBIfYc
	 QsQAMRwhTa7t4WfIScI8NrlygnoCoLkM1umtWV23L2uzDxENJOzEAylXQZPO2q+XuiGCP
	 QieBIZNpgvvF0ACbBJpO/MaSQQ738StQRJObg/2XsH3m1Mdqiggk6bXTzt0U6D3wXBbVA
	 bbkVL83rSesGUY1y/vTzgxDRA+vt77aCuqy65z2m14KSaL7MGliiu1CgrxTPm6xCP7vtS
	 ugKrF5nQsmbrXtLSHk/jo6xEqiEJMoLaIjVH1gO0AlP0X9DDmvobvjGbI4F9t5VE7ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792934027;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=I85GjuYGFajQ5AdfshYwqYSmsEV1VIf051vTVtj36NI=;
	b=qOke4bWrvvhi1aa+e/xGC2W63mZU+/NJvIvjM53wVAa8O2ODLyIoWrvp3Rsx8Dimc2Xs
	 rzM7Yy3pgmzfpIzIXmLh125kCGm3/aV3ZxatIxqQS3v/CxTnC5x5yD8K0jvLkD2noPjTY
	 8Xi6rhplkqwVZTp4AmTOyalqqj3vqZAp+DYdRJL0GnWC4vtnCPJoCTEgmpZD0eCooaW64
	 RkBKG2yTh0oLpH3pV02tsZ39UPhvpkofWzA0Dt0qt2VCx4ImLs+yfR0Llc+kz7FHJ5T6y
	 7uLKdrG8Z6Kqnx/APEXkV1dWn85Gc0FWn5hLq5wrTT+QpPA5bJIn4wDYKUw4qe52z4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gnnJmOPf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5E5606A31A
	for <linux-efi@vger.kernel.org>; Sun, 25 Oct 2026 13:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gnnJmOPf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DBA1F01825;
	Sun, 25 Oct 2026 13:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792934026;
	bh=I85GjuYGFajQ5AdfshYwqYSmsEV1VIf051vTVtj36NI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gnnJmOPf1cMudTqudIsLFqeeApOL/NxI7McoP7YSw5E9whNMxQ52oW+0dbiBX0+RK
	 b2oUqpUJdDI9RXpgk9UZ0Jzho1mtel5Nh6Avfl2/Z854KXkCQNq+DAqT3q5VsR6PFY
	 UhPYtgwseKd0gIbKOnfZzbwhJqM8xsEMk+bD+rxBvDrYkBtR6C/DqZ3T0KtxBS9lvn
	 oqFsnPtXoQmFByyyxOZdYuJEmyqizt3x2GOfY8QXBSD4l4qp4ygpgkv8xl5/yjSN3n
	 qWBTixPAZq8AGuplppkOOsammd7QYnSK6A1xg0u87se9AZ2dHvSAVy7//OT7DFLx/M
	 SbHo00qKHYTNw==
Message-ID: <sashiko-outbox-184220@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/7] init: add DPS root partition type UUID
 definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Mailhol" <mailhol@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Davidlohr
 Bueso" <dave@stgolabs.net>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>
Cc: linux-efi@vger.kernel.org, "Dave Hansen" <dave.hansen@intel.com>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Helge Deller" <deller@gmx.de>, "Matthew
 Wilcox" <willy@infradead.org>
In-Reply-To: <20261025-discoverable-root_partitions-v2-2-fb77d0821fab@kernel.org>
References: <20261025-discoverable-root_partitions-v2-0-fb77d0821fab@kernel.org>
 <20261025-discoverable-root_partitions-v2-2-fb77d0821fab@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 13:13:45 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] init: DPS_ROOT_PARTITION_TYPE_UUID sets 64-bit UUID on 32-bit LO=
ONGARCH
--

commit 109ce0d2c6fc812a6bc94f72e97807013dc5fc56
Author: Vincent Mailhol <mailhol@kernel.org>

init: add DPS root partition type UUID definitions

This commit adds the hidden DPS_ROOT_PARTITION_TYPE_UUID string Kconfig
symbol populated with the Discoverable Partitions Specification root
partition type UUIDs for EFI-supported architectures, along with the
derived DPS_ROOT_AUTO_DISCOVERY boolean symbol.

Link: https://uapi-group.org/specifications/specs/discoverable_partitions_s=
pecification/

> diff --git a/init/Kconfig b/init/Kconfig
> index b31aa298c4fe5..133854355697b 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -2166,6 +2166,20 @@ config ARCH_HAS_PREPARE_SYNC_CORE_CMD
>  config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
>  	bool
> =20
> +config DPS_ROOT_PARTITION_TYPE_UUID
> +	depends on EFI && EFI_PARTITION
> +	string
> +	default "69dad710-2ce4-4e3c-b16c-21a1d49abed3" if ARM
> +	default "b921b045-1df0-41c3-af44-4c6f280d3fae" if ARM64
> +	default "77055800-792c-4f94-b39a-98c91b762bb6" if LOONGARCH

[Severity: Medium]
Should the LOONGARCH default also depend on 64BIT, matching the RISCV &&
64BIT check on the next line?

The UUID 77055800-792c-4f94-b39a-98c91b762bb6 is defined by the
Discoverable Partitions Specification specifically for 64-bit LoongArch
(SD_GPT_ROOT_LOONGARCH64), and the specification does not define a root
partition type UUID for 32-bit LoongArch.

In arch/loongarch/Kconfig, config LOONGARCH unconditionally selects EFI and
supports both 32-bit and 64-bit kernel builds (such as
arch/loongarch/configs/loongson32_defconfig):

arch/loongarch/Kconfig:
config LOONGARCH
    ...
	select EFI
	select GENERIC_ATOMIC64 if 32BIT
    ...
config 32BIT
	bool "32-bit kernel"

config 64BIT
	bool "64-bit kernel"

When building a 32-bit LoongArch kernel (CONFIG_LOONGARCH=3Dy, CONFIG_32BIT=
=3Dy,
CONFIG_EFI=3Dy, and CONFIG_EFI_PARTITION=3Dy), DPS_ROOT_PARTITION_TYPE_UUID=
 gets
populated with the 64-bit LoongArch UUID and DPS_ROOT_AUTO_DISCOVERY is
enabled. Because a 32-bit LoongArch kernel sets elf_check_arch to
elf32_check_arch in arch/loongarch/include/asm/elf.h and only loads
ELFCLASS32 binaries, wouldn't early_lookup_dps_root() auto-discover and
mount a 64-bit LoongArch root partition when root=3D is omitted, and then f=
ail
to execute its 64-bit userspace?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025-discoverab=
le-root_partitions-v2-0-fb77d0821fab@kernel.org?part=3D2
