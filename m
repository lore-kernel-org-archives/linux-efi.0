Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911FA419303;
	Fri, 10 Jul 2026 11:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783682816; cv=none; b=Tu8GEr7Bpf8tR6Gjn4OzKsBC9l/LHbWM7rIWZ6kN9DjOF6/kGrFmK88xJIyEOkXwrQ7Syzdntyj0mtJ+B/MYjvkubpXR9+KrZwHDo/pzrcqPlqDkqOYEmCeUAHvULghQZCYoUYebirMh8RLcUjIed0fVZRDtcdJUakk9fkkb1pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783682816; c=relaxed/simple;
	bh=r1AN1sg+kEl2QNZWVBBf72Yu7BjRN7kZCK6BZNSlkOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HStVTIcrfbVO87A2g7AVP+BfJhiZH9xAPKfQB7bLNfD2rOO8RRDAzTwFksuUMReq+Ig/CNV8mz3CZ+viF88nDnycVcw/FgI1wU5DEvWmKNkKgVUB7VuO31Vs7vL/8bZY+EdX8mD+Vcif8KDi52HDGkRHnRr7eYzJ1aKNLUCA/TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h7907AdB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h7907AdB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3000B1E4D;
	Fri, 10 Jul 2026 04:26:43 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F26F03F85F;
	Fri, 10 Jul 2026 04:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783682807; bh=r1AN1sg+kEl2QNZWVBBf72Yu7BjRN7kZCK6BZNSlkOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h7907AdBjdOPhjN3Ii5bhLDDLRawDPCIMnf6wn5p+Yx/laJ2CR317CgvH73Wsbyt0
	 GNurl1HpeZeq1A3YoMsyGarbAeSDhAL7t0PnIhQUn/NJ+qNKnA3vKhzmTnujwP1Zz7
	 pyqvoioOvn9OEk7630tOoVb2+mHGunxDfxmEVKtA=
Date: Fri, 10 Jul 2026 12:26:42 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
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
Message-ID: <alDW8vjjU_f7dkIK@e129823.arm.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>
 <ak9GEtPuFv_1Sqcw@e129823.arm.com>
 <alDJNWZdBpkIZrcM@gmail.com>
 <alDMRabP9s6Pqhxq@e129823.arm.com>
 <alDTjHtL5Q4ormKb@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alDTjHtL5Q4ormKb@gmail.com>

> On Fri, Jul 10, 2026 at 11:41:09AM +0100, Yeoreum Yun wrote:
> > > Hello Yeoreum,
> > > 
> > > On Thu, Jul 09, 2026 at 07:56:18AM +0100, Yeoreum Yun wrote:
> > > > 
> > > > One of my concern is for the UpdateCapsule runtime service.
> > > > It might have a case where takes more then 2 mins and there's one
> > > > RFC to support a runtime capsule update for arm platform [1].
> > > 
> > > I'm not familiar with UpdateCapsule. Are you suggesting that a 2-minute
> > > wait for an EFI call should be acceptable (?!)
> > > 
> > > Wouldn't that trigger stalls and hung-task/wq warnings throughout the
> > > kernel?
> > 
> > Might for default config timeout for hung-task. However at least
> > its timeout configurable.
> > 
> > TBH, normally it wouldn't task more than 2 mins.
> > But for a in case of *slow firmware*, would be good to make
> > runtime-service timeout configurable at least?
> 
> OK, that is fair request.
> 
> I would suggest we do an additional patch with this change, if Ard is
> positive on the idea.
> 
> Yeoreum, would you like to do it, or should I do it?

It's up to you. I don't care who will do this :)
But if you have no bandwidth, I'll take once your patch is merged
and Ard agrees for this.

Thanks!

-- 
Sincerely,
Yeoreum Yun
