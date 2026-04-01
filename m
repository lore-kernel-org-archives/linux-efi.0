Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F573D6489;
	Wed,  1 Apr 2026 12:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775047570; cv=none; b=M7+HoVEDfJdvQfKc2jKsgr9eaxhN5a5/LjKU4BhrzqX8/mXIgpJjNZr4mhjGw70wMnsPAa0G8cy2jKa70jCCybqQS2MbhfrSOvfmuTGQ/xu9ABXoovBKB/Ung4+mCP7GLYwVKuH2GWaKgJgkL+GovJreSnv5MTJhq0GwQjwTQq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775047570; c=relaxed/simple;
	bh=oHTRxYd165ZsougDIXnpj45WolMG9KACLQ4wxkjzjnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jvOPHkkfzXRwmefw4mriSwZxTERY63enBfSOhilnBiIcaBGqm0f6k0JmXXwz8pbOvYgHAM7kJimgdEQ97ct2ZHgiqnxRr/Y6TBDpBa9Cr475USiajcQ1drZo+TYvS21k5AzPlSnNCQ0SE/kpGKyQvsqIifQ211/3jTnXMOpZFRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Sr5664zH; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Sr5664zH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IIk8KgWJaWwOCfRfx9h0Xjq8K9rYj6OyC4svMBvPEtE=; b=Sr5664zHYYJmj8GUgVcwuPhOs+
	PIzE+724YDLH5Eufm6uORltYl4q7FnZJnJkyd8qQNe/MTvsfE4bE5AFUGfcswDf/EYtEtxtxEbyh1
	JqCfz0vvBkRoBCQwRJsDRUt0o2knsenKngoa6+tfDr+zD4BAbmDwXEYYZqiH8fcaDoJpa0RMDEegi
	98GMgQmH/bmyvNFQY5Aq1g13qexnDfi0wmllljuJhwaVcmYPDBYvaQQwljRM7I6dmORnaWyVa4/3l
	cTwm/w03zw6pcBYMaEOZfX/jGVvYJnzAvfrWRsLrqKcRN94NqXR7C3ojGjJuMLEAiknwwiozqfjP2
	Z/kOZvqg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7uxN-002zmj-2j;
	Wed, 01 Apr 2026 12:46:00 +0000
Date: Wed, 1 Apr 2026 05:45:54 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>, Dave Young <dyoung@redhat.com>, 
	Gregory Price <gourry@gourry.net>, Usama Arif <usamaarif642@gmail.com>, 
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH v2 1/5] efi/memattr: Fix thinko in table size sanity check
Message-ID: <ac0SynMEZTkodole@gmail.com>
References: <20260401122351.2058145-7-ardb+git@google.com>
 <20260401122351.2058145-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401122351.2058145-8-ardb+git@google.com>
X-Debian-User: leitao

On Wed, Apr 01, 2026 at 02:23:53PM +0200, Ard Biesheuvel wrote:
> +	if (tbl->desc_size < sizeof(efi_memory_desc_t) ||
> +	    tbl->desc_size > efi.memmap.desc_size) {
> +		pr_warn("Unexpected EFI Memory Attributes descriptor size %d (expected: %ld)\n",
> +			tbl->desc_size, efi.memmap.desc_size);

Should tbl->desc_size be printed as %u and %lu?  tbl->desc_size is u32
and.  The pr_warn a few lines below already uses %u for the same field:

>  		pr_warn(FW_BUG "Corrupted EFI Memory Attributes Table detected! (version == %u, desc_size == %u, num_entries == %u)\n",
>  			tbl->version, tbl->desc_size, tbl->num_entries);
