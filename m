Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792575254;
	b=j1hOTwKpbd/RjrDgFG8JzwEEzcgraExgn8OkxqoX7Yf0ATu4jSgNTp5rLVXEA9ogWbjH
	 w64pY7QQVfYO/N8VfPqAK7Nie8R8Ce2wAToCdVyewjLRFB4bVySESqUBYh692g8PbYT04
	 Q8UFGEDM+5Ilfo/xwlkUGfjuxurF84V/nq5qk75QwWs43V6kCPXtM+p/8Kt692ouTUC2G
	 nWBAVbE3jaFuS2N+NXHKeKS+iTUzYJ4uuiiceatZGgIAP4Uvvtd8kpAr0kr7B4VQn874g
	 3llXrBrzcR3FqSJ7LmhHtIh+9z9fxuLcO7IlOWKrKD2kYkuaCN+mludKkFDVciStejw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792575254;
	h=DMARC-Filter:DKIM-Signature:X-Lms-Return-Path:Subject:Date:
	 In-Reply-To:User-Agent:Content-Type:X-Original-From:
	 Content-Transfer-Encoding:To:Cc:From:Message-Id:Mime-Version:
	 References;
	bh=coNWzQ5GIYQq0sPIsYUvWDSkWqhCl1jRcwfPQzxcsYs=;
	b=AGsVqenYmBFbvp56pY7frK3hCAB+i0DDvxAKrKxcjaPnxrTp+DZoTKGYZ0LHfozqg6LO
	 NLLIomk6ALqdAI0KPZ3HQXefNBR6EwjB0cIEkEbgNF5sgeHKz5RktxMHAVDrr3j0Uhek0
	 TCAiSmhbPXpSDu/xkhAZpp1arEMQmA4gnvpROGITQgT1IUA7AOKLUhgxWMIasJrSytVXO
	 bbIaqSha1M7ROjuKxSN4tl+nq4xxWEi2dYeUeG97oK4SDMEn6vJg4zVF5PI30PuLt5bV1
	 Zpp/8JboncV7cEcQKn+hGBV568VrGWY5ST56POJ2n7RHGx35ACFWJHbHVB94ynEaNAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ccvoIXh7;
	arc=none smtp.remote-ip=209.127.231.113
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD32606A31D
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 09:34:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBD32606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ccvoIXh7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792575248; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=coNWzQ5GIYQq0sPIsYUvWDSkWqhCl1jRcwfPQzxcsYs=;
 b=ccvoIXh7oTjSziKOA6CLkKOftjqBtbQ/HZCtfXQBoaX7llsMqJ8i5XR/sTJ0r7YV70udCU
 x6jPBuL6mPNvszHK7m549UDVETqYNPf5FNG5fCvLfSo7rftcJpMQ2M6utGRADEUdhmJhPH
 ca1N2IQ6aC4qr98eGi45+aHbPYnzj+Fcr4PQRwekEaEFXeT9ha2xALGNlSiSA1nw6GjZKj
 OCssEO/OfwOc2E1IrlBEsMvQO2xvXmmbWoO4k1zvfjJPYeTu2loUCNxFDeb59tOV9lw6Pe
 EpjjCZuTvg29c/TtsRDBJhwWy0JBkClw6YKuA2hHnmP17UUX5SnEOHiNxYCOlQ==
X-Lms-Return-Path: <lba+26ad8870e+6ab876+vger.kernel.org+qirui.001@bytedance.com>
Subject: Re: [PATCH v5 2/9] riscv: Define arch_apei_get_mem_attribute for RISC-V
Date: Wed, 21 Oct 2026 17:33:45 +0800
In-Reply-To: <20260924073714.1650588-3-himanshu.chauhan@oss.qualcomm.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Original-From: Rui Qi <qirui.001@bytedance.com>
Content-Transfer-Encoding: 7bit
To: "Himanshu Chauhan" <himanshu.chauhan@oss.qualcomm.com>, 
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, 
	<linux-acpi@vger.kernel.org>, <linux-efi@vger.kernel.org>
Cc: <acpica-devel@lists.linux.dev>, <anup.patel@oss.qualcomm.com>, 
	<ardb@kernel.org>, <conor@kernel.org>, <james.morse@arm.com>, 
	<lenb@kernel.org>, <palmer@dabbelt.com>, <paul.walmsley@sifive.com>, 
	<robert.moore@intel.com>, <sunilvl@oss.qualcomm.com>, 
	<tony.luck@intel.com>, <zhangzhanpeng.jasper@bytedance.com>
