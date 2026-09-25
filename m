Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9186935F602;
	Fri, 25 Sep 2026 12:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790338477; cv=none; b=tTWZiQyTq05sQCGnlDpmP3hvZ05XEb71yANkG6gF2J9xtFMObsGfBfOR7O+0GiArGYWtQNy9kXwIbyok3zoLfTDxvg5V7CwGuYJEWqx+Hz+bM7+zgWd/mFzhxHi3wU32oLwByvufGOrwwWyxOxtw+q6BDxpV+9IwtPO3Gj63BRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790338477; c=relaxed/simple;
	bh=ddS6EtYbyPBCw7wCkDFEw/NfPASSKbIXnb55T4G1WpE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=GzVXOl3B4kiM4cQ8j2YG9fYBAs0B+OUUrpSUkFeeIwvdJf/PL3lXPmr4aABTs3wDFNVMBtDrEX6sC+nIu+/+DliJJzRySW52CMeV/KROCVP1rimJOI7f0zZ8XI+EXfeBDdiru4mEe/v+ptHvrks06AnpyoEhPM5kYpHIQRTo3KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gc2YFf6P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gc2YFf6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CD31F00898;
	Fri, 25 Sep 2026 12:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790338475;
	bh=IahDHAQF7RfDObHvj4rGyzlzFJnRRjAI2g4CtB30gI8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Gc2YFf6Pi1Dsz+74QHVbGsexpdMLXU5cA/TvsZSl1qz+7aMvvHXyKHQg9g/frshPj
	 h+jj3T+gfLtKeFwBuIUhzR1FOI/M4Mp9glhQMm5FbrnS07ZsvghXHj8Rka7V8TxU40
	 wSc1IDzayQnvSyGQnuzbSjeaOFwWIME378Cy//pzFfBuzN6KJfA0FnlVRPSi2wxE/P
	 4rtu7aIZrN+h5pHASY5d6pxq6fX/eY8yIKv/be98igaUswsPNlmYRdzLg35ppsNUEu
	 xFwMSevW1tf31nXTRMFiOLyj0zS/dtqTFIFGjtnXYhFLlRJ7cdjEtch8e3r1vewqxJ
	 WDidVIJYlAX+g==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id BB207198004A;
	Fri, 25 Sep 2026 08:14:32 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 25 Sep 2026 08:14:32 -0400
X-ME-Sender: <xms:pWW2aiCQzrBzkt2I7YVYwfxzTu27KAFzbeoda4dI8ym42QkilmmGMQ>
    <xme:pWW2anXxflYzxFcLQnHvOTUB_7KpUo4wvXBQfUs_mWX94ZAvwxVDWwefIzYN3iGQ5
    nYF84e-ysaJEDYAHsMDYrlI_A9ThwO6aHyL8tw4QjbO0JyJ7ZQ7q-1e>
X-ME-Proxy-Cause: dmFkZTFyygE7+hGtxC3ACXIARRMAb82zW5/8US7NbRjR/GomXcS8O1Ux0Gwn/xb9W9m7/Q
    OXwu2dd9yjEim1CR7HvhgbiA33/QjThBcCjOsTPuRrkUZS0bX0MrCxcOeQZE0m1aWO7kaO
    nZghqBxbcz43d4Avb3MhHyv8dmhsJ7vbjyp1G8IeDufmvq7izZZjgdNo8EhBCoJBdpR9fN
    TrIU5SL6dXqm/Kg4HdDVsHSxrzSbvD4tRbiZ7c3n/9KC54Of3d+b0BzhMtuvMwympAazWZ
    3SRR3cujbyLS9C3sAiGWsf8xbajY7huETyk2MjUNQbq9x9KIhH7hCSXoS0WhqPDW0GdAWO
    YMjVlbEbMcb5F8fcD6lirA522ehVkoIiD+XZGQUqZbPA2B9/kx7w7QUa+ZZO1jb9T3Kj8E
    h9/CD9UEf38mSNIuv2bcmtIle2kjClef3kn+gqZ2zYalrIWIelOb/aB6hGqtoaHxpR237j
    LCZksX930kQsHKPya8gYUp9dO2qwF2v5FuDKNkIiQbQlKSBv8bvEX27wQPN2veX9aroeLo
    6VUWUPVmXqqrXN/soDb3rCOYwsqpqxsmuNxRxNM/OarWszLmmL8to9lYPBb0kIhX3neNBl
    Lde+Gt0TAKwLGLoWs27QqeZXDSGa7Hiz0g2plMuNnn5SIb1fkysowVvAcnmw
