Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A6E3290B1;
	Mon,  5 Oct 2026 06:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791181801; cv=none; b=EJ/9qSyTe5KJyVfH1h/PGe9UTMm2EZhA+7GK2u3QByFztwfKSK/P8Av3a2h+wrhY9xdYaWNollaK/2ovM1Cy1zmL0JLVjiqNuWMbps9QNKM8qlbFmC02V1j1kPqTaClgDuhYwEYqwF0rhnUVSAOZFbf6bEJ3IKGyAxxKmV3fmK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791181801; c=relaxed/simple;
	bh=TyO4u2KWK78c9gO8VxFyI8mKQKwpEe8Vs33LhFo7sMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A4OoGk+gVtpOF0uP1cQAwEV+bAo4wvV1IESpfwBCuSOMjbvzbSmotwYmxb3dwXAuVwneEsE8ZmfQ41FBz7/1lrcBF+cwdfupfotdf/0vjCqk+t72LD3QbSQZCkEUIG6bAcpiNRCNOeMgyRRtRe0O/qWg8CiHMvLlLgY3IjTfSnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFHs0RI0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFHs0RI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E65B1F00893;
	Mon,  5 Oct 2026 06:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791181800;
	bh=NMXP+3HOcHF428TlVrg2cs9+rmnJKLTevmDSSnYryBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gFHs0RI0vQiYN70xLjJK6AIYAhKscdvLrr5shld7PhX2KZychrY1pspfUyGMIyjgR
	 mbkFt9Cb7WMu6rmV0YK7D6FB1RqQpIwcnjbvH/a8zwzdISBXeDxfcPXSds6DBbys25
	 UPDLmNmI5IR8DhAvnAxyD7B0lABLUqOm8rN5+XVq/cKEJprw7em17Xe35a7kBMxQnj
	 2nIkE+qQq91I2LBKt5owi+zYqepp7uqZU1R5dNPMIPeduKfGwHtf9JvyuvaHBtbPLX
	 oSWkiCiwB41mvjZxskSm+7HDZWrGWb6aVcllIiebe2luvrsOd4VQUN7q9UO4HkfmtL
	 EZb5je/2vyG6w==
Date: Mon, 5 Oct 2026 07:29:51 +0100
From: Will Deacon <will@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-efi@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-mm@kvack.org
Subject: Re: [RFC 00/12] arm64: Add support for TLBI domains
Message-ID: <asND3-Wnb2hiDAop@willie-the-truck>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <DLW95E2XWSVT.8W90FW4WG6K8@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DLW95E2XWSVT.8W90FW4WG6K8@nvidia.com>

On Sun, Oct 04, 2026 at 02:06:48PM -0400, Zi Yan wrote:
> On Thu Oct 1, 2026 at 7:06 AM EDT, Kristina Martšenko wrote:
> > This series allows the kernel to use TLBI domains. TLBI domains (FEAT_TLBID) is
> > an Arm architecture feature that enables a TLB invalidation to target a subset
> > of CPUs instead of the whole system. It can improve performance on systems with
> > many CPUs. TLBID is not yet part of the Arm Architecture Reference Manual but
> > some of it is described in the latest XML [1].
> >
> > The goal of this series is to send TLBI commands only to the CPUs where a
> > process has run (i.e. where its page tables have been installed). The last
> 
> IIUC, mm_cpumask() is used to store this information on x86 and other
> archs. I see you put this information in tlbid_domains of mm_context_t
> from patch 9, although in the form of tlb id domains. I wonder why not
> make arm64 also update mm_cpumask() like x86 and other archs and derive
> the tlbid domains based on mm_cpumask() and a cpu-to-domain mapping
> (added in patch 7).

Historically, maintaining mm_cpumask() was a horrible source of contention
when we looked at it in the past. Maybe that's no longer true, but it
would be good to see some numbers if we want to start keeping that thing
accurate on arm64.

Will
