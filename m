Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47768368D5E;
	Fri, 12 Jun 2026 10:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258740; cv=none; b=A/F158pmOHjF9fUUzNA2JoYzoPI+u0yrW9gDmtBnf05PBV/XAf19GFylJ9LyxKTY+PVeTrJv6qHxKi59rqqe4QgWQA5bEAWZDgA2fr8jpjaQdrGX7SR8fU5X2IQ+/gu5hXw3c5nYGEbMt79qJvm4HF9qJ5Z5jMyxQojo2irPKFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258740; c=relaxed/simple;
	bh=h06qz2sGCc4ofNHKh4/Aa/PDOVMaNRea1IuHYxcrSFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FUimDx9l4SMZOdBYbHjJyWRD/C1n1cusA7nNbN44leJghc2jM2mc0af5LopMKwDKOoKKJUZyHYdtBkPxFF4DpElD8rjsa2BtPXYoWpHnhrp6IbVJv2pw7dNPRHfOdjYPOWT/2EYMQXAHW2RZ4jN2Atz1paWRDi1lq+1LNgu/wvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=XPDpVTgD; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="XPDpVTgD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9qvkEheN47AKR0CRd/jP2t4ON3uW/ZXHQeho9SD3Z2M=; b=XPDpVTgDCKnxSLAAuplP6Ebsfy
	soNkN6Gvug9te5r2+qp8/JkyEECUi5h9RByjAA5TcHeZfYk555OZ0PuGMwczK3Jzym+AXVh7N24Bp
	sqIZuDxHVXsXT18kCQgXYexcJLhmkB5YuMNM3MUY8yivW3nbuusRQ1Pr5xHnl8200xcA5tF3IUmev
	5sb7q1mG4pcBuPRlk6fuUXe0kH4WRfgr/O5qz9yR8sHymDKDiYX76FNIhAmtLxft2UmAck+nOlzSw
	A9P9My3t5WlmT+zdp/TnbGNOwuwczckaImIJIs9XI9eQLejrjz3dLZLy6EiZr0kcwm4rZhttHmvOK
	wpALD6oA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXylZ-00AefI-2n;
	Fri, 12 Jun 2026 10:05:34 +0000
Date: Fri, 12 Jun 2026 03:05:29 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] efi/runtime-wrappers: bound the wait for EFI runtime
 service calls
Message-ID: <aivZN29oru1TWOvu@gmail.com>
References: <20260609-efi_timeout-v1-0-69a896faa805@debian.org>
 <20260609-efi_timeout-v1-1-69a896faa805@debian.org>
 <71de953a-43e9-4987-8b8e-00d9b99a099e@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71de953a-43e9-4987-8b8e-00d9b99a099e@app.fastmail.com>
X-Debian-User: leitao

