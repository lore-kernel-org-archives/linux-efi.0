Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792769341;
	b=H1qnBiVAGuVvPuCOMYZYq8PKSw9f2zbiodI7Y2soShVgTyswkl2cjfiZAtnpYnAcQ2iL
	 hkiLq56Fsz4w7r6KmjkiIF3pT2z1fNxBpmV1lcstGf692fgB971jXmXGa37+U2FHG57JT
	 8KxoZ3qTC6XhRXUKMnTDVZJqUoV2dYTL6F1tY/2kyt6dkC9St5/4+ceTFecRyuQUZR7IR
	 G1S+XVWPIGsUzENjdCPETeS4RWFWcFbd6hvRKZx/58RO5iCNAGvCW5i8h0bSm12xLnNvO
	 Ki845PVEs9ktQLkV9DlqHYVRHpD8FA9Px2OdoECfCbgVRsZzDwdFji3TcaX+mlXoyzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792769341;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TTKsFjhHMqmkMHXmIXelfKmvngdkQQuEBhhn8ZrNqRo=;
	b=XXn+UuGGBF0Pe9tTLuIs8K7noPU9XMInLrYZkYkbKYJmeam5WY6JH0baIeE3GwoapU9t
	 PoGTuwk8us/N0Q9wp0qb8/p3FMwbFnrnxUc0lieMyYnjf7srmu1ux5XCV477sPEPydjZG
	 4hWFqeXI/al2KfAbGtiHWSUU+5o4d6r0B00PksqcHyMwF3o8MjMgIv9ERJ2ldYhxCenRQ
	 zZALNpd0cg3BiecZIgqTkjyJFwk30rQdY6o7Swq999+yCLB3TILSHeZD10HyY9e/LiO3x
	 dzXM3QtHVynS6q4J84y/0ydR+IMnVx/fLeJmobfvfpAHMRKZP5E44oLOhJQaOSIADHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="OnFrPR6/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D9BED606A335;
	Fri, 23 Oct 2026 15:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OnFrPR6/
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C7B311F01825;
	Fri, 23 Oct 2026 15:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792769340;
	bh=TTKsFjhHMqmkMHXmIXelfKmvngdkQQuEBhhn8ZrNqRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OnFrPR6/BoleO3KQuO8L/F5p1p/swj4MqES3/C7iutgTxjUwJHUO7BlYqMKNWqSup
	 tldpuyaBn09mhmQUX2xWLvWCsI8rr2pQwA3eXMhzX/VUB5mH0QcXw6LxFOs3DXXURO
	 nJ6V0qdd5JqWjsRZEeREUY+jIbKt7J39ldg95+HhmIH1TGoZ2w8gKZhGGvrEYvBa8u
	 ibOeTop350Y7YXu1hAGwKVNHHH3zGcj5AVUXZ7WA7EOT98GvX4grXq+Ztc88PwgWZY
	 dv4x5N9RMfl2+IDE/OYvgyR7DkszTDyN1Sz8q+kDuJDEwwQGXNVM+JMTc4C8qIJpiI
	 hfdPsyinRU7zA==
Date: Fri, 23 Oct 2026 18:28:56 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Make hibernation work with lockdown
Message-ID: <att9OPPi0sPqt_CW@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
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
> 
> 2) Filtering TPM commands from userland isn't ideal - anyone able to 
> poke commands into the TPM directly is in a position to violate the 
> assumptions here. Is there any way we can get a secret into the kernel 
> that can be used as an auth value? It would need to be impossible to 
> obtain from userland and it would need to be consistent over platform 
> reboots.
> 

Now I have finally all priority stuff out of the way. I'll start by
refining my test harness to always have regular hibernate enabled and
fully working. Once I get that out of the way this patch set should
become low-effort to test.

Br, Jarkko
