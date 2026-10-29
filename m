Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275612;
	b=2+xP+0AJQg7/FMd/gTNWQEouRAKs98Ddqf4OCbE/tZQPQENGWZqaTVt9ch0a/HYhZ3Bi
	 WACJYHAwUL/TAsezM0IH+972kjWNu9xuuuIa9uwsjbIit3t6Cc30QGYjKY+yCA1JQ69XL
	 uggErlPmQQu2y+sidTEPRLpAoZ2ax6rytjtKxlXZtjqv3uEZEUU49qa9Heiu00ZUvfdTv
	 JeUluL+z6S0Gl18C7b8kyvBkihLCEUg4BxNwcugFILVZXks8aVbACHX/dcR0Nre99mwKD
	 k8tnbM2ullUVAyDdJ26iqC9PhWK1VwH92vqSFIgpXbkRYPWMWNkZfbjyvL0r9uuahfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275612;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=jZbLu0wzSjOdnjAJn+WXuj5iQYYS4qUcPU4E+L4JQbY=;
	b=XC1kn+xHKC7s/dxDrP5YLGUnFr/b+D5DzEYZ/WErG+lAf+VXJtINO8XbmcjZvokphXMd
	 CKXhLm4OqMbf6jSk0nvcABuUBOMtkgRk42Yw5GfWCEkw5seg3CEPs2sRqcnFNn+LVuVXq
	 e9cj98FK7BRjoZ4ZCNVoWoUTK8HeewZLJGG3aghe9gH5pm5hppPrDlP9P69K9VR3tfT6G
	 DYG2z/JkYTygL5dLuIF4zxWmdpXvHlpxyt/AHzI4rXpK7MAg4Xix/KZN58Rst68nJJnjy
	 DLYPGpR1PljiKRtG3P9L0vdrr7sTnbXmd+s1CjKPEISWjqSko3eetUXCaIxFa/mGJFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bo9O2Jkw;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C48606A31F;
	Thu, 29 Oct 2026 12:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74C48606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bo9O2Jkw
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A18D1BB2;
	Thu, 29 Oct 2026 05:06:47 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09DC83F673;
	Thu, 29 Oct 2026 05:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793275610; bh=XuWqiX8GeiKnGK/0kw5HiwXWVYKheY7gCYzp1RS3dQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bo9O2JkwLOS7LGpq9ufyaBMHKJAyRLCQQUNFQeXJmMvGyV9Ow2p9BmXWD+O5wgtKK
	 0NTO/+3bHJSwx0SYyMwOzqehHeOFKu4M/hQWA9xKlna72cHxmebLV0qvJkeca0VnaB
	 Jg3Wac3Ss3af0VKYKctrzqCeZvHnjSdOJMUY0iwk=
Date: Thu, 29 Oct 2026 17:36:47 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-efi@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Hanjun Guo <guohanjun@huawei.com>, Sudeep Holla <sudeep.holla@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [RFC 00/12] arm64: Add support for TLBI domains
Message-ID: <upkds2ymzuztqvxxuysm62lxcdv5oa3ji6xrxbnz3yt3vntbp6@rw54ndtnpz3y>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261001110655.461473-1-kristina.martsenko@arm.com>

Hi Kristina,

On Thu, Oct 01, 2026 at 12:06:43PM +0100, Kristina Martšenko wrote:
> Hi,
> 
> This series allows the kernel to use TLBI domains. TLBI domains (FEAT_TLBID) is
> an Arm architecture feature that enables a TLB invalidation to target a subset
> of CPUs instead of the whole system. It can improve performance on systems with
> many CPUs. TLBID is not yet part of the Arm Architecture Reference Manual but
> some of it is described in the latest XML [1].
> 
> The goal of this series is to send TLBI commands only to the CPUs where a
> process has run (i.e. where its page tables have been installed). The last

Lets say if we have a TLB domain of 8 cpus and a process has ran on only
one cpu, dont we end up broadcasting to all cpus in the domain as the 
granularity is at the domain level ?
If thats true, would be good to make that clear.


> patch explains a bit about how it works. This is an RFC since I'm not familiar
> with the kernel's TLB/mm code and I'd like feedback on whether the general
> approach is correct.
> 
> A few notes and open questions:
> 
>   * Domains are described in a new "TLBI" ACPI table. This is not yet part of
>     the ACPI specification. There was an initial proposal [2] but this series
>     uses a newer WIP version of the table that aims to be published by the end
>     of the year.
> 
>   * There is currently no device tree binding since the feature is mainly meant
>     for server-class systems.
> 
>   * It's also possible to use TLBI domains to limit a KVM guest's TLB
>     invalidations to CPUs where the guest has run. I'll try to include that in
>     the next version. This series only disables domains for guests.
> 
>   * With this series a long-running process may eventually run on all CPUs and
>     just issue broadcast TLBIs. It may be worth periodically reducing the set
>     of CPUs but it's not clear when.

Do you have some thoughts on how we could reduce the set of cpus, to avoid
cross domain scheduling ? 
IIUC, this should me more of a scheduling decision with domain awareness. 


Thanks,
Linu Cherian.
