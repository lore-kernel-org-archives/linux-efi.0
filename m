Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B60A59;
	Thu, 30 Apr 2026 07:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777535512; cv=none; b=E1mL5gN//AKuVxyc6o4VejV+nT7JXWCnr/uMUKFykbBuhdA4PGriyJHTHBDR8sux2L/4BeYkRr7NNUEWiQ3YACzXEeHf61naZPkTneVV8ockMm9XJuwGo+Yej1/Y3dUkebtH/klsnJ66Q99SS6ETKrdOUEGmoXLXoYdWtOUUvN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777535512; c=relaxed/simple;
	bh=omB0cPFbcJR1aTGvPYweI9ttFbTkvnjHz/3tBImfyz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvYBdz7C4Ykq6sKtiwCC9ljBbm2qa8DTJWZIUk9mShSUz5NAJ1jhhOHEBxRdfyQaJZCCHjs42+VJpRZ8eYoRi4wtqlXJWRbPPtMR4L3J9EaMT7SqmmjUHKg5fkucYukz/9Epa2CGk6ZfQb3Skv8PxHrG+9A1l8xLtW8+HOoSveE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CGniRKjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CGniRKjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F388BC2BCB3;
	Thu, 30 Apr 2026 07:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777535512;
	bh=omB0cPFbcJR1aTGvPYweI9ttFbTkvnjHz/3tBImfyz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CGniRKjJDcMMa+jSknbvc9Rlummh2xbrcKzH/WE1LLyNzkl59cwhYEQjYfjQN7dCe
	 FpAJqKGNqTg0dIwcGwdcS3TFE7jOFf9170gwhmosrvUBiGsGlfu/ygW5ExQyKZhrf0
	 UTbcWVDnrruLV6BZ/bEZDpdegBXf/Sm/n6LkUhCL0G2ZoAHoqcG1Zy6ZUUbK9jhC9O
	 vDoPQOcXEjkxZPeX7iWjUbMfUGR5V/JUkJr2dQSR1gUtBGb7hnSlEGkcy5tar8+Aj1
	 aiMC2K8VpH3LtzRHO34kgl2c7INJm6vAybmMw+VY4/DnUeLW5XvbmATH3cuMazUJpk
	 oHPRLtkYNNdIQ==
Date: Thu, 30 Apr 2026 09:51:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64/mm: Rename ptdesc_t
Message-ID: <afMKEgJGWZpZjZub@kernel.org>
References: <20260430034933.541634-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430034933.541634-1-anshuman.khandual@arm.com>

Hi Anshuman,

On Thu, Apr 30, 2026 at 04:49:33AM +0100, Anshuman Khandual wrote:
> ptdesc_t sounds very similar to the core MM struct ptdesc which is actually
> the memory descriptor for page table allocations. Hence rename this typedef
> element as pxxval_t instead for better clarity and separation.

Maybe we should keep the "pt" prefix and make it "ptval_t"?
No really strong feelings, so

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-efi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This patch applies on v7.1-rc1
> 
> Took the liberty in including David's tag from an internal discussion.
> 
>  arch/arm64/include/asm/io.h            |  2 +-
>  arch/arm64/include/asm/pgtable-types.h | 14 +++++++-------
>  arch/arm64/include/asm/ptdump.h        |  8 ++++----
>  arch/arm64/include/asm/tlbflush.h      |  4 ++--
>  arch/arm64/kernel/efi.c                |  4 ++--
>  arch/arm64/kernel/pi/map_kernel.c      |  2 +-
>  arch/arm64/kernel/pi/map_range.c       |  4 ++--
>  arch/arm64/kernel/pi/pi.h              |  2 +-
>  arch/arm64/mm/mmap.c                   |  4 ++--
>  arch/arm64/mm/pageattr.c               |  2 +-
>  arch/arm64/mm/ptdump.c                 |  2 +-
>  11 files changed, 24 insertions(+), 24 deletions(-)

-- 
Sincerely yours,
Mike.
