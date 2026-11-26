Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795694766;
	b=gFxCgnT8qhT0op9NS9gNPCSWqbckV2r9mE49Zg/DWcJayQzAFrwAlG61jHYuGLCMgQYk
	 br/NkHgK2EVil3HIXE9eF9M/yYew1N8LBGB7aO8/EMvMAO4NIKfZTakBV7jqMS3r+deXk
	 X5oDpGj1S3BRxEugzBJHbPQAr0BKgwxk818SQ0zcvNWziR7iQvHH7TudSeZym4kyTxLRo
	 yrGCFGbVulHV9zI68PprM7Gbih4coiY03OfK4YUej+Ph8JobZMSZcLXvw0eiVCCUpsIKW
	 oMLWm/6LLQidPxKeGlFb9ltPMyWNG2roc7lzYlKVyn1pOFvz4JkT/j4DctcXD2mMLUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795694766;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BYdAH1zodMk6GcU9BR3r0etHoWawAK2VHYBxoH+UIZk=;
	b=BSGJJmx6K2MEoKZTjLO2DPOxu5T6Wl4BnotAtwKOHYhULTUE8yp1Rs4GBgu2uNCoGJDS
	 hJbCvdet88LSimtdWmSMRLvBBcHU5aymbsPmlgdOgilHyzpBnS1571YbAR0alftHMLAiu
	 O9xm7QgKaFOoYiygnunODYsrQji1JAbklvEzeEDph3H66mYoAGiRnvpFmjhXHwQIP/sKu
	 9Cyv+qrUnrS+ofo3o2+cSgmW70nuyL+KtRs1Sw4QAgZOBtfKJV/7FcdjPBGTdMXpiMcwj
	 b76Grl1nieLWbAwEzH9y/0Q2mVz0FnIcKbwNMd5Sl5PoXJBdWXzOoFtsPMz6lR0uhyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KcfIamO2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A68F606A31C;
	Thu, 26 Nov 2026 12:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KcfIamO2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9534F1F000E6;
	Thu, 26 Nov 2026 12:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694765;
	bh=BYdAH1zodMk6GcU9BR3r0etHoWawAK2VHYBxoH+UIZk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KcfIamO2mcEVfuIjaaZhsEx5K5VJvl4imQF4/k0lbP53FtbJz43wKP7AkLzce0XMq
	 KPHlERYZUaJSAcC7zd8hNW6PZv9Vv+cM8WZt48ftq7LhhaiIhTHrZR3X+VpcyMKUDW
	 oSP9lHPqxG74dW9Ke/3MpcN7PvVqxFfiy7Ru5K88/wrOusL6r8A1IzMbGoj7OXNsvQ
	 lzESrx4eVE7c+OGVGi32y+UipbfIQ4Ktj6dLp81ZlnLlNLld7rYWjVGvjDWy/7gi2O
	 TwtXKVb1LNP47uJmQdror4gfxSPZ40C2IkzxBL+cfDFGmqhBDXdVGsuINVJfeA+3vT
	 8mDN7sosIIQVw==
Message-ID: <sashiko-outbox-235475@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC v2 11/13] arm64: Support TLBIP instructions
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S3Jpc3RpbmEgTWFydMWhZW5rbw==?= <kristina.martsenko@arm.com>, kvmarm@lists.linux.dev, linux-efi@vger.kernel.org
Cc: "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Linu
 Cherian" <linu.cherian@arm.com>, "Anshuman Khandual" <anshuman.khandual@arm.com>, "Lorenzo
 Pieralisi" <lpieralisi@kernel.org>, "Hanjun Guo" <guohanjun@huawei.com>, "Sudeep
 Holla" <sudeep.holla@kernel.org>, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, "Fuad Tabba" <fuad.tabba@linux.dev>, "Joey
 Gouly" <joey.gouly@arm.com>, "Steffen Eiden" <seiden@linux.ibm.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Zenghui Yu" <yuzenghui@huawei.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Jinqian
 Yang" <yangjinqian1@huawei.com>, "Zi Yan" <ziy@nvidia.com>
In-Reply-To: <20261126114936.864256-12-kristina.martsenko@arm.com>
References: <20261126114936.864256-1-kristina.martsenko@arm.com>
 <20261126114936.864256-12-kristina.martsenko@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 12:06:04 +0000
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
- [Low] arm64: tlb: missing __always_inline on __tlbi_level() and guard
  on __tlbip()
