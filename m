Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A808435CBC3;
	Wed, 12 Aug 2026 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786545712; cv=none; b=AZAUpWp36FKpiY47mbKAyIcv3iOjKa7MdbfGFsmc1h69wMSjoNSHoHGnVKAB/+V/rql5tp2VmNrJdG0qt2vcBaKdSjhvgVTwVrDSigHoa1j1IxO0oTCeFC64TqYFLKEw/OXCNAvVm3JwgMu8K1tgoEZjdLHozT4GJBK8YqA1Qqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786545712; c=relaxed/simple;
	bh=Y3+tHlJvxzaevN7riS0pjW4kmKRShCH91utWXiaOJzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SAtvyorpvyO3TQH5qr3qIl/t80wUXa5LMYfbtTRgm5bLluC0NM0dhVySFg47ow8SIOUD+yyBv789bNWUMUpw1JGcBtrURktooBTh5+N6u4nVDg32y1B4VymD7TyGkBSoXvfP3WdV422edNbTfyojYiWo4NA3G2FYN4HVgz9tf50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=vG69TSNE; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=DxmAb5Nv; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vG69TSNE";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="DxmAb5Nv"
Date: Wed, 12 Aug 2026 16:41:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1786545708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lsqn5GI97jZzlDGUrDi2eLDBinpVB4CEF9tbNGkt/dA=;
	b=vG69TSNEA8A5va8HgmgnUNn+QLrO0NbRt/A33znNF3XtATNADRzxpRO/1b2KJi6RVHjxr2
	mZLnwia4H9O80mj/mVD4oIP9jTi/7e8zmA7pF5r486sBIMzLGVj5KPCyqEH83ipEhZcHbK
	g326V/tfc/J3KAoIwTAvRkrB3R+7Akvxsd5ShbJsci5LFa3t2uZPxtbdetGeKFR1SwPCTY
	NYKTWlqmwIGOjrWESm0qSePLmsW2V6KaMyy0YEIkYsAyDt+rbHT5CIVjgdPx0t+Fboy5sq
	nBuh+pR4tdzisx/jPt2KtB8MMZQgwobY2E7lO18TToeKc9q6sSVV8uwvMGs97Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1786545708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lsqn5GI97jZzlDGUrDi2eLDBinpVB4CEF9tbNGkt/dA=;
	b=DxmAb5NvIlhWgbOPz9Qml6KgMXN6oGOaJLkRlWYznTxwot0dQ2U57Hk3gka87hS5SeVRZl
	nr4xjgHDJxS6GyBQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Junxiao Chang <junxiao.chang@intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mefi: add dynamic control interface for EFI runtime
 services
Message-ID: <20260812144147.0Dahmj4w@linutronix.de>
References: <20260704003341.3923900-1-junxiao.chang@intel.com>
 <d107385f-1c58-4aa0-beac-7d536d064600@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <d107385f-1c58-4aa0-beac-7d536d064600@app.fastmail.com>

On 2026-07-23 08:37:23 [+0200], Ard Biesheuvel wrote:
> (cc Sebastian)
Thanks.

> On Sat, 4 Jul 2026, at 02:33, Junxiao Chang wrote:
> > b/Documentation/admin-guide/kernel-parameters.txt
> > index b5493a7f8f228..533213101f808 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -1595,7 +1595,8 @@ Kernel parameters
> >  	efi=3D		[EFI,EARLY]
> >  			Format: { "debug", "disable_early_pci_dma",
> >  				  "nochunk", "noruntime", "nosoftreserve",
> > -				  "novamap", "no_disable_early_pci_dma" }
> > +				  "novamap", "no_disable_early_pci_dma",
> > +				  "dynamic" }
> >  			debug: enable misc debug output.
> >  			disable_early_pci_dma: disable the busmaster bit on all
> >  			PCI bridges while in the EFI boot stub.
> > @@ -1612,6 +1613,8 @@ Kernel parameters
> >  			novamap: do not call SetVirtualAddressMap().
> >  			no_disable_early_pci_dma: Leave the busmaster bit set
> >  			on all PCI bridges while in the EFI boot stub
> > +			dynamic: enable EFI runtime services, which can be
> > +			disabled via /sys/firmware/efi/dynamic_enable.
> >=20
> >  	efi_no_storage_paranoia [EFI,X86,EARLY]
> >  			Using this parameter you can use more than 50% of
>=20
> I'd prefer not to add a command line option for this. If the sysfs control
> is useful, we can enable it unconditionally, or depend on PREEMPT_RT.

If we do this enable/ disable at runtime, could we name if
"runtime_enable" or "enabled" instead "dynamic_enable"?
We could also have the =3Dnoruntime option as an initial off switch which
could be overwritten at runtime to enable it temporary.
This probably benefits only efivars since everything else (like efi-rtc)
remains non-functional or broken (if enabled/ disabled at runtime).

We have this thing where the efi-runtime workqueue can be limited to a
certain CPU in case it helps. But then I learned then certain EFI
versions do block all other CPUs while the one CPU is performing a EFI
invocation=E2=80=A6

Sebastian
