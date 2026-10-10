Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0F43603DF;
	Sat, 10 Oct 2026 21:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791667758; cv=none; b=quNclEbcN/63yuTxd8ukp8kUFKk5Po/UiKU6bnwjblwIa8sU8EbzH3Y4H/+QZpltdx8PeGPecwo9LzhwNNlbXU3yKCOA8pIJhug1BaDGvHk2Ry1m6FKekJnSk+1wrpOUk+dYk+BtX0NksSdVGot6ivPOCcCCSOphjtO2Bx1Ng/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791667758; c=relaxed/simple;
	bh=9Os20CJlwn4UaDQPV5d96KFXFFtVG8KvVSHvcxAMK0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRtA7FnC40IDeL1HXB4XLwPXUs0aU7qDoyVpYBvavbriwdI7bAYbxSgOz/9IcymVEjU2na6wOwHVO1AQpIUug9+syRoc7Nud8u4/IDwhcYvZ0QEyfrjoGs9mPFsUW1rpmrWDhGQn24kW6iUsJcX9u3tudcOSMtxuoAXskiP3Zd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/ScVXlU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/ScVXlU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3E35F1F000FF;
	Sat, 10 Oct 2026 21:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791667757;
	bh=mW/YZupnz+VClnHiVoSvbEe0jv6QWxWpkLeox9G79OE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f/ScVXlUsoQ/RtjmcZoUO4LUAjj2zRoG+pBctPgim+IKGuDk3z3HSTD4DbbU90rV8
	 Id4iupePTb6xLwiJupajKQVw1bRHCkWSkyk2qoPrtSAELVtOTAzJRog6W9lC9K6oxY
	 7tFGUB5yKQQDN72uCpvxgMU997VRIoeW9VfJEqg+8WWClP9GXl7W3NJ9birfg1fpOO
	 2RsFw80ybVQ5jYfAIcmQQGT3gcONpOThwyOPA0zDoKJWdd1sX3l0uTto+h8dgqc7Is
	 0irNGwVWP2cMSYn1ZW8o4xc6RP9w1AST4uEXFKXjVvjU3QmET3zR3tnaqqfK2KNF7z
	 FPjQjn0OFzjbw==
Date: Sun, 11 Oct 2026 00:29:14 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 17/17] PM: hibernate: Allow hibernation under lockdown
 with signed images
Message-ID: <asquKsFJNSEdshAT@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-18-matthewg@nvidia.com>
 <asfKpInP6j8DYA4-@kernel.org>
 <asimRSqckPDUl0A8@srcf.ucam.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asimRSqckPDUl0A8@srcf.ucam.org>

On Fri, Oct 09, 2026 at 01:31:01AM -0700, Matthew Garrett wrote:
> On Thu, Oct 08, 2026 at 07:53:56PM +0300, Jarkko Sakkinen wrote:
> 
> > I skimmed the rest of the patches but gave up for now given time and
> > bandwidth, and also having quite loose grip to the changes until I
> > run them (it's just complex patch set enough).
> > 
> > What kind of test environment you have in high-level, or could you
> > give some rough guidelines for a test environment?
> > 
> > I'm thinking of setting up something with Buildroot, QEMU and swtpm
> > perhaps.
> 
> Testing has been qemu + swtpm, with some scripts to build a toy 
> initramfs to automatically do the testing. What would be the best way to 
> share those with you?

Hmm... right. I think I actually have an environment havingg most of
the shenanigans already in place, including swtpm:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/

I'll shoehorn basic hibernate at first in a way or another and after
that try the patches.

Br, Jarkko