X-ME-Proxy: <xmx:qGW2aqLSiJtuF5utrYHWMPeES7R2HnnQ7K6pFgT-w69WSYW438zLww>
    <xmx:qGW2at_anXx3QJyqcd26y0j7a5UmzHeP75EnikyzfM0sX1PEy0Q-TQ>
    <xmx:qGW2ahKv1SQnFn7HXRm6CYY4EiicjZ3k1_jTeP_L5WHgIZffCJHRJg>
    <xmx:qGW2asG7CD_096kscy5mhIm77L1DUuFY7UlrnxHv84qVHB7T0MV40Q>
    <xmx:qGW2alzK_Vbdx4GEcGozso-Fxu4A3PcC9bo17SlmoHpVKwVAo2xk1VsT>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id B0BDBF80086; Fri, 25 Sep 2026 08:14:29 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 25 Sep 2026 14:14:09 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Prashant Singh" <singhpra@juniper.net>, "Jeremy Kerr" <jk@ozlabs.org>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Jonathan Corbet" <corbet@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
 "Steve McIntyre" <93sam@debian.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Message-Id: <17ae71e4-c044-4354-938e-3e8021615e6d@app.fastmail.com>
In-Reply-To: <20260925113145.7396-1-singhpra@juniper.net>
References: <20260925113145.7396-1-singhpra@juniper.net>
Subject: Re: [PATCH v3] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Prashant,

Thanks for respinning this.

On Fri, 25 Sep 2026, at 13:31, Prashant Singh wrote:
> QueryVariableInfo() is an EFI runtime service that, on some firmware,
> takes tens of milliseconds and runs with preemption disabled, stalling
> the CPU that services it. efivarfs_statfs() calls it (rate-limited since
> commit b2326338dc68 ("efivarfs: Rate limit statfs() handler")) to report
> the variable-store used/available capacity, so any statfs(2) -- e.g.
> every "df" -- can inject that stall into unrelated latency-sensitive
> workloads on the same CPU.
>
> Add a negatable "nostatfs" mount option: with nostatfs, statfs(2) skips
> QueryVariableInfo() and reports zero used/available; with statfs it
> reports the capacity as before. It defaults to nostatfs on
> CONFIG_PREEMPT_RT so real-time kernels do not take the stall out of the
> box, but statfs can be passed there to force reporting back on -- e.g.
> for tools such as fwupd that need the efivars free space to update Secure
> Boot key databases.
>
> The option can also be toggled on a live mount via remount, so reporting
> can be enabled only for the duration of a firmware update without
> unmounting the boot-time efivarfs mount:
>
>   mount -o remount,statfs   /sys/firmware/efi/efivars   # reporting on
>   mount -o remount,nostatfs /sys/firmware/efi/efivars   # reporting off
>
> Tested on an Intel Xeon E5-2628L v4, 6.12 kernel, via
> "strace -T -e trace=statfs df" on the efivarfs mount.
>
> Cost of the firmware call (CONFIG_PREEMPT_RT not set, so reporting is
> enabled by default). Default mount calls QueryVariableInfo() and returns
> the real store capacity, ~66-129 ms per call:
>
>   statfs("/sys/firmware/efi/efivars", {f_type=EFIVARFS_MAGIC,
>       f_bsize=1, f_blocks=90024, f_bfree=33387, f_bavail=28267, ...})
>       = 0 <0.129124>
>
> With -o nostatfs the firmware call is skipped, capacity reported as
> zero, ~11 us per call:
>
>   statfs("/sys/firmware/efi/efivars", {f_type=EFIVARFS_MAGIC,
>       f_bsize=1, f_blocks=0, f_bfree=0, f_bavail=0, ...}) = 0 <0.000011>
>
> PREEMPT_RT default and live remount toggle (CONFIG_PREEMPT_RT=y). The
> boot-time mount defaults to nostatfs (mount shows nostatfs); no firmware
> call, capacity zero:
>
>   statfs(... f_blocks=0, f_bfree=0, f_bavail=0, ...) = 0 <0.000018>
>
> Enabling reporting in place with "mount -o remount,statfs" (mount now
> shows statfs) takes the ~70 ms firmware call and returns the real
> capacity, without unmounting:
>
>   statfs(... f_blocks=90024, f_bfree=30315, f_bavail=25195, ...)
>       = 0 <0.070293>
>
> Disabling it again with "mount -o remount,nostatfs" returns to the fast,
> zero-capacity path:
>
>   statfs(... f_blocks=0, f_bfree=0, f_bavail=0, ...) = 0 <0.000014>
>
> An unrelated remount that does not respecify the option preserves it: a
> "mount -o remount,rw" after "remount,statfs" leaves the mount showing
> statfs.
>
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Prashant Singh <singhpra@juniper.net>
> ---
> Changes since v2:
> - Make the flag negatable (fsparam_flag_no): "statfs" forces reporting
>   back on, "nostatfs" skips QueryVariableInfo(). Default stays nostatfs
>   on PREEMPT_RT. This lets fwupd get the efivars free space it needs for
>   Secure Boot key (KEK/DB/DBX) updates on an RT kernel by mounting with
>   -o statfs (Luis Claudio R. Goncalves, Steve McIntyre).
> - Support toggling the option on a live mount via remount, so reporting
>   can be enabled just for a firmware update without unmounting efivarfs
>   (Sebastian Andrzej Siewior). Options not respecified on remount are
>   preserved.
> - Read/write nostatfs with READ_ONCE()/WRITE_ONCE(): statfs() reads it
>   without s_umount while remount can update it.

