Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD418369985;
	Fri, 25 Sep 2026 13:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790343077; cv=none; b=gc8NXWNPS6PhMx9DJNeMAbQpTfOCfX44MSfCOc5COTS/EYn6ay5Uam73bhdb8n1dqazZGaM/+YgCicDdCOpyvOKgjEpincRJ/BJLPwkK9qS+0xsXOqNVamCCwqodRrjK/Wb3ZTeMrFPWq5+CoIqZBggzN9IOWDCf239RXDIjbXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790343077; c=relaxed/simple;
	bh=yA4cKLHyF4qCdwLvgoh1JpCvz5VpyX0kJMobRdgR1Xg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Oa6rYjh89zgDgXZCzLHMIWluCpfH2stz9daJru1LgSkjvNfqEDENJEzUyEtMkyBkUlqr6yAx3HcZMHbt0OmJGpabjDUDMT97BYd07rVTq1eDtq7pqg6p5gHIJWWght79x4cSO3qGzAs1LeMFZd+cKh5xr3hrlI7wvyK2v9j3/Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lRUrwpGc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lRUrwpGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84D01F00899;
	Fri, 25 Sep 2026 13:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790343075;
	bh=VZ4tp2eoIotFzdh0KT5kqPmQquJ1TlPLTl8eKwffrqI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=lRUrwpGcqS1kuxeDagQfJeuE/MLm7JBNkzmNXz4q/V9qZuJsfE56cE4WXHuYv79Q0
	 BX+ew66MF/P8nFqG1f8hmm9cWegfMqJ5rk43bW+6bTPmfKN+J69FQQkDYOKiOs8r3C
	 9giQhjy7hF201aEYxi5gOVMEK1HPCc3W6PBbJGBaZep7j8/qK7g3i1i8sFiOrUT7c2
	 shfEn3D95+tik8rcMJRLFOxUeLgIBR0ds8rDCCZBQiisbJmp1b3LwmdPevk4tKxbsL
	 b3qaltRurA4tc32zaNmKNZY960FTwqguB/5o0BWXJhr3lPYXFw4JRT0zOddjvYdEkJ
	 gTTSALYMAU58A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0FBC3198003A;
	Fri, 25 Sep 2026 09:31:11 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 25 Sep 2026 09:31:11 -0400
X-ME-Sender: <xms:mXe2auaDmvXz_ZbNQ5IUJUvYulOdkwXsiDPPm9R48nIri4QEnP-RXQ>
    <xme:mXe2asOg4Uw2Voj5roTOu2w_3W42g94Ku9M-KmHxhBE3eG4CeOWlhUOj3UPC7XS4M
    9AedKEJpZ2v7g91WPnKPBRLHfpSmkbITrWurBoh578CH7n78bedTURj>
X-ME-Proxy-Cause: dmFkZTEMF3/5tb6mz+ib9V0nff9NPmGPtWKkpNVahF43RJATx7iiAV9mOQ1UX28wOiLXG6
    jf7rcb1V5l5VxL6pbRzDh96fda46eQgCweXFg/XRm3wMx1Gd8rI5l0Wpz0HzoF3Sg3N81s
    R4dklUgOcIrqDzQzHPK3FWNsqerTynZIDmUQlFBSG1fhgmFPWVd88BfpDvD2ONNOlL6PD9
    RcHqYFkv7x72ewz577x/8VfmX9Ufo1EBw8Z+mbiQl4pkbAnujHjV6DVJFwda6p4IF/G2s3
    l55ZGhXkHxZH5BOeGYioJ+Rj4P+N1ARQs3Wu1hFMJzXC8LIqRkqnq10fB/tdxU48g6eNtV
    e9i6AdN9NTKtwRMswwiyiGxRi/JrcPEvipCWJjq/jROH81UrjeleKirf4Gx2sFYKpFpfr1
    +zCPn+1f1n8WyT1uCJPh12A9tlq1/+ig4PkNjvRrU1v/bq1jzksE3Q4YSfMmI3+N1sHjxO
    +I14IciFlV8OotFodD/QjTFbodk/ydtL2awqThW45gMwuMWu3qsonxCbATLJOLkpFh47tz
    DI0doApvsSc6lUU4nZx6rQVDX0cuFg9MLivKCF9qAPsbPFj3UqWsniE2xBiFBCmGops4wb
    FCBJRZT8VeLHluNTUQYK0XUhIRAzAmRkje4/l6jZQeuN1L3mP3bFdUMlg3Bw
