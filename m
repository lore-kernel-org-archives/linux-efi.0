Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED73487CC3;
	Mon, 19 Oct 2026 06:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392716; cv=none; b=LDeI8UFh4A//qV7zRhc/iDFm8PAux7HjGE9+1+9ZmCEBLr+TUrZzrMw7SeClMJTnpjYx4Z1Rn712vjvQ2w454Mm53TSHkVp/e4p26Psq4YnEM3YRC4wa+TuqVt+0fnP383ip3gX2LmCbdk7Pk0frsPkgq2bjAj0OF/Ju467Kx1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392716; c=relaxed/simple;
	bh=WmtiytexO55eyMlLjW4zSbJakK9ypbi9Ru6KDLCNii8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PR2iabeIMITNx4r7FXls1ni9EMOuvGYzwDMN/VvqBvPIgnRgQpVn12goWHOtHmqYCHqRKGFQ8iAQCCAxARwpUYigjCFTNpZPtDtOw/BcTmprhQGMUVSoj6UcJY5EZd8/fLlphmtWZHIMVQjjbwot8i8zr5UVw2SQN17ZGptDTwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Mm26FSJJ; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Mm26FSJJ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=c3obcKuS8MPPfakEMVl1TjadNNf74SXcQB6y0vzEWrY=;
	b=Mm26FSJJWjYAGOf8SqrEiSkxdcSvJ7BZ5OzJB+IqedBYOW1xKku+9Zobxa/ID7XuWU1cNw4yn
	p1ANI7CN1F5AcviRZt27pZEOf6L67g91LJEFyyyJ+vDkm5VEurlTD3HT3Uu2y/+DR9iyaiyhd8q
	hzkRhdjXDCPcTn4SaYMEGl0=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4j7R6V24mWz12Ldh;
	Mon, 19 Oct 2026 14:51:46 +0800 (CST)
Received: from kwepemk300013.china.huawei.com (unknown [7.202.194.231])
	by mail.maildlp.com (Postfix) with ESMTPS id 552E140579;
	Mon, 19 Oct 2026 14:51:46 +0800 (CST)
Received: from [10.67.121.183] (10.67.121.183) by
 kwepemk300013.china.huawei.com (7.202.194.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 19 Oct 2026 14:51:41 +0800
Message-ID: <e4cee1ac-ce71-4217-bcbe-c85d07d37d9e@huawei.com>
Date: Mon, 19 Oct 2026 14:51:22 +0800
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 10/12] arm64: Support TLBIP instructions
To: =?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-acpi@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <linux-efi@vger.kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Linu
 Cherian <linu.cherian@arm.com>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>, Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Fuad Tabba
	<fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden
	<seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <20261001110655.461473-11-kristina.martsenko@arm.com>
From: Jinqian Yang <yangjinqian1@huawei.com>
In-Reply-To: <20261001110655.461473-11-kristina.martsenko@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300013.china.huawei.com (7.202.194.231)

Hi,

