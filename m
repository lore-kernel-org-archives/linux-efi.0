Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794917461;
	b=A78a52J9yMFAeWYjK1/0aDcLLYvSEfSMu6p9H/ytSd1dCSCAZuKdhZYZRI2Orf1ROGMK
	 TmZRKFgcMAEVnRopFMwqK2HF93fq0TR+xYeQNiW7yY1NjSsWKwLDdNoUuJMqJ85y/IPpg
	 gkFxYe+d2vZD3aJWX/0zT2k3rpgpmzt3FYkDwWS5wG1h6STNXciZH1ynWGXMW8MmR9suy
	 gqF9PsUakQ7sFcJaNSDSZvRKCESN5oLfPGZ4tJ0OtJO4wQO87BrGbLQT0nMXs3kwRtPx8
	 jmAW4+2qK60Km5MSIaiTRMf9LdjBKQ2q9PQrMPh8LIeHvhBdZhCKgX1lDeCsruWUpQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794917461;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+1BpRIRf2nPGKzJFdVk2a4hDpuZJr7hID0LUitYqiDA=;
	b=emuCmcNd1qT9ByEOHxuJIUTfL9+NfsBmjhJ7eLBaIsIJn252YVOIDz9pTl5o0CH15zfx
	 toJrBT0rRKGpWy2gec4izFKPnnXs/wQVydq8lQtV9XH8JC8TEf9uyngPYk/R1slqS3tPR
	 CMoPgCayePsW7T0iKm62bVu2VHwlDUGW14PUxhf9LbZMRc98XtpXgyuhKAbY5lJXTmKm3
	 eS9CQOTuzeboUJaytEzbv5lnxTn2t05tzfn+vChlXKv9rvtMnVjjExfdvHqqAKbo8b/Xw
	 vQitFxMUk0WDeMygjRcEWPMNOj5O/PAUx/fAIlTFSp7vOnxpBEGPLZzrtp0ipY6x5cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGxA30+L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26EB606A31C;
	Tue, 17 Nov 2026 12:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGxA30+L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327E31F000C4;
	Tue, 17 Nov 2026 12:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794917461;
	bh=+1BpRIRf2nPGKzJFdVk2a4hDpuZJr7hID0LUitYqiDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JGxA30+LSayvTFpzFzaPwgAO/2s9/BHbbED1n1A/usLmbrL8nArMCz1gwId+3VYr4
	 vDKe/KQ1paoenZ68G4/rpBjJOBgLm1Jt/NURy/TBxhC3xyeAfeVS86PTz1uK3W3WBC
	 3Pj9cnWMyfS6WNMe4Kj9lyzaJ8v7GSCksmRx4dGex0aqXp11SvayvDc+kBic6z0WnF
	 cUFYrsuZOnDwSdtj7U5I8ieqgeOFb+oVXM71vR3MitFPShxoU56q0nRteRXS2mhONc
	 +fZqxCrtVWWe2Bkk4d/tJLyHLcgWF1/LDt/1dV/Zq0RXtOhJVV3GrLidOnBMZE6ETd
	 RFBgOdKl7eLyQ==
Date: Tue, 17 Nov 2026 12:10:54 +0000
From: Will Deacon <will@kernel.org>
To: Sven Peter <sven@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
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
Message-ID: <avxETlOGyr_WQ2zp@willie-the-truck>
References: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
 <9c53cfd7-e193-4441-83ca-7710060225b7@app.fastmail.com>
 <apldL6Ml91GW-tE9@J2N7QTR9R3.cambridge.arm.com>
 <aplk2hHRB7Yw9FWW@willie-the-truck>
 <eb75b82a-8910-4198-b89a-5c8b487c0fd5@app.fastmail.com>
 <cadadedb-1de1-46f0-9bfd-35eb8bdfa85b@kernel.org>
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
In-Reply-To: <cadadedb-1de1-46f0-9bfd-35eb8bdfa85b@kernel.org>

