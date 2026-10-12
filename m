Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9038D471CE4
	for <linux-efi@vger.kernel.org>; Mon, 12 Oct 2026 12:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791809486; cv=none; b=rixBC68Ohd7lwz+ZbjN1nG+NOVMr/e3qQV6+yjOs5ndpIrlo20u7QAZYJ/cNlAqxIzX1zGUsEMceA2nGc05+WhxU/5CARZjNB6JxvX4OsvVRQ47ctjKFajhESY5/cz35rUhxnsAts397Bz7ulVpKx9HfDYTdVGLxfjF/N11UzgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791809486; c=relaxed/simple;
	bh=sdQiRsgwCGg73aGmtuJiJQm0mp8UEzwCHU64FdmNsrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9xv+TELj+2kBiHd8kdljKue6XAoYyA1J5iINDhM2YbSc783PT7wCo0fkekJRgu248dSKCsyBHKx+c/Wpp5TIyCKnrkYk3oGydOmmgiNiuox8CL9Igo9H5gmLEykYpkJkXMNRiDFyWuEh3RceZV1Aaye6dS9CeBNKQX8w5vPjZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NHlJTX9S; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NHlJTX9S"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78BD6152B;
	Mon, 12 Oct 2026 05:51:20 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA74B3F66F;
	Mon, 12 Oct 2026 05:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791809483; bh=sdQiRsgwCGg73aGmtuJiJQm0mp8UEzwCHU64FdmNsrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NHlJTX9SpAwdkqXF7VFujHNgmZa8ZpElZK6aRKRQuqI5njdz7fJhjvYE1AuYRROfh
	 NLaD8lw9Ss9rlPPKn0g2dCUP4nh6kylIPzmoKZ1mk0o6GNC79TvdVXc0OU7yLVQhG6
	 +PASkHPm1Mc1zZ0VI5xavRv76VvgwjCcdeNylC8M=
Date: Mon, 12 Oct 2026 13:51:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] arm64/mm: Route faults taken by EFI runtime firmware to
 no_context
Message-ID: <aszXyPjGB8zIWKQT@arm.com>
References: <20261009143438.330265-2-ardb+git@google.com>
 <cad3ed39-407e-49db-91f5-cd36f052ced0@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cad3ed39-407e-49db-91f5-cd36f052ced0@app.fastmail.com>

On Mon, Oct 12, 2026 at 10:36:41AM +0200, Ard Biesheuvel wrote:
> > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > index 0b52557652be..db308fe01c4f 100644
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -40,6 +40,7 @@
> >  #include <asm/kprobes.h>
> >  #include <asm/mte.h>
> >  #include <asm/processor.h>
> > +#include <asm/stacktrace.h>
> >  #include <asm/sysreg.h>
> >  #include <asm/system_misc.h>
> >  #include <asm/tlbflush.h>
> > @@ -621,6 +622,17 @@ static int __kprobes do_page_fault(unsigned long 
> > far, unsigned long esr,
> >  	if (faulthandler_disabled() || !mm)
> >  		goto no_context;
> > 
> > +	/*
> > +	 * Faults taken by EFI runtime services firmware are never resolved by
> > +	 * the mm (efi_mm has no VMAs), and must reach __do_kernel_fault() so
> > +	 * that efi_runtime_fixup_exception() can recover from them. When EFI
> > +	 * runtime services are invoked from a preemptible kthread, neither of
> > +	 * the conditions above applies, so check for this explicitly.
> > +	 */
> > +	if (IS_ENABLED(CONFIG_EFI) && !user_mode(regs) &&
> > +	    is_ttbr0_addr(regs->pc) && current_in_efi())
> > +		goto no_context;
> > +
> 
> Looking at this again, I wonder if we should just add a comparison with
> &efi_mm to the preceding if() condition.

I think mm_is_efi() check in the previous block is simpler. I couldn't
find any case where this wouldn't cover the more extensive check above
(or the other way around).

-- 
Catalin