Why? There is no memory ordering or tearing issue here, but only a
fundamental race where a remount and a statfs() might occur at the
same time.

> - Add PREEMPT_RT + remount test data to the commit message.
>
> Changes since v1:
> - Replace the sysctl with a mount option named "nostatfs", per review
>   (Ard Biesheuvel).
>
> v1: https://lore.kernel.org/all/20260917071600.5587-1-singhpra@juniper.net/
> v2: https://lore.kernel.org/all/20260919044124.8268-1-singhpra@juniper.net/
>
>  Documentation/filesystems/efivarfs.rst | 16 +++++++++
>  fs/efivarfs/internal.h                 |  1 +
>  fs/efivarfs/super.c                    | 46 +++++++++++++++++++++++---
>  3 files changed, 58 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/filesystems/efivarfs.rst 
> b/Documentation/filesystems/efivarfs.rst
> index f646c3f0980f..cd81ee84115b 100644
> --- a/Documentation/filesystems/efivarfs.rst
> +++ b/Documentation/filesystems/efivarfs.rst
> @@ -37,6 +37,22 @@ accidentally.
>            |4_bytes_of_attributes + efivar_data|
>            +-----------------------------------+
> 
> +Mount options
> +=============
> +
> +statfs / nostatfs
> +      Control whether ``statfs(2)`` reports the variable-store used/available
> +      capacity. Obtaining it requires the ``QueryVariableInfo()`` EFI runtime
> +      service, which on some firmware takes tens of milliseconds and runs with
> +      preemption disabled, stalling the calling CPU. With ``nostatfs`` the call
> +      is skipped and ``statfs(2)`` reports zero. The default is to report,
> +      except on ``CONFIG_PREEMPT_RT`` where it defaults to ``nostatfs``; pass
> +      ``statfs`` there to force reporting back on (e.g. for tools such as fwupd
> +      that need the free space for firmware updates). The option can also be
> +      flipped on a live mount with ``mount -o remount,statfs`` /
> +      ``mount -o remount,nostatfs``, so reporting can be enabled only for the
> +      duration of a firmware update without unmounting efivarfs.
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
> index 8d33f11db2a1..d2e1f31a72d1 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -74,6 +74,15 @@ static int efivarfs_show_options(struct seq_file *m, 
> struct dentry *root)
>  	if (!gid_eq(opts->gid, GLOBAL_ROOT_GID))
>  		seq_printf(m, ",gid=%u",
>  				from_kgid_munged(&init_user_ns, opts->gid));
> +	/*
> +	 * Always show nostatfs (it makes statfs() report zero capacity, which
> +	 * is otherwise surprising); only show statfs where it is not the
> +	 * default, i.e. on PREEMPT_RT.
> +	 */
> +	if (opts->nostatfs)
> +		seq_puts(m, ",nostatfs");
> +	else if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +		seq_puts(m, ",statfs");