On Sun, Nov 15, 2026 at 07:38:35PM +0100, Sven Peter wrote:
> 
> 
> On 03.09.26 15:25, Ard Biesheuvel wrote:
> > On Thu, 3 Sep 2026, at 14:15, Will Deacon wrote:
> > > On Thu, Sep 03, 2026 at 12:42:39PM +0100, Mark Rutland wrote:
> > > > On Thu, Sep 03, 2026 at 01:34:56PM +0200, Ard Biesheuvel wrote:
> > > > > On Wed, 8 Jul 2026, at 09:15, Sven Peter wrote:
> > > > > > This series adds a custom EFI table that points to a PSCI entry point
> > > > > > (plus some other stuff that has to be available before EFI runtime
> > > > > > services are set up) and adds support for this new conduit to the psci
> > > > > > code. We can't directly use the normal EFI runtime path because that one
> > > > > > takes a sleeping lock and we need to be able to call into PSCI from
> > > > > > atomic context during e.g. cpu bringup or during idle.
> > > > > > It also adds support for specifying the specific MAIR attributes for EFI
> > > > > > runtime mappings as defined in the latest UEFI spec since Apple Silicon
> > > > > > is rather allergic to using Device-nGnRnE vs. Device-nGnRE for its MMIO.
> > > > 
> > > > > >        dt-bindings: arm: psci: Add EFI conduit
> > > > > >        arm64/efi: Add and parse custom PSCI EFI configuration table
> > > > > >        efi: Add EFI_MEMORY_ISA_{MASK,VALID}
> > > > > >        arm64/efi: Honor EFI_MEMORY_ISA_MASK for Device-nGnRnE vs -nGnRE
> > > > > >        firmware/psci: Add EFI runtime conduit
> > > > > >        arm64: dts: apple: t8103: Add PSCI and CPU idle states
> > > > > > 
> > > > > 
> > > > > I've picked up patches #3 and #4, which are useful in their own right.
> > > > > 
> > > > > I'm not sure if the arm64 maintainers will want to consider this, but
> > > > > I think it's a reasonable compromise, as it puts the abstraction in
> > > > > the right place.
> > > > 
> > > > Sorry for the late reply; I've been away almost all of August and I'm
> > > > slowly catching up on things.
> > > > 
> > > > As with last time this was proposed (in abstract), I am not happy about
> > > > bodging an EFI conduit into PSCI, given that the manner in which state
> > > > is managed is completely different from SMCCC.
> > > > 
> > > > If we need a mechanism for doing hotplug and/or idle without HVC/SMC,
> > > > that's one thing we can consider. I don't think we should pretend that
> > > > it is PSCI.
> > > 
> > > What do you have in mind for an alternative mechanism? I understand your
> > > objection to this proposal, but at least it keeps the interface fairly
> > > high-level and avoids opening the flood gates for a bunch of SoC-specific
> > > idle routines. Are you thinking of extensions to the PSCI spec or
> > > something else?
> > > 
> > 
> > I can't speak for Mark, of course, but I could imagine EFI being used as a
> > conduit to provide a callable set of interfaces (with a rigorously defined
> > set of constraints such as the ones in this patch, i.e., reentrancy, no FP
> > or SIMD, not relying on ISA features that the OS needs to know about and
> > enable, etc).
> > 
> > There is prior art here in ACPI PRM, which does something similar, and this
> > also relies on EFI runtime services.
> > 
> > You'd still need to implement the CPU ops and a cpuidle driver afaict (no
> > expert here), but at least those would be coded against an interface that
> > the kernel itself specified, and can be made as generic as we choose to.
> > 
> > Not saying this is all great, but it might be a worthwhile compromise to
> > consider.
> 
> Finally getting back to this series...
> 
> 
> I'd definitely like to keep mapping the resident firmware using EFI runtime
> services because otherwise I'd have to duplicate a whole lot of tricky code
> to do the same thing via some other means (e.g. a device tree nodes that
> contains all mappings + callbacks) and I just don't see much value in that.
> 
> I'm happy to just drop the PSCI part though and replace that with a simple
> and somewhat generic "efi-rt" (or similar) cpuidle driver and make that one
> have similar requirements like I added for this RFC series and expose bunch
> of generic callbacks (that will just happen to resemble PSCI functions very
> much ;)) via a custom EFI table. That would keep PSCI out of all of this but
> come at the cost of an additional cpuidle driver.
> 
> I don't think that would open any flood gates for SoC-specific drivers since
> we could just point them to the generic one and tell them to use that one if
> they can't do PSCI for some reason.
> 
> 
> Now before I go off and prototype this: Would this approach be fine in
> general with you, Mark and Will?

tbh, if the "efi-rt" thing is just PSCI with a different conduit and that
conduit is properly documented, then I really don't see the point in keeping
it separate. However. I suspect that we probably all have slightly different
opinions here which isn't going to help you very much :(

Will
