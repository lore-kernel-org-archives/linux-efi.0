Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F784B53E2
	for <linux-efi@vger.kernel.org>; Thu,  3 Sep 2026 14:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788445132; cv=none; b=nid/r4s5JngHEpiOssMo03kowBiPZvIHUYk2a7F35tBh+RKHWVVA00ypvNTcwSbmJVULLz4EQn9mNYLV5b9ZwNFA4hOu+ofBV+RQ8NI4JqG6Mn/f21kRZw4Nuou4igIY5/j1Htm8t1fhZtwPrYVfu2sRicNA97mJJ6HrfGLEov0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788445132; c=relaxed/simple;
	bh=Lb0Sv9j60k9cRcuQ0s/kgADg4wOv/tJaz3ryo/vRWaM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=b4aaWupN9Wjvwt6Boe1MTAsN6t5YKJ/qgUEZxviBZuGG7ScrzWGu7Pkx2BGnLOlK95fyrCUGN1AejhhqL8fe8+IUnG7aGiV4RoMm9OfLNeBOc9BI1OugNfNqrTuv/XpqhLuGkhm4og5BrZaLd4xD4lKHf1Dt1I8AHFe65JYO2WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gaXVR+5c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gaXVR+5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52EB1F00AC4;
	Thu,  3 Sep 2026 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788445125;
	bh=h+cwkYP6l09COUwE6LeNOPyCUXGnqmwGDMQzclGBPQM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=gaXVR+5cCOh4ZW3d6F1HMCduNDGlFxK9JaV3PLnHwo96J+S2L9syABXxSHlVSyZi+
	 s/8N4QeUvNUHoB3SxtlzagIT1ppVUKBZhaDLYSrpA3jnvuGL8GJ0XddQIFzv9iOd38
	 hP/NJB8Zyzlb1VQEb8LiqQST+i3A9o0+0ccxSwhUCHjothI6Fo7gmqpMKi5ggZd6Ej
	 mYIPouVkwYYwhLM641OL/9NO/5VNXMb6wevqyUXQtrHTXrPtTI5i8tDCUKIfI2UqiR
	 5humff4EQAT1JLExamn091DjSw8PnbJJzbTi2H9Kl/cmVY1XLup3kLAcM7qynbojul
	 mlh4Y4RBh89Ig==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 876411980052;
	Thu,  3 Sep 2026 10:18:43 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 03 Sep 2026 10:18:43 -0400
X-ME-Sender: <xms:wYGZavwFIG8hyvoz3AS9HE5hUNNLAAbSIb55qP8WoOoh7u86shbN3g>
    <xme:wYGZaiHI4f0jLcDg26_PJcEfeofAinsFN9ZbQik1EMog-tkj5k8mbF14mF_75aJFC
    hQVVrr-jEz5P6FWCikteuW3d8W6_2t16lK46TozGnTFWK4BGfy0GweB>
X-ME-Proxy-Cause: dmFkZTFJJgOg0lpliFrBucK2YjdINdfA+pdBd/bwWV3nCrK3y9sk2Nt1UgXhh+MMo9hhx6
    FJhES3wAAjk/XtbUK7M864xV1UKVeFDouC9acH7fVkZ5/4wcsC9TN5y6jnRAVTrqXl4Jz6
    pfUcdKGlFbTCFRX+bt5dvUmHZLCd5MRBcAPky8DQ51jl5wntsKA4CZH2cPjAhMMDE+99cl
    K4bnEn+08nT/Ixygd7JMj4RT/fAajL5F0BPVyba/QSo19v40KMwqJysnN8bNCjzH7IucWa
    qOVw9nDWbvVXiwTmzUeFmuelAQmFagh8+UphV4b40bmk2QGX/PNyqkN/cfKZ841Nb5ddaQ
    b7V22afHAtoglULx6Spu7e8fa59iT8OsOTHOA1Iel0AUdBxNmUjHfx7L5bTVv2/PSG9TAx
    PnmADPorXvCiwahN0L1j2afEp1hm/KuW6eJIAQtPBqiWoWM19gyvlGS7A7LCVLLQicVpnq
    5ih3Afcr4ACHNSB5eZHStQeB1saN+T0Lqg3bYqpXguB0V55ORkSyd0vgmMvHxScb74zlT0
    jzKDaSFk18yq0MJ8hWvcxkiYBg+CZXHR/kZLTSFhYT+6P5g0SVzCniO0G50a7OCbS60LhV
    fmEhUoO5lQLOEKHDwXfczKnXQikNPUKwkwbB3dRosbFUn5UXrpqaKFbVwHVQ
X-ME-Proxy: <xmx:w4GZaiinmz2NBdK1Q5YRwUYvJnssMqAqNwDB3I2EdbuS8yvocwngPg>
    <xmx:w4GZaln8Bw-UVGuFnw_bRJRNiQ8h25zqcmti3Ri3C9OMt2b9dT8Wkg>
    <xmx:w4GZats8SOo6kg3JZgu_tOxIu0VEEtK2_CxpaOSNmy6FKBWXlSrqyQ>
    <xmx:w4GZarZg37iH4TnBV8AMMtFRA0lakkL9rfn8tFz8nVGXzjG1U0fNbw>
    <xmx:w4GZalDhR-UoMRqwEq2SlkZvMgWAlKrg2hj99SPVwcWovwc0skEapjRp>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 957C7F8007A; Thu,  3 Sep 2026 10:18:41 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 03 Sep 2026 16:18:21 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
 linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, x86@kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <a9e23066-aa75-44be-ac3b-9a15f4cf6047@app.fastmail.com>
In-Reply-To: <cover.1788259938.git.jasmeet.bhatia.us@gmail.com>
References: <cover.1788259938.git.jasmeet.bhatia.us@gmail.com>
Subject: Re: [PATCH v1 0/2] efi/tpm: Preserve event log without changing x86 E820
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Jazz,

On Tue, 1 Sep 2026, at 13:34, Jasmeet (Jazz) Bhatia wrote:
> The EFI stub currently allocates the TPM event log as
> EFI_ACPI_RECLAIM_MEMORY. On x86, this becomes an ACPI data entry
> in the E820 map.
>
> On a Framework Laptop 16 (AMD Ryzen AI 300 Series), the EFI allocator
> can place this allocation at different physical addresses across boots.
> Since x86 hibernation validates architecture-specific data from
> the firmware E820 map, this causes an otherwise valid hibernation image
> to be rejected on resume with the following error:
>
>   Hibernate inconsistent memory map detected!
>   PM: hibernation: Image mismatch: architecture specific data
>
> Allocating the event log as EFI_LOADER_DATA avoids changing the E820
> map, but doing that alone would regress the kexec corruption issue fixed
> by commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event
> log to avoid corruption").
>

As I replied in the other thread, I am not convinced preserving the TPM
event log across a kexec makes sense to begin with. This is the firmware's
view of the state of the TPM PCRs when it handed over the system to the
first OS.

If the first OS boots, loads a kexec kernel and then boots it without
measuring any of that into the TPM, the TPM event log will match the
TPM state, but this is meaningless because of the missing measurements,
and the attestation chain is broken.

If the first OS does perform TPM measurements, it would need to record
them into a log and pass that on to the kexec'ed in some implementation
specific way - it cannot use the existing TPM event log for that.

TL;DR perhaps we should just discard the TPM event log reference from
the EFI config tables after consuming it. Or add a special case to the
kexec code to disregard it.
