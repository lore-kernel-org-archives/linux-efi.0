Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3623A3822;
	Tue, 29 Sep 2026 07:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790667798; cv=none; b=QnwjCJmCvYfqUym9T31dp9lRsaDCijjhNIpQMxqAL2InlhrSFjrP5ikOMwli/t1jEVRQPDvPj6l1jJaAiGuznoInUFNe1G+YNhMvF6b6FIZ5n15DjI1H/vb1Lu2m7rL62ZLIQPQiw0AHKf0zuL/1SSUDmVYz+++fkoNRabp4YVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790667798; c=relaxed/simple;
	bh=jZfjDi738drGdWDIkeE7S/b/DZY6Q8Q7YhPuTKZgKz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BKFt89dqixjetaqvX8VX92OsXCbSBFOqyNpudrHjhDH5fl1tp2CRmwT00LmX8JSTdSfMtBVVg2Rs3jy5HQIZjRuJTZLfzJ2kjVykNWniCn9GbAg1nxVtZDuq465t+ImOMNLE3SxggqhWLMYB2gOHe7H4N6BzaVvyiexv4GMIzbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=nS9RHlm7; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=wxh7sa8S; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="nS9RHlm7";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="wxh7sa8S"
Date: Tue, 29 Sep 2026 09:43:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1790667794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KzEsdINBBmXBVcSahJG8a4OGgbBJJf5/DV0Pt5R6nBc=;
	b=nS9RHlm7O+JvKW+gUzSIFkKYrOFUwOpVgiDvFX1PZLZp/xtNoF2KwnMvLrh4utrLcA8aEP
	7OqBk46MhuMcNR0B1rzd3Z81mwmVj16rlTnY2N7WBUmCFNDjYdL44BO0PgfV+O4RHjpAca
	T38DmL9pVSwomCMKIumDM8ZR6n1FP3IrLTMjESIsBP06oo6g0LSe4J7qPJpG9hfbbNDQRC
	3kZWwjwX9yUuZPHNPFqYqj92xPCChCjtUbaN7LQqOnTIt7PYkUwWVqugM+T3R+VYYYGwxL
	9EmJlJgfXIeua4FC7rIYmLJbEVMX6Qh3083VydyleQU+98tpUPmk6UiU+fQdWA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1790667794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KzEsdINBBmXBVcSahJG8a4OGgbBJJf5/DV0Pt5R6nBc=;
	b=wxh7sa8SUIVwhPkF/eyoF3z5hLWsx3Lnd/RukkjWeMeYxGniV/c21TV4UIDBbw157nYac9
	aVIWEEb0y4z3y9Bw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Prashant Singh <singhpra@juniper.net>
Cc: ardb@kernel.org, jk@ozlabs.org, clrkwllms@kernel.org,
	rostedt@goodmis.org, corbet@lwn.net, skhan@linuxfoundation.org,
	rdunlap@infradead.org, lgoncalv@redhat.com, 93sam@debian.org,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v4] efivarfs: add nostatfs mount option to skip
 QueryVariableInfo()
Message-ID: <20260929074312.v3jT8uel@linutronix.de>
References: <20260928203445.72318-1-singhpra@juniper.net>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260928203445.72318-1-singhpra@juniper.net>

On 2026-09-28 13:34:45 [-0700], Prashant Singh wrote:
> QueryVariableInfo() is an EFI runtime service that, on some firmware,
> takes tens of milliseconds and runs with preemption disabled, stalling
> the CPU that services it. efivarfs_statfs() calls it (rate-limited since
> commit b2326338dc68 ("efivarfs: Rate limit statfs() handler")) to report
> the variable-store used/available capacity, so any statfs(2) -- e.g.
> every "df" -- can inject that stall into unrelated latency-sensitive
> workloads on the same CPU.
>=20
> Add a negatable "nostatfs" mount option: with nostatfs, statfs(2) skips
> QueryVariableInfo() and reports zero used/available; with statfs it
> reports the capacity as before. It defaults to nostatfs on
> CONFIG_PREEMPT_RT so real-time kernels do not take the stall out of the
> box, but statfs can be passed there to force reporting back on -- e.g.
> for tools such as fwupd that need the efivars free space to update Secure
> Boot key databases.
>=20
> The option can also be toggled on a live mount via remount, so reporting
> can be enabled only for the duration of a firmware update without
> unmounting the boot-time efivarfs mount:
>=20
>   mount -o remount,statfs   /sys/firmware/efi/efivars   # reporting on
>   mount -o remount,nostatfs /sys/firmware/efi/efivars   # reporting off
>=20
> Tested on an Intel Xeon E5-2628L v4, 6.12 kernel, via
> "strace -T -e trace=3Dstatfs df" on the efivarfs mount.

This until the end looks extremely verbose. Even if that statfs takes
ages, that important part is that it does so with disables preemption.
There has been also the introduction of the efi_runtime workqueue which
can be pinned to a single CPU. I guess this doesn't work for you or the
EFI firmware takes all other CPUs down until the all completes.

