Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007103C9EFC;
	Fri,  4 Sep 2026 16:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788539945; cv=none; b=eSDyRYPbhXXxeajj8uuZPjcW8qwtBvLbsXe+N+knLvkJw3M5qVxfNJ77eiuAQLq6Jlb1+eAWJyFlX31keLfqam2eGy8AL3Y5Yon33M4IRxmynbVyWMv6C5bPHw/wJFXAiAF8HlRTba4yG+c56/nTUE8IT5phjPO4hm2+7wSRxHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788539945; c=relaxed/simple;
	bh=4876m8Xl7xznP9hT7yoe2KXPjmR8y0rw4lMySnl4J9A=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=LbQ+3tpxuj5isw6TovQwJdCiuxZ38Sn/Ic/5eWBf8Oh+T/3ftOkpwbuIT5+tIQ1tyetGB7X5/r3u4VU7xzs3za3hLb8ABnffdmGqoVPVjnsoKw81mmKXSpJw67orr6gMjGsY5ZPLkL/aVL7HE63vqr0qxPYVMURg3T9jYQIDN64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EvRV3AtF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EvRV3AtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F031F00A3F;
	Fri,  4 Sep 2026 16:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788539943;
	bh=EyhTNaHTKv5y3Fw7p2rkhVoV+Cwe5qw9RLK1+iJouWg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=EvRV3AtF4i3OalyUd4hCY56id+AfhtzUHvjVJ8QfOHHYBc/B0BLXOoUK1dcZ7x/HG
	 bCioueFTujZY+knRr4w/7wH6JCo1ZayQqpFgEvwBskmDDQFSMlpAAI4BqZRvADFb+j
	 mXcuWhAFlZV9fOHa3XzREweEjUCLbzlO4QTQuijNhokuNnRVz+utkw7dthrTR3FK8K
	 GvudxqSlEz64QFDHhyGbqJK3oGO8OfWar8+6nrZOGbTjmUTmTa6wuZIlOB/eChGOE4
	 2Mfjxx+11A5CCCGVIzbuLinbjihxxi6WpgWqZpJRhxHHK8u9KkEbxV4kYSXpHCgO0T
	 tmma5yfM5no9w==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3B895198003A;
	Fri,  4 Sep 2026 12:39:01 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 04 Sep 2026 12:39:01 -0400
X-ME-Sender: <xms:I_SaasEnPC41iFI8dUUbRNoRKNWiI0wmnaQcx7tnXuJ7S1YOPiLMmQ>
    <xme:I_SaagInz5ooD4cLOU5zDZHFyHbwP8LHAkzXu1axHaVmboCxB5tg2wcwLeUx7cdQ2
    2p2Zc6uHm9CVHDP4R9ahv94mjaa76Rq_kI1Z7ROeetwDTvimBGBOqM>
X-ME-Proxy-Cause: dmFkZTFIgSrUni/4Jij77moSSof9PkQsBCUenuutrcqQiD7+F4oTGMrDD41jgH5hUVzC8X
    yHZB5ripv1hZ5q/CqMyhpcSe1YFln/zjEx3EOglbIKUnQAxf1NR9wjYpzt0SCBxcFQ0s1S
    R4mD3h7eY1oKJzx1WMfn/3hS73s9lU3DpHG9P7Jl08qhuYrHZrCizYQEKWcgXB+Ks1vG5b
    w5r3DOeD0XGLHv7TRJJwGU/OQBBIYimG/GupGNG4X6uMB7ruMfibATevXhQ93xo2fIiWcE
    wrq7Y2shUtgzdGcsQL2xTDPcdlAErXLUPtTPfLnVSnIJPoTal36wUh44NRnoip6aKH3IkV
    +rMs4PEGmaGq+uxsDILJ21aja+xMehEr/+kzATJARMg8yzWmbqxr4VF5rj8cE45lsiJhUB
    iVfpeUYF8FJj7Kx54JyyAeqsaETC2ySTkXsrtePGhYdsGksMIa2JeIrvoltriSANG48sFu
    ZzHug5ljaEdyFnUm35iQOcrYP7lxb7CvPUbCQl/SRgFqYZdyc2PXC4JIIfKbjb3AKUZiXs
    V5aMNtNkzF6BNWZVlw1bULEq25zdJbvVwOleRq+F2PtdeCehE3VylgdOLCwAHOumhhOPnJ
    401XJSmPaS6SZmwf1oG2exYSMqSVtwJKjxXvdcPiYlTq11K/5clInkNtlsAg
