Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54F84734C6;
	Tue,  4 Aug 2026 16:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785859267; cv=none; b=G0uzgY3MCSfn3TirUZ/fKY1r+9Z907sJysH+I5L2EwvevC5zAEp4Hf0iVuHh9xfJ3wozasaDPPGYHYXtWhXvD2q/xcANrCTwK5O6sc2VwMm4iDTdPFGupJ+PuOazyJtY52korVrqAnIDDxL6EIc1E6h/9vKGAV8YNNHe23dIr3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785859267; c=relaxed/simple;
	bh=amA/zNFZTLgxeWDrshmk2tq6j/UbuhratCW+sZ0Id6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jt8VKdIqI9Ng+yofJQiWvWXXexkWSz3SlKPLhq6mpmFuLr3MiQru5ZaoP2hbpIONY4xq3F+W8cstqc9zFa9m4t0MK9Xf4Alf1kssGsUbhftIpXsG1fkxu1kB95QohQGpxhw42ZdHFeNDJFbAWrNZE3goZG6cm88Gqr0KMFLVNo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astier.eu; spf=pass smtp.mailfrom=astier.eu; dkim=pass (2048-bit key) header.d=astier.eu header.i=@astier.eu header.b=mXvOOc6D; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=e2KrbUUM; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astier.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astier.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astier.eu header.i=@astier.eu header.b="mXvOOc6D";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="e2KrbUUM"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1FDB37A014A;
	Tue,  4 Aug 2026 12:01:05 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 04 Aug 2026 12:01:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=astier.eu; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1785859264; x=1785945664; bh=WGaGMtoMRE
	M94Sk31ffrXiM7wUJRVVKWVpv6IYqhd9U=; b=mXvOOc6DB2rfC7g4lSRr9JJjbP
	Ll5t8eSZBTCtPTPqLkDB4iCwDbw6dGqMLKw/xqFeFGMioUJmWpKi274QF5YsX9BB
	L34FqmAlwCudM95BTdHByic8gxC0KiN1Kk05jR4nKVh981m4c8D5ezIniJLWgt1n
	ESVF87fzazxjuOsthHN7H3wX7x//F4EJxmE6aCQqqkKOH0xqfuYt8qrlEZjw6iX2
	dZhvNHhPjYvZDXS59hY30KIVVlmvkxka2ZW9p2H0jh09U06FlfQyxmr1bjzfzXY5
	HgXoCozezQp+YY60vyzp6X/9Dz3v7OoibR5uM02+efwGl6/F5bli4hrT1B5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1785859264; x=1785945664; bh=WGaGMtoMREM94Sk31ffrXiM7wUJRVVKWVpv
	6IYqhd9U=; b=e2KrbUUM9uXJbfyG/17bGUIAIdCpqgPYGb1DDosbT/D7gGpcp7+
	4GbGHEPfO3Z+cL4onWz5FDq/m55HtymRZqM1Dy7MmfykMOtpu+QeYb87nPeS2kdC
	I9qli7jksmocGbKJ+dUDDG9HM8bR29RwuMHyVZsIwpLbdp9N/PdCwmmWErouIW2c
	5BWS0xMLN1fq4JuOo+Kdf0JEcb5uGEcLo6L8F552gxssALCwv2FFy+IJDMEc0LjC
	LdDYalegvko2k6X62lYU03zy84czrXegRw3F/moO5GIgkf69Jje2l5hOdXkyJXeI
	BeowLHOzug0IxOnzaxJrgOwtFdXA/idPJcg==
X-ME-Sender: <xms:wAxyaowIh94w3Dnf6p8qcRjHLb7oEIDmJfe39xPynSg1Tyd9pRYOlg>
    <xme:wAxyatyV3d_E0Xv5a0BjQOey4pgHwdbwYlGxbzhwtVdivJ9RSiNJQ82cglBnyFKPj
    o3UKuQ47plvjl2mf-JRwYdFKnRYfM7XBwhIKvLIzbXVx9Rge_9mjRYQ>
