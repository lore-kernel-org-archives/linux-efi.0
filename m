Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B8842A80;
	Tue,  7 Jul 2026 06:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405041; cv=none; b=D2V064qxcNUnmXeBpTnGg5XIo1X5lK7q5GPQ3P2MJXzokNNXy2J/3ul6OcKfUxqf2fSwWGeUJJpPahudbLuaC6tR4g2xm4vccfh/V1JhDGyDtn9Yp1A9PlF26buSu1Vmh3p3n8xEQdFCISWuCSvTIUfgGsHE/d0lBCW7zneHdEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405041; c=relaxed/simple;
	bh=zu0uu2fq2xHP4Jth5+S9wdRCRiksjRN/THePIUsujrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lni3iPEeWufsT9yZ3toWPQxu4i7TxTV13VMQxQRMit2k0VdlucGw+aT8bJH9iKF6DlDwgckF3rRLge3pcXm1FCl2LUlgu3JwLrYX5oTMs3R8ylvNVfKaolmZDs9urbHZS2Cs64VwH/nDCA3RkK86bcBLl/5SIlOTUotHvBY4EC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l9LZ68VX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9LZ68VX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0651F000E9;
	Tue,  7 Jul 2026 06:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405039;
	bh=836SAMNcgYGznpPv4pDFhhl2VYFtwB3MUE7NXhRTR44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l9LZ68VXwiy2wzLo7a6kET2rVY4gxtpjyT5oNRV80EH+ueCCspXQGjjIAlDlLzyeO
	 YFYx6l0N+wz+Yy6oMl2JKy3lr/dXU/sJGiE/Mk3RNnxpzjGu+j5vbStTn4Sbhjgc14
	 aZe8rHO3zg0yr1Yfzs6dPtpo6gK9Hw+qdCT0DXbO8vE8KJ8xBpvmIl7MIxNsP9+Ok4
	 tlnMXmxQ9La5/V8b47TJbYkAWoQQODk2Hx1nTtTghnvdeQPJLOaNeS7bpTJcdHx+vX
	 lejiXTi4/7NIktdzxwyfeeL4MkfFWX0K2bNuHqFaSu9rbXvb1YZT2M+vVWfQe5DPsX
	 vROavjbjpHKiA==
Date: Tue, 7 Jul 2026 09:17:08 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>, Thomas Gleixner <tglx@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>, linux-mm@kvack.org,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>, x86@kernel.org
Subject: Re: [PATCH v2 0/5] treewide: remove unreachable memblock_reserve()
 return value checks in early boot
Message-ID: <akyZ5DhIV_Grn1Kc@kernel.org>
References: <20260706163753.193875-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706163753.193875-1-ekffu200098@gmail.com>

Hi Sang-Heon,

On Tue, Jul 07, 2026 at 01:37:48AM +0900, Sang-Heon Jeon wrote:
> memblock_reserve() can only return an error after memblock_allow_resize()
> has been called. Before that it either succeeds or panics, never returning
> an error.
> 
> Before memblock_allow_resize() is called, the return value checks of
> memblock_reserve() are unreachable and can be removed.

I'd rather keep these checks.

Removing them relies on internal details of memblock_reserve() implementation
and the existing event sequence. If the code would move around relying on
panic in memblock_reserve() may not be correct.

And the few bytes and cycles the change saves do not worth the churn.

-- 
Sincerely yours,
Mike.
