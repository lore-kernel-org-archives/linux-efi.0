Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86001FDA61;
	Wed, 14 Oct 2026 11:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791976569; cv=none; b=WHNtif1ZD9owDgIplEzlCRmhWgG69DhyYvI6Md0KJo3rxuIb09hxfezB3GhyI717UTt1kUncDDHWy82IZy3o9NKWq7F2MiL8GrUl0dXayfsyx4GZjxLOJ+81xky4AwILTpEA7YvLIp07h/x+qDHsYxh8J38H/mOFLlUnc7quI0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791976569; c=relaxed/simple;
	bh=ANIAZeCI49ncIAOn1Qx2otz/JAKnr5/P8kBp6eTpMrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rw75xOiCoX+DcbQjCWp5duGopNoQbm55BunPFNyijpEnpKIBHNy7ifZpXRETecaws6f5zQzymzivbr4riO2V0+z27iIdCw/Xx7OPT03Twa5oaWHch9YkXceme9C5+IcBCXLcsnqWmbkQ5SalGIt58szzDztmOYjrvCnqtRPyp8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SytKuFCW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SytKuFCW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1C801595;
	Wed, 14 Oct 2026 04:16:04 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DED1B3F673;
	Wed, 14 Oct 2026 04:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791976568; bh=ANIAZeCI49ncIAOn1Qx2otz/JAKnr5/P8kBp6eTpMrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SytKuFCWS+BbRIFJTXkQLfw8lOGTZHvB7LP2L+hrcByURwa4n8cmYCnHTAqG9KcT6
	 kkb20HoZ6AKC7ZODxhIn717hTrduKf7droq6LEwt5N1zJi8e9VJiq+vY7WDBzefPmS
	 zzDS/ENefiLXAXptt1riIpAx5vKzOvyssCvRQrpg=
Date: Wed, 14 Oct 2026 12:16:04 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"sami.mujawar@arm.com" <Sami.Mujawar@arm.com>
Subject: Re: [PATCH] firmware: efi: add a separate timeout for UpdateCapsule()
Message-ID: <as9kdBzoGNEEj0Gi@e129823.arm.com>
References: <20260903113238.2291844-1-yeoreum.yun@arm.com>
 <960e985e-b338-4648-a29b-1f8a31e00599@app.fastmail.com>
 <apl_29t7Jxr2mv9C@e129823.arm.com>
 <44097058-9fdc-4e9f-a277-d63e3876b035@app.fastmail.com>
 <23ce2fb0-1002-409f-bb84-f592db9d0b89@app.fastmail.com>
 <apmFpUvkRBgMdOH2@e129823.arm.com>
 <aqkGohQYChzkBPZ7@e129823.arm.com>
 <b6602c6e-4c77-4dcf-8683-95b5c8fc4693@app.fastmail.com>
 <aqwO0EdIwzBQlnmW@e129823.arm.com>
 <asjQqEKdF6YiMXxU@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asjQqEKdF6YiMXxU@gmail.com>

> On Thu, Sep 17, 2026 at 05:01:20PM +0100, Yeoreum Yun wrote:
> > > > Could there be any issues with doing it this way, or would there be
> > > > a better approach?
> > > >
> > > 
> > > Would it make sense to simply have different limits for UpdateCapsule() and
> > > for everything else? How much longer than 2 minutes do you need in the
> > > typical case?
> > 
> > Although the time required to complete a firmware update depends onthe platform
> > and other factors, such as whether the capsule contains a single firmware image
> > or multiple images, it is generally reasonable to expect the update to complete
> > within 10 minutes.
> > 
> > If, for some reason, an update is expected to take longer than 10 minutes,
> > the sysfs interface for configuring capsule_update_timeout would be useful.
> > 
> > This would allow the timeout to be adjusted as needed, for example to
> > 15 minutes, before capsule update. 
> 
> In this case, if you have a worker that takes 10-15 minutes, will not 
> the workqueue stall kick in ?

Hi Breno,

Sorry for the late reply. I was on holiday.

If the default value of 30 seconds is used, it would trigger the workqueue
stall warning. However, AFAIK, wq_watchdog_thresh is configurable, and
platforms where the operation is expected to take longer than 30 seconds
should configure it accordingly.

What I want to tell is  capsule update timeout should be configurable
depending on the use case, rather than hardcoded at least.

Thanks.


-- 
Sincerely,
Yeoreum Yun
