Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794767923;
	b=K8sM1ZZy2mO8du6wF+w0Xa7Bj2hEovs+zAp1zVI9XJdk+UeSZrwHU3diS0dxnh75jqhC
	 rVkuqOUMWM3Xft8LaxH07x8jakx1kmZ5mV0FPHRLU+0u2DJVTO5H+wQQK+qewJnnnuD/H
	 3YyYTzIkA6fIt5WT5AtSKfpVgvhtOSaRSJuACHJOUbsaRgFdaEVt/f7x/TeAqOnxf9TpK
	 bWCUJ+A1qAy4SjwMP8hd7A86VyvyyxXECldaQdndp9T0YSihJ6mmNWMYrmjOAYIqHAleO
	 c/8vKxgMM0fA0iM1KHS/v3mJ+FdyFKXXVtx7uU1oKH9fvP7grj93RLsR1CHBm5X8OwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794767923;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=arPSgjHS15vPHb0JCnqy9OouR7YuHrSqzN7k0IpSy4Y=;
	b=CQmg2uW/uMFJVnZ7u+kARDe+6KIEVCyxEHQI9z6OLj+OMqwMobNJflAxjCAycVQHol21
	 fcYlfRwSc42tfrFOINFaFG7d5vDVfnOrSPGDN223BOFyPzAT8m9iWHOkolpQjUPkApwls
	 PxJUf228Ll3oGwM19jJzdHSlLJM/z9OPMtwcELmJiCmxcUHmnGt4gO2HArKKJ63gjlVub
	 MMvNGPan/nJrR6tzsR1KBiNz5m6PgXaPCndun1UJzyRFfUm1HB1u4/cmp3Zul48ccoFD7
	 qmG3yG4wXzv0KtOnlU3gc5YHCizAwotWj+uaSPsYAs+Qm0hxQjgVVsthDsREJBlmvNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I4RBcK4Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117F9606A31A;
	Sun, 15 Nov 2026 18:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I4RBcK4Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63B01F000C4;
	Sun, 15 Nov 2026 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794767922;
	bh=arPSgjHS15vPHb0JCnqy9OouR7YuHrSqzN7k0IpSy4Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I4RBcK4ZAnk1QwAXA56mz6tfAD7cwMoY/DmdBdyNp/MCDke1j0K/iqhm2TnulUyRT
	 paudavJLRFoqY3/kXQ6WVI1qOvGarxQU9eZZWzNV5NBqBqZb4NjtiP3ZOCusbJ7AGK
	 KLjVXP0f5GcuKSrk+B5xeMcu4WSIv3e+w2MX9FH06EMoNy5BreKICjuE5d5bobeV4B
	 7wthe7OE1Dz0rYq6dImjBWzvPgBakFh6KJZk5eJczAreOd3RNl3fOWWFNN7XeL4cNl
	 WkDBLVHUC6lMXJfuspSxAMTsJteDaLTe2gNw5o4N+PdsnPSEyB8lB1bCA1azrx4P0I
	 o+K/AezXHHqyg==
Message-ID: <cadadedb-1de1-46f0-9bfd-35eb8bdfa85b@kernel.org>
Date: Sun, 15 Nov 2026 19:38:35 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/6] PSCI-via-EFI to support firmware and kernel
 sharing EL2 for Apple Silicon
To: Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sudeep Holla <sudeep.holla@kernel.org>, Janne Grunau <j@jannau.net>,
 Neal Gompa <neal@gompa.dev>, linux-arm-kernel@lists.infradead.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, asahi@lists.linux.dev
References: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
 <9c53cfd7-e193-4441-83ca-7710060225b7@app.fastmail.com>
 <apldL6Ml91GW-tE9@J2N7QTR9R3.cambridge.arm.com>
 <aplk2hHRB7Yw9FWW@willie-the-truck>
 <eb75b82a-8910-4198-b89a-5c8b487c0fd5@app.fastmail.com>
