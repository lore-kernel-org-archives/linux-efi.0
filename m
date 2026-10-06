Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FD535CBD7;
	Tue,  6 Oct 2026 10:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791282680; cv=none; b=rBBZIoty3KlLtGDZQuXZtlOBaoB6+F50Zsz73MhE0Jb7YZ6wDYjkIEEU5+v1vuV54UKiiWRBRS6Ii4ctYK7WmXUUVgJkpz6kyLjOb++Kz6ZebcD68kCaAJQZqevba9LpDSS8yp28fpcWqbaKColXrSgPgsquEWV+p1Rbh3oL+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791282680; c=relaxed/simple;
	bh=aI+9f6gBPu0M/vQ973hOPuaVfSloZHq5oBgKDhlM498=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=YHqXFYrOwPWWHCYt2/p7b9GT9DVOldoaYPYols4APrOh0Bu1aRVigswlBsW3p1aZcO63RWQbPXdPUHN4riegi4pI24r7qKGRCN67AUFQ0szK1ZrKJVuYmjF4sRo+j7DJXczV8yorbRvaRl2emyiqw0ts58Bd7uHQ1t7JssPPP8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ol9YmwxO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ol9YmwxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAE81F00898;
	Tue,  6 Oct 2026 10:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791282678;
	bh=ALpN1Maj9EHVWlBdbWojDECYyuYPzFGmL3crn6hvyc8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=ol9YmwxOTJV2ajvh2DQPaO3GJQHwWDfoIdhumtwFIh8TDephvBCPYF1tSs7t3SjHR
	 Ii8NiCuW1gEl25wbUbJ99mlc83gMbENr90LDiabLWhKEfvMFuHdVT8PAG9s5ea2ho5
	 Gum2fnt+KjmkyvLDcuf0IFWGHFZ1tqcEJENca2U1Zou8MVRHRQI4EZs1RFUIkYKvl2
	 MFjOfamExjIGEmzfIpQMNe/tju3QMf4lXsf7BP9BWrpCL2CTuM99JCEGV4T73Kq2yv
	 B86sw3xuvK0dCtoSaSDDLyTScs7mQqHlsFEYqNxSEUkQomWJQR5WM9aNfZtkoOukxH
	 rsehSQWb4+HhQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 2EA9D198003A;
	Tue,  6 Oct 2026 06:31:15 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 06 Oct 2026 06:31:15 -0400
X-ME-Sender: <xms:7c3EairCLg3yVpK4hsQL87XbeTZz0qqK97feUdhHMqKUPUmwE4Fm4Q>
    <xme:7c3Earc7oeXbL0vktWcCiT2vaJMzHxsdvDMlL2q5uHMMDi07cSffHdlWGNmKiBZVU
    e6B1nVgh8R7i0FLJkqrVwrkkuJxqggTGfHNhNNupIBDkcrG8gRDC67z>
X-ME-Proxy-Cause: dmFkZTEsDdnX9Y3ZJDxPCrw6tc0zS1iA5aGPrVX9TtkSIvacA0aBhZUTjX4nyhSQkLvqa9
    DmJLo+mkZ/vcnM5+2ypJbQSA4I/Zc7oR4UPvExYMwwU2Q2tCsRwj9uTpKEr0bxWC0yYLrv
    iL5LvHBWucAIdDDcbC36/9xav+t2BKAPGcEG75hTocgUXNYq/e0RIvYO2ZoXMtdy+N3HvC
    P4aWLEQuWh0xp/TA7hWqQ26F0CXYHIj6GFdluDUGAoLo7BEpfXsmQJvf1R8DibG2s5wmMY
    TA3tFKFlaArn15B2GKsPRs21f5EkS9yXuUJVRRTftwuKKQ14eC/W9mR+f592ITAwQ7n6rd
    XjT/kFbXnLkqTzP9mLuMg4R0k8rLkof2AATMIgV7+nGkDz78hszK3q7e8cR0iNEN+trEeS
    9e9FOcKP3HcDFO2p+Z0Qmsa264H0yYnADcEov1bOQzpqtbe/QAiZoCj6+RWWVibb6EG0C0
    dg7PjFuLMRjF655zY2vHRbJHQn5NAg0Lk+RrzeAJh+kqksBLvrg25ryG/d4z8DpeEy0LUJ
    AyhzcTfVdtP9OGgfo+CQJHj2NAaf0o0efQU365eZQvV2guAOiNdgJDdtkSbNBXxZR6Wsss
    7Kmth4q4tbSlqPSgErGW0Ggiey8t1VNVdsrlXHkVMQlunYj4q/J82Coh9vDQ
X-ME-Proxy: <xmx:883EaqbFk9J2X19clUCTNwkmExxeL5YEvgYu31KiMlF8dKt9qaCIqg>
    <xmx:883Ear1oFzNmKL3xeFUQJFaGlcHKcECrpQv-WRHnUA-pFXIQwJw7HA>
    <xmx:883EankWHW2yqE2pSkoiiyJTOV2rVpwiZXRBhMh0Z_SOVAZSfD5_mA>
    <xmx:883Ean9dlEcmspj88ogYncv1tKmRElqHzdWkjU4bmkfVugVRkdwtXg>
    <xmx:883EauHQsLeXiDNeaMO4hBD7vplWFRkth1sWFg3wIZ3_y74Vm5hMEY0g>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 91AB0F80090; Tue,  6 Oct 2026 06:31:09 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 Oct 2026 12:30:47 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jason Gunthorpe" <jgg@nvidia.com>, "Alexandre Ghiti" <alex@ghiti.fr>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Arnd Bergmann" <arnd@arndb.de>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "David Sterba" <dsterba@suse.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, linux-arch@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org,
 "Mark Rutland" <mark.rutland@arm.com>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Paul Walmsley" <pjw@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Simon Glass" <sjg@chromium.org>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Nick Terrell" <terrelln@fb.com>, "Will Deacon" <will@kernel.org>
Cc: "Alexandre Ghiti" <alexghiti@rivosinc.com>,
 "Conor Dooley" <conor.dooley@microchip.com>,
 "Jonathan Cameron" <jonathan.cameron@oss.qualcomm.com>,
 linux-integrity@vger.kernel.org, "Palmer Dabbelt" <palmer@rivosinc.com>,
 patches@lists.linux.dev, =?UTF-8?Q?Piotr_Kr=C3=B3l?= <piotr.krol@3mdeb.com>,
 "Ross Philipson" <ross.philipson@gmail.com>,
 "Sami Tolvanen" <samitolvanen@google.com>,
 "Song Shuai" <songshuaishuai@tinylab.org>
Message-Id: <4c482b32-390c-4fc7-9cb1-002eb88bfe58@app.fastmail.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
Subject: Re: [PATCH v2 00/15] arm64: DRTM, boot portion
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Jason,

On Sat, 3 Oct 2026, at 01:31, Jason Gunthorpe wrote:
> This is the first series for an implementation of ARM's DEN 0113
> v1.4b Dynamic Root of Trust for Measurement (DRTM) launch protocol.
> It is built on some generic changes to the EFI stubs that provide for
> a simple, direct DRTM launch directly into vmlinux.
>
...
>
> Jason Gunthorpe (15):
>   efi/libstub: Fix error unwind freeing fdt in
>     allocate_new_fdt_and_exit_boot()
>   efi/riscv: libstub: Don't set image_size in handle_kernel_image()
>   efi/libstub: Free cmdline_ptr in efi_pe_entry

I've picked up these fixes for v7.4. I'll need some more time to go through
the rest.

