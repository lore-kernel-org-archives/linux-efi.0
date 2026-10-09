Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E70130F7E8;
	Fri,  9 Oct 2026 01:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791509376; cv=none; b=GhytGm21qdcQa+kTqFuRaEix/u0igxROUsmOz/vfQO8Q7FcZ8WI+Ml/SIu7TdxtfFi20l7HthfnpOVe3RKyJo9E3YkwobKm30TLs6Q7VyF+brGMn21aSA5eJMGPp8Zu/WDA0huciL6TA10VWed04QFV43ENpJTY6Dqu2JIhCVz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791509376; c=relaxed/simple;
	bh=jH/l6x487aXDmqSSrS3m30THASRA0bXnGuiuLhFqz9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksPa2a1taTeCVIENzafwB/YGjmaYr/BgkFEHBN4pWGHz3lLq2urTF+Va3u9GbbWLzr/aV+NvvNVLXe5E3qwnfS6ObgmXzNH80n9irLKb+9+e4Y50yN/uRszqsi0E6oVhu4F9CoSzdNwjSWFYRZqu2oALb+pofp2flDlquUVcq1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aIC2PZ73; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aIC2PZ73"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8C2A1692;
	Thu,  8 Oct 2026 18:29:30 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4AD283F8C6;
	Thu,  8 Oct 2026 18:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791509374; bh=jH/l6x487aXDmqSSrS3m30THASRA0bXnGuiuLhFqz9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aIC2PZ73HdBqmdUfdPvQ7G9DGX8bh4oZr79sFC/dusbcGocrbnPFUaBVxWSQ2gWG+
	 ATVGW3RmooxUzXX4LK3IIX406QcmqKZoJnYpoD1jTRvZjdlfw5Vfy76utfqDi3jViy
	 5DueC8mHYK6Z7pKmFAH391smGA1D4Gf2bycJcxDY=
Date: Fri, 9 Oct 2026 02:29:30 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Breno Leitao <leitao@debian.org>,
	"sami.mujawar@arm.com" <Sami.Mujawar@arm.com>
Subject: Re: [PATCH] firmware: efi: add a separate timeout for UpdateCapsule()
Message-ID: <ashDevpqfxNKx4nz@e129823.arm.com>
References: <20260903113238.2291844-1-yeoreum.yun@arm.com>
 <960e985e-b338-4648-a29b-1f8a31e00599@app.fastmail.com>
 <apl_29t7Jxr2mv9C@e129823.arm.com>
 <44097058-9fdc-4e9f-a277-d63e3876b035@app.fastmail.com>
 <23ce2fb0-1002-409f-bb84-f592db9d0b89@app.fastmail.com>
 <apmFpUvkRBgMdOH2@e129823.arm.com>
 <aqkGohQYChzkBPZ7@e129823.arm.com>
 <b6602c6e-4c77-4dcf-8683-95b5c8fc4693@app.fastmail.com>
 <aqwO0EdIwzBQlnmW@e129823.arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqwO0EdIwzBQlnmW@e129823.arm.com>

On Thu, Sep 17, 2026 at 05:01:20PM +0100, Yeoreum Yun wrote:
> Hi Ard,
> 
> > 
> > On Tue, 15 Sep 2026, at 10:49, Yeoreum Yun wrote:
> > >> > On Thu, 3 Sep 2026, at 16:29, Ard Biesheuvel wrote:
> > >> > > On Thu, 3 Sep 2026, at 16:10, Yeoreum Yun wrote:
> > >> > >> Hi Ard,
> > >> > >>
> > >> > >>> Hello Yeoreum Yun,
> > >> > >>> 
> > >> > >>> On Thu, 3 Sep 2026, at 13:32, Yeoreum Yun wrote:
> > >> > >>> > On platforms that allows to update firmware in runtime, UpdateCapsule()
> > >> > >>> > may immediately write a firmware image to persistent storage.
> > >> > >>> > This operation can take longer than EFI_RTS_TIMEOUT.
> > >> > >>> >
> > >> > >>> > Use a separate timeout for the UpdateCapsule() runtime service. By
> > >> > >>> > default, wait indefinitely to avoid interrupting an ongoing firmware
> > >> > >>> > update. Administrators may configure an appropriate timeout, in seconds,
> > >> > >>> > through /sys/firmware/efi/capsule_update_timeout.
> > >> > >>> >
> > >> > >>> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > >> > >>> > ---
> > >> > >>> >  drivers/firmware/efi/efi.c              | 41 +++++++++++++++++++++++++
> > >> > >>> >  drivers/firmware/efi/runtime-wrappers.c | 14 +++------
> > >> > >>> >  include/linux/efi.h                     | 10 ++++++
> > >> > >>> >  3 files changed, 55 insertions(+), 10 deletions(-)
> > >> > >>> >
> > >> > >>> 
> > >> > >>> Given that UpdateCapsule() is rarely used these days at runtime, I
> > >> > >>> wonder if we should just call it synchronously instead of via the
> > >> > >>> EFI workqueue.
> > >> > >>> 
> > >> > >>> I assume that would also solve the timeout issue?
> > >> > >>
> > >> > >> Might be. But it would make *non-preemptible* for UpdateCapsule().
> > >> > >> AFAIK the purpose of running runtime service with efi_queue to
> > >> > >> run it in indepdent context and to be preemtible in case of arm64.
> > >> > >>
> > >> > >
> > >> > > No.
> > >> > >
> > >> > >> Since most of UpdateCapsule() will be called via capsule-loader's misc
> > >> > >> device, if UpdateCaspule() is called synchronously, It would be
> > >> > >> non-preemtible in arm64 platform.
> > >> > >>
> > >> > >> But, some platform could be preemptible while updating firmware so
> > >> > >> I think it would be better that it would be called via EFI workqueue.
> > >> > >>
> > >> > >
> > >> > > EFI runtime service invocations are preemptible on arm64, so this is
> > >> > > not a problem.
> > >> > 
> > >> > Ah wait - you're right, they are only preemptible when invoked from the
> > >> > work queue.
> > >> 
> > >> Yes. That's why I think it would be better to call via EFI workqueue
> > >> when I see arch_efi_call_virt_setup().
> > >
> > > Hi Ard,
> > >
> > > Could there be any issues with doing it this way, or would there be
> > > a better approach?
> > >
> > 
> > Would it make sense to simply have different limits for UpdateCapsule() and
> > for everything else? How much longer than 2 minutes do you need in the
> > typical case?
> 
> Although the time required to complete a firmware update depends onthe platform
> and other factors, such as whether the capsule contains a single firmware image
> or multiple images, it is generally reasonable to expect the update to complete
> within 10 minutes.
> 
> If, for some reason, an update is expected to take longer than 10 minutes,
> the sysfs interface for configuring capsule_update_timeout would be useful.
> 
> This would allow the timeout to be adjusted as needed, for example to
> 15 minutes, before capsule update. 
> 
> Am I missing something?

Gentle ping in case of forgotten.

-- 
Sincerely,
Yeoreum Yun