On Thu, Jun 11, 2026 at 12:21:42PM +0200, Ard Biesheuvel wrote:
> Hi Breno,
> 
> On Tue, 9 Jun 2026, at 13:55, Breno Leitao wrote:
> > When an EFI runtime service call hangs in firmware, the kworker on
> > efi_rts_wq is stuck inside the firmware call and cannot be cancelled.
> > The kernel currently waits indefinitely on the completion, and the
> > caller holds efi_runtime_lock for the duration, so every subsequent
> > EFI runtime caller (efivarfs, NVRAM writes, set_wakeup_time, ACPI PRM
> > handlers, ...) is wedged until reboot. The only externally visible
> > symptom is a "workqueue lockup" message and userspace processes piling
> > up uninterruptibly on the semaphore.
> >
> > Replace the indefinite wait_for_completion() in __efi_queue_work()
> > with wait_for_completion_timeout() bounded by EFI_RTS_TIMEOUT
> > (120 seconds). On timeout, log the wedged runtime service id and
> > return EFI_TIMEOUT to the caller.
> >
> > The wedged worker is intentionally leaked - it is still inside
> > firmware and cannot be cancelled - and the shared efi_rts_work is
> > abandoned to it. EFI runtime services become unavailable until reboot;
> > the alternative is permanent userspace hang.
> >
> > This patch should land together with the follow-up that introduces
> > the efi_rts_dead fast-fail flag: between the two, a subsequent
> > __efi_queue_work() caller will re-INIT_WORK() and re-init_completion()
> > on the work_struct and completion that the leaked worker still owns,
> > which can corrupt workqueue state and let the next caller observe
> > the leaked call's status as if it were its own. The split exists for
> > review clarity; reviewers may prefer to squash.
> >
> > Known limitation: the union efi_rts_args that __efi_queue_work() hands
> > to the worker contains pointers into the caller's stack frame (the
> > compound literal in efi_queue_work() and the in/out buffers it points
> > to, e.g. *tm in GetTime). Once the caller returns -EIO and unwinds,
> > those slots are reusable. If firmware eventually unblocks and writes
> > to the output buffers after the timeout has fired, the writes land in
> > whatever now occupies that memory. In practice firmware that hangs for
> > more than 120 seconds tends to stay hung. A follow-up bouncing args
> > and output buffers through kmalloc would close this gap.
> >
> > At fleet scale this turns a generic "workqueue lockup" or stalled-task
> > mystery into an unambiguous "EFI firmware is at fault" signal in
> > dmesg.
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  drivers/firmware/efi/runtime-wrappers.c | 20 +++++++++++++++++---
> >  1 file changed, 17 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/firmware/efi/runtime-wrappers.c 
> > b/drivers/firmware/efi/runtime-wrappers.c
> > index da8d29621644..6ce6d094066e 100644
> > --- a/drivers/firmware/efi/runtime-wrappers.c
> > +++ b/drivers/firmware/efi/runtime-wrappers.c
> > @@ -118,6 +118,14 @@ union efi_rts_args {
> > 
> >  struct efi_runtime_work efi_rts_work;
> > 
> > +/*
> > + * Upper bound on how long we wait for a single EFI runtime service
> > + * call to finish before declaring firmware wedged. Chosen to be longer
> > + * than any plausible legitimate call (including UpdateCapsule on slow
> > + * SPI-NOR) while still bounding userspace wait time.
> > + */
> > +#define EFI_RTS_TIMEOUT		(120 * HZ)
> > +
> >  /*
> >   * efi_queue_work:	Queue EFI runtime service call and wait for completion
> >   * @_rts:		EFI runtime service function identifier
> > @@ -338,10 +346,16 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
> >  	 * queue_work() returns 0 if work was already on queue,
> >  	 * _ideally_ this should never happen.
> >  	 */
> > -	if (queue_work(efi_rts_wq, &efi_rts_work.work))
> > -		wait_for_completion(&efi_rts_work.efi_rts_comp);
> > -	else
> > +	if (!queue_work(efi_rts_wq, &efi_rts_work.work)) {
> >  		pr_err("Failed to queue work to efi_rts_wq.\n");
> > +		goto exit;
> > +	}
> > +
> > +	if (!wait_for_completion_timeout(&efi_rts_work.efi_rts_comp,
> > +					 EFI_RTS_TIMEOUT)) {
> > +		pr_err("EFI runtime service %d wedged in firmware\n", id);
> > +		return EFI_TIMEOUT;
> 
> Could we just clear the EFI_RUNTIME_SERVICES bit here right away?

Ack. This is better than createing a new variable. Thanks!

I am planing to move that entry check ahead of the efi_rts_work
assignments (its own small prep patch), Otherwise a post-timeout caller
would overwrite efi_rts_work.efi_rts_id and reset it to EFI_NONE on the
way out.

> It /should/ also block the calls that are not routed via
> the workqueue, e.g., any EFI pstore calls to the non-blocking
> SetVariable() variant, but I just noticed that we never check
> EFI_RUNTIME_SERVICES on those code paths, which is probably a bug. 

Confirmed, fixed as a separate patch: virt_efi_set_variable_nb(),
virt_efi_query_variable_info_nb() and virt_efi_reset_system() now check
efi_enabled(EFI_RUNTIME_SERVICES) before calling firmware.

> And please return EFI_ABORTED rather than EFI_TIMEOUT - probably
> doesn't matter in practice but I'd like to avoid introducing more EFI
> return codes in the runtime context that the spec mentions only for
> boot services stuff.

Ack. The timeout path returns EFI_ABORTED, matching what
efi_recover_from_page_fault() already reports

Thanks for the review,
--breno