- [Low] arm64: tlb: missing #undef __tlbip_user at end of asm/tlbflush.h
--

commit 483f71029edea8a91bc6a1e440a10493264ee5af
Author: Kristina Mart=C5=A1enko <kristina.martsenko@arm.com>

arm64: Support TLBIP instructions

This commit updates the TLBI helper functions in asm/tlbflush.h to issue
128-bit TLBIP instructions when requested and adds a Kconfig check for
assembler support of FEAT_TLBID.

> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/t=
lbflush.h
> index 8338d780ca595..da7f99d722a58 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -41,11 +41,27 @@
> =20
>  #define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
> =20
> +#define __tlbip(op, arg) do {							\
> +	u128 __arg =3D (arg);							\
> +	register u64 low asm ("x0") =3D (u64)__arg;				\
> +	register u64 high asm ("x1") =3D (u64)(__arg >> 64);			\
> +										\
> +	asm (ARM64_ASM_PREAMBLE ".arch_extension tlbid\n"			\
> +	     "tlbip " #op ", %0, %1\n"						\
> +	  : : "r" (low), "r" (high));						\
> +} while (0)
> +
>  #define __tlbi_user(op, arg) do {						\
>  	if (arm64_kernel_unmapped_at_el0())					\
>  		__tlbi(op, (arg) | USER_ASID_FLAG);				\
>  } while (0)
> =20
> +#define __tlbip_user(op, arg) do {						\
> +	if (arm64_kernel_unmapped_at_el0()) {					\
> +		__tlbip(op, (arg) | (u128)USER_ASID_FLAG);			\
> +	}									\
> +} while (0)

[Severity: Low]
Should __tlbip_user be undefined at the end of asm/tlbflush.h alongside
#undef __tlbi_user?  Commit edc55b7abb25 ("arm64: mm: Implicitly
invalidate user ASID based on TLBI operation") added #undef __tlbi_user so
the internal helper would not leak to translation units including this
header.

> @@ -132,49 +148,75 @@ static inline void sme_dvmsync_batch(void)

[ ... ]

> -static __always_inline void ipas2e1(u64 arg)
> +static __always_inline void ipas2e1(bool tlbip, u128 arg)
>  {
> -	__tlbi(ipas2e1, arg);
> +	compiletime_assert(!tlbip, "Unsupported TLBIP operand");
> +
> +	__tlbi(ipas2e1, (u64)arg);
>  }
> =20
> -static __always_inline void ipas2e1is(u64 arg)
> +static __always_inline void ipas2e1is(bool tlbip, u128 arg)
>  {
> -	__tlbi(ipas2e1is, arg);
> +	if (tlbip)
> +		__tlbip(ipas2e1is, arg);
> +	else
> +		__tlbi(ipas2e1is, (u64)arg);
>  }
> =20
>  static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 =
level,
> @@ -188,7 +230,7 @@ static __always_inline void __tlbi_level_asid(tlbi_op=
 op, u64 addr, u32 level,
>  		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);
>  	}
> =20
> -	op(arg);
> +	op(false, arg);
>  }
> =20
>  static inline void __tlbi_level(tlbi_op op, u64 addr, u32 level)

[Severity: Low]
Can building fail if the compiler decides not to inline __tlbi_level()?

Unlike __tlbi_level_asid(), __tlbi_range(), and __flush_tlb_range_op(),
__tlbi_level() is marked static inline rather than static __always_inline.
Wait-free elimination of the indirect tlbi_op call relies on inlining the
entire call chain from callers such as __kvm_tlb_flush_vmid_ipa_nsh(),
which passes ipas2e1 to __tlbi_level().

If __tlbi_level() is not inlined, the tlbi_op callbacks passed to it are
instantiated out-of-line with a non-constant tlbip argument:
compiletime_assert(!tlbip, ...) in ipas2e1() will fail compilation, and
__tlbip() in helpers such as ipas2e1is() will emit .arch_extension tlbid
and tlbip instructions even when CONFIG_ARM64_TLBID=3Dn and
CONFIG_AS_HAS_TLBID=3Dn.

Marking __tlbi_level() as static __always_inline and guarding __tlbip()
with CONFIG_ARM64_TLBID would avoid depending on inlining heuristics.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126114936.8642=
56-1-kristina.martsenko@arm.com?part=3D11
