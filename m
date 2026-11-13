Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794528374;
	b=A6Dt/FCFqdwXe86AE/jU6DscwWIUMXEHg3wBlEdlN7tshZjwAuzu+vi7O3bRmOO0iq5Y
	 BS8cq9sZVF9P66ei4kht+GxP823cnsXmxNnyT6K9/UJ2UXZjtPFNsDB0riUOXaV5lujp3
	 /aX5O0aMQyNVfTvP1XFCgxK8sie0JkRqNOJ7y22I/0sqLEBuKqrIwxj3+i6VowKF7ba9A
	 c4yUY4vokUf0MqkSwQDZp67PO235YRX7CTTr2bT5aru4Z8pdWsz35QN4KGRhNQ8CfwSpC
	 vWdEIIRBW085y9aFeqwoZnOOJNyRxmUV23xZcStDpxz86RRWWDyLS27DEJ5kWi4J41A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794528374;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=tOPY0JlA/znfkgxSHyXmiwQi91KyGIwi3K/ptmdzr38=;
	b=4Hkf17qmiasGd1rtgfrgDlE5sCjZYko8TCYIwALBTVlSeq/p89OxZdCEmdYhOn0u1HPO
	 WUH9pGKMlEfqjzWu4fGAjRaPd0ibuwZ2ADFzLaR8Ef0YFX0cKkThVSIKOpseq3j12q4cF
	 hA3gJmABO5wc+DFTa334fNrJqCUADCtIITwU8JltNxb0pRKUXlP4uS71+0uhsIn58+b7W
	 k8fddoQuan6vzRl9beh8CWX7pGM3WFjW2Nkiu9AxV6i+SIdeAitgns2+rqpuIDbhFfNX8
	 8rthmfs4vW6t3Ol0xy11EJ88uUHfLtEmcjuGCixcVzu6tCplgaDLKjlHjgPk209dCIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kjfy9lof;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 61937606A31C;
	Fri, 13 Nov 2026 00:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kjfy9lof
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5AC781F000C4;
	Fri, 13 Nov 2026 00:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794528373;
	bh=tOPY0JlA/znfkgxSHyXmiwQi91KyGIwi3K/ptmdzr38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kjfy9lofwbjzd9FFAJDce2u7ufstE8HqelEhcMCALvLNRrXCBwbtMo7X509gxtJL3
	 FJrqnU2wNkax6dbrW7Ag9WBG/8d8WYUStUUFRO/LEel/Y3i3UPaClW8VgN9r/43n5p
	 6L3BJXUejhVYnO7eEOluB0crkJKkGzL3JNrZgo3jjNmeUdwcD33bqjUa7hfdaOY2Vg
	 B51ni7Y3ewjCCbFr58fzw3wGUjLBprgYlydkIloPkB93A8nrEjngDXZRL1Ln11xsNX
	 +TqoGikIcAVTPQ4VB05C8I0da08cBcEt8TZYZhDgxlkI9WAaBpm0WnQhUFcSVnj8nV
	 loLIRayBx3+XA==
Date: Fri, 13 Nov 2026 02:06:10 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Make hibernation work with lockdown
Message-ID: <avZUcjjjNtEUfnVM@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <avJ1JiFQApsgYT_c@kernel.org>
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
In-Reply-To: <avJ1JiFQApsgYT_c@kernel.org>

On Tue, Nov 10, 2026 at 03:36:38AM +0200, Jarkko Sakkinen wrote:
> I have a rebased branch of these patches with all the merge conflicts
> sorted out:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=hibernate
> 
> And I'm finishing up refining my test environment:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/
> 
> The build recipe is:
> 
> 	export LINUX_OVERRIDE_SRCDIR=<kernel tree path>
> 	make build BOARD=tpmdd_amd64
> 
> This results build/tpmdd_amd64/images/tpmdd_amd64.iso, which is a live
> ISO. Once I get remaining commits pushed (not all of them yet are),
> the image can be installed by typing:
> 
> 	sudo npx @puu/install
> 
> The TUI installer duplicates the bootc image of the live ISO  to the
> target hard drive. It has a checkbox for hibernate as part of the
> installation flow.
> 
> I'll report the results later, and at that time my testing harness
> should be fully available in public.
> 
> I think this is pretty much the lcd for the required testing machinery.
> It is neither a feature very popular nor well maintained among popular
> Linux distributions.

To my surprise both my refined (installable) testing harness and the
kernel patches worked on first trial :-) This has probably looked more
like building an ivory tower and making noise than getting anything
done.

I also verified and traced that:

1. The expected call paths are actually exercised.
2. Secure boot is active.

The next step is to review the patches properly and try to see what
needs to be done to eventually land these patches.

As far as I'm concerned it is force majeure situation with accepting the
idea at least, as without lockdown support hibernate is a bricked
feature overall.

Br, Jarkko
