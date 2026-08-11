Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53297442FBC;
	Tue, 11 Aug 2026 12:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786450167; cv=none; b=eS0DQx2/Dt+1dd+IwHb2rW/lWvKn1KLaL1WezPiUmssFgeCwgCK/xjtwfAoIepkRs1fSnrWVNeW9WQVKZKODtUVbpnTOIZf6ZpnLP4kO3MPhPj54Ir5x1CvBJuYBuy0QI10n/SmqLHNcRQjZBN7Zos0clsbweHceDdUPggaB3f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786450167; c=relaxed/simple;
	bh=S9pjNkIX18C5tNI/rfqRWMx4jAKzHe+yNdZGc73E880=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZIATj1nuJ8oVGWTPlZHtfbb6cYEDFbQgxjgv37+SbwpVMz4C4GaYeRVJiFC0TgoqMwKfsxfGYECz33Wld+E2t96HDE2bqIufsr1YA6/iVHrKRGVAiYBkUTEFUljDDI/kevJvSVfP9X4If6dgfiafG6n7nZkaY4JoqAFqDV+GBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRB9orrj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRB9orrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965861F000E9;
	Tue, 11 Aug 2026 12:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786450164;
	bh=KYf/U0nL9j9PnqjTffdu49QRWXvXhUFAROWiqj38684=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LRB9orrjzfTGLQNJxffigMBqmUUB4/JhA6YJvO2S7dsUnOwOIuEQZiK8dwsV6+oDU
	 JiL7T+/QLTy1xs7YDID+RpfESR4UdYdNEVneioV/YjqmTkZ8YMeC3ZRuZL8Fq9E97e
	 19WYDH4Y+sjD91Q/gHoAnJScpbUlaePG8Ls6wPF0eSp3zv06yKpXkDYfbSNG05I3xJ
	 Y5lcSoavTXoBSYfhoqlQaXDNLask+4oUgR2HI3r35tw00vlDmpVk+ECXQpqNnIdfGy
	 Zne1h8KaQE68sgtPLGLoNY6d+pQMZDYeHdPc4jPhugiOwhcdXVTszAh9bTJBZT6CSM
	 99wjU8MB+DZCA==
Date: Tue, 11 Aug 2026 13:09:19 +0100
From: Will Deacon <will@kernel.org>
To: Gus Bourg <gus@bourg.net>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64/efi: Do not call EFI runtime services preemptibly
 under SW PAN
Message-ID: <ansQ7xG51RddFmVu@willie-the-truck>
References: <20260806000144.3388823-1-gus@bourg.net>
 <anXMug2_-vZl_pZ7@willie-the-truck>
 <30c5499e-8041-4e39-933b-c5220d53be77@app.fastmail.com>
 <anmwTDnFR2cgxkqR@willie-the-truck>
 <CAKL=SEpvBqMjw2Ts4ODYHCJz0K1axwmtrUGKQEJeb_rvuAQk0A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKL=SEpvBqMjw2Ts4ODYHCJz0K1axwmtrUGKQEJeb_rvuAQk0A@mail.gmail.com>

On Mon, Aug 10, 2026 at 05:51:16PM -0700, Gus Bourg wrote:
> On Mon, Aug 10, 2026 at 4:04 AM Will Deacon <will@kernel.org> wrote:
> > On Fri, Aug 07, 2026 at 04:56:00PM +0300, Ard Biesheuvel wrote:
> > > On Fri, 7 Aug 2026, at 15:16, Will Deacon wrote:
> > > > On Wed, Aug 05, 2026 at 05:01:44PM -0700, gus bourg wrote:
> > > >> There is such a preemption point in arch_efi_call_virt_setup() itself,
> > > >> immediately after the TTBR0 install: __efi_fpsimd_begin() ->
> > > >> kernel_neon_begin() -> put_cpu_fpsimd_context() -> local_bh_enable() ->
> > > >> preempt_check_resched().
> > > >
> > > > Hmm, can we move the ttbr0 toggling until after __efi_fpsimd_begin() so
> > > > that this preemption point doesn't interfere?
> > > >
> > >
> > > Either that, or tweak the logic so that the switch is done eagerly in
> > > this particular case (untested):
> > >
> > > --- a/arch/arm64/mm/context.c
> > > +++ b/arch/arm64/mm/context.c
> > > @@ -266,7 +266,7 @@
> > >          * Defer TTBR0_EL1 setting for user threads to uaccess_enable() when
> > >          * emulating PAN.
> > >          */
> > > -       if (!system_uses_ttbr0_pan())
> > > +       if (!system_uses_ttbr0_pan() || mm_is_efi(mm))
> > >                 cpu_switch_mm(mm->pgd, mm);
> > >  }
> >
> > I think I'd prefer to avoid special-casing this, if we can. I was just
> > thinking of the diff below.
> 
> Tested the v2 approach (__efi_fpsimd_begin() before
> uaccess_ttbr0_enable()) on the board that originally reproduced the
> oops: Khadas VIM3, Amlogic A311D (4x Cortex-A73 + 2x Cortex-A53, no
> FEAT_PAN, so CONFIG_ARM64_SW_TTBR0_PAN is in use), EDK2-based UEFI
> firmware, v7.0.12 plus this change alone (my prior workaround removed).
> 
> Both firmware description modes were exercised (DeviceTree and ACPI
> boots of the same system):
> 
>   - 3,000,000 GetVariable calls (three concurrent readers) plus
>     200,000 GetTime calls per mode, under sustained CPU contention
>     (busy-loop load on half the cores to force scheduling in the call
>     window) - i.e. 6.4M calls total across the ACPI and DeviceTree
>     boots of the same system
>   - SetVariable create/write/delete round-trips in both modes
>   - ~15 reboots/power cycles (ResetSystem) and clean shutdowns across
>     the session
> 
> Zero efi_call_rts faults and zero "Unable to handle kernel access to
> user memory" events; efivars and the EFI RTC remained functional
> throughout, and poweroff/reboot stayed clean. Under the unpatched
> preemptible path the same board faulted within thousands of calls with
> comparable contention, so this comfortably clears the reproduction
> threshold.
> 
> Tested-by: gus bourg <gus@bourg.net>

Thanks for giving it a spin. I'll send it out as a proper patch.

Will
