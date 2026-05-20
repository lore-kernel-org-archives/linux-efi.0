Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A17812C3245;
	Wed, 20 May 2026 02:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779242944; cv=none; b=I66WBqYc/GyY7RGfqpmSi/fLLNB+udFsijxcHUedQcQU/IuMPt/QvypwHyXfbGJHEAFV6Brs7+4LYoWLpZhOSMnawTQq4XikuSwkbnvG17Cop7Wpm+oRXRdBofpaqSzR0wsu/3Un4eejn8cljbq/WMGyVQaDMaepYOAmnIDynP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779242944; c=relaxed/simple;
	bh=t/zcxRnmWow/5jiKAHWJPO/z52Ho0PtKFjig7sSxFyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fFI5u2RNdi/iHPQ8CyjU5ulO+1gsSf1OKGiSdEJH6kjG/a6gVkBoIHPqA2nzR+RpR39CindZ/eQkqiBSHq5Rrosmm605gomAGumziS4K+CSzvKe+Y1agd+TAIQ4nu185xRea6AEs83sMTuzTV1DsMfZVQl9LOB3/N7y8VAoZXyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fCQnfIwc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fCQnfIwc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73129355D;
	Tue, 19 May 2026 19:08:50 -0700 (PDT)
Received: from [10.164.18.45] (unknown [10.164.18.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 63B9C3F7B4;
	Tue, 19 May 2026 19:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779242935; bh=t/zcxRnmWow/5jiKAHWJPO/z52Ho0PtKFjig7sSxFyc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fCQnfIwcTX0WscYmYVgcPeWcYVVdX9wlLPvNH72MeszU1VayFwTUD2vFsJ6PYR8Si
	 SYKjKQx1RjR3VrZs5CR+egCRla1umReo9RHvaigqPs18mXW1O4foKIltE/GDDULh6I
	 LqPVZT7yDFT5BQ6d7MCuTPvtXW/9KzI6D1i/sf+g=
Message-ID: <2f60361d-43b9-4f7f-b786-7852d081f4a1@arm.com>
Date: Wed, 20 May 2026 07:38:50 +0530
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
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <34c31f7a-e3e5-47c1-9e41-e6e9a90e89d3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 19/05/26 4:32 PM, David Hildenbrand (Arm) wrote:
> On 5/19/26 12:44, Will Deacon wrote:
>> On Thu, Apr 30, 2026 at 09:51:46AM +0200, Mike Rapoport wrote:
>>> Hi Anshuman,
>>>
>>> On Thu, Apr 30, 2026 at 04:49:33AM +0100, Anshuman Khandual wrote:
>>>> ptdesc_t sounds very similar to the core MM struct ptdesc which is actually
>>>> the memory descriptor for page table allocations. Hence rename this typedef
>>>> element as pxxval_t instead for better clarity and separation.
>>>
>>> Maybe we should keep the "pt" prefix and make it "ptval_t"?
>>
>> Yeah, the 'pxx' prefix really hurts my eyes. Please use something else!
> 
> Fine with me as long as we don't call it something with "pte" in it.
> 

Seems like there are two choices here

(A) pxdval_t
(B) ptval_t which Mike had suggested earlier

Unless there is a preference will probably go with pxdval_t
