Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755739;
	b=yrwgL+FyfjfCgFhHZORxqPQ2X0wUNUltSDowK/QuDH+siNASFuJDv5IMKUlZwNCnSgUU
	 KJDHZIo8LX9pKptoDkJPtL6h2geg+iVCbFPEzV1jkbp5o9c9Jfq+Fu+dlTlTxy4Ys8Z4C
	 3Ez7M0ZmUXDewn0bVIZHudimaT8BmIclZsorpJgU67vUgjreKHK+fpRXQ8iknoumHCxAk
	 DqZ+oHJtRoKUnSAyhf4yAO31+riEo9nlWLOKitTtPZlarGU9dQCOCD3rGP1hvApmhmJ+0
	 AW9igpxuI5CCWWE1JfpwTEgdBocZkY6vydT49xEqg3kNBR+txURuSOMPmRgitxvNYWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755739;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZMJp4/fulOCGDmJoG0GQAtDWGPmAgWD+3y7C5zmC73o=;
	b=E1ikWI3LEuBSSUxbLi8/fpbUtNtUQ3tI7xXOifDvXYk6spFeNeAMxDpR4N8vxoN3iqvn
	 O2QvDHW6xNLovMlA4LFXiQCY9QWZSz2RPixj3VXkCnvbPS6XGHOaGSqk12Xh79jbYsUGV
	 BReBBo1Po04TBvbpdChtBIcqPbrV6LwWzYOEtj4LNJAhKZcTVXzWW8edPL0Mz+whCrEjg
	 uB1of66pWpp3O+O+yqjN9vrTaVGe9BYl+mn//zHndStKXLb6oN+DhWXG+Ac0aFvR4VTHp
	 17Wu1DubEehnjVYpehmsOqZTbfYOfY2W2AeE1Wa2ncYF3yqGBOexrF6W3DiY5HE/XaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aPRY9RWp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1177B606A31A;
	Sun, 15 Nov 2026 15:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aPRY9RWp
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3E3441F000C4;
	Sun, 15 Nov 2026 15:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755738;
	bh=ZMJp4/fulOCGDmJoG0GQAtDWGPmAgWD+3y7C5zmC73o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aPRY9RWpolvNu0ag3CuefduZM1tVexeZetcAmcbNFYRetdmAMXdX7fEMloTnd6wYi
	 1cON5uNR5P4Ovloj8oBK9c3iutcAZsvRmrwgWhBBmL9gjy3Th1zffytgqbboASJ7gJ
	 PJOTqPfZbfuBEtf53QhTXWeDrxhwakxuIJUQb7ip/PUOEn/Iab9EK9KJJxAehkJvbg
	 8Gm41Me2v8ZXwi3WrWfPMyYGcdIVL2XK7YsLtlJFR5GsZjEJQgsr6nApb2/DN9nr3l
	 kh85fCmUYRLMjf5ZX5Ia/aO43VdVshLb8hjrdZz+VlQX68N/ocgJdEbyF72woI8vrX
	 YltI13ozcILdg==
Date: Sun, 15 Nov 2026 17:15:35 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <avnMl7fD156F1fx4@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-2-matthewg@nvidia.com>
 <435907614242e82ecde1767a967a3110fca6fb37.camel@HansenPartnership.com>
 <asqthz69ohnMVCye@srcf.ucam.org>
 <059384e86fd256618498b9a7214b6421d38fdf1f.camel@HansenPartnership.com>
 <astjpI65VOyU8xvI@srcf.ucam.org>
 <f002fc613bf0bdcf895e5be02dfd2524b7608787.camel@HansenPartnership.com>
 <asty4acE2B94t5q6@srcf.ucam.org>
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
In-Reply-To: <asty4acE2B94t5q6@srcf.ucam.org>

On Sun, Oct 11, 2026 at 04:28:33AM -0700, Matthew Garrett wrote:
> On Sun, Oct 11, 2026 at 12:27:58PM +0200, James Bottomley wrote:
> > On Sun, 2026-10-11 at 03:23 -0700, Matthew Garrett wrote:
> > > Hmm. Well, that's irritating. Which year's XPS is this?
> > 
> > It's an XPS-13 9380 Core i7 ... circa 2019 I think.
> 
> Yes, that's definitely later than I hoped. Bother. I think this patchset 
> is probably still worthwhile because it does unblock us on at least some 
> machines, and the implementation is intended to be opaque (other than 
> the change in PCR 5 measurements, but we should still get log replay) 
> and can be replaced with something else if we want. The other approach 
> that springs to mind is tying this to having distros switch to a new 
> kernel signing key before enabling this and so having PCR 7 be 
> associated with the feature, but that sounds like an incredibly tedious 
> thing to get right in a reliable way.

What prevents blocking PCR 5 access from /dev/tpm*? If firmware already,
does it, this can only add defense-in-depth.

This feels way too obvious question to ask so I presume I'm missing
something.

Br, Jarkko
