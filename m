Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF85503BC3;
	Thu, 17 Sep 2026 12:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649291; cv=none; b=hREoSM8kOCZpghsSzXsliO8NK//aEjQWVKK49RSWPhKNp9ghOY4370vy/lWhQa2KYKa1obDNGbGjf0DpcZUsSOEqmU4b4aP/QhoOV0zZFlYfHMkF3w7w1WDGwYZNSA9DqrKWJKPKUmL6vNPyPZh3B48ioefNWFk2T8jnsK2vwYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649291; c=relaxed/simple;
	bh=NMgg80kClZTR3rqRl6aY4igBdyi4THxTY7KHZXOIStE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=ic7PDbK0wpngPIBBhbe/XMKyvB4CzgVTbvMuhBvgxs82F5YIIioHrtQ1w6tRCGPVVSqlZIvgfvIL5i+eN6gZRg9CgfbVsNzLiuDKZwVkG6meEw5bo6Jlpd3TGn/jOGNFdsm9M6DAKSWsTZGi89DooB9XAUtZzhQ51+aXx/Z8bVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KocQVZC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KocQVZC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2050A1F00898;
	Thu, 17 Sep 2026 12:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649278;
	bh=2upxzb5/gZsb1Rha3aM8fbRCAT+zsZRzcObIyULwoMo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=KocQVZC6B1sNGak/+O+8jS+SsIxfP2VIfVj2AzKB6Zasyn5T8E4bMdYCJ8xt0E+Bf
	 0FR20ABdgDVabHzcPDteuQKtJCCuCftni1oxLcdMN7/igOVmdlEK4UMMcD84gzgI6H
	 7nhMg6iu1c86qBCdg91SIJNplgdqo6/2hkuGgjO2PocoGDVPZtixj2AmAfFhGilwue
	 6Id+df5q0IeIMdLkzqT4O2VzOgVQ0i/5XAy3v62nLgts3RkyR9rCvsnDw2HByegOA4
	 OSQrk2UdgEREvvAL/K8UBpIl/N4+SHmkjMgj1aEsILsdG3v/GW5QQOMND2HIec5TQ1
	 vtYW7J+5ZJtmg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 86E43198006B;
	Thu, 17 Sep 2026 08:47:56 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 17 Sep 2026 08:47:56 -0400
X-ME-Sender: <xms:euGraoBNnKL1PpuZ9hDA1_zOU6XvfrfaoIG2zVBVMPSJAd6JwsG3Tg>
    <xme:euGralXTvPdLr1KXbPsy61Nv4AFVgub20QYEP0enVG1Dwyzl_RYU_sIw_OY9_NDZg
    mV2zu6I9xkPaZ216kWflDI2r0Z1U61dDLcM6IEM1ZoyutSbGRP74St5>
X-ME-Proxy-Cause: dmFkZTGxw0yxLVpRYmYsRRF+w+9AsjklEfKsqciXRtJIGovkXGEZXnRBW+flkWBmw5+38G
    u+XSJhXx8zOP2hp1kr4wK2cZsY2kiPa9KJTt60C97Nj3MNdMvMSYxy1MyNCDZYpelLymXB
    PVH3/N4SVDBs5d9qYVz0X3D0cnrFkDh9YMxm8W+V0v4xcKKSbNVaEh5mqsXJftIZURFG3D
    6bRgxAAdPsLJ/wDQ8YcKMUhHaKDDRFYdgzFL5wu0/sLy1B0Tr2DUo5g+3OTEr9cN/Ri8zB
    WWE5RG53bLoZXKnA8s4xH9gTUTjs5Ise3KOVtmdKl6SXODFy6BIz5Q7kvmXZO4GnLUOOrN
    XLFHhLbZ4mk1aN+bT/Mg/+ODCK6NMMeT4MJGtAWYg6e6aEDxzbiEUYi262uOGNeQU3IjIp
    HQLCUfmVuOfDzWEK0pdhbGTZ3VFZyW9uawqTjs5vRSKfW8ls6jM7ik8LWyZ03SWqz70cmT
    XNgRozb40cymhf1bdfjeJgAo2ZbJV9GWnrwVgvwIA1QX/Oz810/D8UdL+aVFVybjRZimWL
    41LaIpYQ91DR6XkkistvJqmK4wTcdXOk1XnscbIIH0FHZra0ctCAPR7Q9XfTPRY/eMx6hC
    4S1lSkfKrYhs81BIpb4QMq/99B+7ZrdtLPWmDKVhE5RwlD5vks8WXAE0nRpg
