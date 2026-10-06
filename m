Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AFB260580;
	Tue,  6 Oct 2026 07:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791270606; cv=none; b=bHBFdlqFUGaOn/2zWedMcR45/syeDIGQvL3rTe0e8nTSwoZPxI+SzxwW4Y1ymnH5ShyS0oz3ameBsezP3Qw5hatqTNSimYbDufQMvk556S/GxTbrORNVH7KS3YTUdAuQ4VJ/txc8xHvPYLSeVy96vNvou0mVIsrZeYQ1GSz9Puw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791270606; c=relaxed/simple;
	bh=/qpRFrkBociXKpV7oooGEKkR1Nt08nqoDdbWI3A0wKA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=plK/bBnZrmbirKlyqobJJ759GcdX+/liYzUaRPJlx24QDNaJCNQd7yUI7V5ehNNSlDLlrLPqXljZQAOAUIa1+H1tbWdnZYmGjP9Vop+jtQSTj9i4wNcskWsZXN7euqqahmtgFFwDdVAoZTwv8SX2G+Gs9lWf80qBYY7mfVbtlbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLeaJp2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CLeaJp2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB1B1F00898;
	Tue,  6 Oct 2026 07:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791270601;
	bh=sOQijHY7DJOOHAhEBNsA40M7U1qEh85aVMqxzjjd0bA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=CLeaJp2foe5xzjpcqpnf2x3F+NnJZyLK4BSSJjAKzvOIliqfAc175XHfGrnCMfer0
	 rlWBmiYtcbJemp/UEvf0ErX3SoX1O4vdv6bGCYAMSjlW35luhdY9vyN2OBoI0P7b+w
	 FP738W8INGEg/Ef2lz+EIctRNfRG+F88KqlB9ePft6O6IZAV9NYv4og/HaaoHSCKtF
	 P0KzkC+VeOPYNn3yrl+mo5dML6IHgq/SBNRpzDTEdfUjRleRwXyxloa1A2c4d7vrt3
	 hVgrpLFUAGMyXQs4oR/cBoHjByOVgEHrmdx0ooL8VebEXAmi4prvbl9he/6KToFTdk
	 QENFTaKLzG6TQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id F0603198003A;
	Tue,  6 Oct 2026 03:09:57 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 06 Oct 2026 03:09:57 -0400
X-ME-Sender: <xms:wp7EagYWhHlq7xL1kYHRmgEElwA-nzXqIMDtbtoqZGd-rSBtE9NGcg>
    <xme:wp7EamOYHcZgAhBie_hci7Pm-UgipQX2ZQXFHISNO7WEJkKuu8fZggt4ugslGK_hW
    I_-TbHC6sacI9dSy9tp_StGGnVVo7FHRHTgcsDqukvuo6rRl8_YQa1b>
X-ME-Proxy-Cause: dmFkZTFfYsO83d1bf3d4Io3qJyTppZEdCv1hE3mBjiapHPJG+0iU8DU8ctD2SUouDVFqRg
    3zYPX5y+97aiFVbZ7IK3tcRwE8ObcNvN+PppQ/SAOtLPXBU0y0PTq6WnxioTfESm/8dx2k
    e1bobayFQdN/UM+hMi50uWFzudrcl04Z3z87PMq3YculaYF9ywHAq2xJWpQbQLW0/yPTke
    jOZju+CNmCmKJjtZ9br5bFlQFGu+Vyb7bz3RgBH2BfMphtpLwz5TmBij4ug0kydn6Wnzx5
    4Awq5nrHBiEDCIe3y1kpHrymIFufcSXE1I5mZ6D1jcRbWK19jzlmbmR+sk5JEUxy77f1MS
    7TBLKgroitpdRZ01vaTOvjZB2uuxx9XRuf7FkRr+Au+ysVO5FbsSl1xBXAMExggv2FhXZZ
    MlnjIi5h8m3dneGwyTwnvZUg7If0Y6MXP3ZiBFKP38afgGjsYVxfcGEhHlGG0VuT/0qNTq
    OlpQ2Cf/7a2xCeGtX5LKGU9iAapYT0IsRCDxAyluzjE0hu2e5IwNr2hwgcMh3qPrtjJNmo
    iVHS6sNSk81pxVcSpSHXJFojRufDW4w46KRx11h9fzlxJyzTWLs/gj5pMRNMqgxLX+yryG
    rLvGU09IQ6F7eRVFbqvJlzQvHUnmUuAbYqf2xK+7S8BNh0unO2XvCD/1uP4A
X-ME-Proxy: <xmx:xZ7EaqTQMwbMgLCTWexKSfRRhi7S7jcpk8J5yTE6d6zBm80N9R13zg>
    <xmx:xZ7EanX9RBfHGowOOldudbaSN05ZHp6jmS6yTQ_DalnL9b47jrsypA>
    <xmx:xZ7EancTnhzFoww7u6ATK4qonH_Tp4dJf0H0mJAGP4gBkifLCwbhXQ>
    <xmx:xZ7EaiyTMgzSuVvFeIrFUsp4noCn45ltaESBZsF0oUmqBS0defEfww>
    <xmx:xZ7EaqG5o4oWt4XHeEIuJIPsWqg3O4MFmYVVjd9aV4kiFNnHwHqcXLCg>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C73EDF80090; Tue,  6 Oct 2026 03:09:54 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 Oct 2026 09:09:33 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Prashant Singh" <singhpra@juniper.net>, "Jeremy Kerr" <jk@ozlabs.org>,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Jonathan Corbet" <corbet@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
 "Steve McIntyre" <93sam@debian.org>, joaoanandalima@gmail.com,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-rt-devel@lists.linux.dev
Message-Id: <fd8750f7-a30c-4b60-9254-395858bc9aca@app.fastmail.com>
In-Reply-To: <20261005232250.2620-1-singhpra@juniper.net>
References: <20261005232250.2620-1-singhpra@juniper.net>
Subject: Re: [PATCH v5] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Prashant,

Thanks for respinning this.

On Tue, 6 Oct 2026, at 01:22, Prashant Singh wrote:
> QueryVariableInfo() is an EFI runtime service that, on some firmware,
> takes tens of milliseconds and runs with preemption disabled, stalling
> the CPU that services it (and, on firmware that services it via SMM, all
> CPUs). efivarfs_statfs() calls it (rate-limited since commit b2326338dc68
> ("efivarfs: Rate limit statfs() handler")) to report the variable-store
> used/available capacity, so any statfs(2) -- e.g. every "df" -- can
> inject that stall into unrelated latency-sensitive workloads.
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
> A remount that does not specify statfs/nostatfs keeps the current setting.
>

So what happens with uid= /gid= in this case. Do they get reset to the
default or not? And before this patch?
