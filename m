Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C554B2035;
	Thu,  3 Sep 2026 14:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788444648; cv=none; b=N1GohjCjxbQLea67YoxWcofFNypxn4+fL4XN3RcWd0c91myYO62lBQXZrJu3n3/5zaUclPI4tEjDNGri0+dQPI3jhmTBASjgrTgJbJW+3uQbSd11TgJ68dwqNPXcymdnGEjuHcfEMN7h4K7ziE2BSgk5iLKtMU2YYR1bkFnVWjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788444648; c=relaxed/simple;
	bh=pTOzblkFOsyEkX/GrQ+IJftHza01vi5Bwx5axi8Gix8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9qFWji1AQFUdIuvY5ASSMskgF8WNC8l9csmMtKIm9n6ovFFwFNMUoUxLQDE7Z2aBHCc9T+A8dQPaweFH/gMGrDGUwEarGuFoPc/Dq33/r2gGtLUbdQGrJVFGRhdEdSQPXrAOX+WBl4DKvPhfHN7rOT9QNpS4hDVmgKww5TLmgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qM7WEz0v; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qM7WEz0v"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B00711596;
	Thu,  3 Sep 2026 07:10:34 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B0683F673;
	Thu,  3 Sep 2026 07:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788444638; bh=pTOzblkFOsyEkX/GrQ+IJftHza01vi5Bwx5axi8Gix8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qM7WEz0vs7Qs1oAfLO/HSa48Obh0H9vQAL36RlwbGEz+KNhGM7Z5fY7QNjc7RtJgn
	 cdAZc1Npbv0FnmamYEHr1e1Ael9y8Dc0Hv37gy+yur9MBIy0jK3oumlyiX1OQGgGIB
	 nFFrHjaSFIv8LtmepanWYtGt4FV4pdsuWPVa88aQ=
Date: Thu, 3 Sep 2026 15:10:35 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Breno Leitao <leitao@debian.org>,
	"sami.mujawar@arm.com" <Sami.Mujawar@arm.com>
Subject: Re: [PATCH] firmware: efi: add a separate timeout for UpdateCapsule()
Message-ID: <apl_29t7Jxr2mv9C@e129823.arm.com>
References: <20260903113238.2291844-1-yeoreum.yun@arm.com>
 <960e985e-b338-4648-a29b-1f8a31e00599@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960e985e-b338-4648-a29b-1f8a31e00599@app.fastmail.com>

Hi Ard,

> Hello Yeoreum Yun,
> 
> On Thu, 3 Sep 2026, at 13:32, Yeoreum Yun wrote:
> > On platforms that allows to update firmware in runtime, UpdateCapsule()
> > may immediately write a firmware image to persistent storage.
> > This operation can take longer than EFI_RTS_TIMEOUT.
> >
> > Use a separate timeout for the UpdateCapsule() runtime service. By
> > default, wait indefinitely to avoid interrupting an ongoing firmware
> > update. Administrators may configure an appropriate timeout, in seconds,
> > through /sys/firmware/efi/capsule_update_timeout.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  drivers/firmware/efi/efi.c              | 41 +++++++++++++++++++++++++
> >  drivers/firmware/efi/runtime-wrappers.c | 14 +++------
> >  include/linux/efi.h                     | 10 ++++++
> >  3 files changed, 55 insertions(+), 10 deletions(-)
> >
> 
> Given that UpdateCapsule() is rarely used these days at runtime, I
> wonder if we should just call it synchronously instead of via the
> EFI workqueue.
> 
> I assume that would also solve the timeout issue?

Might be. But it would make *non-preemptible* for UpdateCapsule().
AFAIK the purpose of running runtime service with efi_queue to
run it in indepdent context and to be preemtible in case of arm64.

Since most of UpdateCapsule() will be called via capsule-loader's misc
device, if UpdateCaspule() is called synchronously, It would be
non-preemtible in arm64 platform.

But, some platform could be preemptible while updating firmware so
I think it would be better that it would be called via EFI workqueue.

[...]

Thanks!

-- 
Sincerely,
Yeoreum Yun
