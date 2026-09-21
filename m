Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6998468C38;
	Mon, 21 Sep 2026 09:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789984275; cv=none; b=Agcryb/lPYXv0xl+yso66I+X/43a2acB+fdzA2kAU8OHNCAD6dWyj6WXN47fr9nNaWWPnmXrAIHbF/noyzl8mNdvyro/c4uI5X34sb3/BazmKT1u91SdZq/sEEPCWDnYQWqgYL9LPKFGdcESEe+mxzAYQ4UyD2S4kq7fFVJigIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789984275; c=relaxed/simple;
	bh=Yh04mAUW/tMDEOlWdN+OXJwoGQ3qq3vUxi4DFjfm1GY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LU0YpL9tx6m1Zf3O/descXuNKTOEMaFuB/aHVszr33j5FUQEYKItdYRVPUYTAoVajSRewq01w7CAF5uhSLPWRXHF1Mny6JAq1Q7K0p98Ip1TrEeAJUwfHl5L4jMx4vkd3xe4PPuL2toRGD/xOHdQ7e/I8mPydV/AFcjD4TsJzgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PwNXaD+0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PwNXaD+0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A778153B;
	Mon, 21 Sep 2026 02:51:09 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F7573F86F;
	Mon, 21 Sep 2026 02:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789984273; bh=Yh04mAUW/tMDEOlWdN+OXJwoGQ3qq3vUxi4DFjfm1GY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PwNXaD+0WUdgUn9Bq7v/HPrz6iSdG1Ka6YECPv9iF0/ZzjF26pxz1O08q0ccMYQOB
	 bwL5+mucY5hunLe30UlgLiO6VVb5ARI9CGDPOGyQ+uv4FlLL6YtNVCUQHpoIMJEw4b
	 NXAtZ3P9Af5w6Y40kU8Ymb3s0bMrOwUXnW+78CFE=
Message-ID: <27fb625b-7117-4666-9a34-3b8aa9a43833@arm.com>
Date: Mon, 21 Sep 2026 10:51:07 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] arm64: distinguish HW PTE pointers from SW PTE value
 pointers
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> Hi,
> 
> The generic series introduces hw_pte_t for HW PTEs, while SW PTE values
> use pte_t. This series enables the distinct type on arm64 so the
> compiler can distinguish HW PTE pointers (hw_pte_t *) from SW PTE value
> pointers (pte_t *).
> 
> The conversion updates HW PTE pointers and accessors, including atomic
> updates, fixmap, and early page-table construction, before selecting
> ARCH_HAS_HW_PTE_T. Higher-level entry types remain out of scope, and
> shared helpers retain explicit casts.
> 
> The linked generic series is a prerequisite. Its cover contains the
> Coccinelle script used for most pointer conversions; the remaining sites
> were converted by hand.
> 
> Link: https://lore.kernel.org/all/20260903103002.1091859-1-usama.anjum@arm.com/
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

I've been through this as best I can and provided some minor comments. This all
looks ok over all. But given the number of small changes, it would probably be
wise to go big on testing; what level of testing has been performed? I'd suggest
mm selftests (with all the magic to make all the tests actually run) at minimum
and all the fastpath benchmarks as a stress test.

I think it's quite ugly (and adds a bit to the cognitive load) to have this
intermediate state where only ptes are converted. But I understand the need to
do this incrementally. Hopefully you can follow up with the other levels soon :)

Thanks,
Ryan


> ---
> Muhammad Usama Anjum (6):
>       arm64: use hw_pte_t for HW PTE pointers
>       arm64: use hw_pte_val for HW PTE atomics
>       arm64: convert between HW PTEs and SW PTE values
>       arm64: use hw_pte_t for fixmap HW PTEs
>       arm64: use HW PTE accessors in early map_range()
>       arm64: enable a distinct type for HW PTEs
> 
>  arch/arm64/Kconfig                |   1 +
>  arch/arm64/include/asm/hugetlb.h  |  19 ++---
>  arch/arm64/include/asm/pgalloc.h  |   2 +-
>  arch/arm64/include/asm/pgtable.h  | 157 ++++++++++++++++++++------------------
>  arch/arm64/include/asm/vmalloc.h  |   2 +-
>  arch/arm64/kernel/efi.c           |   3 +-
>  arch/arm64/kernel/pi/map_kernel.c |   4 +-
>  arch/arm64/kernel/pi/map_range.c  |  20 +++--
>  arch/arm64/kernel/pi/pi.h         |   3 +-
>  arch/arm64/mm/contpte.c           |  49 ++++++------
>  arch/arm64/mm/fault.c             |  11 +--
>  arch/arm64/mm/fixmap.c            |   8 +-
>  arch/arm64/mm/hugetlbpage.c       |  48 ++++++------
>  arch/arm64/mm/kasan_init.c        |   4 +-
>  arch/arm64/mm/mmu.c               |  46 ++++++-----
>  arch/arm64/mm/pageattr.c          |   4 +-
>  arch/arm64/mm/trans_pgd.c         |   4 +-
>  include/linux/pgtable_types.h     |   6 ++
>  18 files changed, 215 insertions(+), 176 deletions(-)
> ---
> base-commit: ead700ca770c82167af32622cf8b68c9f87c3c7c
> change-id: 20260911-pte0_arm-f1b7df7c0b51
> prerequisite-message-id: 20260903103002.1091859-1-usama.anjum@arm.com
> prerequisite-patch-id: 0114fcc6ab0dbb739b5bb6fc0fe6b1c8f1fa37a1
> prerequisite-patch-id: 09fcf65970074620dd3a9cce6850b901beb01db8
> prerequisite-patch-id: 9b2fdab97c99effabb85526fa7f141c933b3aa23
> prerequisite-patch-id: 1aa309a26d98a1e93a54742705a03567ee93be71
> prerequisite-patch-id: ebe32f52c95ad0542982f0b37798d209595e25e1
> prerequisite-patch-id: a60d249f52d092524176851b2570d7245bb24434
> prerequisite-patch-id: 81ebd1378e25d40a1771b53973abcc4defa87535
> prerequisite-patch-id: d982f2b00c5eddb2459f69008a73e4f4ae4d8299
> 
> Best regards,
> --  
> Usama
> 

