Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA95473C8C
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 11:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790247949; cv=none; b=JtFGXaQ2HRFxLhbDIqg7dm+OOzT3sYWvf3jEuJwOyfxE9z4ziYaxCx5JPUeL7YFfKBLL7zzvjaJil1lzQtYMgkxf7Co8Jof4llEACYP5HJzdDauKasd0hV02sXk6Ud8zkKpNiFX6cxBRRAsxYu4vZGbReM8C22wmbLlCnhZmgJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790247949; c=relaxed/simple;
	bh=utgzeSBA2M5zFswMKeucmOMbeeXxVlgSipgD4gD3Mwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heLJPbJ6c2XUjZzCfl5bfuQX1AqxFOZCv4km30Lg0/a/5vcyOCNd/TkNJByW3K+Lfn4N2MD7ILsKx0DKIbRggQipwO6R/pg899XEzJ92ZQM1XGP48mOwLFes/6PtZHB4O85LtZBWHgm0pIvpzRsD3LF0RFZPOmJaGCRYgsA/mUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h1+LEzJm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h1+LEzJm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790247945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VatXkwlXsOSuDvfRkV4aLa2L93mcMP86Fr//ozUJyQE=;
	b=h1+LEzJm+gpJkuZ1mMlmplUVxQGc8/3RcONZamCJqbCPRAHpYtlNtf807lequDuHktjX8P
	LB/PD/K6b1ys6Jj6qEGjUJQ9uDZa3YrCWyGnYl8Xeycb270bN8CzSCHFBMeq0jiO3yjrbd
	CT5dR5nqGBVXTamt8wkdrB/IFqLC1DM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-96-pUiPnD3PNj6bE5Gs_CNgxw-1; Thu,
 24 Sep 2026 07:05:39 -0400
X-MC-Unique: pUiPnD3PNj6bE5Gs_CNgxw-1
X-Mimecast-MFC-AGG-ID: pUiPnD3PNj6bE5Gs_CNgxw_1790247937
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CB541977302;
	Thu, 24 Sep 2026 11:05:37 +0000 (UTC)
Received: from localhost (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B8A6C180057E;
	Thu, 24 Sep 2026 11:05:35 +0000 (UTC)
Date: Thu, 24 Sep 2026 08:05:34 -0300
From: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
To: Prashant Singh <singhpra@juniper.net>
Cc: Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2] efivarfs: add nostatfs mount option to skip
 QueryVariableInfo()
Message-ID: <arUD_p0Vn4qyBH_e@redhat.com>
References: <20260919044124.8268-1-singhpra@juniper.net>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260919044124.8268-1-singhpra@juniper.net>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Fri, Sep 18, 2026 at 09:41:24PM -0700, Prashant Singh wrote:
> QueryVariableInfo() is an EFI runtime service that, on some firmware,
> takes tens of milliseconds and runs with preemption disabled, stalling
> the CPU that services it. efivarfs_statfs() calls it (rate-limited since
> commit b2326338dc68 ("efivarfs: Rate limit statfs() handler")) to report
> the variable-store used/available capacity, so any statfs(2) -- e.g.
> every "df" -- can inject that stall into unrelated latency-sensitive
> workloads on the same CPU.
> 
> Add a "nostatfs" mount option: when set, statfs(2) skips
> QueryVariableInfo() entirely and reports zero used/available. It is set
> by default on CONFIG_PREEMPT_RT so real-time kernels do not take the
> stall out of the box.

I tested the patch and was quite satisfied with the results, but upon a
comment from colleagues I ran a few more tests and noticed (confirmed their
hunch) that fwupd complains about not being able to get the free space in
efivars:

  # fwupdmgr get-devices | grep efivars
  │     Update Error:       getting efivars free space is not supported
  │ │   Update Error:       getting efivars free space is not supported
  ...

I was not able to establish whether that would prevent specific operations
due to the HW I had available for such test.

One idea that I have been musing over is whether or not it would be interesting
to create a static view of the efivars statfs data when first mounting it
and updating this data whenever efivars is modified (create/write/delete).
Does that sound reasonable?

Luis
 
