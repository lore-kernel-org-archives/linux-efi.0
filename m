Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020337;
	b=oZD0qy26zJE67+XeZ4zQZShlTY0AoB/fLsLimLUhgsm3CnSDM9gGDjGWEVGbv5HH8e4M
	 Da5lVHmCuCKOayY1WmRgyzFPAYtgzdASko1DCdbAqaIxZDMFYpN8QTadNRhJKaIit9NOj
	 CFrBOKTkT91VWpPMyvRJ0BfO2p6/gUPRAdTk90iXnrOFmqOczz6Bc1bbhQm2uSaXkik/k
	 dXKq0SS1HM+/+SLZW+zX9L/ZaiTikJ+n4W8pLpA/CYVyYB4MwK/e0I2Gw8Mmnb9pgGv1h
	 D10pFxnlhb/iHAFwhfHoahMLIe3tltfL6jJHvmpK9X1NHqFEBTWWn8+8MS5IWBxLrVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020337;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4+V7ZxaI/k6si/vFnT5MgrgbAfT4gJr2UlOitiWvUG0=;
	b=Nu7d3j3ynyKcHTaE/+M4Iv/m6kBPmscxFpXScw2gLEnb2psgjhnbSZpsxnoxudsRHtwM
	 xy1OZyrTO2FaoknHDtpGm4IqT2baJ+AMZr8wZph4OwGXiOISOvwQcwOMXKkOpowZvCRQj
	 le9hYRS+R0Jmbaa0hYw8Nf8tCYPA+0NNnDlvy0tZ32IbS6lSe4khyAcULcCXjW1iid4L9
	 9yNN3jG1Y4TrbILZY5yORj5f1hxuI3ESTGM0J3jCu/SomCxPK8SKLz/f6ntzqXjqweQEl
	 Bxw2LZw500KsGW+A2Ry+poUML6EJjVPh3V6ATyl119TI7Y9/N17G8k0VaI+zh8CTrpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lo9mrKcJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9D5EC606A32F;
	Wed, 18 Nov 2026 16:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lo9mrKcJ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ED4FB1F000C5;
	Wed, 18 Nov 2026 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795020337;
	bh=4+V7ZxaI/k6si/vFnT5MgrgbAfT4gJr2UlOitiWvUG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lo9mrKcJqP8pzESYtspzXrSzQyrlIJmps/NWp/4GbNsiWBsS+vZoBxqJw0BISgCMk
	 mrJCGOZQe3+Om9bUi1S5LfJB+45tLjdZLyNFShQ2pDESi2oJXHFUcncRaqjEKne3yQ
	 bqsxwvro9jFZm734jV42O4FCwmKTp9CkUnYe60ovOurB/nkL4cN9Ii73FWK6Q88yLg
	 3WToPTOUTcBGY/RtyD22KIo5zThMqEEgX/eQcWyZg812Jc3TDyJCnO/6L89zXJHCnO
	 ExgPKvw0iiIa1Xegsx1qvkz3Twgfy5Q6dD+VPhrC5co7pt4hwcqoVQSdXRWDWnC0YP
	 AcpO+OxzLbgHg==
Date: Wed, 18 Nov 2026 18:45:33 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <av3WLT51SpyCmbG2@kernel.org>
References: <435907614242e82ecde1767a967a3110fca6fb37.camel@HansenPartnership.com>
 <asqthz69ohnMVCye@srcf.ucam.org>
 <059384e86fd256618498b9a7214b6421d38fdf1f.camel@HansenPartnership.com>
 <astjpI65VOyU8xvI@srcf.ucam.org>
 <f002fc613bf0bdcf895e5be02dfd2524b7608787.camel@HansenPartnership.com>
 <asty4acE2B94t5q6@srcf.ucam.org>
 <avnMl7fD156F1fx4@kernel.org>
 <ba43d150febc8a85247d6c54f57db0835cb8f5de.camel@HansenPartnership.com>
 <av3SvHN3UCzzvyY9@kernel.org>
 <av3V7zfq5WhR9d44@kernel.org>
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
In-Reply-To: <av3V7zfq5WhR9d44@kernel.org>

On Wed, Nov 18, 2026 at 06:44:35PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 06:30:56PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 18, 2026 at 11:06:55AM -0500, James Bottomley wrote:
> > > The better mechanisms to address this are probably:
> > > 
> > >    1. Detect that PCR5 has been disrupted (get the kernel to store the
> > >       on-boot value and check they match) and if so refuse signed
> > >       suspend to disk with a message (this is easy).
> > >    2. Capture the additional writes to PCR5 and store them as part of
> > >       the attestation so the resuming system can prove the current boot
> > >       value of PCR5 matches the attested one when the additional
> > >       extends are replayed (this is a bit more complex).
> > 
> > (2) is a great suggestion IMHO; did not cross my mind.
> > 
> > That approach would also help to debug any possible issues.
> > 
> > I think it also might make sense to drift away from kernel config flag
> > to kernel-command line parameter when it comes to pre-existing integrity
> > code. It's time consuming to test and improve right now.
> 
> The problem with it is probably the indefinite growth. I.e. despite the
> log won't likely be that large it has no theoretically maximum  number
                                           theoretical

Br, Jarkko
