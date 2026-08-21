Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D866947ECEE
	for <linux-efi@vger.kernel.org>; Fri, 21 Aug 2026 11:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787310304; cv=none; b=C+LXuJpp/88sVSwtsi6I8j17zWfnJXSrxeoF+48lEBQb5oyf/43f0yLZLcmF8S0UlBATNUozDqLc2IcQBUFBCmWMI6jeUQFB9nVz1sBIN99GaC57TPFJwXNoU3xEUBPHdiGewbdmpR1oXPfUL9EI66y3YIs/d5f53zeu02rDwgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787310304; c=relaxed/simple;
	bh=+XA7XIPxJkktEP/nUfXHpcEIp/KX5C0v7mJMsyrzvR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nhgC7dXF1d5ZWhfVONpktM1daWX/Ck/VuYTcfNhrYoBL9v862oLMZSMlHDLgrTSjeYoDL8FHXHxOekDaq1Y6ftbKhtBcOwBo1aIvY0+Af0a0Ly9MqqicLvQjJWpQN8qeWHl8kDJOV2hb/WffyRH0GORfQzLZQSnBjxdSoZN9Zi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXA/xwwX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXA/xwwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881CA1F00A3D;
	Fri, 21 Aug 2026 11:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787310301;
	bh=pCvD1MdzsW2akKjjzWWz1w5C615w+H1/o/P1Mz5Sgas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bXA/xwwXn4mlknABhcs+eK/JMOJK6tbygxJOQMNISU2axQcGedUiq+oXFvNCNv9L/
	 vzUAFDuljuxzu/8t0oydhoubTIBLPP6wUYL7BeADjIqaiFHglf/IOQFNKIvvl4mRGU
	 kOJp1+hurzzvo+cMau+URL845baPVGUlLydXRMaMZKOK+eCDNnoIFzXEJY9oV7kPTh
	 PWHSunSaxuBbMgoCpqz2XyO0ndwTytWoLzqja5SK7kFCfOGtCva7Bw+QHs92OZrau7
	 K0olHV4ldLh2SYkjdBHS+RKu5ZV4kBjiTdTHFwlwt3pcpqSKL/4Bnb7nVOz5EPPLAT
	 DfrTxeGm5Kdmw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id DE9AA1980070;
	Fri, 21 Aug 2026 07:04:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 21 Aug 2026 07:04:58 -0400
X-ME-Sender: <xms:2DCIal3BzlUlLRcbUf1WM3l8G3jfkGrsCNsXyuggYI3ebJOhVS4g-g>
    <xme:2DCIapgoWIV8fysXnFo7Fbf4F6UKCP-YJGNKUg4JKJHBFh7F3zLyL5h-7DGTz0YD8
    8nPdiOMNjK5q7Dw67TGT5XyDdtnJ0Z4RcBQ23TQlW7ufF00kQfa_r0>
X-ME-Received: <xmr:2DCIal2UclUQM-TfhqxlJ0XsJiZfpPLiMNb6hdsHGDFLnIDhg2XQKTK2joY>
X-ME-Proxy-Cause: dmFkZTEWM2E58ZDI3GBPHZLDZKPHLTpyhDURcoURdljfk4cH7f/KXOu0wRWhhh9eH1QjfP
    Hp+aXrB4+gX0+3nQ2wUB/0Zvpvx7qc4d6/fk8+4IbRswX34lPo/BdJFV5G0qe+PMX54acE
    6lv00gVtxDmgkIP6CGEleZL9qbWoXqA2tuV52C0yG7xpsMWNkMvCN/v51+Hhf9fW7iEsCg
    hWuFYjNdn5OKp/KjkJpYfUEGv+I0qBpjxsHBdjZoULL4G0EWgCiVun6QBLQ4Z7I97oMxO8
    mNESgb5/JqWf4uBVnaYDM02rPLOn4fEGSZpAAxIkmMXoRT23duwEkNmZ8Ga5IT+v8ho/XJ
    PCkb/fhaZZo0oGr/0/ozdbDPV67SewXLZ9ZpakNXpjAdrdBwRFy+FFPt2Hf3TYa3C5mYTC
    mSmfqEJm+P2jiYXI3Wokb3IFaRvrt1CpmPnuhV33AUFAXTs/MSpZXW7OMtxyIbdNQV6tYu
    BPBXQrx2p7xQAcZwZGycAznwajnw2F3Qtl/nAlWxLxpJnj91KTaq0Ko8/jEJbCjeTCCdDl
    KVtgulxJo8BKttcTC+Yo5KG5o+tQZrkJRkwqA0vRG+6lWRpC67Kj1PdtYZz0eIPjUZrGA2
    RTIwa8c910SS/a9bxUETGsMRVOALUBl/insQ0UaPZevyX2e+/klPyDBCu4ww
