Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005623C7697
	for <linux-efi@vger.kernel.org>; Thu, 11 Jun 2026 10:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781175494; cv=none; b=A0jrdYsALqSvfErNLwPPDekooxxngJ5t0KExSTfsGqmhVXSovNjYoSPgt/qE0mGMPACyvyq/+ZInO2gRLzuDtnWllewA5UhlxbXMkHi1e08P4Vfkpimyvf1ygRUfXW5sGeF67IgIRr6aRzDBOWN5Z5KW5WzLdlx+wRTxSSYiL2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781175494; c=relaxed/simple;
	bh=Ud2TaFqVHVwcHzi7uesTh79xH30kJPxjFLSUBItuxEs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=PtM7S+tcpIU3wGGgphgNvo8xZK+pNpX4zLr1flZOOZkIVI+0ingNwksAXcjt9ozFzfJWugxJvZa1TEpMj2m1ZtymWXJuIxVL7VfdlL7rHdkWZiGh1wuOM3lCyDBUNr5dzVEFOqOW7CwHiqPFRvWdJ4cOipiARJiWcEHq5CSgVzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Map99WZ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Map99WZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E3B1F00898;
	Thu, 11 Jun 2026 10:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781175491;
	bh=kHoK2w7CDbHJbtv+1Rpc0M6DH2KHkbN7AY+3+gGwBh4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Map99WZ61BMIC5e9EpUYlWxLpRu+oUufZrVwUcS02WqcGJOdRizGuDOckmiKX5yt9
	 HvHZpO2yeNSK8oN8aW4xTJXdFGRiWhcjAU9czFKOxNJEzbzScgKYglq8dIhtYz6XP9
	 vevYB0qZOYI0DIs/1mqJmVORG/rSmsKeZCibINjTSkMdQPWFf5j6RXta/Yr3tqC+Gm
	 AXNIGJVnvSTTRpPXEBaFpRMCn5BRn0TqzhZ0fkJVyNg+oxz0M13/ERUQjPWPjVyZfK
	 bjDv1LTcNXufju6uOSr5Yhwy9K79H3RcQuomgU/+sKXCy8ubZvZyJWevyHBe4u8OLJ
	 jf5GmWw/9Nkvg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9D511F4006D;
	Thu, 11 Jun 2026 06:58:10 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Thu, 11 Jun 2026 06:58:10 -0400
X-ME-Sender: <xms:wpQqamWBlJsrH06ZgAZ4AQfUmB9fMtZhj414-4OkubSuxSkaFQ094A>
    <xme:wpQqatapJmU_EBa98G8CBfryOzdCTnZYT0i4zBfZFFU37hmZAAPsorBNp38Z4TFkf
    ecHy923gEhsUx1xKaOqBlQsHbvTBlDtR8VC23S1tJEsuLDHVoMtvJE>
X-ME-Proxy-Cause: dmFkZTE7sHs2jw7PF661S94muladhHsaHVpLyECVRlHc7iyLdK4Cn1OwmOyGXLDzC/eYYH
    dNcVWcYlSua7CqI9mhKYed75CNKsyDXSVTDh9XZWef/OCMHvwZ1svZqTErp4LdZUgj/4J4
    bsjDEzwBSp3FS1nm2jrw8yG9CHYvTwHwGJj1tj+gWv/L6L96WX7qoGocEv1RuCL19C4zWc
    m1tC3u4O8055/BOkonQiaQDIIp28SouqRx+IEWqNeZGs3V97CHDPe8tFfr9VdsaYDKClgI
    5/SKhcknlFHYd1MjQadx7F2n0peroZjae4Ot2iC0YuDPrOWiSL3UWFX84UUKXOvAsrapG5
    mR23uMxBZbxzTfI4zjBQ5PTM6JtDyEJjpeu6ulC7jwRPDsXZ+wWRd+WECSw3Nq99BHRB2T
    L/9lfGoYIw/KyJ1XNj+jZCQwdG1FxXZPrF3EyCP3zLJks7e2a2wuA5dHYMAZZ0FcK6YbM/
    q/fHrycFJu9KmbI/TV87buPHR/arYGDamj1VVL+DlxgV9XMFuM6XGqaYiDfH4BmbwXc6Hd
    xpH9Ycl8NeV5/7tzam98BiZxF0m/GUwyU8ggrUCCLsibn5fkVGxsokn2DClxspcS2Gbt7v
    1p8cMeFFmzcB5EcTXJKgTya69ZEB9IMV+l5fOwoK2zbZgKi9DHFhtbaQJ/Eg
X-ME-Proxy: <xmx:wpQqaqjyRV-Nxt8g2jJXjTWRVZZTqhjokpTj5S3NRKgqzFu-KBoNHw>
    <xmx:wpQqaj-bp8_1nswdZhdsolWqz4I6AVgkR4ZXUhfSjv7cLca8aRK_Bw>
    <xmx:wpQqatr7JBYG_5AUdyH8ZhuFfSE9ZcxKSP24rVjIXDozhddeNubqLw>
    <xmx:wpQqajVZbtjH1jvJKsI12VzuQWtsSpIoIsyt6thPw5DDxa2R3-ZQCQ>
    <xmx:wpQqakD0wMYMVQS3mQR9_LDQxUHXLU4L4OR7c5weJiFjNtaW4jUti6bT>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7B0691820082; Thu, 11 Jun 2026 06:58:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 11 Jun 2026 12:57:50 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Breno Leitao" <leitao@debian.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Message-Id: <f8c9be21-f15c-4c97-8dfb-de083e07dd32@app.fastmail.com>
