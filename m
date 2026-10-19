Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCEB4908C8;
	Mon, 19 Oct 2026 07:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792396224; cv=none; b=jz1tbZ/HfN2beGFJyKFC5zdc2s86EpVDC9EWXx5PuJFARTWgZAnXSR8db1q0dvPYtJeRj7dcFKTknEtZzuB0wAiWcWAtUG8h9D//M8lfs9+6WiHsfQCT1KE2JWzqJ54VEgOBtEWAKRBILHYG9bzxh6yTIghBXNApEDjzYv2jJqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792396224; c=relaxed/simple;
	bh=q6nzKWe/Qe1MwaN18sAYpKN7gyI/txGOIUnkyLgTQvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=n1nsTz30TY9/05YcFMb0y7sPK5O8j2OUq0v7+Kye2O4jyTuQvLOIjIg0rjGrZoxMXFq6KbtAxSzI+qsD+zCelV/fVQaQP5j/JTv3TJ8xCs3y1EXNfwEG0DvL2dMH5ZVHNzBeWbtMQHgTkLZ3KHNmJDcuQX12Oxhnimwc2nvL8pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=YNnmNWHz; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="YNnmNWHz"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TfWxx76uGZPAx8muZb+AM8rdjUCDSsgdX5aqqxf1ygs=;
	b=YNnmNWHzcUWkPqEB70mQCx/3LrJHVntKBiorFx2yuGzGuXBMZGsS5m3s7i+MVMPpNingdYxcJ
	dSbPfSOOUuGelLhPxFklSehjTiMP5AdXzNPG+Hp4MHTlEUgBwjYePfzuEIXikra/ulYGXw+c2vS
	vv3T+GOGL/E/c4JyJugKQ2g=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4j7SPl1wLvzcb4D;
	Mon, 19 Oct 2026 15:50:03 +0800 (CST)
Received: from kwepemk300013.china.huawei.com (unknown [7.202.194.231])
	by mail.maildlp.com (Postfix) with ESMTPS id 66CFB4057F;
	Mon, 19 Oct 2026 15:50:09 +0800 (CST)
Received: from [10.67.121.183] (10.67.121.183) by
 kwepemk300013.china.huawei.com (7.202.194.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 19 Oct 2026 15:50:08 +0800
Message-ID: <2c90472e-b178-4d11-9e55-5faf4fc579c8@huawei.com>
Date: Mon, 19 Oct 2026 15:50:06 +0800
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 07/12] arm64: tlbid: Set up CPU domain bitmaps
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
 <20261001110655.461473-8-kristina.martsenko@arm.com>
From: Jinqian Yang <yangjinqian1@huawei.com>
In-Reply-To: <20261001110655.461473-8-kristina.martsenko@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300013.china.huawei.com (7.202.194.231)

Hi,

On 2026/10/1 19:06, Kristina Martšenko wrote:
> +static int __init init_cpu_domain_bitmaps(struct tlbi_domain *domains)
> +{
> +	int cpu;
> +
> +	cpu_domains = kcalloc(nr_cpu_ids, sizeof(*cpu_domains), GFP_KERNEL);
> +	if (!cpu_domains)
> +		return -ENOMEM;
> +
> +	for_each_possible_cpu(cpu) {
> +		cpu_domains[cpu] = bitmap_zalloc(domain_count, GFP_KERNEL);
> +		if (!cpu_domains[cpu])
> +			return -ENOMEM;
> +
> +		for (int i = 0; i < domain_count; i++) {
> +			if (cpumask_test_cpu(cpu, domains[i].cpus))
> +				set_bit(i, cpu_domains[cpu]);
> +		}
> +	}
> +
> +	return 0;
> +}
The same minor issue: init_cpu_domain_bitmaps has a memory leak per CPU
if bitmap_zalloc() fails during execution, the allocated bitmap will be
leaked.

Thanks,
Jinqian
