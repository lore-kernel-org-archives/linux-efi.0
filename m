Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68F83176EE;
	Wed,  1 Apr 2026 14:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775054113; cv=none; b=NoV7CSuY+kPdsQSpGA7TRY7tvP6MZOIV4HcNoQKsvuWMfwgjBHjGkQa1Cj1E5V36y4BgzMCmfv9rmC18fluGSsxwYRip7lIoI76ZG/HJPw6B9QUla+6hViLbxq8mbkXKC6Fw32wCB6On6mVyfHHRcME/u78LsjU274saZYXGjDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775054113; c=relaxed/simple;
	bh=snHcW5q0pmyzez0BMGcVwHnuUY2dugCo0VKxeFlQaE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RR/qlXxPEsD5V94KEqXLf9fR8IUQfkFNGi3dQywtEdBUfEJXM3CjqkhsPXlLgRPM95jvIzet0tmB9OZv5Dvv7fS4cR6oyuOi8MiS8XLIA68NK9ZnWhNeti1ZsFF2FgpJFWxX80BUtiK8kw5ZeeeWQDyXTGz3T8e9fwhRCF2UoZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=lA4TfXun; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="lA4TfXun"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Lx4y61s5G0gu5xutUJPNdblgqDAhWb/FUK34GrLD7F0=; b=lA4TfXunn1uCZZQnl/AuomfgI8
	CfWH8F9T2dgFQXB5IBdVnix5jyT08DiuO5KZAq6Cb97iteFLiQkbV+KiRAhGMJmlue+M+EAt0p1XH
	Jq60/kTcSePz5U/EiJU9j0045Csp9ouc7onQ6Han6Roib2jFNBiXco031ZOFH0NeKKcVOfODzPUrA
	pYyjWAbrAKSy3J6E8pjIAhUs8zV1RtFyGh1jIvykgyfTnGP3yYDubuD9zcxPYPMTNLgjCHMnSgzgb
	urSMPaYoh4ZjV5KQt8M0l3F+vjxJSes+5uqfUrpj0d+NA30XPzfqzyzm6AsBmbZjhZ78SRgvfQZYz
	bh6zBq7Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7wf0-0033OF-2Z;
	Wed, 01 Apr 2026 14:35:09 +0000
Date: Wed, 1 Apr 2026 07:35:04 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Dave Young <dyoung@redhat.com>, 
	Gregory Price <gourry@gourry.net>, Usama Arif <usamaarif642@gmail.com>, 
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH v2 1/5] efi/memattr: Fix thinko in table size sanity check
Message-ID: <ac0tBmNkY3UMSsYa@gmail.com>
References: <20260401122351.2058145-7-ardb+git@google.com>
 <20260401122351.2058145-8-ardb+git@google.com>
 <ac0SynMEZTkodole@gmail.com>
 <eb368b0d-4acc-4dc6-a86b-7a1a81762960@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb368b0d-4acc-4dc6-a86b-7a1a81762960@app.fastmail.com>
X-Debian-User: leitao

On Wed, Apr 01, 2026 at 04:31:27PM +0200, Ard Biesheuvel wrote:
> 
> On Wed, 1 Apr 2026, at 14:45, Breno Leitao wrote:
> > On Wed, Apr 01, 2026 at 02:23:53PM +0200, Ard Biesheuvel wrote:
> >> +	if (tbl->desc_size < sizeof(efi_memory_desc_t) ||
> >> +	    tbl->desc_size > efi.memmap.desc_size) {
> >> +		pr_warn("Unexpected EFI Memory Attributes descriptor size %d (expected: %ld)\n",
> >> +			tbl->desc_size, efi.memmap.desc_size);
> >
> > Should tbl->desc_size be printed as %u and %lu?  tbl->desc_size is u32
> > and.  The pr_warn a few lines below already uses %u for the same field:
> >
> 
> Yes, good point - will fix.

Thanks. With the fix, please add:

Reviewed-by: Breno Leitao <leitao@debian.org>
