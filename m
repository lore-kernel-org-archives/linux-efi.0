Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48DB2517AF;
	Wed,  1 Apr 2026 14:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775054955; cv=none; b=sEpD9jku8As7+QdZXd/KEmTmNhMjTCF42Yf7m5UmeTcnd9Rj/ay0EI6LpjRWIU57vavFz90lvRw8dSijW+91xt/eSfWuY5lx2Jfwap69gJ3MFstULRfjTxxnpjViSEL8VgusW3kxpLuuiy9QbLs9HI5119/ptV3YyULXAMCw+eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775054955; c=relaxed/simple;
	bh=vxJQgtv8nuFMIja/Mlywj1YN00jxTLSMPzy0XCtMzYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ls0/0qlcsaGPpvbyP684byuHY224hWedMzVh+se4qJsV/cPB6QMw4rX9vo2UP8BdUbtnGfiFQhnzChEBdBH9BU2qhek/iKPv/Egp/EfbjBdBKx1GUz9LDTME8uDI3RaAGJnsHLe93O0hz5aF9n3UydF/QYXsihC1NA5BLpZJhV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=A1jJUY9R; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="A1jJUY9R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5/z96B2eZHQhUvJrL9JSTvNjMgBRLWl0q47wPzMerAY=; b=A1jJUY9R4smMwA1/nmsmwTD72B
	HAnt+JNsPsBVtWhszVOK6GhQGZl6kRcTgbU0PHw7eK+Nr1PCt1C62jURmzxha0Q36rfGjCeJ5TXcK
	pnGtq2sP4k+jEeXEgUxkQe2hK6J7X3aT9v15IHBR+6hD+w48NWMZulQFiWc+9QQv9x2ktXHAEro/d
	bmD+oibIOvmzIOU1ai5owOniosKXwaY6fM/DUSFU0LJdCDsOSCfOVsLHtw6/0npv4WS3g1LKLwRPZ
	7u4DOTrwmSDu7b0Zz5yG40Qi1+248E/LJXYNU9oO2L0pahcc8BBKvGl1aDCUw4w5NgSbfuL5T8KLv
	aqbAnTIQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7wsZ-0033tK-2u;
	Wed, 01 Apr 2026 14:49:10 +0000
Date: Wed, 1 Apr 2026 07:49:06 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, 
	Gregory Price <gourry@gourry.net>, Usama Arif <usamaarif642@gmail.com>, 
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH v2 2/5] x86/efi: Gather initial memory reservation and
 table handling logic
Message-ID: <ac0wIbJiTvHigfaU@gmail.com>
References: <20260401122351.2058145-7-ardb+git@google.com>
 <20260401122351.2058145-9-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401122351.2058145-9-ardb+git@google.com>
X-Debian-User: leitao

On Wed, Apr 01, 2026 at 02:23:54PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Move the back-to-back calls to various EFI routines related to
> processing of firmware tables and reserving the associated memory into a
> helper function. This is tidier, and will avoid the need to add yet
> another function call there in a subsequent patch.
> 
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Breno Leitao <leitao@debian.org>

> +void efi_init_reservations(void);

Do you neeed __init here, as the declaration below? I know that "extern" is not
necessary, but isn't __init?

  extern int __init efi_memmap_alloc(unsigned int num_entries,
                                     struct efi_memory_map_data *data);

  extern int __init efi_memmap_install(struct efi_memory_map_data *data);
  extern int __init efi_memmap_split_count(efi_memory_desc_t *md,

