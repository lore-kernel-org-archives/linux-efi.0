Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169111DF723;
	Mon, 16 Mar 2026 06:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773644132; cv=none; b=CDm3LwUNG3uVAuv2aBQxQ1nuV+wnGEQ6Ot/IYLHjE6i88E/BC0TUpMo88RLlTSOb+NeRsUVga3IJiNRTRvFEV7Jvy9nJGiyHVFwl92elRfim7mpSEsf0r1TV2iiOTnd7fdOnjpDhyF3/R1+CBYuGcUTxfkFDFA7l33P7kXzpBno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773644132; c=relaxed/simple;
	bh=Zfn7Qeb4THipJ0yCSUbqrHM6H6B+OqJqpNMRhDW+NN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLdmkJRoyXI7LqL6X027AEU5GOJE/2ZFzZgRULdxHtQ1PMFmxuHsTR4fCkKfYsdJYGjlypZ5rC2DaqOUqBgLmC7H3Biu24MGZWXSwFj7tVt0TkY8jbzdVmHwwqMYmxPfCmgrv2dDwXdfHCEajyCtNtAwQXmbGixvlqJfRQ1NS0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eF9vWBQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eF9vWBQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55ABAC19421;
	Mon, 16 Mar 2026 06:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773644131;
	bh=Zfn7Qeb4THipJ0yCSUbqrHM6H6B+OqJqpNMRhDW+NN8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eF9vWBQOTsLaI98SkOFbDPLBCg0UeXwDYQtX2xXPVMjSw7fDOVCFDlZLerJbJa0cy
	 lGtQyb3f5TLty1OedShYXRNA8funwzJBDtGPsgyxkQabYpui44viFT3Rr4HXMLDZzY
	 GI4fFtLs7veDDElzeNKThYbyVoSHGjys7tN3FW97xWC0b+jkfTitKeKnBNMoelDyaZ
	 7UmOwhxiy5TIVMZ35N/g8h5TjwQ/ykMQnmE0CF/vTFRHZhrsZtQvRwoNg03bbXEmJE
	 9hTL+tis9vs+2CxCokXcsT9oRVAkG0k8KPGI3gZsKyan+8YUajKHlfiAJb6yd+3AVM
	 MM1nd3mfWPB+A==
Date: Mon, 16 Mar 2026 08:55:25 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 2/9] efi: Tag memblock reservations of boot services
 regions as RSRV_KERN
Message-ID: <abepXaPWWRdqBYFg@kernel.org>
References: <20260306155703.815272-12-ardb+git@google.com>
 <20260306155703.815272-14-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306155703.815272-14-ardb+git@google.com>

On Fri, Mar 06, 2026 at 04:57:06PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> By definition, EFI memory regions of type boot services code or data
> have no special significance to the firmware at runtime, only to the OS.
> In some cases, the firmware will allocate tables and other assets that
> are passed in memory in regions of this type, and leave it up to the OS
> to decide whether or not to treat the allocation as special, or simply
> consume the contents at boot and recycle the RAM for ordinary use. The
> reason for this approach is that it avoids needless memory reservations
> for assets that the OS knows nothing about, and therefore doesn't know
> how to free either.
> 
> This means that any memblock reservations covering such regions can be
> marked as MEMBLOCK_RSRV_KERN - this is a better match semantically, and
> is useful on x86 to distinguish true reservations from temporary
> reservations that are only needed to work around firmware bugs.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  drivers/firmware/efi/efi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index b2fb92a4bbd1..e4ab7481bbf6 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -600,7 +600,9 @@ void __init efi_mem_reserve(phys_addr_t addr, u64 size)
>  		return;
>  
>  	if (!memblock_is_region_reserved(addr, size))
> -		memblock_reserve(addr, size);
> +		memblock_reserve_kern(addr, size);
> +	else
> +		memblock_reserved_mark_kern(addr, size);
>  
>  	/*
>  	 * Some architectures (x86) reserve all boot services ranges
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 

-- 
Sincerely yours,
Mike.
