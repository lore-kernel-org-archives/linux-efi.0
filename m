Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707CD48875D;
	Mon, 19 Oct 2026 07:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792395489; cv=none; b=g8/JZH1YOjuq1vyRSzvMWZvqh50Xcvhtugg6Yn78nhS0TlWqBPcQPzdI+6sgnCGnJ85MdJk/xON3M8QtKOeKmcvsexb6H9l33xWFN4ociQtZZabYUJtapLw/hWW8pcw3DwDSj0zvSoIHRM8+WAV7e/5jNReQ+Bju9lRfVGGmwYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792395489; c=relaxed/simple;
	bh=EALUpi89F8vG8tau0PZutc7ETFh24LQ10NG5a1YgYP0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lqKE3mhCdRRLeM5Hr5mS8ECwFJ22OWufk5vZXCXFUv3sBazMoxjMe+c/5tMalcvZ3IfWaIpuZFxEwopeU951FcIUSIWDBpowIkBybe2le27ww+x/6q6TuqbQVT2WOyMZkzB4IMVFsqmGHKUmjqJAoSTInejCFnKUAiaG0gQG5eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=oUtFqMPX; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="oUtFqMPX"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dl5RLVgDUnKMmfwkyYpV+I64OLaYgtn2GgeN1aSXzxk=;
	b=oUtFqMPX256inh7nC7a+6PjRlRe1sqcp+mWOt6JQZCRkpGSMf5H8qLiMbX8sCSKJoI+nPSTnr
	fPGZUtnBPFPu/404GHMvOpJF0YS9cvIRkEaXNv/uKSuyEpoWhXRD+/9jcT1PqkfkYXW7vduDrv4
	rtVICoS3BdIIXxZ0JSxO/D0=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4j7S7s1VHnz1prRJ;
	Mon, 19 Oct 2026 15:38:01 +0800 (CST)
Received: from kwepemk300013.china.huawei.com (unknown [7.202.194.231])
	by mail.maildlp.com (Postfix) with ESMTPS id D70DB40575;
	Mon, 19 Oct 2026 15:38:03 +0800 (CST)
Received: from [10.67.121.183] (10.67.121.183) by
 kwepemk300013.china.huawei.com (7.202.194.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 19 Oct 2026 15:38:02 +0800
Message-ID: <49e48aac-8d84-4786-9e3e-04e1c2fef020@huawei.com>
Date: Mon, 19 Oct 2026 15:38:01 +0800
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 06/12] ACPI: TLBI: Parse domains from table
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
 <20261001110655.461473-7-kristina.martsenko@arm.com>
From: Jinqian Yang <yangjinqian1@huawei.com>
In-Reply-To: <20261001110655.461473-7-kristina.martsenko@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300013.china.huawei.com (7.202.194.231)

Hi,

On 2026/10/1 19:06, Kristina Martšenko wrote:
> +static int __init parse_tlbi_table(void)
> +{
> +	struct acpi_table_header *table __free(acpi_put_table) =
> +		acpi_get_table_pointer(ACPI_SIG_TLBI, 0);
> +	u32 offset;
> +	int ret;
> +
> +	if (IS_ERR(table))
> +		return PTR_ERR(table);
> +
> +	tlbi = (struct acpi_table_tlbi *)table;
> +	if (tlbi->header.length < sizeof(*tlbi) ||
> +	    tlbi->domain_count > MAX_TLBI_DOMAINS)
> +		return -EINVAL;
> +	if (!tlbi->domain_count)
> +		return -ENOENT;
> +
> +	domain_count = tlbi->domain_count;
> +	domains = kcalloc(domain_count, sizeof(*domains), GFP_KERNEL);
> +	if (!domains)
> +		return -ENOMEM;
> +
> +	offset = tlbi->domains_offset;
> +
> +	for (int i = 0; i < domain_count; i++) {
> +		struct acpi_tlbi_domain *domain = tlbi_get_domain(offset);
> +
> +		if (!domain || domain->id > U16_MAX)
> +			return -EINVAL;
> +
> +		domains[i].id = domain->id;
> +		if (!zalloc_cpumask_var(&domains[i].cpus, GFP_KERNEL))
> +			return -ENOMEM;
> +
> +		ret = parse_tlbi_domain(domain, domains[i].cpus, 0);
> +		if (ret)
> +			return ret;
> +
> +		offset += domain->length;
> +	}
> +
> +	ret = validate_tlbi_domains();
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +void __init acpi_tlbi_init(void)
> +{
> +	int ret;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_TLBID))
> +		return;
> +
> +	ret = parse_tlbi_table();
> +	if (ret) {
> +		if (ret != -ENOENT)
> +			pr_err("Failed to parse ACPI table\n");
> +		return;
> +	}
> +}

The error paths in parse_tlbi_table() return without freeing
"domains" or the cpumask already allocated.

Thanks,
Jinqian

