Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FFD2931D9;
	Tue,  1 Sep 2026 07:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788248802; cv=none; b=e4nj+Y8LM04GXw4TEDvy3KeELKnLQMhQfIkBi5+HZTjaIlkW00va1SWd5/Fp1hJ7JFKt6hv+NnN5eHCNdfuYXWKUrwct04IlyzQSmcaQB+TBzrNC8tppgOVqGPpRVvNnaucQHC75vbrOceSgFsHaoluFwSYsYcZcHYFAGpLCNHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788248802; c=relaxed/simple;
	bh=v/An2BC5S8oN8RkfExWXcae0xF52oIum1YsykNv7Tb0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=aexywJ5cFJYLEFlUYUkpsSzRFESGaQq3HGCv6zUiT5uTtFtpZP9IxC0tWg6cctFnqZxdZssLUeOhnzR1m6YXpyYr5YB2NLnUijTLwwUI2O/HTNIl3RhmZYPieiYs8E/kPWAdHDx8p7dmDb6xURQbkk8l28M64vf6PtuOIQTjvAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JcV1y/Hp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JcV1y/Hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCF71F0155A;
	Tue,  1 Sep 2026 07:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788248800;
	bh=tycthEubAVEPDTzKZ89ZW92uoSczdcYfRgozoAn/gcg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=JcV1y/HpE7fnhx8ZQKxJw2Pki5mUdYLn/gBk7n1+//kTzN8FDdB6o+lXkcs3TVwpB
	 0HFGFujJozZM76n4CxtHOr2YS4SAyzTbtlO6rbyR45f/HDBvlinwtepHgVBgaqBAm0
	 BpYv+UoJtaSIQWHZb4BIrUreswFemFliu/CxdPWoB6V/KNG+bveJl53yBG7JbdqD1T
	 L8PcpCrgfFor9oF4o3pTzqPIOx5e54laQFtCRsgDpc74IrpNlMcf9bow0ACConiYl1
	 yh3hkaPx/F0orj4/UpKVgHzDd73JPUkJM+OK+3FcSt0fFEHDeL0QICjbpQHG/nzjNB
	 armZ2M2WP8UxQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id C77A41980047;
	Tue,  1 Sep 2026 03:46:38 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 01 Sep 2026 03:46:38 -0400
X-ME-Sender: <xms:3IKWas-USWresrMBg_PjOEdBx_HUyglt4r0LEguzDwkhzlJL5mk5cw>
    <xme:3IKWavgpaenlWlDWVB7O1hAtAeuS5clTy_HBc-Bi1ah2PIoL5BE7-Tfod_Bh1AJfB
    LS2UzSGJCW5NA8wzHBvvmJScLm0dI8kwttwvEZ5ygS-BMEX_m2rLHk>
X-ME-Proxy-Cause: dmFkZTGdeAAZd7nm8BQbk45gyvcsKSuHH3+WyvCBBHysyzB+JWpO7OakyersasOOFw5t9S
    aUuVlHng9R84S/5OCYhOO+wfvnnhXcJJ2p5Bh2Tn82X5ZmruMpgQwj9Z6sGjYym0dcHLGh
    KkrItYKblSDXQKbIGDMSBAR1y5Z8K249b4ohzJ2NptXTpNoY+Mi7hpBO7OFSlGEN44hl8l
    mxcatjydrVncNWw+WyqcBYlvMtJdgrItIRcqNEzlsuoZ2LrsE25YHuwFhpwDDan4I/p23M
    nLI1GMzO48M7MR5Xo0d2eGNqdUboHxsgiku6fLWrA+eNiced+pk8sLoNGl+BjZxalBC0cr
    iXWZr8nwxqpZulxZgtxL2kAXoH7P7JUspKC1qtDYFclVQKwoJBkVZTWi6oF5bNekU4bRx4
    oMDm0fjSUmMt1g1qOFB+1b8wtWsrsO9J/CbZiQD3+RP2nY7087Zs9PUa72EHtizQah1zui
    YiKomU2yCxxtYkJuXa1y7NtX6MJ9yhX2e1lsxF0XF3hpU6gwMuVBMBZsxNOz7AV6F1e/xb
    LVCmE7rSGLMA2M94inPldXnoQ82R2U5GddkAFd2qxopGjlqtyIgXNQyb7jUv6vctnU/cUR
    vBI4pR/uyEgg1HKqSb/PcHJnGnbg/Baio9fgZ0v53f3NeuKjLP0W+5vz2UQg
X-ME-Proxy: <xmx:3oKWau-0p-UJxzfC5c-r2Qqga0PdhDyGngIJneCSWmj_wvlMjw_bFg>
    <xmx:3oKWarSqFvssmjfZoaI-v0VElUd_zgMIiA35rxPjMni7SnUYXdAKZQ>
    <xmx:3oKWaoefmi8dxYmF7h8P9eBr7JF0wEvzkoFNMApWr8legZpvkEQvYQ>
    <xmx:3oKWatQ3EoNlMekDdaFJPAeqlwoxk2tQxv54eeVPiBgXJxvvtOTpcQ>
    <xmx:3oKWakIVeNiheVTKvvPgoEn1xPBydzwLR5OVd2TYMBk_tP7TOsflqk-Z>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id AC032F8007A; Tue,  1 Sep 2026 03:46:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 01 Sep 2026 09:46:16 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>,
 "Rafael J . Wysocki" <rafael@kernel.org>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Pavel Machek" <pavel@kernel.org>, linux-efi@vger.kernel.org,
 linux-pm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 "Breno Leitao" <leitao@debian.org>
