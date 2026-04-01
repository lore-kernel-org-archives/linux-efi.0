Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFE43DEFE0;
	Wed,  1 Apr 2026 17:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775065200; cv=none; b=BTqwr3qbRbWB+GLR59UwzQBDz/mBM/oShaiF+3mLzjElOPQMciufxE1WtiV0mNYoQgvyZJnfIkYDyiJ3f/ijZBvev2Xv7nD9Sqr0Akkcwv2jOyAeAm/IOZC1CxZEaGfmJySvgfzd9+1VW47kjHMQ5oygY2TcxPjTIzbeBoslzos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775065200; c=relaxed/simple;
	bh=7AtwhuE3nrmLmz5C4zIqB+DaIRnI+ttS14J88JDk388=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gf2ia/FeygYWgN/R4gSxGaBf9erwJVM0ErqiWX7FNX27vmVuquY8Ct7ymFqMlJEREnqX9sTmepAxz2VBp/8AoU7htbssOeiIDWbt751LvEUyOwFQw77NxbnjR0z9z+6ok7Sb7QGld3dYjiWP2zGMpeRnPuEsoPRPVikdyhEPkWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=vGlNLhUa; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="vGlNLhUa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z0FZv4RNo4WhV6xRQYmIBIFoZ7LX5v1lvXax40XqC2g=; b=vGlNLhUaLvFsVvl0ElFCpca1/0
	1Wh/FWKu7rfjtA3E+jHmA3zFi3taLD0hbNLHFBsgtn5dO/vQw16/qtLkVx4yXg7JsV80RPs8Ncb2k
	DIlKWiwsw4imBln1XWPN++L113whzXnADoco7cn23SDIsTOCnXX8kdxrXBWJ7u3cmKHO3PXgm3YyE
	7u958vABS2oXrnI8eBK8gTuV85L8j0U4iqjsGoWNHujLld0aE5I0OOI7Mc8dIXY5kbH/AJmfSrCgs
	RHGeHLSS4NSevcmfH/x6+up+LzKXBsta6qX+xpc6WKMCzpsyQZOR5h8Xh3OQuR59QSw9vFouK3/87
	oPkT/MwQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7zXp-0039k4-1j;
	Wed, 01 Apr 2026 17:39:56 +0000
Date: Wed, 1 Apr 2026 10:39:50 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, 
	Gregory Price <gourry@gourry.net>, Usama Arif <usamaarif642@gmail.com>, 
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH v2 4/5] efi: Use efi_mem_reserve() to reserve the memory
 attribute table
Message-ID: <ac1YPh9xuRyMHVX3@gmail.com>
References: <20260401122351.2058145-7-ardb+git@google.com>
 <20260401122351.2058145-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401122351.2058145-11-ardb+git@google.com>
X-Debian-User: leitao

On Wed, Apr 01, 2026 at 02:23:56PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Use efi_mem_reserve() rather than memblock_reserve() to reserve the EFI
> memory attributes table. This is needed on x86, where memblock_reserve()
> is not sufficient for assets that may be placed in EFI boot services
> data memory.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Breno Leitao <leitao@debian.org>

> ---
>  drivers/firmware/efi/memattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
> index b83f1c5a9164..785b7fc687fe 100644
> --- a/drivers/firmware/efi/memattr.c
> +++ b/drivers/firmware/efi/memattr.c
> @@ -75,7 +75,7 @@ void __init efi_memattr_init(void)
>  	}
>  
>  	tbl_size = sizeof(*tbl) + tbl->num_entries * tbl->desc_size;
> -	memblock_reserve(efi_mem_attr_table, tbl_size);

nit: memblock_reserve seems to be the only memblock usage in the file,
so after this patch, the #include <linux/memblock.h> becomes dead.
