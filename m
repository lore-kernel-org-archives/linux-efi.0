Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804103;
	b=X0pEAemAtBl9g3dN/9yTPi5V0Gv9Yjk0EayH9JEq+CJiwJ5z2C995ffr+/TU+lOpW28p
	 2KN8vfCTOX7kHSurQ//H8JdqnxfieY7xjFq98ZNyGdnNNZUgCCwOBndXwXFQjxPScwnFT
	 mmRlwac8M5N2VX1SBpk78O4JjLtzakrzaHZYk5mA5w3eg2eUahgFK40t35iqNPNkJyOC3
	 AsyzMuxiqJvBpkaDaW3SW+uncIA8g+/OOoeUzKt7QIlWLq2Q1dubWuu4N2WAFosd7Kw7V
	 brCd4gUr2p101Y92rLq7dMUpxjLGlZhsKqpqp1u5yx5i5W9WZjbNZ0RvQnCDG71Y2qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804103;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=T/LFH12Z4WZEglTbKhXQW4K9eV4VYPQ2vTkGE/YeZdw=;
	b=1F1HP3Qx0L0c1DCC/mr+8s5se7D1KXqZEQ7y8n/ev/pjLKztz2PI+DfF/j+82Eb0I1b8
	 TyiGaGKvAI2OxtX/SmfROMXTwy5esf0glDsWPBSmleF7A31CCDaDkpAbD4UIMEe3D9diZ
	 /BNIfFXMEBgbvTBlMlWzEroJLbcpFK95oAyzGGNxae+elXWIlXmzR9sStAOsOueC+dSzg
	 juRDTuXhgPboeS98HuWwCIp+ySpqTAuEqMMrWp6JLYnsMGyEoq3zxaritqv/TBb2cE56g
	 rWIYr8O1vU2E4QC8O4ZsCmUKcRZZMffkyj/pfCliAL5pDYddPkYf7Ax+ef7krlUdqiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iv1lPNlz;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=CRZvQnFt;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340AA606A326
	for <linux-efi@vger.kernel.org>; Wed,  4 Nov 2026 14:55:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 340AA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iv1lPNlz;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=CRZvQnFt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793804101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T/LFH12Z4WZEglTbKhXQW4K9eV4VYPQ2vTkGE/YeZdw=;
	b=iv1lPNlzqdRQKqVS0gds5uZzd8y0ySIgpkJmYDBeUZxI/rFKzbZtfS5BadY0nykY8zg2YI
	ysNCDr7RpUJ7d2x3UEIybTos9bcYhVaJUl6n7Xvg9hU5E9W21WHLWfN/SAClLQ8JSO+ejC
	rZkWnWyjS27XAgeylB+bmn5KGSI6JH8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-QPA9rtLCMSuR1rtL14a-Cw-1; Wed, 04 Nov 2026 09:54:59 -0500
X-MC-Unique: QPA9rtLCMSuR1rtL14a-Cw-1
X-Mimecast-MFC-AGG-ID: QPA9rtLCMSuR1rtL14a-Cw_1793804099
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ae73921fd1so854226a91.1
        for <linux-efi@vger.kernel.org>; Wed, 04 Nov 2026 06:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793804099; x=1794408899; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T/LFH12Z4WZEglTbKhXQW4K9eV4VYPQ2vTkGE/YeZdw=;
        b=CRZvQnFtt5RL2jN+WGIqCWR5UoUZ94miOysWGxXcQyigJhhW5/fCZjde7BwdDj0T8D
         RIwwb2Ow37CcUItTA//Qwr4jJV9RSpQWD+weWQwIxoGAj4xg5Ozi6CtDb4fX0gT70TGj
         d31u+InWoE11UB4mbEkHvfD5ZjG3UQfv2LFIz1qr8FT0gSqHUROqllfIcfwtLGcV1+Dj
         7tb1E951U0RFn7pz2S0+KuRfbOiW0gmkukOnGPSoe4I92akJZYe5zUt5k2aM8c4ASw1Y
         FPKNO0lMyBo1MlnUuonxBIwS8o71IgnUp+Zqgmq+5mYJnAI7kJFmwaOj0oSuA/jfTEJC
         O+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793804099; x=1794408899;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T/LFH12Z4WZEglTbKhXQW4K9eV4VYPQ2vTkGE/YeZdw=;
        b=Gcz+OmiICX/gI8ouaxTX3YV0Sw4wIDFK31FWhnGNBmqA79lfTDPjyIp5sx4Q3kg0xg
         NuRm8sP2c72+agJlqmtYBcA4ZkhHu+9Nv+BpEkhCYU+Bmjp4NyxFht5p2hIhkZ1Q6Flg
         SEyqdDtuKPoxuRfLCRblrtGA73XyuD1ujv2TAIyvd/xtdjkhhXyPa5J5myqwu9K6WLC8
         V49cTTa5f7vOR5KIinFWC0qz3Qza9RGrj9YW8sp5jVwpmazrtAuYFkWJhiH8EJwSk/9x
         COM/01q0C90YTALXN5PIfRoTxfnrR2SpRHTReAMywnYtc4+UtEYC8knFWlfSmD3Vzite
         DOOQ==
