Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE263FCC
	for <linux-efi@vger.kernel.org>; Sun,  9 Aug 2026 04:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786249097; cv=none; b=qpz+jH59saD/Rl1DRfTgYM7/gbIIpIQomnf7Z9rYA3TOM8kGwzaasTTTUFOCbKrgxXoj0P2r/gDvIBsdI3Tv3L5+yVinj4W+AToxWiF1exrmHZEf0pyILiQibu4px5gskYnlViZU38Sdm0cLJP3XVAIyiygltXwzo9PIgX7R1aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786249097; c=relaxed/simple;
	bh=M4/vJhWQLgkh4a7nKoBDxfLygKuaZXWnBHCnT006Jlc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uBgfSR0uma2u/MOVHUneZwYO8k12zmbu2As0XlKcN3GDOiN1qVl1KJGmUfLbuP25uEnujSjQi8oe4jCads3YqTG4f+I3CcvIZJg8xIDsDP2yih2MA/9p2edps/N7tezeRf1tqpPrkO4K7OCXMf/Dk4hbpfZ4ZjZhhFj4EG2h3qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BWqR2OoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BWqR2OoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030CB1F00A3D
	for <linux-efi@vger.kernel.org>; Sun,  9 Aug 2026 04:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786249096;
	bh=j3nl1oGlrcfuCJuGBdIMdIDErS4NCVUDQGrDn8WbrKY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BWqR2OoKgA28BeVh3Tm2EUcOjEZnC39w2oYDR+RumJ0+Zfy9UrFNzlUMMWe6DTogV
	 Wf+sIzEfuyhbUINfv+0VurPDdJG51M2uZWhkBBvaqJ8kwgtV1U7fjfd5HytQtxk++J
	 gBB0qGmAr3XMfYyfSES3OSr3PgNSmBkhzFArQlrCuaLeKQrjm8/7N6n6/dywaNFU8m
	 OFgCa6oc6mUFIs4oRxh/1pEyFqxwCZk10TWBqIurV8I0ZHQb1XBwxoYXgQ+skJjr+G
	 EVcz/4EdA5ZZ0Qwqiw49wfVW+xBjgZuUyjgTeaIUnvn5XGib+ONyHzpMT7C6m7LY1j
	 cftS7HORAGe4A==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a1b51723a9so1237162a12.1
        for <linux-efi@vger.kernel.org>; Sat, 08 Aug 2026 21:18:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrUc/qBd6LSJ3YzSFOXJk1zum6icTfshYlhskyJ8357jQv5TTcivIN1Yzuu+ct0x3zrOS4mE0kyrpI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjvfLAz6cHb04ncm5NdObAj2r4haUf6FeHfTisDR6so1wcgGYW
	/p+B3Jg2bLneXss34c+OKPnI4FubnJqeMrP26EakYgZOvVW52hL8DmBN/phfEITgOBJ+DmfDr2Z
	2uTI5PiI2W3V9G7MU+iApEv91dEg7JgA=
X-Received: by 2002:a05:6402:5d0:b0:6a1:245e:525a with SMTP id
 4fb4d7f45d1cf-6a14f26eb8emr17244030a12.19.1786249094682; Sat, 08 Aug 2026
 21:18:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807103714.33074-1-dongtai.guo@linux.dev> <20260807103714.33074-2-dongtai.guo@linux.dev>
In-Reply-To: <20260807103714.33074-2-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 9 Aug 2026 12:18:04 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4xxPXVRNXP42CBtMdVXbBZ4E6A997jZmw7HpEUSFAj9g@mail.gmail.com>
X-Gm-Features: AUfX_mzdXzAu0LbrcSZLHxk0mDTfusrkGeDoTo4UC_Q7T6b0NAW8AH8IYMcYy6c
Message-ID: <CAAhV-H4xxPXVRNXP42CBtMdVXbBZ4E6A997jZmw7HpEUSFAj9g@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] efi: add a KHO configuration table GUID
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	shuah@kernel.org, ardb@kernel.org, guodongtai@kylinos.cn, kernel@xen0n.name, 
	graf@amazon.com, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, George,

