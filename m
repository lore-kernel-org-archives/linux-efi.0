Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423F8456E04;
	Thu,  3 Sep 2026 12:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788437731; cv=none; b=CJ4zj6+oQ26rQpeuvhTBn5I4OLGGU/i9WPpN5s90euCb/GGhTt7qE4EJ/zBEfmANKthUjk2rOfFFJyRS+S8yhJkbDdbNi/eWmak6x3+R1FOf2gTIbtc8UdkNEVsD+fm2Ypegy3pXMBDBy07OLjzYe2Lj0EYafcqR1b4CDzb0Cng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788437731; c=relaxed/simple;
	bh=QsJJKv84o4yFegTGOrPDVQ99tVJ5YNEisyGtASAATnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EK/uMvClfStWAxDzRRUt7dLXXydOA1Fy5EWzNdibKq1zitCgYLOcTFZvHHJYCppy2ERzbNrNlwWTrvnoomo1RVqyFS1j5YQqnsux8wdC9qbFPn/FlH5DYiqIupYB7vXezPDKzK33UC3LBSzWVCnqqzaiNhtl7DIr2JcJb9hd5JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wlhg71sE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wlhg71sE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E7C1F000E9;
	Thu,  3 Sep 2026 12:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788437729;
	bh=BQZPrnDuGftEtbnqTGVPBifdVscC5mec8jxqTDh+SJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wlhg71sEdsZ12VOuBMKYZ+OVPWHR/+2qU3Rz9ebiVUVvBe7WpKVuelJcjp/f4b29g
	 TvaIJR7Bs94UulLQXVkUtxPvBuITBUbf8griasJlRHwVlIxThtbW/abkXrDWPSqgoj
	 GvsBJuxmwE5Rp0A4BaDO4rkO1HnG/xcQvGiivdPlhajCQe8tNk48XFKW5cVSrCzO5a
	 XBxEdnl1Zgl/vKnVppsBHS1LxNE7qUmBtm+k00PB060y3Mh2EwJiThCrltiKrDSoys
	 rAJCaAwHob/s9uZglPOtos9vt2YwyBKVPLTGIlpjF7I7qXIz87dpoB4c63gVX6XZeI
	 yM2S6inSkCX2w==
Date: Thu, 3 Sep 2026 13:15:22 +0100
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Sven Peter <sven@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>, Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>, linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org, asahi@lists.linux.dev
Subject: Re: [PATCH RFC 0/6] PSCI-via-EFI to support firmware and kernel
 sharing EL2 for Apple Silicon
Message-ID: <aplk2hHRB7Yw9FWW@willie-the-truck>
References: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
 <9c53cfd7-e193-4441-83ca-7710060225b7@app.fastmail.com>
 <apldL6Ml91GW-tE9@J2N7QTR9R3.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apldL6Ml91GW-tE9@J2N7QTR9R3.cambridge.arm.com>

On Thu, Sep 03, 2026 at 12:42:39PM +0100, Mark Rutland wrote:
> On Thu, Sep 03, 2026 at 01:34:56PM +0200, Ard Biesheuvel wrote:
> > On Wed, 8 Jul 2026, at 09:15, Sven Peter wrote:
> > > This series adds a custom EFI table that points to a PSCI entry point
> > > (plus some other stuff that has to be available before EFI runtime
> > > services are set up) and adds support for this new conduit to the psci
> > > code. We can't directly use the normal EFI runtime path because that one
> > > takes a sleeping lock and we need to be able to call into PSCI from
> > > atomic context during e.g. cpu bringup or during idle.
> > > It also adds support for specifying the specific MAIR attributes for EFI
> > > runtime mappings as defined in the latest UEFI spec since Apple Silicon
> > > is rather allergic to using Device-nGnRnE vs. Device-nGnRE for its MMIO.
> 
> > >       dt-bindings: arm: psci: Add EFI conduit
> > >       arm64/efi: Add and parse custom PSCI EFI configuration table
> > >       efi: Add EFI_MEMORY_ISA_{MASK,VALID}
> > >       arm64/efi: Honor EFI_MEMORY_ISA_MASK for Device-nGnRnE vs -nGnRE
> > >       firmware/psci: Add EFI runtime conduit
> > >       arm64: dts: apple: t8103: Add PSCI and CPU idle states
> > >
> > 
> > I've picked up patches #3 and #4, which are useful in their own right.
> > 
> > I'm not sure if the arm64 maintainers will want to consider this, but
> > I think it's a reasonable compromise, as it puts the abstraction in
> > the right place.
> 
> Sorry for the late reply; I've been away almost all of August and I'm
> slowly catching up on things.
> 
> As with last time this was proposed (in abstract), I am not happy about
> bodging an EFI conduit into PSCI, given that the manner in which state
> is managed is completely different from SMCCC.
> 
> If we need a mechanism for doing hotplug and/or idle without HVC/SMC,
> that's one thing we can consider. I don't think we should pretend that
> it is PSCI.

What do you have in mind for an alternative mechanism? I understand your
objection to this proposal, but at least it keeps the interface fairly
high-level and avoids opening the flood gates for a bunch of SoC-specific
idle routines. Are you thinking of extensions to the PSCI spec or
something else?

Will
