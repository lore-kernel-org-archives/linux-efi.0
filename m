Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102707;
	b=eLm3xl7rK1WjjaIa2aDPhVH0jg/VDhLtHbs0dYFoXEBJD9fRiQQw9k0Z0PZ07tS6z9iz
	 FXwefMX0B473MUki8MFW9q04JL82l8nqFAz+rJCS53Szgd5gXNZxWr4EaonEX0G7L6sXZ
	 ipcJHp+6Rke5J0HxKY++d+MYeFVhiGL04PrtpA/FeGFfAECO6cGAe/m8hR0eeabO1JfmS
	 MzahVNVjxzG1MlqvieWSZbsVZjKIru5ZcJa/X2gSHNsuc1K6ukzjDrnDmga2igV2LXEc1
	 wFpEC9KXPFNZV+K5WR5Q7Jxmz3EuCgyGmi2/TBB2mSEjwJiyzdYTsqCCm5KJwIaCuMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102707;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=WGQr9homvcBDDaDNFjGaP7bjHcrXtaqxHaJKTI0quEg=;
	b=YLXzy0wp17oDfvFiS45c9u/QxLcwSZlElIzprl6zYOgcTsgr9+DeHhBKX0RwlpEKL8LZ
	 /SX9izmYgZr17VvvjxA2G8I9zzj8frAO7TehcQnMDIwZdkjFI31MAdCT9S6JoIRXMadcU
	 mhev9Gpd8HGirhUnTK0bhuKdsgTpmuetlwfybSIPGN9h5S4TwfUzg0btq8gFAHg2NMxCk
	 LzfHAnDyYIjzr891OiZUwWodz175K9zevjdLYtb66V0fVacR1b+RZzyr2OkLkiyuXnIlx
	 q811I78FrJqXq8VLqo6fO5n75ZYBBBkDZQite8r9mde93laoV97JqMlNPnoiSxXIWng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nWGDqYNC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C4D60A2607;
	Thu, 19 Nov 2026 15:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nWGDqYNC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E8A1F000C9;
	Thu, 19 Nov 2026 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795102707;
	bh=WGQr9homvcBDDaDNFjGaP7bjHcrXtaqxHaJKTI0quEg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=nWGDqYNCGgY6EsYektk0F3ocquHXbRy1fnBV1cjg2r5M/i1bmrbziHyQsCLWESUdJ
	 opBWD9W5X5P5mOOl4X7/vqsOz5egFXFqJAoPrL4wF2t4goJ4HyOW0XVMH95ZFst1+K
	 zMl6ZnTfRZ3zlTPlIVDjv/wCnHDmdeEMZiGZi3Oz2oDcuTE9oVH8vy/+c97AqyrB06
	 qfAK6S6U9Kmd9ZtWqMyHpCYtStkgZRJhpi9hovItWRr9tH5NJJXztFH0dK+aOhgXFI
	 5abk/OIW6k2WsjCfCEqMkNRBGtntyyVmO0X4Bua4NEszIh6DdRYDzmfJ3kdQhFCz/+
	 HsHGJtTPB/JZg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id BDA09198003A;
	Thu, 19 Nov 2026 10:38:24 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 19 Nov 2026 10:38:24 -0500
X-ME-Sender: <xms:7Rf_ahjoSDHuY-li6z80mwYOQLNJTGQf1s9UH2cE69IDojYofOJwPg>
    <xme:7Rf_ag02Px5PS4iBvm_FnNjsIZ6ZtHQjpcHB8i3JsRRyvwbq0U9FF8ofWY68gj4vd
    ihV1_A3F1imUG4RxW7k_Qc7xhu6BK1y-71x4MxdUuBj2ooChhuX7UHh>
X-ME-Proxy-Cause: dmFkZTFjUXYloFjoDllRlpZzwX+Mr2aQT9ODXP8XGqHiLINShhj92g8SnoXLjarMGxqFOO
    oMDZM9EMatC8AGeg/TSMAdaFkP0NJsv1RNjS5Z5wWE7XSkhmx4jF+oLRVh3mFvSxwbe+xk
    nU298dZTxAa+bh/zAwbQbFPI3xyGDOOUS+385VVsVL1+gnA2mILXuFwfM0DajlGwagkkBS
    u27MEZWc8i8uC/2bF9euzQlyo4MLEJN8OuSZrtvxdRVK1sYclzWbHdRfR72lilcXQx0dLz
    i3W7h3MPidwET8W+CEXkC+RoWeLCGzPYlagVwS2A5U3Y11yanQZV1s6/vZkWj53tyOy2AD
    pzA9vLhqXXaM9bjhj4TJ+RCvFGC+1d+/mxLqU4jENV6V9cg2cbVPnjK017AVB0ZjBJVpr3
    s6siunXhUGx205Yl44urUhkqQpwryhaQ70MGhoa6F+xWX5jg7c8biylL5yT1OMtAuJGuqr
    MwQHxiAoZwbrPftISKaf60cnPvn9tGs3EH+fVmm7/OTXfIjBXcfKM2Nm7amnjiiHF8O+nt
    od6D2ndZV4Tg8t2DNQYZ07MeZfFHqEw2FGpeLs+MY2H7cWkgrlHEGVW6tk8MNmtCZI2VbU
    zrEFfeiZRVlvNisMmkmYFY6hsVs+/dc+sZkZ36SJx+rOx3TOi3fFB/o/OTfw
