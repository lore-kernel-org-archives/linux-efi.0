Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795697986;
	b=Azizer/xO7+eCbdB+ZgvSivhUPWy7te4oyWHz8LkGEJShktnYeccd+VL09DSFUlHQylO
	 RATOMkgTZ2e25KQXJA4xiAV5PboX/59XrhitB5ewMQyeGfIafjsSf0TjiwLr1PsLgwCec
	 af/unD1fgJa03CVduOcj0WcSpj34OQg+j8E38+vE01fgy9OMfCzmB09AsazEjWOwjNdvK
	 app8qsNZUQgzfo2ZxKc6wZg7ckhuOd6C6F8KXcaDQ/u2MAe6bsTq+MINvrBFba5k2LwgG
	 Krcvrbfpy1fdKRAZeeMrNOccmyD91t2FnQGN3ORT163AITnzSHAC5h+/8EOW9kO9FZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795697986;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=49SH4z4rBYPkYl0KdB8+pVuPcYez0jj+4mJuAYx3GXw=;
	b=WxhGkN5ntwWdjR4VN/UQ8DU5uAiWYCwJO4F/RUd14VF5GI6JXQe3Li9iz6OikIXZtXM3
	 bAcRBH9kVeT5CF98gmoxO5BKzHXk9Wy66yUGbnqJv0n5kyf5FkLgmXFXEQr1NwbnbkDjF
	 ZGDxuzo4qEvLDZeiBzl7/8WS7VW6xMD+fqsM6ahAyL/mX7jXSpphm/le5fUWVR5Xa0lMM
	 rw1/pQgBSsxPf7Nr9q0+XpHPos8wnghphrB1dd1fQASUwn8OWaNPC72q4qTy/4bu7R/v+
	 bOlxJ3CIduWCx5UQsxAXElgf73eNQoVVK7nrvB3evL2+Wmi41sPKpeIa80fYGR+jHPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mePhcBso;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B1D606A339
	for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mePhcBso
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FF91F0089E;
	Thu, 26 Nov 2026 12:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795697985;
	bh=49SH4z4rBYPkYl0KdB8+pVuPcYez0jj+4mJuAYx3GXw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mePhcBsoVAK0N8vmltlkIfgB3Eu/0HpmBzKHBt90hBv/3LplorT8A6tVy54ZQqDbA
	 uhFLVqVKHpleUGoMsNkTCIFP9WqazTA9e34dFbHNt7aTB5F/7TGOYxjNbBrzVv/nMs
	 XYNVy96i98bjhWmnDl3XhjS6hLWuX+3bZmBzufjOkxJ1LnBBWdzjbZ+RgAYMYWR0GV
	 jN2FgXy+zIoar7pMSVHJMfMMYhYSGmMgDXDXFclpUmrGqdrbGjvmFVmQH0cqGiflbO
	 Nvu5cfy144Go0UTeR5Zcsu4ZUzE23CrNBrcU7433iR9h2r2CohBFwU9ZfG+fz6iS3J
	 E87cLQtzOmddA==
Message-ID: <sashiko-outbox-235550@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] efi/libstub: fix building loongarch32 without zboot
 enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dmitry Antipov" <dmantipov@yandex.ru>, "Ard Biesheuvel" <ardb@kernel.org>
Cc: "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>, "WANG
 Xuerui" <kernel@xen0n.name>, linux-efi@vger.kernel.org, "kernel test robot" <lkp@intel.com>
In-Reply-To: <20261126124145.876953-1-dmantipov@yandex.ru>
References: <20261126124145.876953-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 12:59:44 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] efi/libstub: dropping $(zboot-obj-y) breaks all
  CONFIG_EFI_ZBOOT builds
- [High] efi/libstub: removing shift helpers breaks 32-bit
  CONFIG_EFI_ZBOOT link
- [High] efi/libstub: removing lib-clz_ctz.o breaks ZSTD
  CONFIG_EFI_ZBOOT link
- [Medium] efi/libstub: loongarch32 aliases shift helpers to
  instrumented kernel C code
--

commit 387fa3daffaccbaba76887c4a051e10a5a6deaf6
Author: Dmitry Antipov <dmantipov@yandex.ru>

efi/libstub: fix building loongarch32 without zboot enabled

This commit defines EFI stub symbol aliases for __lshrdi3 and __ashldi3 in
arch/loongarch/kernel/image-vars.h and removes the zboot helper object rules
from drivers/firmware/efi/libstub/Makefile.

> diff --git a/arch/loongarch/kernel/image-vars.h b/arch/loongarch/kernel/i=
mage-vars.h
> index e557ebd46c2b3..19202f4f84c2b 100644
> --- a/arch/loongarch/kernel/image-vars.h
> +++ b/arch/loongarch/kernel/image-vars.h
> @@ -8,6 +8,8 @@
>  #ifdef CONFIG_EFI_STUB
> =20
>  __efistub_strcmp		=3D strcmp;
> +__efistub___lshrdi3		=3D __lshrdi3;
> +__efistub___ashldi3		=3D __ashldi3;
>  __efistub_kernel_entry		=3D kernel_entry;
>  __efistub_kernel_asize		=3D kernel_asize;
>  __efistub_kernel_fsize		=3D kernel_fsize;

