Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27A9361DDA;
	Wed,  1 Apr 2026 14:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775055454; cv=none; b=no/kucL6ZYvq6+4/lnPMORM3Yt/DlqEFu/NjTn3Fk8Ul0xNGnZfFOjnGBUlMxPYXWWoNGHtCgObhdT7hEWoKUfnXeXmc9K07A9+Ib6zj+qu9yQqk5gOVFGpcx/a5o3mIjUY624zeQfCCX1SPYnpWs46l22E63sjhW61NUU9fOP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775055454; c=relaxed/simple;
	bh=1DyIYJ1sdNC60eVJ/Rp077SxEl9qMJG+7PY7c2EdCDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXOOxd67tubZE6l9XrDGI1XSZbEQJLXfbEieu0EZVND9eUf+vQsW5cYr38lHDTt+x13bbkZWo9b8YtXhSLWamP54N/MncJtFtfj+GtSzGYUgw6268wiTABfANii/pOpmmPcn0LQ6KEGv5CAZc9oq+XYo4TiR6Qh7RBNjXgwwjqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=wLLAR99I; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="wLLAR99I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yoxZjMIQWkHszT6eH0DvW0OHyw+941YlYbxkAMzoDZo=; b=wLLAR99ILbMz0l5IFZJr0nTR3z
	jqRg7yBgeHI+c7XUGNn5P4de5B0vvDMT9SrehkAnwiL/9Y2C+07tvPeYTlMAIRRtnBApANT24HAgv
	/U89DLUPF/Zo5HKjHDooze+DFhIbRwerPPvU6OaIbmL009k8DppYzUZtI26QG2dxLrj1Q0C+KimSx
	8ZsmbHouM7d6MTl89f5JJz3SigPHpxVS2XAK5dOoAOA/cmC8Mb2lBIpeDrTJS1whTu3KVs5XzB/f8
	V4OMdHa7ViJOvNrta/+3ubMn67DSyP6IEG8fesbtKsgJGvhYcqi47beKMr3lRXcQHOQa524SAJqZU
	drCIPj7Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7x0e-00344X-0N;
	Wed, 01 Apr 2026 14:57:31 +0000
Date: Wed, 1 Apr 2026 07:57:26 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, 
	Gregory Price <gourry@gourry.net>, Usama Arif <usamaarif642@gmail.com>, 
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH v2 3/5] x86/efi: Defer the call to efi_memattr_init()
Message-ID: <ac0yTFq1UaWD-WmQ@gmail.com>
References: <20260401122351.2058145-7-ardb+git@google.com>
 <20260401122351.2058145-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401122351.2058145-10-ardb+git@google.com>
X-Debian-User: leitao

On Wed, Apr 01, 2026 at 02:23:55PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> efi_memattr_init() should call efi_mem_reserve() rather than
> memblock_reserve() to preserve the memory contents of the region when
> the EFI memory attributes table is loaded by the firmware.
> 
> However, efi_mem_reserve() can only be called later during the boot on
> x86, due to the fact that it may need to memblock_alloc() memory for the
> EFI memory map.
> 
> So move the call to efi_memattr_init() to a later stage when building
> for x86_64.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Breno Leitao <leitao@debian.org>
