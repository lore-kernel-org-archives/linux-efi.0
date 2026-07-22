Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29BC2248B4
	for <linux-efi@vger.kernel.org>; Wed, 22 Jul 2026 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784728222; cv=none; b=mQ7f5ZqJzDD/WeCEkIiTgl2c47jzfvwE/yQGO1ljzvRVaylF4bI/tvuQGcitEY84v6K7BVOvKmdbrZH6KqLYsG7SOqHQ7zt4ZpYTF4IttIggxUQvpk/leTbS9Dmg8769ITEGoc3LfhTHx0unYlYGm8txYi3WaOsATGjb8PoMoDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784728222; c=relaxed/simple;
	bh=RZTKR1BFgn752DIvCx3uxo9MvI0G2kWTvnugFgV62d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCgLhZfSqJDXeyCQCdIA0itU8fEfjXZJD5bI43iF2aAHsKf9yVZW791MwH9tg4Q7SceJxy9a5pj1p2r10K1GDgYGplLxiymZdN/qCZymC3wquT30sRgclwosmz2SWTsbBu0ypjyKek+/FzyxhrDax6e9AIeddf2avYEzShlkMBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/r8Fyat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/r8Fyat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E749D1F00A3A;
	Wed, 22 Jul 2026 13:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784728221;
	bh=EeoRfimiiY9Q3irn9keuGCYbXE0eQn79Xjd7POvlsJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T/r8FyatYSzoUoPZRC74rXA7bBAIRxpONYRHXdf5Mi9dhy8o8M3tl3WV99KKPwGMM
	 IH9UFgzJb9bIEhpaVALb7TbbknHaBSdPxIOD3d19VqZpowS4XZAyxgCrlw7siDmfVQ
	 FNZ/sAhxfRwrZczlvoQSBwaXyQmgyRMiJCYM61R0X/ZS3G8Th1dLH+ptYJSP1K2Jp5
	 roZK41OtTIwZGPW5WSJytAcGaD187QNdEOWl38XZ87MrCAkQlmqQhzZQJlMrRiJwFo
	 c6zBuLhlrT7TpaZrYl11bPxgbR9tuYnO524xJFLJyz+6bdjCxSanzCRDHzClATsZYg
	 M4A4Il8iCaJ9g==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2C847F4006F;
	Wed, 22 Jul 2026 09:50:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 22 Jul 2026 09:50:20 -0400
X-ME-Sender: <xms:nMpgaiPexXFulMtpWAyLEaEws_-rBvDj0PQ7nmNGPHCBgS-KBKDNBQ>
    <xme:nMpgajSrEPao7G6bTDU0XWoDvVCmO7WBXv3GdxFWtvv8dfUK4lvbHOf-uIWKE4G0-
    svdqhEJJHWxEfQ0MpHekm9lNeDeTIgySWQ32Rc-vCU2JDiA_bKRUI8>
X-ME-Received: <xmr:nMpgan_6rMcwyWKWVzJq8xp5IEMCamoJNxGsOhK9UYawu_-PKD2zTaLOKfnwuA>
X-ME-Proxy-Cause: dmFkZTEcLBRCwuXySOYV7H6x7DkJIvrYO9Ery/tQi+sq7I57KFQUF1qdJr6zrlSqcvF9Ph
    deAkADIfMnJyfKCJ80SNnkezEOqscALfqlkpBZTUnQSZZojV5gyx0oOKDQ0eri80MNuuIr
    9gObeR+HUgmEj6Cla+MYcNTg61VpyDq7ILZJ/gN3wdt4zxWIg555StQsNfcRCIc+pu1iVB
    t3awqXZ6ybgYd/ROnC7Vy91+fg1Jo2IRoZUm9rhFFIGANGcUB02mSARfiA+BSLCJLBi1AW
    nlHlvxx/+fNSry5BX93yUaiaCtAggG4UtjCXDlcJLSNCvDXHqZhnM/P/q2SuH0l+gyjUtm
    BzaKLVGOEjqwfH6K6BnJRff/8fHaDSj0YoXDewKOs2KDXip6nXwim7proZPQ9XFv2/NSAI
    IEQptmkwx9KLubsenYj8MUM5ucfDyR5ctDxbCXlcEbr/zfX9uljpbFZonG3zlcAgEFtgVf
    nVw6w977M5lPgjrBjAwkT2YRp5l3WFRrvREt87A0++ayBq5h4EtGfKR4nNTB30NSTHwxoY
    YeC/aMQACKWpu6iOqk5bjUvsgv9CvZRZFaZFvKqM1BHmmMU8E1l3IP1x6QhejwkHRwBM4b
    tp/ous0bXtJIqShDCMBjz8XITbuGcABDhJXHj8K8DwVkydmOEytoWiAQYCpg
