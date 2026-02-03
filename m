Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE133009DA
	for <linux-efi@vger.kernel.org>; Tue,  3 Feb 2026 11:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770117177; cv=none; b=VKCUwII3itTc1rQ7yrPlzPe+i9fVw0ERFqxKOw3QBd53K9sZIkuZ7rY96HlA1Ery+13eMLWLvTp5u3cfLqRVG08+N72I2kvQ/w4k2nLT6UbZxMaDFzBC121c2QgSN08lHX06rVMxXCzkXuXKQ4H8GJ/xVBm3lTt3K6loVZ0Uiy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770117177; c=relaxed/simple;
	bh=nTpe9wbQPfWCaTdsw1hxkwbQbogjCIFzERnAV3j9o7k=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=r6Tlku1plMGFTlBV8mS9n703cQftWEoqfxompQUUS5tZ+MTCJPbmSkxHQDUp6sIF2q1y5GBk/fn+YL0gOgwRRsk/vMsUdByCEV3Ue1NAVzrzHrCptBk+sFUir/tpJtNZDko677dt3Fj8jA9wU5du5XY0T3xR2IwWakXabREXwA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLH+M6Ck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLH+M6Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68096C19421;
	Tue,  3 Feb 2026 11:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770117177;
	bh=nTpe9wbQPfWCaTdsw1hxkwbQbogjCIFzERnAV3j9o7k=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=FLH+M6CkuRZGpe+DvYQjNSzmG5/pakcdziAPmzb3oiP+LdHxHqfLDglnOy8cmbo5H
	 gXerPFw3JjbQxymgdn317zKRzjccR/7NaWjaVhsRIYSIK3bkiVHyeYIlH0k27fkJZB
	 QgvvPLbVDI13H6jjunRQinbgXXWeMIJ7lrk3mq2xbRTB0bSDfJ6kbTgQgxPEUnaY/O
	 8KwohXX+TP5uEbAJZBn0Uk/IKjwDcHoCnMMcOpU8AfKTBa4szyeDAzVkdZ7heeWE+2
	 dx9JnyE9ufwNtZ+N1PndrTe6wYbxn+DQWTHUFBxZRH7gWgwD4bI71MEJkQMvvfT7JY
	 7zvGeHKvhUnwA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4CF55F40068;
	Tue,  3 Feb 2026 06:12:55 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 03 Feb 2026 06:12:55 -0500
X-ME-Sender: <xms:N9iBaSDnI1ySTcZQgSUxyZKlXtVGr_OXK3Ka2kDx9zuw_85xTyyefg>
    <xme:N9iBaXX8_imykBF7gkafTS4WlwDL0qlcuLlIJ7Y45Jy9_yypIAKmqif8mxJM_EXQx
    FzgObKUSkR236DV6TjOXtpmgs5od50YYDF9LKla-Nh3p2EMt9kXAnjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeelleeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeduledpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepshhimhhonhgrsehffhiflh
    hlrdgthhdprhgtphhtthhopegrihhrlhhivggusehgmhgrihhlrdgtohhmpdhrtghpthht
    oheprghthhgrrhhvrghtihifrghrihhlihhnuhiguggvvhesghhmrghilhdrtghomhdprh
    gtphhtthhopehfrhgrnhgtvghstghophhomhhpohdvsehgmhgrihhlrdgtohhmpdhrtghp
    thhtohepjhgrnhhirdhnihhkuhhlrgesihhnthgvlhdrtghomhdprhgtphhtthhopehroh
    gurhhighhordhvihhvihesihhnthgvlhdrtghomhdprhgtphhtthhopehmihhnghhosehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehjrghnihdrnhhikhhulhgrsehlihhnuhigrd
    hinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:N9iBaenzbIIMVQhcmCIzSe0N1WdjdYaWjASVhpxjAZywalDletKxKA>
    <xmx:N9iBaUMaxqdWnBmU6eLFsyWvKU5mV99m7mlWJfqA-Y7cPU_XJJvpig>
    <xmx:N9iBaYoZITaOjXg5cO3QTAwUqjhAcGlFBuwKzcyfNqwAa-hBIAmehA>
    <xmx:N9iBaVtyncDAUdi-kz1Xr2YJKVT_rbJtNzBieNym0FRheHh99Jh3Uw>
    <xmx:N9iBaU6UdddKTBw7Ijyblc5A2a0rtFg1Shz6-SxnQyWEaTq9Mp12fR_A>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1CE9E700065; Tue,  3 Feb 2026 06:12:55 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: APW7_PzxWZZ-
Date: Tue, 03 Feb 2026 12:12:21 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Atharva Tiwari" <atharvatiwarilinuxdev@gmail.com>
Cc: "Jani Nikula" <jani.nikula@intel.com>,
 "Jani Nikula" <jani.nikula@linux.intel.com>,
 "Rodrigo Vivi" <rodrigo.vivi@intel.com>,
 "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>,
 "Tvrtko Ursulin" <tursulin@ursulin.net>, "David Airlie" <airlied@gmail.com>,
 "Simona Vetter" <simona@ffwll.ch>, "Thomas Zimmermann" <tzimmermann@suse.de>,
 "Javier Martinez Canillas" <javierm@redhat.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, "Ingo Molnar" <mingo@kernel.org>,
 "Francesco Pompo" <francescopompo2@gmail.com>,
 "Lenny Szubowicz" <lszubowi@redhat.com>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Message-Id: <40497cd8-b8c7-42bd-a176-96f38b994dc4@app.fastmail.com>
In-Reply-To: <20260203073130.1111-3-atharvatiwarilinuxdev@gmail.com>
References: <20260203073130.1111-1-atharvatiwarilinuxdev@gmail.com>
 <20260203073130.1111-3-atharvatiwarilinuxdev@gmail.com>
Subject: Re: [PATCH v3 2/2] drm/i915/display: Disable display for iMac's
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 3 Feb 2026, at 08:31, Atharva Tiwari wrote:
> Disable display on iMacs, as they can't do link training
> on the internal display.
>
> (tested on iMac20,1)
>

How will you use the iMac if you disable the display?

If this is not in fact what you are doing, please explain in the commit log what exactly you are disabling and why.