X-ME-Proxy: <xmx:8Bf_ailq9KZsUJBEpXUEZIDn32ElvnIruMtxjDCpKznCpT1ZTkVThA>
    <xmx:8Bf_akG8_SUQdfXtfWLssOzQRlbG3JFU89ndf_BfWHbWgGdCiKq6Vw>
    <xmx:8Bf_amEpQKt3967seOdLahbvyYJbpHiNLFsWPrFIeR0LP7WwCukBZw>
    <xmx:8Bf_as3jiR3CjL8AoEsqrCL3Ad7TrusWoiXyrbNpceBqdUwceNWKtg>
    <xmx:8Bf_aofDdp_XnT9_bucLRcIiGEv1YKmTwbaVBT6hJMDgjrNll8blkGpU>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id BEF05F80093; Thu, 19 Nov 2026 10:38:21 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Thu, 19 Nov 2026 16:38:00 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Sven Peter" <sven@kernel.org>, "Will Deacon" <will@kernel.org>
Cc: "Mark Rutland" <mark.rutland@arm.com>,
 "Lorenzo Pieralisi" <lpieralisi@kernel.org>, "Rob Herring" <robh@kernel.org>,
 "Krzysztof Kozlowski" <krzk+dt@kernel.org>,
 "Conor Dooley" <conor+dt@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Sudeep Holla" <sudeep.holla@kernel.org>, "Janne Grunau" <j@jannau.net>,
 "Neal Gompa" <neal@gompa.dev>, linux-arm-kernel@lists.infradead.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, asahi@lists.linux.dev
Message-Id: <a1b18224-4171-4702-acb2-cef994dd9921@app.fastmail.com>
In-Reply-To: <ef76e141-491d-44a9-90a6-e9cd54526012@kernel.org>
References: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
 <9c53cfd7-e193-4441-83ca-7710060225b7@app.fastmail.com>
 <apldL6Ml91GW-tE9@J2N7QTR9R3.cambridge.arm.com>
 <aplk2hHRB7Yw9FWW@willie-the-truck>
 <eb75b82a-8910-4198-b89a-5c8b487c0fd5@app.fastmail.com>
 <cadadedb-1de1-46f0-9bfd-35eb8bdfa85b@kernel.org>
 <avxETlOGyr_WQ2zp@willie-the-truck>
 <ef76e141-491d-44a9-90a6-e9cd54526012@kernel.org>
