Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04281420495;
	Mon, 17 Aug 2026 13:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973219; cv=none; b=JAaRqVgeiGU+Ix3qB5Ziap1yS0pOqBgLHHms308kovunZS4aoseM+Y5l02fX2DV9lKcsOiKtECO2Qi95uDOeNyGYOSwPXbDNFBF+CWpadekyKg4PQppTfU/AI41vpEezxleeTJ6oCUxZdDYuqCoS588yuGB3300Q1lzQxQN4t3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973219; c=relaxed/simple;
	bh=u+miCiu1XsipyzdOYS6/+K9OR5G8x1N7F7U2faswnqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PKgzL6NWtStwHrjmB3WfYGRcEWbWYGiphX63984VmSdPPzeoKt91jFVTYuKZSjM8e3moD2CPxGx6dbsXMgTVuQCvzfXuBfUwPqieRiPMun/BGXLt5sYK4XZicRaUI3/Q4hSqccUzppia+CATRoeqno64Xc+L5qEUHu9fc+VArO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astier.eu; spf=pass smtp.mailfrom=astier.eu; dkim=pass (2048-bit key) header.d=astier.eu header.i=@astier.eu header.b=HH3IvLu5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MiDgoTyF; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astier.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astier.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astier.eu header.i=@astier.eu header.b="HH3IvLu5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MiDgoTyF"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 18685EC021C;
	Mon, 17 Aug 2026 09:26:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 17 Aug 2026 09:26:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=astier.eu; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1786973217; x=1787059617; bh=n1VjQmtwJ2
	C9h1kBQVUk2eUL1LFVlEhuRUjmzdddrIM=; b=HH3IvLu55vsiFGew72veTJIu+m
	LqYnf03jkLQJHA16M7fcp5BkESGzaaIDVfACueIH6iGFdD0lI5fOTOA/guuobMjI
	QV9nkuAHxHJZDml8L2c0jZVLZC42C9egW6gR3PcGMvb00Hy8euAjBOo97HLh2v45
	1D1iZnRIlxoJCRQm95SeQj4MkdhwiL04Inx8vROVCNWODTvVkqlM3pH+sFM6qPmE
	r8sIUPXyXMF1cKEAP9hJEzyEMlp/OMp72yDwv2uk+L9QEzZfNapyZJJ2RT23Igpr
	IdYPVwZRaVFM7MEF09rbKiFB+L7MJjAMg729TXgzpN4KIy/4VFtFuwFqAKag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1786973217; x=1787059617; bh=n1VjQmtwJ2C9h1kBQVUk2eUL1LFVlEhuRUj
	mzdddrIM=; b=MiDgoTyFdQ09bt8Awf5rT4LTC38crumR6uPHLwxUbqLZt8d2NpY
	+HnbA5YaGqA42Oc9WK92K/Vy13s3hZju+uQCgmZ6UCmWDjLUUPYS/z1l2FzMwPyy
	LbTdWDnddaXum/fAq197dfa5uutIElQXoLiNDw/AYrqYfyuQ+E2zOBROmMjxAX9F
	8nqKNnwLeobsI7/3eZUfFgS1CIA+hxOSBR2ZydyhGPBdQyP2LCS60OHL5B4S5P+Q
	ZDdqDpv7KfsribGH1Wi3jusl1QOb0kP0hqmEscy75/4ouRH5cneEuRHsvc8aaC7H
	UPhifR5basf5RLqXcphCrRMOgh6JZEylTTA==
X-ME-Sender: <xms:IAyDau1U5a6INLUlgECCS-iJtVpYMx2fbOXOO4oXNREM7L5dIm_79w>
    <xme:IAyDailBD9jKtE7CUAi31WoGwV3JemkeuOuE4dpeN5Zv7wJjftrrCzs5Ca5Jw58AA
    oUcZla_xD_3qfJUwpSLJl9qQBTPGGjogjNARnlWIGyr3Dh-ERbuoJ-8>
