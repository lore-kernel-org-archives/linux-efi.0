Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9461DA0E1;
	Wed, 20 May 2026 05:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779255492; cv=none; b=ReBPuX+p5iaiAT+vtxlKavt7Dmkyd/8g2VaIEoPyT/1pfkpgwVCbn3pcDnoB8q0OHQF5PDAmVnbHw/oIakuzcRRj2NuPFPI1n8nfrIb6C3ITD9+C5Yv403olM2AlJQt20lMoWowJerzjmlxAicK/UZiqsF50pbMO1cLUIAo4iic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779255492; c=relaxed/simple;
	bh=mVh8HT1+IbJA3i4RRUc8uxMLBmgDbM4OmSRaoPb2cVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eEGi4Ve8NPyorL0gsTT3xET8t0oybcKo5e5zWpxeLoxLymBKF3I1zLf4+pW2BJseVv97RBbz2CRiX0XXjAEOIZvjybVKghLfr5sXKUnKQRz5Xi2iX1q640ZuJoFxqGaN1kFeDpC+AcVTjaT04ZDSf6tzTsXQyZsL6cCDBuZlQg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ObLlAjYh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ObLlAjYh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 197B13590;
	Tue, 19 May 2026 22:38:04 -0700 (PDT)
Received: from [10.164.146.0] (J09HK2D2RT.blr.arm.com [10.164.146.0])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D0763F632;
	Tue, 19 May 2026 22:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779255489; bh=mVh8HT1+IbJA3i4RRUc8uxMLBmgDbM4OmSRaoPb2cVw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ObLlAjYh3RLvu2xxlUUllZ73g66wjGL3BE/wJSa/k0qYxle1w9UZZHqfi+BJpjMD3
	 Fp+I7tkB2Aw1/fo2Lo9uaE1hJWcT79a3scyxkSZjWCciqNEvUO4VdDH4A/gu5QHpQD
	 sapvug2KQMu0JHmUCgnQGpQ6MGVzKdeCHoH+eYSo=
Message-ID: <a63aadf6-703a-4a67-a86a-fc6da3de117c@arm.com>
Date: Wed, 20 May 2026 11:08:02 +0530
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: Rename ptdesc_t
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Will Deacon <will@kernel.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260430034933.541634-1-anshuman.khandual@arm.com>
 <afMKEgJGWZpZjZub@kernel.org> <agw_Ih69WYh7NDWZ@willie-the-truck>
 <34c31f7a-e3e5-47c1-9e41-e6e9a90e89d3@kernel.org>
 <2f60361d-43b9-4f7f-b786-7852d081f4a1@arm.com>
 <66031835-d9f9-4fcf-a720-baba1aaf45a1@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <66031835-d9f9-4fcf-a720-baba1aaf45a1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 20/05/26 10:56 AM, David Hildenbrand (Arm) wrote:
> On 5/20/26 04:08, Anshuman Khandual wrote:
>>
>>
>> On 19/05/26 4:32 PM, David Hildenbrand (Arm) wrote:
>>> On 5/19/26 12:44, Will Deacon wrote:
>>>>
>>>> Yeah, the 'pxx' prefix really hurts my eyes. Please use something else!
>>>
>>> Fine with me as long as we don't call it something with "pte" in it.
>>>
>>
>> Seems like there are two choices here
>>
>> (A) pxdval_t
>> (B) ptval_t which Mike had suggested earlier
>>
>> Unless there is a preference will probably go with pxdval_t
> 
> given it is ptdesc_t, ptval_t sounds better to me.
> 

Sure - ptval_t it is.