X-ME-Proxy: <xmx:fOGrauBIcbnh3elH2t9_GzfOULi3fXi2Y4nW7g8IS2QlmFDOr96yfQ>
    <xmx:fOGrajdmZbom6bQcQahUpI6Y_UVWlL0QBsx7jdOXxKvA67K4LH_znw>
    <xmx:fOGraglmvnGz3omrlWejwtyUCTbR2wSNYbqnc_iB70NnD-7YwWzn_w>
    <xmx:fOGraiGM11qvRUgyJ5yt5rQYJh64eEGvdKk8TyBJ_2Qpn9lpX18Dlg>
    <xmx:fOGrag4sXA0MfMa-Dmo4F8waQc51zXPDUxRMxnem6HOrSkCyHJl-oraR>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id D359FF8007E; Thu, 17 Sep 2026 08:47:54 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 17 Sep 2026 14:47:34 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Breno Leitao" <leitao@debian.org>,
 "sami.mujawar@arm.com" <Sami.Mujawar@arm.com>
Message-Id: <b6602c6e-4c77-4dcf-8683-95b5c8fc4693@app.fastmail.com>
In-Reply-To: <aqkGohQYChzkBPZ7@e129823.arm.com>
References: <20260903113238.2291844-1-yeoreum.yun@arm.com>
 <960e985e-b338-4648-a29b-1f8a31e00599@app.fastmail.com>
 <apl_29t7Jxr2mv9C@e129823.arm.com>
 <44097058-9fdc-4e9f-a277-d63e3876b035@app.fastmail.com>
 <23ce2fb0-1002-409f-bb84-f592db9d0b89@app.fastmail.com>
 <apmFpUvkRBgMdOH2@e129823.arm.com> <aqkGohQYChzkBPZ7@e129823.arm.com>
Subject: Re: [PATCH] firmware: efi: add a separate timeout for UpdateCapsule()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Tue, 15 Sep 2026, at 10:49, Yeoreum Yun wrote:
>> > On Thu, 3 Sep 2026, at 16:29, Ard Biesheuvel wrote:
>> > > On Thu, 3 Sep 2026, at 16:10, Yeoreum Yun wrote:
>> > >> Hi Ard,
>> > >>
>> > >>> Hello Yeoreum Yun,
>> > >>> 
>> > >>> On Thu, 3 Sep 2026, at 13:32, Yeoreum Yun wrote:
>> > >>> > On platforms that allows to update firmware in runtime, UpdateCapsule()
>> > >>> > may immediately write a firmware image to persistent storage.
>> > >>> > This operation can take longer than EFI_RTS_TIMEOUT.
>> > >>> >
>> > >>> > Use a separate timeout for the UpdateCapsule() runtime service. By
>> > >>> > default, wait indefinitely to avoid interrupting an ongoing firmware
>> > >>> > update. Administrators may configure an appropriate timeout, in seconds,
>> > >>> > through /sys/firmware/efi/capsule_update_timeout.
>> > >>> >
>> > >>> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>> > >>> > ---
>> > >>> >  drivers/firmware/efi/efi.c              | 41 +++++++++++++++++++++++++
>> > >>> >  drivers/firmware/efi/runtime-wrappers.c | 14 +++------
>> > >>> >  include/linux/efi.h                     | 10 ++++++
>> > >>> >  3 files changed, 55 insertions(+), 10 deletions(-)
>> > >>> >
>> > >>> 
>> > >>> Given that UpdateCapsule() is rarely used these days at runtime, I
>> > >>> wonder if we should just call it synchronously instead of via the
>> > >>> EFI workqueue.
>> > >>> 
>> > >>> I assume that would also solve the timeout issue?
>> > >>
>> > >> Might be. But it would make *non-preemptible* for UpdateCapsule().
>> > >> AFAIK the purpose of running runtime service with efi_queue to
>> > >> run it in indepdent context and to be preemtible in case of arm64.
>> > >>
>> > >
>> > > No.
>> > >
>> > >> Since most of UpdateCapsule() will be called via capsule-loader's misc
>> > >> device, if UpdateCaspule() is called synchronously, It would be
>> > >> non-preemtible in arm64 platform.
>> > >>
>> > >> But, some platform could be preemptible while updating firmware so
>> > >> I think it would be better that it would be called via EFI workqueue.
>> > >>
>> > >
>> > > EFI runtime service invocations are preemptible on arm64, so this is
>> > > not a problem.
>> > 
>> > Ah wait - you're right, they are only preemptible when invoked from the
>> > work queue.
>> 
>> Yes. That's why I think it would be better to call via EFI workqueue
>> when I see arch_efi_call_virt_setup().
>
> Hi Ard,
>
> Could there be any issues with doing it this way, or would there be
> a better approach?
>

Would it make sense to simply have different limits for UpdateCapsule() and
for everything else? How much longer than 2 minutes do you need in the
typical case?



