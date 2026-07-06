Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338C43DDB1A;
	Mon,  6 Jul 2026 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783342666; cv=none; b=fazya5BUqkpf7te4jKEKUF2sqhAT5G/u0mta3fzWHBmhOwFw/DF2F5V0J4XByOJuGHYXDOMXGN0qJXyL0Kh2O9MkSS9HnzvvaMEa3ZX6IaEGV4q0zwiKiBZNIUw2GDNKclPfZ035m7N2i5pI8JKnBWlEQ8zpBNfpbr6t9OVeaCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783342666; c=relaxed/simple;
	bh=tC2spD3U/GH5bblbsDUr2dwxWjOG4BtVw6VfclWtIu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=goPM1ZrXzpt6rnuxefC2zItqQvSb6J2s3iNOxtL1SWPEOtdgiD5i62mTl7WVsrOdqf6UH5cg5pvwYuR+WI063NfPuvmwm2YDDlTlQgZoBCnPIn/8Y0zpymu/+EHYZHcSlkZZnZ1opuWdRDbsNqkXwp0EyoE9f+UeGFaqb1hP3+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=NU2eZAxZ; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="NU2eZAxZ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HWGOFzpCq+iP0+0NjVv6uf8SWmRqy5AkRECjfy5Liok=;
	b=NU2eZAxZ55qGUQI+YpTRECwMn3mUleshFzTu8GaqJ7oGc0o+5nKlL18Zw5tGVc8jpnUvftU5f
	r+MqWqXHAjirTDpbZDYX66nsoRnSXiapg16NuApCiK/oXELFEHIEi8xDUoY4MYPdEvSKPX8WZF/
	Igdc02D3OV+yI9LYaruaEA4=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gv41B2TcqzpSvH;
	Mon,  6 Jul 2026 20:49:02 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 4509B4058C;
	Mon,  6 Jul 2026 20:57:39 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jul 2026 20:57:34 +0800
Message-ID: <4a2f2262-c945-4bc1-92dd-fc55e4118ba0@huawei.com>
Date: Mon, 6 Jul 2026 20:57:32 +0800
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/17] arm64: Move DAIF macros to ptrace.h and use them
 centrally
To: Breno Leitao <leitao@debian.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <maz@kernel.org>, <ardb@kernel.org>,
	<ilias.apalodimas@linaro.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<oleg@redhat.com>, <mark.rutland@arm.com>, <lpieralisi@kernel.org>,
	<tglx@kernel.org>, <ada.coupriediaz@arm.com>, <anshuman.khandual@arm.com>,
	<ebiggers@kernel.org>, <broonie@kernel.org>, <mrigendra.chaubey@gmail.com>,
	<baohua@kernel.org>, <lucaswei@google.com>, <james.morse@arm.com>,
	<zengheng4@huawei.com>, <thuth@redhat.com>, <yang@os.amperecomputing.com>,
	<leo.bras@arm.com>, <Sascha.Bischoff@arm.com>, <james.clark@linaro.org>,
	<peterz@infradead.org>, <ben.horgan@arm.com>,
	<punit.agrawal@oss.qualcomm.com>, <gshan@redhat.com>,
	<osama.abdelkader@gmail.com>, <fengchengwen@huawei.com>,
	<ryan.roberts@arm.com>, <yangyicong@hisilicon.com>, <kevin.brodsky@arm.com>,
	<kees@kernel.org>, <jeson.gao@unisoc.com>, <zhaoyang.huang@unisoc.com>,
	<ryotkkr98@gmail.com>, <wsw9603@163.com>, <pasha.tatashin@soleen.com>,
	<jeremy.linton@arm.com>, <schuster.simon@siemens-energy.com>,
	<osandov@fb.com>, <arnd@arndb.de>, <zhangpengjie2@huawei.com>,
	<smostafa@google.com>, <vladimir.murzin@arm.com>, <tabba@google.com>,
	<vdonnefort@google.com>, <kaleshsingh@google.com>, <jic23@kernel.org>,
	<timothy.hayes@arm.com>, <alexandru.elisei@arm.com>, <zenghui.yu@linux.dev>,
	<david@kernel.org>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<memxor@gmail.com>, <qperret@google.com>, <chaitanyas.prakash@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-efi@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-2-ruanjinjie@huawei.com> <akfl8VwB-RkHIFgm@gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <akfl8VwB-RkHIFgm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)



On 7/4/2026 12:44 AM, Breno Leitao wrote:
> On Fri, Jul 03, 2026 at 06:01:19PM +0800, Jinjie Ruan wrote:
>> So move the definitions of DAIF_PROCCTX, DAIF_PROCCTX_NOIRQ, DAIF_ERRCTX,
>> and DAIF_MASK from <asm/daifflags.h> to <asm/ptrace.h>. 
> 
> This seems a bit counter intuitive, to have DAIF definitions at
> arm/ptrace.h instead of asm/daifflags.h, no?

If we keep them in <asm/daifflags.h>, we would hit a circular dependency
issue when <asm/daifflags.h> and <asm/ptrace.h> try to include each
other to resolve types.

> 
>> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
>> index 9393fe3ea6a1..cbe2a616c726 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/host.S
>> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
>> @@ -11,6 +11,7 @@
>>  #include <asm/kvm_asm.h>
>>  #include <asm/kvm_mmu.h>
>>  #include <asm/kvm_ptrauth.h>
>> +#include <asm/ptrace.h>
> 
> ..
> 
>> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> index 89cb553be1e5..26ea02e7f5fd 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> @@ -15,6 +15,7 @@
>>  #include <asm/kvm_asm.h>
>>  #include <asm/kvm_mmu.h>
>>  #include <asm/pgtable-hwdef.h>
>> +#include <asm/ptrace.h>
> 
> And then you need to do this in many low level files, which sounds less
> intuitive to have to have ptrace.h include instead of asm/daifflags.h
> (which is clear why we need it).
> 
> --breno