In-Reply-To: <71de953a-43e9-4987-8b8e-00d9b99a099e@app.fastmail.com>
References: <20260609-efi_timeout-v1-0-69a896faa805@debian.org>
 <20260609-efi_timeout-v1-1-69a896faa805@debian.org>
 <71de953a-43e9-4987-8b8e-00d9b99a099e@app.fastmail.com>
Subject: Re: [PATCH 1/2] efi/runtime-wrappers: bound the wait for EFI runtime service
 calls
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 11 Jun 2026, at 12:21, Ard Biesheuvel wrote:
> Hi Breno,
>
> On Tue, 9 Jun 2026, at 13:55, Breno Leitao wrote:
>> When an EFI runtime service call hangs in firmware, the kworker on
>> efi_rts_wq is stuck inside the firmware call and cannot be cancelled.
>> The kernel currently waits indefinitely on the completion, and the
>> caller holds efi_runtime_lock for the duration, so every subsequent
>> EFI runtime caller (efivarfs, NVRAM writes, set_wakeup_time, ACPI PRM
>> handlers, ...) is wedged until reboot. The only externally visible
>> symptom is a "workqueue lockup" message and userspace processes piling
>> up uninterruptibly on the semaphore.
>>
>> Replace the indefinite wait_for_completion() in __efi_queue_work()
>> with wait_for_completion_timeout() bounded by EFI_RTS_TIMEOUT
>> (120 seconds). On timeout, log the wedged runtime service id and
>> return EFI_TIMEOUT to the caller.
>>
>> The wedged worker is intentionally leaked - it is still inside
>> firmware and cannot be cancelled - and the shared efi_rts_work is
>> abandoned to it. EFI runtime services become unavailable until reboot;
>> the alternative is permanent userspace hang.
>>
>> This patch should land together with the follow-up that introduces
>> the efi_rts_dead fast-fail flag: between the two, a subsequent
>> __efi_queue_work() caller will re-INIT_WORK() and re-init_completion()
>> on the work_struct and completion that the leaked worker still owns,
>> which can corrupt workqueue state and let the next caller observe
>> the leaked call's status as if it were its own. The split exists for
>> review clarity; reviewers may prefer to squash.
>>
>> Known limitation: the union efi_rts_args that __efi_queue_work() hands
>> to the worker contains pointers into the caller's stack frame (the
>> compound literal in efi_queue_work() and the in/out buffers it points
>> to, e.g. *tm in GetTime). Once the caller returns -EIO and unwinds,
>> those slots are reusable. If firmware eventually unblocks and writes
>> to the output buffers after the timeout has fired, the writes land in
>> whatever now occupies that memory. In practice firmware that hangs for
>> more than 120 seconds tends to stay hung. A follow-up bouncing args
>> and output buffers through kmalloc would close this gap.
>>
>> At fleet scale this turns a generic "workqueue lockup" or stalled-task
>> mystery into an unambiguous "EFI firmware is at fault" signal in
>> dmesg.
>>
>> Signed-off-by: Breno Leitao <leitao@debian.org>
>> ---
>>  drivers/firmware/efi/runtime-wrappers.c | 20 +++++++++++++++++---
>>  1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/runtime-wrappers.c 
>> b/drivers/firmware/efi/runtime-wrappers.c
>> index da8d29621644..6ce6d094066e 100644
>> --- a/drivers/firmware/efi/runtime-wrappers.c
>> +++ b/drivers/firmware/efi/runtime-wrappers.c
>> @@ -118,6 +118,14 @@ union efi_rts_args {
>> 
>>  struct efi_runtime_work efi_rts_work;
>> 
>> +/*
>> + * Upper bound on how long we wait for a single EFI runtime service
>> + * call to finish before declaring firmware wedged. Chosen to be longer
>> + * than any plausible legitimate call (including UpdateCapsule on slow
>> + * SPI-NOR) while still bounding userspace wait time.
>> + */
>> +#define EFI_RTS_TIMEOUT		(120 * HZ)
>> +
>>  /*
>>   * efi_queue_work:	Queue EFI runtime service call and wait for completion
>>   * @_rts:		EFI runtime service function identifier
>> @@ -338,10 +346,16 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
>>  	 * queue_work() returns 0 if work was already on queue,
>>  	 * _ideally_ this should never happen.
>>  	 */
>> -	if (queue_work(efi_rts_wq, &efi_rts_work.work))
>> -		wait_for_completion(&efi_rts_work.efi_rts_comp);
>> -	else
>> +	if (!queue_work(efi_rts_wq, &efi_rts_work.work)) {
>>  		pr_err("Failed to queue work to efi_rts_wq.\n");
>> +		goto exit;
>> +	}
>> +
>> +	if (!wait_for_completion_timeout(&efi_rts_work.efi_rts_comp,
>> +					 EFI_RTS_TIMEOUT)) {
>> +		pr_err("EFI runtime service %d wedged in firmware\n", id);
>> +		return EFI_TIMEOUT;
>
> Could we just clear the EFI_RUNTIME_SERVICES bit here right away? That
> way, we probably won't need the second patch (unless I'm mistaken). It
> /should/ also block the calls that are not routed via the workqueue,
> e.g., any EFI pstore calls to the non-blocking SetVariable() variant,
> but I just noticed that we never check EFI_RUNTIME_SERVICES on those
> code paths, which is probably a bug. 
>
> And please return EFI_ABORTED rather than EFI_TIMEOUT - probably doesn't
> matter in practice but I'd like to avoid introducing more EFI return codes
> in the runtime context that the spec mentions only for boot services stuff.

Also, could we prevent the kthread that runs the workqueue from being scheduled
again if we decide that the runtime services are wedged? x86 has some logic for
this when a page fault occurs, and I wonder if there is a generic way to do
something similar.

