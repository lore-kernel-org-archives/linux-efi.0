Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094523C342A;
	Thu,  9 Jul 2026 06:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783580185; cv=none; b=eUyH9MSYc7vKR8ZiWalzjckgFNKuUWVEd2IyyqTAPjpMF6K/hZd8KksQ6qSQ7r9LIJH805UXobMsiEqNNV8KJgbBbgLLbHYeHAG2Qra762wlFpaGp0g41i0VMrTSNqvp4ZvHio05WvaUCpqxXE5qp8HljnAVvWqVUOmrOprMla4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783580185; c=relaxed/simple;
	bh=vhWCQINown8Eh9DrTWy4Yj2cB/aQX48UTouXGQRkeas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mtjxcNFO+eXt7lxX3XGTs/NFLArsbdEEub5Y/jmBzkAqrnMNrmIvBUGkRe2Fwwdfuj/hM8kcfXsBSuwpyUyphWiF2EpT1EUtXVcVZzX+3FzVv3o8EL+jEIbh04VzAaY0GkBHrC0wZ+PhE1pYbgbI5oLFlHwCd40+lskqjthd0K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hE2pJjl9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hE2pJjl9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 139D02444;
	Wed,  8 Jul 2026 23:56:19 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02D193F7B4;
	Wed,  8 Jul 2026 23:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783580183; bh=vhWCQINown8Eh9DrTWy4Yj2cB/aQX48UTouXGQRkeas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hE2pJjl924bz5M+TgKrI/aJ9ugfm5DbR4drt6miigpBewU6wsbc2T03a5C4ESqtQz
	 LTmHRHVN0W0BU1ZgSpYywMlhcYy5HTlzSUSoXsJW/P9FpWL4FDHMKGXA5qnOq+QcLl
	 fQ6KM4kRO7rGLwKlRBMdidTH/S3plGjKqPwtur1c=
Date: Thu, 9 Jul 2026 07:56:18 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>,
	Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 5/7] efi/runtime-wrappers: bound the wait for EFI
 runtime service calls
Message-ID: <ak9GEtPuFv_1Sqcw@e129823.arm.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>

Hi Berno,

> When an EFI runtime service hangs in firmware, the efi_rts_wq worker is
> stuck inside the call and cannot be cancelled. __efi_queue_work() then
> waits on the completion forever while holding efi_runtime_lock, so every
> later EFI caller is wedged until reboot; the only symptom is a "workqueue
> lockup" and tasks piling up on the semaphore.
> 
> Replace wait_for_completion() with wait_for_completion_timeout() bounded
> by EFI_RTS_TIMEOUT (120 seconds). On timeout, clear EFI_RUNTIME_SERVICES
> and return EFI_ABORTED so later callers fail fast at the entry check
> instead of each paying another 120 seconds. The wedged worker is
> intentionally leaked and keeps ownership of efi_rts_work.
> 
> A worker that only starts running after the timeout would otherwise
> dereference efi_rts_work.args, now pointing into the caller's freed stack
> frame, and hand stale pointers to firmware. Park it with
> efi_rts_park_worker() at the entry of efi_call_rts() when runtime
> services are already disabled, before it touches args or enters firmware.
> 
> Known limitation: a worker already inside firmware when the timeout fires
> still holds efi_rts_args pointing into the caller's stack frame; if
> firmware unblocks afterwards and writes the output buffers, they land in
> reused memory. Firmware hung this long rarely recovers; a follow-up could
> bounce the buffers through kmalloc.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
> index ae974edc0b04e..2ec5cbdf46d07 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -118,6 +118,14 @@ union efi_rts_args {
>  
>  struct efi_runtime_work efi_rts_work;
>  
> +/*
> + * Upper bound on how long we wait for a single EFI runtime service
> + * call to finish before declaring firmware wedged. Chosen to be longer
> + * than any plausible legitimate call (including UpdateCapsule on slow
> + * SPI-NOR) while still bounding userspace wait time.
> + */
> +#define EFI_RTS_TIMEOUT		(120 * HZ)
> +
>  /*
>   * efi_queue_work:	Queue EFI runtime service call and wait for completion
>   * @_rts:		EFI runtime service function identifier
> @@ -234,6 +242,9 @@ static void __nocfi efi_call_rts(struct work_struct *work)
>  	efi_status_t status = EFI_NOT_FOUND;
>  	unsigned long flags;
>  
> +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> +		efi_rts_park_worker();
> +
>  	efi_runtime_lock_owner = current;
>  
>  	arch_efi_call_virt_setup();
> @@ -355,7 +366,13 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
>  		goto exit;
>  	}
>  
> -	wait_for_completion(&efi_rts_work.efi_rts_comp);
> +	if (!wait_for_completion_timeout(&efi_rts_work.efi_rts_comp,
> +					 EFI_RTS_TIMEOUT)) {
> +		pr_err("EFI runtime service %d wedged in firmware; disabling EFI runtime services\n",
> +		       id);
> +		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +		return EFI_ABORTED;
> +	}

One of my concern is for the UpdateCapsule runtime service.
It might have a case where takes more then 2 mins and there's one
RFC to support a runtime capsule update for arm platform [1].

But I'm not sure how we can discern whether it's a time consuming or
for the bug on the firmware.

At least, should EFI_RTS be configurable via Kconfig and boot param
(timeout or keep the former behavior -- wait_for_completion without
timeout)?

Thanks.

Link: [1] https://github.com/tianocore/tianocore-wiki.github.io/pull/34

-- 
Sincerely,
Yeoreum Yun
