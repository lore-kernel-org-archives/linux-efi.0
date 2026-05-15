Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4363DA5C1
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 17:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778866165; cv=none; b=rQGsVE2oGKgJQJAmGBJH2LMAb0mTy00iO0xN2wqwWuLzxsQh1SkKUN9OWHArM1wq5uKeQbLV7Z/TBJkVVp/vX/hrJo0nK7UBpH1j7mtM3nTlcmjlEIIT4Low+J23AN78VctkCITFCkZoPy9nGC3eG0mdd8x9aJoxFVsq3svDzFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778866165; c=relaxed/simple;
	bh=lKC5h4eMZE8zS4EswFs2r1WoAMZiz5c0odheNCP9aWY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=D2Y4vSCb4cgBVCMYvvsfQLesr40vQa23LGaRYMk/Titx21jhvxR0IwRxSxWfAjOL1Cwana51adU84vXrAQJq0XiMblKMRKhohzho93YjVUIUl8Gz6GM2yu4PcWD+vSyqAZunt6Bt92NfoXfpzl6FHAITRyLmnpdKSwj1tnSOPKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6IS9k7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6IS9k7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A74EC2BCB3;
	Fri, 15 May 2026 17:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778866164;
	bh=lKC5h4eMZE8zS4EswFs2r1WoAMZiz5c0odheNCP9aWY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=j6IS9k7bDCuFyIxVhxgNMHDp+M/FXcWoDBOQQz1x9G/i/aW1fp+Jj/F0R7Eh5hI+b
	 4s9ETJqzTp2sUe37mo4q8y/+AuQ+nyyp5uLUd5T8r4eDgtrgfO3uq0wgO2TLzH/B0e
	 Qn6Iwh56roFVRvMIiiuUhEoxruNW0QCL3R/cJpFX9ALFmbCuQGivHisiyoetlMUv9i
	 px0tXMr7Q1Mbr5c1Xv+E70ziQX6pE+dH8amEMcTGS+eOVKM4Q8Fqf3INFKf4a0m3x9
	 eUPdJHfoRhTge6mx1eluXl+4SC41rAsreBIn07Ml3mUdxBsfKHb4Scynr6piTnnMOh
	 uCSL6aRHwzNuA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id A9965F40084;
	Fri, 15 May 2026 13:29:23 -0400 (EDT)
Received: from phl-imap-14 ([10.202.2.87])
  by phl-compute-01.internal (MEProxy); Fri, 15 May 2026 13:29:23 -0400
X-ME-Sender: <xms:81cHauLRxHJyNMJCqQPqSErhRbZ28F_TNEWProNrLjKSUGyU0k1jXw>
    <xme:81cHag89RQZo2sg-LlgUYo6mmE_MxBOKYgJFFpEV_g_WJxPJpLE5XphpV4xqiRlF2
    JWXLDrV916WzaTi9J8ZWphNWS7F6sCBDAJwiuqQhQrY7noNBl4vAq4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddufedutddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehrrghfrggvlheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhlihgrshdrrg
    hprghlohguihhmrghssehlihhnrghrohdrohhrghdprhgtphhtthhopehlihhnuhigqdgr
    tghpihesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgvfh
    hisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhn
    vghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:81cHau--QIqNDE1kNGGWlmqtJPQBaqWaiQIwGfsukJiRjJIwg1x-EA>
    <xmx:81cHaiZH4UatCS7VXbkjUloo5Ot7Cmwb02k_jsrJKVEU3i5oFumZZw>
    <xmx:81cHat3JomfCr645dh1QYzEaBYGzB1srrVctE77bSXojAi5o6SLfdQ>
    <xmx:81cHatbwVQPH6iwHnpttgURDusllT6XBA-79FPEkOSL3s8-hzrJNPg>
    <xmx:81cHalKetaH2io7Qz13G4TZYdqyZotvfDPOhjgwJEWzn1S7kcVXCTbKk>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 8B0B3C4006E; Fri, 15 May 2026 13:29:23 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 15 May 2026 19:29:03 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Rafael J . Wysocki" <rafael@kernel.org>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-efi@vger.kernel.org, "Linux ACPI" <linux-acpi@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Message-Id: <0572b4b0-d67c-46de-aecb-d11a4336c202@app.fastmail.com>
In-Reply-To: <2415513.ElGaqSPkdT@rafael.j.wysocki>
References: <2415513.ElGaqSPkdT@rafael.j.wysocki>
Subject: Re: [PATCH v1] efi/runtime-wrappers: Avoid crashing on early PRM code
 invocations
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Rafael,

On Fri, 15 May 2026, at 19:10, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>
> There is a dependency between EFI and ACPI PRM that the latter cannot
> run until the former is ready and PRM can be invoked from AML early
> through acpi_platformrt_space_handler().  If that happens before
> initializing efi_rts_wq, it leads to a NULL pointer dereference.
>
> Avoid that by adding an efi_rts_wq check against NULL to
> efi_call_acpi_prm_handler().
>
> Fixes: 5894cf571e14 ("acpi/prmt: Use EFI runtime sandbox to invoke PRM 
> handlers")
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: 6.6+ <stable@vger.kernel.org> # 6.6+
> ---
>
> An alternative would be to somehow ensure that efisubsys_init() will always
> run before acpi_init(), but moving any of them to another initcall level is
> not an option AFAICS.
>

Given that they both run as subsys_initcall() currently, changing acpi_init()
to subsys_initcall_sync() is probably fine (famous last words :-))

But if the PRM code can deal with EFI_NOT_READY than this is also fine,
modulo the comment below.


> ---
>  drivers/firmware/efi/runtime-wrappers.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -590,6 +590,8 @@ efi_call_acpi_prm_handler(efi_status_t (
> 
>  	if (down_interruptible(&efi_runtime_lock))
>  		return EFI_ABORTED;
> +	if (!efi_rts_wq)
> +		return EFI_NOT_READY;

This should occur before taking the semaphore

>  	status = efi_queue_work(ACPI_PRM_HANDLER, handler_addr,
>  				param_buffer_addr, context);
>  	up(&efi_runtime_lock);