Please drop this else branch - it should be sufficient for the 'nostatfs'
to disappear from the mount options to understand what is going on.

>  	return 0;
>  }
> 
> @@ -82,13 +91,19 @@ static int efivarfs_statfs(struct dentry *dentry, 
> struct kstatfs *buf)
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
> +	if (!READ_ONCE(sfi->mount_opts.nostatfs) &&
> +	    efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
>  		static DEFINE_RATELIMIT_STATE(_rs, 2 * HZ, 5);
>  		static u64 storage, remaining;
>  		static DEFINE_SPINLOCK(lock);
> @@ -323,12 +338,13 @@ static int efivarfs_callback(efi_char16_t 
> *name16, efi_guid_t vendor,
>  }
> 
>  enum {
> -	Opt_uid, Opt_gid,
> +	Opt_uid, Opt_gid, Opt_statfs,
>  };
> 
>  static const struct fs_parameter_spec efivarfs_parameters[] = {
>  	fsparam_uid("uid", Opt_uid),
>  	fsparam_gid("gid", Opt_gid),
> +	fsparam_flag_no("statfs", Opt_statfs),
>  	{},
>  };
> 
> @@ -350,6 +366,9 @@ static int efivarfs_parse_param(struct fs_context 
> *fc, struct fs_parameter *para
>  	case Opt_gid:
>  		opts->gid = result.gid;
>  		break;
> +	case Opt_statfs:
> +		opts->nostatfs = result.negated;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -402,11 +421,17 @@ static int efivarfs_get_tree(struct fs_context 
> *fc)
> 
>  static int efivarfs_reconfigure(struct fs_context *fc)
>  {
> +	struct efivarfs_fs_info *sfi = fc->root->d_sb->s_fs_info;
> +	struct efivarfs_fs_info *new_sfi = fc->s_fs_info;
> +
>  	if (!efivar_supports_writes() && !(fc->sb_flags & SB_RDONLY)) {
>  		pr_err("Firmware does not support SetVariableRT. Can not remount with rw\n");
>  		return -EINVAL;
>  	}
> 
> +	/* statfs() reads nostatfs locklessly (no s_umount); pair with WRITE_ONCE. */
> +	WRITE_ONCE(sfi->mount_opts.nostatfs, new_sfi->mount_opts.nostatfs);
> +
>  	return 0;
>  }
> 
> @@ -524,8 +549,19 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
>  	if (!sfi)
>  		return -ENOMEM;
> 
> -	sfi->mount_opts.uid = GLOBAL_ROOT_UID;
> -	sfi->mount_opts.gid = GLOBAL_ROOT_GID;
> +	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
> +		/* Preserve options not respecified on remount. */
> +		struct efivarfs_fs_info *old = fc->root->d_sb->s_fs_info;
> +
> +		sfi->mount_opts.uid = old->mount_opts.uid;
> +		sfi->mount_opts.gid = old->mount_opts.gid;
> +		sfi->mount_opts.nostatfs = READ_ONCE(old->mount_opts.nostatfs);
> +	} else {
> +		sfi->mount_opts.uid = GLOBAL_ROOT_UID;
> +		sfi->mount_opts.gid = GLOBAL_ROOT_GID;
> +		/* QueryVariableInfo() stalls the CPU; default nostatfs on PREEMPT_RT. */
> +		sfi->mount_opts.nostatfs = IS_ENABLED(CONFIG_PREEMPT_RT);
> +	}
> 

Why do we need this? Does remount otherwise forget its options? Does this
mean that before this patch, remounting with only a different guid would
reset the uid specified at mount time to the default? If so, please fix
that in a separate (preceding) patch.

 
