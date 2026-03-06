Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE12B37BE8A;
	Fri,  6 Mar 2026 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772812492; cv=none; b=j/kI4XoSIZU9QaTPROeTRPWFS6LKf8gDR19qmM78TTqlW2VtDi5nXHGJ2VT2QlqKnparQRgpYS3OuSobXCPdCEfvXBMjuKV5SNqSp+KAdFTy6SiVPqujAby0DpztPriDa2F+eiqQ3GOXvFK0IOspgRb+1YwhjJq27IcmVfwUdgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772812492; c=relaxed/simple;
	bh=b6Q2vfwCcs0E5l+Cn9299eegQd0q/hpFvgEzI2+Enlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Unnv0WjlGdzoCf6UMLsEMfSAb667p3h+zjZSjhzgW+zd3S9Qde7GbfzjCZXEKjUMzFWxWawPX/hQ3vK4bM45bVn/VFHh6hbH9tK5UtqMkZ/TP62HKishKBUbjrHwQxMkeTZDegaeBsYZR1lc1TIVMSXHFtafV1ocqgh0OnIrYcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4jy2GCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4jy2GCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40A3C4CEF7;
	Fri,  6 Mar 2026 15:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772812492;
	bh=b6Q2vfwCcs0E5l+Cn9299eegQd0q/hpFvgEzI2+Enlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p4jy2GChNGU3tNV8OYElXie3aNzB0SXD7lh9yXZvKz1zVKHOB/ZWGp67yIFiNq5mf
	 Fhce69xc6aXopB0jXkIAQbwBRa6F49TXpg6qSElR3asH5LWu83AgIOZq/hvqaULwCj
	 cZ+4oqg1GlBG/VhklOHArgoo+k0eGGzK8/Jl5b+s/ZbLNUDdXNCs4oFiUxekgTu9mS
	 aGMwLC12+GsaxeKj6VbFiUsT5i5QQ7paFf32c2u2V8bWKhy5pxy1Mg82t6aW4jxZkO
	 nF0jWTWWJiJ1H0ndGgHFrEcgvRhnpQ2v7XVCVLCVMZESVe5wkWQjaDZaDrFmHeiwTq
	 riKeL5Mi5/Mng==
Date: Fri, 6 Mar 2026 17:54:41 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@kernel.org>, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
Message-ID: <aar4wRh3TRm1m0HJ@kernel.org>
References: <20260225065555.2471844-1-rppt@kernel.org>
 <7e4f6a4b-fe41-482d-a4cd-5a059e1626e6@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e4f6a4b-fe41-482d-a4cd-5a059e1626e6@app.fastmail.com>

On Thu, Mar 05, 2026 at 12:11:12PM +0100, Ard Biesheuvel wrote:
> 
> On Wed, 25 Feb 2026, at 07:55, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > efi_free_boot_services() frees memory occupied by EFI_BOOT_SERVICES_CODE
> > and EFI_BOOT_SERVICES_DATA using memblock_free_late().
> >
> > There are two issue with that: memblock_free_late() should be used for
> > memory allocated with memblock_alloc() while the memory reserved with
> > memblock_reserve() should be freed with free_reserved_area().
> >
> > More acutely, with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
> > efi_free_boot_services() is called before deferred initialization of the
> > memory map is complete.
> >
> > Benjamin Herrenschmidt reports that this causes a leak of ~140MB of
> > RAM on EC2 t3a.nano instances which only have 512MB or RAM.
> >
> 
> Putting a fixes tag referencing a patch that dates back to 2011 doesn't
> seem that useful here. Is this really an issue that goes all the way
> back? Or did a later change trigger the actual leak?

You are right, the leak was triggered later by addition of deferred
initialization of struct pages which is about 4.2 time.

So fixes tag is wrong indeed, but all the currently maintained stable
versions are affected.

-- 
Sincerely yours,
Mike.
