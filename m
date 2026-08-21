Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B516645FFA0;
	Fri, 21 Aug 2026 12:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787313821; cv=none; b=ZM5fp+5XiQBPrW3oTUAb6Hr+/nKRyNdRaK9wZpWKZCG3aWgtrPIZ8Xbb/DdgdfyeizxB5MaSWT44mSf51niDt8HQI2lU/4rfoT1RiE+1/X5TLO7ddjoPUwmSByf5oyN9t8ittQFJ/zK0qArPsnR+rWBjyjMeDWGmrZ3IuKyylOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787313821; c=relaxed/simple;
	bh=PJd1cPkAf0dmLVFLQtG/2H5ZyBgdoCwhCtQXOUQXglc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bmybAOS93jaVny1OMRLDc25rUY7JrjGf0jYZR4oSwUtdr4oCyKN4aUxOZwvEKzfKCGFKr725CgPo+itXngQZ9aPbKrfhPwQ8EEAFk5VBA96QNFg2CZlOQoXhNBOXCzExoYvyOZDImjhvcUIcvZGZLAJcqUMuWqQ3vgJv1hk+XOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FW9VNZWW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FW9VNZWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C4D1F000E9;
	Fri, 21 Aug 2026 12:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787313814;
	bh=CPHwxj7cgfi/sRFO/JKzf12L/v93WRQC6iXrX/2UKjo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=FW9VNZWWcJRWeOTsfqG/VhlOIWFBxJVwe8qQ5oJ/6a+dgxXFiuOpleuNfo9Kkc0oN
	 fHUnbSoLU47lPBjGpbLd+GTnToWJMfgE8eYvsOwQyYGZoyeRKRZDW5gVfbv8ptCjeP
	 mJaQcjqZeExwsqMZ75PrZ4/GkUrYy5pePxw9k1XndOqQ2MTJN0p6wU8vJuqI5d6Z85
	 h9addDWDBzemyOtuPqhXh3Gw3q8MMCJie0Q6FJA1FuutruSnBMf5KBF7Ryb4po7Pba
	 R1geGg21BhmJ+PWE32ng98qsO9u0picoefL+3Pl3+RVNqPH4ZPWk+VylifnTNONXTY
	 zQtrFIATDMPbQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Breno Leitao <leitao@debian.org>,  Ard Biesheuvel <ardb@kernel.org>,
  Ilias Apalodimas <ilias.apalodimas@linaro.org>,  Miaohe Lin
 <linmiaohe@huawei.com>,  Naoya Horiguchi <nao.horiguchi@gmail.com>,
  Andrew Morton <akpm@linux-foundation.org>,  linux-efi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  rmikey@meta.com,
  riel@surriel.com,  kexec@lists.infradead.org,  kernel-team@meta.com
Subject: Re: [PATCH v2 2/6] efi: add the LINUX_EFI_POISONED_MEMORY
 configuration table
In-Reply-To: <aog7bwfMVpSy9LcY@thinkstation> (Kiryl Shutsemau's message of
	"Fri, 21 Aug 2026 12:51:34 +0100")
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
	<20260821-hwpoison-kho-v2-2-5743791e48e6@debian.org>
	<aog7bwfMVpSy9LcY@thinkstation>
Date: Fri, 21 Aug 2026 14:03:30 +0200
Message-ID: <2vxz5x13znn1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Aug 21 2026, Kiryl Shutsemau wrote:

> On Fri, Aug 21, 2026 at 03:06:02AM -0700, Breno Leitao wrote:
>> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
>> index 29e0729299f5b..69c0dc02bc112 100644
>> --- a/drivers/firmware/efi/Kconfig
>> +++ b/drivers/firmware/efi/Kconfig
>> @@ -263,6 +263,16 @@ config EFI_COCO_SECRET
>>  	  virt/coco/efi_secret module to access the secrets, which in turn
>>  	  allows userspace programs to access the injected secrets.
>>  
>> +config EFI_POISONED_MEMORY
>> +	bool "Carry hardware-poisoned pages across kexec"
>> +	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
>> +	help
>> +	  Record page frames that are hardware-poisoned while this kernel runs
>> +	  into an EFI configuration table, and honor that table early on the
>> +	  next kernel so a kexec does not hand known-bad RAM back out.
>> +
>> +	  If unsure, say N.
>> +
>
> Do we want to make it conditional? Maybe just for everyone with EFI_STUB
> && MEMORY_FAILURE?

+1. Each config we add is a decision someone has to make when compiling
the kernel. If they rely on the default, they will miss out on this
fairly useful feature.

So, is there any downside to just doing this by default without any
config?

-- 
Regards,
Pratyush Yadav