On Fri, Aug 7, 2026 at 6:38=E2=80=AFPM George Guo <dongtai.guo@linux.dev> w=
rote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> Kexec Handover (KHO) passes the address of its state FDT and of its
> scratch area from the current kernel to the next one.  On architectures
> that boot with a device tree, the current kernel writes the
> linux,kho-fdt and linux,kho-scratch properties into /chosen, and the next
> kernel reads them back in early_init_dt_check_kho().
>
> Architectures that boot through EFI without a device tree have no such
> channel.  LoongArch is one of them: its efistub passes the EFI system
> table and the command line to the core kernel directly and never creates
> an FDT.  x86 has the same problem and carries the state out of band
> instead, in a struct kho_data in the setup_data chain of its boot
> protocol.
>
> Add an out-of-band channel for EFI: a LINUX_EFI_KHO_TABLE_GUID
> configuration table entry, under a randomly generated GUID, pointing at a
> struct linux_efi_kho_data.  The
> current kernel loads the structure and an extended configuration table as
> kexec segments, then switches the EFI system table to the new table
> before jumping.  The next kernel finds the entry by GUID and calls
> kho_populate().
>
> The structure carries no version field.  An incompatible change to the
> layout must use a new GUID, which is the usual rule for EFI configuration
> tables.  The handover payload itself is versioned separately, by the
> compatible string of the KHO state FDT that kho_populate() checks.
>
> This patch adds the definitions only.  LoongArch is the first user; any
> other EFI architecture without a boot FDT can use the same channel.
>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  include/linux/efi.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index ccbc35479684..789ab9e4312a 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -422,6 +422,7 @@ void efi_native_runtime_setup(void);
>  #define LINUX_EFI_COCO_SECRET_AREA_GUID                EFI_GUID(0xadf956=
ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
>  #define LINUX_EFI_BOOT_MEMMAP_GUID             EFI_GUID(0x800f683f, 0xd0=
8b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
>  #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID    EFI_GUID(0xd5d1de3c, 0x10=
5c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
> +#define LINUX_EFI_KHO_TABLE_GUID               EFI_GUID(0xc941b6c7, 0x7b=
3f, 0x4af6,  0x9e, 0x50, 0xfc, 0xb3, 0xa8, 0x86, 0x8a, 0x17)
I don't know whether it is allowed to define a new TABLE ID while
doesn't touch the UEFI SPEC.

Huacai

>
>  #define RISCV_EFI_BOOT_PROTOCOL_GUID           EFI_GUID(0xccd15fec, 0x6f=
73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
>
> @@ -1271,6 +1272,29 @@ struct linux_efi_memreserve {
>
>  void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
>
> +/*
> + * The LINUX_EFI_KHO_TABLE_GUID config table points to this structure.  =
It
> + * carries the kexec handover (KHO) state from the current kernel to the=
 next
> + * one: the addresses of the KHO state FDT and of the scratch area.
> + *
> + * This is the handover channel for architectures that boot through EFI =
without
> + * a device tree, where the /chosen linux,kho-fdt and linux,kho-scratch
> + * properties read by early_init_dt_check_kho() are not available.  The =
current
> + * kernel loads the structure and an extended configuration table as kex=
ec
> + * segments; the next kernel finds it by GUID and calls kho_populate().
> + *
> + * The layout is an ABI between the two kernels and is fixed.  It carrie=
s no
> + * version field: an incompatible change must use a new GUID, and the ha=
ndover
> + * payload itself is versioned separately by the compatible string of th=
e KHO
> + * state FDT, which kho_populate() checks.
> + */
> +struct linux_efi_kho_data {
> +       u64 fdt_addr;
> +       u64 fdt_size;
> +       u64 scratch_addr;
> +       u64 scratch_size;
> +} __packed;
> +
>  /*
>   * The LINUX_EFI_MOK_VARIABLE_TABLE_GUID config table can be provided
>   * to the kernel by an EFI boot loader. The table contains a packed
> --
> 2.53.0
>
