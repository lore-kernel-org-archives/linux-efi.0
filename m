Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A523AF647;
	Tue, 15 Sep 2026 08:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789462185; cv=none; b=thqFYEU5J2cIZQJkWBXL1zE80kXB5v0rVgaaXTt+ZN7RVxStOsC2IqnoBr5oyPxcwjw4KIcXrMGkMhOST7y0DFQhVCLbIOr4/1PYM/mp03dbtTqQbBMY8hItZABajAfMbivCy24EEHixismaiDRsxuR7hcVsvUgH6+cnyG/BQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789462185; c=relaxed/simple;
	bh=oyNHMyZYqpDoIcovpuHq/8xHd5nxJXQeaDtXcCz49N0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNsfm+GZpgkT1r/5MbBdMIwta/4w/ucYhGp1m2Dtt1ZAkaDeUo0ymOybcz1qjqU2zG+AcZg+IkXB7oPXSZWiiEdULlLuiDDKS449dHUSCj9Jehez21hHXPdaH8J6JY189rMgZQdTiRaWrEKLrfxl6X9j/XIEt4cT9xOhuDLYzhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H5C5ag1n; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H5C5ag1n"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 725DA169C;
	Tue, 15 Sep 2026 01:49:38 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C1A53F7B4;
	Tue, 15 Sep 2026 01:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789462182; bh=oyNHMyZYqpDoIcovpuHq/8xHd5nxJXQeaDtXcCz49N0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H5C5ag1nVPLPhe55qsjBPQBbtGvhwI+EZy4hOGcyjOPWYcUe0GpC4S0V9JgcZN0nb
	 obKGCOQNx/hPY4kiy/lcgwTHy3lNzQowHJtLPL4gljGbLWzPav4p4nS+1oGuQbStlp
	 QVdzo86jLuagwOj0unB4MjzirpKKKS0SsTW4ZI4s=
Date: Tue, 15 Sep 2026 09:49:38 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Breno Leitao <leitao@debian.org>,
	"sami.mujawar@arm.com" <Sami.Mujawar@arm.com>
Subject: Re: [PATCH] firmware: efi: add a separate timeout for UpdateCapsule()
Message-ID: <aqkGohQYChzkBPZ7@e129823.arm.com>
References: <20260903113238.2291844-1-yeoreum.yun@arm.com>
 <960e985e-b338-4648-a29b-1f8a31e00599@app.fastmail.com>
 <apl_29t7Jxr2mv9C@e129823.arm.com>
 <44097058-9fdc-4e9f-a277-d63e3876b035@app.fastmail.com>
 <23ce2fb0-1002-409f-bb84-f592db9d0b89@app.fastmail.com>
 <apmFpUvkRBgMdOH2@e129823.arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apmFpUvkRBgMdOH2@e129823.arm.com>

> > On Thu, 3 Sep 2026, at 16:29, Ard Biesheuvel wrote:
> > > On Thu, 3 Sep 2026, at 16:10, Yeoreum Yun wrote:
> > >> Hi Ard,
> > >>
> > >>> Hello Yeoreum Yun,
> > >>> 
> > >>> On Thu, 3 Sep 2026, at 13:32, Yeoreum Yun wrote:
> > >>> > On platforms that allows to update firmware in runtime, UpdateCapsule()
> > >>> > may immediately write a firmware image to persistent storage.
> > >>> > This operation can take longer than EFI_RTS_TIMEOUT.
> > >>> >
> > >>> > Use a separate timeout for the UpdateCapsule() runtime service. By
> > >>> > default, wait indefinitely to avoid interrupting an ongoing firmware
> > >>> > update. Administrators may configure an appropriate timeout, in seconds,
> > >>> > through /sys/firmware/efi/capsule_update_timeout.
> > >>> >
> > >>> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > >>> > ---
> > >>> >  drivers/firmware/efi/efi.c              | 41 +++++++++++++++++++++++++
> > >>> >  drivers/firmware/efi/runtime-wrappers.c | 14 +++------
> > >>> >  include/linux/efi.h                     | 10 ++++++
> > >>> >  3 files changed, 55 insertions(+), 10 deletions(-)
> > >>> >
> > >>> 
> > >>> Given that UpdateCapsule() is rarely used these days at runtime, I
> > >>> wonder if we should just call it synchronously instead of via the
> > >>> EFI workqueue.
> > >>> 
> > >>> I assume that would also solve the timeout issue?
> > >>
> > >> Might be. But it would make *non-preemptible* for UpdateCapsule().
> > >> AFAIK the purpose of running runtime service with efi_queue to
> > >> run it in indepdent context and to be preemtible in case of arm64.
> > >>
> > >
> > > No.
> > >
> > >> Since most of UpdateCapsule() will be called via capsule-loader's misc
> > >> device, if UpdateCaspule() is called synchronously, It would be
> > >> non-preemtible in arm64 platform.
> > >>
> > >> But, some platform could be preemptible while updating firmware so
> > >> I think it would be better that it would be called via EFI workqueue.
> > >>
> > >
> > > EFI runtime service invocations are preemptible on arm64, so this is
> > > not a problem.
> > 
> > Ah wait - you're right, they are only preemptible when invoked from the
> > work queue.
> 
> Yes. That's why I think it would be better to call via EFI workqueue
> when I see arch_efi_call_virt_setup().

Hi Ard,

Could there be any issues with doing it this way, or would there be
a better approach?

-- 
Sincerely,
Yeoreum Yun