X-ME-Received: <xmr:wAxyaqYz4okG8MbgwLMuW1gaOU1E7kx32i0mjGn-mhwD4TmFIOesijZPylY>
X-ME-Proxy-Cause: dmFkZTEqwEKzxuD4pnELxQQmO2GGUhQoBSvYe92M8+k2S/Xr6b8AhthiUB+1wE7at074AV
    9zwKMYE5WV2LvkU8WbZeWwtwfdG2pTWtmIXMp9UbQz/iPE5ZTzTyJRVWDDIdos3jofJ2R5
    5O7R/69aOcBXEXzdomYUsf/IYTyVKUrtlZIjbFmq6JAcV21VjOKNJzZbtmtF3q4pKcO5tK
    hlU/e1z8NEj4QS7ypBt20eEOPOVGCo2uQRo1FpE2f3vmJbSFG44Qyjjp9XSRil/ZUfke1C
    anuFurdH8E2rQ5edNQ56tW2D6soSZh/WV4yDEjVXkG08UYB2/h1597+rvbk6FtrKWZdAWT
    V3AEXKJZFYG4z0ddxbIYWvg/LevRNoNbHR4jxIW069zx2GjWBv7XgEZ6rXCUnTMXmXlB+A
    otpndcVPwW4O3gT7oJF+LLRRDq+opLpIRAgY7qca8omLEo98nOmpTAFKiMklgEarDNPr/U
    u9UiK1jggK6WTsSEOfX6MD82s03IAfDw5M78qpUEi6XCzlDk39qfNNr9LILVCJ2FzL0Cd9
    rTPotUrGxsr9L9iFHn2x9ZnoMGH/NT7kcZQ1m2ymgGN40hZhldb12wM1tvnrJKxENsmUDn
    qFDgZBXWCwoF5VYDVcZsEPc2iVN2fSncD+IzWQ0RRBFjPG9NIk/pe43mI8dg
X-ME-Proxy: <xmx:wAxyamV7u4SG0nMbBA2UR4oSNM7RlAYlbUEgAyTDHUwbwKw2CVlsOA>
    <xmx:wAxyagiQBaIGzoHyI4dxxuPQpsCPHPYHSGbYtvlfqd7YkW8eBlqs2A>
    <xmx:wAxyasvElqqNOBQFS95FcDHAK0NX8j1w-2b3NxNBUXftrywZwW__-Q>
    <xmx:wAxyah6H59R_Vcz2BkRFtRVCGIvdozzbYM3PXINH2eBzNAYOLyN7SQ>
    <xmx:wAxyanOmU55KdkVL3Qho6-6zbU0JvNz6EZllgYNDl4o9OJ36_BYzDfdK>
Feedback-ID: iccec46d4:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 4 Aug 2026 12:01:03 -0400 (EDT)
Date: Tue, 4 Aug 2026 18:01:01 +0200
From: Anisse Astier <anisse@astier.eu>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH] efivarfs: Cache occupied and available space
Message-ID: <anILrU83ClMOZ6hO@PF620VM5>
References: <20260801144258.15977-2-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801144258.15977-2-ardb@kernel.org>

Hi Ard,

Please find a few comments below,

