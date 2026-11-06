Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962950;
	b=xMTwQV0B8G2BAZ88jlVYSYvnwWZxQy2H+mMYv480s1eefsTRVIDyv0h3pzHVz5bLwYKV
	 M3uCT5A8p2ZPs2NVcf5G+fU2QCb8/Tc8EvWanmd5TZImdqslC6DhV4ZeRz5HYiFcvxu2D
	 LgHaPdk5zbQGxqawzjLEJqZZ5FrxUtoaT5vlfx31YQmB9HnMJGtsVDtWaJpVkfLQvByBe
	 kYg0MJ8I6NxoOftzum0QAVol9UXYUKO19MTNrwnbn5/TNmkq9LXyTZFZgNfFuFWS4NEO3
	 NrXXZf2L+MPlcdhLJ1DnHEu5QjTP3AVsisedGNqZsMPMG/lvNar68bk354n7fC4WYow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962950;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=1EX2YTA7N1m8201rWClNkOLoSBkj+pXHUt+FjNqM5s4=;
	b=FkP+1+Njoaaazawc3l0W4VjeugHaXg6I6CCARGMiPSaR9OoM8IHX2KcCKW0RVShKbyoc
	 QdqJYkoJP0n2/Ld3qn51kc0D5V/kEsp9cGox583OKO+V7XowbDZKgcMqYodWl1YUNlcQV
	 68djoUM+uLfNGT1+wN59BkhqIHK/GuMdeFi4Ok9IuMojvcii3dNhtae4SHilHer/kgvF8
	 cuhQqrNehDq/ok6p3UytD5w8Mwa0EHccLqw6J8PJ6fIpn0giTxL+JYWmfiIw6zBZv0UJm
	 rk8hf/ktEBuQuLjPRA+acNKhcc2t6f6z3jqd+CWzREqBAb9ClvGWuKuqvp83WPhhUhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=IXdLbkhB;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770D7606A329;
	Fri,  6 Nov 2026 11:02:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 770D7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=IXdLbkhB
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 858CB1650;
	Fri,  6 Nov 2026 03:02:25 -0800 (PST)
Received: from e142392.arm.com (e142392.arm.com [10.2.213.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C208D3F673;
	Fri,  6 Nov 2026 03:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793962948; bh=vViXHVIoIW/K//DPywNrgxXC6rqNmWDghWNtpvorf90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IXdLbkhBeUk/3GjTjz8gzknsqr/4kj0JpHND7lmwR/llHNS/s8WDy/vGxCwPqCAUv
	 qNSnIjh162159EV7AtA2tqB2EiVb3NrdpSDa2Z4HJaWSxTxCMynmutIanTjxBGP7/h
	 t3OQ1zlrwiTXg3/kQLIYdW3r0WTMGfjLEdp9E2i4=
Date: Fri, 6 Nov 2026 11:02:17 +0000
From: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: Linu Cherian <linu.cherian@arm.com>
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
Message-ID: <r7vnudhgumcjrhoo7iiv2nckxhhoax6k2d2xlquehfzv3f3dyk@idottvqbcjtr>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <upkds2ymzuztqvxxuysm62lxcdv5oa3ji6xrxbnz3yt3vntbp6@rw54ndtnpz3y>
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
In-Reply-To: <upkds2ymzuztqvxxuysm62lxcdv5oa3ji6xrxbnz3yt3vntbp6@rw54ndtnpz3y>

On Thu, Oct 29, 2026 at 05:36:47PM +0530, Linu Cherian wrote:
> Hi Kristina,
> 
> On Thu, Oct 01, 2026 at 12:06:43PM +0100, Kristina Martšenko wrote:
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
> 
> Lets say if we have a TLB domain of 8 cpus and a process has ran on only
> one cpu, dont we end up broadcasting to all cpus in the domain as the 
> granularity is at the domain level ?
> If thats true, would be good to make that clear.

Yes that’s true. Linux can’t change the domains and the smallest domain
can contain 8 (or more) CPUs. I’ll add a note about it in the cover
letter to make it clear.

> > patch explains a bit about how it works. This is an RFC since I'm not familiar
> > with the kernel's TLB/mm code and I'd like feedback on whether the general
> > approach is correct.
> > 
> > A few notes and open questions:
> > 
> >   * Domains are described in a new "TLBI" ACPI table. This is not yet part of
> >     the ACPI specification. There was an initial proposal [2] but this series
> >     uses a newer WIP version of the table that aims to be published by the end
> >     of the year.
> > 
> >   * There is currently no device tree binding since the feature is mainly meant
> >     for server-class systems.
> > 
> >   * It's also possible to use TLBI domains to limit a KVM guest's TLB
> >     invalidations to CPUs where the guest has run. I'll try to include that in
> >     the next version. This series only disables domains for guests.
> > 
> >   * With this series a long-running process may eventually run on all CPUs and
> >     just issue broadcast TLBIs. It may be worth periodically reducing the set
> >     of CPUs but it's not clear when.
> 
> Do you have some thoughts on how we could reduce the set of cpus, to avoid
> cross domain scheduling ? 
> IIUC, this should me more of a scheduling decision with domain awareness. 

Sorry, the wording is unclear here. This is not about reducing the set
of CPUs that a process runs on, it’s about optimizing the domain bitmap
of a process such that it only contains CPUs that the process is active
on. Currently we only remove domains from the bitmap but never put them
back, even if the process is no longer running on a given CPU and its
TLB has been flushed. So we may end up removing all domains except the
broadcast-all domain.

This isn’t trying to avoid cross-domain scheduling or to change
scheduling at all.

Also, having thought about it some more, I’m not sure if this series
should try to optimize the domain bitmap at all, since it will require
synchronizing with the domain update in switch_mm(), which will add
overhead and needs to be benchmarked on TLBID hardware first (which we
don’t have yet).

Thanks,
Kristina
