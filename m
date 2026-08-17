Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023893E95AE;
	Mon, 17 Aug 2026 12:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968726; cv=none; b=W4EOjtDOtYUgklQ8BxI2yn+jb/ldAaHFAxMg2QyLBx2V9+6LpVL+VGuJZHRWWGtRfDQkzjXZg5CBCERE0xnhJ7gS7h3zixs+tH9EAkZqybRrmZABcpzzngXVNgBALXBLrHJXvvTCUPKvRGU0Z4ffoPbioVN65vavgnj/iTGKK+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968726; c=relaxed/simple;
	bh=tWv7jQ4FJsDjnW2YBGSDs7Jeuszle8bDlj/0ZUQ1+xA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=fIk8eoTEM1lFtUZWoKsigalBXshpu1Q0pcYq88LINVHWWdX15PfDRKdIgosfGQuFIZgfSyq2kR1a4+MFSfsrTa6bp9pCb7+lIX0jxz4zvsOD9QSzyx5LauIwGAA9OhXefRYOhTzds9wMElvD8zAeLmNQVy/sC0egSODAPjdjTxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKbivvzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKbivvzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6AF1F000E9;
	Mon, 17 Aug 2026 12:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968724;
	bh=zrCx3RgcjDCn4tPX6xBXQ4RVf1cF/k/mxH5r8avq6hs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=BKbivvzlkFnUFJYnN52gCsw8R9KXK9IHs4tuaygvKZMPyq+oxcCbDNbcNRJ+N5uET
	 QoV12VA78sJZTKKyxNAvFaPdqjdQMOynkR88ftKFZH/3aQ2Q5F1150Bau2OkGBvnRb
	 9q0O6PFPKJ14mSRiUD5w9aotta+pktqCu4iyTrRt4FtF2Rnj/k0VRvR4Q1AyEvYCnv
	 BuX92fUePY7I25+R28TiuPOpap+BVodFAfZcZcRCw+gb9DqyQ9eW+dv2tVVNuypDOR
	 tZrT6EjOmFkwZOaCM99eD0IPZZpqEC/tI0jve/xefvcQwImV+TB5OCkRPznIl73NQS
	 QEATaxA1yAoxQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id BAC1E198006E;
	Mon, 17 Aug 2026 08:12:02 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 17 Aug 2026 08:12:02 -0400
X-ME-Sender: <xms:kfqCarxBmSL2IcLWWkhrjHRXX4fG_S5U-0Lb5pE6Mx-brnYsaZOlMA>
    <xme:kfqCauG4LunYfAc-COiJLJ0VFQgBWp60zxRqlw41DWMTMIxsBSo8qVZu1CfoAqKrW
    uI8ZG00pqHOST6H07e8z743yfrreyEFOcs2hr0wl9V3bzM1k2xzQfc>
X-ME-Proxy-Cause: dmFkZTFJcUl3oizwCJSjr7/2yDV0QPn6YzR7tNqZC6tX1pv5HJLA+SZp1rKM8JyL05HHve
    ZFXkcprd2fZ3648mb47pmUAII6S3GoG1eaRo6iXuA8U7eHTKjNxGcil1X+rmaxAF9G5Wbs
    P02JsyPZL+0QcuB68mdvcdj+8wgc5QS7yRdmmJWVbt3cQG41X1pa1cvzF9Ylu4EqXlz4Wc
    tskOTVC5mYOZuj7Rit/kwLycOJZtjve03+E+WQnj0HLfJFjcsWwMWOBvi1Pnnpoe5By26k
    NlYASIyL3WqBVZNyMxwsIaVpPCeFaW4Fa2jwudTVoFiJHn8TzYinK5fwNYUda2Un8CAMMt
    tTKtQ9q4PXmX6Kt2m59ekp8sN5fUC3VDD1E5ECn2l84LRz2eWp8gTl2+6WPSNY6NKXEgrW
    BwBHFWSCTw9f/YLlN01JV/w1itsvQynFDwgbRDyC+tdyAHzk67rR0rchIA6MH9wthjV80Z
    gcJ+yEYqFl45Daqo0phUTcACI3mWDsjGmkLnquEVY4FPeYOEUDCBUeQZ2Qpu6IcM5rS1W4
    kHPLqNgAp6wGJq3HjYttbVAjQRgBvdjXQfq29qYYKGED9MIko3nfM8qo9u+q4cS0kumzS6
    ChwPq5ZoJo/Fmpwd5Nb2rRj2LN4kJnK6IUKVz2Z8oHR0nVhxJFO26zydvfQg