> Tested on an Intel Xeon E5-2628L v4, 6.12 kernel with CONFIG_PREEMPT_RT
> not set (so reporting defaults to enabled and nostatfs must be passed
> explicitly), via "strace -T -e trace=statfs df" on the efivarfs mount.
> 
> Default mount: statfs() calls QueryVariableInfo() and returns the real
> store capacity, ~66-129 ms per call:
> 
>   statfs("/sys/firmware/efi/efivars", {f_type=EFIVARFS_MAGIC,
>       f_bsize=1, f_blocks=90024, f_bfree=33387, f_bavail=28267, ...})
>       = 0 <0.129124>
> 
> With -o nostatfs: no firmware call, capacity reported as zero, ~11 us per
> call:
> 
>   statfs("/sys/firmware/efi/efivars", {f_type=EFIVARFS_MAGIC,
>       f_bsize=1, f_blocks=0, f_bfree=0, f_bavail=0, ...}) = 0 <0.000011>
> 
> Signed-off-by: Prashant Singh <singhpra@juniper.net>
> ---
> Changes since v1:
>   - Per review, dropped the fs.efivarfs sysctl / cached-capacity approach
>     entirely; instead add a simple "nostatfs" mount option that skips
>     QueryVariableInfo() in statfs() and reports zero, set by default on
>     CONFIG_PREEMPT_RT.
> 
> v1: https://lore.kernel.org/all/20260917071600.5587-1-singhpra@juniper.net/
> 
>  Documentation/filesystems/efivarfs.rst | 10 ++++++++++
>  fs/efivarfs/internal.h                 |  1 +
>  fs/efivarfs/super.c                    | 20 +++++++++++++++++---
>  3 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/efivarfs.rst b/Documentation/filesystems/efivarfs.rst
> index f646c3f0980f..3ead638c796a 100644
> --- a/Documentation/filesystems/efivarfs.rst
> +++ b/Documentation/filesystems/efivarfs.rst
> @@ -37,6 +37,16 @@ accidentally.
>            |4_bytes_of_attributes + efivar_data|
>            +-----------------------------------+
>  
> +Mount options
> +=============
> +
> +nostatfs
> +      Do not report the variable-store used/available capacity in
> +      ``statfs(2)``; report zero instead. Obtaining the capacity requires the
> +      ``QueryVariableInfo()`` EFI runtime service, which on some firmware takes
> +      tens of milliseconds and runs with preemption disabled, stalling the
> +      calling CPU. This option is set by default on ``CONFIG_PREEMPT_RT``.
> +
>  *See also:*
>  
>  - Documentation/admin-guide/acpi/ssdt-overlays.rst
> diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
> index f913b6824289..0cb053884b4b 100644
> --- a/fs/efivarfs/internal.h
> +++ b/fs/efivarfs/internal.h
> @@ -11,6 +11,7 @@
>  struct efivarfs_mount_opts {
>  	kuid_t uid;
>  	kgid_t gid;
> +	bool nostatfs;		/* skip QueryVariableInfo() in statfs() */
>  };
>  
>  struct efivarfs_fs_info {
> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index 8d33f11db2a1..fbdaa4915d30 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -74,6 +74,8 @@ static int efivarfs_show_options(struct seq_file *m, struct dentry *root)
>  	if (!gid_eq(opts->gid, GLOBAL_ROOT_GID))
>  		seq_printf(m, ",gid=%u",
>  				from_kgid_munged(&init_user_ns, opts->gid));
> +	if (opts->nostatfs)
> +		seq_puts(m, ",nostatfs");
>  	return 0;
>  }
>  
> @@ -82,13 +84,19 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	const u32 attr = EFI_VARIABLE_NON_VOLATILE |
>  			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
>  			 EFI_VARIABLE_RUNTIME_ACCESS;
> +	struct efivarfs_fs_info *sfi = dentry->d_sb->s_fs_info;
>  	u64 storage_space, remaining_space, max_variable_size;
>  	u64 id = huge_encode_dev(dentry->d_sb->s_dev);
>  	efi_status_t status;
>  
> -	/* Some UEFI firmware does not implement QueryVariableInfo() */
> +	/*
> +	 * Some UEFI firmware does not implement QueryVariableInfo(); the
> +	 * nostatfs mount option also disables this (preempt-disabled,
> +	 * potentially slow) call entirely, reporting zero used/available.
> +	 */
>  	storage_space = remaining_space = 0;
> -	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
> +	if (!sfi->mount_opts.nostatfs &&
> +	    efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
>  		static DEFINE_RATELIMIT_STATE(_rs, 2 * HZ, 5);
>  		static u64 storage, remaining;
>  		static DEFINE_SPINLOCK(lock);
> @@ -323,12 +331,13 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
>  }
>  
>  enum {
> -	Opt_uid, Opt_gid,
> +	Opt_uid, Opt_gid, Opt_nostatfs,
>  };
>  
>  static const struct fs_parameter_spec efivarfs_parameters[] = {
>  	fsparam_uid("uid", Opt_uid),
>  	fsparam_gid("gid", Opt_gid),
> +	fsparam_flag("nostatfs", Opt_nostatfs),
>  	{},
>  };
>  
> @@ -350,6 +359,9 @@ static int efivarfs_parse_param(struct fs_context *fc, struct fs_parameter *para
>  	case Opt_gid:
>  		opts->gid = result.gid;
>  		break;
> +	case Opt_nostatfs:
> +		opts->nostatfs = true;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -526,6 +538,8 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
>  
>  	sfi->mount_opts.uid = GLOBAL_ROOT_UID;
>  	sfi->mount_opts.gid = GLOBAL_ROOT_GID;
> +	/* QueryVariableInfo() stalls the CPU; default nostatfs on PREEMPT_RT. */
> +	sfi->mount_opts.nostatfs = IS_ENABLED(CONFIG_PREEMPT_RT);
>  
>  	fc->s_fs_info = sfi;
>  	fc->ops = &efivarfs_context_ops;
> 
> base-commit: 9b87fdc9af2fbfcdb5c24a64139685ef80f6573f
> -- 
> 2.34.1
> 
> 
---end quoted text---

