Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792782805;
	b=D0UsxJb3G7AYPLqnjuUkduUGRYZh/fpIzoj5MbWhbcb3kmP3f+KuzWBrrMI+nFrsOsnI
	 MNuJoKpd8v/bDXdAlXxywiHQZCSIrYtpsD1bppDoDwjj7IVVPcfsEdabk8fyFnVW2wZJ6
	 bIDf3iLR0juQcdunOgWKq9Dz5uhMGM0q8IzqYhQYDdsnzc2kGrzAWTWtWcGyyTJqjQluy
	 +Er87A1M4mNYyOGSQ6xPptNbSwLTe5QVaKYCSXIk97URaTvA1ZeKjkxwz6tN72Y3jXozs
	 5ByLp0IxWuccbr2LSQ41I2b6XGFf7cjpMdK6JxFLykHi+7tWFa7Gmd9ZIvwAElb+uMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792782805;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UYatpzYJ+kSKQ7a2QtrULywNxP41+vz2UBzDQ0wdRcY=;
	b=vcF2CjzUTvUFt2n1eWmDXcQCscCMPAkugRjj8g1koJRsIJzGO+lKlMTd8JSCFbSyelKM
	 mxONnRP1auGVuHXu1GiCXFBpsp+wzXGCn/ewtQFsgjNz3txZtfzGry4nvBLmjoBzh0zdT
	 IWRXdRcb6qubOi+zne9qRDT2E8xtLrYfBebiI8jThWJ2SVIsbNEBEsxPHxn4W0/hWqQ1h
	 BrfHsBuahhtn17wUFAOL+i23q2inNaMKXAByo5LgCILsAzDkOxGfQEPRrdgWmPz9ql17s
	 3c775a0rwYwva2aXYPRY5d8m4o4PZbBkjgoWdmisFjTlA/oJdsnmvNpJMXFQ8PuuJWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bo33bFvx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EFDAB606A31A;
	Fri, 23 Oct 2026 19:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bo33bFvx
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E11A21F01825;
	Fri, 23 Oct 2026 19:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792782804;
	bh=UYatpzYJ+kSKQ7a2QtrULywNxP41+vz2UBzDQ0wdRcY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bo33bFvx3nsY8ZLDnNxvcXGn1Cd7du9x7GGa1GKoyMORhBmKw9pudA5o4wDXizf6U
	 6InbcbHrF7avS/4peOAX7mGdfxzyRTGmIbQBynH4jPFQEbmAbZKvqEoUY6Wr/RipJo
	 i6nLhKJDV/wfa5DgicIBashJ71n7GCAliUcykeEBGLPMBG/K6C/uK70Or36WfqZm1R
	 +UB+1B2/t9zH0oEOsFIDKHshUZHZvZQvt5C79Fj3QDf24vnGQHDy5+Vbt9DC9BaXSP
	 dTVsMNMSw/PVQFHHwYocCyrxN4MsPUfQJv0O0jvPE4AWr8iAa30YI0el7xcviUIMa2
	 Op7DRejXbs9MA==
Date: Fri, 23 Oct 2026 22:13:20 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Make hibernation work with lockdown
Message-ID: <atux0EFb_euN6pM3@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <att9OPPi0sPqt_CW@kernel.org>
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
In-Reply-To: <att9OPPi0sPqt_CW@kernel.org>

On Fri, Oct 23, 2026 at 06:28:56PM +0300, Jarkko Sakkinen wrote:
> Now I have finally all priority stuff out of the way. I'll start by
> refining my test harness to always have regular hibernate enabled and
> fully working. Once I get that out of the way this patch set should
> become low-effort to test.

We have some luck with this actually.

At work I've been doing a bootc based operating system for vLLM workloads
and for no any particular good reason I converted my test environment to
build bootc/UKI based hybrid ISO images. It's exactly like any other
live ISO.

As the next step I'll expand the bootc OS installer that I did to have an
option for hibernate so that it does partition layout and all the wiring
required. I can then integrate that to my test environment and test it
in a libvirtd VM.

It's not as tedious as it sounds :-)

There would be faster routes but this is the only one that is not a
tower of cards. I'll just shovel it through.

I'd figure that it's also modelling quite well any possible production
environment where this feature might be ever used (reproducible build,
read-only rootfs, bootc container).

1. https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/
2. https://github.com/puu-os/installer

Br, Jarkko
