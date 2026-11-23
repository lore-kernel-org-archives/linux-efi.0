Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460024;
	b=upfkhXBFyOPEByaIh6CmDzAXu4+l+hHIKjnc+eZyY2AZQvevsp2o0Fqakqf5CMhKgxn3
	 GFwMcFnDVhgMUdEf7s1yvJVSChsE0MQ6YBDtU7ML3CR4lsLOGMSwiSoOrW7qE6u+ftPKA
	 UVt8k1Sjr7IjCmOkalEOrwmv0LZjHxKe+WHza8retaa87OrumpSslfqfGOBxJxh9e2CGf
	 YC8aCCSm0WQmuzf8tgXYd3O2oMDSSE1sEprYr7gXPNbJAWuC4kkeY4UzUBTVvKX9RyGgW
	 VtlY3FRArgOIYJpXrH3n2n65BjDFAsgzPluw+uV+aij2w3kYZuDgeJS8U89jgHo/F/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460024;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WdqrFA4uMZhpfSRMkoHMOlyWPOST+lnV86bO3jFjXcQ=;
	b=Nzcrlcn0WlMS/24KGHLGupSL1XizCWMF8bXHzaCNew+iyNYDFoA+fCa7t5K+6QaXecZO
	 JA62CPn8py8A5/Kw01Ay+Y5lwjSTNGeBg/eGagzBr+hlNO/dy+7bbt6dpzrsVtBLD0deD
	 JV/gLoDveGtq2XlKLEvubgb0zsRVD/qO6zuIgBpO6B+zUXMf2Xra5IBd04Jp+HNNrdSUP
	 u0pg3IHUcEE4V6bLqn0tBjlMgBH/WhHhHd2b7r4tg6W5YdqByjI0Xx5EIMYgBYN3p+jYn
	 E1Pd/bLknaUOp3c9GleSDm8JEu8R7sZv6QXCsV0lBtJvENNejOKiMmBNTchiNf34XqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H0jZDblr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 53F0F60A260D;
	Mon, 23 Nov 2026 18:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H0jZDblr
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9B2921F00ADF;
	Mon, 23 Nov 2026 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460024;
	bh=WdqrFA4uMZhpfSRMkoHMOlyWPOST+lnV86bO3jFjXcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H0jZDblrgj/8Uj0P38G4u0vgtl/UQEubq9xMla+QYomELeA7br61lMP0RsFSj3LEm
	 lwMNRaW2Y7006f/ZnPdCOb7G+6jRfn1P/JAdNPLpGNMyLDBx5h43t8OL1aFq23Wu7T
	 wZWdbkzHKkPTbzymtBxjIDfKS0XW7zHzhqdhnAjpiCXzGAVtsI0hzSkNNCvTE/cCe/
	 enlaqm7LBSbN61CGFmCjdOF85zwpPHiF8n0argJ+IcqAtEtAS+kInKlcX6ijm90a9d
	 I/AU9opWj9KmQjoCl1rD/+KXjh+DBrc0+SE0kZBh8hmuYjKD0vuQyHIBNOC1jnVNUQ
	 R4KJ602A+3kuw==
Date: Mon, 23 Nov 2026 20:53:40 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <awSLtAUT8KBcKvQI@kernel.org>
References: <asqthz69ohnMVCye@srcf.ucam.org>
 <059384e86fd256618498b9a7214b6421d38fdf1f.camel@HansenPartnership.com>
 <astjpI65VOyU8xvI@srcf.ucam.org>
 <f002fc613bf0bdcf895e5be02dfd2524b7608787.camel@HansenPartnership.com>
 <asty4acE2B94t5q6@srcf.ucam.org>
 <avnMl7fD156F1fx4@kernel.org>
 <ba43d150febc8a85247d6c54f57db0835cb8f5de.camel@HansenPartnership.com>
 <av3SvHN3UCzzvyY9@kernel.org>
 <av3V7zfq5WhR9d44@kernel.org>
 <av3WLT51SpyCmbG2@kernel.org>
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
In-Reply-To: <av3WLT51SpyCmbG2@kernel.org>

On Wed, Nov 18, 2026 at 06:45:33PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 06:44:35PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 18, 2026 at 06:30:56PM +0200, Jarkko Sakkinen wrote:
> > > On Wed, Nov 18, 2026 at 11:06:55AM -0500, James Bottomley wrote:
> > > > The better mechanisms to address this are probably:
> > > > 
> > > >    1. Detect that PCR5 has been disrupted (get the kernel to store the
> > > >       on-boot value and check they match) and if so refuse signed
> > > >       suspend to disk with a message (this is easy).
> > > >    2. Capture the additional writes to PCR5 and store them as part of
> > > >       the attestation so the resuming system can prove the current boot
> > > >       value of PCR5 matches the attested one when the additional
> > > >       extends are replayed (this is a bit more complex).
> > > 
> > > (2) is a great suggestion IMHO; did not cross my mind.
> > > 
> > > That approach would also help to debug any possible issues.
> > > 
> > > I think it also might make sense to drift away from kernel config flag
> > > to kernel-command line parameter when it comes to pre-existing integrity
> > > code. It's time consuming to test and improve right now.
> > 
> > The problem with it is probably the indefinite growth. I.e. despite the
> > log won't likely be that large it has no theoretically maximum  number
>                                            theoretical

Hey, what if this resolved with a combination of your suggestions:

1. Fixed amount of memory for storing event long entries. It does not
   have to be huge in order to be unlikely to end up.
2. However, if this does happen, kernel marks PCR5 as "distrupted",
   and semantics go according to your first proposal.

I think this would be pretty good and totally doable approach.

What do you think?

Br, Jarkko


