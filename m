Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793110986;
	b=uT6IAJal2SDj70J7AxEDStP3l5b1+O3Pp81epYl7vHPMtb3LtuZX1OCjLtPAaoMcOULK
	 Jb9q19E0MQOqfRi9XDjaJTUE0KmM6vpkTQNzjQqO+NfiIt8P66njhm/hXcXxgVnBL/IK0
	 pRTtL3RSn9yFAwRrLjs//ioZvILN4KD+7r7p2r9L62RbPAmbQ38+jWqqHHYtlti+J+wyn
	 FNjVDcgSdojNXA+5HDZcMBzSVyYx65yWNkSNJMC5kD40znD92JUlUYQ+jQVaMtEKHT+t8
	 pecMCJWvNMEwXkCLZDERd0OKZ3C0zLZe0pgqlJ216GW9KW40Y0WQwNFLU5j0sou2Qkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793110986;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=YCM1R6dVVWvuIH+UBR6TH5CMJ3bKt8HZdVGd2g1zmYs=;
	b=z9AeNlRFon0u9D0Q1fpxdUaEYGJ10tAMWD64dG6KaE1qszoVwT9P/K+4vYCbw1T/8JXa
	 mXQK3E+ttRGS5QRV5q/UeByfEEeTkijuEsSqi6E6gpFHmrnml1tdOu3E+U1Zc+5GIFa6q
	 Q6isp1N+qjsijWUBi96XPgqbyYaK+8vCL1SqL5AWudtelyVHpJkhgNaZQL4ATd0aZurk2
	 uO7BdsztJE18x/YO72/QIy0biVI9UobXvVkgTqOinup2IMdvsFJhNqX1kx6S4sYhsiNZk
	 McOtwxguxd0j5Up/XM0ALANp3r7QEMV2GTbgTp1LSUdkIeLDWDZi7hIqSQX9mkdhSOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Y1y72I7Z;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281AE606A31A;
	Tue, 27 Oct 2026 14:23:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 281AE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Y1y72I7Z
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4A8F15A1;
	Tue, 27 Oct 2026 07:23:00 -0700 (PDT)
Received: from e142392.arm.com (e142392.arm.com [10.2.213.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7565A3F7B4;
	Tue, 27 Oct 2026 07:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793110984; bh=5oj/0Olu6P0vOlAuhliwwyRovCufR2SAkrdb83vbrEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y1y72I7ZZgHOwDZ52neOkUJTOFHLGM6SpPrLJVlApi2ONKuPpXy5gvo/YDy6bjRdY
	 UjZ8l/7y5kF6noVILXl0H6e+7Nb7KYz93CLjCCr7D1N2FQkJe6kC1ZNYqjb4NZfw1c
	 kqwUht3UItiP8Y9UtMdtZaMB+dEp84ku6EU01etY=
Date: Tue, 27 Oct 2026 14:22:50 +0000
From: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: Jinqian Yang <yangjinqian1@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-efi@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Linu Cherian <linu.cherian@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Hanjun Guo <guohanjun@huawei.com>, 
	Sudeep Holla <sudeep.holla@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [RFC 00/12] arm64: Add support for TLBI domains
Message-ID: <cs3tsczrky7egqzde6gnsf7l22t53jit3cygtwe56yfeka5ue7@zesz6zptww3v>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <9eb6e0fe-5d8a-499c-b19b-ce73fe982451@huawei.com>
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
In-Reply-To: <9eb6e0fe-5d8a-499c-b19b-ce73fe982451@huawei.com>

On Mon, Oct 19, 2026 at 04:52:04PM +0800, Jinqian Yang wrote:
> Hi,
> 
> On 2026/10/1 19:06, Kristina Martšenko wrote:
> > Hi,
> > 
> > This series allows the kernel to use TLBI domains. TLBI domains (FEAT_TLBID) is
> > an Arm architecture feature that enables a TLB invalidation to target a subset
> > of CPUs instead of the whole system. It can improve performance on systems with
> > many CPUs. TLBID is not yet part of the Arm Architecture Reference Manual but
> > some of it is described in the latest XML [1].
> > 
> > The goal of this series is to send TLBI commands only to the CPUs where a
> > process has run (i.e. where its page tables have been installed). The last
> > patch explains a bit about how it works. This is an RFC since I'm not familiar
> > with the kernel's TLB/mm code and I'd like feedback on whether the general
> > approach is correct.
> > 
> 
> Thanks for posting this series.
> 
> I'm working on the KVM side of TLBID, and have a series that
> virtualizes TLBI domains for guests. It includes:
> 
>  - per-vCPU vDomain configuration via a new capability and
>    two ioctls
>  - VTLBID_EL2 programming at vCPU load/put, mapping vDomains
>    to physical domains
>  - a guest visible TLBIDIDR_EL1 with virtual domain counts,
>    and conditional exposure of ID_AA64MMFR4_EL1.TLBID
> 
> You mentioned you planned to look at KVM support in your next
> version. Would it be OK for us to post this as an RFC on top
> of your series? :)

Thanks for sharing.

I’m starting to look at KVM support but I’m not working on exposing
domains to guests. I’m looking at if we can track which CPUs a guest has
run on and transparently redirect all of a guest’s TLBIs to a single
domain that contains those CPUs. This could be a fallback in case the
guest is not configured to have virtual domains itself (which your
series enables).

I think there is some overlap between what we’re doing (e.g. configuring
VTLBID), but also lots of separate parts. So no objection from my side,
please feel free to post your series.

Thanks,
Kristina