X-ME-Proxy: <xmx:2DCIakdSFSnxuxbFUy646Z_3pYcU_JQFsASN4D6sJAP-TMs8JrzTCQ>
    <xmx:2DCIaoEqODzw6s1FL1FnLSsCuRfvekhbFwAJ1HbQqpOQw3ZD_ZwYPw>
    <xmx:2DCIaqowZBgRL8NADKAstydP1-5mHUgpue4ZvUWDj0JXKZP_gT7mHA>
    <xmx:2DCIaqLd6vjFP-EyxxsMYhC_zElx0Y3mLCL6mll6uNeY5PR-YMnRnA>
    <xmx:2DCIajxJhxC591LPoHBXbm1Yl_2ItGS4mPuM2BlqgWSUmfCgvGc5-U2C>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 07:04:55 -0400 (EDT)
Date: Fri, 21 Aug 2026 12:04:54 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/6] efi/libstub: add a helper for the top of usable
 RAM
Message-ID: <aogvGXKH2u7JsJiS@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-1-5743791e48e6@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-hwpoison-kho-v2-1-5743791e48e6@debian.org>

On Fri, Aug 21, 2026 at 03:06:01AM -0700, Breno Leitao wrote:
> diff --git a/drivers/firmware/efi/libstub/mem.c b/drivers/firmware/efi/libstub/mem.c
> index 59f3f83de50c2..777f1f180c66e 100644
> --- a/drivers/firmware/efi/libstub/mem.c
> +++ b/drivers/firmware/efi/libstub/mem.c
> @@ -64,6 +64,59 @@ efi_status_t efi_get_memory_map(struct efi_boot_memmap **map,
>  	return EFI_SUCCESS;
>  }
>  
> +/**
> + * efi_get_ram_top() - find the top of usable RAM
> + * @top:	on return, the end of the highest memory map entry that becomes
> + *		usable RAM
> + *
> + * Walk the UEFI memory map for the entry types that become usable RAM, the set
> + * setup_e820() maps to E820_TYPE_RAM, and return the highest address any of
> + * them reaches. Memory a confidential guest has not accepted yet counts as
> + * well, since it becomes RAM once accepted. This is what the stub has in place
> + * of max_pfn, which is only set once the kernel proper is up.
> + *
> + * Memory the firmware hot-adds later is not described by the memory map and so
> + * is not accounted for here.
> + *
> + * Return:	status code
> + */
> +efi_status_t efi_get_ram_top(u64 *top)
> +{
> +	struct efi_boot_memmap *map __free(efi_pool) = NULL;
> +	efi_status_t status;
> +	u64 ram_top = 0;
> +	int i, nr_desc;
> +
> +	status = efi_get_memory_map(&map, false);
> +	if (status != EFI_SUCCESS)
> +		return status;
> +
> +	nr_desc = map->map_size / map->desc_size;
> +	for (i = 0; i < nr_desc; i++) {
> +		efi_memory_desc_t *d;
> +
> +		d = efi_memdesc_ptr((unsigned long)map->map, map->desc_size, i);
> +		switch (d->type) {
> +		case EFI_LOADER_CODE:
> +		case EFI_LOADER_DATA:
> +		case EFI_BOOT_SERVICES_CODE:
> +		case EFI_BOOT_SERVICES_DATA:
> +		case EFI_CONVENTIONAL_MEMORY:
> +		case EFI_UNACCEPTED_MEMORY:
> +			ram_top = max(ram_top,
> +				      d->phys_addr + d->num_pages * EFI_PAGE_SIZE);
> +			break;
> +		default:
> +			break;
> +		}
> +	}

You model it after setup_e820() which is x86-specific.

On ARM is_memory() adds anything with WB/WT/WC, and is_usable_memory()
also counts EFI_ACPI_RECLAIM_MEMORY and EFI_PERSISTENT_MEMORY.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov
