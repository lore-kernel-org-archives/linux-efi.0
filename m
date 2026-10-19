Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5390447DD44;
	Mon, 19 Oct 2026 08:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792399935; cv=none; b=nvFrYrxe64NiGQS67N/EAUAnLuq3WAkWwSZzTz+xZd+BD3hTjoJt2JtEiuD2iiTgo0rl9k7SmMhk+n7I2cTMW5PfMvL1MYam3PL223lhFjKKrHe4LyBgj8ixgGSOge7bfSailw/at2A2NJaQSyvEUWotdZAZAjHM5e4hVG2EZR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792399935; c=relaxed/simple;
	bh=MUCbYR8v18SbB6OH/HVYNU3LttmfdwnVvjpPi4IMhV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=P3ZTGbRmsWE/URLWHAiL+Vh9CLk3hxAadxeiJQuB/zzyZpSbefOurNGCEFVXAmTe40I0bmjzvKliurPX7YEsJmXMR8gO2kPPSJNi4pgSBIVd/0DrDkg7GEJT3wEP0z2cVQT9fXz2jXnR3pTWO8tQjxwz6t2w9kIuAIsLFz+NF48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=GT1bZLoW; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="GT1bZLoW"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9RA/hcHJY3Xat3tCcIdPXsEW1mdR/MAvb3pTyuaKtH8=;
	b=GT1bZLoWEeUhVI9pHxVGG5Ih5t07PJ7PhNfPRlbaE6gxZFAUryRnYskkR/n2v4K6+kzhR3gNZ
	GFY97Pdf5N+UsxDTpm2dJa7f5PXuLu/jkhwrISX8RblokF3/07EYt7DotxFJMl8Kpy6VH79B1q0
	qJGqGHYJkgZmEVNFdymwEF4=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4j7TnJ4Sr4z1prlN;
	Mon, 19 Oct 2026 16:52:04 +0800 (CST)
Received: from kwepemk300013.china.huawei.com (unknown [7.202.194.231])
	by mail.maildlp.com (Postfix) with ESMTPS id 47EFD40575;
	Mon, 19 Oct 2026 16:52:07 +0800 (CST)
Received: from [10.67.121.183] (10.67.121.183) by
 kwepemk300013.china.huawei.com (7.202.194.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 19 Oct 2026 16:52:05 +0800
Message-ID: <9eb6e0fe-5d8a-499c-b19b-ce73fe982451@huawei.com>
Date: Mon, 19 Oct 2026 16:52:04 +0800
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/12] arm64: Add support for TLBI domains
To: =?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-acpi@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <linux-efi@vger.kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Linu
 Cherian <linu.cherian@arm.com>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>, Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Fuad Tabba
	<fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden
	<seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
From: Jinqian Yang <yangjinqian1@huawei.com>
In-Reply-To: <20261001110655.461473-1-kristina.martsenko@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300013.china.huawei.com (7.202.194.231)

Hi,

On 2026/10/1 19:06, Kristina Martšenko wrote:
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
> patch explains a bit about how it works. This is an RFC since I'm not familiar
> with the kernel's TLB/mm code and I'd like feedback on whether the general
> approach is correct.
> 

Thanks for posting this series.

I'm working on the KVM side of TLBID, and have a series that
virtualizes TLBI domains for guests. It includes:

  - per-vCPU vDomain configuration via a new capability and
    two ioctls
  - VTLBID_EL2 programming at vCPU load/put, mapping vDomains
    to physical domains
  - a guest visible TLBIDIDR_EL1 with virtual domain counts,
    and conditional exposure of ID_AA64MMFR4_EL1.TLBID

You mentioned you planned to look at KVM support in your next
version. Would it be OK for us to post this as an RFC on top
of your series? :)

Thanks,
Jinqian

