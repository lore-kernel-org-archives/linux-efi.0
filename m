Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D90A356761
	for <linux-efi@vger.kernel.org>; Sun, 12 Jul 2026 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783873542; cv=none; b=Jv089VvHux7mRxHn1FY5tiOUXgllH8mhfaHT3Vc2HKe2rpD4wHiyXTCZ4YEbXubKUZHVg0tBCcXCa4XcffWEnbW1dFb0xVrz/CnlINEtQtK4W8vmHU4Lht51118lEhQ5RkW0jsIRnTwhRTSSb+VHzXdeL1rktJ2OO+6NT91KtA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783873542; c=relaxed/simple;
	bh=lSI7LU0qtaVfyX0y2c0W/GGd2QIrg9b8ANiKqOVOIvA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Sv98vKWfSQHr2W/uQiebXPgb749H4JsW4EEZM5QDXMM4gSmv95IeJn/ao8M1hpJ/f9gh+w9wVJT+SNP3z4b/N5eJ7in1bckPYxBd+8H3N0XZaq6pX6Su1MNRHzoanplZ6A4SPzF5rQf++WzekIkq/4uYZIKSN3YuEFGAWznH3eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MTg+CTXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTg+CTXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6267F1F00A3D;
	Sun, 12 Jul 2026 16:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783873540;
	bh=2t1cjZCz1xB/ZbxPLJ1lprvc3Y2s5lq6CGehgs9Yino=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=MTg+CTXTqQTzpNDwAT+OxPpeNA3OQKKJCMZOqXSs3qYh3DSV1+EtIuy/IJdbP8J0s
	 L1aMC9dGEVufF1D0YsReO5WI3sJQpnnomBqWoZlYNgDsBAuLGb94xWqUYvzpqFg0P1
	 Sf0R5bvOOlRGgpOgT9f6ulT6eUNd3YuNHdenMeu22klbK1jZqXWWe8adk7wbVZLFY4
	 WmQYnYEBc4wA/qoiTmWFUfykS0APjJyI45YbBZIvsHcX8/o+TwoGblzVZmkpTAdZDP
	 hFZ2SJKIJsuNhxk7vv5kzuZkxsaVA3A30Cb6w1EuUtYIj38NbhQuMoiPIdC6xMIvGA
	 Zqm0R3RlROyqg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6ABB2F4024F;
	Sun, 12 Jul 2026 12:25:39 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Sun, 12 Jul 2026 12:25:39 -0400
X-ME-Sender: <xms:A8BTajbhWUWQWrgoZXVexWjGE0IwsH3RlGYkWHvb60IYLtEmQGG_PA>
    <xme:A8BTatM78pQy1JRVvy9T30DU2fa2Krtjjjtrikb99tQermzksLpihv76Sj9dRXmgK
    trkohlsWbLN_WunTIYp6iP3DBctoRRaE-JGo2cnP40cPpI20aSoNU4>
X-ME-Proxy-Cause: dmFkZTGvSqIA+4jdHxdlTDVZoO/boMoyii2hTbJCys+X9VKy3BUu1CiXuQLpAy7nwRQkLr
    0H373sSbeNwHGFgU51g089vp3uHwUavog1GSRNUpiWteQhezMzmsHbmqgMlWVI4bTmXPa/
    Eal+P1CyYPNc7bdQslRUUCNpwkhzRmVTqX4orKXwPkdMD0vxgiYct2tWLSumzh2hGiuUnS
    vXRRJ/ADxXEBV/dJYXLRsQ4Abs0rpkDKqmWFtch7jKdAO6Va4FzhSIbMnFncyGwTrGPK0P
    oLxff8UaznLPFmjuqLXR1B8hawxWOFJvVPnYyA6Q4gX+CZjmLTNJZnWiQBdlLs8ty55yt2
    N1V5KMqg+lhsk/De+enOaHJu4B5IZv5GL1J2ZOa0Xgxj5bWzJFiBZrRE2DQD1Gy7Daflr3
    Nx6YpFgH84xVvB9AF8HqF/kJR30yProhXi+SwCXTK88sl2Z5vMX0Tj4D/c9d/RZE7gIyWH
    IX9tc/LFYfE7u8bIfAhHg7QpsDpl+esnbd9eaYn4yfRsdFmMBDqJV9Epkjx++6XYfqUlP0
    860Hwa/zT+4iuwKethZICQ7VWC/8ZloSKlfz2v9d1Q5O37sA27yZH9vY/dcnt6qB+H3Wy8
    dl3eq6KaoVRaErJaxy0UHuyVPiQh2M+cGWZYqyYpY5l6NF/axclJg/7M9tOQ