On 2026/10/1 19:06, Kristina Martšenko wrote:
> Modify the TLBI helper functions in tlbflush.h to issue TLBIP
> instructions instead of TLBI when requested. These will be used to pass
> a TLBI domain ID to TLBI operations.
> 
> FEAT_TLBID introduces TLBIP instructions that behave like TLBI but take
> a 128-bit value as an argument (passed in two consecutive GPRs). TLBID
> uses these to pass a TLBI domain ID to *VA* and *IPA* type instructions.
> TLBID does not introduce non-shareable TLBIP instructions, so assert
> that those are not requested.
> 
> Use local register variables to ensure that the two GPRs are
> consecutive. Alternatively we could use the %H operand modifier but LLVM
> doesn't support it.
> 
> Check for assembler support of TLBIP instructions. TLBIP won't be used
> (nor assembled) when CONFIG_ARM64_TLBID=n.
> 
> For now there should be no functional change, as no callers request
> TLBIP. A later patch will change this.
> 
> Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
> ---
>   arch/arm64/Kconfig                |   9 +-
>   arch/arm64/include/asm/tlbflush.h | 131 ++++++++++++++++++++++--------
>   2 files changed, 103 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 46701449fef2..a6525754492b 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -2329,9 +2329,16 @@ config ARM64_LSUI
>   
>   endmenu # "ARMv9.6 architectural feature"
>   
> +config AS_HAS_TLBID
> +	def_bool $(as-instr,.arch_extension tlbid)
> +	# https://github.com/llvm/llvm-project/pull/178913
> +	depends on AS_IS_GNU || (AS_IS_LLVM && AS_VERSION >= 230000)
> +	help
> +	  Supported by LLVM 23+ and binutils 2.46+.
> +
>   config ARM64_TLBID
>   	def_bool y
> -	depends on ACPI
> +	depends on ACPI && AS_HAS_TLBID
>   	select ACPI_TLBI
>   
>   config ARM64_SVE
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index b51df8e0ce63..dac35568570f 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -41,11 +41,26 @@
>   
>   #define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
>   
> +#define __tlbip(op, arg) do {		\
> +	register u64 low asm ("x0") = (u64)arg;					\
> +	register u64 high asm ("x1") = (u64)(arg >> 64);			\
> +										\
> +	asm (ARM64_ASM_PREAMBLE ".arch_extension tlbid\n"			\
> +	     "tlbip " #op ", %0, %1\n"						\
> +	  : : "r" (low), "r" (high));						\
> +} while (0)
> +
>   #define __tlbi_user(op, arg) do {						\
>   	if (arm64_kernel_unmapped_at_el0())					\
>   		__tlbi(op, (arg) | USER_ASID_FLAG);				\
>   } while (0)
>   
> +#define __tlbip_user(op, arg) do {						\
> +	if (arm64_kernel_unmapped_at_el0()) {					\
> +		__tlbip(op, (arg) | (u128)USER_ASID_FLAG);			\
> +	}									\
> +} while (0)
> +
>   #define TLBI_TLBID_MASK		GENMASK_ULL(15, 0)
>   
>   /* This macro creates a properly formatted VA operand for the TLBI */
> @@ -132,49 +147,75 @@ static inline void sme_dvmsync_batch(void)
>   
>   #define TLBI_TTL_UNKNOWN	INT_MAX
>   
> -typedef void (*tlbi_op)(u64 arg);
> +typedef void (*tlbi_op)(bool tlbip, u128 arg);
>   
> -static __always_inline void vae1is(u64 arg)
> +static __always_inline void vae1is(bool tlbip, u128 arg)
>   {
> -	__tlbi(vae1is, arg);
> -	__tlbi_user(vae1is, arg);
> +	if (tlbip) {
> +		__tlbip(vae1is, arg);
> +		__tlbip_user(vae1is, arg);
> +	} else {
> +		__tlbi(vae1is, (u64)arg);
> +		__tlbi_user(vae1is, (u64)arg);
> +	}
>   }
>   
> -static __always_inline void vae2is(u64 arg)
> +static __always_inline void vae2is(bool tlbip, u128 arg)
>   {
> -	__tlbi(vae2is, arg);
> +	if (tlbip)
> +		__tlbip(vae2is, arg);
> +	else
> +		__tlbi(vae2is, (u64)arg);
>   }
>   
> -static __always_inline void vale1(u64 arg)
> +static __always_inline void vale1(bool tlbip, u128 arg)
>   {
> -	__tlbi(vale1, arg);
> -	__tlbi_user(vale1, arg);
> +	compiletime_assert(!tlbip, "Unsupported TLBIP operand");
> +
> +	__tlbi(vale1, (u64)arg);
> +	__tlbi_user(vale1, (u64)arg);
>   }
>   
> -static __always_inline void vale1is(u64 arg)
> +static __always_inline void vale1is(bool tlbip, u128 arg)
>   {
> -	__tlbi(vale1is, arg);
> -	__tlbi_user(vale1is, arg);
> +	if (tlbip) {
> +		__tlbip(vale1is, arg);
> +		__tlbip_user(vale1is, arg);
> +	} else {
> +		__tlbi(vale1is, (u64)arg);
> +		__tlbi_user(vale1is, (u64)arg);
> +	}
>   }
>   
> -static __always_inline void vale2is(u64 arg)
> +static __always_inline void vale2is(bool tlbip, u128 arg)
>   {
> -	__tlbi(vale2is, arg);
> +	if (tlbip)
> +		__tlbip(vale2is, arg);
> +	else
> +		__tlbi(vale2is, (u64)arg);
>   }
>   
> -static __always_inline void vaale1is(u64 arg)
> +static __always_inline void vaale1is(bool tlbip, u128 arg)
>   {
> -	__tlbi(vaale1is, arg);
> +	if (tlbip)
> +		__tlbip(vaale1is, arg);
> +	else
> +		__tlbi(vaale1is, (u64)arg);
>   }
>   
> -static __always_inline void ipas2e1(u64 arg)
> +static __always_inline void ipas2e1(bool tlbip, u128 arg)
>   {
> -	__tlbi(ipas2e1, arg);
> +	compiletime_assert(!tlbip, "Unsupported TLBIP operand");
> +
> +	__tlbi(ipas2e1, (u64)arg);
>   }
>   
> -static __always_inline void ipas2e1is(u64 arg)
> +static __always_inline void ipas2e1is(bool tlbip, u128 arg)
>   {
> -	__tlbi(ipas2e1is, arg);
> +	if (tlbip)
> +		__tlbi(ipas2e1is, arg);
> +	else
> +		__tlbi(ipas2e1is, (u64)arg);
>   }
>   

