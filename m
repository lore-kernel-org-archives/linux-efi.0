Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DE3188713
	for <linux-efi@vger.kernel.org>; Wed,  1 Apr 2026 14:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775053909; cv=none; b=JeaZ1DF6Aqb/JEMRoPdRwgu8aHppLAqaqW3LpsBlHwusdwpBFUdYOfWkBkekp7u1XylYw4ZsBK96h9v3m4EvLPxrecBASBMbPrTdw3T24sGeqDkFPhb2GemOQKgZPx5VEj/utMYmLfhOlpcNwQ68q4wwCwX5mqdcXreDft6MZCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775053909; c=relaxed/simple;
	bh=0PDjTbqpJYMUU/5bt30Gc+OY76/IAV/10T65mSIjE7k=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OAcE0WcJrWyhlNgcXBSmTooGFSyTz8gHgs0agG/1P8T4lJrnxP2rB05BOuJhpRZS3j94IOGIo0uLhC6fe/q/1c/EEvRfc2tWRkTxA2wuYBW2FNYHmaDxPxZ/cMywT8vCmamP60kVleJRVGLUBUZKT8dzOUzfCtkMtTIuGMXFz38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8USsARG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8USsARG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CBCC19421
	for <linux-efi@vger.kernel.org>; Wed,  1 Apr 2026 14:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775053909;
	bh=0PDjTbqpJYMUU/5bt30Gc+OY76/IAV/10T65mSIjE7k=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=B8USsARG8vc1UanLp2FOzPt+S0LoxUA8/duJpImhH4nQrjQAbXNhrJCL8W7RbIvhR
	 bAcXQdXROObuZUgZLolG5Hti5JzmsL3rPGj1bJvKhmMolkiQUsc0EiffLyYYfcrCiR
	 9WtQ3yBd4UbeRu1tJdaTwLxVWVQ5XKwYiWkhDIFKn6bEB3Gbu4qjvNY7Z8Lww5VYm7
	 9UNdpHUTCqBR2hYjbo8wPbvZ8tJIXnMvjDq2bmuwOHO3cscWa7wRhPHMhigU06+G0w
	 zkCfLp+bE5Asm2hSZOCm5RcOE2+7qMwoUHtALbZ9rWw5d+nux2+NXzWq8QuucFSjH5
	 HTsGI8zgsEdeQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1A2ABF4006E;
	Wed,  1 Apr 2026 10:31:48 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 01 Apr 2026 10:31:48 -0400
X-ME-Sender: <xms:VCzNafYT0AOlSGrrsxj_WpY26AtxiRHKOmkI0SjVb3W_EeaAnqcJ6A>
    <xme:VCzNaZNX3icAAtC8eS1Y8GiRtTYJ0HatUkMkcBzTBgTPcYrrSBWoFyRimIfSZRkIS
    gKp5fYp7lIR44jwNpMZvaWzK-ObDYl8yr9Qaq4IMaNyokoX4VYYeYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeffeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcuuehi
    vghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeeijeef
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    guodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqdef
    fedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurd
    gtohhmpdhnsggprhgtphhtthhopeekpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehlvghithgrohesuggvsghirghnrdhorhhgpdhrtghpthhtohepuhhsrghmrggrrhhifh
    eigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepghhouhhrrhihsehgohhurhhrhidr
    nhgvthdprhgtphhtthhopehjihhrihhslhgrsgihsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopeguhihouhhnghesrhgv
    ughhrghtrdgtohhmpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghr
    nhgvlhdrohhrgh
X-ME-Proxy: <xmx:VCzNaZaMEBAH3rNmsEA2CQ2UIo41w_Z-fNj694-w7r366WBwJ1RTOg>
    <xmx:VCzNacadWkRubZ_YR7mx-BnZ-a9JLSX2FtoOHKk-GHAbPK-eDOx9DA>
    <xmx:VCzNaeJhoC0mwtEmrd7xrfL8X0sVwOpG6RrsrXsJgB4DEfurk_KbFw>
    <xmx:VCzNaYuZRvCtnksXcsPajKJvdRfWgdc52M56V3Omt2MDy183HD8P5A>
    <xmx:VCzNaSUXRFkz3tMpIYes3zlTBeUkEhAK_PywnuzBCoGnVpJhuzhOP2K2>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id F00E8700065; Wed,  1 Apr 2026 10:31:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AzaxcsQTxqiw
Date: Wed, 01 Apr 2026 16:31:27 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Breno Leitao" <leitao@debian.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 "Dave Young" <dyoung@redhat.com>, "Gregory Price" <gourry@gourry.net>,
 "Usama Arif" <usamaarif642@gmail.com>, "Jiri Slaby" <jirislaby@kernel.org>
Message-Id: <eb368b0d-4acc-4dc6-a86b-7a1a81762960@app.fastmail.com>
In-Reply-To: <ac0SynMEZTkodole@gmail.com>
References: <20260401122351.2058145-7-ardb+git@google.com>
 <20260401122351.2058145-8-ardb+git@google.com> <ac0SynMEZTkodole@gmail.com>
Subject: Re: [PATCH v2 1/5] efi/memattr: Fix thinko in table size sanity check
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 1 Apr 2026, at 14:45, Breno Leitao wrote:
> On Wed, Apr 01, 2026 at 02:23:53PM +0200, Ard Biesheuvel wrote:
>> +	if (tbl->desc_size < sizeof(efi_memory_desc_t) ||
>> +	    tbl->desc_size > efi.memmap.desc_size) {
>> +		pr_warn("Unexpected EFI Memory Attributes descriptor size %d (expected: %ld)\n",
>> +			tbl->desc_size, efi.memmap.desc_size);
>
> Should tbl->desc_size be printed as %u and %lu?  tbl->desc_size is u32
> and.  The pr_warn a few lines below already uses %u for the same field:
>

Yes, good point - will fix.
