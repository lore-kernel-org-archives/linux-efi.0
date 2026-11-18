Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020275;
	b=XhIYQA2r04zO9y4UKpR4X/oBdzwQyTa16enbiU2DII9QgDjd0mJciQHDu6TnhjjdTPAv
	 0alsxiCrkJmhIKuxB0hlH0lESejPfgNhhUnre1tu+A7WGgCB3vMrDEuanzo9ZLdQ4YeWT
	 7pcMUGvzpmyMwlBrJ6gfmwM2xYGtULjaYYEniQUe8gl7P8CYGoWb+hwju9eVRqAwFaL/o
	 wW+/exoQwq5pVWbxjYvNZypKWmzSLydHt3iUz2Y68vHWcrtK12JuWh8KboX1V3NFN7UI0
	 U3W/Hvr4wK2SOPB3GWONdL7u7mzMwN/lFEJA6yY3nCJpSZ8tuMWwzZknQovrbi29JvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020275;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=O+0ny3jqnqa+BeZBemKleOcgWcJyFiXPeguzG6RKuVs=;
	b=JSDIGEfMfzctED4h8kk+yHPzHD0WzbJQVBRkxoEgFRar4tvnoA8mLhd2t/zEZMQuUSwl
	 WiWZKjrcv9DnAZhRNd1AGkJHLyK5uOJaTBu6ytp+QEE11tfEVG0tm3EM8f8V4p2q/Da57
	 rPvlyxqR4nxSrhURCWQh6DwlbFBzQNPGo4I2NLBqp2CE5zEpQjdPe5vVfvn4VL4TIdWrE
	 gnEo0FyiLBdcso5/H76/ea8Xe+QUi2OKoxUsmyTV8z04hWGbbncmNSthH1QB+aWnhUTc3
	 glip29zzrupMRvtYaX8AXHFgahnzE2Aqp52BvtcqqWyHyXJLPmF4SbIfOU8OdXuLnVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZGSMWI3z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7503E606A332;
	Wed, 18 Nov 2026 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZGSMWI3z
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B35A51F000C5;
	Wed, 18 Nov 2026 16:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795020275;
	bh=O+0ny3jqnqa+BeZBemKleOcgWcJyFiXPeguzG6RKuVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZGSMWI3zSQIfnpevzydVCpG4zzHuDI7pL5ljldmeHsNQ4YSJ6ohcFJ/+6eQzdQwQF
	 bvF0k1Mbux6ZtB9nxybbpATxbLkTalPMcJxA4cpNbqSdGG8RISe0tsclmE9gxe/EFf
	 CrOPJ7kVvKtaRqkWc9bY+1fdphmKqjm5/nd/2kDYw0vok+Da/stG+1VeIsF73QUWJw
	 ZGT2jvKfH1b1w4w112W/Pm9i7SnFqSs1NNJdCX8xTPW2GjjwzABHkJBsU0EX+AP/gd
	 PmUftk5x2ywGWDPjxIm+t/pWSpD8DR7rFWqiFd0BfrNRUcs96IZMRXM0lQsxWbYzq3
	 hZZ7y9hWyo7kg==
Date: Wed, 18 Nov 2026 18:44:31 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <av3V7zfq5WhR9d44@kernel.org>
References: <20261008132532.1155166-2-matthewg@nvidia.com>
 <435907614242e82ecde1767a967a3110fca6fb37.camel@HansenPartnership.com>
 <asqthz69ohnMVCye@srcf.ucam.org>
 <059384e86fd256618498b9a7214b6421d38fdf1f.camel@HansenPartnership.com>
 <astjpI65VOyU8xvI@srcf.ucam.org>
 <f002fc613bf0bdcf895e5be02dfd2524b7608787.camel@HansenPartnership.com>
 <asty4acE2B94t5q6@srcf.ucam.org>
 <avnMl7fD156F1fx4@kernel.org>
 <ba43d150febc8a85247d6c54f57db0835cb8f5de.camel@HansenPartnership.com>
 <av3SvHN3UCzzvyY9@kernel.org>
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
In-Reply-To: <av3SvHN3UCzzvyY9@kernel.org>

On Wed, Nov 18, 2026 at 06:30:56PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 11:06:55AM -0500, James Bottomley wrote:
> > The better mechanisms to address this are probably:
> > 
> >    1. Detect that PCR5 has been disrupted (get the kernel to store the
> >       on-boot value and check they match) and if so refuse signed
> >       suspend to disk with a message (this is easy).
> >    2. Capture the additional writes to PCR5 and store them as part of
> >       the attestation so the resuming system can prove the current boot
> >       value of PCR5 matches the attested one when the additional
> >       extends are replayed (this is a bit more complex).
> 
> (2) is a great suggestion IMHO; did not cross my mind.
> 
> That approach would also help to debug any possible issues.
> 
> I think it also might make sense to drift away from kernel config flag
> to kernel-command line parameter when it comes to pre-existing integrity
> code. It's time consuming to test and improve right now.

The problem with it is probably the indefinite growth. I.e. despite the
log won't likely be that large it has no theoretically maximum  number
of entries.

Could the feature require the RW-use of ESP for state storage? A bit
unorthodox but it would resolve that issue. Perhaps, there are other
solutions too (and I did not think about this too long).

Br, Jarkko
