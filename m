Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE652D592C
	for <linux-efi@vger.kernel.org>; Fri, 28 Aug 2026 14:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787926282; cv=none; b=e564UapHI1n7xPpXu6xiaBdrs7kgOBJBk07OM9Qt4SVGkmt0yJEpaS/G9DaOYBcgv1DWdUkqTDdEltlkiUBxUAjyY6gkWnq58SZTN6CMtUsgCeNxeW6reTWuVAHewif1Oy49BjsoWIUui1HqGjlgiLDG+3zIV3IYN9lKVAsK81s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787926282; c=relaxed/simple;
	bh=zx3nsKWTltY3MFKuLkPckkA8gWREFpd2w76hoQ5jIcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WfQNLUuZ05kUPAa75BUo5tXEBKrXC7I1rep3GU2oeGUmlQe+LWkvRMn0Hy2NYGGZVj6z31a2TtRnvZxzc0cgfKmsf+0iD6E52c4RmkZ1zuZlbc1z0EeaNARmCt+FkXuh28j4H3YjWqxTLgUDVncYZmIEkio83ilCTRqbBnU+AcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URfLviro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URfLviro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706C41F00A3A;
	Fri, 28 Aug 2026 14:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787926279;
	bh=U7b6NXuQpbm+Bpwe770MpMgWC/+r6IvbVv/YGtdtPR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=URfLviro2w0VdJ4YO8neeZvUxtIdNwrPWpvPo48fNJ8y84NnI1SrupmK5IKxoSOny
	 n+fC7M1OrWiec6Ar1qgigzfapw4D/MkkurtVnFwnp8FqLyTa5wd76JTmA+0klf8cx7
	 I12MgxdC88orwWRC/waMtG3j6M5KsSimDuLC9jWVROYPDlF9kZ3Ib6yI3++Eg4yzl7
	 m7fcdj1sN25g+P9JHwJF3gDCGg49Bpl5+94pckjbqGHpaKSvWDa9F+BQpv5O9GUZHM
	 MdSKP7Cvh7/nBMkuA4W5AXbbiT5Y6lzR+bBK2JFFLQBJLP6Jr13EBYRjt8Yi+KAFet
	 pKbM60O03S71w==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.ams.internal (Postfix) with ESMTP id E6CB4198003A;
	Fri, 28 Aug 2026 10:11:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Fri, 28 Aug 2026 10:11:16 -0400
X-ME-Sender: <xms:AJeRas1aZk9opjMSiGX5jElAqjZ4yIFj2k79pkjQWBBDs2rRAZz-GQ>
    <xme:AJeRaqPZSBLSs0GN8Ma9LdPe9x3z3EXOw3X4xZZ3t6AdjbQEFNUAw03QHcz8KE-4c
    gfOnZTcW8a2Jq_e4kyjWntEV2vEZ231XWkT4_Qb_6D4Pub9gbb2G14>
X-ME-Received: <xmr:AJeRaiWuEV238jidr06ojGeBuk6qzsjid56OXlDDKuTMiedxTLZPhL_oZmY>
X-ME-Proxy-Cause: dmFkZTGfMEtIdxK9TZhqZLeRbfNvLYXlwoNy36VBDoEf9Mft6xswYTLKr5+mL4ccPtdqIJ
    +vUC/Jlk/xplE2julyVEiux1aCh0eTADY2ObZjiUqkrKT5Ef1K/Qc+X4X0h0mCPmpbKqPL
    AjDnxuLaEDPB4g2sNEZHXSXz0it2PYy7eaS5EAF/3j8NDfbb1e2T+8R6ZWYLnhBvUGl17y
    1sAzCDfz5CMOQDgVGhn24L+BZer5Uyqd71kfJ6/xMXI3m8JiQIMTFF4KPRsN79kPqDCBAY
    w1NnkXoPPSuNed5UOjneSlrXRudTr2DT8EOVI2Rn2XM0JKcyccE5oUSCd89xeQcNPWIMqW
    2o/KtmRCeONuaV8kcZ3bSQ9t3OqJhmCbPkO1VXJO6s3+D7dlY6dmU9D3tPPOqBhNvdtKTK
    OlaIZTh4bSsVAY/aKs93BhArFKW2i3ZdUkEb81t3r9qa1ONHeB9sHjOY0dXWaLTARhkva4
    vIi3zi/TNm4LExcwt8SOAO0b1TWucerQhHfZrj1XTyd44r1NHzSJG1WmyL7CUUMDkVGO6H
    SpcvpmXTUDEpUJJ5+nx0UJxYbn1u7Wz+yOACY9/dhRipLWlz+rP1JSLvg/ZlrszAEwRUbV
    tDHQCBk21ZXc2A2ldQQ9t4qy/RXSjvgl7kAflQd5gF1SRV3DvYJUOlXmZruw
X-ME-Proxy: <xmx:AJeRaqbiOjLtG_O770h2bh6BHEdo4Bfr0xoea3h137RsTu7NgBpFug>
    <xmx:AJeRatvSmGpff_pBo8O3gYONJARpaii_gjMdzsVD37p2L3pNXZ5jqw>
    <xmx:AJeRasls8flkBSEysMaaYuVugCPUBY3Vj4AGw7dHVBnplXF-iqOgAw>
    <xmx:AJeRanSZBbWnVQE4lXp4-_7P4acsvBKQPgaH-3fdXqdmG9QsGgIrXg>
    <xmx:AJeRauMjyfqAE17oyt7EQXafma_xxc_kKuxVOfPciLs7NHoGagJ_eI5B>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Aug 2026 10:11:11 -0400 (EDT)
Date: Fri, 28 Aug 2026 15:11:10 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 3/5] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
Message-ID: <apGWUWi5-RbhFHpe@thinkstation>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-3-6f79c4b605bc@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826-hwpoison-kho-v3-3-6f79c4b605bc@debian.org>

On Wed, Aug 26, 2026 at 05:03:54AM -0700, Breno Leitao wrote:
> diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
> new file mode 100644
> index 0000000000000..d6855e712832c
> --- /dev/null
> +++ b/drivers/firmware/efi/poison.c
> @@ -0,0 +1,126 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Runtime side of the LINUX_EFI_POISONED_MEMORY table: one bit per
> + * EFI_POISON_UNIT_SIZE, set here as frames go bad, honored by the next kernel.
> + *
> + * Copyright (c) 2026 Meta Platforms, Inc. and affiliates.
> + * Copyright (c) 2026 Breno Leitao <leitao@debian.org>
> + */
> +
> +#define pr_fmt(fmt) "efi: " fmt
> +
> +#include <linux/bitmap.h>
> +#include <linux/efi.h>
> +#include <linux/io.h>
> +#include <linux/log2.h>
> +#include <linux/memblock.h>

Is it leftover? I don't see any memblock usage.

> +#include <linux/mm.h>
> +#include <linux/overflow.h>
> +
> +static struct linux_efi_poisoned_memory *efi_poison __ro_after_init;
> +static u64 efi_poison_nbits __ro_after_init;
> +
> +static u64 __init
> +efi_poison_usable_size(const struct linux_efi_poisoned_memory *pm)
> +{
> +	u64 nr_units = DIV_ROUND_UP(PFN_PHYS(max_pfn), pm->unit_size);
> +	u64 bytes = DIV_ROUND_UP(nr_units, BITS_PER_BYTE);
> +
> +	/* Whole words: the bitmap is reached an unsigned long at a time. */
> +	return min(round_up(bytes, sizeof(unsigned long)), pm->size);

Hm. Why bother to clamp to max_pfn? What's what's wrong with just using
pm->size directly?

> +}
> +

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
