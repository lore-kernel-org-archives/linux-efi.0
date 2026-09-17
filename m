Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156CE47C116;
	Thu, 17 Sep 2026 08:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789634218; cv=none; b=oAlTCtWx4gWoJ9MtiMxi9Kp+Ii5TSeBfZ56WIngq3yw0jZPO8fKl27Iiki0tOZRQs5Hbnqx4NUvN0Qw28+k0zYsfRXD2aaR5KNr50WTTJEwx7adzwtUBIzcYq4QsT+mNZ+usP1oEL8lje+4bJB3Jb+e/E/2Fe3V8zJoEhQWOB8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789634218; c=relaxed/simple;
	bh=AjPQQ34DjEurplenLQ7sBH+VHMaZnGFbeJBQVIWEoTs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=RR0M1ygdRaLAm/GBqH75fEcxqlzt9CqOW69KhKGE+vhkUVZcFecORvRVvYBBTF9v0Azwn8tSFvy00qhKSemvyokSDxSn+EoIgFggdEpPL1zKX6jmAsAva7T/XyCBByDxyZkJWyRYS3LRArw5Qgt/cIy/s0uKUZqxRIb2EyQ+zIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTwzq7Eo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTwzq7Eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608871F00899;
	Thu, 17 Sep 2026 08:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789634211;
	bh=AjPQQ34DjEurplenLQ7sBH+VHMaZnGFbeJBQVIWEoTs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=GTwzq7Eo0fBeR7MbMPqG5QLnCXLBSCeWvnu/N3aKXYGQ2NJ5mpS7jNeHApp2BVkEh
	 TGjtPquNf1ssqU3LqUcdUGEut8DwCIblXT674DSBUi6tNfbgpjynjyaMlWZQ8+z7C4
	 iVi4opq6Zv0A5Ej/KrP6xAvxFlBWgodtpMWTBIINbx34ZRlDr6uJFMVEQuSOQiYL+B
	 fB7eATby8veC/x7ZoDQi8Rm83xicxahVrIa0imLmvrvRhtgIOPgB+Y2rlB9geNt+xo
	 9P5JEwqqo53McOnSUqDzI4mGwrDXSEE6jMABDE5xhyvQit0bxef0Mvrq/ffLXvTSmC
	 fYy4WwAr26v0w==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id BC76B198003A;
	Thu, 17 Sep 2026 04:36:49 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 17 Sep 2026 04:36:49 -0400
X-ME-Sender: <xms:oKaranGauXjJYBj2OHr5Ts3ZvWM-4P-vVhEP88gSLbqJWXHSD3BNHw>
    <xme:oKaravIbg2HlGEmoHcVv_BjVLGPcHG3OsFaw2-tJq5-Ru_f4b8y5ECjPkzp1utBBK
    P23XCMBuaGC-H9G9AqqrsLxfuebjf2uUpS9Ra4GUy5YXVdrvKdU4dp1>
X-ME-Proxy-Cause: dmFkZTGj/iOcN9vrW1Y04XJ/AbklSHO56cmeyUArUFrIGsnEAsW1WzgWJpdGXhSDI7lJyV
    bdMpwFH+usjcjY7/COJk6gayth2TOAtCB2AC9NXaVyvx0FogMmVkwM1Rt5S1TRPBRm0AwW
    Tz8HpyDOcazHAujGIOBFh6IFCRZtW425tt72Z39CVDtoa3ORSC+Ab5eZ5DsUyRSHg0b8Ac
    RGtdgKZNiuJRaMiyAagQi6jtB/FMOuFVuHwUvCBgudqw1jy5engrVn8IUrhoE50CboVrP/
    7XSOVhIVuwZO53XChsmGCLD65qwOHNXmjVM9BKT62ezMOPmUR/BFSF8mPh4tQ7lGprTrWa
    9mTiQIc8wc1GAN+3Ahl2dla4xmDGYl4+yfi5TEvlPsdiC6jeqYR8W7l8UN2Ni3RsWaw+gx
    9p4WMNomgaOJXC0V5EXrDlzDqcSepzundyrYNOynftfN4nZtOPuO3pnNw+c1JV+mvLx4PE
    T3Hmx4bqGAmTNFStkN59JUhRUv4RulqdoOFRxmDOTL41GS96e3lSuaGGMvfG3q1KJgXLzn
    eBMfQKYA8whbXtNdH4j9kMHopFEzSkAj3BFz3VCcZLHtjntDm0++6RnViXGiuQmVfHH4gh
    u74N2kVAktG0wMcyiOsA3vRrJIyLrumMiHT+OH6wyx+ummuByCYwrog0GxOA
X-ME-Proxy: <xmx:oaaraqqUsvWTVUn08_QhGUNB-TZy4cvST8lLYfiHzLuf9OGB4DDBLw>
    <xmx:oaaraq4MIIb6MeK-bsdetCGQ8aC7D0y_JCeibS3zNQuiAnAdrvwyHQ>
    <xmx:oaaraheWtWY6kO5-2xy6uDVF5Y2vxmU6O9oCu6BnoyOMX4mMhutvoA>
    <xmx:oaarav7_DL630r33YPBKlyq-QbrG3RS6-Ocm81lTh_KRXnWrN7nDtA>
    <xmx:oaaraosHZCMzFL_XVKvF4xJ_HoeSk3B6IOBOU5KxHzCCqPe1SeDBpQGu>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id F059AF80084; Thu, 17 Sep 2026 04:36:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 17 Sep 2026 10:36:26 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Prashant Singh" <singhpra@juniper.net>, "Jeremy Kerr" <jk@ozlabs.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Jonathan Corbet" <corbet@lwn.net>, linux-doc@vger.kernel.org
Message-Id: <60d0b7a5-cc1f-4841-b4f2-754e1b921794@app.fastmail.com>
In-Reply-To: <20260917071600.5587-1-singhpra@juniper.net>
References: <20260917071600.5587-1-singhpra@juniper.net>
Subject: Re: [PATCH] efivarfs: avoid slow QueryVariableInfo() in statfs()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Prashant,

On Thu, 17 Sep 2026, at 09:16, Prashant Singh wrote:
> QueryVariableInfo() is an EFI runtime service that, on some platforms,
> takes tens of milliseconds and runs with preemption disabled, freezing
> the CPU that services it for the whole call. efivarfs_statfs() issued
> this call on every statfs(2) (e.g. every "df"), which produced large
> latency spikes for unrelated latency-sensitive workloads pinned to the
> same CPU.
>
> Commit b2326338dc68 ("efivarfs: Rate limit statfs() handler") already
> bounds the firmware call to twice per second. That helps against a
> statfs() flood, but on a real-time / dataplane system even the residual
> 2 calls/s x ~40ms = up to ~80ms/s of preempt-disabled CPU time is
> unacceptable: any unprivileged process (or a periodic monitoring "df")
> can still inject ~40ms stalls into a co-located latency-sensitive task.
>

Could we instead introduce a mount option that disables used/available
reporting entirely? Feel free to set the default to 'disabled' when
CONFIG_PREEMPT_RT is set.



