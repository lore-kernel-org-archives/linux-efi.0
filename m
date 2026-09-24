Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A509473C96
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 10:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790247395; cv=none; b=JZAgXCOTSohNIdtyRcpgCaL79ZTrwl/D1R2c2VTt9OC5DiNCKHu/gXiS9LmCsqpi87xH/g5Qrm4s25qvGOVXmhtxI4QGeT6mWiE/ZnJBjuTrjmLqMvCmRVJk155IoIHinBObfzhD73sZBT2IaMa3g6dY16GKGhfwk4YDW64fLwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790247395; c=relaxed/simple;
	bh=YjF/DAjWATunOBVs4MbgmBozqUhWjQ0U63EwtICVy1Q=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=UGQzyiiT5EzSuJREH4fCSnjpi+9VMR7fIsG7jBsL88niLB2SnUhugzbG+HoXd5+L1KU+S00cRHbwcrTRH0nhvii3fjxjeLKvxLDQ25H+NW9wrtcLGI2Nc7AeNCP4Gf1BcTOFezGAWDS7bpywi2sN62aKugkQlfjxrkhghZo+zmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrdtBWxs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrdtBWxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C121F00898;
	Thu, 24 Sep 2026 10:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790247389;
	bh=nvZOIi1haz8s5ExjYZ8lmssJkcUOwrjgXq0hPw33gno=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=CrdtBWxstV0xbBpMVeA5adESf65cEeh9nWi1MMmUAdhof5t/cgXZmRdpB/LJUlUOC
	 2Xg47kWrlr66WphsMdVz8b9IR3Y2U12YbdQ4G6lu4IBA2/T04l073iOUXE9HJDAq0X
	 AzklhE61uL4vZn24hM0uE5wK+azSmM2gEcOm93lDFaJlQevxnRnqAKhEC4NeiC2STw
	 /ePOzXdMdNKmqckUWhdmp67je9eAbddeTXjR+UCEu0hFbJkmVWBIUpFHsxmkO/iMkf
	 cRXaLRzvbL6ySQ8CId1HoG72KniEIeG3OdANzk4GX9AWg53ihoue3mSnjbmkgAEVht
	 wxQa76qKLW8Ig==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 53497198005A;
	Thu, 24 Sep 2026 06:56:27 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 24 Sep 2026 06:56:27 -0400
X-ME-Sender: <xms:1wG1agwGANhDe2SxDPfpZdJIvTdU1ElOXo6BgFTfwEeLfEKWIkrLsQ>
    <xme:1wG1avEuENTTI-XqbGFzV6axITnaJ-alyGyZKUrcwgM_-gAzEwphaGmNtq1UYhYac
    BBKc9G7xOaWykC9fbMLUCQMW7WCz00RAAPxwQcJsUxLjQcm849cE8aN>
X-ME-Proxy-Cause: dmFkZTEJpuBeIotz8ZzEsukIoKcd4CyUEPf0xFmRQCqcQgCTYvsejbHsgHekWRQ/wtLP17
    9O8u9UIirYRCprBAVVBKkVZQ236CKFSfGt849qdjiaNjcLlsuFAdIhcfe0tJT8yqAAy2yF
    3/AKu7kR8tXjpLM6kvVgQMCL2CvzgxRH0ntb4ss487dHAunDDns1B0VklvlOmU6uWlt/b7
    vlksOvvw4JN8da9MFwRjvrNPpFmg1yEoTBPpJMH8kTV5QFgKB1e4lYNprVicxsn480Rbc7
    YfW54tBJLZ+o03elGsGRDsThoi/cksTbgXKWtwlX2fItR0tpLDPs3wvp6GGx5mSsWsK+oA
    8zOqmJg8OayXCKWmk+f69iWlSVttpt8hs/F8sUxXIJ1MzlSIqkuJUPx3fz+7BUUjKbGPqw
    xz2YzTMQO74oJL+yQMauo1DsldB3rNXJLgaV0vQpRqLzVE/TVcBQdjEKk6uXl+PFp07RaB
    qQem4Onq/jvcUheGcRhR1PPDo0PfBy4mdCZHX5TaiibZv8ZnHAhLelA3QCunBAi2vC0tlD
    vTo9NGH9WCA89GhQocX5I/Env4XaTQtkRzf5sJFzuzt7kLVSOs493VMzTaYfLIKjwoG/+y
    hbXNbzKGoTIeoM1si+Fy9DGBF5QnaYaz9r9AQiNnqfNeO5wWzSBs10spWWiA