X-Forwarded-Encrypted: i=1; AKwUvBzeBRc0nY9zP/s0aHPHoDMqDydz+kZ4ZcRIglcNS3kVFQFzdm8sMIundk9pzoqENz5Nk/aBfO9PpTE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+7Kcbi20Dqdd8miQ5PxBJ1DZVU968rb7Lu35/zR2aNgEaidG/M
	eSG71Fcj+P2kqVReMVOuyzqDcknFC5FGvqvCY6s6naL7kgQdA5DfYKZg0424gEhwXvEYjbmpaew
	P5E4uOTKP7TlF9lo78B9+FjTmnqzeObBn32iHB5CylqbFKeDoF0LuFXdU6BYcMw==
X-Gm-Gg: AYBFou2rkKWctI4iNBvS70+D03cQ8HFysIQdZYy2zNXQ4jG30iwSJ7Oo8DS0pPoD1Ol
	dEsHAqsoEFpPbqdVG4lLMb3MRRTiqLlK4tr3yZ/ZfFM2IzJzFYnVQ3fiJnZPX2n/28UF3sEAs1k
	VwAVTyb2W+5/EP+BeMC+Si/QbNuSZXnNsBLtmx+2CGWOXjJwo1MDyMdN1PCqSE68I2Z78Qc2+p2
	XsqgmxVwcQ8b1TiPLw9TOXUOy+Vi8QDR4Y8JW4GhcyBUEpkQwSgY9Wi6YQtCtQ7jLjLN/csGH8y
	WOaz0Firpffdgm+bfxHSFUbO2/kgl/VN5+dGS3XZlGoIBrLUnoSkQy/uJwlIruv4bgNykOREhWV
	Czrx2d+m9Q/66KP2rXzkV2eQ6BYuyVGXas9RKPvR5OtHSGKHk+jiu5vVvCVhEZBpxGcgz+U/FRc
	cmSYpHJK/r0bHfc72DuYU+OO8HTXNelPzDA4KwK3uukZ0=
X-Received: by 2002:a17:90b:48cd:b0:3b0:a970:caad with SMTP id 98e67ed59e1d1-3b0a970ce14mr563074a91.28.1793804098467;
        Wed, 04 Nov 2026 06:54:58 -0800 (PST)
X-Received: by 2002:a17:90b:48cd:b0:3b0:a970:caad with SMTP id 98e67ed59e1d1-3b0a970ce14mr563055a91.28.1793804097848;
        Wed, 04 Nov 2026 06:54:57 -0800 (PST)
Received: from ?IPV6:2401:4900:1f28:63e0:edae:927e:c670:b679? ([2401:4900:1f28:63e0:edae:927e:c670:b679])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b096994650sm2176379a91.2.2026.11.04.06.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 06:54:57 -0800 (PST)
Message-ID: <99670aa8-a33c-4a36-b8dd-66b02c6b6159@redhat.com>
Date: Wed, 4 Nov 2026 20:24:47 +0530
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a
 configuration table
To: George Guo <dongtai.guo@linux.dev>, rppt@kernel.org,
 pasha.tatashin@soleen.com, pratyush@kernel.org, chenhuacai@kernel.org,
 ardb@kernel.org, shuah@kernel.org
