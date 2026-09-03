Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06161348C6E;
	Thu,  3 Sep 2026 16:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452785; cv=none; b=gGGzKn6P7MClAEcEvBXF+2oyOEgiVqr4V8Hj1hcIm4dGzEdhZXoQHLQPAlU5kr5Wj/mVmyGKB2tbNapyNXLzuUvOnAkXWlHKrPsqquErMhUNmx066StSDzvtbckn9ncD79o1o/tKL9hzoOEEHUYd6UWCmN8eWN52XxCEbdBxdK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452785; c=relaxed/simple;
	bh=FTN85+wh6Pdn0k0De7Y3v0wgVKMDrH7hi/h5YG7U70A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ltUGxtXgUM1bN13f2ylaO/HwN7ey7kdWQ6EvKaz6d9ZNrtZYCstKxzXVLNVDPCDtwFs3m8PM1xvsDm/JDoE7IrRYxTGpZZMv9HgaJOoV3haAXFbebVMecr9ogj07FW37qkYnPOuVbgW1S0WdIOI4Bn9hEJOy36PN/85XAMFcWXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BesfQ5/m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BesfQ5/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269911F000E9;
	Thu,  3 Sep 2026 16:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452783;
	bh=Yklku70u8AEdfLgrIe06VUjsn48xfAtvDjV3kRMaOPc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BesfQ5/mUpvGx3f+5eEtnewfGkXq60IW2E7K8lGAqDntWpvphQ+1dpFUL1T4N7ZLw
	 WtmmxSkCKv5vuExm2oFDDjhbgBaBFNGh8Msdb9AwAAl6dz9CNM8wmycJpaCFB2CohK
	 B9/N5m+Ti5EigTEERBbSnH9jqMuwM82/6d7qcxDuUDX9eYOudRJIPzU2c8SVwel+2D
	 0phIgmgO88ljgkKMm2xbXd2DkKS2ROPqORhMlx6xfgUn0q4pAIcNQqWpIEi79K4n1R
	 X/nXhmP9qwHJllhWSBTSTUvREa+Coq8wP6pWSCp8iSybho7RIquD9R2XYNbEJ22Ktm
	 5zU3fmtRl8eDw==
Message-ID: <acdf2acc-a1a7-4a02-8924-4605e0d929b0@kernel.org>
Date: Thu, 3 Sep 2026 18:26:18 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/6] PSCI-via-EFI to support firmware and kernel
 sharing EL2 for Apple Silicon
To: Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Sudeep Holla <sudeep.holla@kernel.org>, Janne Grunau <j@jannau.net>,
 Neal Gompa <neal@gompa.dev>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
 asahi@lists.linux.dev
References: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
 <9c53cfd7-e193-4441-83ca-7710060225b7@app.fastmail.com>
Content-Language: en-US
From: Sven Peter <sven@kernel.org>
In-Reply-To: <9c53cfd7-e193-4441-83ca-7710060225b7@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ard,

On 03.09.26 13:34, Ard Biesheuvel wrote:
> Hi Sven,
> 
> On Wed, 8 Jul 2026, at 09:15, Sven Peter wrote:
>> Hi,
>>
>> Usually, idle and sleep state are implemented in firmware running in
>> e.g. EL3 with the kernel trapping into that from EL2. Unfortunately,
>> there's no EL3 on Apple Silicon machines and we'd rather not run the
>> kernel in EL1 since this would result in losing KVM support.
>>
>> While the shallower states could be implemented inside a custom cpuidle
>> driver (like we do downstream, see [1]) the deeper states result in a
>> complete loss of state and require bootstraping the cores again which is
>> quite involved. So instead we need some way to call back into our
>> open-source firmware to be able to handle that. This is even more
>> important for M4+ which don't even support the architectural wfi anymore
>> and always lose state when that instruction is executed.
>>
>> Luckily, EFI runtime services provide much of scaffolding we need,
>> namely a way to keep some code and data mapped and the ability to jump
>> into there from inside the kernel.
>>
>> This series adds a custom EFI table that points to a PSCI entry point
>> (plus some other stuff that has to be available before EFI runtime
>> services are set up) and adds support for this new conduit to the psci
>> code. We can't directly use the normal EFI runtime path because that one
>> takes a sleeping lock and we need to be able to call into PSCI from
>> atomic context during e.g. cpu bringup or during idle.
>> It also adds support for specifying the specific MAIR attributes for EFI
>> runtime mappings as defined in the latest UEFI spec since Apple Silicon
>> is rather allergic to using Device-nGnRnE vs. Device-nGnRE for its MMIO.
>>
>> This all results in a surprisingly small diffstat. I believe this
>> approach was originally suggested in some IRC discussion years ago,
>> possibly by Ard, but I can't find the old logs anymore.
>> Happy to add a Suggested-by tag though if anyone remembers.
>>
>> The firmware implementation I used for testing can be found at [2] and
>> the full kernel tree with this series applied at [3].
>>
>> Best,
>>
>> Sven
>>
>> [1]
>> https://github.com/AsahiLinux/linux/blob/asahi/drivers/cpuidle/cpuidle-apple.c
>> [2] https://github.com/AsahiLinux/m1n1/tree/psci-via-efi
>> [3]
>> https://git.kernel.org/pub/scm/linux/kernel/git/sven/linux.git/log/?h=efi-psci
>>
>> Signed-off-by: Sven Peter <sven@kernel.org>
>> ---
>> Sven Peter (6):
>>        dt-bindings: arm: psci: Add EFI conduit
>>        arm64/efi: Add and parse custom PSCI EFI configuration table
>>        efi: Add EFI_MEMORY_ISA_{MASK,VALID}
>>        arm64/efi: Honor EFI_MEMORY_ISA_MASK for Device-nGnRnE vs -nGnRE
>>        firmware/psci: Add EFI runtime conduit
>>        arm64: dts: apple: t8103: Add PSCI and CPU idle states
>>
> 
> I've picked up patches #3 and #4, which are useful in their own right.

thanks, I think i had a fixup for one of those in my local v2. I'll 
check and send it as a separate patch if it was important.

> 
> I'm not sure if the arm64 maintainers will want to consider this, but
> I think it's a reasonable compromise, as it puts the abstraction in
> the right place.
> 
> I take it this will be contributed to u-boot if it gets accepted here?

Yeah, that was my plan: First agree on something that can be accepted 
into the kernel and then work on the rest of the boot chain. The current 
code in m1n1 that sets up bare bones EFI tables is just a hack to proof 
this all actually works.


Sven