Message-Id: <52b1567c-522a-4e93-a5c4-0a37af688d76@app.fastmail.com>
In-Reply-To: <DL3MNWW4VEBR.K3K6A92WMHUY@gmail.com>
References: <DL3MNWW4VEBR.K3K6A92WMHUY@gmail.com>
Subject: Re: [RFC] efi/tpm: ACPI reclaim event log allocation breaks x86 hibernation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

(cc Breno)

Hi Jazz,

On Tue, 1 Sep 2026, at 04:34, Jasmeet (Jazz) Bhatia wrote:
> Hello,
>
> This is my first mail to the Linux mailing lists, so apologies
> if I've missed any conventions.
>
> I have been investigating a reproducible x86 hibernation resume
> failure and have traced it to the EFI stub's TPM event log allocation.
>
> The system is a Framework Laptop 16 (AMD Ryzen AI 300 Series), using
> Insyde UEFI 2.9 / Framework BIOS 04.01.
>
> On resume, the hibernation image is found, but x86 eventually rejects
> it because the firmware E820 map does not match:
>
>     PM: Image signature found, resuming
>     PM: hibernation: resume from hibernation
>     ...
>     PM: Loading and decompressing image data (4198398 pages)...
>     Hibernate inconsistent memory map detected!
>     PM: hibernation: Image mismatch: architecture specific data
>     PM: Error -1 resuming
>     PM: hibernation: Failed to load image, recovering.
>     PM: hibernation: resume failed (-1)
>
> I compared the E820 map across repeated ordinary boots and found a
> 48 KiB ACPI data region whose address changes from boot to boot. Its
> base always corresponds to the TPMEventLog EFI configuration table
> address (the table pointer is base + 0x18).
>
> For example, across five ordinary boots:
>
>     E820 ACPI data region          TPMEventLog
>     678da000-678e5fff              678da018
>     678db000-678e6fff              678db018
>     678d1000-678dcfff              678d1018
>     678d6000-678e1fff              678d6018
>     678d8000-678e3fff              678d8018
>
> This occurs on normal reboots as well, so it doesn't seem to be
> specific to an S4 firmware path.
>
> drivers/firmware/efi/libstub/tpm.c currently allocates the copied TPM
> event log using EFI_ACPI_RECLAIM_MEMORY:
>
>     status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
>                          sizeof(*log_tbl) + log_size,
>                          (void **)&log_tbl);
>
> As a diagnostic experiment, I changed only the memory type back to
> EFI_LOADER_DATA:
>
> -   status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
> +   status = efi_bs_call(allocate_pool, EFI_LOADER_DATA,
>                          sizeof(*log_tbl) + log_size,
>                          (void **)&log_tbl);
>
> With that change, TPMEventLog continues to move between boots, e.g.
>
>     boot 1: TPMEventLog=0x678d8018
>     boot 2: TPMEventLog=0x678d5018
>
> but the BIOS-e820 entries are identical across those boots. The
> 48 KiB ACPI data island around TPMEventLog is no longer present.
>
> Most importantly, Linux 7.2.0 with only this one-line diagnostic
> change successfully hibernates and resumes, whereas the unmodified
> 7.2.0 kernel fails to resume.
>
> Despite that, I don't think simply reverting to EFI_LOADER_DATA is a
> good fix. Looking back, I noticed commit 77d48d39e991
> ("efistub/tpm: Use ACPI reclaim memory for event log to avoid
> corruption") intentionally moved away from this allocation to prevent
> the TPM event log from appearing as unreserved RAM to an incoming
> kexec kernel.
>

There might be other ways to protect this memory from being clobbered
by kexec.

Or even better, given that both hibernate and kexec invalidate the
TPM attestation trail anyway, perhaps it would be better to simply
find a way for kexec to ignore this table altogether. That way, we
could use EFI_LOADER_DATA for the region, and your issue goes away.

-- 
Ard.


(leaving untrimmed below)

> I tried retaining EFI_LOADER_DATA while registering the TPM log with
> efi_mem_reserve_persistent(). The ordinary memblock reservation
> protects it in the running kernel, and I hoped the persistent EFI
> reservation could provide the kexec protection without changing E820.
>
> On x86, however, efi_mem_reserve_persistent() returned -ENODEV:
>
>     Failed to persistently reserve TPM Event Log: -19
>
> Looking at current mainline, the Linux EFI MEMRESERVE root is installed
> by install_memreserve_table() via efi_stub_common(), while x86 uses its
> own stub path. Current master (abdf623dd) also still allocates the TPM
> event log as EFI_ACPI_RECLAIM_MEMORY.
>
> At this point I'm a little unsure what the correct approach to fixing
> this is, so I would appreciate guidance on where the fix should live.
>
> Should the TPM event log remain EFI_ACPI_RECLAIM_MEMORY and x86
> hibernation account for this Linux-created, boot-dependent E820 entry?
>
> Or is there an existing/preferred x86 mechanism for preserving an
> EFI_LOADER_DATA TPM event log across kexec without making the transient
> allocation part of the firmware E820 topology?
>
> I have the full failed-resume dmesg, before/after E820 maps, five
> ordinary-boot maps, and the successful diagnostic hibernation logs,
> and I can provide any additional testing that would be useful.
>
> Thanks,
> Jasmeet Bhatia
