Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793415669;
	b=nqjezm6rtLFLcQ4i+Ijj35ohSai/5F0RafFknRvZMgoe/bPW+nmlkW6xQduXYNshdLoW
	 3K5C0boOTJKZq5uIfPnq1JhEEDRP91fQfBUWfz7Tjkr6YDm4USbZ5mtfqduBrQ32953eN
	 43O4HyU0IjzexKcSJaxYUCIftSmFEZOXb4G3jeshRCVArkUZjJNimK4ZTLqkhXFvN3zfo
	 8Xa/Q1izhy0EEQ3CaAerDD9lnnvk1iZmfZRouHRjO9ZyyUYb/crx4GQFcqlDBa1/hTaUD
	 GBZqHVKtp1z7THnb2bozgErdVJdyHMGyCRjIu4UBObbfNglWJOhzUn/oIfUr25629gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793415669;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BngSBXTp+deGkFdRSOmECpX1qa4udSKk9eVqZM6ckQs=;
	b=YSe2HFYYDU0qva1DgzWG2f2n4mytpx1Pn9jHjdsXrvvWnUdogd22BNaFy5vmHEmAxUSC
	 2elthGW2RPJeYkXuM+iW00Eltu3B29AnmdPafixIaD51pM7CAQuWK9uAHZz2DCQ2wK7qH
	 hWrokd/aYuTqpLiyFM7eMFvtz39p9pHtI9Fk8BQAyTIdi+VAHvH2kkTQJrwnY5tWXqSVj
	 OibyvbGofX2+i5xbtMynQfmxFw6ci4S1qSIkx7Ac7gx5zB0L/29LSZ1durE7Uatyq6blo
	 TKFGPmVJgDXeK9JuOrbvNsrwH4oNv21J5SJUAh1SjUKxwKbDd36SelDntatglUcIoyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K5tBDEg3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 65E29606A31A;
	Sat, 31 Oct 2026 03:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K5tBDEg3
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6155B1F000C1;
	Sat, 31 Oct 2026 03:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793415669;
	bh=BngSBXTp+deGkFdRSOmECpX1qa4udSKk9eVqZM6ckQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K5tBDEg3PiRlab478XW6PS7L4wUZFmiKjSTa5yM23K+XR5iNzDS+zBV06lnLbqf13
	 /zb5sNkIHZNfa+A1k0HIT7zUjUQyNYOgwmILdmgi2WdCepEhtM42cFKKwFcCYiDRdx
	 ZfI8NzwC11B98IA4FyOGG9xNK3fCIWXABm/XLw9QydHm1VTYfy8kjvHnpr2j32ymMt
	 6Hxhf20TsSWLlOD+MfUHJsW+ECBxBtcGz4UxKJ0JN/r23xwEnSikQYeroaJ0JtDYMz
	 dLdO38ky/dpx3/4bHDxzQwpDfU5uRZ8Jt9KDHEY4DG6t6r657KhyyqUjy6WEQ2Vxlm
	 rtmRfmMAHcgkQ==
Date: Sat, 31 Oct 2026 05:01:04 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Make hibernation work with lockdown
Message-ID: <auVZ8AvMXqqKXl7S@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <att9OPPi0sPqt_CW@kernel.org>
 <atux0EFb_euN6pM3@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atux0EFb_euN6pM3@kernel.org>

On Fri, Oct 23, 2026 at 10:13:20PM +0300, Jarkko Sakkinen wrote:
 > As the next step I'll expand the bootc OS installer that I did to have an
> option for hibernate so that it does partition layout and all the wiring
> required. I can then integrate that to my test environment and test it
> in a libvirtd VM.
> 
> It's not as tedious as it sounds :-)
> 
> There would be faster routes but this is the only one that is not a
> tower of cards. I'll just shovel it through.
> 
> I'd figure that it's also modelling quite well any possible production
> environment where this feature might be ever used (reproducible build,
> read-only rootfs, bootc container).
> 
> 1. https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/
> 2. https://github.com/puu-os/installer

My kernel test build is now generating installable bootc container, and
has hibernate working (not all changes have been pushed yet). Not being
completely ad-hoc environment allows effortless testing, which is
essential in order to get all of this eventually applied. 

The next step is to test with the patches applied but without secure
boot at first.

Br, Jarkko


