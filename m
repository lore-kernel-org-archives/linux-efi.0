Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B1551FCBD
	for <linux-efi@vger.kernel.org>; Tue, 29 Sep 2026 12:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790684580; cv=none; b=UpMDQHiDuDukOWapDaMBrV060e1ygU0OW8QWSodmSxkQ27TJ7wY08x0mSqnnmjokwcPeR7KdN0/SbczW40/o2dJOqgfSGnMdQr1+t7rMinyyBwdxlvjTJuWY63kmiAutgEcpuHEKdUIRSV0vsSHsVOuS8ZXstV0kF4oNqlejCnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790684580; c=relaxed/simple;
	bh=6QEaADfaXLCRdOUWWu0nY6VbePuVEBMcOGAcZQncT5Q=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=uMBn9ewqeObWtwA6d4QYEA+Jk+VC4MOhbOsoHMqHjpraoIKmIZDrtGknrz1rjcNqojZ/h1XeSPu/Es86dq2jNgCFFaQ7L9fcb3z/cHvVYXGqUyZWhsMnKJkYB4x/t9QdM7jHAj8iimCcCliFFVxHKQW8IWX9p0F7c7LgZe5XcGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d80sDkKt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d80sDkKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C675E1F000FF;
	Tue, 29 Sep 2026 12:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790684577;
	bh=iSzVu9OwDDKxOSjGO9fkBCYVmRFSj5orb28UskQyMkM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=d80sDkKtMEyVQkdw2pshzKKKdx98S4oV3YJfHZSRJgT/PlHGMvzY8Z6Z3Ol+6SCU6
	 cgxWlVKkNyEdvo4W238v4C0WLQeTWfjX87Msv19olm/48XgUACRHKYoiT0kkevsxoi
	 pIWeJNorj7ojYlr/666p/I4SX7CO5Nui1bWu5ozfFW4TbcKykjS/yTPgC8KY+GYpY7
	 Zj5vram10u6m4Z2ETZS42snGUEPg/6SXMRP/869ie+lPsmxDrq1R/Ene3Uyst3lipL
	 4G6RgNQNfaNDvxrSzZ4o32k5oLxHKqaSObq3Ia2I7p9P//9rCbrdYU25v5y2cgWrG3
	 eNwBR2kZob+AA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 11F151980050;
	Tue, 29 Sep 2026 08:22:55 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 29 Sep 2026 08:22:55 -0400
X-ME-Sender: <xms:nK27atFqomlGV2UEjoqFdmOK3Y8IOZP3H5K6BHxv4YJSW82tZz2C3Q>
    <xme:nK27atIUWnhxcFpsf6mQHoXvOkjAo1PiJP2OB02I_j8CtElNsezTkhNEvi1etIwX8
    jImmgpK3hi2kVctHaZyPQBFh2CFLWSVIJ_B0NKgSZEuZH4afrHmyWvX>
X-ME-Proxy-Cause: dmFkZTEDFjcPpHlmpkQRZITCYrIcMttwRfx+2D/INT7R3trpwOZHl4PWCw5n4lgiDnG85h
    HoxMVL9u8TrY/SzF1B75DE0C2B57mS8Erprifw+yAoB7NCv0R2o/vqeXE5Twas2a9Js/TE
    B/BCvis7tHqJM8o5Ha9WguGhk0bAmD2VOFoCm540fWGtejPMXzLGVqDZvFf2WeB+WqRPG6
    sOD/vsTrwxMmqZA5SxHt9eQ0AQQtwrAmhpz7QCoZjbXMIyJ9Et/u+3Z9IWQ7YAH/HWMN7o
    cxEho1rZaYTDnu3zfzBz4vDCZuDL+qPIiHFWdiNGRKtRb924KVsxYKUrR9NHyIUqm6x8rd
    OXluILFCRMtuqZnv8m4vI378VfHv40BQQbo5knaglo/dVqg9dUY5Ork/NPpSVVDHaBgzTM
    RZvMM5Tohpzg+52ZBw1wGnqWIrQKgjjntkxGC3+eLAJzIKIxOxNEgATpgwsGLi9CAnPNQO
    Ir7iUsaqlCrDBKS63xhp72dsVXtSI7mkZiHLbm/YbdWXCSXicEN19I3Cn4/glSy2HkfSUg
    YqJItdoo8UpUOClJ4zE99qm9aplhtkqnoN1A8AslXqM2RLOBqpxYqjoVLS+Gx7M9uD4IYb
    Zwip3/pRir4PwgwhpcOFCw4QGfstSb/OEPnp0QOwjj5EEdVkd4L7f5THmALA
X-ME-Proxy: <xmx:n627ai3_wYBiwMYAVwqs9t59pqrX0DOHBpL9nVgBncHmfHZb261T8g>
    <xmx:n627avcojehXun9VOwoFJT5tqumgvF0vTOQzMw_3T3astm3oEKHRjg>
    <xmx:n627ahD7YnlvrWz8teuu59MphbWLdas-u2vnc0TNdLaj98lsHvNBOw>
    <xmx:n627au9p3AqdVNaTtgTFbkn0mQG8646iSw8s46aMwFginBrz_Cwe5w>
    <xmx:n627atrZhCVR34YjziFKbxbsQZkvsELvpNgC05WfaJcbGhMwwnLchXHD>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 072BFF80080; Tue, 29 Sep 2026 08:22:52 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 29 Sep 2026 14:22:31 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "Prashant Singh" <singhpra@juniper.net>
