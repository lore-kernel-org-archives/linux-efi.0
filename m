Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 568C346AEDD;
	Thu,  3 Sep 2026 11:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435780; cv=none; b=VFVWn0QsASGUDeE9ET/xJ5Zrz3F6eZDcqOLiVcstpR8mEi9Y89xniOzhu+5cPrcvtgvmHtBSVVwLJ6gndG3h07m+h9TE0ZVDucN+rwg3Rwvueges8+kU6NJB3PnTQqajUHz/JwM5KZtJjKtv9jYyv+wWh0P1/79q7kajDzTT5wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435780; c=relaxed/simple;
	bh=siMXG41iJ3X/vqbf8RYp8LNhM43Y0Ves9W+OMagA4eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QC+Y7+cHAJP8hwPWpRdvHDn5kQ301QqM6IJNzH1HXiAs4eK36Fe9E/JDwFs+bJ0JEYG12bbE5Tvsc2nhg7Co4JqSFMFqMxUCv6jY7KedZpkTnUcG3GCVixHpyuRtK5P3zEzdWeNBoMejvwB15D83o0TsS2Snn1lbhjL/PbApFzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=C4o2G78x; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="C4o2G78x"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 468011596;
	Thu,  3 Sep 2026 04:42:41 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 65C403F7D8;
	Thu,  3 Sep 2026 04:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788435765; bh=siMXG41iJ3X/vqbf8RYp8LNhM43Y0Ves9W+OMagA4eg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C4o2G78xVRbsEO8NNa92eegrUnoKRBkTQi5AK6Z+uyRztqM2xYpbSXDOO3g4HxV/d
	 W90CrGzaqSvWPTyHSZfMLw7Nf3Z27pletfVGLZwuwVUni4e2ZVUjRQ/BQfh4zPbzAP
	 y2n+SDFMuPdpwTRzFydlZNGoYWT0LHGwitc3+Aa4=
Date: Thu, 3 Sep 2026 12:42:39 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Sven Peter <sven@kernel.org>, Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>, Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>, linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org, asahi@lists.linux.dev
Subject: Re: [PATCH RFC 0/6] PSCI-via-EFI to support firmware and kernel
 sharing EL2 for Apple Silicon
Message-ID: <apldL6Ml91GW-tE9@J2N7QTR9R3.cambridge.arm.com>
References: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
 <9c53cfd7-e193-4441-83ca-7710060225b7@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c53cfd7-e193-4441-83ca-7710060225b7@app.fastmail.com>

On Thu, Sep 03, 2026 at 01:34:56PM +0200, Ard Biesheuvel wrote:
> On Wed, 8 Jul 2026, at 09:15, Sven Peter wrote:
> > This series adds a custom EFI table that points to a PSCI entry point
> > (plus some other stuff that has to be available before EFI runtime
> > services are set up) and adds support for this new conduit to the psci
> > code. We can't directly use the normal EFI runtime path because that one
> > takes a sleeping lock and we need to be able to call into PSCI from
> > atomic context during e.g. cpu bringup or during idle.
> > It also adds support for specifying the specific MAIR attributes for EFI
> > runtime mappings as defined in the latest UEFI spec since Apple Silicon
> > is rather allergic to using Device-nGnRnE vs. Device-nGnRE for its MMIO.

> >       dt-bindings: arm: psci: Add EFI conduit
> >       arm64/efi: Add and parse custom PSCI EFI configuration table
> >       efi: Add EFI_MEMORY_ISA_{MASK,VALID}
> >       arm64/efi: Honor EFI_MEMORY_ISA_MASK for Device-nGnRnE vs -nGnRE
> >       firmware/psci: Add EFI runtime conduit
> >       arm64: dts: apple: t8103: Add PSCI and CPU idle states
> >
> 
> I've picked up patches #3 and #4, which are useful in their own right.
> 
> I'm not sure if the arm64 maintainers will want to consider this, but
> I think it's a reasonable compromise, as it puts the abstraction in
> the right place.

Sorry for the late reply; I've been away almost all of August and I'm
slowly catching up on things.

As with last time this was proposed (in abstract), I am not happy about
bodging an EFI conduit into PSCI, given that the manner in which state
is managed is completely different from SMCCC.

If we need a mechanism for doing hotplug and/or idle without HVC/SMC,
that's one thing we can consider. I don't think we should pretend that
it is PSCI.

Mark.
