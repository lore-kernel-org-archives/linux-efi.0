Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794125697;
	b=nBd5FmhmL1ERbIILAjZjanGe35FMNVjqPyAy0wo6a150KUyRdFqLvcB1KJZQny+8nqX8
	 ZotODc+qYAwRoDaAnaLezA+pb7DSwBtYlHjAGqU0peJNvTQVs14vr2QzDrmq1NTzfCr4G
	 01NuJg+cCatLN6kNfRji2yUCinzMoQl+aDHoHOAmZFBTQDdrlMC6usxEkKqblhK5+3T3L
	 IyVTPktoZlHn5fbv3JzGE/WTLyrIQhc0uChfZpGqsSx5jCQQTcMaEVLQTHLCDroSNSoFV
	 aFgsko5xQZOQzv+aclTxWpeaStTUtBzMPUgQDR94w21IO+JhfZwNQBoOK3hmlfvykEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794125697;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=0W/6CqRYQKhRFQh0YmGByeLiEw+AYRdR3bmjVY7Mfnw=;
	b=epci4E9X3u5sXZK0uzov5kunDpRN+EgPLn6y+zghOQ5eISXRDRpou+Z1wYiqQuvt2Utu
	 F7AVzDRk5TXp7IJDfUc/qa7/fFJLEs6APjJNHuRAu1/4nnyxyz2xErjPMWRmR709ilnmP
	 R/AngaRLnqtvwrweoIGcyvNSBzIqtKd1KsbgAGiZNv+Vj1oH7Td2AgGiOGRtMfQLlUJNX
	 GHY2PIvRHv5k13Td/6SQND7gGokgt0FOS2nGlYT+o8MqvU99179ZuxQnZ6KJTxmqOba2S
	 SMoHpErgIJ+VBXO1132p05EayspBBJbvkIj0qR57wOadAHKROASbnkVakpUrnYv4myQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MKFzGvSF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D69606A31C;
	Sun,  8 Nov 2026 08:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MKFzGvSF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F881F008A1;
	Sun,  8 Nov 2026 08:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794125696;
	bh=0W/6CqRYQKhRFQh0YmGByeLiEw+AYRdR3bmjVY7Mfnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MKFzGvSFZwWIFFRA0ZXyvs16A8suXF5CnHj8Yu6DWVn1XNaXrMDEdixojJ9WmXEb7
	 B8HFMUjzOTvU6RwlNQjwdzjqPDvQCGA/4AJ0Em0zHhj4ypRhnI0mKxzYLZP1OV0ifL
	 eA9/fxW3Pxy16892wCazYquUCYCuIsm8XcchNAPA4t/tkQu4javpgOcU7RVq4A3nxo
	 k4uHK/8yLyZ3smraijDdggziz20OX07t14xfVyqW5GBbR1PgqbbVWyHXUI4Z32Xbrc
	 0iyAWtnR+xfX5UnU/tie3OAW89SLmVQEk/G3YHRAs2N39oS4qhXV1enxnkV6a1AaEm
	 jVNdWp25bMNnQ==
Date: Sun, 8 Nov 2026 10:14:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>, pasha.tatashin@soleen.com,
	pratyush@kernel.org, ardb@kernel.org, shuah@kernel.org,
	ilias.apalodimas@linaro.org, akpm@linux-foundation.org,
	baoquan.he@linux.dev, ruirui.yang@linux.dev, guodongtai@kylinos.cn,
	kernel@xen0n.name, graf@amazon.com, liukexin@kylinos.cn,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 5/8] LoongArch: Allow memblock arrays to resize
Message-ID: <avAvdiYY7SJ_Gfwt@kernel.org>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-6-dongtai.guo@linux.dev>
 <aux9Hm0QFJLUDPWv@kernel.org>
 <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
 <auypq8_7T-vml5_B@kernel.org>
 <CAAhV-H6aO_QNEzV-r6+FbNa=9EUQgv1vH0ET-ETXAH5x6oQGjA@mail.gmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H6aO_QNEzV-r6+FbNa=9EUQgv1vH0ET-ETXAH5x6oQGjA@mail.gmail.com>

On Fri, Nov 06, 2026 at 10:35:01PM +0800, Huacai Chen wrote:
> On Fri, Nov 6, 2026 at 12:07 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Thu, Nov 05, 2026 at 11:07:01PM +0800, Huacai Chen wrote:
> > > Hi, Mike,
> > >
> > > On Thu, Nov 5, 2026 at 8:57 PM Mike Rapoport <rppt@kernel.org> wrote:
> > > >
> > > > On Fri, Oct 30, 2026 at 02:29:52AM +0900, George Guo wrote:
> > > > > From: George Guo <guodongtai@kylinos.cn>
> > > > >
> > > > > LoongArch never calls memblock_allow_resize(), so the reserved region
> > > > > array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
> > > > > (INIT_MEMBLOCK_REGIONS + NR_CPUS).
> > > >
> > > > This might be something to fix independent of KHO.
> > > >
> > > > Huacai,
> > > >
> > > > What's the reason LoongArch never enables memblock resizing and why it
> > > > defines INIT_MEMBLOCK_RESERVED_REGIONS to include NR_CPUS?
> > > At first we didn't define INIT_MEMBLOCK_RESERVED_REGIONS, then we got
> > > boot failures on a 128-cores machine, so define it, and the value is
> > > similar to arm64.
> >
> > AFAIR, arm64 had to reserve some per cpu data before they could enable
> > memblock resizing, so they had to make it static.
> LoongArch is similar, so below 64-cores machine has no problem.
> 
> >
> > > The reason LoongArch never enables memblock resizing is because the mm
> > > code is derived from MIPS, and MIPS never enables it.
> >
> > If that's the only reason, you might want to revisit that :)
> Yes, it seems we need memblock_allow_resize(), but maybe it is better
> to bring back paging_init()? Most other archs call
> memblock_allow_resize() in paging_init().

paging_init() is a historical relict that hugely misnamed everywhere :)

I think platform_init() should be fine.

As far as I can tell, by the time platform_init() calls init_numa_memory(),
all memory reservations that must happen before any memblock allocations
are done.
 
> Huacai

-- 
Sincerely yours,
Mike.
