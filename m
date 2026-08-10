Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E863B0AE6;
	Mon, 10 Aug 2026 11:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786359890; cv=none; b=CJqA4omCVsyGqeD13gAopmADfx74HA/CIyazaGi+53cUscC+GPyS+X1C6kbkRSJYD4rbKe/kgaa7/P/Qj96d9L45FWKZ0bWXyud/cAzuo8soSa2PnEw1Nx/5IjAIlVwg0tfXV7/5iC9I6sR9YG2doI6ElfmExx03en59Vh+phKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786359890; c=relaxed/simple;
	bh=5UUelv2h0RnA9w6W180NpfBAwIdxpaiWU9xTaqF7veM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hzxr9fZ71YjprWIvCM8S6lVr2H7RxcJiqG6ggJ2z6n6ou73CyPPsuLW6sg99oAwgjwwpySleax7tn+QGoTzlmycm+FAxG2ygIHZ2dvHwjvS0K5M/j7ocwaDYwlZu3yWftC4pKgDJBDYLtGVA/IHj6YuG8hxI/JAkNez4h2PJpU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agFE+wD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agFE+wD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61451F000E9;
	Mon, 10 Aug 2026 11:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786359889;
	bh=gI5k/9cl/ieyg839FRaHqV6Z6OMpnh4gRsszIL3A9lg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=agFE+wD2ubNxyH2+bC30Mu/nvDhuGf1lGI3fxZ/VlwVou3BrvUsWA7v4mCYflP98/
	 kPVS4JMrHfPPPmEX+4ZYWdGl6/7jYRoOzQl7CpCbMw+Ko/cjrW18eK4AfiaTfuYmNL
	 65R4p7p/Y+hIA09oKr0+sPh7RFa1OVE0RSj7jJkMWPHqr8lwZsFrAQGfYtbdBtZvfU
	 gqYDKcPsYDSQDYwsGhMaesZH+JL6sfSehZ5GqLGzxnsJjWltMPL0ab8Q10pn8NHHQX
	 /8oEijyKs2b1HC0gt1WHvozn3osKhAYEHhjTrLDv/RaIuBXyscRynMFasSMqQ/Flhs
	 OGmn1HDOvO3Vw==
Date: Mon, 10 Aug 2026 12:04:44 +0100
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: gus bourg <gus@bourg.net>, Catalin Marinas <catalin.marinas@arm.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64/efi: Do not call EFI runtime services preemptibly
 under SW PAN
Message-ID: <anmwTDnFR2cgxkqR@willie-the-truck>
References: <20260806000144.3388823-1-gus@bourg.net>
 <anXMug2_-vZl_pZ7@willie-the-truck>
 <30c5499e-8041-4e39-933b-c5220d53be77@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30c5499e-8041-4e39-933b-c5220d53be77@app.fastmail.com>

On Fri, Aug 07, 2026 at 04:56:00PM +0300, Ard Biesheuvel wrote:
> 
> 
> On Fri, 7 Aug 2026, at 15:16, Will Deacon wrote:
> > On Wed, Aug 05, 2026 at 05:01:44PM -0700, gus bourg wrote:
> >> From: Gus Bourg <gus@bourg.net>
> >> 
> >> When PAN is emulated by switching TTBR0_EL1, arch_efi_call_virt_setup()
> >> installs the EFI mm into TTBR0_EL1 via uaccess_ttbr0_enable(), and only a
> >> return from exception ever puts it back: check_and_switch_context() skips
> >> the register write by design ("Defer TTBR0_EL1 setting for user threads to
> >> uaccess_enable() when emulating PAN"), and __switch_to() does not touch it
> >> either. switch_mm() updates only thread_info->ttbr0.
> >> 
> >> Since commit a5baf582f4c0 ("arm64/efi: Call EFI runtime services without
> >> disabling preemption") the runtime call is preemptible, so the EFI worker
> >> can now be scheduled out inside that window. An involuntary preemption is
> >> harmless, because __swpan_entry_el1()/__swpan_exit_el1() save and restore
> >> the state around the exception. A voluntary reschedule is not: it performs
> >> no return from exception, so the worker resumes with another task's
> >> TTBR0_EL1 - or reserved_pg_dir - and the next efi_mm access takes a level 0
> >> translation fault.
> >> 
> >> There is such a preemption point in arch_efi_call_virt_setup() itself,
> >> immediately after the TTBR0 install: __efi_fpsimd_begin() ->
> >> kernel_neon_begin() -> put_cpu_fpsimd_context() -> local_bh_enable() ->
> >> preempt_check_resched().
> >
> > Hmm, can we move the ttbr0 toggling until after __efi_fpsimd_begin() so
> > that this preemption point doesn't interfere?
> >
> 
> Either that, or tweak the logic so that the switch is done eagerly in
> this particular case (untested):
> 
> --- a/arch/arm64/mm/context.c
> +++ b/arch/arm64/mm/context.c
> @@ -266,7 +266,7 @@
>          * Defer TTBR0_EL1 setting for user threads to uaccess_enable() when
>          * emulating PAN.
>          */
> -       if (!system_uses_ttbr0_pan())
> +       if (!system_uses_ttbr0_pan() || mm_is_efi(mm))
>                 cpu_switch_mm(mm->pgd, mm);
>  }

I think I'd prefer to avoid special-casing this, if we can. I was just
thinking of the diff below.

Will

--->8

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 30cd7f804398..0ec90fd1754e 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -184,6 +184,8 @@ void arch_efi_call_virt_setup(void)
                efi_virtmap_load();
        }
 
+       __efi_fpsimd_begin();
+
        /*
         * Enable access to the valid TTBR0_EL1 and invoke the errata
         * workaround directly since there is no return from exception when
@@ -191,8 +193,6 @@ void arch_efi_call_virt_setup(void)
         */
        uaccess_ttbr0_enable();
        post_ttbr_update_workaround();
-
-       __efi_fpsimd_begin();
 }
 
 void arch_efi_call_virt_teardown(void)

