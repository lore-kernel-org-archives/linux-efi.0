Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C793ACA59;
	Thu, 11 Jun 2026 10:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781173326; cv=none; b=r26dO9lOTywQWDwElgMtlRJyAlggSfTPbQXJy40ebXpTPLPGjHHUz9+eCWIqrBSBpNhdu/vMfCs93KfrXwUF/4fzfA9lrILXKlsa7STQzOIfUor7s3Me6rUlQhW0U2fO+lSfemT/PVpWmrQLlJvOvo35wI7cafOQuOiBEa+Qq4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781173326; c=relaxed/simple;
	bh=53YvzcbY3NDWCmL7hPALiKXTRTh3hwzjsqKes5EewvY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=ZrxuhnKkAq+NoN5w61sCqOnvMvqPkQcgoMYU8We/0M/kzqfhsiixkUZoih5F8l99y/1d6ZYL/cnoQJrnU1A4MfsVNV9JhSBN7kSOKI+t2AT0+Y580qqKPSYBjCbzW0ULh3tssswYThoPgBsnHXKS0/Z4bdaXPpD+0nrJix2AOZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKdQ/Ipa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKdQ/Ipa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267131F00898;
	Thu, 11 Jun 2026 10:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781173324;
	bh=++Md3FwB4bQg/e+l7aPepcsewpGZu69iJrqfgEtfR6s=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=gKdQ/IpadfXK5zhe1wHufyyZkUdL2hPZ0W+MOtwTTN6N8HQAr5459yvdfPFmzCaxp
	 W89zgUIPS+WzxVvgPHcXtoXRkND8cyN5J4Zkx/KuaXoRfeSbDZ3B/StjqPyDzY6Qjy
	 OKatmNwp/6MnSkJoECkLAYkS9qezvWRFFvkB/ODqQzSBG++dOtzT8nH4pbCHaCUHlU
	 o0ATz2ooISqrR2csGp3P/FB/Ca7FWd+aOoZxiVZm2ZUlDWPKio35ig0CcUD2RvWYZT
	 U9zga4Po/qSY/s6WPKhOQydWu3jnPjNInY2otEmdcp/LnnKWEIC2AgpHCNCFQsUjQ+
	 rtnOp3Yg7QgSA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5784FF4006B;
	Thu, 11 Jun 2026 06:22:03 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Thu, 11 Jun 2026 06:22:03 -0400
X-ME-Sender: <xms:S4wqagFH1TPWZFESlRoLlLu1U3FWi_q6kO4uUoQ7WGL7--4uB9i9Gw>
    <xme:S4wqakL1FN7zPl8DkmIHz365_RPaOQ7_8fIhyGhWblp1vftMozZ8ixd2ttymgmir4
    2cNdpfpTPsy6G_YndxQBO4hEZkGxFRbaNnmv-wQ-KzmH1WnkdGARCQ>
X-ME-Proxy-Cause: dmFkZTFzBLxIxzSa+Bp8Wpya6OjB10UY3FHc6Fy9jOByGEB09AcGAghmYdwhVm/J1NSoma
    q3di6AuMoW1lkJWXIyQh+/7mv/k88PDLxhzf7A/e2N1TmtBJ6n7vuBnYdaqjmSP5sC16uj
    wKAG/A3kj79RJUHRFyX8YFwLlRM45C9EMWJY3cUf80CQfaxlZR5sWOsHr9xDkgrDKX3oGv
    ni3A7PTjb8ntnbtxILGtwKylOGAID8cWxWI1U2CE3IbN9hmsVGavdCTbSlbCl98/18ZOKC
    56ZWEbXoizaIpGeaNVMvCUAq0bf0LQ0i4F05eaYSghCJDzjzbr436x+Sm4pD8E4sob7vEl
    h+e+KWILVaVr6NTGQ7I1I48H9MF6ccxLeZJutlKbUwXBA7Jxv1U+JhfzKaDv5cktko2co1
    1mytJ6/Rgw9CIHngyc25PNoGJTEzUd4ww8f+T65Eso7tWuK+PwfgAMkF8dAlB4SsJhPgmH
    iAX95lkhXx+FUYHbvOdezIvSdYztm6Xh2cxLRjzrmR5G7I0g4IIOJOOGN9WFP4Xx7TQre3
    CW0VeLkmFIafy1wIig1oQ9/sVnAk5mcKrnsyuMvVXbSqipCvq0sjATw1D68d/wDkfAMpPk
    WkfI5p9FBq2AYoKor77t4tqWh3vFQlb3bdQgPEKSOnGptSLBcrL7PH6vZTpg
