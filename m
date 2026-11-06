Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975718;
	b=MDvSSkUzKrVzD5jULTsdcKsMnVzmEzJIXB+4StEAjfGBUlRJJBjUCJ5fYbO0R9wymQGD
	 4EBRDexyq/yUxpuWUHG+UsDETrDsG7R6OAcbodnVDQAxKlw3S7tukeZHeu1MLyt9bpYyU
	 hPrlNZPX7Ptxsh3GpWp229Dgd4qQYe44EsRYhexdw71npgtXU91zPitvM7491QiWIYfPU
	 7zvKGwowfOVpgObukXtQOLKP8V0qg4uvsLq4iU9dpD/Pm/T/F5ih851TxPrjTgfEm6Bx+
	 ecgFLuheZdyTSPdEZU1rBCF/k2z4lF+q0RNWsF61GsZy6/8zxdPJ4kw74DSl+f2Or1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975718;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ABFV9qqW5v9B/veTK1qFSxVFzw8UX9r8phfo5f88bHM=;
	b=LoRHcwvQ3TqNmpINzu+JrujOUWM83Gop1VWhw0WIAyN92uZ1omcZ+nNuvrqehyBgHE4I
	 NrLRSueq2vJ+pkphyjkXVwNA0xU4ILLFRpnwOe+UVRVRngYMyIx2DkCki1y7wcA4zyae1
	 +8JO80hGZ0D4e9xCGAtEBXn0udvIPh54AfjibE9Y2r1OoKw5Qdy45GZ9OrstRt+Ut6DaZ
	 6Y628kPIuDF5u56KaFw1novw37f9KeDRxUDCCqY9hhdb2cU1ulmXZh3GMPYQ4L6VCwxDu
	 KiyjUCu75CsERWO4uOPW7Cz2iqSfQ/Wkwxg0hOCCtmq4YiDCxKNZSmPK7MMdaX1oVlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a7LdKMpo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96845606A331
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a7LdKMpo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E121F00907
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793975713;
	bh=ABFV9qqW5v9B/veTK1qFSxVFzw8UX9r8phfo5f88bHM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a7LdKMpoABR41gUzcHoVbB11ZSqAhEI7ksiYmrBmVIMoLE4+exZ0z1ZbAUDkTAQ7A
	 VnZON0YcjmLVL0l3KiRts6YZttZHIsit3U/hSekKUtQfCvpSRAe5wgqrX+nizmAq6B
	 pUwVBY9cU/y9IRbgLaIO//6RcUCnpi5ITVMhrR/k7j/cQiy8IgLXBx6KR4b/2Sf7bp
	 nH1n4vZjf7wCcdHRAKr4ovoS6JJy7XvG0Z+EqZoaDWIfhO2MyR+QFynbk4EoLoSwzH
	 +BWrUi1wDukYRSEJ7ww9XGzZQqvCyFe7GrcMeU2KcAVFN+2mCsbKRUhW5JgumVuKlR
	 nCwWDpi/f2fUw==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso850475a12.3
        for <linux-efi@vger.kernel.org>; Fri, 06 Nov 2026 06:35:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEIJzQqmriiZv3AX8LoYjGU6IgVWiggiglVtn9NLAtvDwXcEVMO7+58eSCxSF4GvksCRenEbXvG0Ps=@vger.kernel.org
X-Gm-Message-State: APuU4Z/zOZUrHjzUv9idG6IZ4gx7nYfBVQ9BqWEDbN7obHLvebBzHsF/
	g068SMTtwx5s24Ht5UcAJXGIsN2FT4wMS7z8oRa/rtALI9YLGbv+ozK/FwRdgog8oxFPCDv6Ddb
	xO+M+6rh2VQ7DRZYbSX/48mGnyMIpXDw=
X-Received: by 2002:a05:6402:1e94:b0:6b6:edd7:7928 with SMTP id
 4fb4d7f45d1cf-6b6edd7899emr802991a12.26.1793975711577; Fri, 06 Nov 2026
 06:35:11 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029172956.20791-1-dongtai.guo@linux.dev> <20261029172956.20791-6-dongtai.guo@linux.dev>
 <aux9Hm0QFJLUDPWv@kernel.org> <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
 <auypq8_7T-vml5_B@kernel.org>
In-Reply-To: <auypq8_7T-vml5_B@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 6 Nov 2026 22:35:01 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6aO_QNEzV-r6+FbNa=9EUQgv1vH0ET-ETXAH5x6oQGjA@mail.gmail.com>
X-Gm-Features: AclHuK9KCIrf61pzsewLNfcg32ftrSETM4BdWXL6OTYNNDPn4F3U0UamXyiZ-QM
Message-ID: <CAAhV-H6aO_QNEzV-r6+FbNa=9EUQgv1vH0ET-ETXAH5x6oQGjA@mail.gmail.com>
Subject: Re: [PATCH v6 5/8] LoongArch: Allow memblock arrays to resize
To: Mike Rapoport <rppt@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, ruirui.yang@linux.dev, 
	guodongtai@kylinos.cn, kernel@xen0n.name, graf@amazon.com, 
	liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 12:07=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, Nov 05, 2026 at 11:07:01PM +0800, Huacai Chen wrote:
> > Hi, Mike,
> >
> > On Thu, Nov 5, 2026 at 8:57=E2=80=AFPM Mike Rapoport <rppt@kernel.org> =
wrote:
> > >
> > > On Fri, Oct 30, 2026 at 02:29:52AM +0900, George Guo wrote:
> > > > From: George Guo <guodongtai@kylinos.cn>
> > > >
> > > > LoongArch never calls memblock_allow_resize(), so the reserved regi=
on
> > > > array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
> > > > (INIT_MEMBLOCK_REGIONS + NR_CPUS).
> > >
> > > This might be something to fix independent of KHO.
> > >
> > > Huacai,
> > >
> > > What's the reason LoongArch never enables memblock resizing and why i=
t
> > > defines INIT_MEMBLOCK_RESERVED_REGIONS to include NR_CPUS?
> > At first we didn't define INIT_MEMBLOCK_RESERVED_REGIONS, then we got
> > boot failures on a 128-cores machine, so define it, and the value is
> > similar to arm64.
>
> AFAIR, arm64 had to reserve some per cpu data before they could enable
> memblock resizing, so they had to make it static.
LoongArch is similar, so below 64-cores machine has no problem.

>
> > The reason LoongArch never enables memblock resizing is because the mm
> > code is derived from MIPS, and MIPS never enables it.
>
> If that's the only reason, you might want to revisit that :)
Yes, it seems we need memblock_allow_resize(), but maybe it is better
to bring back paging_init()? Most other archs call
memblock_allow_resize() in paging_init().

Huacai

>
> > Huacai
> >
> > >
> > > --
> > > Sincerely yours,
> > > Mike.
>
> --
> Sincerely yours,
> Mike.