X-ME-Proxy: <xmx:JfSaak22pDS6n1KxtzcGZOF12dr7QWE_-2rB4luTt2t7LsbZy8wqYg>
    <xmx:JfSaahqtmm1BpVgSsrR6Q3HVjMhToYD95Xb0Zgi0hRKKYS0pSk7rFw>
    <xmx:JfSaagjldklgNToSg2aRfybJlQdljul3slgNFay8JRWetHdBMW_lOA>
    <xmx:JfSaat9pUTpfIuMMZrJ4EQPc1PIzUY0IFRPtJZsumhK755-bfQB3Gg>
    <xmx:JfSaasWd3HYP7im-5lmH558VDz3vcj-FR1COgGmJVjyp-Zq_8q3BycUc>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id BC4BDF8007A; Fri,  4 Sep 2026 12:38:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 04 Sep 2026 18:38:28 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
 linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, x86@kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <c3ca811b-a6eb-4f4d-bbb2-4feef02e3db2@app.fastmail.com>
In-Reply-To: <DL6NCV1KQ9F9.6K6XZQCS4AF3@gmail.com>
References: <cover.1788259938.git.jasmeet.bhatia.us@gmail.com>
 <a9e23066-aa75-44be-ac3b-9a15f4cf6047@app.fastmail.com>
 <DL6NCV1KQ9F9.6K6XZQCS4AF3@gmail.com>
Subject: Re: [PATCH v1 0/2] efi/tpm: Preserve event log without changing x86 E820
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 4 Sep 2026, at 17:45, Jasmeet (Jazz) Bhatia wrote:
> On Thu Sep 3, 2026 at 7:18 AM PDT, Ard Biesheuvel wrote:
>> Hi Jazz,
>>
>> On Tue, 1 Sep 2026, at 13:34, Jasmeet (Jazz) Bhatia wrote:
>>> The EFI stub currently allocates the TPM event log as
>>> EFI_ACPI_RECLAIM_MEMORY. On x86, this becomes an ACPI data entry
>>> in the E820 map.
>>>
>>> On a Framework Laptop 16 (AMD Ryzen AI 300 Series), the EFI allocator
>>> can place this allocation at different physical addresses across boots.
>>> Since x86 hibernation validates architecture-specific data from
>>> the firmware E820 map, this causes an otherwise valid hibernation image
>>> to be rejected on resume with the following error:
>>>
>>>   Hibernate inconsistent memory map detected!
>>>   PM: hibernation: Image mismatch: architecture specific data
>>>
>>> Allocating the event log as EFI_LOADER_DATA avoids changing the E820
>>> map, but doing that alone would regress the kexec corruption issue fixed
>>> by commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event
>>> log to avoid corruption").
>>>
>>
>> As I replied in the other thread, I am not convinced preserving the TPM
>> event log across a kexec makes sense to begin with. This is the firmware's
>> view of the state of the TPM PCRs when it handed over the system to the
>> first OS.
>>
>> If the first OS boots, loads a kexec kernel and then boots it without
>> measuring any of that into the TPM, the TPM event log will match the
>> TPM state, but this is meaningless because of the missing measurements,
>> and the attestation chain is broken.
>>
>> If the first OS does perform TPM measurements, it would need to record
>> them into a log and pass that on to the kexec'ed in some implementation
>> specific way - it cannot use the existing TPM event log for that.
>>
>> TL;DR perhaps we should just discard the TPM event log reference from
>> the EFI config tables after consuming it. Or add a special case to the
>> kexec code to disregard it.
> Ok, honestly that makes a lot of sense I see what you are saying and I
> tend to agree. I'm treating the copied event log at something that
> survives kexec in this patch because of the corruption fix so I'll look
> at dropping that LINUX_EFI_TPM_EVENT_LOG_GUID reference and rewrite this
> patch. Hopefully, that will avoid that x86 E820 instability as well.
>
> Appreciate the guidance!

Please don't send any patches yet - I'd like to get some input from other
folks as well.

