Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894838;
	b=f8ANxy/EhWHW8BeIK/3SmBtNjechvfuL006am/YLJDhliyEIMaeHzHkHvLy3wMqPxWPW
	 8LpNgeaYJ2qKefttrEC/2kpenAMbW7+7iY+2MGVA+0w7805O9SwyPWJ7KsVQKNYV82t9b
	 EBT/DPxUxk3JgP0RwCZ44QiNILDGeYagZnslLEH6n3PQGyzg1e9HFn0X7Wx4orEfkPY9z
	 hUXjLxmAWPtHvGPUQXy16IkUep3ZmY4makE5+G9dzdUCCWqetMfEF1Ufr6M6XOTVk7YTu
	 dCdVSawDDe5I0EpgCbvYVNo0++BIGuZfyzwfl1/jmwKfMfRfut7mMBPopSI1ZxY/ofQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894838;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=fYG2b96fyayScxVvqtx3OSAsQSRRGOB6T40PDUmTI+8=;
	b=OB/JxUbjAXYgN2FFn1D/4m5gaDZPNR2ELG/SGtCflmARkDPXXr0UzaSp09bfHzmxkgTL
	 pprfB/S3j2nk4DgMHrk3VB76us8F3u9k5jainjErelz6rEQgNfT3h4V4Jgm0nY2Uyee0q
	 STt6qVry66lkKPaYVOrVLlEDPdxiO2UIUfwSFqh8lHcIA4yy7fZkNhTG0Q81lTUkSpMYW
	 tXGvWWhnq7Bw0QFiQZIrQopw8GlC6UAab77FyJA4Lwv9WVQQc8qSOAEr9PjKRWFQQBjT/
	 SXih+hKjNKzGMIYQDqp1V396xwB288gQqNcRp89nH07LQAAuZVOcZ3Em3FZREL9qyew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="fYo5p/HM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D17606CFAD;
	Thu,  5 Nov 2026 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fYo5p/HM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9871F00919;
	Thu,  5 Nov 2026 16:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894838;
	bh=fYG2b96fyayScxVvqtx3OSAsQSRRGOB6T40PDUmTI+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fYo5p/HMbU1gpXil/HFCks0XvJiGMwmcZT5vbnMwHLk29sKgRmtxnOzZk1wDd/aea
	 3QO93SZshqmi5XcbWCDImlOImNePvoMJSzaG2b7YVRdjnMMdkX2pMzX3zjGqqi9z/R
	 1giA01W0A74nBvUCV4Evs/Jpwh20TV7FcDEvOARPx86KpxOfYsGMq3+4ict6Zw0DmO
	 s71kK6K/sdKfuvuYgcVNrK3Izbx/cjngYc8wS2qLay+oUhVI6HRfeV9UV4zP/v7cDI
	 sRVdM/r2aEzpO9PIo3TiPHvl/20iU0QuIOji7FmhpavsI/vN/TSq8Nm8/IpxBsuWOM
	 +wCOYw3XpsVoA==
Date: Thu, 5 Nov 2026 18:07:07 +0200
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
Message-ID: <auypq8_7T-vml5_B@kernel.org>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-6-dongtai.guo@linux.dev>
 <aux9Hm0QFJLUDPWv@kernel.org>
 <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
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
In-Reply-To: <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>

On Thu, Nov 05, 2026 at 11:07:01PM +0800, Huacai Chen wrote:
> Hi, Mike,
> 
> On Thu, Nov 5, 2026 at 8:57 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Fri, Oct 30, 2026 at 02:29:52AM +0900, George Guo wrote:
> > > From: George Guo <guodongtai@kylinos.cn>
> > >
> > > LoongArch never calls memblock_allow_resize(), so the reserved region
> > > array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
> > > (INIT_MEMBLOCK_REGIONS + NR_CPUS).
> >
> > This might be something to fix independent of KHO.
> >
> > Huacai,
> >
> > What's the reason LoongArch never enables memblock resizing and why it
> > defines INIT_MEMBLOCK_RESERVED_REGIONS to include NR_CPUS?
> At first we didn't define INIT_MEMBLOCK_RESERVED_REGIONS, then we got
> boot failures on a 128-cores machine, so define it, and the value is
> similar to arm64.

AFAIR, arm64 had to reserve some per cpu data before they could enable
memblock resizing, so they had to make it static.
 
> The reason LoongArch never enables memblock resizing is because the mm
> code is derived from MIPS, and MIPS never enables it.

If that's the only reason, you might want to revisit that :)
 
> Huacai
> 
> >
> > --
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.