> Cost of the firmware call (CONFIG_PREEMPT_RT not set, so reporting is
> enabled by default). Default mount calls QueryVariableInfo() and returns
> the real store capacity, ~66-129 ms per call:
>=20
>   statfs("/sys/firmware/efi/efivars", {f_type=3DEFIVARFS_MAGIC,
>       f_bsize=3D1, f_blocks=3D90024, f_bfree=3D33387, f_bavail=3D28267, .=
=2E.})
>       =3D 0 <0.129124>
>=20
> With -o nostatfs the firmware call is skipped, capacity reported as
> zero, ~11 us per call:
>=20
>   statfs("/sys/firmware/efi/efivars", {f_type=3DEFIVARFS_MAGIC,
>       f_bsize=3D1, f_blocks=3D0, f_bfree=3D0, f_bavail=3D0, ...}) =3D 0 <=
0.000011>
>=20
> PREEMPT_RT default and live remount toggle (CONFIG_PREEMPT_RT=3Dy). The
> boot-time mount defaults to nostatfs (mount shows nostatfs); no firmware
> call, capacity zero:
>=20
>   statfs(... f_blocks=3D0, f_bfree=3D0, f_bavail=3D0, ...) =3D 0 <0.00001=
8>
>=20
> Enabling reporting in place with "mount -o remount,statfs" (mount now
> shows statfs) takes the ~70 ms firmware call and returns the real
> capacity, without unmounting:
>=20
>   statfs(... f_blocks=3D90024, f_bfree=3D30315, f_bavail=3D25195, ...)
>       =3D 0 <0.070293>
>=20
> Disabling it again with "mount -o remount,nostatfs" returns to the fast,
> zero-capacity path:
>=20
>   statfs(... f_blocks=3D0, f_bfree=3D0, f_bavail=3D0, ...) =3D 0 <0.00001=
4>
>=20
> An unrelated remount that does not respecify the option preserves it: a
> "mount -o remount,rw" after "remount,statfs" leaves the mount showing
> statfs.
>=20
=E2=80=A6
> Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Prashant Singh <singhpra@juniper.net>
> ---
> Changes since v3:
> - Drop the show_options "statfs" branch; the absence of "nostatfs" now
>   indicates reporting is on (Ard Biesheuvel).
> - Drop the uid/gid copies on the remount path; efivarfs_reconfigure()
>   applies only nostatfs, so they were dead code (Ard Biesheuvel).
>=20
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
> - Add PREEMPT_RT + remount test data to the commit message.
>=20
> Changes since v1:
> - Replace the sysctl with a mount option named "nostatfs", per review
>   (Ard Biesheuvel).
>=20
> v1: https://lore.kernel.org/all/20260917071600.5587-1-singhpra@juniper.ne=
t/
> v2: https://lore.kernel.org/all/20260919044124.8268-1-singhpra@juniper.ne=
t/
> v3: https://lore.kernel.org/all/20260925113145.7396-1-singhpra@juniper.ne=
t/
>=20
>  Documentation/filesystems/efivarfs.rst | 16 +++++++++++
>  fs/efivarfs/internal.h                 |  1 +
>  fs/efivarfs/super.c                    | 38 ++++++++++++++++++++++----
>  3 files changed, 50 insertions(+), 5 deletions(-)
>=20
> diff --git a/Documentation/filesystems/efivarfs.rst b/Documentation/files=
ystems/efivarfs.rst
> index f646c3f0980f..cd81ee84115b 100644
> --- a/Documentation/filesystems/efivarfs.rst
> +++ b/Documentation/filesystems/efivarfs.rst
> @@ -37,6 +37,22 @@ accidentally.
>            |4_bytes_of_attributes + efivar_data|
>            +-----------------------------------+
> =20
> +Mount options
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +statfs / nostatfs
> +      Control whether ``statfs(2)`` reports the variable-store used/avai=
lable
> +      capacity. Obtaining it requires the ``QueryVariableInfo()`` EFI ru=
ntime
> +      service, which on some firmware takes tens of milliseconds and run=
s with
> +      preemption disabled, stalling the calling CPU. With ``nostatfs`` t=
he call
> +      is skipped and ``statfs(2)`` reports zero. The default is to repor=
t,
> +      except on ``CONFIG_PREEMPT_RT`` where it defaults to ``nostatfs``;=
 pass
> +      ``statfs`` there to force reporting back on (e.g. for tools such a=
s fwupd
> +      that need the free space for firmware updates). The option can als=
o be
> +      flipped on a live mount with ``mount -o remount,statfs`` /
> +      ``mount -o remount,nostatfs``, so reporting can be enabled only fo=
r the
> +      duration of a firmware update without unmounting efivarfs.

could this be, I don't know something smaller not including the
commandline where I would expect that people know how to use it.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D     =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
(no)statfs		Control whether ``statfs(2)`` reports the variable-store
			used/ available. Disabling it skips the EFI runtime=20
			service call, which might block the CPU for a few milliseconds,
			reporting 0 for used and capacity. Enabled by default on
			PREEMPT_RT.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D     =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

It might make sense to add this knob to Documentation/core-api/real-time/ha=
rdware.rst.
I am not sure yet but slowly we are getting more knobs that I have
expected.

> +
>  *See also:*
> =20
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
Here and below you add a comment to every change you make. What about
focusing on the important parts, that deserve an explanation why a
change has been made. For instance why nostatfs has the READ_ONCE/
WRITE_ONCE accessors and sometimes it does not.

>  };
> =20

Sebastian
