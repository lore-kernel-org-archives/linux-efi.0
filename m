Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9512C1C3F0C;
	Thu, 12 Feb 2026 15:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770909519; cv=none; b=AqIvXlVAF/U9JeCSTFmDvHMiJC5GnWPwhqC+zWLqARcsGKBOLBmwcNWi3FR1ydGtgbkD9tny+ESGodltEeKdVPuQtGNpSMnDTAmx2VpqYSDDP4OOC2nE4DwGsKOSX6GC4SqVerSk7i0l9AIXwc6UsB7mr75ptaWUJo33Z1/920M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770909519; c=relaxed/simple;
	bh=ai5+4phpGGg9Zf2/MzswoaaLkZJhMjczH6MtkTFYiDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2KVRju0eX48Aup5aFHJWJITfdkmEFpXS12yCFfOGjygnhwXqXgKBhn1Jxr3gdHwmoxtt5RSj5c1zgIVpcpZPAYp+ACiWbWTDpTNQYITcZQSSxvqrbIu4fB//0Z8Uqy4gbtNJjf3ILdLkQHkM9tinNRa61ITYqm7mGmELU1UwIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=NXAXFZMz; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=6iTTKLuH; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="NXAXFZMz";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="6iTTKLuH"
Date: Thu, 12 Feb 2026 16:18:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1770909516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SGzf6YJRP8H9TbMz2kFAMAC0ww4swNjoJ2X6kO51pI4=;
	b=NXAXFZMzFKsu3TQWxkx/BzaMjJ5wh1BhqgUFgpk5LnoCEDxGwPYreHmOifj6nINpSZPnXf
	XbTXy3A2tPNcS0/OqjTijJTyyThlGcRljq9AGipKIJciI03nJ65Ha3iUzEGLctrRGkhgvA
	PcsvuyIUgv1FAOcT3CuzzxvB20IMDDNPfsXKvPlOr/5W4PovrWWcqzKhuLu/ackf4moOdA
	uJCG6TH0rNhiYZQRKn13WnC9Pfiogvd9kxktkL9a7lNuC1Z5sWb2bI+MbmI2jL/vf+XUI1
	opowre9I1KhWyUzUzZGYDq1COdGSIrOY8mbKBoU1UFxZzPt+nbK8Gw1mqohjwg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1770909516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SGzf6YJRP8H9TbMz2kFAMAC0ww4swNjoJ2X6kO51pI4=;
	b=6iTTKLuHeo8tsKSEw2Tb3IhQl9uQNa4hmagPRfUl9Bj0V11NbFx4BiHkNOf5G0F3mJpVJc
	qVqGeEDXXcQBZpAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	John Ogness <john.ogness@linutronix.de>,
	Lai Jiangshan <jiangshanlai@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/2] efi: Expose the runtime-services workqueue via sysfs
Message-ID: <20260212151835.8On7hOkI@linutronix.de>
References: <20260205115559.1625236-1-bigeasy@linutronix.de>
 <4c6a5533-6fcd-4237-bb35-0ca74029c7db@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4c6a5533-6fcd-4237-bb35-0ca74029c7db@app.fastmail.com>

On 2026-02-09 18:10:52 [+0100], Ard Biesheuvel wrote:
> Hello Sebastian,
> 
> On Thu, 5 Feb 2026, at 12:55, Sebastian Andrzej Siewior wrote:
> > EFI runtime services are disabled on PREEMPT_RT by default which can be
> > overwritten on the boot command line. For native EFI, an invocation
> > requires to disable preemption while a call is made into EFI.
> 
> This is no longer true on arm64 since
> 
> commit a5baf582f4c026c25a206ac121bceade926aec74
> Author: Ard Biesheuvel <ardb@kernel.org>
> Date:   Wed Oct 15 22:56:42 2025 +0200
> 
>     arm64/efi: Call EFI runtime services without disabling preemption
> 
> except for some corner cases (reboot, pstore crash dump).

Hmm. While this sounds familiar (and I think you told me that FPU usage
no longer disables preemption here, too) there is x86 for instance. Here
arch_efi_call_virt_setup() disables preemption twice (efi_fpu_begin() +
(firmware_restrict_branch_speculation_start()) followed by
efi_call_virt_save_flags() where interrupts are off. 

Also I don't know if the EFI implementation itself is allowed to disable
interrupts.

> > There are two EFI invocations which are not covered by this
> > - mixed EFI
> >   Used on x86 with 64bit kernel but 32bit EFI. Would it work to use here
> >   the same workqueue mechanism?
> >
> 
> That stuff is beyond obsolete, so I don't think it is relevant for RT.

agreed.

> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Oh. Thank you.

Sebastian