X-ME-Proxy: <xmx:nMpgavrX9fWw6b6Zb5y_znY8GnfRFScZx4f7Uw4ayNe5cQ3hQH7amQ>
    <xmx:nMpgaoGuwB2bl2huD-XpJ3TFcPX9GomeQDNDaHojGSovRPu-l4v5Wg>
    <xmx:nMpgau3ijbR3EzLaS4uCt5blXvK8FClevkg5H-p0CteeeXjFLc0Wxw>
    <xmx:nMpgauOiOx20T1ZNOfSc24IAUGCBRPEUjXmBnYDAwaro0bOwMzOdKQ>
    <xmx:nMpganU0caj9CT79AvPOSmVsSSJs4n3N9fjnBeSXi_ossJ05Ij7IRKWr>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Jul 2026 09:50:19 -0400 (EDT)
Date: Wed, 22 Jul 2026 14:50:18 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	rneu@meta.com, riel@surriel.com, caggio@meta.com, anilagrawal@meta.com, 
	rmikey@meta.com, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH RFC 0/3] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Message-ID: <amDHmNWfQ8eid9jH@thinkstation>
References: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>

On Fri, Jul 17, 2026 at 07:03:02AM -0700, Breno Leitao wrote:
> Problem:
> ========
> 
> When a page is hard-offlined due to an uncorrectable memory error (multi
> bit ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from
> the buddy allocator. This information is not carried to the next kernel
> that is kexeced. The new kernel kexecs and trip over that bad memory
> bank _again_.
> 
> Why now:
> ========
> 
> Several industry trends make this increasingly important:
> 
>     1) DRAM is getting more expensive
>     2) soldered / on-package memory (LPDDR, HBM) is becoming more common, so a
>        failing part can no longer simply be swapped;
>     3) memory is kept in service far longer (at Meta, DRAM lifetime is being
>        drastically extended).
>     4) It is more and more common to kexec instead of full reboot
>     5) Increase of memory per system with CXL
> 
> Proposed Solution:
> ==================
> 
> Carry the poisoned frames to the next kernel in a new EFI configuration
> table, LINUX_EFI_POISONED_MEMORY, modeled on the existing
> LINUX_EFI_MEMRESERVE table.
> 
> EFI configuration tables already survive kexec: firmware hands the EFI
> system table to every kernel in the chain, so a table installed once is
> seen by all successors without a new handover channel.
> 
> The mechanism is architecture independent, so x86 and arm64 use the same
> code.
> 
> The EFI stub installs an empty table while EFI boot service is up. A
> configuration table can only be created there; the running kernel can only
> append to it.
> 
> Each hard-offlined frame is appended; an unpoison "removes" its entry
> so a frame that is good again is not carried forward.
> 
> The next kernel walks the inherited table early in
> efi_config_parse_tables(), before memblock and the buddy allocator are
> up, and memblock_reserve()s every recorded frame. The bad RAM is never
> handed out.

The allocator is only half of the problem. kexec segment placement
doesn't know about any of this: kexec_file picks destinations from
System RAM resources (memblock on arm64), and poisoned frames are only
ever removed from buddy. So the next kernel image, initrd or purgatory
can be placed on top of a poisoned frame -- the relocation memcpy then
consumes the poison and the machine checks during the very kexec this
series is supposed to protect. Same for the table's own list pages:
overwrite one at placement time and the next kernel parses garbage.

Hooking num_poisoned_pages_inc() also means soft-offlined pages are
recorded. Those are functional pages, offlined predictively. Turning
them into permanent losses for every kernel down the kexec chain does
not seem right. I would record hard failures only.

On the data structure: I am not an expert on DRAM failure modes, so I
went reading. The field studies [1] say roughly a quarter of DRAM
faults are multi-bit structures (row/column/bank), and the address
interleaving means one such fault shows up to the OS as many separate
4K pages. A row fault lands in a window of tens of KB to about a MB; a
column fault is one bad line per row, strided across the bank's entire
footprint -- potentially thousands of pages scattered over gigabytes,
reported one MCE at a time as they get touched. DDR5 on-die ECC hides
most single-bit faults from the host, so the visible mix shifts toward
these multi-bit modes over time.

If that is accurate, per-4K entries have no natural bound, and every
entry becomes a separate scattered memblock_reserve() in every future
boot.

I would consider a bitmap with one bit per 2M instead, modeled on
struct efi_unaccepted_memory: the stub sizes it from the EFI memory map
at cold boot, the running kernel sets a bit on hard offline, clears it
on unpoison, and the next kernel reserves set units. It is one
fixed-size allocation, so the whole grow-and-link machinery and the
chain-parsing trust problem go away, and a row fault collapses into one
or two bits.

[1] https://arxiv.org/abs/2408.15302

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