Cc: "Jeremy Kerr" <jk@ozlabs.org>, "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Jonathan Corbet" <corbet@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
 "Steve McIntyre" <93sam@debian.org>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Message-Id: <59d5452c-42b1-4784-a593-5e549a2a0f12@app.fastmail.com>
In-Reply-To: <20260929074312.v3jT8uel@linutronix.de>
References: <20260928203445.72318-1-singhpra@juniper.net>
 <20260929074312.v3jT8uel@linutronix.de>
Subject: Re: [PATCH v4] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sebastian,

Thanks for taking a look.

On Tue, 29 Sep 2026, at 09:43, Sebastian Andrzej Siewior wrote:
> On 2026-09-28 13:34:45 [-0700], Prashant Singh wrote:
>> QueryVariableInfo() is an EFI runtime service that, on some firmware,
>> takes tens of milliseconds and runs with preemption disabled, stalling
>> the CPU that services it. efivarfs_statfs() calls it (rate-limited since
>> commit b2326338dc68 ("efivarfs: Rate limit statfs() handler")) to report
>> the variable-store used/available capacity, so any statfs(2) -- e.g.
>> every "df" -- can inject that stall into unrelated latency-sensitive
>> workloads on the same CPU.
>> 
>> Add a negatable "nostatfs" mount option: with nostatfs, statfs(2) skips
>> QueryVariableInfo() and reports zero used/available; with statfs it
>> reports the capacity as before. It defaults to nostatfs on
>> CONFIG_PREEMPT_RT so real-time kernels do not take the stall out of the
>> box, but statfs can be passed there to force reporting back on -- e.g.
>> for tools such as fwupd that need the efivars free space to update Secure
>> Boot key databases.
>> 
>> The option can also be toggled on a live mount via remount, so reporting
>> can be enabled only for the duration of a firmware update without
>> unmounting the boot-time efivarfs mount:
>> 
>>   mount -o remount,statfs   /sys/firmware/efi/efivars   # reporting on
>>   mount -o remount,nostatfs /sys/firmware/efi/efivars   # reporting off
>> 
>> Tested on an Intel Xeon E5-2628L v4, 6.12 kernel, via
>> "strace -T -e trace=statfs df" on the efivarfs mount.
>
> This until the end looks extremely verbose. Even if that statfs takes
> ages, that important part is that it does so with disables preemption.
> There has been also the introduction of the efi_runtime workqueue which
> can be pinned to a single CPU. I guess this doesn't work for you or the
> EFI firmware takes all other CPUs down until the all completes.
>

Yeah the most severe issue is that entering SMM requires a rendez-vous
of all the cores, and so whether preemption is enabled or not is
actually kind of irrelevant, given that all the other cores just
disappear.


...
>> diff --git a/Documentation/filesystems/efivarfs.rst b/Documentation/filesystems/efivarfs.rst
>> index f646c3f0980f..cd81ee84115b 100644
>> --- a/Documentation/filesystems/efivarfs.rst
>> +++ b/Documentation/filesystems/efivarfs.rst
>> @@ -37,6 +37,22 @@ accidentally.
>>            |4_bytes_of_attributes + efivar_data|
>>            +-----------------------------------+
>>  
>> +Mount options
>> +=============
>> +
>> +statfs / nostatfs
>> +      Control whether ``statfs(2)`` reports the variable-store used/available
>> +      capacity. Obtaining it requires the ``QueryVariableInfo()`` EFI runtime
>> +      service, which on some firmware takes tens of milliseconds and runs with
>> +      preemption disabled, stalling the calling CPU. With ``nostatfs`` the call
>> +      is skipped and ``statfs(2)`` reports zero. The default is to report,
>> +      except on ``CONFIG_PREEMPT_RT`` where it defaults to ``nostatfs``; pass
>> +      ``statfs`` there to force reporting back on (e.g. for tools such as fwupd
>> +      that need the free space for firmware updates). The option can also be
>> +      flipped on a live mount with ``mount -o remount,statfs`` /
>> +      ``mount -o remount,nostatfs``, so reporting can be enabled only for the
>> +      duration of a firmware update without unmounting efivarfs.
>
> could this be, I don't know something smaller not including the
> commandline where I would expect that people know how to use it.
>
> ===================     
> =========================================================
> (no)statfs		Control whether ``statfs(2)`` reports the variable-store
> 			used/ available. Disabling it skips the EFI runtime 
> 			service call, which might block the CPU for a few milliseconds,
> 			reporting 0 for used and capacity. Enabled by default on
> 			PREEMPT_RT.
> ===================     
> =========================================================
>

+1

> It might make sense to add this knob to 
> Documentation/core-api/real-time/hardware.rst.
> I am not sure yet but slowly we are getting more knobs that I have
> expected.
>
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
> Here and below you add a comment to every change you make. What about
> focusing on the important parts, that deserve an explanation why a
> change has been made. For instance why nostatfs has the READ_ONCE/
> WRITE_ONCE accessors and sometimes it does not.
>

AIUI the READ_ONCE/WRITE_ONCE were added because Sashiko warned about
potential KCSAN splats? It would be nice to mention that.

In any case, KCSAN is runtime instrumentation, and efi_reboot_required()
is only called after all other CPUs have been brought down. So if anything,
this should just wrap the read on the reboot path in a data_race() so
that we don't trigger any instrumentation inadvertently on the way down.

