Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DA7494A10
	for <linux-efi@vger.kernel.org>; Mon, 28 Sep 2026 09:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790588655; cv=none; b=ArQ6ntkdtOwLqXOytyMJBgcSYcW4bOup5vw1EQU4J/yl0r0NS6Jyqg9VuKG1ysetaqcnMpRdSucpPPnpV4BMcgXSbfwggAd1z+2crvfdjIo3Dq/BsqlbPaaN2I6rnv1o/nHdB9hXNZqbuPxyWpzQKoVGTH2A1gVmXAIqnkKC4J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790588655; c=relaxed/simple;
	bh=yDiCbrD67teRI5Xt14TjK1TJBZ5nXKLfTDyJjKsZQ5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tDYeI7PJ0LgPpIAjwgrpRBsWjInl9gjTT9+7izyw2jRi01oi4dxQ9/WsMjSu6EDlQML2D6w5A1tW5SgVJfoOtKOeNCTd8j9Cjzb7+tC80/6keQSZa30TNGTQfUoYKOgTM2v31lPEPbu1lumQZlmKofQlJcA28VC2jZMhMwzMTEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VeiF1xoW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VeiF1xoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526B21F00893
	for <linux-efi@vger.kernel.org>; Mon, 28 Sep 2026 09:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790588654;
	bh=yDiCbrD67teRI5Xt14TjK1TJBZ5nXKLfTDyJjKsZQ5Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VeiF1xoW0YmgdSp1I+PFdq5zWcn2Ujzgm/HHuPX2OkBdIZ71wHDl0yS5v0qopB0is
	 0wpQoRiHucq+Qok3/3mDpOSUAH/wed3vJgOtyAsmz4drR4BItzkCpZtaM7JSzoFW1z
	 0kAY4wIIn4pGOyXOPlQ7kzxcbDkufGYJLhgZ5Xj8goc/i4EA59bDPI8nFk7/64SZdq
	 /uLImon+nTZFVOjyuS4FNzfSVNnRy+qTcgtv78+JBFwvsrp32fBL0PhQcVkYvvwgPt
	 e+pA+SB3icPjj7EbtenzdseAlVrbMMRzIGYOEr0Ia4p4brdBRwM8C0RSufc57KXboP
	 PMwR1IKDUrOWw==
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aae1f2cedfso3554298a12.3
        for <linux-efi@vger.kernel.org>; Mon, 28 Sep 2026 02:44:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByzFh6dId7nzaP2xRpHz1RDg5ujwKdjcAxqftWMXBgLQbWP2lus9YQ0VViKxyLN0Z+D5f/iBdQFsg0=@vger.kernel.org
X-Gm-Message-State: AFuF++nfTZoxN8G+56b8D8bCPV5TT6Q1BlKu7q4BRP1//+rhCLVJ/GPh
	phFuDvelKg6ucmBy6gTI22cyCN2W69/5UqRV5Q6rnPjpQJqtM04z74VJp5BiCUtxe39KE7XK7dC
	o451rm4N5H6asijnXt7Anm08OYURlLe4=
X-Received: by 2002:a17:907:7289:b0:c29:52dd:317c with SMTP id
 a640c23a62f3a-c2ac24c5d47mr1054543866b.30.1790588653269; Mon, 28 Sep 2026
 02:44:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com> <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
 <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com> <aqKrhNQ3mZMs5-Dy@thinkstation>
 <b24b9785-b790-476d-985d-e8c5405d192b@app.fastmail.com> <20260912061005.GDaqTsveevVkzxRJoI@fat_crate.local>
 <b259aff1-1fb1-4819-88ca-9b47dac036cd@app.fastmail.com> <20260912175410.GAaqWRwnz7bHUtXYSs@fat_crate.local>
 <862d50e1-2072-407b-882d-5e3074a3c225@app.fastmail.com> <20260913181105.GAaqbnOUDX2YNFW8iQ@fat_crate.local>
In-Reply-To: <20260913181105.GAaqbnOUDX2YNFW8iQ@fat_crate.local>
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 28 Sep 2026 11:44:01 +0200
X-Gmail-Original-Message-ID: <CAMZ6RqJCMt3zoDQ2iWXWJvxSifB0cV20FayX=yxoG30QdJ8aQA@mail.gmail.com>
X-Gm-Features: AclHuK8G_5R08tF6nQfMjGGwRFyMW3SHkXEugmF7cirr7NnVpvpLiskIoE_UXNI
Message-ID: <CAMZ6RqJCMt3zoDQ2iWXWJvxSifB0cV20FayX=yxoG30QdJ8aQA@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of panic()
To: Borislav Petkov <bp@alien8.de>
Cc: Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kirill@shutemov.name>, 
	Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Borislav,

On Sun. 13 Sept. 2026 at 20:11, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Sep 13, 2026 at 06:35:33PM +0200, Ard Biesheuvel wrote:
> > The reason I want to get rid of panic() is because snprintf() is going
> > to be removed from the EFI stub.
>
> Ok, I'll queue it into x86/boot and give you an immutable tag it doesn't look
> like something urgent to me.

I had a look at tip/x86/boot but could not find this patch yet, nor an
immutable tag containing it.

Just checking whether it is still queued on your side, thanks!


And, by the way:

Reviewed-by: Vincent Mailhol <mailhol@kernel.org>


Yours sincerely,
Vincent Mailhol