X-ME-Received: <xmr:IAyDam9R64cLOhSjQra1nImPYpiO4_-ZHzoVdfTCKGr1NNRLJUAPEu9RKwV9vSRSyguapORdFC-mgIS4KA9i7x55_kETAf1y>
X-ME-Proxy-Cause: dmFkZTERlgCRbmyvXXn05yePRcO+O+BgQQqy6iSr093hS7PtDvADrWZAEY00lUBKwdCYdX
    Ml9tkk0SGVjrDhpv85Qtof3yZRlDLUtazCDPcB1Bz5NwuExAT1mUeBSkTM/UaXkJwLrMHV
    U8MXt5Le+PK5ldJs6K2YyukBd27x/oZ58dyRdbaCTPk1qSmGosOLqig0q9186zXmjNaHXW
    DUynHm3WA8CL2jX1Dkgxg+SWzarTAU6HFIfXwGJBlxpvUEZoM83SJFnJmqDbIzZKNnAoo3
    gc6FCoL5QZfdftcdfrIXcbQWNIxNBb6Z+DK2T+oNGlygtCEPloirgbHF3G/7YGlyIYmTht
    lyWconO3ZvyVgUdMmejpTXAJFRE+xwY3eWY2MMPVIDxjHbsKZJ8ayOrkN+H8jF9uwi6Vu5
    zMBGmyrnfCFh3z0OYrvRo0mvhT/wmvV8ULF5cEXR8gSpW2XVH8wUW7CceBmQ+N82/akT/6
    8arD1ghvL6JO1Ome1yxseo7gxXNKgGAteCKpfdRCeCDDfB7vpqTtW8/y3Ibs8ylt78K4HU
    q6WqVNB/4grrOaVAAgIHxVp3O2Pj8bUaHvoHunXuJj+QsGLr3T8QESMM4As/SXoC/T+Doa
    m5PUQODStFQhF19uNdUS8KiEIgkICr8dHFY6hKqhrHTiLLsQ5Wu8wcow+g5w
X-ME-Proxy: <xmx:IAyDavq_q6IIeLE0NEkQnyPFUdzxlwUVlTktcgOBf2dxtlj4qVXbwg>
    <xmx:IAyDanmhTK7lbBFBteVrb6A0QMVq4DGPQjuVFMoUbKcold-qXFWZPg>
    <xmx:IAyDaui3sNC8JCZyF4rYzfhBoh_oPJ22mQL7pOUaN0HLiS3lOI-M5Q>
    <xmx:IAyDancYHKOphoiUxw1JLRv92Y_FwpZfGzuyMQsTQ2WvL9pj4TXfnw>
    <xmx:IQyDasjIaSVBgouEsYWSs1ktxH5yhTwi_5Q0Yc7MOA4w23QNRvFBAlOd>
Feedback-ID: iccec46d4:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Aug 2026 09:26:55 -0400 (EDT)
Date: Mon, 17 Aug 2026 15:26:47 +0200
From: Anisse Astier <anisse@astier.eu>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH] efivarfs: Cache occupied and available space
Message-ID: <aoMMF_P6cdSII-8e@kanto>
References: <20260801144258.15977-2-ardb@kernel.org>
 <anILrU83ClMOZ6hO@PF620VM5>
 <38e0e561-3b51-4c14-8e01-b8b7137199dc@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38e0e561-3b51-4c14-8e01-b8b7137199dc@app.fastmail.com>

Hi,

On Mon, Aug 17, 2026 at 03:11:40PM +0300, Ard Biesheuvel wrote:
> Hi,
> 
> Thanks for the review.
> 
> On Tue, 4 Aug 2026, at 19:01, Anisse Astier wrote:
> > Hi Ard,
> >
> > Please find a few comments below,
> >
> > On Sat, Aug 01, 2026 at 04:42:59PM +0200, Ard Biesheuvel wrote:
[snip]
> >> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> >> index 733c19571f1c..3691a2a087a0 100644
> >> --- a/fs/efivarfs/super.c
> >> +++ b/fs/efivarfs/super.c
> >> @@ -23,6 +23,8 @@
> >>  #include "internal.h"
> >>  #include "../internal.h"
> >>  
> >> +u64 efivar_storage_space, efivar_remaining_space;
> >> +
> > Since those are globals (before they were only local to the function),
> > I'd put them behind a lock now, probably efivar_lock, because we need
> > something that's globally available.
> >
> > statfs could be raced from userspace vs the rest of the code; and
> > efivar_invalidate_cached_storage_space is only called outside the lock.
> >
> 
> Right. So we might inadvertently report zero size and zero available
> space even though QueryVariableInfo() is supported and working correctly.
> Not the end of the world imo, but better avoided if we can.