X-ME-Proxy: <xmx:kvqCau_w1IVoZRPf3WYyoE54Zhi6ToykRoSuaP40UcXrXGDDMJweew>
    <xmx:kvqCanqpca7nzLDnoLS67C-vgXpJbdEYZ204rJmLxUH68j4WdcCLLw>
    <xmx:kvqCavkMWsNnUkcovEMWmK_hcwigswk87V2Hml3bVId4q2DgZQ8nCQ>
    <xmx:kvqCamh9_O80GF6zBnB2N7ImBlKft_ypXUs_SBxKhZ9jjf8NUizsgA>
    <xmx:kvqCavcv0BvvqA7UjbbElgQJvON8qks9GxDsP2u4TPn1j9jjS8kOkNfX>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1E06FF80070; Mon, 17 Aug 2026 08:12:01 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 17 Aug 2026 15:11:40 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Anisse Astier" <anisse@astier.eu>
Cc: linux-efi@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org,
 "Ravi Bangoria" <ravi.bangoria@amd.com>
Message-Id: <38e0e561-3b51-4c14-8e01-b8b7137199dc@app.fastmail.com>
In-Reply-To: <anILrU83ClMOZ6hO@PF620VM5>
References: <20260801144258.15977-2-ardb@kernel.org>
 <anILrU83ClMOZ6hO@PF620VM5>
Subject: Re: [PATCH] efivarfs: Cache occupied and available space
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Thanks for the review.