X-ME-Proxy: <xmx:S4wqagTUKNU7ZidK1JddokZLJypg8pK0mQiCfy1798czJarWt9mktQ>
    <xmx:S4wqams3imAmQz0vIyFi5DVghnR6BzKHFsY8gbjoN_i7QpHc6ChUBQ>
    <xmx:S4wqapYCgX8V4t2hK5QYWMq9423poCuwGxFwVUDeOJZb66EMyiesBA>
    <xmx:S4wqakEf-p-Qh522JjQ_vSJcIyUnr-RQ8uuVLpk0MvNKzWMwDqgP_w>
    <xmx:S4wqalwPQ0ylx2EsuwC7a-sDDY6kvlikDI6sNDsRtowTsZgxl2bRlEBO>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 34126182007E; Thu, 11 Jun 2026 06:22:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 11 Jun 2026 12:21:42 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Breno Leitao" <leitao@debian.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Message-Id: <71de953a-43e9-4987-8b8e-00d9b99a099e@app.fastmail.com>
In-Reply-To: <20260609-efi_timeout-v1-1-69a896faa805@debian.org>
References: <20260609-efi_timeout-v1-0-69a896faa805@debian.org>
 <20260609-efi_timeout-v1-1-69a896faa805@debian.org>
Subject: Re: [PATCH 1/2] efi/runtime-wrappers: bound the wait for EFI runtime service
 calls
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Breno,

On Tue, 9 Jun 2026, at 13:55, Breno Leitao wrote:
> When an EFI runtime service call hangs in firmware, the kworker on
> efi_rts_wq is stuck inside the firmware call and cannot be cancelled.
> The kernel currently waits indefinitely on the completion, and the
> caller holds efi_runtime_lock for the duration, so every subsequent
> EFI runtime caller (efivarfs, NVRAM writes, set_wakeup_time, ACPI PRM
> handlers, ...) is wedged until reboot. The only externally visible
> symptom is a "workqueue lockup" message and userspace processes piling
> up uninterruptibly on the semaphore.
>
> Replace the indefinite wait_for_completion() in __efi_queue_work()
> with wait_for_completion_timeout() bounded by EFI_RTS_TIMEOUT
> (120 seconds). On timeout, log the wedged runtime service id and
> return EFI_TIMEOUT to the caller.
>
> The wedged worker is intentionally leaked - it is still inside
> firmware and cannot be cancelled - and the shared efi_rts_work is
> abandoned to it. EFI runtime services become unavailable until reboot;
> the alternative is permanent userspace hang.
>
> This patch should land together with the follow-up that introduces
> the efi_rts_dead fast-fail flag: between the two, a subsequent
> __efi_queue_work() caller will re-INIT_WORK() and re-init_completion()
> on the work_struct and completion that the leaked worker still owns,
> which can corrupt workqueue state and let the next caller observe
> the leaked call's status as if it were its own. The split exists for
> review clarity; reviewers may prefer to squash.
>
> Known limitation: the union efi_rts_args that __efi_queue_work() hands
> to the worker contains pointers into the caller's stack frame (the
> compound literal in efi_queue_work() and the in/out buffers it points
> to, e.g. *tm in GetTime). Once the caller returns -EIO and unwinds,
> those slots are reusable. If firmware eventually unblocks and writes
> to the output buffers after the timeout has fired, the writes land in
> whatever now occupies that memory. In practice firmware that hangs for
> more than 120 seconds tends to stay hung. A follow-up bouncing args
> and output buffers through kmalloc would close this gap.
>
> At fleet scale this turns a generic "workqueue lockup" or stalled-task
> mystery into an unambiguous "EFI firmware is at fault" signal in
> dmesg.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/firmware/efi/runtime-wrappers.c 
> b/drivers/firmware/efi/runtime-wrappers.c
> index da8d29621644..6ce6d094066e 100644
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
> @@ -338,10 +346,16 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
>  	 * queue_work() returns 0 if work was already on queue,
>  	 * _ideally_ this should never happen.
>  	 */
> -	if (queue_work(efi_rts_wq, &efi_rts_work.work))
> -		wait_for_completion(&efi_rts_work.efi_rts_comp);
> -	else
> +	if (!queue_work(efi_rts_wq, &efi_rts_work.work)) {
>  		pr_err("Failed to queue work to efi_rts_wq.\n");
> +		goto exit;
> +	}
> +
> +	if (!wait_for_completion_timeout(&efi_rts_work.efi_rts_comp,
> +					 EFI_RTS_TIMEOUT)) {
> +		pr_err("EFI runtime service %d wedged in firmware\n", id);
> +		return EFI_TIMEOUT;

Could we just clear the EFI_RUNTIME_SERVICES bit here right away? That
way, we probably won't need the second patch (unless I'm mistaken). It
/should/ also block the calls that are not routed via the workqueue,
e.g., any EFI pstore calls to the non-blocking SetVariable() variant,
but I just noticed that we never check EFI_RUNTIME_SERVICES on those
code paths, which is probably a bug. 

And please return EFI_ABORTED rather than EFI_TIMEOUT - probably doesn't
matter in practice but I'd like to avoid introducing more EFI return codes
in the runtime context that the spec mentions only for boot services stuff.

