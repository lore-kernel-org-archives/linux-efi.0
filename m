Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E11345731
	for <linux-efi@vger.kernel.org>; Fri, 12 Jun 2026 11:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262696; cv=none; b=TKQq7g93oQnWSZtAjNua9TfyZ/VtHantXrGJ7BbpmOCzoytjJpj2n75Fvgg1OaDx/Cg5VidnoDMHVgI4GX/7Z8H92iblHB94Bd7Vr1yUfi+dYZZnh1EHvwAGP5DkgRyJdRd2zRGcVobbyeLdqt3kjqd+D76Ob4egFVJhk5iyKr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262696; c=relaxed/simple;
	bh=fBYAEpgoH6cxa527iAK538WoCT+ndgQHLUeJbKSORIU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=cch6MVausbnTMvDRBxsPk5JE0N2Oq/vR015d295SympdVGe5nXgVjahLKi+Jf8ShUzSmwqP67c/GmiDJDizkm2rTiThv9psGpk12JznWXNNEHX1pNMAALweENPUDPenhxrzUZDv0cuhxBcpuT8GDRQimC7o5LdCO5jh8d8honQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MjtnFePb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MjtnFePb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B1E1F000E9;
	Fri, 12 Jun 2026 11:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781262693;
	bh=lwR3AGs+s58U/CQtIGmRIplopDCSuhP6rnPNfMMKMnU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=MjtnFePbxoJFsR6ScabI6waI+OniyYTo+RJEb9rLVhYXYiyrf+UNgt2bGOd+woZw/
	 SbLSkComOR4lA8U+3flcHTUTYA26YrKpi9O8OollzlIsUNblXKC/5ORRkcchQE6w1z
	 E+7IZ9OYoepyDhCTtlhdBtwhMSAk3fu8UlP3tKIUQZ0Ab0rqFdCZRx/j9wyAnvL/9Q
	 kCooM93qZbLkYzcyV5DPKYScAMqfX2m+lVLpSJ3VrJF/W6Ashieh6MUCg53CTD8yNN
	 vebVXHfIiPF9xkkUBQCvhQHAJbjv1/SxGrYtAf4RyH4ugqRu/cawp9fPXoapUIrGba
	 9QwRGOQPqtmQw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5EA7BF40095;
	Fri, 12 Jun 2026 07:11:32 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Fri, 12 Jun 2026 07:11:32 -0400
X-ME-Sender: <xms:ZOkrahcdWn27kxpD3k6S_1se8WWKCE6AEPE1M3w7o5kcy03rtclucw>
    <xme:ZOkraqDgQ_Q46MVdZlYhBS1xcpMfkZBAajzECZ5w9ke882cIRM87HFj8leClsv9C1
    kuLwrHFQN42CY3qVMS-3WOAhpobToG1gwtXy_cgPUr7nxlbDyuvRQ>
X-ME-Proxy-Cause: dmFkZTFVJXeoBD943uVROk8yBmSMdxVi7Q6ue5a/7CR4nh3/IOEnJs89v/fr6CzQ55TDgt
    HZJnu16VjMNfziHIs1+sPf3CgGCHZoeIgKVdjALsPJxQByU5d0yU7/jxhpxPcV2FyLVztx
    f1CmpxEf9hneDI2chrwLE8oiz2JmsqZdXXYLNDifwm4avdBJ6eHVRNVtYlKAIrfsjJYWK/
    aK0610+ZppCLfkX3ynEgwmmqEaeJFrDVUKImbv7g7ouHzQgoAsUqlXaA9flD1UQ+8bJj5K
    k/QOhDtsQMcScfWUJwvXdSnUlFl3mM2Lb6rINMgoeAL6RvQmtyUoiyJKyYMVjzpYv5BtVF
    bpw6v4hPz/Zoxs/WR+HRue9imWSKw9c6rdYMpYuishSboA2DnHkV9UIGiLGbxW7GZ8ctcg
    2OG/dDcvPPvq8BV1/DSEzgGhGfGsYglvuI5bS9nUNfZ8UZ9m+v1Hf4YwvrYTjJH7P5BGJr
    YCMu4+WK4H7C1KlkO/F6/WZO6grW4Jf9SB9cZ69PJHRiE0l6Bq2DzY9i0cvwjr0D8DzPZH
    x4zMEhURkDcF3DWOQES464BVK0QtrycjeLSc1lBUDuX7bRXwKn/vO62iCgsW6TvIpcL0t8
    MulSrpWAS9OpDX9rUnLyKxZEUs9OEpOzt9xnUoh6Wj+bOwdL/7/z5tfxUtIQ
