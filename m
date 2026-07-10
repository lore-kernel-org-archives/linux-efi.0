Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7403126B0;
	Fri, 10 Jul 2026 10:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783678020; cv=none; b=Qk8Job+qc41VIlEzTzR1it7PVHsqPyf3TS+B++iphw0V5hjEcuPAEAjFIpVCbha+aiFf+3ryu1NNOBCuSDYqTcrQx5izrvryLayYE1YIBTMr1L3tfkKG31lSrd6TDZP/AaIBxnB00AzBJgbxa/WQGGMfAJOVj7wudT5GCg8T2dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783678020; c=relaxed/simple;
	bh=A0uy1JxEYjNecsdXGgSE+EbC+0dUnhy/VnqijuRQNRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pCtLxJORQPjAY0n01L1u9jIpYMsYiC4M0Kk9695EUp10GhMzCuiDWsUAPKe4orEz7KbETAnCSLEZoN8ZWAAu1kF3Yp7ABgNsmB1y+hXrYKtKyFURTK9xT4/UkH+rXuUvFTZ2gcswEnOSYUHzNIUVg7e1/gmXozNK0lBX9+Skt+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=wYmXW/6f; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="wYmXW/6f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tUd9VsB0u4X+mMWWmIpJ5KnSh6Wntd7MJUSzaWerPQw=; b=wYmXW/6fAqIAnno5aOeert4d2O
	XJ8b/hXcb7wqiC8weSeJLUONUtP/6xQtU4g7uxkZxyKAilTlUWQDURscQ9rF49Whlem36zFzZj655
	DjcreuRZEEZFKcSJ+NS9Fn/toX6kS6rjiurl++70C7GZy3AWnuJmb5FNy/kXmmTvbOzL9hb/te1CL
	sKRnGOxAfQ3tnJDPtlGJ/U0YopEbZrolTkWItwtL+h/z0RCIin8pp/JToGH5UTguBZqCVNZZTxOA3
	vmY+YZ1oKU+adk2QjveXrwoH9UiCbTG1T1TR/Wocjvtu3iIFLD/a/EtKX1wgzdWKjzRgIvpbyFSBP
	gkjVcx1A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wi888-004Oxf-0Y;
	Fri, 10 Jul 2026 10:06:48 +0000
Date: Fri, 10 Jul 2026 03:06:43 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <kees@kernel.org>, 
	Tony Luck <tony.luck@intel.com>, "Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 0/7] efi/runtime-wrappers: bound the wait for EFI
 runtime service calls
Message-ID: <alDDv3XGXVdd1mri@gmail.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <akUG8giyFn2a3Lts@gmail.com>
 <361838e6-76e6-4ad3-95ab-994a56bf5f9e@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <361838e6-76e6-4ad3-95ab-994a56bf5f9e@app.fastmail.com>
X-Debian-User: leitao

On Thu, Jul 09, 2026 at 08:02:28AM +0300, Ard Biesheuvel wrote:
> 
> 
> On Wed, 1 Jul 2026, at 15:28, Breno Leitao wrote:
> > Hello Ard,
> >
> > On Tue, Jun 16, 2026 at 05:09:33AM -0700, Breno Leitao wrote:
> >> When an EFI runtime service call hangs in firmware, the kworker on
> >> efi_rts_wq is stuck inside the firmware call and cannot be cancelled.
> >> The kernel currently waits indefinitely on the completion, and the
> >> caller holds efi_runtime_lock for the duration, so every subsequent
> >> EFI runtime caller (efivarfs, NVRAM writes, set_wakeup_time, ACPI PRM
> >> handlers, ...) is wedged until reboot. The only externally visible
> >> symptom is a "workqueue lockup" message and userspace processes
> >> piling up uninterruptibly on the semaphore.
> >
> > I'd appreciate your thoughts on this approach. Is there anything you'd
> > like me to adjust or improve before we move forward?
> >
> 
> This looks fine now, apologies for the delayed response.
> 
> I've queued this up for v7.3

Thanks, Ard.

We got two reports that I would like to address:

1) efi_rts_park_worker() should be tagged as __noreturn
https://lore.kernel.org/all/202607100848.iWPxdkhX-lkp@intel.com/

2) efi_runtime_lock_owner() is undeclared in some kernel config
https://lore.kernel.org/all/202607100518.uMJJPDfP-lkp@intel.com/

Do you want me to respin this series, or, some fixes on top of current
tree?

Thanks,
--breno
