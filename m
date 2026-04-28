Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA16E258CCC;
	Tue, 28 Apr 2026 08:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777364512; cv=none; b=hZ1ey4L9QZbFpT6LPbNuh0No9ToZ9/CqFTrMBYtRbW9swadXLlxQlTrU73Zrd3heBCEi2bgB4bYDWE9osl5j54CUUoek28AVOHhaOjwvs8eGHMc9Px0aqDAnPwNdU8GhgM0x1Dfd3AXx49q3dSQjg286rDx34PlKXOxk+QWmnIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777364512; c=relaxed/simple;
	bh=s1VCxGduYh3gB/P/eYW1On8ykUjfqkNGh7wNxBLABrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aGF/oQAn3uwpluTjc5q+LyWwiRbyw42mED4O1mXOKwScUSrPfZ3oJrwyajp+hbbgMs58G2pLIkZSXASlWyxKUt3eVOmb8kp1fz0Su6UI/JKhAbQjf+zJvmXV1/4V/zEQOkZSmlVGDj+iDU4DFXg2pKSJFP0sYW+AWSJ0dDp1SO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T6Zq6xJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T6Zq6xJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFB4C2BCAF;
	Tue, 28 Apr 2026 08:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777364512;
	bh=s1VCxGduYh3gB/P/eYW1On8ykUjfqkNGh7wNxBLABrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T6Zq6xJ2hA6IfeGwl3Y43UDI/oBVPCclDckmtuktKffN/BNTIJbcnLxZpmQ+JlFMV
	 eK93fOQblaQICTjMCYMXByYsIzPq76pwOqRZsAnzgtDoahQ/P+Gt8jbusmKaLxvMCr
	 1jEsmdp46/d7kKWxPnuQjmvNH3ZibWM4MAb+bKUkrhqm4FyB7ZBsL7+xGzncT3AaLd
	 4BQKbMkFpXXx2g5yUFTQNFYTAsS+4cyllyH9m6naot0ISmCCoodLz+DywdX3bbfZ9s
	 gB75EWDcuzrMDdmiAkEM+Zu9V+stsKrcy1sJZ+Y0xDr6s5KdUXOFwuHmktgmjfOT3B
	 Rn5gw+iboaMJw==
Date: Tue, 28 Apr 2026 10:21:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v3 02/17] x86/efi: Drop redundant EFI_PARAVIRT check
Message-ID: <afBuGnFnAAYYCbSf@kernel.org>
References: <20260423152024.1098465-19-ardb+git@google.com>
 <20260423152024.1098465-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423152024.1098465-21-ardb+git@google.com>

On Thu, Apr 23, 2026 at 05:20:27PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> efi_memblock_x86_reserve_range() exits early if EFI_PARAVIRT is set, so
> there is no point in checking it a second time further down.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/x86/platform/efi/efi.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 0c39adb96b91..1b7a0cd54d08 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -211,11 +211,9 @@ int __init efi_memblock_x86_reserve_range(void)
>  	data.desc_size		= e->efi_memdesc_size;
>  	data.desc_version	= e->efi_memdesc_version;
>  
> -	if (!efi_enabled(EFI_PARAVIRT)) {
> -		rv = efi_memmap_init_early(&data);
> -		if (rv)
> -			return rv;
> -	}
> +	rv = efi_memmap_init_early(&data);
> +	if (rv)
> +		return rv;
>  
>  	if (add_efi_memmap || do_efi_soft_reserve())
>  		do_add_efi_memmap();
> -- 
> 2.54.0.rc2.544.gc7ae2d5bb8-goog
> 

-- 
Sincerely yours,
Mike.