Subject: Re: [PATCH RFC 0/6] PSCI-via-EFI to support firmware and kernel sharing EL2
 for Apple Silicon
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 17 Nov 2026, at 16:25, Sven Peter wrote:
> On 17.11.26 13:10, Will Deacon wrote:
>> On Sun, Nov 15, 2026 at 07:38:35PM +0100, Sven Peter wrote:
>>>
>>>
>>> On 03.09.26 15:25, Ard Biesheuvel wrote:
>>>> On Thu, 3 Sep 2026, at 14:15, Will Deacon wrote:
>>>>> On Thu, Sep 03, 2026 at 12:42:39PM +0100, Mark Rutland wrote:
>>>>>> On Thu, Sep 03, 2026 at 01:34:56PM +0200, Ard Biesheuvel wrote:
>>>>>>> On Wed, 8 Jul 2026, at 09:15, Sven Peter wrote:
>>>>>>>> This series adds a custom EFI table that points to a PSCI entry point
>>>>>>>> (plus some other stuff that has to be available before EFI runtime
>>>>>>>> services are set up) and adds support for this new conduit to the psci
>>>>>>>> code. We can't directly use the normal EFI runtime path because that one
>>>>>>>> takes a sleeping lock and we need to be able to call into PSCI from
>>>>>>>> atomic context during e.g. cpu bringup or during idle.
>>>>>>>> It also adds support for specifying the specific MAIR attributes for EFI
>>>>>>>> runtime mappings as defined in the latest UEFI spec since Apple Silicon
>>>>>>>> is rather allergic to using Device-nGnRnE vs. Device-nGnRE for its MMIO.
>>>>>>
>>>>>>>>         dt-bindings: arm: psci: Add EFI conduit
>>>>>>>>         arm64/efi: Add and parse custom PSCI EFI configuration table
>>>>>>>>         efi: Add EFI_MEMORY_ISA_{MASK,VALID}
>>>>>>>>         arm64/efi: Honor EFI_MEMORY_ISA_MASK for Device-nGnRnE vs -nGnRE
>>>>>>>>         firmware/psci: Add EFI runtime conduit
>>>>>>>>         arm64: dts: apple: t8103: Add PSCI and CPU idle states
>>>>>>>>
>>>>>>>
>>>>>>> I've picked up patches #3 and #4, which are useful in their own right.
>>>>>>>
>>>>>>> I'm not sure if the arm64 maintainers will want to consider this, but
>>>>>>> I think it's a reasonable compromise, as it puts the abstraction in
>>>>>>> the right place.
>>>>>>
>>>>>> Sorry for the late reply; I've been away almost all of August and I'm
>>>>>> slowly catching up on things.
>>>>>>
>>>>>> As with last time this was proposed (in abstract), I am not happy about
>>>>>> bodging an EFI conduit into PSCI, given that the manner in which state
>>>>>> is managed is completely different from SMCCC.
>>>>>>
>>>>>> If we need a mechanism for doing hotplug and/or idle without HVC/SMC,
>>>>>> that's one thing we can consider. I don't think we should pretend that
>>>>>> it is PSCI.
>>>>>
>>>>> What do you have in mind for an alternative mechanism? I understand your
>>>>> objection to this proposal, but at least it keeps the interface fairly
>>>>> high-level and avoids opening the flood gates for a bunch of SoC-specific
>>>>> idle routines. Are you thinking of extensions to the PSCI spec or
>>>>> something else?
>>>>>
>>>>
>>>> I can't speak for Mark, of course, but I could imagine EFI being used as a
>>>> conduit to provide a callable set of interfaces (with a rigorously defined
>>>> set of constraints such as the ones in this patch, i.e., reentrancy, no FP
>>>> or SIMD, not relying on ISA features that the OS needs to know about and
>>>> enable, etc).
>>>>
>>>> There is prior art here in ACPI PRM, which does something similar, and this
>>>> also relies on EFI runtime services.
>>>>
>>>> You'd still need to implement the CPU ops and a cpuidle driver afaict (no
>>>> expert here), but at least those would be coded against an interface that
>>>> the kernel itself specified, and can be made as generic as we choose to.
>>>>
>>>> Not saying this is all great, but it might be a worthwhile compromise to
>>>> consider.
>>>
>>> Finally getting back to this series...
>>>
>>>
>>> I'd definitely like to keep mapping the resident firmware using EFI runtime
>>> services because otherwise I'd have to duplicate a whole lot of tricky code
>>> to do the same thing via some other means (e.g. a device tree nodes that
>>> contains all mappings + callbacks) and I just don't see much value in that.
>>>
>>> I'm happy to just drop the PSCI part though and replace that with a simple
>>> and somewhat generic "efi-rt" (or similar) cpuidle driver and make that one
>>> have similar requirements like I added for this RFC series and expose bunch
>>> of generic callbacks (that will just happen to resemble PSCI functions very
>>> much ;)) via a custom EFI table. That would keep PSCI out of all of this but
>>> come at the cost of an additional cpuidle driver.
>>>
>>> I don't think that would open any flood gates for SoC-specific drivers since
>>> we could just point them to the generic one and tell them to use that one if
>>> they can't do PSCI for some reason.
>>>
>>>
>>> Now before I go off and prototype this: Would this approach be fine in
>>> general with you, Mark and Will?
>> 
>> tbh, if the "efi-rt" thing is just PSCI with a different conduit and that
>> conduit is properly documented, then I really don't see the point in keeping
>> it separate. However. I suspect that we probably all have slightly different
>> opinions here which isn't going to help you very much :(
>
> Yeah, well, I agree but I really don't have a strong opinion or any good 
> argument if either "efi-rt" vs "psci-via-efi" is better or worse. I only 
> think both are better than SoC-specific cpuidle and cpu_ops drivers and 
> I have no idea how else we could do this. (We could drop the kernel to 
> EL1 and do "normal" PSCI in EL2 then but that would be much worse than 
> either of those options imho)
>

I agree with Mark that implementing a pseudo-PSCI that can never quite
comply with everything in the PSCI spec is probably not a great idea
unless we actually need it.

> And especially with M4+ I'd like to have something that can go upstream 
> because normal wfi loses most general purpose regs there and has to be 
> disabled which is not great.
>
> I can also just prototype the efi-rt cpuidle+cpu_ops thing and then we 
> can take a look at it as well and see if that's better than what I have 
> in this series if that helps but I'd rather not spend that time if that 
> has no chance of being accepted either.
>

I think a consistent approach for both secondary bringup (+teardown?) and
cpuidle that is based on the same efi-runtime layer is perfectly acceptable,
and allows us to define it as narrowly as we can, rather than having to
consider what shared code might assume once it sees enable-method=psci on
a CPU, or a PSCI conduit (SMCCC detection, mitigations, etc etc)

