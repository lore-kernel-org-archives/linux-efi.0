Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E7248A8BB
	for <linux-efi@vger.kernel.org>; Wed, 19 Aug 2026 16:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787157426; cv=none; b=cmy0AroJZCxgDBUAO8jxmcNXsk1C/Bz4NWo1M97d2BzNn6+frffr9mlEJr9RC91Yg95uTiQp3cfF+NzQJpMXOmj+EgqWatichyyLKgiwTcl7DYlAWtQFrb35DQ8wDrHeOJaVtHT08EVsBPcAySubkJ4N7H66jLg6rOowbOu4bOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787157426; c=relaxed/simple;
	bh=pr/mOrKNrihbvxZpK9+jrONIYord+BLta6/NkM4PkzQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=IEC2xxYvmCfh8yO3SAq3qrezS3upYVJDPmplNpEAasBLLchRccFNDR3O21Nmg9j1iU9BmF2Nv5gPOS54fSmftmuHaNkYBep4WL3MAewRV5U3awg0RGtmLXEakqBmYqqhfWIodQ+EGMZcltOOul4M06Aon9BipiDhCy3Dl5EhXEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZNNO9kn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZNNO9kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023161F000E9
	for <linux-efi@vger.kernel.org>; Wed, 19 Aug 2026 16:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787157425;
	bh=QsHEuqcdf3ru8nPwtUEXSBpm0W4HyNiSw2503P8ARO0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=gZNNO9knt/IoPYcaBewn5z/dBrZWDxjSpCRAH0E/jnKKf5zwgPzZQp6jkGtMrsgP9
	 sGdfG2zfHaizAMfGO+760bkER1ybyTXWDXqoICkyoPev7mnmmlaILeEUyyyYBwbd/V
	 0CbAYGwHtGnM5m++Pg0q6+HP+eRo0gidxBQEPOU4NpVF/P3fZWirTefPKCvg+/xa6I
	 q1GWF3Q2nCQhjFKBIviBcxRYTDePGjC1HMKk+20oobf27L77JJJ4nF6o+j1EoAT7dM
	 hnShgcTnZSg0ejmd80JOL+99252chZfwQje6ffKnvQg9kJc2/4Kmct/lD4XSVm866q
	 V6HZh+Y6wOmzQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7BC3B1980045;
	Wed, 19 Aug 2026 12:37:03 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 19 Aug 2026 12:37:03 -0400
X-ME-Sender: <xms:rduFaiU8F0gYhF-BU0aQxYSkZxjxqXbvQOHpStDZLnfb40ycOR2YWg>
    <xme:rduFapatmPUyspDRf3f6ubDj39g4XRNZTt5DjONIUhORcJvtg7AXwnDym_4HOySN2
    BVBchoW4ufjKVK_xF6ywGS2oXnQ7dk8ymA0Gxa7tSmFleEWuXA0R-I>
X-ME-Proxy-Cause: dmFkZTEzE8aUVDxTong4hnJ8VtE8fbJv1fo/B8hPJ4CFDN4gIvKOB1NJX9QKNYv9Rbu5RZ
    eL2U24IvdfMCHAmV9/P0i6/hAjxED07ZY2b8lyCwTfAHrNcCy4lQy1xFOIXubynYm7EeDx
    2nlK6MaafCQhEsDxZoHeHJYhYjUyWhBTndcE8ZdUGhniMga51nvraSBabg6TmhwBvQlvZj
    PMmfBtSfUbWyjK/G1HcIUdXqmrGaCfgBDYC+0Wk3DU73t83bPlwwXEAYrbxliS/IVx/zoO
    qCttFHVkH+YMxXACmwWtdSFTrpTOrx0yTqf1qTBP1NOl34AiX3WDRp5/QOwBSj6K+dkSad
    i+at6FvHlacWjaFTa4YCzIAcumiI7ggi21l9zGrrNqT0ZyxzIgd46aDv22Z/9jyyX0EGH6
    ru4EYG6SiErKJNyRQn0stwtAVk3ch4MvCmBrcmryhwRX/uFMwNRGrNVSf38vyEntgo4Qe2
    XVRKh3QrY5eiLsONrqMfXQYJj6djEk5tquuZEvB5vfJI5XAOrtTANIYnpg35Ic0fQ4zhHu
    zYg2jG+0xUQ05wv1PRtFACcv4OA1cQyleeYn5Ebt3p1GR53f8tOgl6F0upMQdpyRouHZDy
    +pUeBVSF28qiPD8A0rvk8Yx2D07xHmkgZjXMuBQsYwhTX++giHcyeWeFVMnw
X-ME-Proxy: <xmx:r9uFamj527aITrtzXMZGw2fHBz95aXNq8VZnSxFu-uhe1OS-e2pmjA>
    <xmx:r9uFav_6mJ0VQdVOTrjbTpCurx1KIqFvmqOIHZLxX1AHYvk3pI7KSA>
    <xmx:r9uFappA8WYY0i_pGU7QrkINlFR4ojZClXAHjiJbwGm7upnKGniA2g>
    <xmx:r9uFavUeLKbnOscmORzSAi9Z3r3qIvhs7ELMIqEkPDvKPzbANzqd9w>
    <xmx:r9uFagCnOK1Ee_P0vwXj-8p2CYAoy8Gmlfz3dhP5jFDsNNWPfbyu99t->
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 965E0F80071; Wed, 19 Aug 2026 12:37:01 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 19 Aug 2026 19:36:40 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Anisse Astier" <anisse@astier.eu>
Cc: linux-efi@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org,
 "Ravi Bangoria" <ravi.bangoria@amd.com>
Message-Id: <e4153579-37a2-424b-b96b-eb0f1d8085be@app.fastmail.com>
In-Reply-To: <aoXZ7xBT546YKdOY@kanto>
References: <20260818141150.905336-1-ardb@kernel.org> <aoXZ7xBT546YKdOY@kanto>
Subject: Re: [PATCH] efivarfs: Rate limit statfs() handler
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 19 Aug 2026, at 19:29, Anisse Astier wrote:
> Hi Ard,
>
> I like the new approach, it's much simpler and easier to understand
>
> On Tue, Aug 18, 2026 at 04:11:50PM +0200, Ard Biesheuvel wrote:
>> Ravi reports that statfs() may be called by unprivileged users on the
>> efivarfs mount point, which may result in a flood of calls to the
>> QueryVariableInfo() runtime service. These calls are disproportionately
>> costly on x86 systems where the variable store is backed by SMM, as each
>> SMM entry requires a rendez-vous of all the CPUs.
>> 
>> So rate limit the calls to QueryVariableInfo() at twice per second, and
>
> It's already a high-rate in performance sensitive environment. I'd have
> gone higher at once per 10 seconds for example. But really, this is
> minor, so please consider this:
>
> Reviewed-by: <anisse@astier.eu>
>

Thanks!