Content-Language: en-US
From: Sven Peter <sven@kernel.org>
In-Reply-To: <eb75b82a-8910-4198-b89a-5c8b487c0fd5@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 03.09.26 15:25, Ard Biesheuvel wrote:
> On Thu, 3 Sep 2026, at 14:15, Will Deacon wrote:
>> On Thu, Sep 03, 2026 at 12:42:39PM +0100, Mark Rutland wrote:
>>> On Thu, Sep 03, 2026 at 01:34:56PM +0200, Ard Biesheuvel wrote:
>>>> On Wed, 8 Jul 2026, at 09:15, Sven Peter wrote:
>>>>> This series adds a custom EFI table that points to a PSCI entry point
>>>>> (plus some other stuff that has to be available before EFI runtime
>>>>> services are set up) and adds support for this new conduit to the psci
>>>>> code. We can't directly use the normal EFI runtime path because that one
>>>>> takes a sleeping lock and we need to be able to call into PSCI from
>>>>> atomic context during e.g. cpu bringup or during idle.
>>>>> It also adds support for specifying the specific MAIR attributes for EFI
>>>>> runtime mappings as defined in the latest UEFI spec since Apple Silicon
>>>>> is rather allergic to using Device-nGnRnE vs. Device-nGnRE for its MMIO.
>>>
>>>>>        dt-bindings: arm: psci: Add EFI conduit
>>>>>        arm64/efi: Add and parse custom PSCI EFI configuration table
>>>>>        efi: Add EFI_MEMORY_ISA_{MASK,VALID}
>>>>>        arm64/efi: Honor EFI_MEMORY_ISA_MASK for Device-nGnRnE vs -nGnRE
>>>>>        firmware/psci: Add EFI runtime conduit
>>>>>        arm64: dts: apple: t8103: Add PSCI and CPU idle states
>>>>>
>>>>
>>>> I've picked up patches #3 and #4, which are useful in their own right.
>>>>
>>>> I'm not sure if the arm64 maintainers will want to consider this, but
>>>> I think it's a reasonable compromise, as it puts the abstraction in
>>>> the right place.
>>>
>>> Sorry for the late reply; I've been away almost all of August and I'm
>>> slowly catching up on things.
>>>
>>> As with last time this was proposed (in abstract), I am not happy about
>>> bodging an EFI conduit into PSCI, given that the manner in which state
>>> is managed is completely different from SMCCC.
>>>
>>> If we need a mechanism for doing hotplug and/or idle without HVC/SMC,
>>> that's one thing we can consider. I don't think we should pretend that
>>> it is PSCI.
>>
>> What do you have in mind for an alternative mechanism? I understand your
>> objection to this proposal, but at least it keeps the interface fairly
>> high-level and avoids opening the flood gates for a bunch of SoC-specific
>> idle routines. Are you thinking of extensions to the PSCI spec or
>> something else?
>>
> 
> I can't speak for Mark, of course, but I could imagine EFI being used as a
> conduit to provide a callable set of interfaces (with a rigorously defined
> set of constraints such as the ones in this patch, i.e., reentrancy, no FP
> or SIMD, not relying on ISA features that the OS needs to know about and
> enable, etc).
> 
> There is prior art here in ACPI PRM, which does something similar, and this
> also relies on EFI runtime services.
> 
> You'd still need to implement the CPU ops and a cpuidle driver afaict (no
> expert here), but at least those would be coded against an interface that
> the kernel itself specified, and can be made as generic as we choose to.
> 
> Not saying this is all great, but it might be a worthwhile compromise to
> consider.

Finally getting back to this series...


I'd definitely like to keep mapping the resident firmware using EFI 
runtime services because otherwise I'd have to duplicate a whole lot of 
tricky code to do the same thing via some other means (e.g. a device 
tree nodes that contains all mappings + callbacks) and I just don't see 
much value in that.

I'm happy to just drop the PSCI part though and replace that with a 
simple and somewhat generic "efi-rt" (or similar) cpuidle driver and 
make that one have similar requirements like I added for this RFC series 
and expose bunch of generic callbacks (that will just happen to resemble 
PSCI functions very much ;)) via a custom EFI table. That would keep 
PSCI out of all of this but come at the cost of an additional cpuidle 
driver.

I don't think that would open any flood gates for SoC-specific drivers 
since we could just point them to the generic one and tell them to use 
that one if they can't do PSCI for some reason.


Now before I go off and prototype this: Would this approach be fine in 
general with you, Mark and Will?



Sven

