Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205DD234964;
	Tue, 29 Sep 2026 06:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790663548; cv=none; b=U3L3AL/GVZeIPTIJKUqqWMDNRS1bOfMV8uY778TD2P7sVIRRW3y0KdI3ST9Hp2h9Q5MKXEZV90cKwHs+azs8H9uVt7eQoOR4FNAw47lleeYtowhSjWBaWObD5ICSucXXptrjF8CumalPT/3k+6bn11HUnkHP6MErLucCQf+5ejQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790663548; c=relaxed/simple;
	bh=AIbzTbZ/AofnIejMdWe2PPEZVfsXawvroHwWq8ciIW4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=I9GXpGqMWj8ndjcedeS+TE/uOuqFmb3aVPM3Ii3BgUGmVP8wm7dGkgWWCoszrzaAexH6zJ++FG7MZLgeVviveTHRKSkJen9cL9dKbcsCIYMvR1Ndi7W1+8FtoUaZU81tckfGwPjZ/5SNCNFxppiS+/IlbiwZqD9YwlP/HKliCio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmUrCK1y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmUrCK1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CCD1F000FF;
	Tue, 29 Sep 2026 06:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790663546;
	bh=ye191Qsb4WmX9ajAZ1ttsvrrzjJ1uJXF9ugl/Q2S64I=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=YmUrCK1y26pxBzNyPcqSc+E/ZHJ9ATUOUnxaCqlQDM9RHxVRq+dqzns2G2CFsSaq2
	 +EHGI9pzW1gm4GeCnWrzgxngLr8IpCZOHL0IlzGmr6jRbj0FZ4yuzK7MKZWktBZSKn
	 t6UHKwUqXFipz5gNM7x7OWH8GkUsuh8wFJlV0jvtr93brwl8Gw5wVFxYujse+9/bA2
	 e+9ywVg3/B3SqE41UfH+zuRmBycVVmN9ufej/FgCx3LJAj0NJ1H1Qp8Mr1dNDB603H
	 f2HdYAsqlwivU0MAmeLaJXhWkPBHNf9ZKUT9jTc39b+lgCyJKLIxqKWs4BsomsdOre
	 ohWHWgsX+bcbQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id B42DD198003A;
	Tue, 29 Sep 2026 02:32:24 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 29 Sep 2026 02:32:24 -0400
X-ME-Sender: <xms:dVu7aqkLo6hdQ57uKKcLcMT-_DX1qul7lHGOsJjpE99ELtjumpgRyA>
    <xme:dVu7asqgQHOtuuSw1ByS2py3FkBV7Rv7uM7vVfIhT0GoxbxAL532u2GSa5ky-r8lj
    sCkSKhxs7OHQdRqvphV80j8XiX8gce-k12F0HJGZQItQz_IbSnimeea>
X-ME-Proxy-Cause: dmFkZTFRLkXnksJ+VexXEjoQC+YpGDk1a+NcmxZAZkbAT8An8Fh8r+nptUsAWHqiNi4yFw
    lWHb6EEyDVp4wKQFdcPPkaUacLM4/AkI0IKNpBSfYs7l+ZWqd/G5vieDCnBwXb+amm55rE
    dnoYjhgcVBvODbyEKIsy4822ogCFaNOZfh1vguTTQgcP9iGZH25xrmyNsDW6rn9eN+yZ2N
    TMweaMPFSIM8h7oEoMufy9xK2W4hPkY6mkZGYxH5YBeihxKvNnxxtf0fQreEmmObSafRMt
    PEvC77VxKHIQz234ejRZl2ZED9lBrywxc/nnJbdkLzDhwXiCBaUy6viktYYiu8T0VmV5VB
    B93MCVGS9Brb4ZbcLvw380lOMbP0paDwYkZovYzTPglcgQ124ugj3vViNsRaQN68qvMuTY
    9uAb1yg92D2LE/Re4sdKnajxDM6/bdmBDdX8Loesh8m9kJvBLLot7DuAhySCu7ZTyUaMAb
    PosVUR+ISCkNJMusAkL9HdEVM/CJ9T6kwUzilueECA5xrj7qwcpyS9ZECB1hc44NEMcA/i
    lJheJIOr5dd1mdhwHxhQaOZARiVO1cIRtFWr14mlTbeqMpP1d5sdWS/nDiHO6ziGsmPmPT
    Qwg5f2G7RYeRVJj6KEMLld+CdW+N7797TXiWcuHgOSBWCfjdvnh2jAlYoVvw
X-ME-Proxy: <xmx:eFu7akXSkxCzmDCPFfwDUimJWqLb_o4whKo9v7bXO4A3xVsp2niarw>
    <xmx:eFu7ai-aqxLoi4nYZziv47NJnBtM0TfVt5wNKuGcIGKyLDn1cY4IkA>
    <xmx:eFu7auh_sbGQK4An-7IHWtTR7TL8l3iGNXyxnV_50dqVEVZ2XghfbA>
    <xmx:eFu7aucJxVYKpt8VVwqz3_RDdYeWEwUO7TqhXwIiZw32ZMBd0z3ykg>
    <xmx:eFu7anLG6f8IzfpqfkLjL4ZqAR842zWkLhBA1SVHyMSBCVuealHBw_eS>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 8B7A0F80084; Tue, 29 Sep 2026 02:32:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 29 Sep 2026 08:32:01 +0200
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
Message-Id: <52dfcc0a-7896-48d6-8b63-a160b9b3d0af@app.fastmail.com>
In-Reply-To: <20260928203445.72318-1-singhpra@juniper.net>
References: <20260928203445.72318-1-singhpra@juniper.net>
Subject: Re: [PATCH v4] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 28 Sep 2026, at 22:34, Prashant Singh wrote:
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
> Changes since v3:
> - Drop the show_options "statfs" branch; the absence of "nostatfs" now
>   indicates reporting is on (Ard Biesheuvel).
> - Drop the uid/gid copies on the remount path; efivarfs_reconfigure()
>   applies only nostatfs, so they were dead code (Ard Biesheuvel).
>

Please don't respond to questions by respinning the patch without
having any discussion at all.

I asked you an honest question, and it seems Sashiko spotted an
issue here too.

Is there a problem with how the current code deals with uid and gid
on a remount?

