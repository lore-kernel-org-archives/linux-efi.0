Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590C2369D66;
	Mon, 21 Sep 2026 09:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983888; cv=none; b=f7mZ7dWa8KbnBSELNJgsjduZ0kevcSu7YMyMjmNjqTrPA+fiH3l/joM8k44fKK3HvT/R4M7tiy3gwS3ZusPclF+90FkRW2kwtFWbKtARO57buElYkG2T5lRkCLeZKpYAS+UT7XUMeZ04y+zx53BAkJOLvQNTsmmQTM88YwhUlzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983888; c=relaxed/simple;
	bh=21HQ9Jm+j3bA+jZJyxERUm/iQSi9IvRUOjPhb/LBexA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dq26cFtWqcKdKJosBI9RhVQ9qHCTt74uffzGL8KGrOx5DEj/8g+iZ6yXMRHGffRdROUEe6e4MFLgnDPN65wmFzWB1C8HgfH0BJiZMBV4qRZGxsBMMeZGjM6o5x72YGHSR7GVZuec7dP6XMHetcdfpiWsBfQ/Vr0sO/q2g3Zz9hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=e52ERe3N; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="e52ERe3N"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84ADA153B;
	Mon, 21 Sep 2026 02:44:41 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD1793F86F;
	Mon, 21 Sep 2026 02:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789983885; bh=21HQ9Jm+j3bA+jZJyxERUm/iQSi9IvRUOjPhb/LBexA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e52ERe3NX85DTf+sp8aD7+t+Z3+kuFmz2m3Q1UFRyMS1D4lxPKCftTkfNT25qwagy
	 O4kzIm9OdRUieaMkJo7t5izcU6xr9HIDIhIJ2AIjuMfNbPHeo3gS24WWx3cczAEWEL
	 Sy6+/Iq7UIvFNwm5CwTWVVvAgQg4fN+pILUIHuRM=
Message-ID: <cb0f1d49-865b-4728-89f7-7d8552dabd67@arm.com>
Date: Mon, 21 Sep 2026 10:44:38 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] arm64: enable a distinct type for HW PTEs
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
 <20260914-pte0_arm-v1-6-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-6-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> With HW PTE pointers and direct HW PTE accesses converted, arm64 can use
> the generic hw_pte_t wrapper instead of the pte_t alias.
> 
> Select ARCH_HAS_HW_PTE_T to give HW PTEs and SW PTE values distinct C
> types.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 2bbeded33da0d..42841d5e2ed26 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -31,6 +31,7 @@ config ARM64
>  	select ARCH_HAS_FORTIFY_SOURCE
>  	select ARCH_HAS_GCOV_PROFILE_ALL
>  	select ARCH_HAS_GIGANTIC_PAGE
> +	select ARCH_HAS_HW_PTE_T
>  	select ARCH_HAS_KCOV
>  	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
>  	select ARCH_HAS_KEEPINITRD
> 

