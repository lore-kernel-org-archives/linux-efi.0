Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EF0353A8E;
	Sat, 19 Sep 2026 14:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789829545; cv=none; b=p53uqEEnparkwkpb3kTRKWZwdIQK6jawfLiGu8nduGfOCzQLznwaIwy2FjX5yyD2jJMK3IFIm+F69qa2qLws+b7Tz4PVyEDeoLqS1FGpl/1rqtccKO/IGkQb2X1xT9L7a1ABzEo0z3aVcqmQa7nK8yLLunsigB0QGBWDaq3KQMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789829545; c=relaxed/simple;
	bh=aYuny4h6qcvJqAjPXOYGsWaiDUiRiJEPSoa3VNDPMig=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=GBZCZW934h9Tes9ZP/rJ0HBE1NagFElQ+m6sJU+AtjWOldLnIwXKfbdzqXIavWojhOfSYd0To/6EBPhhPT6gz72pClSAe5pLWArRpQ5msVXKAeMQLaYUiw+Q1eQpuxvPomrUZmEkr1f4TchJzm9gI+NcI6HHAv15upCpqxwF/gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GL+0/145; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GL+0/145"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E29E1F00898;
	Sat, 19 Sep 2026 14:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789829543;
	bh=6uZGsOZ/tjORmIY+N5hf3mwD4h/neomAS9OSWAtb9U0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=GL+0/145qzmNaZ4eQ8bq98jNcKv1iTTYpkY5znuiNw7+2LNn20UniVuWypZy1/k7b
	 OUNrik8hEWf4AUCdWDBWioVjd8ladmqvVeqtaQYMDbVuyTZfU2jYHHGm99UFKUq8fk
	 Wzv/4Fc3Okjc5BTeIaK6smA1ckpjNMVoOZR+cPgpojEqpaorGS1FuucxscNVVJsXf8
	 BedBZgbMCHkCKGEH30oPmAr/eqPMFh19lb/pIFtR/ly+obhQ/WKORGKuGZThKF8OZt
	 7R0qdEG9Sp1ymyXvVRpWBws4Y9CcAg7zB3oxNKoiDG71uRF4EK+CKJkbyIzsQKvpJs
	 oFIIfuSUSNDbQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id BA1D4198003A;
	Sat, 19 Sep 2026 10:52:20 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sat, 19 Sep 2026 10:52:20 -0400
X-ME-Sender: <xms:oaGuarpFxsdZn4PbatYO_NcxKBJTLvPGUkUwbhclkjAB6kTYG0WRzw>
    <xme:oaGuagegF6Hu1JFG4Z4493_kH-S0xGJu6-6p1ugwji-rzcLzOaItbcq2pZFwpiqpK
    IyKqjKDhU_QEvSPOpAQBewPlRAzwQ4LJ-_yWOu49e8vyHgbjqK1iA>
X-ME-Proxy-Cause: dmFkZTGxoQc5c+HA9Asv4PDqeRbNHqRu8FkzJGcHggZQl6BUDphxyn0qSpEUseKS9SOLeU
    /0kjpCIjHzUjHArYOf6Yy9qiwrd6KrfjfDnMk80DegjFny8i4KW9aPJnqZjyHihmUNLvQN
    zZECI+JmNMrQZ1HuIC7N4SXmGL/hEIN+kCGERNpL2q8CP7LdoxWG0foXc7k5xieMiZ+ceu
    nHoZGM0IWsRhmXlyiT/w5Dokdmy1umG5apD9d2y0AMyBRtrGy9FSSAwBUoLtZnROGd4a13
    eWkVL5PW0n+9mQVP/2+/zA/Q5YecUV7BS8W9hWgqkzO9Nq19mCKeGk0DEkpYMdiTmG2nKF
    BIUE66+o/CAbH7nx4oYVO7E7CxbEQP2FaGGqoh7PyS/DwZFJalbF3vhARZouI9VAhJjCSZ
    OdHrprbeyHafXnAmRJ9RLInrXWXthjbNmIJ/9ZclWBSBWGkQGvrddZLY6OYJ6M5eFX1T5Z
    xK71fdC4E+8NWuWs7kppDcNgE951bcIRI7DitEviya/r8AZF+4rGrDTErmGUwP4lGGWeF3
    dT/YxX2V/kQQGKT2biokO8T0EcdlH5k4FZ2TWAo8xNye1Jrv/E4DvXmXlBTJ2VCRDobAHM
    KqYP3+9xskSgMUUSZy30XltqcMv9f28LV64B8WDDFW/gwklD9Vrni/42qpIA
