Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7247E3271FD;
	Tue, 17 Feb 2026 10:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771325905; cv=none; b=DENS8FLPTJ1xGPMZfJf2gn6fX4oe2HZ0rpDHCvFjxSOkaWu/Znh+WfSHbk8grvRWOtgV4LJwSbmYgoJFRLELHQ52OOvH3xSLcM/HWaDRNYaiP85gvcdGw2TYHEfB3jw8pJeRf9VB2JogV2b/TSOqaGHQEQNVa2uWqZXJhehbrfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771325905; c=relaxed/simple;
	bh=ryxJBBu02okjtlGFLoujN0OXwkvCKzYbVblj4RXti9c=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=d0W6CrAwQfbmpS9GWL/TotnwaKhW5Fr2GirihX+g396I8ZRcQ7XjELeCh1zFCr8qcITydqfxBxDhwNOBO3RQbrX0cugfa+pibdKaur0d1YrenVrMFGnfUeszzcZ+xgAncw8CwXt5A5owkewA//w4t9QK/7T3b75uTRrADoMN7QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=McbP35il; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="McbP35il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEE3C4CEF7;
	Tue, 17 Feb 2026 10:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771325905;
	bh=ryxJBBu02okjtlGFLoujN0OXwkvCKzYbVblj4RXti9c=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=McbP35ilSo+pn6ro/ZqNpGKA3cA3yoFeWTpIYszQyGdBr58cUt9eVIjWk5WQLQwGq
	 PAMj39TKpLk6Ie1hojO/hNMZSEQJIvazyxMZmBeXRR96qSDDiW3wXvnEKs88X4TcdK
	 pu9+amh1Zu0HkJVrsVBxfujooMGZ0it/hFdelBOM7i1HDL7YcM6cq7iBOm10Mcao5q
	 3GzS/H3Zd0lRrIWjenrjq4yiDVAtldEWxsPsFAvoRTUpIExNeH027vCL+dGI+kIq4d
	 Tm9ozyfQl+dMKyQxyinfAtbwRxmo59eRz2/NTifaw/Ic4olEKxQuc/OzLZDrYRxT5H
	 aazG13EqmleBQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7B5BCF4006A;
	Tue, 17 Feb 2026 05:58:23 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 17 Feb 2026 05:58:23 -0500
X-ME-Sender: <xms:z0mUaTx8RQ093bum1HHtbue6fuBlrCWKODCeN5bPEyLPVmhDwwyHtQ>
    <xme:z0mUaWGhEn8O4WE0Z2PnRMvJJyfhNCdD6VVhQuyJRBQRyLb1imYvpqnebUkxhIlPs
    xNbNjFxbgb3H86EHUJzuFEZMWkNXctbAKEANNC5JHw0uRwtIE5Hd8c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudelheekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepthhhohhmrghsrdhlvghnug
    grtghkhiesrghmugdrtghomhdprhgtphhtthhopehmshesvggughgvlhgvshhsrdhshihs
    thgvmhhspdhrtghpthhtohepkhgrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprh
    hpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnhes
    lhhinhhugidrihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:z0mUaXuQoKtBWIPfbLc8JNg_ziG9IGFD3TnvomCiCbY_wBSPnZ_xWQ>
    <xmx:z0mUae2E-oLPhhy3l-GkLawjqRJIFreZOjovOz6xAW-QQAVU3WCq6g>
    <xmx:z0mUaXCog2WQPeEL6xcsnVd9C3kvvY6Ghggh0Jwo9Fc0X-W25Nu_6Q>
    <xmx:z0mUaUD3EE-U2diFt7CEbtMGqP1D1vv52vgE-sneYLZn_B5LhdXEvQ>
    <xmx:z0mUaQnRRvCWaFUp19H8OzJHnVJMhXIW6TOfmqkW0BfZ9ZutmK0cM1br>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5C4B5700065; Tue, 17 Feb 2026 05:58:23 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AvPcN72_GPoV
Date: Tue, 17 Feb 2026 11:58:03 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Tom Lendacky" <thomas.lendacky@amd.com>
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Moritz Sanft" <ms@edgeless.systems>,
 "Mike Rapoport" <rppt@kernel.org>
Message-Id: <42bdc4c5-9d9f-49e4-8bee-75633c987500@app.fastmail.com>
In-Reply-To: <20260217104957.249340-1-kas@kernel.org>
References: <20260217104957.249340-1-kas@kernel.org>
Subject: Re: [PATCHv2 0/2] efi: Fix alignenment issues in unaccepted memory code
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 17 Feb 2026, at 11:49, Kiryl Shutsemau (Meta) wrote:
> This series addresses two issues related to unaligned physical addresses
> and sizes when handling EFI unaccepted memory. These issues were
> identified as potential sources of kernel panics in Intel TDX
> environments due to incomplete memory reservation or missing "guard page"
> extensions.
>
> The first patch fixes the reservation of the unaccepted memory table
> itself in efi_config_parse_tables(). It ensures the entire page range
> covering the table is reserved even if the table doesn't start on a
> page boundary.
>
> The second patch ensures that memory acceptance requests in
> accept_memory() and range_contains_unaccepted_memory() are page-aligned
> before performing the unit_size alignment check. This prevents skipping
> the necessary "guard page" extension for unaligned ranges, which is
> required to avoid crashes with load_unaligned_zeropad().
>
> v2:
>  - Fix 'end' calculation in the second patch (Tom)
>
> Kiryl Shutsemau (Meta) (2):
>   efi: Fix reservation of unaccepted memory table
>   efi: Align unaccepted memory range to page boundary
>
>  drivers/firmware/efi/efi.c               |  8 ++++----
>  drivers/firmware/efi/unaccepted_memory.c | 10 ++++++++--
>  2 files changed, 12 insertions(+), 6 deletions(-)
>

This looks fine to me. If other folks are happy too, I'll queue it up and get it to Linus by the end of the week.