Yes, I don't think it's that performance sensitive (famous last words),
so putting it all behind a lock is a cheap way to avoid this type of
issue (unless you have a better idea?).

> 
> 
> >>  static int efivarfs_ops_notifier(struct notifier_block *nb, unsigned long event,
> >>  				 void *data)
> >>  {
> >> @@ -82,15 +84,16 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
> >>  	const u32 attr = EFI_VARIABLE_NON_VOLATILE |
> >>  			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
> >>  			 EFI_VARIABLE_RUNTIME_ACCESS;
> >> -	u64 storage_space, remaining_space, max_variable_size;
> >>  	u64 id = huge_encode_dev(dentry->d_sb->s_dev);
> >> +	u64 max_variable_size;
> >>  	efi_status_t status;
> >>  
> >>  	/* Some UEFI firmware does not implement QueryVariableInfo() */
> >> -	storage_space = remaining_space = 0;
> >> -	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
> >> -		status = efivar_query_variable_info(attr, &storage_space,
> >> -						    &remaining_space,
> >> +	if (efivar_storage_space == 0 &&
> >> +	    efivar_remaining_space == 0 &&
> >> +	    efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
> >> +		status = efivar_query_variable_info(attr, &efivar_storage_space,
> >> +						    &efivar_remaining_space,
> >>  						    &max_variable_size);
> >>  		if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
> >>  			pr_warn_ratelimited("query_variable_info() failed: 0x%lx\n",
> >
> > We've had issues with firmware in the past, shouldn't we be a bit more
> > defensive here in case of errors? I'd reset both variables on error in
> > case an incomplete write to one of the variables gives us an invalid state.
> >
> 
> This is a pre-existing issue, right? The only difference being the fact that
> the variables are now globals?

Yes and no. Before, a bad value might be returned once. Now, it might
get inadvertently cached and returned until the next variable
modification.

Yes, this is an edge case, but I think it can be worked around very
easily by either implementing the suggestion above, or simply writing
the values to other temporary variables, and updating the global ones on
success.

> >> @@ -480,6 +486,8 @@ int efivar_entry_delete(struct efivar_entry *entry)
> >>  					    &entry->var.VendorGuid,
> >>  					    0, 0, NULL, false);
> >>  	efivar_unlock();
> >> +	efivar_invalidate_cached_storage_space();
> >> +
> >>  	if (!(status == EFI_SUCCESS || status == EFI_NOT_FOUND))
> >>  		return efi_status_to_err(status);
> >>  
> >> @@ -620,6 +628,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
> >>  				    NULL, size, NULL);
> >>  
> >>  	efivar_unlock();
> >> +	efivar_invalidate_cached_storage_space();
> >
> > In this function, the error path for efi_set_variable_locked (that could
> > have triggered an EFI_OUT_OF_RESOURCES) is not covered by the
> > invalidation.
> >
> 
> Right. So under the assumption that the state of the EFI variable store
> might change even after a failed SetVariable(), the cached values may
> have become inaccurate. Is that what you are saying?

Yes, the actual free space might change but failed to be updated.

> 
> >>  
> >>  	if (status && status != EFI_BUFFER_TOO_SMALL)
> >>  		return efi_status_to_err(status);
> >> -- 
> >
> > Couldn't the variables be written outside of efivarfs as well?
> > efivar_set_variable can be called from other code? pstore could maybe be
> > ignored if it's only used during crashes (I'm not sure), but I see at
> > least one other driver calling it as well. Wouldn't that change the
> > available/free size?
> >
> 
> Yeah, that is a very good point.
> 

FYI, since this patch was initially merged, it helped us catch errors in
production *twice* thanks to existing monitoring on filesystem free
space: bad configurations or logic that wrote too many variables.

I can also see why this type of regular monitoring triggering SMM
rendez-vous of all CPUs might be bad for performance.

Regards,

Anisse