Cc: ilias.apalodimas@linaro.org, akpm@linux-foundation.org,
 baoquan.he@linux.dev, ruirui.yang@linux.dev, guodongtai@kylinos.cn,
 kernel@xen0n.name, graf@amazon.com, liukexin@kylinos.cn,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-2-dongtai.guo@linux.dev>
Content-Language: en-US
From: Mukesh Pilaniya <mpilaniy@redhat.com>
In-Reply-To: <20261029172956.20791-2-dongtai.guo@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi George,

On 29/10/26 10:59 pm, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> KHO has to give the next kernel two addresses: the KHO FDT and the
> bootmem area list. arm64 and riscv put them under /chosen in the boot
> FDT. LoongArch systems booting with EFI and ACPI do not require a boot
> FDT, so KHO needs another way to pass this information.
> 
> Add a Linux EFI configuration table for them, under
> LINUX_EFI_KEXEC_HANDOVER_GUID. It points to a struct linux_efi_kho_data.
> 
>   - On a cold boot, the LoongArch EFI stub installs the table, zeroed.
>     Each kexec'd kernel is given the same EFI system table, so it finds
>     the same table.
> 
>   - In early boot, efi_config_parse_tables() reserves the table so
>     neither the page allocator nor kexec segments use it, and calls
>     kho_populate() if the table holds KHO state.
> 
>   - Provide efi_kho_update() to update the table before kexec. Map the
>     table during boot so updates do not require allocation or mapping
>     at panic time.
> 
>   - efi_kho_table_found() tells architecture code whether the table was
>     found at boot, so it can turn KHO off when the table is missing.
> 
> Only the LoongArch stub installs the table, and only with
> CONFIG_KEXEC_HANDOVER. Elsewhere there is no table and this code does
> nothing.
> 
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  drivers/firmware/efi/efi.c               | 68 ++++++++++++++++++++++++
>  drivers/firmware/efi/libstub/efi-stub.c  | 22 ++++++++
>  drivers/firmware/efi/libstub/efistub.h   |  2 +
>  drivers/firmware/efi/libstub/loongarch.c |  2 +
>  include/linux/efi.h                      | 40 ++++++++++++++
>  5 files changed, 134 insertions(+)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 0327a39d31fa..e409e4a57378 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -24,6 +24,7 @@
>  #include <linux/initrd.h>
>  #include <linux/io.h>
>  #include <linux/kexec.h>
> +#include <linux/kexec_handover.h>
>  #include <linux/platform_device.h>
>  #include <linux/random.h>
>  #include <linux/reboot.h>
> @@ -62,6 +63,7 @@ unsigned long __ro_after_init efi_rng_seed = EFI_INVALID_TABLE_ADDR;
>  static unsigned long __initdata mem_reserve = EFI_INVALID_TABLE_ADDR;
>  static unsigned long __initdata rt_prop = EFI_INVALID_TABLE_ADDR;
>  static unsigned long __initdata initrd = EFI_INVALID_TABLE_ADDR;
> +static unsigned long efi_kho __initdata = EFI_INVALID_TABLE_ADDR;
>  
>  extern unsigned long primary_display_table;
>  
> @@ -629,6 +631,7 @@ static const efi_config_table_type_t common_tables[] __initconst = {
>  	{EFI_TCG2_FINAL_EVENTS_TABLE_GUID,	&efi.tpm_final_log,	"TPMFinalLog"	},
>  	{EFI_CC_FINAL_EVENTS_TABLE_GUID,	&efi.tpm_final_log,	"CCFinalLog"	},
>  	{LINUX_EFI_MEMRESERVE_TABLE_GUID,	&mem_reserve,		"MEMRESERVE"	},
> +	{LINUX_EFI_KEXEC_HANDOVER_GUID,		&efi_kho,		"KHO"		},
>  	{LINUX_EFI_INITRD_MEDIA_GUID,		&initrd,		"INITRD"	},
>  	{EFI_RT_PROPERTIES_TABLE_GUID,		&rt_prop,		"RTPROP"	},
>  #ifdef CONFIG_OVMF_DEBUG_LOG
> @@ -806,6 +809,23 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
>  		}
>  	}
>  
> +	if (efi_kho != EFI_INVALID_TABLE_ADDR) {
> +		struct linux_efi_kho_data *kho;
> +
> +		/* Keep the buddy allocator and kexec segments off the table. */
> +		memblock_reserve(efi_kho, sizeof(*kho));
> +
> +		kho = early_memremap(efi_kho, sizeof(*kho));
> +		if (kho) {
> +			if (kho->fdt_addr)
> +				kho_populate((phys_addr_t)kho->fdt_addr, kho->fdt_size,
> +					     (phys_addr_t)kho->bootmem_addr, kho->bootmem_size);
> +			early_memunmap(kho, sizeof(*kho));
> +		} else {
> +			pr_warn("Could not map UEFI KHO table!\n");
This is a Linux EFI configuration table, not a __UEFI KHO table__, so
IMHO; UEFI wording is wrong here.

> +		}
> +	}
> +
>  	if (rt_prop != EFI_INVALID_TABLE_ADDR) {
>  		efi_rt_properties_table_t *tbl;
>  
> @@ -1171,6 +1191,54 @@ static int __init efi_memreserve_root_init(void)
>  }
>  early_initcall(efi_memreserve_root_init);
>  
> +static struct linux_efi_kho_data *efi_kho_table __ro_after_init;
> +
> +/* Did the previous kernel or the EFI stub pass a KHO table? */
> +bool __init efi_kho_table_found(void)
> +{
> +	return efi_kho != EFI_INVALID_TABLE_ADDR;
> +}
> +
> +static int __init efi_kho_table_init(void)
> +{
> +	if (efi_kho == EFI_INVALID_TABLE_ADDR)
> +		return 0;
> +
> +	/* Map it now: the table is also written at panic time. */
> +	efi_kho_table = memremap(efi_kho, sizeof(*efi_kho_table), MEMREMAP_WB);
> +	if (WARN_ON_ONCE(!efi_kho_table))
> +		efi_kho_table = ERR_PTR(-ENOMEM);
> +
> +	return 0;
> +}
> +early_initcall(efi_kho_table_init);
> +
> +/*
> + * Write the KHO addresses the next kernel should use, or zeroes
> + * if it should boot without KHO.
> + */
> +int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
> +		   phys_addr_t bootmem_addr, u64 bootmem_size)
> +{
> +	struct linux_efi_kho_data *kho = efi_kho_table;
> +
> +	/*
> +	 * No table: either the architecture passes the KHO state some other
> +	 * way, or it turned KHO off at boot because the table was missing.
> +	 */
> +	if (!kho)
> +		return 0;
> +	if (IS_ERR(kho))
> +		return PTR_ERR(kho);
> +
> +	kho->fdt_addr		= fdt_addr;
> +	kho->fdt_size		= fdt_size;
> +	kho->bootmem_addr	= bootmem_addr;
> +	kho->bootmem_size	= bootmem_size;
> +
> +	return 0;
> +}
> +
>  #ifdef CONFIG_KEXEC
>  static int update_efi_random_seed(struct notifier_block *nb,
>  				  unsigned long code, void *unused)
> diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
> index 42d6073bcd06..0fb0d4041d1c 100644
> --- a/drivers/firmware/efi/libstub/efi-stub.c
> +++ b/drivers/firmware/efi/libstub/efi-stub.c
> @@ -100,6 +100,28 @@ static void install_memreserve_table(void)
>  		efi_err("Failed to install memreserve config table!\n");
>  }
>  
> +void install_kho_table(void)
> +{
> +	struct linux_efi_kho_data *kho;
> +	efi_guid_t kho_table_guid = LINUX_EFI_KEXEC_HANDOVER_GUID;
> +	efi_status_t status;
> +
> +	if (!IS_ENABLED(CONFIG_KEXEC_HANDOVER))
> +		return;
> +
> +	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(*kho), (void **)&kho);
> +	if (status != EFI_SUCCESS) {
> +		efi_err("Failed to allocate KHO config table!\n");
> +		return;
> +	}
> +
> +	*kho = (struct linux_efi_kho_data){};
> +
> +	status = efi_bs_call(install_configuration_table, &kho_table_guid, kho);

