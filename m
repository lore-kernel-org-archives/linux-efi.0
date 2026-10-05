Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9F92FE05C;
	Mon,  5 Oct 2026 08:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189629; cv=none; b=QC5+GHL3sjh+yuJD8QU2tBxhU4NZkSqJQpfMSsRsOCJX48t78OsZnr2MVwNIl12/ar6rXfvnsMMnTk2teQJiUB46xxwjjaTIArThksTi5q/HHz5Q5V9p20EdVxI5TD/GS+3PKnSsUXryfugt7Dcf2VRdQv6bT2/ldXpAxK+Jj9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189629; c=relaxed/simple;
	bh=7vYwjN3r+v7sr4u0OEkpPtVQ+McQ8rLbBPFktzyUxlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oj84WeGItLil/99YLl3lw+Av7Iz+Mci4ahwnJAt50aqkIwaxC3kvvEU4KtKVTId4GgocHHphapT/ju6w8H4L4bOTAPfdhYhmYkf2a/rB9J9TmlPIBE215UnT+XXLuALZPCKK4+qD/dRkHToCY0jYrMDie/2mWBiEDiICs2Pp69I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6+39s7d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6+39s7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424981F000FF;
	Mon,  5 Oct 2026 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791189628;
	bh=OT4fTCBzl6ea0tdPBPkwmD3TW36PNhwwmU38PY2NoAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e6+39s7dojdpn57bOln9SdDj77kq3GXuRYOEc4Gm39fJlu+B2J/ZduPGUzr2efObT
	 ZJCz5CLam8qehPkkIiHWC9jzLo3mbRxMAiB0RJeUV+4ZL9MYllSjQTLYPwROymbka+
	 /A9UrZ086Z+ROMSV2wwSGb42pHPwLLGNQN42B+Q2AyiweuXbm6yNToUbPIVFDfWnrZ
	 5pUNCRKMbaMq/gwluzf4zY6NOH6phd+zrdxfjBwHun7aTaj8N3zCnHhNq/l8/qwmkJ
	 /shnVG5aWIu8LPx3Ht11qTeruxeOAxBd60wsX7qutlSBYYeZohg7Ka92o6+vKGC4QD
	 d1dHjZyOZkTqw==
Date: Mon, 5 Oct 2026 01:40:17 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-efi@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [RFC 00/12] arm64: Add support for TLBI domains
Message-ID: <asNicWUtP4v1ti19@kernel.org>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <87mrsu3gql.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mrsu3gql.wl-maz@kernel.org>

Hey,

On Sat, Oct 03, 2026 at 05:12:50PM +0100, Marc Zyngier wrote:
> Hi Kristina,
> 
> On Thu, 01 Oct 2026 12:06:43 +0100,
> Kristina Martšenko <kristina.martsenko@arm.com> wrote:
> 
> [...]
> 
> >   * It's also possible to use TLBI domains to limit a KVM guest's TLB
> >     invalidations to CPUs where the guest has run. I'll try to include that in
> >     the next version. This series only disables domains for guests.
> 
> My take on this is that just like MPAM, it makes little sense to
> expose this to guests. As long as the L0 hypervisor has the means that
> to scope TLBIs to the relevant domains (subset of CPUs to start with,
> but hopefully SMMUs eventually), we're good.

Err... I think TLBID is quite useful in a VM and unlike MPAM should
actually be virtualizable.

Think of a case where a VM spans multiple chiplets, the VMM will likely
affine vCPU threads to a particular chiplet and present a virtual
topology to the guest. If those underlying chiplets map to TLBI domains
then it seems beneficial to expose virtual domains to the guest.

Even for VMs that fit within a single domain, you'll still need VMM
participation to scope the virtual domain correctly and affine the vCPU
threads appropriately.

I don't think this needs to happen as part of the initial enablement, no
issues with hiding the feature for now. We can revisit the topic later
how the feature is expected to work for KVM.

Thanks,
Oliver