X-ME-Proxy: <xmx:A8BTarYArrrY4g3WqGxMPsp4PHoHF2c4MRXbXXgKza9d5_7XV6el7w>
    <xmx:A8BTamubA_ochF8d8of6JlIoos55Rz18rdiAYd6t5XKy_7NdxhVQXg>
    <xmx:A8BTavnwxHtseGklGPgIZZvIDbHH1idHkJ4YGjjxzrgtpLDYzLxntA>
    <xmx:A8BTauwOKwDvUjAzS3lNn0hiJGRBRYE0q2yW8FzVP9XmgXRHO07mmA>
    <xmx:A8BTarz-Lu7_q7PlsxQo9nK9onJ2r1vlagXCRqMHW_iEEMRiv_ET_ssE>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 39FC31820086; Sun, 12 Jul 2026 12:25:39 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 12 Jul 2026 19:25:19 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Breno Leitao" <leitao@debian.org>, "Yeoreum Yun" <yeoreum.yun@arm.com>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Borislav Petkov" <bp@suse.de>, "Andy Lutomirski" <luto@kernel.org>,
 "Kees Cook" <kees@kernel.org>, "Tony Luck" <tony.luck@intel.com>,
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Message-Id: <af81fe18-d246-4bd7-b32e-c61ec2e7c856@app.fastmail.com>
In-Reply-To: <alD3ZFgfgMj0_qoT@gmail.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>
 <ak9GEtPuFv_1Sqcw@e129823.arm.com> <alDJNWZdBpkIZrcM@gmail.com>
 <alDMRabP9s6Pqhxq@e129823.arm.com> <alDTjHtL5Q4ormKb@gmail.com>
 <alDW8vjjU_f7dkIK@e129823.arm.com> <alD3ZFgfgMj0_qoT@gmail.com>
Subject: Re: [PATCH v3 5/7] efi/runtime-wrappers: bound the wait for EFI runtime
 service calls
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 10 Jul 2026, at 16:47, Breno Leitao wrote:
> On Fri, Jul 10, 2026 at 12:26:42PM +0100, Yeoreum Yun wrote:
>> > On Fri, Jul 10, 2026 at 11:41:09AM +0100, Yeoreum Yun wrote:
>> > > > Hello Yeoreum,
>> > > > 
>> > > > On Thu, Jul 09, 2026 at 07:56:18AM +0100, Yeoreum Yun wrote:
>> > > > > 
>> > > > > One of my concern is for the UpdateCapsule runtime service.
>> > > > > It might have a case where takes more then 2 mins and there's one
>> > > > > RFC to support a runtime capsule update for arm platform [1].
>> > > > 
>> > > > I'm not familiar with UpdateCapsule. Are you suggesting that a 2-minute
>> > > > wait for an EFI call should be acceptable (?!)
>> > > > 
>> > > > Wouldn't that trigger stalls and hung-task/wq warnings throughout the
>> > > > kernel?
>> > > 
>> > > Might for default config timeout for hung-task. However at least
>> > > its timeout configurable.
>> > > 
>> > > TBH, normally it wouldn't task more than 2 mins.
>> > > But for a in case of *slow firmware*, would be good to make
>> > > runtime-service timeout configurable at least?
>> > 
>> > OK, that is fair request.
>> > 
>> > I would suggest we do an additional patch with this change, if Ard is
>> > positive on the idea.
>> > 
>> > Yeoreum, would you like to do it, or should I do it?
>> 
>> It's up to you. I don't care who will do this :)
>> But if you have no bandwidth, I'll take once your patch is merged
>> and Ard agrees for this.
>
> Sounds good. Let's wait for Ard's feedback on the additional patches
> [1], and we can decide how to proceed from there.
>
> Link: https://lore.kernel.org/all/alDDv3XGXVdd1mri@gmail.com/ [1]

Please send patches against efi/next, I will apply them promptly. 

UpdateCapsule is a special case that we can deal with separately
