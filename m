Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770BE41F5D8;
	Wed,  2 Sep 2026 09:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788341706; cv=none; b=VDr859CalZJYFLntNV8G5tTT5vzKHLpDTtVGEyWiAPaW8TS3yfRYWKjIkCf1roIpUoWPwKHfHy2koUqprXqAw1Zb9zst3TgD7yL4nSEQfGyQ4PD0FEEu8jQmtbYGhcKN4c6weXlyK573eIMAWl3abkd9Pn0eCFDNRnLhDVkSIsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788341706; c=relaxed/simple;
	bh=H3bwyw2iZ3rYwpkMDEKE+j0pNhVGyd2GhNusj8uEgYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcAczUpx0LndSZqfbjmFV+0woMlcB5tFQ1a0qfsnBjGnmGvoT/B0NmzCIokmHGNS65jVcaIB3EmQNJC3eIp2enSt29xYCdu1aZs4hHFj3dclz2SZTECpHmpftveAEfIyhBg6YmV5LouwkLVq/4XmgvXsIljRh2JWEatcuuGgsXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RQFtdSYS; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RQFtdSYS"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C2AB1476;
	Wed,  2 Sep 2026 02:34:58 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 235E53F85F;
	Wed,  2 Sep 2026 02:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788341702; bh=H3bwyw2iZ3rYwpkMDEKE+j0pNhVGyd2GhNusj8uEgYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RQFtdSYSbcyPA8zBsDWpEdfa3CU165hfy6Sb+qWDQfvRputwTKzRXfLztTQKYgCwj
	 pVxkqBx5TPskIibxs17PbdC3e2A/wi79t9WSKs06fWolz9mPqFvzvEp9hdbWLmCQga
	 WV1I71GSIh9xQW136ZxVaidnxBdLiyfbp+xCBEws=
Date: Wed, 2 Sep 2026 10:34:57 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>,
	Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 5/7] efi/runtime-wrappers: bound the wait for EFI
 runtime service calls
Message-ID: <apftwY062XjcV5-K@e129823.arm.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>
 <ak9GEtPuFv_1Sqcw@e129823.arm.com>
 <alDJNWZdBpkIZrcM@gmail.com>
 <alDMRabP9s6Pqhxq@e129823.arm.com>
 <alDTjHtL5Q4ormKb@gmail.com>
 <alDW8vjjU_f7dkIK@e129823.arm.com>
 <alD3ZFgfgMj0_qoT@gmail.com>
 <af81fe18-d246-4bd7-b32e-c61ec2e7c856@app.fastmail.com>
 <alS2izWImqj0N_IZ@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alS2izWImqj0N_IZ@gmail.com>

Hi Breno,

> Hello Ard,
> 
> On Sun, Jul 12, 2026 at 07:25:19PM +0300, Ard Biesheuvel wrote:
> 
> > > Sounds good. Let's wait for Ard's feedback on the additional patches
> > > [1], and we can decide how to proceed from there.
> > >
> > > Link: https://lore.kernel.org/all/alDDv3XGXVdd1mri@gmail.com/ [1]
> > 
> > Please send patches against efi/next, I will apply them promptly. 
> 
> Acknowledged. I'll rebase the fixes on efi/next and send them shortly.
> 
> > UpdateCapsule is a special case that we can deal with separately
> 
> Understood. I understand I should defer the configurable timeout work
> for now.

If you don't mind, Could I send the patch?
TBH, If we handle the UpdateCapsule seperately,
I think it seems good to make a exception for capsule update to wait unlimit.

-- 
Sincerely,
Yeoreum Yun
