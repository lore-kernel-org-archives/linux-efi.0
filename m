Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7313438AC93;
	Fri, 12 Jun 2026 10:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781260148; cv=none; b=Xb8RQJihwSv2ZkhCgbnmfkg3MW6hMUU+SzZnmYxZSy8dlErnU+7HJtAuBPF/3S0Zn0rZN9YRPoXEqMsciphWozWHhXbl647yEurYJHv4XZT/7ZRheyv6uHJNgVn5Qp4e6SKUKiNd/c/I580wXJCEAK+Zx357O3Ma9dqfnt7kbIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781260148; c=relaxed/simple;
	bh=PIY4ZhjnsmFdYlEn2lTL4uh5JAvh+GImnwY3nw6MX7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLlHg7IVtIQU9KZGl4M2GDwlQlsZB35+byEvztJHqZNK6z1xeV39pBDayKQwxXtFR6NKslxSxz2iewYU0QNeOmSDi4wDU7K0JegaKsSltI9/YU4ngoti/siiMKMlyP4Kz8LwjpJlkChe/MlohVIM318qIt7l+QkqpvcXhkd0a98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=l6CyCzKM; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="l6CyCzKM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Gk3+S7d4diVmy1DiiOBP8AO6ZoJWBq4kX3LohqcAucw=; b=l6CyCzKMTJHcSO1iG6tW1rSaI1
	WZYDZtZXi+hQg7BJwpyIXVCTtiSLtb/m/D4PXrUuIzgPDS2U4axg1Wo/wiN/CCtxhz7/Y7F651VQb
	HmWh/j89e9wP7tD/IZFExQpMICv23IgcTcEEyhuUSL7KdWH+k9DZBrOs+Giuem7fpMoeYurngjB2v
	o64qKp9PCgFvQaf/K+n9T7xKX7Ds3nfcdz6z3B++x/4ZFM8wzZNhfZbSRsBKWBbBp2Eqk+UQD2/9n
	F/VJMefYObc7qGVSK7bQYEJIfKndIomqhYFfFfl/9p5iFqsqK3q8MO/7m0Ymdzvjgsfdsbq7MunZb
	UMn9jyKA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXz8I-00AffS-2z;
	Fri, 12 Jun 2026 10:29:03 +0000
Date: Fri, 12 Jun 2026 03:28:59 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] efi/runtime-wrappers: bound the wait for EFI runtime
 service calls
Message-ID: <aivZ8wQAPwGB1O4Y@gmail.com>
References: <20260609-efi_timeout-v1-0-69a896faa805@debian.org>
 <20260609-efi_timeout-v1-1-69a896faa805@debian.org>
 <71de953a-43e9-4987-8b8e-00d9b99a099e@app.fastmail.com>
 <f8c9be21-f15c-4c97-8dfb-de083e07dd32@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8c9be21-f15c-4c97-8dfb-de083e07dd32@app.fastmail.com>
X-Debian-User: leitao

Hi Ard,

On Thu, Jun 11, 2026 at 12:57:50PM +0200, Ard Biesheuvel wrote:
> > Could we just clear the EFI_RUNTIME_SERVICES bit here right away? That
> > way, we probably won't need the second patch (unless I'm mistaken). It
> > /should/ also block the calls that are not routed via the workqueue,
> > e.g., any EFI pstore calls to the non-blocking SetVariable() variant,
> > but I just noticed that we never check EFI_RUNTIME_SERVICES on those
> > code paths, which is probably a bug. 
> >
> > And please return EFI_ABORTED rather than EFI_TIMEOUT - probably doesn't
> > matter in practice but I'd like to avoid introducing more EFI return codes
> > in the runtime context that the spec mentions only for boot services stuff.
> 
> Also, could we prevent the kthread that runs the workqueue from being scheduled
> again if we decide that the runtime services are wedged?

Sure, I can park it at for (;;) schedule()). Maybe with a helper?!

> x86 has some logic for this when a page fault occurs, and I wonder if
> there is a generic way to do something similar.

I have no clue, to be honest. If you have something specific in mind,
I'll dig in.

Thanks for the review,
--breno


