Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794553CEBB9;
	Tue, 28 Apr 2026 08:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777364488; cv=none; b=L00P/+Q1dYOT0z36y1Ge7IJe3bYcZix/VNCaPau80QePBsK1+TWc7P/XNwXe+RHhkqVD2VFyvKTcmWJJ9uIcJ48v+hpq98j6OrW+FFKuhy+obROMKgsNw/EGFZU7iMKQP8mMiACr37HNQ0Qm3VnXOJNPkjm3yBptv5W1wJMINKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777364488; c=relaxed/simple;
	bh=bRlSjTuBfi3zM2DJsCs+HvbxHwegTPef9Enkd36bHTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FxAIM1/ibQUFgLMRp6QwHzk15IimU20e636GAzlmpz7cMCgKb5YwC5sAfmJxejXzv9AGUOjxqivqCJzKfA9HKGflyIgnmVjIVWiTkyBYQzOUTTn+BaXHpL+4HisbpJdqb41gBC7/Npv5lWzJ7Bi683pefzy7RyO8oeBFwjjmhSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T47/mHPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T47/mHPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF6CC2BCAF;
	Tue, 28 Apr 2026 08:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777364488;
	bh=bRlSjTuBfi3zM2DJsCs+HvbxHwegTPef9Enkd36bHTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T47/mHPw0Ltm2Ou1RBB8ICI1VTwaDwuEIIHmjmTDEabPXv4f4olP9Btg+zVdk4AyW
	 8SsVkjCCOLev7ls3MMSQV0G9hkoJZpCGI3bsrAm0WcmhCGCoreFCt8aVGrK0jcSEWY
	 /npQzXRFJpu4MuaLHEvQpPoG4913+Ptq3O2BypVA9RU5OrWTaj4O90CJ0tehHg9gH0
	 eLSNlPyttG1I6F0E6sUxIh3CmbAzLffk2xgM1LdYFPymG4JkAlG6Wt7cOX7oObryZh
	 eWUP7K0KGPog7I1c35rCtZZbVzJqQADVI//p0/+rkmxH7FJbGbnbty0UqdHEP9RK6n
	 rZclyUkmfGMTQ==
Date: Tue, 28 Apr 2026 10:21:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v3 01/17] x86/efi: Omit redundant kernel image overlap
 check
Message-ID: <afBuAZGndc0jZhm8@kernel.org>
References: <20260423152024.1098465-19-ardb+git@google.com>
 <20260423152024.1098465-20-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423152024.1098465-20-ardb+git@google.com>

On Thu, Apr 23, 2026 at 05:20:26PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The physical region covering the kernel's executable image is
> memblock_reserve()'d in early_mem_reserve(), and so it is guaranteed not
> to intersect with the regions passed to can_free_region(). So remove the
> pointless overlap check.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/x86/platform/efi/quirks.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index df24ffc6105d..4d8de7c6ce59 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -305,16 +305,11 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>   * can free regions in efi_free_boot_services().
>   *
>   * Use this function to ensure we do not free regions owned by somebody
> - * else. We must only reserve (and then free) regions:
> - *
> - * - Not within any part of the kernel
> - * - Not the BIOS reserved area (E820_TYPE_RESERVED, E820_TYPE_NVS, etc)
> + * else. We must only reserve (and then free) regions that do not intersect
> + * with the BIOS reserved area (E820_TYPE_RESERVED, E820_TYPE_NVS, etc)
>   */
>  static __init bool can_free_region(u64 start, u64 size)
>  {
> -	if (start + size > __pa_symbol(_text) && start <= __pa_symbol(_end))
> -		return false;
> -
>  	if (!e820__mapped_all(start, start+size, E820_TYPE_RAM))
>  		return false;
>  
> @@ -343,10 +338,8 @@ void __init efi_reserve_boot_services(void)
>  		 * Because the following memblock_reserve() is paired
>  		 * with free_reserved_area() for this region in
>  		 * efi_free_boot_services(), we must be extremely
> -		 * careful not to reserve, and subsequently free,
> -		 * critical regions of memory (like the kernel image) or
> -		 * those regions that somebody else has already
> -		 * reserved.
> +		 * careful not to reserve, and subsequently free, critical
> +		 * regions of memory that somebody else has already reserved.
>  		 *
>  		 * A good example of a critical region that must not be
>  		 * freed is page zero (first 4Kb of memory), which may
> -- 
> 2.54.0.rc2.544.gc7ae2d5bb8-goog
> 

-- 
Sincerely yours,
Mike.