On Tue, 4 Aug 2026, at 19:01, Anisse Astier wrote:
> Hi Ard,
>
> Please find a few comments below,
>
> On Sat, Aug 01, 2026 at 04:42:59PM +0200, Ard Biesheuvel wrote:
>> Ravi reports that statfs() may be called by unprivileged users on the
>> efivarfs mount point, resulting in repeated calls to QueryVariableInfo()
>> which are disproportionately costly on x86 systems where the variable
>> store is backed by SMM, as each SMM entry requires a rendez-vous of all
>> the CPUs.
>> 
>> So cache the output of QueryVariableInfo(), and invalidate the cached
>> values when an entry is added or deleted, or the variable store is
>> synchronized after a suspend/resume sequence.
>> 
>> Cc: <stable@vger.kernel.org>
>> Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
>> Fixes: d86ff3333cb1 ("efivarfs: expose used and total size")
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>  fs/efivarfs/internal.h |  2 ++
>>  fs/efivarfs/super.c    | 21 +++++++++++---------
>>  fs/efivarfs/vars.c     |  9 +++++++++
>>  3 files changed, 23 insertions(+), 9 deletions(-)
>> 
>> diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
>> index f913b6824289..d43789bc7839 100644
>> --- a/fs/efivarfs/internal.h
>> +++ b/fs/efivarfs/internal.h
>> @@ -31,6 +31,8 @@ struct efivar_entry {
>>  	bool removed;
>>  };
>>  
>> +extern u64 efivar_storage_space, efivar_remaining_space;
>> +
>>  static inline struct efivar_entry *efivar_entry(struct inode *inode)
>>  {
>>  	return container_of(inode, struct efivar_entry, vfs_inode);
>> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
>> index 733c19571f1c..3691a2a087a0 100644
>> --- a/fs/efivarfs/super.c
>> +++ b/fs/efivarfs/super.c
>> @@ -23,6 +23,8 @@
>>  #include "internal.h"
>>  #include "../internal.h"
>>  
>> +u64 efivar_storage_space, efivar_remaining_space;
>> +
> Since those are globals (before they were only local to the function),
> I'd put them behind a lock now, probably efivar_lock, because we need
> something that's globally available.
>
> statfs could be raced from userspace vs the rest of the code; and
> efivar_invalidate_cached_storage_space is only called outside the lock.
>

Right. So we might inadvertently report zero size and zero available
space even though QueryVariableInfo() is supported and working correctly.
Not the end of the world imo, but better avoided if we can.


>>  static int efivarfs_ops_notifier(struct notifier_block *nb, unsigned long event,
>>  				 void *data)
>>  {
>> @@ -82,15 +84,16 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>>  	const u32 attr = EFI_VARIABLE_NON_VOLATILE |
>>  			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
>>  			 EFI_VARIABLE_RUNTIME_ACCESS;
>> -	u64 storage_space, remaining_space, max_variable_size;
>>  	u64 id = huge_encode_dev(dentry->d_sb->s_dev);
>> +	u64 max_variable_size;
>>  	efi_status_t status;
>>  
>>  	/* Some UEFI firmware does not implement QueryVariableInfo() */
>> -	storage_space = remaining_space = 0;
>> -	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
>> -		status = efivar_query_variable_info(attr, &storage_space,
>> -						    &remaining_space,
>> +	if (efivar_storage_space == 0 &&
>> +	    efivar_remaining_space == 0 &&
>> +	    efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
>> +		status = efivar_query_variable_info(attr, &efivar_storage_space,
>> +						    &efivar_remaining_space,
>>  						    &max_variable_size);
>>  		if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
>>  			pr_warn_ratelimited("query_variable_info() failed: 0x%lx\n",
>
> We've had issues with firmware in the past, shouldn't we be a bit more
> defensive here in case of errors? I'd reset both variables on error in
> case an incomplete write to one of the variables gives us an invalid state.
>

This is a pre-existing issue, right? The only difference being the fact that
the variables are now globals?

>> @@ -104,8 +107,8 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>>  	 */
>>  	buf->f_bsize	= 1;
>>  	buf->f_namelen	= NAME_MAX;
>> -	buf->f_blocks	= storage_space;
>> -	buf->f_bfree	= remaining_space;
>> +	buf->f_blocks	= efivar_storage_space;
>> +	buf->f_bfree	= efivar_remaining_space;
>>  	buf->f_type	= dentry->d_sb->s_magic;
>>  	buf->f_fsid	= u64_to_fsid(id);
>>  
>> @@ -114,8 +117,8 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>>  	 * when the storage_paranoia x86 quirk is active. To use more, users
>>  	 * should boot the kernel with efi_no_storage_paranoia.
>>  	 */
>> -	if (remaining_space > efivar_reserved_space())
>> -		buf->f_bavail = remaining_space - efivar_reserved_space();
>> +	if (efivar_remaining_space > efivar_reserved_space())
>> +		buf->f_bavail = efivar_remaining_space - efivar_reserved_space();
>>  	else
>>  		buf->f_bavail = 0;
>>  
>> diff --git a/fs/efivarfs/vars.c b/fs/efivarfs/vars.c
>> index 6833c3d24b54..4196963695bd 100644
>> --- a/fs/efivarfs/vars.c
>> +++ b/fs/efivarfs/vars.c
>> @@ -361,6 +361,11 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
>>  	kfree(str8);
>>  }
>>  
>> +static void efivar_invalidate_cached_storage_space(void)
>> +{
>> +	efivar_storage_space = efivar_remaining_space = 0;
>> +}
>> +
>>  /**
>>   * efivar_init - build the initial list of EFI variables
>>   * @func: callback function to invoke for every variable
>> @@ -450,6 +455,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
>>  	} while (status != EFI_NOT_FOUND);
>>  
>>  	efivar_unlock();
>> +	efivar_invalidate_cached_storage_space();
>>  free:
>>  	kfree(variable_name);
>>  
>> @@ -480,6 +486,8 @@ int efivar_entry_delete(struct efivar_entry *entry)
>>  					    &entry->var.VendorGuid,
>>  					    0, 0, NULL, false);
>>  	efivar_unlock();
>> +	efivar_invalidate_cached_storage_space();
>> +
>>  	if (!(status == EFI_SUCCESS || status == EFI_NOT_FOUND))
>>  		return efi_status_to_err(status);
>>  
>> @@ -620,6 +628,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
>>  				    NULL, size, NULL);
>>  
>>  	efivar_unlock();
>> +	efivar_invalidate_cached_storage_space();
>
> In this function, the error path for efi_set_variable_locked (that could
> have triggered an EFI_OUT_OF_RESOURCES) is not covered by the
> invalidation.
>

Right. So under the assumption that the state of the EFI variable store
might change even after a failed SetVariable(), the cached values may
have become inaccurate. Is that what you are saying?

>>  
>>  	if (status && status != EFI_BUFFER_TOO_SMALL)
>>  		return efi_status_to_err(status);
>> -- 
>
> Couldn't the variables be written outside of efivarfs as well?
> efivar_set_variable can be called from other code? pstore could maybe be
> ignored if it's only used during crashes (I'm not sure), but I see at
> least one other driver calling it as well. Wouldn't that change the
> available/free size?
>

Yeah, that is a very good point.

