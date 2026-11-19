Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.143
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049753;
	b=yEzAklWOCbKSK19pl7ohX0XYXAW0MXSrLa99IRSDOfIG0zesp2Dkkp3vR1+OGKVtLwYx
	 ChKaXc52PgXtaKRJZ+UAXcS8EfHb6PC6GRK3NFBv2e9vBS9Idg+9BRLBJObyKrp2+UJJD
	 qENEHVPhmqTC46gXRQFMUJ/7XkTGyzCJpej+eqqmc1poIVRd/5FV7rQs50uAmySkNY5nh
	 lw98EdSBjc99BK0W63XmxtKig95LpZpsEgNDKgMV8iY46gEmwJHfUhstdhvvYUOVSkU25
	 jSR9y2aN+6ImsfyhwlzhUvICKvkFM+G+wHd1kuWZ/HQ2RsNWS/yzI9D333WF17vAjBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049753;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=4dHYGiMp2OgqgXTFuwal6qZwY9wfxwgje5xp+LeFzJk=;
	b=If3l1YfkgG+SMTB6Uw0i/g+yzJ6uKqyXCBJvyiU5cFLzwFjMn/a/5cFw/ox7/zj1UUkM
	 jIZX/asKTkgAgc6XAWmjKibBccPvfMOBKqcTyd3x5VFXyMN54BRJcErkfbypErg6YbuwR
	 PSxU5XNhmk1XjQJMFFfawPiaxx72bBgIyE6xY4s7DJY67WLYbDgW1ZVIQTG0Vi4u75gV8
	 rdgGBClUkMQL8ykZapjOfmXrVMpmc7tAnGIfnAqJQ03v+1Pv2hGdCDRvCeAVBOQSzp5VT
	 3QMReUkQK2wWFJBTNuc/heuGf5Nf6lF+gt4kHIW/27GpHXxkaMXBiFiTQvqRnb04WDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="N+9ECN/Q";
	arc=none smtp.remote-ip=91.218.175.143
Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C1B606A320
	for <linux-efi@vger.kernel.org>; Thu, 19 Nov 2026 00:55:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55C1B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=N+9ECN/Q
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=B3Z6dHpZXWGm8x4mbBfqqfsDLhaP9HByrFnyDFGFCWQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795049750; v=1; x=1795654550;
 b=N+9ECN/QOZkBtJQ9sF/Gk6XwPMe1bQ/LHcXR877xF9UOIZV2UJlzHrhpVLC1HQg+wLR7g0Z/
 UE/Q6h0j21IF00WBDs+WZVbLTC/RRss2SDSACVd+BtbSHAx+I6UPs1EVBMSFt+QjnwrD7x/tUR+
 VfaK/v5lZ7XSeC8anScN24rU=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cb9fd8956d227ef5;
	Thu, 19 Nov 2026 00:55:46 +0000
X-Mizu-Trace-ID: cb9fd8956d227ef5
X-Migadu-Flow: FLOW_OUT
Message-ID: <367c45f0-8288-44a2-96b2-d804d1cd1553@linux.dev>
Date: Wed, 18 Nov 2026 16:55:43 -0800
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] firmware: efi: add a separate timeout for UpdateCapsule()
To: Ard Biesheuvel <ardb@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Breno Leitao <leitao@debian.org>, "sami.mujawar@arm.com"
 <Sami.Mujawar@arm.com>
References: <20260903113238.2291844-1-yeoreum.yun@arm.com>
 <960e985e-b338-4648-a29b-1f8a31e00599@app.fastmail.com>
 <apl_29t7Jxr2mv9C@e129823.arm.com>
 <44097058-9fdc-4e9f-a277-d63e3876b035@app.fastmail.com>
 <23ce2fb0-1002-409f-bb84-f592db9d0b89@app.fastmail.com>
 <apmFpUvkRBgMdOH2@e129823.arm.com> <aqkGohQYChzkBPZ7@e129823.arm.com>
 <b6602c6e-4c77-4dcf-8683-95b5c8fc4693@app.fastmail.com>
