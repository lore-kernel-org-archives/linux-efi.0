Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0433219CC39;
	Sat, 12 Apr 2025 20:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744491027; cv=none; b=ZYtRHUhu8CUbC80udjWq8YL6QiigR737CQjqWnN4RQvL9Klbsr52uPmDhUZ3pUQbNCldQgzoetiWSagN1S9tC0eC2UfLfME7/DJkzmfeEZYCM5kdn7+Dtk701g60/lS82hqwvL76Y4+m1+vqyoYqu13ucOvMItgIkeBC06y9f5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744491027; c=relaxed/simple;
	bh=wqTZW779iFkZkApPjqU0NxvXHKCBaGbop+Dbb17RLI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqdssw6JnSPcYcdF0VQXeImUcfStcNE7Wd5/LDHAZ4wX7ttX4ucNd0+LPhP/mxobw6b8mFEjIoL4ycoZmiBBhIxBLLhvtQVrjjVM3Bz3ht4QlcfA7t874iE5pWDBjw/gH+/iLLILZO0s2G4AhH+cvR4PNf76KZavwXpf2NcNDWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qAnbUFfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qAnbUFfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7363FC4CEE3;
	Sat, 12 Apr 2025 20:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744491026;
	bh=wqTZW779iFkZkApPjqU0NxvXHKCBaGbop+Dbb17RLI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qAnbUFflrweSoYKMjb33Ru75hXrx5CrQnJ0GBwRqKQiTbABrdCByU7E+yAYSHOjAO
	 peh/3n0IbcvPniafTbI5loKmrqQmenEQQf1GPPM5G3m0+AnDUlSKJb501V8Koz9PYz
	 cwFIywYRrw5MAe4B/rUgl7AxaiP6c8iAdKvTBtRbEfsdKotaEREk8LgfUXvs/TVApP
	 u9UR+qvKPYDTA+owsUIkrvc0I78MBZaIddKxvu9qMPTKnMwQ+XkwV5Zbk1y6oFdh2m
	 rINRTfiEZZhiVz5ma9te7z1C5KgjFKV/cR3Kq7c+711mRLOnBnQ69sF+Rg+zTf9cTg
	 EyHivIkuZjDcQ==
Date: Sat, 12 Apr 2025 22:50:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Dionna Amalie Glaze <dionnaglaze@google.com>,
	Kevin Loughlin <kevinloughlin@google.com>
Subject: Re: [PATCH v4 08/11] x86/sev: Split off startup code from core code
Message-ID: <Z_rSDk0gINdtH9RO@gmail.com>
References: <20250410134117.3713574-13-ardb+git@google.com>
 <20250410134117.3713574-21-ardb+git@google.com>
 <Z_pbLAw56NIFo7yK@gmail.com>
 <Z_q1RthXIbSXY2Eq@gmail.com>
 <Z_rIJx_b70rzzERV@gmail.com>
 <CAMj1kXHAp5mWYTWP33B3JDu9z-+pHczA_pU06zEadgPcyL8ehg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHAp5mWYTWP33B3JDu9z-+pHczA_pU06zEadgPcyL8ehg@mail.gmail.com>


* Ard Biesheuvel <ardb@kernel.org> wrote:

> On Sat, 12 Apr 2025 at 22:08, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > * Ingo Molnar <mingo@kernel.org> wrote:
> >
> > > Ignore that, I have now read the cover letter too, with the patch
> > > dependency mentioned there - as kindly pointed out by Ard in a
> > > private mail. :-)
> >
> > But there are other problems during the allmodconfig final link:
> >
> >   vmlinux.o: warning: objtool: __sev_es_nmi_complete+0x5a: call to __asan_memset() leaves .noinstr.text section
> 
> This is an odd one, because noinstr functions should not be
> instrumented by kasan afaik.

FWIW I'm not doing anything particularly weird on the build environment 
side: GCC 14.2.0.

Thanks,

	Ingo
