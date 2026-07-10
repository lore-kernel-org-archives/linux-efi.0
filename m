Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10E7408001;
	Fri, 10 Jul 2026 10:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783680076; cv=none; b=Y0LxnCKwVm8/Dx65ZGk/HZ7nrXG3PlTZz2iRmhAYnxTAMwRdCDPc1uALYwqtXBdRWYb4cB6XUSvK16rHjACCRslC3o2odCI9ITn1e1wLJvlOsyENcXC7uIvITbbbO+6iSQGWqaN99mpa4W32DA7Et6S26W0toBG/uFOEdxT0Ec4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783680076; c=relaxed/simple;
	bh=4Qke2xJsR2sXwK0I4gvKYKDPFfPo8IyCKD4XHCDwxuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o19PgmXP0IzRK8t96VAW5gOdF0vv2cXX+NfBQgvvBL9eAP3u9M1xonRT8YBI6rvAt1VmiSiMXHG1LODUflE/3X9XfaPtQZfMqubZhK3K85AhNevudUuruGEsfWG+6qDeYT0vrpxwQ5k/Z2AaAE0+9ckiCdgXcR8UvVdFR2xYFPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uulKf2rd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uulKf2rd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F3E31D15;
	Fri, 10 Jul 2026 03:41:09 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7E8A3F66F;
	Fri, 10 Jul 2026 03:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783680073; bh=4Qke2xJsR2sXwK0I4gvKYKDPFfPo8IyCKD4XHCDwxuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uulKf2rdn99A9IDxFQosEukntgFiN1G5OTUZU+jvzGuTgezEks0y5xKArHbh1lpuD
	 8NkAmlIalQ8Ef79d1uR9u0ZEtrj+sHOcL73LZaNT1FMH4Nhx/fYkcAsngiIAUVqmLj
	 ZrB9/5Ynnoy5mre5xI86wYkN93rWGuHdFGLuAfbg=
Date: Fri, 10 Jul 2026 11:41:09 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>,
	Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 5/7] efi/runtime-wrappers: bound the wait for EFI
 runtime service calls
Message-ID: <alDMRabP9s6Pqhxq@e129823.arm.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>
 <ak9GEtPuFv_1Sqcw@e129823.arm.com>
 <alDJNWZdBpkIZrcM@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alDJNWZdBpkIZrcM@gmail.com>

> Hello Yeoreum,
> 
> On Thu, Jul 09, 2026 at 07:56:18AM +0100, Yeoreum Yun wrote:
> > 
> > One of my concern is for the UpdateCapsule runtime service.
> > It might have a case where takes more then 2 mins and there's one
> > RFC to support a runtime capsule update for arm platform [1].
> 
> I'm not familiar with UpdateCapsule. Are you suggesting that a 2-minute
> wait for an EFI call should be acceptable (?!)
> 
> Wouldn't that trigger stalls and hung-task/wq warnings throughout the
> kernel?

Might for default config timeout for hung-task. However at least
its timeout configurable.

TBH, normally it wouldn't task more than 2 mins.
But for a in case of *slow firmware*, would be good to make
runtime-service timeout configurable at least?

-- 
Sincerely,
Yeoreum Yun