Content-Language: en-US
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <b6602c6e-4c77-4dcf-8683-95b5c8fc4693@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/17/26 5:47 AM, Ard Biesheuvel wrote:
> On Tue, 15 Sep 2026, at 10:49, Yeoreum Yun wrote:
>>>> On Thu, 3 Sep 2026, at 16:29, Ard Biesheuvel wrote:
>>>>> On Thu, 3 Sep 2026, at 16:10, Yeoreum Yun wrote:
>>>>>> Hi Ard,
>>>>>>
>>>>>>> Hello Yeoreum Yun,
>>>>>>>
>>>>>>> On Thu, 3 Sep 2026, at 13:32, Yeoreum Yun wrote:
>>>>>>>> On platforms that allows to update firmware in runtime, UpdateCapsule()
>>>>>>>> may immediately write a firmware image to persistent storage.
>>>>>>>> This operation can take longer than EFI_RTS_TIMEOUT.
>>>>>>>>
>>>>>>>> Use a separate timeout for the UpdateCapsule() runtime service. By
>>>>>>>> default, wait indefinitely to avoid interrupting an ongoing firmware
>>>>>>>> update. Administrators may configure an appropriate timeout, in seconds,
>>>>>>>> through /sys/firmware/efi/capsule_update_timeout.
>>>>>>>>
>>>>>>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>>>>>>> ---
>>>>>>>>   drivers/firmware/efi/efi.c              | 41 +++++++++++++++++++++++++
>>>>>>>>   drivers/firmware/efi/runtime-wrappers.c | 14 +++------
>>>>>>>>   include/linux/efi.h                     | 10 ++++++
>>>>>>>>   3 files changed, 55 insertions(+), 10 deletions(-)
>>>>>>>>
>>>>>>> Given that UpdateCapsule() is rarely used these days at runtime, I
>>>>>>> wonder if we should just call it synchronously instead of via the
>>>>>>> EFI workqueue.
>>>>>>>
>>>>>>> I assume that would also solve the timeout issue?
>>>>>> Might be. But it would make *non-preemptible* for UpdateCapsule().
>>>>>> AFAIK the purpose of running runtime service with efi_queue to
>>>>>> run it in indepdent context and to be preemtible in case of arm64.
>>>>>>
>>>>> No.
>>>>>
>>>>>> Since most of UpdateCapsule() will be called via capsule-loader's misc
>>>>>> device, if UpdateCaspule() is called synchronously, It would be
>>>>>> non-preemtible in arm64 platform.
>>>>>>
>>>>>> But, some platform could be preemptible while updating firmware so
>>>>>> I think it would be better that it would be called via EFI workqueue.
>>>>>>
>>>>> EFI runtime service invocations are preemptible on arm64, so this is
>>>>> not a problem.
>>>> Ah wait - you're right, they are only preemptible when invoked from the
>>>> work queue.
>>> Yes. That's why I think it would be better to call via EFI workqueue
>>> when I see arch_efi_call_virt_setup().
>> Hi Ard,
>>
>> Could there be any issues with doing it this way, or would there be
>> a better approach?
>>
> Would it make sense to simply have different limits for UpdateCapsule() and
> for everything else? How much longer than 2 minutes do you need in the
> typical case?
>
>
We are seeing >120 sec timeout for SetVariable as well on Nvidia Grace 
platforms with AMI firmware.

efi: EFI runtime service 7 wedged in firmware; disabling EFI runtime 
services

The SetVariable is called as the last step of firmware upgrade process 
by vthe endor's BIOS update tool (AMI AFU, capsule mode). In this case, 
the firmware is just slow probably due to some bug in firmware.

But I think kernel should allow the timeout to be configurable with 120 
as default. This will allow users to workaround the slow firmware bug by 
extending the timeout temporarily.
