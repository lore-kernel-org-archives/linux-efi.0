Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49375473C63;
	Fri,  7 Aug 2026 12:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786105084; cv=none; b=dU7w+WpvzlhVYxx8mHw9mTq+a5OcdRijdCxKyFEtuK+ruYlmwCQ5feCeVM504uZBmvY6xqjAqqg2uxf/vsrtPzh5se5p8s3JZyDHdf0AxGM7Brih1JjgeC6iGSqm/sOY2Uf9d2+JYuk8P9WAB3rd6sze9ctJ6qxkkBc+oid0PZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786105084; c=relaxed/simple;
	bh=J6ACastlw3ueUj4928B5vWpBPVjv9ubZo/drKFS08do=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJR7Drp3a1ZGH95e3IYXFCgsYZbhehNHdICyB4+/af0IZvjbOpfbqpff29wN4zw/H1jPDGlU76ryJtlGBf7UCDxybLl52Dfvak2hLRIaA8rw45/q8TD/HgmGzdxaQFYByHzdlQahADqQgDkqFcBwvz0LmTTF/NkiSph6TKY1SHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aQ609VhW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQ609VhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D221F000E9;
	Fri,  7 Aug 2026 12:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786105023;
	bh=iIlXgd92q5l3WMeJYxjd8gakHUDLPPBJ4dZQ2jzM1q8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aQ609VhWKoMxZV5B/k6aZXcTx4TL+yj0Oqv8Ck2VatM/sFQ9XfAtp8nCCiwVKXg68
	 4N0urObXCmDTjzXq7U8NuPXV9wzCUtZzg0jVJlxlD61SifrXsSqX65UF1dRto4y3Q1
	 Ms4YJsWHspDH+ggcTif6ddzNYWDhG65x5vbLYHWzY19sy1TGbL2J83IPiqFV9W4clY
	 aC+XzW+fcZxpLC8Z6M4GYqTgNed07yzMeqblP0bVIZk1bnZXNO2MLfWTqlx3JwAhJ/
	 z2+CNj713VWnuA5jBTNo6QklxSsIqmzVSbTbBhZYl7ZwTmHAejYx2D7st1yPux15dR
	 /tFvcjva2sAYA==
Date: Fri, 7 Aug 2026 13:16:58 +0100
From: Will Deacon <will@kernel.org>
To: gus bourg <gus@bourg.net>
Cc: ardb@kernel.org, catalin.marinas@arm.com, ilias.apalodimas@linaro.org,
	linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64/efi: Do not call EFI runtime services preemptibly
 under SW PAN
Message-ID: <anXMug2_-vZl_pZ7@willie-the-truck>
References: <20260806000144.3388823-1-gus@bourg.net>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806000144.3388823-1-gus@bourg.net>

On Wed, Aug 05, 2026 at 05:01:44PM -0700, gus bourg wrote:
> From: Gus Bourg <gus@bourg.net>
> 
> When PAN is emulated by switching TTBR0_EL1, arch_efi_call_virt_setup()
> installs the EFI mm into TTBR0_EL1 via uaccess_ttbr0_enable(), and only a
> return from exception ever puts it back: check_and_switch_context() skips
> the register write by design ("Defer TTBR0_EL1 setting for user threads to
> uaccess_enable() when emulating PAN"), and __switch_to() does not touch it
> either. switch_mm() updates only thread_info->ttbr0.
> 
> Since commit a5baf582f4c0 ("arm64/efi: Call EFI runtime services without
> disabling preemption") the runtime call is preemptible, so the EFI worker
> can now be scheduled out inside that window. An involuntary preemption is
> harmless, because __swpan_entry_el1()/__swpan_exit_el1() save and restore
> the state around the exception. A voluntary reschedule is not: it performs
> no return from exception, so the worker resumes with another task's
> TTBR0_EL1 - or reserved_pg_dir - and the next efi_mm access takes a level 0
> translation fault.
> 
> There is such a preemption point in arch_efi_call_virt_setup() itself,
> immediately after the TTBR0 install: __efi_fpsimd_begin() ->
> kernel_neon_begin() -> put_cpu_fpsimd_context() -> local_bh_enable() ->
> preempt_check_resched().

Hmm, can we move the ttbr0 toggling until after __efi_fpsimd_begin() so
that this preemption point doesn't interfere?

Will
