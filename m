Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793891234;
	b=rbrKP2+1Sf4caNFrHPGM5jXkJKMmpcJj1k26LvbKi3ZTDU0F4iK8KIZ7WVT/CL+uXqYp
	 YmkjwzdrV1bkR+mhhLM3n7uQi7xqv1lPkRi7GtPY+KXNcYej7ukiFw3ZBwaYX2QpUhsjS
	 r3hany1mu9ZmSXghzmepCllopWnqxqjFcANffywyIj/qn3CXDuJLUgtkdPLlvZVqHOmsf
	 3pVba/p45oAHQ6IzVZSia/Pro4RadAWVd/uBm7gGq9Ax6chOpaJL8GvGsMXbr+JjK7Pjk
	 PGdEo94Sr9yd2aTtxhfpbz0pcLMmlhjwtn4+aKNVnO2cH+kcA6/GykyJJNQUipolyCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793891234;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6LZ+1+Vvz+jfm5vRHAeunaTxWBAAAXS8a4MaB1JvOmw=;
	b=b1XH3k6ZJcdzjfIDL3Zk3do/TBs7XFt2FNN65Oy99lo4JWDlwch+rgjdZlKSEVDZtMpY
	 xZtSZ/Ezi7tUya7u+p/evKnWvv7tcwQZpe/6g216/xAm4l6+1rEeP6i4x6sgeDuKz/Yd5
	 cVmdXplcllVO6a0VmzfJh9umiAAzf8Rzplzz0DDg5e6UBjQf4ors4FQEnl6zTmkEya0ca
	 E8Omy9MIbz8nSJc4KQgUBYrtmd/ivjb0p0tT1hijcNj1CcGKlAKUStxWSJdqPc//2YgCY
	 liaI7Y/WKuORa2rdBvkEqUMYBJTak0BunrQbDtxCf8kZy0z+a1CKun/f3eXcmQF93eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="EO2BJ/6+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5626C606A31B
	for <linux-efi@vger.kernel.org>; Thu,  5 Nov 2026 15:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EO2BJ/6+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F074E1F00A1F
	for <linux-efi@vger.kernel.org>; Thu,  5 Nov 2026 15:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793891234;
	bh=6LZ+1+Vvz+jfm5vRHAeunaTxWBAAAXS8a4MaB1JvOmw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EO2BJ/6+M7a0iVK+i0E4JAgIf0guklGRku6bWT0XQ+WcRveIX2swjjcEIo80eGySO
	 Zxwzw8nUep52BHRGVFDCqzj8MkwArw/D/cG+4k9VHdAUSkeTKyuVvrWfqL9HngrE+b
	 fctXZ9EOEIb2b2BwXoMxVj1b3kwiSyO3Te/F20K90NaAQvczD7ROuj9T2Wh7m9zwx4
	 qoffAGSr4/I8IVNzmJCJDgjFqm14vbHAlpFE4Ddpq+2dosEMN65pDabHtkLRweRqSF
	 FKXUAGogl5giMaahe7YMTTTl4OLkvYcSN4TZEU9UC4zNJKQ6bMkXRDwPZkGTMDpUh6
	 Yi0+lZbT1/B/w==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b56c428212so214083a12.2
        for <linux-efi@vger.kernel.org>; Thu, 05 Nov 2026 07:07:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzbWfW+gjRWMEGzCK0PwyIFlAtDJMNi/OBQhYFiHxJxoE6dBQ1oKQc6wZgwaocGWqZ4ln/Ze/puUbU=@vger.kernel.org
X-Gm-Message-State: APuU4Z9cOouOKJSM8lMFPIv/tmIbeyiKTljp21K7VOLj+YFOKsxToRAR
	wC/ug41LO3MIvT3CuLdpp63QxH9azPM2wc+oEPYB5ecf4UeGYk4Dejv4/vblLxM7YrA7pQuqEOZ
	EqGuNKTHFc4K86qvXiQZOSGC7FpfnzyQ=
X-Received: by 2002:a05:6402:27cb:b0:6b5:685a:aa29 with SMTP id
 4fb4d7f45d1cf-6b5685aabaemr3342720a12.30.1793891232594; Thu, 05 Nov 2026
 07:07:12 -0800 (PST)
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
 <aux9Hm0QFJLUDPWv@kernel.org>
In-Reply-To: <aux9Hm0QFJLUDPWv@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 5 Nov 2026 23:07:01 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
X-Gm-Features: AclHuK-7ZT562FqR8Q8-CsL50vorYou5ohB9VqtWfcaV8ssgwEH9NV-xDdP2-NM
Message-ID: <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
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

Hi, Mike,

On Thu, Nov 5, 2026 at 8:57=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> On Fri, Oct 30, 2026 at 02:29:52AM +0900, George Guo wrote:
> > From: George Guo <guodongtai@kylinos.cn>
> >
> > LoongArch never calls memblock_allow_resize(), so the reserved region
> > array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
> > (INIT_MEMBLOCK_REGIONS + NR_CPUS).
>
> This might be something to fix independent of KHO.
>
> Huacai,
>
> What's the reason LoongArch never enables memblock resizing and why it
> defines INIT_MEMBLOCK_RESERVED_REGIONS to include NR_CPUS?
At first we didn't define INIT_MEMBLOCK_RESERVED_REGIONS, then we got
boot failures on a 128-cores machine, so define it, and the value is
similar to arm64.

The reason LoongArch never enables memblock resizing is because the mm
code is derived from MIPS, and MIPS never enables it.

Huacai

>
> --
> Sincerely yours,
> Mike.
