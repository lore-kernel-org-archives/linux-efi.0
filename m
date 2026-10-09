Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F9938E8C9
	for <linux-efi@vger.kernel.org>; Fri,  9 Oct 2026 15:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791561370; cv=none; b=XSzhO7fo3Ei2WhB0EHyn3jqC1voE6Epjl2aWjv0ASiDuCaxdtCv5ejSqRJ04TGOP40D4Um1rWsUDIYMLOuORK/i1kWXndHAfxxZMuJq6GHvotmU2jQ1Yz3O9cCc/SbioOjvmwjj2B86tRYzwYHXFq+WLJyojDizxa0CPTcdg29A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791561370; c=relaxed/simple;
	bh=GCP18PD1xTer3ITZhBVx0+bDHIk2CUj86J8iE46ywE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jtxBS0DY/4G30LRF+fe+NXQfzrFxk5TGfsaGk1Bes4QDrZ8a7v5bjHTIJk0Y2Ex715AJlxz4OAh6t+ARxjUtJRXOHvjlIk/MO1HbcR6JyQHtC/EwEaFMIQDADtDJX1/1S6gws97rJAynVjLWy2QmZ8ganot3tQ0xwo7EcUjq48E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=pOWNL5rU; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="pOWNL5rU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MgPtVOPTkga0OVt5Xh0otTCQJYOa0i544tz0dcNATnc=; b=pOWNL5rU2fCerxe+NuWkPXiWtV
	qsTZ2ONouBu49CHlFk79kmOc2XSfNnvBLfuaMawki1zbQELFi3yx/LVCh/AWdYRXXBZdB6i6NWpme
	fQlB4aDR5TQ/wdCDdwC0+0JAoDa+qE9N6m1t4ygQfoTwR931hSx2kkOFa9t0sSlJVZQ6hHbNQp4Pa
	yX9WHsiO0nNDJt141PD7FM0IZfSpJOVH1qmA97qF3aipxa+xtRTDJwQNI72DbSFHDaqpNrAFd9UNW
	BRAcLJyQLnQPIvQOovTurRE/Mj8LR4sEOBA6wIjiWwqM3O7NT6QkAmdNqjV/38f0eWkNYjJx1mlBp
	q4AFtK6A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xFCx4-000dog-1M;
	Fri, 09 Oct 2026 15:56:06 +0000
Date: Fri, 9 Oct 2026 08:56:02 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] efi/runtime-wrappers: Don't park the worker after a
 recovered firmware fault
Message-ID: <askOeRkTQRw7SslG@gmail.com>
References: <20261009144814.338052-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009144814.338052-2-ardb+git@google.com>
X-Debian-User: leitao

On Fri, Oct 09, 2026 at 04:48:15PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Commit 4b2c033b5bc9 ("efi/runtime-wrappers: retire the worker if a wedged
> call ever returns") parks the efi_rts_wq worker instead of completing the
> call if EFI runtime services have been disabled by the time the firmware
> returns. The assumption is that this only happens if __efi_queue_work()
> has given up waiting for the call.
> 
> However, arm64 also disables EFI runtime services when it recovers from a
> synchronous exception taken by the firmware: efi_runtime_fixup_exception()
> clears EFI_RUNTIME_SERVICES and unwinds the call so that it returns
> EFI_ABORTED to efi_call_rts(), while the caller is still waiting for the
> completion. The worker now parks without signalling it, so the caller is
> stuck for the full EFI_RTS_TIMEOUT of 120 seconds, after which it reports
> that the firmware is wedged, which is misleading.
> 
> x86 is not affected, as it signals the completion from its page fault
> handler before parking the worker.
> 
> So record explicitly that the caller has given up on the call, and only
> park the worker in that case.
> 
> Fixes: 4b2c033b5bc9 ("efi/runtime-wrappers: retire the worker if a wedged call ever returns")
> Cc: Breno Leitao <leitao@debian.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Breno Leitao <leitao@debian.org>
