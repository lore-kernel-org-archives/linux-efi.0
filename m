Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56CC372B27;
	Sat, 10 Oct 2026 21:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791668178; cv=none; b=K61HMH5hOpsHX4ROYdJ33sPM9Bu+EcbzqITPlRfgyj2n0RkennWqMxr7Dn/jeDS/+t3/X3vY4HEjkI6dAe9sqEo8sjgQdH2MSDmTbZ4It2s8q/Qu7klShp6LkqshzB/Cq+mDR58liOZGUach/wz75aSBAbh0q6VwyKHjlN4DTd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791668178; c=relaxed/simple;
	bh=fDaFS6nVKmnDlg8OLCt96D6o4JO9ucFFTf4kBjRgDMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uKP53bWTG3lZmFbyBIdIFOMO9RvmaCMiet5qt0FwsWsgcAWwrxZokj+EcgHi12zddQT/MKa620FgsGE11F56GwfGz886PzcgpIPWaDhqQxTHvFsdsb82XUa/2DIX7xCb0Uvtwx9ZPJ+gN3gpE8PrqIeviBX2/4PKgq6/HWM9A44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fxohZCqQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fxohZCqQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 938431F000FF;
	Sat, 10 Oct 2026 21:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791668177;
	bh=RCIuIi8fcVbobyEow1QyEXCioARiSW41Lz0eibVslYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fxohZCqQSBD/LH4jFbb8JaktV5EBkW6PJ9L5AuAiptrWl657kEJwTSZINNiqm9rux
	 Bu5tQUYJHUzyw/9PU0JO8halfKzNlLyNNR9Lnx/wrndbeEaUzTLO/10HoHj7mYcGZI
	 1osYaPV5ckAKBeImEwmlYhJhgwVluBBcmL94DyZy/r00c6cbAttVfAjRdvVoJt8/+h
	 02UNxq0a8E9YxkwQNRCd1MUTbAJaJZbt0YuzFbCJwk3E63GEuJIhIDA/H9PnHCbMd+
	 rAztJdkVXieNSBE6vwbDN5k6MqUkKnX1TrxSRoqEtyzgBohZwmPo37Rj3LxDgpQIUA
	 L9QZttXlxegwg==
Date: Sun, 11 Oct 2026 00:36:13 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <asqvzfftbKKvXO_L@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-2-matthewg@nvidia.com>
 <asfDZiuFKCuuRysC@kernel.org>
 <asimw1D5J0ZqM4i3@srcf.ucam.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asimw1D5J0ZqM4i3@srcf.ucam.org>

On Fri, Oct 09, 2026 at 01:33:07AM -0700, Matthew Garrett wrote:
> On Thu, Oct 08, 2026 at 07:23:02PM +0300, Jarkko Sakkinen wrote:
> 
> > > +static bool tpm2_dev_cmd_is_blocked(const u8 *buf, size_t bufsiz)
> > 
> > This function could have less generic name.
> > 
> > tpm2_dev_is_kernel_nv_change?
> > 
> > I'm not a huge fan of this name either but it does say quite clearly
> > what the function does at least. Just a suggestion.
> 
> I left it that way on the assumption that it might get extended at some 
> point - maybe that's not a big concern.

Hmm... I take this back. I'm not sure if my suggestion is any better
and yeah quite meaningless detail and nitpicking from my side tbh.

Br, Jarkko