X-ME-Proxy: <xmx:n3e2avHuUEcObNIoXGXVULzB97Xau8XE8vbJcgFkzf51IoPHIRupTQ>
    <xmx:n3e2amAl2zXKBFcjb666kOEFcfSb9IpKzDE3DruVAa_Ce6q74zpaWQ>
    <xmx:n3e2agdrxIVQyzKCNUhwZmr8flkKS885KQsk50KkuswdLVkPVPChcg>
    <xmx:n3e2alL6PjnwBM2Bm0Hu7ue0PGlyLpdDhyRJNNYTtkaynBlirqyLAQ>
    <xmx:n3e2apuVFjFjdTqRYxaqTId9GBDBlwAuBz3cn8VWRF4pO6kRWeP01-bN>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 36A15F80080; Fri, 25 Sep 2026 09:31:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 25 Sep 2026 15:30:44 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jason Gunthorpe" <jgg@nvidia.com>,
 "Jonathan Cameron" <jonathan.cameron@oss.qualcomm.com>
Cc: "Alexandre Ghiti" <alex@ghiti.fr>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Arnd Bergmann" <arnd@arndb.de>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "David Sterba" <dsterba@suse.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-riscv@lists.infradead.org, "Mark Rutland" <mark.rutland@arm.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Paul Walmsley" <pjw@kernel.org>,
 "Randy Dunlap" <rdunlap@infradead.org>, "Simon Glass" <sjg@chromium.org>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Nick Terrell" <terrelln@fb.com>, "Will Deacon" <will@kernel.org>,
 "Alexandre Ghiti" <alexghiti@rivosinc.com>,
 "Conor Dooley" <conor.dooley@microchip.com>,
 linux-integrity@vger.kernel.org, "Palmer Dabbelt" <palmer@rivosinc.com>,
 patches@lists.linux.dev, "Ross Philipson" <ross.philipson@gmail.com>,
 "Sami Tolvanen" <samitolvanen@google.com>,
 "Song Shuai" <songshuaishuai@tinylab.org>
Message-Id: <74197f6b-2ac3-43f3-804a-91e4041da20f@app.fastmail.com>
In-Reply-To: <20260924235031.GE9354@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <4-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
 <20260924155307.00007dfc@oss.qualcomm.com> <20260924235031.GE9354@nvidia.com>
Subject: Re: [PATCH 04/16] vmlinux.lds: Move DATA_LE32() from arm64 to the common
 linker script
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 25 Sep 2026, at 01:50, Jason Gunthorpe wrote:
> On Thu, Sep 24, 2026 at 03:53:07PM -0700, Jonathan Cameron wrote:
>> On Thu, 24 Sep 2026 10:53:07 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>> 
>> > Other arches may want to use this to get consistent fixed endian output.
>> 
>> You will have to grab it quickly!
>> https://lore.kernel.org/all/20260918145217.1669-10-will@kernel.org/#Z31arch:arm64:kernel:image.h
>> drops that definition as part of ripping out arm64 big endian support.
>
> Ah, well easy conflict resolution then :)
>
> When I was doing this I was really doubting why it had to be endian
> specific, this is mostly a cargo cult from the other stuff that was
> already working that way..
>
> I'm personally skeptical any arch could have either EFI stub a
> different endianess than the vmlinux, it seems like nonsense on alot
> of levels.
>
> So, I will remove the fixed endian pieces from here? Does anyone think
> otherwise?
>

Booting a BE kernel from EFI has never worked so no need to start caring
about it now.