X-ME-Proxy: <xmx:2QG1ap8vLX6WYNhBVX-UwOFMGyLjF06NC3UvBTdr2qGokQQPGiO47g>
    <xmx:2QG1amVk6BHdet7u-Roi6v6WT_ph7wK_58ICi2TM6Pp9c92iOySizQ>
    <xmx:2QG1audPJoSAOG78DdUdB2m-XkTHxLXEQNmlkVxur1ECOKIHJUwwkQ>
    <xmx:2QG1anaq2Hp-4jCfIE2WLSiViZobLpDUifGCHqklOWtJW8JJO79VUg>
    <xmx:2QG1aiMDYC05JrRH7gnNQDAYYWWf25t4pq1jVPnV12HsQtn8ri1XIZ-9>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 40276F80080; Thu, 24 Sep 2026 06:56:23 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 12:56:01 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Prashant Singh" <singhpra@juniper.net>, "Jeremy Kerr" <jk@ozlabs.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Jonathan Corbet" <corbet@lwn.net>, linux-doc@vger.kernel.org,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev
Message-Id: <7101392b-2dc2-4472-a7b4-43a74c2c532a@app.fastmail.com>
In-Reply-To: <89957810-4914-4c0b-9141-ca2c5fb8704d@app.fastmail.com>
References: <20260919044124.8268-1-singhpra@juniper.net>
 <89957810-4914-4c0b-9141-ca2c5fb8704d@app.fastmail.com>