On Sat, Aug 01, 2026 at 04:42:59PM +0200, Ard Biesheuvel wrote:
> Ravi reports that statfs() may be called by unprivileged users on the
> efivarfs mount point, resulting in repeated calls to QueryVariableInfo()
> which are disproportionately costly on x86 systems where the variable
> store is backed by SMM, as each SMM entry requires a rendez-vous of all
> the CPUs.
> 
> So cache the output of QueryVariableInfo(), and invalidate the cached
> values when an entry is added or deleted, or the variable store is
> synchronized after a suspend/resume sequence.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
> Fixes: d86ff3333cb1 ("efivarfs: expose used and total size")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  fs/efivarfs/internal.h |  2 ++
>  fs/efivarfs/super.c    | 21 +++++++++++---------
>  fs/efivarfs/vars.c     |  9 +++++++++
>  3 files changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
> index f913b6824289..d43789bc7839 100644
> --- a/fs/efivarfs/internal.h
> +++ b/fs/efivarfs/internal.h
> @@ -31,6 +31,8 @@ struct efivar_entry {
>  	bool removed;
>  };
>  
> +extern u64 efivar_storage_space, efivar_remaining_space;
> +
>  static inline struct efivar_entry *efivar_entry(struct inode *inode)
>  {
>  	return container_of(inode, struct efivar_entry, vfs_inode);
> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index 733c19571f1c..3691a2a087a0 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -23,6 +23,8 @@
>  #include "internal.h"
>  #include "../internal.h"
>  
> +u64 efivar_storage_space, efivar_remaining_space;
> +
Since those are globals (before they were only local to the function),
I'd put them behind a lock now, probably efivar_lock, because we need
something that's globally available.

statfs could be raced from userspace vs the rest of the code; and
efivar_invalidate_cached_storage_space is only called outside the lock.

>  static int efivarfs_ops_notifier(struct notifier_block *nb, unsigned long event,
>  				 void *data)
>  {
> @@ -82,15 +84,16 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	const u32 attr = EFI_VARIABLE_NON_VOLATILE |
>  			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
>  			 EFI_VARIABLE_RUNTIME_ACCESS;
> -	u64 storage_space, remaining_space, max_variable_size;
>  	u64 id = huge_encode_dev(dentry->d_sb->s_dev);
> +	u64 max_variable_size;
>  	efi_status_t status;
>  
>  	/* Some UEFI firmware does not implement QueryVariableInfo() */
> -	storage_space = remaining_space = 0;
> -	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
> -		status = efivar_query_variable_info(attr, &storage_space,
> -						    &remaining_space,
> +	if (efivar_storage_space == 0 &&
> +	    efivar_remaining_space == 0 &&
> +	    efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
> +		status = efivar_query_variable_info(attr, &efivar_storage_space,
> +						    &efivar_remaining_space,
>  						    &max_variable_size);
>  		if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
>  			pr_warn_ratelimited("query_variable_info() failed: 0x%lx\n",

We've had issues with firmware in the past, shouldn't we be a bit more
defensive here in case of errors? I'd reset both variables on error in
case an incomplete write to one of the variables gives us an invalid state.

> @@ -104,8 +107,8 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	 */
>  	buf->f_bsize	= 1;
>  	buf->f_namelen	= NAME_MAX;
> -	buf->f_blocks	= storage_space;
> -	buf->f_bfree	= remaining_space;
> +	buf->f_blocks	= efivar_storage_space;
> +	buf->f_bfree	= efivar_remaining_space;
>  	buf->f_type	= dentry->d_sb->s_magic;
>  	buf->f_fsid	= u64_to_fsid(id);
>  
> @@ -114,8 +117,8 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	 * when the storage_paranoia x86 quirk is active. To use more, users
>  	 * should boot the kernel with efi_no_storage_paranoia.
>  	 */
> -	if (remaining_space > efivar_reserved_space())
> -		buf->f_bavail = remaining_space - efivar_reserved_space();
> +	if (efivar_remaining_space > efivar_reserved_space())
> +		buf->f_bavail = efivar_remaining_space - efivar_reserved_space();
>  	else
>  		buf->f_bavail = 0;
>  
> diff --git a/fs/efivarfs/vars.c b/fs/efivarfs/vars.c
> index 6833c3d24b54..4196963695bd 100644
> --- a/fs/efivarfs/vars.c
> +++ b/fs/efivarfs/vars.c
> @@ -361,6 +361,11 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
>  	kfree(str8);
>  }
>  
> +static void efivar_invalidate_cached_storage_space(void)
> +{
> +	efivar_storage_space = efivar_remaining_space = 0;
> +}
> +
>  /**
>   * efivar_init - build the initial list of EFI variables
>   * @func: callback function to invoke for every variable
> @@ -450,6 +455,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
>  	} while (status != EFI_NOT_FOUND);
>  
>  	efivar_unlock();
> +	efivar_invalidate_cached_storage_space();
>  free:
>  	kfree(variable_name);
>  
> @@ -480,6 +486,8 @@ int efivar_entry_delete(struct efivar_entry *entry)
>  					    &entry->var.VendorGuid,
>  					    0, 0, NULL, false);
>  	efivar_unlock();
> +	efivar_invalidate_cached_storage_space();
> +
>  	if (!(status == EFI_SUCCESS || status == EFI_NOT_FOUND))
>  		return efi_status_to_err(status);
>  
> @@ -620,6 +628,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
>  				    NULL, size, NULL);
>  
>  	efivar_unlock();
> +	efivar_invalidate_cached_storage_space();

In this function, the error path for efi_set_variable_locked (that could
have triggered an EFI_OUT_OF_RESOURCES) is not covered by the
invalidation.

>  
>  	if (status && status != EFI_BUFFER_TOO_SMALL)
>  		return efi_status_to_err(status);
> -- 

Couldn't the variables be written outside of efivarfs as well?
efivar_set_variable can be called from other code? pstore could maybe be
ignored if it's only used during crashes (I'm not sure), but I see at
least one other driver calling it as well. Wouldn't that change the
available/free size?

Regards,

Anisse
