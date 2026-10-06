Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313123A7848;
	Tue,  6 Oct 2026 10:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281128; cv=none; b=mFzaEYCvxgFzznpsbJ/HWB3tsdWj6uPDTy8I7yOpjINsvbdSwaQUNs9XBZ2WZoIqNThj/Nq8RpmIkqAFP9yEKIXVipOucNCDEqQ2xxpZoOuWqpTYS+blnFzWws+U6kloGy/b4o8KzVfyxXj5uH1VD2H1/pPU8zNA2jhM5Cqt6Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281128; c=relaxed/simple;
	bh=fbPDTBgxcNc4frP04ynj36JJjE0DJEvTQUZtg4wjpw8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=tO3QDhWQ8pc4gW9N3u8Cx8Qirw1pFHBBkcYzTOGnUJcdssJLiZV4s7M2dENmh/2pzOzJQWAN5GHAmMl/HKqsnugZgSBeH1ARJA3r0T/fCb2ry3lqwwh7pFCgilWpbei4u6tO8KlZZGWZY2VyN89+dDT/ev/yNYJ0HZfzi/2J/nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QBZKfX/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QBZKfX/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93F51F000FF;
	Tue,  6 Oct 2026 10:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791281126;
	bh=P0gaccN33x1zR0yRwkXVzbN2o1v/zgrTQBD+C2wLJpE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=QBZKfX/GUjQ1iVp3NB9B23SVqu+h4Zz9mTWbF6+19VrcS/J2PwkDkmbWYSz4Y+3mW
	 iGrO8hUbxqs3xSlqUFF6rkMOngK0JO+VEeS6HC8E/XYVCDtqS1En/g3PInGOp/tJCw
	 8zMADuT9EopY0gYrCh8vlavd+ty8wzL/5Rl+Xoew70bI76wsdk+SWUrqjfRDJFdvue
	 Ni+1FwLMqUIYMSRr5szq/Y86MToSwdDDiiLILHE9TY0+bHyF2+Z163yzfTG0cLRyaW
	 CE4yQiCESBEEkTwb4c8OB0zzSkWXQ82dpWP3H+sWpaWcejuxtzl6AiWZYvmXM02Sxo
	 fNW7Uk4xSYtnQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 40E411980047;
	Tue,  6 Oct 2026 06:05:24 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 06 Oct 2026 06:05:24 -0400
X-ME-Sender: <xms:4cfEasecX5dHwyBMqcsge1J_p13sg2csr_ZpV0RtUu-XpNd1vvNVxg>
    <xme:4cfEapBek08CVktQLN6Atrdm8O3CzHlUVQZtnZxo25qOug3M51fcL6_lWnoE26AFS
    zsN0l4hUf217HccbsOQJO9sCrNRp59zi_qiCuPSBhFzU9_byOXOaclH>
X-ME-Proxy-Cause: dmFkZTFWsyfHX7a8C7z4wo1jArpTxqIu2nY2fVAWcV0ZROeoNnzn/ndkhrerpdQR66Tjia
    EKcm3CqTBjXmh2AbcFXux5kLeyCSfbtjSGEe1LuO5eb5Wyz+aZYbHEpsXqZgSs+Aag0O/V
    1T4YIIbdm7gPs9E4/oJRxJ4N4hLx+B3qNkdzhTPsjipJA9uYdrqxG8AC9GcJgtmJmBWevj
    3BMke8FRumRCoxSbMQxkqF9pmnoMT/UU8VGlCZk26fCuUo7Y6lUX8U1/NH1wH5CuJUO1fl
    y770V3LD/BqJ9oyl2BW5EwbWCukQzejlQ3qAm3tFSnz3gT0tC79DNyK41fjtCWXxeR9QLF
    ujFPffa/b+1I+zx+dM3UDZ6NZUBTucs7mGBT6OHtN114vYSuDEUS3BVoPZEaUks0Ag9FjK
    OhkiCQolQeHdR+sLRQ/gL+x3gWo8XsYbP+xLYda0gewYcbZmdR8squQ2WhW83NMeIubcSN
    LupIuY9ZoHl1uYNhcJ4qFfj/HfpCg+fRxtPfb1k+vqDx5EmVyFAWEmgQ9wR9WsoeZ72Nhs
    pq12kvPnimaXdarxgYoE2wXsPq5uwI0QKrt7a9+LHDir+xO8dAge8myAbxxwSIZdhW3P6Q
    Bn3a5Y49nQAU6s6dvFY7kuzV53b2trbk1/eq9mOG5E6LSfhJ3mybENsikbuQ
X-ME-Proxy: <xmx:5MfEavXXHNHO_ycjdzDtNo-ArZXqKAu-Cg0jUCXFQ4oIKdzdQcEgaQ>
    <xmx:5MfEavLgu9VrDpxIbdobMY2LvrtJcIrwHSZKrIbJTdQmHIg0mLpokA>
    <xmx:5MfEarA92yJ78tjJzOxYBS6iFohtGhBdHogxSD_wIAJsIORNQGmWPg>
    <xmx:5MfEanHDuALAFUi2_eXzjOB3vUuNXI6ORBDAZe7zPjFJkcOu0mbIPA>
    <xmx:5MfEagJFwGaKqfYmisXASFUIMd1iNooFiuf32mDyv4HxpOMyJmt7bE2q>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id E877FF8008E; Tue,  6 Oct 2026 06:05:20 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 Oct 2026 12:04:58 +0200
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
Message-Id: <51171e93-6335-4d43-8775-db2bd0dda5f0@app.fastmail.com>
In-Reply-To: <20261006084158.11523-1-singhpra@juniper.net>
References: <20261005232250.2620-1-singhpra@juniper.net>
 <fd8750f7-a30c-4b60-9254-395858bc9aca@app.fastmail.com>
 <20261006084158.11523-1-singhpra@juniper.net>
Subject: Re: [PATCH v5] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 6 Oct 2026, at 10:41, Prashant Singh wrote:
> On Tue, 06 Oct 2026 09:09:33 +0200, Ard Biesheuvel wrote:
>> So what happens with uid=/gid= in this case. Do they get reset to the
>> default or not? And before this patch?
>
> Preserved, not reset to the GLOBAL_ROOT default -- and unchanged from
> before this patch.
>
> efivarfs_reconfigure() applies only nostatfs to the live superblock; it
> never touches uid/gid. uid/gid are parsed in efivarfs_parse_param() and
> stamped onto inodes at creation in efivarfs_get_inode() (inode->i_uid/i_gid
> = opts->uid/gid); reconfigure() has never re-applied them, so they are
> effectively mount-time-only. A uid=/gid= given on remount lands in the
> throwaway reconfigure fs_context and is ignored -- the live inodes and
> show_options keep the original mount values.
>
> Before this patch efivarfs_reconfigure() only had the ro/rw guard
> (efivar_supports_writes()) and never applied uid/gid, so there is no
> behavioural change; the patch only adds the nostatfs line.
>
> Verified on 6.12 (Xeon), identical on a stock 6.12 without the patch:
>   mount -o uid=1000,gid=1000   -> uid=1000,gid=1000  (opts + inode owner)
>   mount -o remount             -> still 1000:1000     (preserved)
>   mount -o remount,uid=2000    -> still 1000:1000     (ignored)
>

Excellent, thanks for clarifying.

I've queued this up now for v7.4