From: "Rui Qi" <qirui.001@bytedance.com>
Message-Id: <98fe9db7-f22c-483d-9811-939263595004@bytedance.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20260924073714.1650588-1-himanshu.chauhan@oss.qualcomm.com> <20260924073714.1650588-3-himanshu.chauhan@oss.qualcomm.com>

On 9/24/26 3:37 PM, Himanshu Chauhan wrote:
> ghes_map function uses arch_apei_get_mem_attribute to get the
> protection bits for a given physical address. These protection
> bits are then used to map the physical address.
> 
> Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
> Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
> ---
>  arch/riscv/include/asm/acpi.h | 16 ++++++++++++++++
>  arch/riscv/kernel/acpi.c      | 12 ++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/acpi.h b/arch/riscv/include/asm/acpi.h
> index cdefa1f2d67d..c7dee956cdb1 100644
> --- a/arch/riscv/include/asm/acpi.h
> +++ b/arch/riscv/include/asm/acpi.h
> @@ -16,6 +16,7 @@
>  
>  /* Basic configuration for ACPI */
>  #ifdef CONFIG_ACPI
> +pgprot_t __acpi_get_mem_attribute(phys_addr_t addr);
>  
>  typedef u64 phys_cpuid_t;
>  #define PHYS_CPUID_INVALID INVALID_HARTID
> @@ -29,6 +30,21 @@ extern int acpi_disabled;
>  extern int acpi_noirq;
>  extern int acpi_pci_disabled;
>  
> +#ifdef	CONFIG_ACPI_APEI
> +/*
> + * acpi_disable_cmcff to disable IA-32 Corrected Machine Check (CMC)
> + * Firmware-First mode. It is not required in RISC-V architecture
> + * and is present for compatibility
> + */
> +#define acpi_disable_cmcff 1
> +static inline pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
> +{
> +	return  __acpi_get_mem_attribute(addr);
> +}
> +#else /* CONFIG_ACPI_APEI */
> +#define acpi_disable_cmcff 0
> +#endif /* !CONFIG_ACPI_APEI */
> +
>  static inline void disable_acpi(void)
>  {
>  	acpi_disabled = 1;
> diff --git a/arch/riscv/kernel/acpi.c b/arch/riscv/kernel/acpi.c
> index efd52a5d05b5..d1e472ce0878 100644
> --- a/arch/riscv/kernel/acpi.c
> +++ b/arch/riscv/kernel/acpi.c
> @@ -204,6 +204,18 @@ struct acpi_madt_rintc *acpi_cpu_get_madt_rintc(int cpu)
>  	return &cpu_madt_rintc[cpu];
>  }
>  
> +pgprot_t __acpi_get_mem_attribute(phys_addr_t addr)
> +{
> +	u64 attr;
> +
> +	attr = efi_mem_attributes(addr);
> +	if (attr & EFI_MEMORY_WB)
> +		return PAGE_KERNEL;
> +	if ((attr & EFI_MEMORY_WC) || (attr & EFI_MEMORY_WT))
> +		return pgprot_writecombine(PAGE_KERNEL);
> +	return PAGE_KERNEL;
> +}


Hi Himanshu,



Could you clarify why PAGE_KERNEL is used as the fallback here?

When none of EFI_MEMORY_WB, EFI_MEMORY_WC or EFI_MEMORY_WT is
present, including the case where only EFI_MEMORY_UC is advertised,
this returns PAGE_KERNEL.

With standard Svpbmt, PAGE_KERNEL leaves PBMT at zero and therefore
relies on the underlying PMA. In comparison, the existing RISC-V
acpi_os_ioremap() starts with PAGE_KERNEL_IO and retains it when none
of WB/WC/WT is present.

Is relying on the platform PMA intentional for the GHES error status
block mapped by ghes_map()? If so, is there a platform guarantee that
the PMA provides the appropriate memory type for every address reaching
this path?

Otherwise, would PAGE_KERNEL_IO be a more appropriate fallback here,
consistent with acpi_os_ioremap()? A comment documenting the intended
PMA dependency would also help clarify the difference between the two
mapping paths.

Thanks,
Qirui

> +
>  /*
>   * __acpi_map_table() will be called before paging_init(), so early_ioremap()
>   * or early_memremap() should be called here to for ACPI table mapping.
