Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E3F501F49;
	Fri,  4 Sep 2026 16:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788539481; cv=none; b=dMhvo0l0tZlCGkkrpXrfgSOd412hyRh2Ic4tKz6aKW0By3jyRRqHBaeM5fVCoF8jClGUVrAD2/fF/malkNCAMxEZpj6ZnCU0NX9IzdHxGTPAyCP7av151ZlUgXc3iaxdgfsaFhVhQRWLGG5jJMa5C1YbiTOhbhjUnnWq29lRjl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788539481; c=relaxed/simple;
	bh=LCxqDWzx6b7SR6fAu1Va6niGlyfQOLIgAToWHVaDNPY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XMHrKlRKfgLS6Vra/MirOpUtFsReCEq9UdywQ95PgJBSRBSgGY5IAQqDH0BV1fuPmX6SjR4iyAlBjuhYJQgG3eR25woHpS3uOme5EXsiYRzc5uUKgjpVxAfYaCIhaUVwmOYAK50CpbTJeNdT8CLS+xXiSSd2ZHWr6fdx7F+nowM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSemKsnr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSemKsnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9101F00A3D;
	Fri,  4 Sep 2026 16:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788539479;
	bh=j2r0KoKgq2hanpcV5bTU2teAuvBMeSQzSfhGhjq68n4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=RSemKsnrj3pHIuCVbsnDLx/wt1VFKGCe9P1UdS6sS6D04rgIzeYeog59OxZ2EqvG3
	 4AoaR2OnVKDz1Co0MgXRuABNi4x2XQX+ZYdHLu3iM/VWdythmpqCdnMLx6+XYGm1BO
	 JNO8PsqwfVAFpnfg/FhSD3yh990j6d+v+ucSzEtu7vyOBpUTIkni94ouoUaJMs6CVv
	 a49FcY6Et2SNenPmkKiozk8+UywCqZhX49cOrgY6YA8Lg+7pgnuKd6A0jjpme3RJzw
	 ZqIwYCT6BiFXcFWD/D7XByQ+oYxuP1mxJrw4CLvt9wIQONyOE2XdEcb6gcq0wPPzhF
	 1hAhD7grQ0peA==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: chenhuacai@kernel.org,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  shuah@kernel.org,  ardb@kernel.org,
  guodongtai@kylinos.cn,  kernel@xen0n.name,  graf@amazon.com,
  liukexin@kylinos.cn,  loongarch@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-efi@vger.kernel.org, Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: Re: [PATCH v4 4/4] selftests/kho: add LoongArch vmtest support
In-Reply-To: <20260904031108.11986-1-dongtai.guo@linux.dev> (George Guo's
	message of "Fri, 4 Sep 2026 11:11:08 +0800")
References: <20260807103714.33074-5-dongtai.guo@linux.dev>
	<20260904031108.11986-1-dongtai.guo@linux.dev>
Date: Fri, 04 Sep 2026 18:31:15 +0200
Message-ID: <2vxzpkytvuzw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Sep 04 2026, George Guo wrote:

> Hi,
>
> While preparing v5, I retested the LoongArch vmtest without the explicit
> `kho_scratch=16M,16M,16M` setting. That setting was masking a pre-existing
> bug in the generic percentage-based KHO scratch sizing.
>
> The percentage heuristic itself is reasonable, but the old implementation
> calculated each per-node baseline after allocating the lowmem and global
> scratch areas. Since memblock allocations are marked MEMBLOCK_RSRV_KERN,
> those scratch areas were counted as new kernel demand and scaled again.
>
> On the 1 GiB LoongArch guest, the 98.45 MiB reservation baseline and 32 MiB
> alignment made the old ordering request 224 MiB of lowmem scratch followed
> by 672 MiB for node 0. The node allocation failed and disabled KHO. I sent
> a separate generic fix here:
>
>   https://lore.kernel.org/loongarch/20260904025101.9959-1-dongtai.guo@linux.dev

Oh, cool! Nice find. I just wrote Sourabh (+Cc) an email [0] about this
too.

I think there is other wonky stuff going on with scratch sizing, like
global scratch being inflated. See my email [0] about that.

Let me go review that patch, since this seems to be causing a lot of
pain.

[0] https://lore.kernel.org/kexec/20260821105609.983622-1-sourabhjain@linux.ibm.com/T/#t

>
> With that fix, the total aligned request is 448 MiB and the LoongArch
> vmtest passes using the default percentage-based sizing. I also ran the x86
> KHO vmtest with the fix; it passes as well.
>
> Therefore, I will remove `kho_scratch=16M,16M,16M` from loongarch.conf in
> v5 so that it tests the default sizing path, matching the existing x86
> selftest behavior.
>
> Thanks,
> George

-- 
Regards,
Pratyush Yadav
