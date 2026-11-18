Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021459;
	b=Kgb0aZDM0JN7KTXdr9UUVtplrCioEOMaOVN/d5yh2Sd7p//GHrXatxElfqjciEuJtlAI
	 oJDXzpSDXdbraCMzqbnUEE+heqF3HV/9+WFPMvpc2rpEBolRtMq07RVxkfHcorReJFj+Z
	 ofzGjmf/WdoQqHa1VBopMFzTqNbfxM951eUS8vMfsTG+m4yrgWraZ+4D7ElGipvfw60iA
	 AGyJjOpUANUtyPjGr5EBF6O0Jh+mU4yghMzo8brKAk2Oz5sBLorevrcgPFrygC65PDLkG
	 OgHa/ar4d65ZAaQ6uHFkPTQNU83XtmKNSX/CxzByGw80oLxfyVFTHV+v3pwmCIBFQig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021459;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Date:From:To:CC:
	 Subject:User-Agent:In-Reply-To:References:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=cYB7uYUwT4BNXsxiCkMX24sYK4BGcJP0bUAR1rrEl8s=;
	b=iql8qVbjRfGCQYBtRI5X+1ZlK3Inv1gItZOOZcJLUSQyxljwXQ38F/xLpNlnExXz2IAk
	 4j1uSUHoxtiLBoFNp47OBNr38o+punhHQprvCnhLl6Q8lPDKde9ws1mkItxNVTtSM/ll7
	 KdCU0hcPvNh1rCpqOjiGVka9O2MvrhCgP8J27pBQ4u8/4m8gr63R3hDTyI6ipgEu+A1DY
	 23ALPR/Yzn2Tp5v6J0WwyDXHqHUbiJDlUjOhtgmdtLAVszAbV4tVWGu4CS2Y/9DinpxKE
	 vfuxD7/QcN1vVY9gmQ8T/K85PZcll4a0w+oREpu8NQkr7zoFKEzhg3N4Jxos+xolMXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zytor.com;
	spf=pass smtp.mailfrom=zytor.com;
	dkim=pass header.d=zytor.com header.i=@zytor.com header.a=rsa-sha256 header.s=2026102901 header.b=BkRfgeli;
	arc=none smtp.remote-ip=198.137.202.136
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED66860A263F;
	Wed, 18 Nov 2026 17:04:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED66860A263F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zytor.com header.i=@zytor.com header.a=rsa-sha256 header.s=2026102901 header.b=BkRfgeli
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6AIH4DRx3411402
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 18 Nov 2026 09:04:14 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6AIH4DRx3411402
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026102901; t=1795021454;
	bh=cYB7uYUwT4BNXsxiCkMX24sYK4BGcJP0bUAR1rrEl8s=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=BkRfgeliodgvVNGjsHnVCmEgZiTq1tvZhksL/IF90Wr4kjIPw4c0VkewKBsSN9Ebg
	 gwQjT2A2G2K4jCH+TDsNVTkjzShcHUoK4T460PHCddWoMIqPnI5GR5covODEQA1xrJ
	 v0Ipn4SdJTHpgiyf1x6V868cyyebPYk0l11EKLW9eNVvP130c9AzyvhwdaBJ7rFPND
	 /V7b3hjaT0SZlowRgsA0t4kG9A4wmJ6aT4YBsppkt7yvGkV5SagC4EdPtdmEPCKkdl
	 ls2DwjZsbKRcmB3fq9lRJPzjknfuX+lDWFkhK/6lHmMkZrlZd1utwAXKBNpwDNKvYd
	 6sBqly2POh9gg==
Date: Wed, 18 Nov 2026 09:04:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Ard Biesheuvel <ardb@kernel.org>, Ard Biesheuvel <ardb+git@google.com>,
        x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_x86=3A_Make_the_64-bit_bz?=
 =?US-ASCII?Q?Image_always_physically_relocatable?=
User-Agent: K-9 Mail for Android
In-Reply-To: <ab8628ec-9476-4f3c-80fc-b68556803002@app.fastmail.com>
References: <20261111091843.3621782-2-ardb+git@google.com> <FD1A5979-1504-4A96-B26C-D89BD362170A@zytor.com> <3522588c-9d7a-454b-afe8-c16c6788265a@app.fastmail.com> <F6E708AE-0476-4E9A-A39D-3DF15E91EB80@zytor.com> <ab8628ec-9476-4f3c-80fc-b68556803002@app.fastmail.com>
Message-ID: <5E2684EC-0F34-4008-B043-F912FA1AAE6C@zytor.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On November 18, 2026 8:55:11 AM PST, Ard Biesheuvel <ardb@kernel=2Eorg> wro=
te:
>
>
>On Wed, 18 Nov 2026, at 17:29, H=2E Peter Anvin wrote:
>> On November 18, 2026 8:18:44 AM PST, Ard Biesheuvel <ardb@kernel=2Eorg>=
 wrote:
>>>
>>>
>>>On Wed, 18 Nov 2026, at 16:51, H=2E Peter Anvin wrote:
>>>> On November 11, 2026 1:18:44 AM PST, Ard Biesheuvel <ardb+git@google=
=2Ecom> wrote:
>>>>>From: Ard Biesheuvel <ardb@kernel=2Eorg>
>>>>>
>>>>>On x86_64, the physical placement of the kernel is independent from i=
ts
>>>>>mapping in the 'High Kernel Mapping' range=2E This means that even a
>>>>>position dependent kernel built without boot-time relocation support =
can
>>>>>run from any suitably aligned physical address, and there is no need =
to
>>>>>make this behavior dependent on whether or not the kernel is virtuall=
y
>>>>>relocatable=2E
>>>>>
>>>>>On i386, the situation is different, given that the physical and virt=
ual
>>>>>load offsets must be equal, and so only a relocatable kernel can be
>>>>>loaded at a physical address that deviates from its build-time defaul=
t=2E
>>>>>
>>>>>Clarify this in Kconfig and in the code, and advertise the 64-bit
>>>>>bzImage as loadable at any physical offset regardless of whether
>>>>>CONFIG_RELOCATABLE is set=2E In practice, this makes little differenc=
e,
>>>>>given that it defaults to 'y' and is a prerequisite for EFI_STUB and
>>>>>RANDOMIZE_BASE, but it will help with some future refactoring of the
>>>>>relocation code=2E
>>>>>
>>>>>Signed-off-by: Ard Biesheuvel <ardb@kernel=2Eorg>
>>>>>---
>>>>> arch/x86/Kconfig                   | 40 ++++++++++++++++++----------=
--
>>>>> arch/x86/boot/compressed/head_64=2ES |  4 ---
>>>>> arch/x86/boot/compressed/misc=2Ec    |  8 +++---
>>>>> arch/x86/boot/header=2ES             |  8 ++----
>>>>> 4 files changed, 29 insertions(+), 31 deletions(-)
>>>>>
>=2E=2E=2E
>> I'm going to vote NAK on this one=2E=2E=2E I was already thinking that =
it=20
>> would mess up low-level debugging too much,
>
>How so? The last time I proposed this, you replied that you were
>planning to do this yourself=2E
>
>https://lore=2Ekernel=2Eorg/all/3f2e8d7c-6029-49ef-8e31-a3eb5efb385b@zyto=
r=2Ecom/
>

If we are going to get rid of it, we should get rid of it properly as in r=
emoving the conditional machinery, not use it as a backdoor for doing somet=
hing explicitly NAKed (forcing PIC compilation=2E)

What you are proposing is literally the exact opposite=2E
