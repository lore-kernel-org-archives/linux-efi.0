Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019456;
	b=D6oQC/OZCBSvnX0d5pc9vZHwMrccA92rTmAIXBjc1MMMA+eGbIdtAEUJsFSnuX1ZPnMv
	 HrbsWNlWhVldlVlJcsK9CK5tkEzRpnMqVBaAWxg8OLIXMcBfXWvMe+RoxKGUgkRseW/8F
	 Cs5okhil+woEi4LHXtaDywQywvWtDHer2D8lu61bMRae/+xVdgfEmboTe4cThfYp/jy/d
	 FeR+PIaBy55gpdc14PZUJwxNJtc7rdTFWFsauuIztfg7YaTJ2gTcDiZV5sC4c6EIzfiP7
	 Zys0bHLKwSZOnVH39MNMXkI+HskqecMaNxwXMg+ryAfF9Has3eMzEiOFqH554MdUhjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019456;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=V8EfCcQQuKQgYuNV+U25OJIYzPXqlQ48YSyRVImINN4=;
	b=CIPBS6mXZG9F91kpCxxP1JyRdcVGN5L5YBl+VM21y0xB1Mx6Y5t1HhPbUzjTZ35w7pNK
	 wadS9p15ocWslJGzn/UxWpMMaCbfKxSeI6lWmuGcZQ26W5MUQF6KM8CAFgu1o/ZgCxA++
	 feqP6MDfwcMFRPlNrUwQRoLb/g0FSzS+CQ5JPSH5m8lwzxwTRnpyuEM4xGGq3aVwOiWFR
	 JjrfMZ7r9agUTrt1TguPN8+rEsEKCs9d8/yi/e8N4sAk8pCV4+w/yeKoBo+28E92VSIJI
	 b6JjH27NbzHg2LFRIeGglcIYsHfb07NJUj2kyTBVh5PfK6zp8zpYKa1ApHE5PFbTmqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LL8pNEpw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 87AF1606A7ED;
	Wed, 18 Nov 2026 16:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LL8pNEpw
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9EA0C1F000C5;
	Wed, 18 Nov 2026 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795019456;
	bh=V8EfCcQQuKQgYuNV+U25OJIYzPXqlQ48YSyRVImINN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LL8pNEpwqA/UXeLxj72+eBHPxZvLqWPADu5si/lCYb7xohJv0s5TNymNRFIlQnveK
	 ttk1SqLivpJHr2DPClSTwST4zbmlIchuTTyXHMwLOEuy2TRjBXuj4STsaum4ev7JgL
	 Uzy2SjviPCrP1TdbIDr9hBojA+9Yiv6wV8kgeyp+mPZhJvU19xcX4dyOcxq2lG4wub
	 mBPrxrAb0opx/TBx/g0yelnoMdD/rx/+Rzsk6VELp2eiM5ZBUtweD/y2kJo1BzA9PN
	 GKxYLgogiVErEkMTcLpqNDRwCrRiXW0Z53JZ4Gy4/YsH6UIPIetfOEMd4eAi9RmEag
	 5rEDZMutIqM3g==
Date: Wed, 18 Nov 2026 18:30:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
Message-ID: <av3SvHN3UCzzvyY9@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-2-matthewg@nvidia.com>
 <435907614242e82ecde1767a967a3110fca6fb37.camel@HansenPartnership.com>
 <asqthz69ohnMVCye@srcf.ucam.org>
 <059384e86fd256618498b9a7214b6421d38fdf1f.camel@HansenPartnership.com>
 <astjpI65VOyU8xvI@srcf.ucam.org>
 <f002fc613bf0bdcf895e5be02dfd2524b7608787.camel@HansenPartnership.com>
 <asty4acE2B94t5q6@srcf.ucam.org>
 <avnMl7fD156F1fx4@kernel.org>
 <ba43d150febc8a85247d6c54f57db0835cb8f5de.camel@HansenPartnership.com>
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
In-Reply-To: <ba43d150febc8a85247d6c54f57db0835cb8f5de.camel@HansenPartnership.com>

On Wed, Nov 18, 2026 at 11:06:55AM -0500, James Bottomley wrote:
> The better mechanisms to address this are probably:
> 
>    1. Detect that PCR5 has been disrupted (get the kernel to store the
>       on-boot value and check they match) and if so refuse signed
>       suspend to disk with a message (this is easy).
>    2. Capture the additional writes to PCR5 and store them as part of
>       the attestation so the resuming system can prove the current boot
>       value of PCR5 matches the attested one when the additional
>       extends are replayed (this is a bit more complex).

(2) is a great suggestion IMHO; did not cross my mind.

That approach would also help to debug any possible issues.

I think it also might make sense to drift away from kernel config flag
to kernel-command line parameter when it comes to pre-existing integrity
code. It's time consuming to test and improve right now.


> 
> Regards,
> 
> James

Br, Jarkko