Should the tlbip path be __tlbip() rather than __tlbi()?

Thanks,
Jinqian

>   static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
> @@ -188,7 +229,7 @@ static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
>   		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);
>   	}
>   
> -	op(arg);
> +	op(false, arg);
>   }
>   
>   static inline void __tlbi_level(tlbi_op op, u64 addr, u32 level)
> @@ -445,32 +486,50 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
>    *    operations can only span an even number of pages. We save this for last to
>    *    ensure 64KB start alignment is maintained for the LPA2 case.
>    */
> -static __always_inline void rvae1is(u64 arg)
> -{
> -	__tlbi(rvae1is, arg);
> -	__tlbi_user(rvae1is, arg);
> +static __always_inline void rvae1is(bool tlbip, u128 arg)
> +{
> +	if (tlbip) {
> +		__tlbip(rvae1is, arg);
> +		__tlbip_user(rvae1is, arg);
> +	} else {
> +		__tlbi(rvae1is, (u64)arg);
> +		__tlbi_user(rvae1is, (u64)arg);
> +	}
>   }
>   
> -static __always_inline void rvale1(u64 arg)
> +static __always_inline void rvale1(bool tlbip, u128 arg)
>   {
> -	__tlbi(rvale1, arg);
> -	__tlbi_user(rvale1, arg);
> +	compiletime_assert(!tlbip, "Unsupported TLBIP operand");
> +
> +	__tlbi(rvale1, (u64)arg);
> +	__tlbi_user(rvale1, (u64)arg);
>   }
>   
> -static __always_inline void rvale1is(u64 arg)
> +static __always_inline void rvale1is(bool tlbip, u128 arg)
>   {
> -	__tlbi(rvale1is, arg);
> -	__tlbi_user(rvale1is, arg);
> +	if (tlbip) {
> +		__tlbip(rvale1is, arg);
> +		__tlbip_user(rvale1is, arg);
> +	} else {
> +		__tlbi(rvale1is, (u64)arg);
> +		__tlbi_user(rvale1is, (u64)arg);
> +	}
>   }
>   
> -static __always_inline void rvaale1is(u64 arg)
> +static __always_inline void rvaale1is(bool tlbip, u128 arg)
>   {
> -	__tlbi(rvaale1is, arg);
> +	if (tlbip)
> +		__tlbip(rvaale1is, arg);
> +	else
> +		__tlbi(rvaale1is, (u64)arg);
>   }
>   
> -static __always_inline void ripas2e1is(u64 arg)
> +static __always_inline void ripas2e1is(bool tlbip, u128 arg)
>   {
> -	__tlbi(ripas2e1is, arg);
> +	if (tlbip)
> +		__tlbip(ripas2e1is, arg);
> +	else
> +		__tlbi(ripas2e1is, (u64)arg);
>   }
>   
>   static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
> @@ -486,7 +545,7 @@ static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
>   	arg |= FIELD_PREP(TLBIR_TG_MASK, get_trans_granule());
>   	arg |= FIELD_PREP(TLBIR_ASID_MASK, asid);
>   
> -	op(arg);
> +	op(false, arg);
>   }
>   
>   static __always_inline void __flush_tlb_range_op(tlbi_op lop, tlbi_op rop,

