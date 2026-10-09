Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D384D0CD8;
	Fri,  9 Oct 2026 11:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791545629; cv=none; b=jT5RWjwa/uKEmVYGDctlLKDU9rz5tf1RGImRiSEO8+yS8HML6wIF6ZwavPkbgdZX9GnirAavYGK/VCY58Z3KZLC68AH/JetLcY9iSPEOy4nUU6J/MWaOD3IUmOFKhr4zMGZNrLFlBcbad6zo6dkuivgfxd12kHTqQzwVRVSNqA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791545629; c=relaxed/simple;
	bh=35CcgE7qYKJIldcAlGz4d1dHsd0RyLUYt1G7cMocRRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQqrq4mK45OfJ+EU6bg31KLGQWbThTI1Fd0rh4Fw0XLq/euPpm0Y3dX2uDqswpp4i6sUu8IZpbXnam9SjTHlu8eZ3KgfWV5iRzxg/Q7eRneTBXS1QnmdcYTc9CK7QylHHVgSdi/wAB7KTt7DJpAjtkvf3N+05B3p571Z5KLh9pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=MgO3dYSY; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="MgO3dYSY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lo5NHgYgqHC5VtUmJ9M7ieb++8MqWKPMb4kBZmp3hX0=; b=MgO3dYSYJj4FTMl+80fE72imSw
	5civSJYOuhrmR1E6MoAZ93pWN5dp7ZKD65cvlpC/x4kCObLvuscojMrK1zrK5oPy8gUx3x0CfKThA
	34TxY0zecp+DNW8OqC7C4JcQng+AdzuhNaYFxwZQj/8rQkXyQ5Qkpj7wXn7vOK1YSPJukmbM0p9nd
	WIGjZuqy4ee3J9ljU6nRXoSZjmg2rhV+L7C8mQfnJTlHRHVn9Rt62y/W5ewc08gjYbrAY6QB4iJkF
	4YR28x84S2pUvJUN6PL1AxfydnZXBRUp6wFhuSto4XNA0MffD+1dnbx8MJjF3bMljTWSzRrdbwnHy
	0GbDl/xA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xF8qz-000VA8-30;
	Fri, 09 Oct 2026 11:33:34 +0000
Date: Fri, 9 Oct 2026 04:33:25 -0700
From: Breno Leitao <leitao@debian.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	"sami.mujawar@arm.com" <Sami.Mujawar@arm.com>
Subject: Re: [PATCH] firmware: efi: add a separate timeout for UpdateCapsule()
Message-ID: <asjQqEKdF6YiMXxU@gmail.com>
References: <20260903113238.2291844-1-yeoreum.yun@arm.com>
 <960e985e-b338-4648-a29b-1f8a31e00599@app.fastmail.com>
 <apl_29t7Jxr2mv9C@e129823.arm.com>
 <44097058-9fdc-4e9f-a277-d63e3876b035@app.fastmail.com>
 <23ce2fb0-1002-409f-bb84-f592db9d0b89@app.fastmail.com>
 <apmFpUvkRBgMdOH2@e129823.arm.com>
 <aqkGohQYChzkBPZ7@e129823.arm.com>
 <b6602c6e-4c77-4dcf-8683-95b5c8fc4693@app.fastmail.com>
 <aqwO0EdIwzBQlnmW@e129823.arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqwO0EdIwzBQlnmW@e129823.arm.com>
X-Debian-User: leitao

On Thu, Sep 17, 2026 at 05:01:20PM +0100, Yeoreum Yun wrote:
> > > Could there be any issues with doing it this way, or would there be
> > > a better approach?
> > >
> > 
> > Would it make sense to simply have different limits for UpdateCapsule() and
> > for everything else? How much longer than 2 minutes do you need in the
> > typical case?
> 
> Although the time required to complete a firmware update depends onthe platform
> and other factors, such as whether the capsule contains a single firmware image
> or multiple images, it is generally reasonable to expect the update to complete
> within 10 minutes.
> 
> If, for some reason, an update is expected to take longer than 10 minutes,
> the sysfs interface for configuring capsule_update_timeout would be useful.
> 
> This would allow the timeout to be adjusted as needed, for example to
> 15 minutes, before capsule update. 

In this case, if you have a worker that takes 10-15 minutes, will not 
the workqueue stall kick in ?