Subject: Re: [PATCH v2] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 19 Sep 2026, at 16:51, Ard Biesheuvel wrote:
> On Sat, 19 Sep 2026, at 06:41, Prashant Singh wrote:
>> QueryVariableInfo() is an EFI runtime service that, on some firmware,
>> takes tens of milliseconds and runs with preemption disabled, stalling
>> the CPU that services it. efivarfs_statfs() calls it (rate-limited since
>> commit b2326338dc68 ("efivarfs: Rate limit statfs() handler")) to report
>> the variable-store used/available capacity, so any statfs(2) -- e.g.
>> every "df" -- can inject that stall into unrelated latency-sensitive
>> workloads on the same CPU.
>>
>> Add a "nostatfs" mount option: when set, statfs(2) skips
>> QueryVariableInfo() entirely and reports zero used/available. It is set
>> by default on CONFIG_PREEMPT_RT so real-time kernels do not take the
>> stall out of the box.
>>
>> Tested on an Intel Xeon E5-2628L v4, 6.12 kernel with CONFIG_PREEMPT_RT
>> not set (so reporting defaults to enabled and nostatfs must be passed
>> explicitly), via "strace -T -e trace=statfs df" on the efivarfs mount.
>>
>> Default mount: statfs() calls QueryVariableInfo() and returns the real
>> store capacity, ~66-129 ms per call:
>>
>>   statfs("/sys/firmware/efi/efivars", {f_type=EFIVARFS_MAGIC,
>>       f_bsize=1, f_blocks=90024, f_bfree=33387, f_bavail=28267, ...})
>>       = 0 <0.129124>
>>
>> With -o nostatfs: no firmware call, capacity reported as zero, ~11 us per
>> call:
>>
>>   statfs("/sys/firmware/efi/efivars", {f_type=EFIVARFS_MAGIC,
>>       f_bsize=1, f_blocks=0, f_bfree=0, f_bavail=0, ...}) = 0 <0.000011>
>>
>> Signed-off-by: Prashant Singh <singhpra@juniper.net>
>> ---
>> Changes since v1:
>>   - Per review, dropped the fs.efivarfs sysctl / cached-capacity approach
>>     entirely; instead add a simple "nostatfs" mount option that skips
>>     QueryVariableInfo() in statfs() and reports zero, set by default on
>>     CONFIG_PREEMPT_RT.
>>
>> v1: https://lore.kernel.org/all/20260917071600.5587-1-singhpra@juniper.net/
>>
>>  Documentation/filesystems/efivarfs.rst | 10 ++++++++++
>>  fs/efivarfs/internal.h                 |  1 +
>>  fs/efivarfs/super.c                    | 20 +++++++++++++++++---
>>  3 files changed, 28 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/filesystems/efivarfs.rst 
>> b/Documentation/filesystems/efivarfs.rst
>> index f646c3f0980f..3ead638c796a 100644
>> --- a/Documentation/filesystems/efivarfs.rst
>> +++ b/Documentation/filesystems/efivarfs.rst
>> @@ -37,6 +37,16 @@ accidentally.
>>            |4_bytes_of_attributes + efivar_data|
>>            +-----------------------------------+
>> 
>> +Mount options
>> +=============
>> +
>> +nostatfs
>> +      Do not report the variable-store used/available capacity in
>> +      ``statfs(2)``; report zero instead. Obtaining the capacity requires the
>> +      ``QueryVariableInfo()`` EFI runtime service, which on some firmware takes
>> +      tens of milliseconds and runs with preemption disabled, stalling the
>> +      calling CPU. This option is set by default on ``CONFIG_PREEMPT_RT``.
>> +
>>  *See also:*
>> 
>>  - Documentation/admin-guide/acpi/ssdt-overlays.rst
>> diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
>> index f913b6824289..0cb053884b4b 100644
>> --- a/fs/efivarfs/internal.h
>> +++ b/fs/efivarfs/internal.h
>> @@ -11,6 +11,7 @@
>>  struct efivarfs_mount_opts {
>>  	kuid_t uid;
>>  	kgid_t gid;
>> +	bool nostatfs;		/* skip QueryVariableInfo() in statfs() */
>>  };
>> 
>>  struct efivarfs_fs_info {
>> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
>> index 8d33f11db2a1..fbdaa4915d30 100644
>> --- a/fs/efivarfs/super.c
>> +++ b/fs/efivarfs/super.c
>> @@ -74,6 +74,8 @@ static int efivarfs_show_options(struct seq_file *m, 
>> struct dentry *root)
>>  	if (!gid_eq(opts->gid, GLOBAL_ROOT_GID))
>>  		seq_printf(m, ",gid=%u",
>>  				from_kgid_munged(&init_user_ns, opts->gid));
>> +	if (opts->nostatfs)
>> +		seq_puts(m, ",nostatfs");
>>  	return 0;
>>  }
>> 
>> @@ -82,13 +84,19 @@ static int efivarfs_statfs(struct dentry *dentry, 
>> struct kstatfs *buf)
>>  	const u32 attr = EFI_VARIABLE_NON_VOLATILE |
>>  			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
>>  			 EFI_VARIABLE_RUNTIME_ACCESS;
>> +	struct efivarfs_fs_info *sfi = dentry->d_sb->s_fs_info;
>>  	u64 storage_space, remaining_space, max_variable_size;
>>  	u64 id = huge_encode_dev(dentry->d_sb->s_dev);
>>  	efi_status_t status;
>> 
>> -	/* Some UEFI firmware does not implement QueryVariableInfo() */
>> +	/*
>> +	 * Some UEFI firmware does not implement QueryVariableInfo(); the
>> +	 * nostatfs mount option also disables this (preempt-disabled,
>> +	 * potentially slow) call entirely, reporting zero used/available.
>> +	 */
>>  	storage_space = remaining_space = 0;
>> -	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
>> +	if (!sfi->mount_opts.nostatfs &&
>> +	    efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
>>  		static DEFINE_RATELIMIT_STATE(_rs, 2 * HZ, 5);
>>  		static u64 storage, remaining;
>>  		static DEFINE_SPINLOCK(lock);
>> @@ -323,12 +331,13 @@ static int efivarfs_callback(efi_char16_t 
>> *name16, efi_guid_t vendor,
>>  }
>> 
>>  enum {
>> -	Opt_uid, Opt_gid,
>> +	Opt_uid, Opt_gid, Opt_nostatfs,
>>  };
>> 
>>  static const struct fs_parameter_spec efivarfs_parameters[] = {
>>  	fsparam_uid("uid", Opt_uid),
>>  	fsparam_gid("gid", Opt_gid),
>> +	fsparam_flag("nostatfs", Opt_nostatfs),
>>  	{},
>>  };
>> 
>> @@ -350,6 +359,9 @@ static int efivarfs_parse_param(struct fs_context 
>> *fc, struct fs_parameter *para
>>  	case Opt_gid:
>>  		opts->gid = result.gid;
>>  		break;
>> +	case Opt_nostatfs:
>> +		opts->nostatfs = true;
>> +		break;
>>  	default:
>>  		return -EINVAL;
>>  	}
>> @@ -526,6 +538,8 @@ static int efivarfs_init_fs_context(struct 
>> fs_context *fc)
>> 
>>  	sfi->mount_opts.uid = GLOBAL_ROOT_UID;
>>  	sfi->mount_opts.gid = GLOBAL_ROOT_GID;
>> +	/* QueryVariableInfo() stalls the CPU; default nostatfs on PREEMPT_RT. */
>> +	sfi->mount_opts.nostatfs = IS_ENABLED(CONFIG_PREEMPT_RT);
>> 
>>  	fc->s_fs_info = sfi;
>>  	fc->ops = &efivarfs_context_ops;
>>
>
> This looks good to me but I'll leave some time for other folks to comment.

Queued up in efi/next now -- thanks.