> +	if (status != EFI_SUCCESS)
> +		efi_err("Failed to install KHO config table!\n");
When install_configuration_table fails, the pool allocation made
just above using efi_bs_callis never freed, so a page of
EFI_LOADER_DATA is leaked until ExitBootServices, This is a minor leak
so mentioned here for review completeness.

> +}
> +
>  static u32 get_supported_rt_services(void)
>  {
>  	const efi_rt_properties_table_t *rt_prop_table;
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index fd91fc15ec81..9e0034c1260a 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -1057,6 +1057,8 @@ efi_status_t efi_exit_boot_services(void *handle, void *priv,
>  efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
>  			     unsigned long kernel_addr, char *cmdline_ptr);
>  
> +void install_kho_table(void);
> +
>  void *get_fdt(unsigned long *fdt_size);
>  
>  efi_status_t efi_alloc_virtmap(efi_memory_desc_t **virtmap,
> diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
> index 2b0c87dc9908..c2df097771e4 100644
> --- a/drivers/firmware/efi/libstub/loongarch.c
> +++ b/drivers/firmware/efi/libstub/loongarch.c
> @@ -74,6 +74,8 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
>  	efi_status_t status;
>  	u32 desc_ver;
>  
> +	install_kho_table();
> +
>  	status = efi_alloc_virtmap(&priv.runtime_map, &desc_size, &desc_ver);
>  	if (status != EFI_SUCCESS) {
>  		efi_err("Unable to retrieve UEFI memory map.\n");
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index aa15ff88539b..253e98bf9922 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -422,6 +422,7 @@ void efi_native_runtime_setup(void);
>  #define LINUX_EFI_COCO_SECRET_AREA_GUID		EFI_GUID(0xadf956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
>  #define LINUX_EFI_BOOT_MEMMAP_GUID		EFI_GUID(0x800f683f, 0xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
>  #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID	EFI_GUID(0xd5d1de3c, 0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
> +#define LINUX_EFI_KEXEC_HANDOVER_GUID		EFI_GUID(0xc941b6c7, 0x7b3f, 0x4af6,  0x9e, 0x50, 0xfc, 0xb3, 0xa8, 0x86, 0x8a, 0x17)
>  
>  #define RISCV_EFI_BOOT_PROTOCOL_GUID		EFI_GUID(0xccd15fec, 0x6f73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
>  
> @@ -1273,6 +1274,45 @@ struct linux_efi_memreserve {
>  
>  void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
>  
> +/**
> + * struct linux_efi_kho_data - KHO state passed to the next kernel
> + * @fdt_addr: physical address of the KHO FDT, 0 if there is none
> + * @fdt_size: size of the KHO FDT
> + * @bootmem_addr: physical address of the bootmem area list
> + * @bootmem_size: size of the bootmem area list
> + *
> + * Pointed to by the LINUX_EFI_KEXEC_HANDOVER_GUID configuration table.
> + *
> + * The EFI stub installs this table zeroed on a cold boot. It stays
> + * in place across kexec; the running kernel rewrites it just before
> + * each kexec, and the next kernel reads it during early boot.
This statement is only true for the LoongArch and on arm64/riscv/x86 no
table exists, so the comment describes a kernel-wide invariant that does
not hold.

> + *
> + * The layout is fixed. Changing it requires a new GUID.
> + */
> +struct linux_efi_kho_data {
> +	u64 fdt_addr;
> +	u64 fdt_size;
> +	u64 bootmem_addr;
> +	u64 bootmem_size;
> +};
> +
> +#ifdef CONFIG_EFI
> +bool efi_kho_table_found(void);
> +int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
> +		   phys_addr_t bootmem_addr, u64 bootmem_size);
> +#else
> +static inline bool efi_kho_table_found(void)
> +{
> +	return false;
> +}
> +
> +static inline int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
> +				 phys_addr_t bootmem_addr, u64 bootmem_size)
> +{
> +	return 0;
> +}
> +#endif
> +
>  /*
>   * The LINUX_EFI_MOK_VARIABLE_TABLE_GUID config table can be provided
>   * to the kernel by an EFI boot loader. The table contains a packed

-- 
Regards,
Mukesh Pilaniya

