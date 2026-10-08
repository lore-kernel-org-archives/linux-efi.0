Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1580B4A4829;
	Thu,  8 Oct 2026 15:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791475007; cv=none; b=ePXukucp544rBjKUKhmO6lQXrCWLntvCEYGfS0oQaB4K6A9roMeQ1faLwhz2TRFo8lP5CmxffLYfsNTq1Ytj7rRSQZh/Ta5CQATGWOdyKtPSqpYwrNS06ccisbEjd3CX4S1LxLA/xefQEStehiXZ+WQxMTe5OaVdGb/nfQ6Sy/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791475007; c=relaxed/simple;
	bh=4T7+kwqeLF1iaqtHRRItlcp3UQ9M8yFbOlUgCboL7Zo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SVh6JWh3QJGIWb8GTxcOej+sfd/CJDeVkaH0SV818eRxqqGthsrLWugbFWTG15Tpdkn0ARVe400fePf5g3xP2WXmkfYqBcP2nf6TlhxmTbUJbYi6rkr5yvKJQNsGAH9VfPzKLJ1dIBi2us4wEsHjqfPYUEzB+c5ZH59FK+IQAk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOopBNKS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOopBNKS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 082A71F000FF;
	Thu,  8 Oct 2026 15:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791475005;
	bh=t/k6GBykoXXVVoctwLm8isejRieFbFuiEFi85fJbtkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DOopBNKS6yal4lzmfYSh/GV3nywKxLzLrX2CjGpOtbTLj+Bo+jGJPN8a/2xVmqxXl
	 I2UOMs6WCThc+spuZ6DNCeAQWMC5t+dIXmzb4Olg5kQw5a6T0AC4uAT4+gmYPq7nW+
	 eg5cakOMYQKJhFbrrS5x9xHBxW32txP0bRr5v2cPturlh5Gm9k3Suil89ips4jn5vu
	 8txFCM4DnlAIIYeFF2XzCssFGXolLNkJzk76BwNaTLEuB0PFFJ4UnqcKY6H4WBqoHv
	 Cwa2tKcDW9yWOAu5MRqcbLOKFPl5Ervl2qpLBFBEekQwz/hEVTsuUyAz/4TPQl4cH+
	 ACEkDx1UqtTVw==
Date: Thu, 8 Oct 2026 18:56:41 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Make hibernation work with lockdown
Message-ID: <ase9OQGWtEvDp0qH@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>

On Thu, Oct 08, 2026 at 06:20:16AM -0700, Matthew Garrett wrote:
> Hibernation writes out the full system state to disk in an unencrypted 
> and unauthenticated manner. Resuming from hibernate reads that data and 
> throws it directly into RAM, then jumps into it. This is effectively an 
> entirely unauthenticated mechanism for putting whatever you want into 
> kernel space. This violates the assumptions around lockdown (root can 
> write whatever they want to the swap partition and then trigger a 
> resume), and as such lockdown blocks hibernate.
> 
> This has made many people unhappy.
> 
> This patchset seeks to solve this problem. In order for hibernation to 
> be trustworthy we need to be able to prove that the image was generated 
> by the kernel and not modified after that. This is not an easy task, and 
> requires some infrastructural framework. To that end, this patchset does 
> the following:
> 
> 1) Co-opts a TPM NV index for the kernel's sole use. This is currently a 
> placeholder and we should register one explicitly from an appropriate 
> range in order to ensure that we don't conflict with userland.
> 
> 2) Does something horrifying with PCR 5 in order to prove that a given 
> kernel supports (1). We need to extend and cap a PCR before userland is 
> running in order to prove that the kernel has support for this feature, 
> but since we don't currently cap any PCRs there's nothing stopping 
> userland from doing the same and so achieving the same state. The way 
> around this is to rely on a feature of PCR 5 - it is extended as a 
> result of ExitBootServices being called, and since the boot stub can 
> execute code before that happens we can perform the proof extension 
> there and then have it implicitly capped by the firmware's extension.
> 
> 3) Adds support for audited TPM sessions in the kernel, allowing us to 
> generate signed digests of the commands that were executed in that 
> session and their results
> 
> 4) Adds support for generating a predictable AK that can be used to sign 
> digests from those audit sessions
> 
> 5) Adds support for generating a TPM signing key in such a session, and 
> using the signed digest to prove that the session took place in the 
> kernel
> 
> 6) Signs the hibernation image with such a key
> 
> An old kernel that doesn't implement (1) won't be able to mimic the same 
> PCR 5 value. Userland won't be able to mimic the NV index value because 
> the kernel will block it. This means that the only way that key could 
> have been created is by the kernel, and so we can trust that the image 
> was generated by the kernel.
> 
> QUESTIONS:
> 
> 1) I haven't tried to make the key management generic, since this isn't 
> intended to ever be exposed to userland in any way. Should it be 
> integrated into the trusted keys layer anyway?

If we don't have a use case, I don't think so...

> 
> 2) Filtering TPM commands from userland isn't ideal - anyone able to 
> poke commands into the TPM directly is in a position to violate the 
> assumptions here. Is there any way we can get a secret into the kernel 
> that can be used as an auth value? It would need to be impossible to 
> obtain from userland and it would need to be consistent over platform 
> reboots.

We could generate a primary key and a keyedhash key that would be stored
outside kernel while data is at rest. Then during power on they could be
read to the kernel memory.

I did not consider who would create the files in the first place.

I neither did look at the code yet meaning that my comments should
definitely be taken with a grain of salt. Just writing down a remark.

Br, Jarkko
