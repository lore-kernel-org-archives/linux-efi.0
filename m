Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA5F34B404;
	Mon, 16 Mar 2026 06:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773644038; cv=none; b=pfwywpKvUMLg9kFI41JX5HKSgfHTEhrPkyfB1zXUKUmPv3CJE/y3m8KpPnWACN8xi9dUcbxFwiC1xG60aOWH4SCPVcZSucdVnRiUp4enBf0Dx/whzLnoAg758BYuQpVwlTrHLI+PEys9W/HUnVkumcADfQePyKv6NlET/1uFfDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773644038; c=relaxed/simple;
	bh=7+64g1YYk9bvms7oHN6eUuMTVwOc53O2+8MQK1i1plk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J1QNFRfQow5skaYzaaIbBZ1pydL8USzFdslKS38kFLTU8rTkZxEA6qv4m5BC79cRPQuK9bT1a2I0vd66lKooKHP+BA2WRFhN9B3RYXk4Rek/JoqLalZws1NyXdg8TlIcU9ZsT6Abps0xtDi98HqYJtl/w5ZAFZIx+Z1c0JERMT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OEaFIlC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEaFIlC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA7AC19425;
	Mon, 16 Mar 2026 06:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773644038;
	bh=7+64g1YYk9bvms7oHN6eUuMTVwOc53O2+8MQK1i1plk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OEaFIlC/je7KlOjsYEWQrvooxKMn47n8ffF6euBdpI3Nd6R8zsCX+N3k8emWmKQnT
	 8v/ZYtj3fIWtnLU/wEA+zNnkc2MxuEG2ZOmU8kflt8HmPUXgWdcJMAGwUG20QOw17R
	 XjEp0n0yukXTttB6l8H1bw7J+8yAeP3DS+xhvGrOCQJT7rVfQsyabm6/w2I76mtnFJ
	 EXMdQQM3pQ+iG/sxxIp13fyThysAYBT3qPA98s8rRIQDPyGc8ueYa305FPYn4jQoYD
	 6qsSOrSXvi1Z8kfxWjvjWO1z5va9iwyq6AAl9bPyT0R1Q0spgXA/ylgyS2amJyQnXa
	 N+85t0/r/A8zQ==
Date: Mon, 16 Mar 2026 08:53:52 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 1/9] memblock: Permit existing reserved regions to be
 marked RSRV_KERN
Message-ID: <abepAJrN7bjeNLzr@kernel.org>
References: <20260306155703.815272-12-ardb+git@google.com>
 <20260306155703.815272-13-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306155703.815272-13-ardb+git@google.com>

On Fri, Mar 06, 2026 at 04:57:05PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Permit existing memblock reservations to be marked as RSRV_KERN. This
> will be used by the EFI code on x86 to distinguish between reservations
> of boot services data regions that have actual significance to the
> kernel and regions that are reserved temporarily to work around buggy
> firmware.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/memblock.h |  1 +
>  mm/memblock.c            | 15 +++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 6ec5e9ac0699..9eac4f268359 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -155,6 +155,7 @@ int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
>  int memblock_mark_nomap(phys_addr_t base, phys_addr_t size);
>  int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
>  int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
> +int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
>  int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
>  int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
>  
> diff --git a/mm/memblock.c b/mm/memblock.c
> index b3ddfdec7a80..2505ce8b319c 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1115,6 +1115,21 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
>  				    MEMBLOCK_RSRV_NOINIT);
>  }
>  
> +/**
> + * memblock_reserved_mark_kern - Mark a reserved memory region with flag
> + * MEMBLOCK_RSRV_KERN
> + *
> + * @base: the base phys addr of the region
> + * @size: the size of the region
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +int __init_memblock memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size)
> +{
> +	return memblock_setclr_flag(&memblock.reserved, base, size, 1,
> +				    MEMBLOCK_RSRV_KERN);
> +}
> +
>  /**
>   * memblock_mark_kho_scratch - Mark a memory region as MEMBLOCK_KHO_SCRATCH.
>   * @base: the base phys addr of the region
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 

-- 
Sincerely yours,
Mike.