X-ME-Proxy: <xmx:pKGuaj2wydKI9FSfcrjbWJyMloTh8O9wkadom3E0QQc6rc-V_PoMrQ>
    <xmx:pKGuagVe67Q2N5AWaT2qBR8RI41q5w3fA0XFDhnW_rKX4f640E7phA>
    <xmx:pKGuatPJmXitWbz0SKNN6koU488gJBfmpz3b19loWawB5a9NpSRRmw>
    <xmx:pKGuar1TN4Ryc_dg_LljaIv7yZ56MXUuCfPPDBlYtscYBtFPlpZR4g>
    <xmx:pKGuapSQ0ehyjCBgXPuQBq2d0so1UCOZ_OmQWLqNzKnlbpc_mB9oxMU9>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id D5A24F80080; Sat, 19 Sep 2026 10:52:17 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 19 Sep 2026 16:51:57 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Prashant Singh" <singhpra@juniper.net>, "Jeremy Kerr" <jk@ozlabs.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Jonathan Corbet" <corbet@lwn.net>, linux-doc@vger.kernel.org,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev
Message-Id: <89957810-4914-4c0b-9141-ca2c5fb8704d@app.fastmail.com>
In-Reply-To: <20260919044124.8268-1-singhpra@juniper.net>
References: <20260919044124.8268-1-singhpra@juniper.net>
Subject: Re: [PATCH v2] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 19 Sep 2026, at 06:41, Prashant Singh wrote:
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
>
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
> diff --git a/Documentation/filesystems/efivarfs.rst 
> b/Documentation/filesystems/efivarfs.rst
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
> @@ -74,6 +74,8 @@ static int efivarfs_show_options(struct seq_file *m, 
> struct dentry *root)
>  	if (!gid_eq(opts->gid, GLOBAL_ROOT_GID))
>  		seq_printf(m, ",gid=%u",
>  				from_kgid_munged(&init_user_ns, opts->gid));
> +	if (opts->nostatfs)
> +		seq_puts(m, ",nostatfs");
>  	return 0;
>  }
> 
> @@ -82,13 +84,19 @@ static int efivarfs_statfs(struct dentry *dentry, 
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
> +	if (!sfi->mount_opts.nostatfs &&
> +	    efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
>  		static DEFINE_RATELIMIT_STATE(_rs, 2 * HZ, 5);
>  		static u64 storage, remaining;
>  		static DEFINE_SPINLOCK(lock);
> @@ -323,12 +331,13 @@ static int efivarfs_callback(efi_char16_t 
> *name16, efi_guid_t vendor,
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
> @@ -350,6 +359,9 @@ static int efivarfs_parse_param(struct fs_context 
> *fc, struct fs_parameter *para
>  	case Opt_gid:
>  		opts->gid = result.gid;
>  		break;
> +	case Opt_nostatfs:
> +		opts->nostatfs = true;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -526,6 +538,8 @@ static int efivarfs_init_fs_context(struct 
> fs_context *fc)
> 
>  	sfi->mount_opts.uid = GLOBAL_ROOT_UID;
>  	sfi->mount_opts.gid = GLOBAL_ROOT_GID;
> +	/* QueryVariableInfo() stalls the CPU; default nostatfs on PREEMPT_RT. */
> +	sfi->mount_opts.nostatfs = IS_ENABLED(CONFIG_PREEMPT_RT);
> 
>  	fc->s_fs_info = sfi;
>  	fc->ops = &efivarfs_context_ops;
>

This looks good to me but I'll leave some time for other folks to comment.


