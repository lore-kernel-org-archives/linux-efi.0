Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0512D3739
	for <linux-efi@vger.kernel.org>; Fri, 20 Mar 2026 14:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774017139; cv=none; b=SAgZZQY9qPwYVEhmCrjBbuhTZL/QMDx3GIhDAGmMDF0FT9xak7UvkHhMxwvArPmpwpFmE1e9tXzrLVt47koawRXmOBdkq/zs+8ZAKHk/CrJBbYjvlW9CxC110Y0vQw3PDAGcWmQbkj1dZlqKDiym2QBsuHrX28B3I5ER0knfBHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774017139; c=relaxed/simple;
	bh=pjKkpuJTqDNqdFPFCHnUMaKFMriTElNabT9wDx4wYTs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=pNnyDC1Tj2IUMVEBikHDCaJN053TIoBuUgYAdmNdGgdsRMbZFEpQQM57ifkQXB5/qkn6L2Ckt8iAIYo9e9J3cl4ZcQIEWG6xvaBJcd2eibuk6qoLn3fNMj6vosk5jlzf90RsCYhvU0VQ0YaO8yjeFSBTYJdXu5w4toOoTZhdLJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GahkMbt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GahkMbt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16174C4AF0C;
	Fri, 20 Mar 2026 14:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774017138;
	bh=pjKkpuJTqDNqdFPFCHnUMaKFMriTElNabT9wDx4wYTs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=GahkMbt5FMp1DK7FfXCrm5bAaoZtxPrfYmHySQhIY9KJCEz3JCd5OECUufWQKdPtv
	 erDtuuFcq2n32eNi3Vmo+kYuY3w8s4GxPvVkx1I/UumFlHE+VgmUsXF6bnyAjmYaJP
	 EcCJI/6z5OP97TH9B0IH7Bqmh8DaS/3Z9WtgsxiPOxl0tD7gSWT9ptntG02c5udKhM
	 Lbb/z3+rpLkrGGQqDKvVFYK7OzZ9fFPHmS5Hj2ndj0jNJexgmXW/1pVsQ9b28sUFbn
	 QWtsU8nvtuuWRMYSdpN9TxGTVNFLBbAoOtE2di1u2Po+YYlaZ8Bn/mtk/cvlhCuwzX
	 ahFpRME4Z65jA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id BFF9EF40078;
	Fri, 20 Mar 2026 10:32:16 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 20 Mar 2026 10:32:16 -0400
X-ME-Sender: <xms:cFq9aXjjJKnYZZQrqxZPP12ETP_RoqAv91P4D2bKoG-uRB-CJFoY-w>
    <xme:cFq9ae19QcecVROab9pSrLE3vn6CIv51RCwzS8rV1oVhdlnc2gxCEh-kMM3mvi7IW
    R2MSB6ZBEGxCqn31Gb6LfdZEuUCGDyACdAlspL4BkQPxo3fFT2I296v>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefuddtudeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeetvdejhfdvheelieegieevtdelgfdtgfevfffgvdetveekveelgeejhffg
    feeivdenucffohhmrghinhepmhgvmhhmrghprdhnrhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhguodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieejtdehtddtjeelqdeffedvudeigeduhedqrghruggspeepkh
    gvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurdgtohhmpdhnsggprhgtphhtthhopedu
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpd
    hrtghpthhtohepsggvnhhhsehkvghrnhgvlhdrtghrrghshhhinhhgrdhorhhgpdhrtghp
    thhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepihhlihgrshdrrg
    hprghlohguihhmrghssehlihhnrghrohdrohhrghdprhgtphhtthhopegurghvvgdrhhgr
    nhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtohepmhhinhhgohesrh
    gvughhrghtrdgtohhm
X-ME-Proxy: <xmx:cFq9aTfSA2oBX6GJaAA5qyyvG0mgaUgov9jMikJ7n1tm-SWyZjqk2A>
    <xmx:cFq9aYoPmSpOJiRimPO6JUcxW6rckwvIwWYhoAzAtm7W8PXWWWLLJg>
    <xmx:cFq9admehDp1NgrNHW2LI5b2sDZUR2Y10AvFO8_XXCKqw6zHor1KsA>
    <xmx:cFq9aZQL5eJ9e16N8XH79b3tAZeRW6_mz_AETcgwzlCfUJsN_c2M3g>
    <xmx:cFq9aTZWQMkWdqa4eN_oNNl3xHNXDOPWG8jIAIXQYNKrpha2ruCMU1m->
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9080070006A; Fri, 20 Mar 2026 10:32:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AusYBuezkfp3
Date: Fri, 20 Mar 2026 15:31:56 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>, "Guenter Roeck" <linux@roeck-us.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Ingo Molnar" <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 "Thomas Gleixner" <tglx@kernel.org>, linux-efi@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Message-Id: <f9d55606-178c-4dc3-9f3c-94185ae4cbd2@app.fastmail.com>
In-Reply-To: <ab1U59ye2eBOz6x3@kernel.org>
References: <20260225065555.2471844-1-rppt@kernel.org>
 <100b9ae1-74cc-48b3-ba63-1a72cfa2ebbd@roeck-us.net>
 <ab1U59ye2eBOz6x3@kernel.org>
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 20 Mar 2026, at 15:08, Mike Rapoport wrote:
> On Thu, Mar 19, 2026 at 09:06:52PM -0700, Guenter Roeck wrote:
>> Hi,
>> 
>> > +void __init efi_unmap_boot_services(void)
>> >  {
>> >  	struct efi_memory_map_data data = { 0 };
>> >  	efi_memory_desc_t *md;
>> >  	int num_entries = 0;
>> > +	int idx = 0;
>> > +	size_t sz;
>> >  	void *new, *new_md;
>> >  
>> >  	/* Keep all regions for /sys/kernel/debug/efi */
>> >  	if (efi_enabled(EFI_DBG))
>> >  		return;
>> >  
>> > +	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
>> 
>> Was this possibly supposed to be
>> 	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
>> 				       ^		     ^
>> ?
>
> Yes, thanks for catching this.
> 
> @Ard, can you please pick the fix:
>

Yep, queued up now.

Thanks for the fix.

> From 8fc5c5e828e7d127e6210bc9952451300591cdce Mon Sep 17 00:00:00 2001
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Date: Fri, 20 Mar 2026 15:59:48 +0200
> Subject: [PATCH] x86/efi: efi_unmap_boot_services: fix calculation of
>  ranges_to_free size
>
> ranges_to_free array should have enough room to store the entire EFI
> memmap plus an extra element for NULL entry.
> The calculation of this array size wrongly adds 1 to the overall size
> instead of adding 1 to the number of elements.
>
> Add parentheses to properly size the array.
>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Fixes: a4b0bf6a40f3 ("x86/efi: defer freeing of boot services memory")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/x86/platform/efi/quirks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 35caa5746115..79f0818131e8 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -424,7 +424,7 @@ void __init efi_unmap_boot_services(void)
>  	if (efi_enabled(EFI_DBG))
>  		return;
> 
> -	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
> +	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
>  	ranges_to_free = kzalloc(sz, GFP_KERNEL);
>  	if (!ranges_to_free) {
>  		pr_err("Failed to allocate storage for freeable EFI regions\n");

