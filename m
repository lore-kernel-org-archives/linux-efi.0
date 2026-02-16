Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E6628FFE7
	for <linux-efi@vger.kernel.org>; Mon, 16 Feb 2026 14:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771251772; cv=none; b=Monbvi6sP/B3+4wK35S2tD7fwalHvybDoO6BCCtugmT4dTC+Oxaq5/6DP2DT8fyBeoPODNkxP7shxNiz09og0/YkqY67bDvslL25hzCEs6jAiAJKzBvWlR45vgBKkMCsU/9C+nRrwvLIeeouFUmrYsL+EtYeeWqt1BLwZpu4LOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771251772; c=relaxed/simple;
	bh=zU3ubHaPiCQva4ddg0RMo350B79XWEl6ga718019SJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/3gCnx14ymObMyK8BOAALqS265Di3cZMqJaDzYhsJvjchZMg7ibR16qbwMpKpZwGI1H6+HLzuJ0WQ/CYCegFTkHzYsFbv/6dhi9CABRucec2CphAvrf10L/Bd3zR18p+hN04bwPLhPdcO+OoHYEehiro0un6Cs29Waatnq+bf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mz+gX6cu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mz+gX6cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEA2C19423;
	Mon, 16 Feb 2026 14:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771251772;
	bh=zU3ubHaPiCQva4ddg0RMo350B79XWEl6ga718019SJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mz+gX6cu5dvxn4gEY+wL9F1YGHucH/BuL7hxFg9Mcc4yOJj4NuvOMpf+uqsXH3eJv
	 FMpc9oa/eJKGVRcgfmt3M2qEf4fI6+IF0HnusXIFaiKZqdhGEzTAuWkAwjWkgSbBxt
	 KdSSTOZLPsHDBckgsrACyF/nTiYr5OfE6y6/znt1nPklxgvtNG+z1SxoYgYSbn2aWS
	 gPJoclwvzWb4vt7FqHoV7uxDdaDS+6jp4TcURjJNDSclVVNjYCyqqq+GaYKEL+rqC3
	 0ncL6TRjZAlDsCa1TXg6vqSemz0O+CfXdq3mJeA3JLkbYVHBVj5dVg8b0i8VtC7roK
	 4VvY+0fdizyYw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id A81C7F4006C;
	Mon, 16 Feb 2026 09:22:50 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 16 Feb 2026 09:22:50 -0500
X-ME-Sender: <xms:OiiTaT4sH9z-kHOTu-4r3OeubnWBwAliot_dyQ_TfoeNCD2CoGVzQA>
    <xme:OiiTaWXQB5vwP_8MqQKZPKRrC4Or4_XT-lzL7gFeUkVA5e-tATwTaVXmfr44ZnnP4
    M0gG5Fg403amXhesZku8942ZST5aAuprbMSwEe2O3oaYNf9m6-f0gU>
X-ME-Received: <xmr:OiiTaaY0-9iAhgSMNvs4uiDp4a81jexcw0wmuJVITcxd0fbMHjcoa9leZods_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudejuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuggrvhgvrdhhrghnsh
    gvnhesihhnthgvlhdrtghomhdprhgtphhtthhopegrrhgusgeskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepthhglhigsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmihhngh
    hosehrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprhgt
    phhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtg
    hpthhtohepthhhohhmrghsrdhlvghnuggrtghkhiesrghmugdrtghomhdprhgtphhtthho
    peigkeeisehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:OiiTaVwnj_tFU21J4poJtyAPFkgtxpyk0TAkTnPFedmzN8p2oLNpMw>
    <xmx:OiiTaXLC5PTv08-dpGr3j8eHnm1M7wO9nE9IsyNP8-3T8laIpbHeFA>
    <xmx:OiiTaUdoj9oH9YFQw71IRuDPWjGJw_1AvkE9dlYcPdmDyvst5Q0NCg>
    <xmx:OiiTaXuZBORuXeCUG8D-n_NqK-6xJQWjR-IuvI1LVeV7LyNA9HdPbQ>
    <xmx:OiiTaaE6TaMod6CiXIVmI-sVqwUeH5ZVSjA6iLJZnY16_pqbsl7T56Uk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Feb 2026 09:22:50 -0500 (EST)
Date: Mon, 16 Feb 2026 14:22:49 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
Message-ID: <aZMn5_uLLH61Fr6o@thinkstation>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-2-kas@kernel.org>
 <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
 <aY9Mf8oZODGiDoXp@thinkstation>
 <6d6dd421-774c-4f29-84d5-3e449240eb93@intel.com>
 <aY9c80nXefdXjGXh@thinkstation>
 <aZCaE04vDpf2hDEc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZCaE04vDpf2hDEc@kernel.org>

On Sat, Feb 14, 2026 at 05:51:47PM +0200, Mike Rapoport wrote:
> > My guess that multiple memblock_add() calls might add up to the full
> > page size.
> 
> I'm not following here. Can you explain what do you mean?
> 
> Multiple memblock_add() calls to adjacent ranges will coalesce into one
> larger range. But I don't see how is that related.

I tried to find justification for the byte-level tracking by memblock.
Not in relation to this case, but in general.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