[Severity: Medium]
Is it safe for the LoongArch EFI stub to call the core kernel's __lshrdi3()
and __ashldi3() before kernel_entry?

Unlike RISC-V in commit a354b8de9ad6 ("riscv: add platform-specific double
word shifts for riscv32"), which implements these helpers in assembly,
LoongArch selects CONFIG_GENERIC_LIB_ASHLDI3 and CONFIG_GENERIC_LIB_LSHRDI3
and builds the C implementations in lib/ashldi3.c and lib/lshrdi3.c as
normal kernel objects.  They are marked notrace, which only suppresses
ftrace, not KCOV, UBSAN, branch profiling or stack-protector
instrumentation.

With CONFIG_KCOV=3Dy, the branches in __ashldi3() and __lshrdi3() call
__sanitizer_cov_trace_pc(), which dereferences current via the $tp register.
When efi_pe_entry() -> efi_handle_cmdline() calls memparse() in the pre-boot
EFI environment before kernel_entry initializes $tp to init_task, that
access crashes before the kernel boots.  Building lib-ashldi3.o and
lib-lshrdi3.o in drivers/firmware/efi/libstub/Makefile avoids kernel
instrumentation.

> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi=
/libstub/Makefile
> index bbab12b8eb4b2..bcf2a59816782 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -96,12 +96,7 @@ zboot-obj-y			:=3D zboot-decompress-gzip.o
>  CFLAGS_zboot-decompress-gzip.o	+=3D -I$(srctree)/lib/zlib_inflate
>  zboot-obj-$(CONFIG_KERNEL_ZSTD)	:=3D zboot-decompress-zstd.o lib-xxhash.o
>  CFLAGS_zboot-decompress-zstd.o	+=3D -I$(srctree)/lib/zstd
> -
> -zboot-riscv-obj-$(CONFIG_32BIT)	:=3D lib-ashldi3.o lib-lshrdi3.o
> -zboot-obj-$(CONFIG_RISCV)	+=3D lib-clz_ctz.o $(zboot-riscv-obj-y)
> -zboot-loongarch-obj-$(CONFIG_32BIT) :=3D lib-ashldi3.o lib-lshrdi3.o
> -zboot-obj-$(CONFIG_LOONGARCH)	+=3D lib-clz_ctz.o $(zboot-loongarch-obj-y)

[Severity: High]
Does removing lib-ashldi3.o and lib-lshrdi3.o break linking vmlinuz.efi.elf
on 32-bit RISC-V and 32-bit LoongArch when CONFIG_EFI_ZBOOT=3Dy?

The __efistub___ashldi3 and __efistub___lshrdi3 aliases in
arch/{riscv,loongarch}/kernel/image-vars.h are only included by
vmlinux.lds.S when linking vmlinux.  In
drivers/firmware/efi/libstub/Makefile.zboot, vmlinuz.efi.elf is linked as a
standalone binary with zboot.lds against only vmlinuz.o, zboot-header.o and
drivers/firmware/efi/libstub/lib.a, where efi_zboot_entry() ->
efi_handle_cmdline() still pulls in lib-cmdline.stub.o and leaves
__efistub___ashldi3 and __efistub___lshrdi3 unresolved, reintroducing the
build failure fixed by commit 442082297e3d ("riscv: fix building compressed
EFI image").

[Severity: High]
Does removing lib-clz_ctz.o break linking vmlinuz.efi.elf on RISC-V and
32-bit LoongArch when CONFIG_EFI_ZBOOT=3Dy and CONFIG_KERNEL_ZSTD=3Dy?

zboot-decompress-zstd.c uses __builtin_ctz(), __builtin_clz(),
__builtin_ctzll() and __builtin_clzll() in lib/zstd/common/bits.h, which
emit calls to __efistub___ctz* and __efistub___clz* when target instructions
are not enabled.  Because vmlinuz.efi.elf is linked standalone against
drivers/firmware/efi/libstub/lib.a without the kernel's lib/lib.a, dropping
lib-clz_ctz.o leaves those symbols undefined at link time.

> -lib-$(CONFIG_EFI_ZBOOT)		+=3D zboot.o $(zboot-obj-y)
> +lib-$(CONFIG_EFI_ZBOOT)		+=3D zboot.o

[Severity: High]
Does dropping $(zboot-obj-y) from lib-$(CONFIG_EFI_ZBOOT) break all
CONFIG_EFI_ZBOOT=3Dy builds across every architecture?

Without $(zboot-obj-y), neither zboot-decompress-gzip.stub.o nor
zboot-decompress-zstd.stub.o and lib-xxhash.stub.o are added to
drivers/firmware/efi/libstub/lib.a, so linking vmlinuz.efi.elf fails with
undefined references to __efistub_efi_zboot_decompress_init and
__efistub_efi_zboot_decompress from efi_zboot_entry().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126124145.8769=
53-1-dmantipov@yandex.ru?part=3D1