X-ME-Proxy: <xmx:ZOkralK3-jhY4mqDwtL4N1xDNMz5FvFLrw5gH8tUL_xVILXnLWtUMQ>
    <xmx:ZOkravr3kX6bjowbpFpsyd6uNxll2hvvZ5KYTWXAGSTj23akcG80nw>
    <xmx:ZOkrakhNZeXHHKxv9LjLaiA5mLqQgmlhKWTez2qpMWiW4VQXIKhVYg>
    <xmx:ZOkrambjVi_1CPRwz9aoCSB9hkSP-MtckloGxCZAcIUZ9gLjxF4WqQ>
    <xmx:ZOkrakm0Ux4Lu5g_P29EQxpWj3VtoilHD-DsVl5aWz0i8PSpbI5nFknZ>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 392AC182007E; Fri, 12 Jun 2026 07:11:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 12 Jun 2026 13:11:11 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Breno Leitao" <leitao@debian.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Borislav Petkov" <bp@suse.de>, "Andy Lutomirski" <luto@kernel.org>,
 "Kees Cook" <kees@kernel.org>, "Tony Luck" <tony.luck@intel.com>,
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Message-Id: <b3780e66-dad0-4f39-9dc6-b74f23fabb62@app.fastmail.com>
In-Reply-To: <20260612-efi_timeout-v2-6-f714bb016df6@debian.org>
References: <20260612-efi_timeout-v2-0-f714bb016df6@debian.org>
 <20260612-efi_timeout-v2-6-f714bb016df6@debian.org>
Subject: Re: [PATCH v2 6/6] efi/runtime-wrappers: retire the worker if a wedged call
 ever returns
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

On Fri, 12 Jun 2026, at 13:01, Breno Leitao wrote:
> When __efi_queue_work() times out it disables runtime services and
> returns, but the kworker is still blocked inside firmware. If the
> firmware eventually unblocks, efi_call_rts() would run its tail on an
> efi_rts_work that the timed-out caller has long abandoned: signalling a
> stale completion and clearing efi_runtime_lock_owner that may by then
> belong to another caller.
>
> If runtime services have been disabled by the time the call returns,
> park the worker in a schedule() loop instead, so it never touches
> efi_rts_work again or returns to the workqueue.
>
> x86's efi_crash_gracefully_on_page_fault() already ends in the same loop
> for the page-fault case. Factor it into efi_rts_park_worker() and call it
> from both paths.
>
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  arch/x86/platform/efi/quirks.c          |  9 +--------
>  drivers/firmware/efi/runtime-wrappers.c | 21 +++++++++++++++++++++
>  include/linux/efi.h                     |  2 ++
>  3 files changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/platform/efi/quirks.c 
> b/arch/x86/platform/efi/quirks.c
> index 90a065fcb1fab..02c56a02eb9bc 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -832,12 +832,5 @@ void efi_crash_gracefully_on_page_fault(unsigned 
> long phys_addr,
>  	clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>  	pr_info("Froze efi_rts_wq and disabled EFI Runtime Services\n");
> 
> -	/*
> -	 * Call schedule() in an infinite loop, so that any spurious wake ups
> -	 * will never run efi_rts_wq again.
> -	 */
> -	for (;;) {
> -		set_current_state(TASK_IDLE);
> -		schedule();
> -	}
> +	efi_rts_park_worker();
>  }
> diff --git a/drivers/firmware/efi/runtime-wrappers.c 
> b/drivers/firmware/efi/runtime-wrappers.c
> index 842f72d44211f..998e5f8f1c62c 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -219,6 +219,19 @@ static struct task_struct *efi_runtime_lock_owner;
>  extern struct semaphore __efi_uv_runtime_lock 
> __alias(efi_runtime_lock);
>  #endif
> 
> +/*
> + * Park a worker that must never run efi_rts_wq again: EFI runtime services
> + * have been disabled and its efi_rts_work is abandoned. Loop in schedule()
> + * so a spurious wakeup cannot resume it.
> + */
> +void efi_rts_park_worker(void)
> +{
> +	for (;;) {
> +		set_current_state(TASK_IDLE);
> +		schedule();
> +	}
> +}
> +
>  /*
>   * Calls the appropriate efi_runtime_service() with the appropriate
>   * arguments.
> @@ -320,6 +333,14 @@ static void __nocfi efi_call_rts(struct work_struct *work)
>  	efi_call_virt_check_flags(flags, efi_rts_work.caller);
>  	arch_efi_call_virt_teardown();
> 
> +	/*
> +	 * If __efi_queue_work() timed out and disabled runtime services, the
> +	 * caller is gone and efi_rts_work is no longer ours: park the worker
> +	 * so it never signals the stale completion or runs again.
> +	 */
> +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> +		efi_rts_park_worker();
> +

So one thing to note here is that the arm64 version of the exception recovery
(in efi_runtime_fixup_exception()) will also clear EFI_RUNTIME_SERVICES, and
that will occur before this check. This means we will park the worker not only
on a time out, but also on an sync exception in the firmware.

I suspect this is actually what we want, but it deserves to be called out.


>  	efi_rts_work.status = status;
>  	complete(&efi_rts_work.efi_rts_comp);
>  	efi_runtime_lock_owner = NULL;
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 24221a8424121..015505423277e 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1256,6 +1256,8 @@ extern struct efi_runtime_work efi_rts_work;
>  /* Workqueue to queue EFI Runtime Services */
>  extern struct workqueue_struct *efi_rts_wq;
> 
> +void efi_rts_park_worker(void);
> +
>  struct linux_efi_memreserve {
>  	int		size;			// allocated size of the array
>  	atomic_t	count;			// number of entries used
>
> -- 
> 2.53.0-Meta
