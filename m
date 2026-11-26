Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795694790;
	b=oy3bTdB8CSYF/P9+FQP/4YLT13dvk/CPh/MjBmS+LUu4oCBgjU3kAVOJSRYrfgLjPZeA
	 QkxlEtaoK9nmdd35SpCQUP6vEcROFOQGijiFINM736tAvfK2oYQRip3jLfbboPARKzulA
	 r1LE7F+ZnJAIYzB2g17xDfz3PxYBHSlPsKu5lJo9RnP/ZJIre4aLt+DMNz6A9xjjuBRPQ
	 bfAnBYgzVPUwfmNVINNphOjQ45WVeiHMZG9ul2RsXOXYgD7XwySqdItesk+weGQLE1uT0
	 Mfnw8gxg/mFPlmNthdi6DgFqGT6KErA4We76OXqR6kaBiKzoFAWTTam8j+YNqAVLOwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795694790;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:X-ME-Received:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=EDJEdQ1TjvzunefynkN28sXQqGJbavrI+88Tql9ZN6s=;
	b=pIH7NRqecazSyVtJONSx0YAHOJ4PWyBWeRxm3FLUBNSaUQgHDOfYHShU/rR3oQIm+hrU
	 vNrRsrH9E2jfbP7Xm5fHKhgEMhcSDRJNvLgGJmvAbos4cOp2licaQ6qAS2N7aaYPIonyI
	 MJkcJcFdYcEoMPpAFSpv7RgwSGqZyVEJvfxA4sAhuuzjlQM4t4yegxS67uLXBijzbhbJ1
	 IVzEZvdeQsAa3K9bZ0BmFi+8hFLeYDC2K+fc4UKuW/Lue6TH2B+FIT3wuL/KXuxWFP8nJ
	 l00zOs63V0V4Qex45L8hCQ3jgZi3Hiy+juZxxL5G2+dOEuOu+pE/OoB9qaGFv0FMfVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=omNT03bw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70010606A326;
	Thu, 26 Nov 2026 12:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=omNT03bw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899691F000CF;
	Thu, 26 Nov 2026 12:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694790;
	bh=EDJEdQ1TjvzunefynkN28sXQqGJbavrI+88Tql9ZN6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=omNT03bwlyXAEzdJPc15TqhhNsvTZ23Ef2viVK5ZuuLgDQ3+eSPY/AKA+0N8WWaI0
	 dTDaozngAYkQbZDdD+ntF/PvCQBmTa0E1LrhQy90EaKWbkfWg2NqpE12/4Q3c85jgu
	 XudscGlS5//4OIM7GZzcT1FfwxbxngQS044emXjROnKFFzGxIfEkXD2FbJDoZ7rIvl
	 fctjgduZ2UDmg5/bhGMuieCbNLH8JF94xC6CEo0VmuI4MG5D+J9gIwyLSJfIwp1o7Y
	 jofavUA9NSxqeJBOgjV/dJqiHcKPPmAqZ05HAVBMy5yI83Bk0iGS7BVihBlAvPrzLM
	 AOgne88Jk5LUA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 29F261980074;
	Thu, 26 Nov 2026 07:06:24 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 26 Nov 2026 07:06:26 -0500
X-ME-Sender: <xms:vyAIa-3m5v1yRqO0vWj2J7VTPhKB5uemSZ4UUbAu43HMhdt3TUueCg>
    <xme:vyAIa36mZZsZkWSk-oh8K-NZknNIazY2ee5I-q8j-ydH-zASTYxGw3FkFCJ4EYwL6
    sLQCbHgjafoRfrQ6l409z97PTkyon4_KlEySxAqRw6nMZCowECImJY5>
X-ME-Received: <xmr:vyAIa_2tkhug_3k7eRKBaKtBcgVEXr9UjyWTJtajmat4AmPjU_LSZW0aiYY>
X-ME-Proxy-Cause: dmFkZTEG867qwPubLmy7FicciVJmTUol3Qz1f7B791QDJNbzIPzz4f9uomLjIqOPfvH7yO
    NxswOWJs4mi6y+Sp1R6QB1dEk6JMugZGnH7Bk4gHz9v+wM/uHUtphmdKRHj2GLnxfQNldv
    yADJr+1oORV73XEU0XfbBxYVi2EGODCQWC8QKV9J+LCHJimcLfSkJVMxo6xJPRLGwUECfh
    1K4q+WTecykqIdZ09/7sDBJwltqu6nEbu+dBNc3vuT0xlv9d3jjahc5qRXUolaQSTMOMJB
    p+bRouw6vkuelppkWr6Tn7KnHwPtYDBIIcpk3G+QiV+y0Q3eNRfb8apDO5QVoR2HDzemRp
    bJxtURZak5+r9R5JFqzDvIx/0Kk9PwEMqCOv+PZXbXzM9AtubbFpNosLUF0PHIFlq39hy8
    JhESN84RHMhFqs1xxmm/ubbX/eGmKp/fQcEw65PZbJN5kgw2felAiO/Et8I5JqQOt5S4ZN
    xtoxsIaM1FIuPeLYep2sQ4v6dAMiEmbuHBhN34wNpYEs9pgUUJBtGOFiNT+zkc2xA87myT
    /lwkrXcEBvn+hrzf4oYt9sI7HRdHz8Un4AELAQJaBaSfa12qo+YHJSSX5lCq/bPM/HN7Je
    0uNJW21s1xGdrA1XZ1Ep/zCgxlRe02m5KcduzGA/9c4z7LlN3diKQeAUI4Aw
X-ME-Proxy: <xmx:vyAIayouA2kdHOPuMjktIbnK199eprThX_wqlPcdAEWBzEytF5TSkg>
    <xmx:vyAIa1XnPKyk3pM6CFL4mOdKN3iJAGie9_hjOCvNMti4OSELm-gPwQ>
    <xmx:vyAIa3dFD2mZB-2rrDI-NSWhDBkcwHEusbPgmJGICdFORiaOefk9Ng>
    <xmx:vyAIa2C6XbpgO9CF8EFGX-dc8JTDy9Fcki1cro5kQIQNqnihlODZGA>
    <xmx:vyAIa23jQzM9hhVggKN5dZEABvfJO1_a9j0DUNBFIq-0bFtlIa_PYFoX>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Nov 2026 07:06:22 -0500 (EST)
Date: Thu, 26 Nov 2026 12:06:21 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Mike Rapoport <rppt@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>, linux-efi@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/efi: Handle EFI_UNACCEPTED_MEMORY in
 do_add_efi_memmap()
Message-ID: <awggd5bP1Yg7qgRQ@shutemov.name>
References: <20261125173338.1250080-1-kas@kernel.org>
 <2c075daa-978b-4efc-bb36-736909ec5ff6@app.fastmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c075daa-978b-4efc-bb36-736909ec5ff6@app.fastmail.com>

On Thu, Nov 26, 2026 at 12:29:30PM +0100, Ard Biesheuvel wrote:
> 
> 
> On Wed, 25 Nov 2026, at 18:33, Kiryl Shutsemau (Meta) wrote:
> > The EFI stub reports unaccepted memory to the kernel as E820 RAM.
> > do_add_efi_memmap() has no case for EFI_UNACCEPTED_MEMORY and adds the
> > same range again as E820_TYPE_RESERVED. e820__update_table() resolves
> > the overlap in favour of the reserved type, so the kernel never uses
> > the range.
> >
> > do_add_efi_memmap() runs when soft reservation is enabled and the
> > firmware marks any conventional memory EFI_MEMORY_SP; that takes no
> > command-line option. It also runs with the add_efi_memmap boot
> > parameter. A TDX or SEV-SNP guest booted either way loses the memory the
> > firmware left unaccepted, and it does not show up in MemTotal.
> >
> > Add unaccepted memory as RAM, as the stub does. Without
> > CONFIG_UNACCEPTED_MEMORY the kernel cannot accept it, so keep it
> > reserved there.
> >
> > Fixes: 745e3ed85f71 ("efi/libstub: Implement support for unaccepted memory")
> > Reported-by: Mike Rapoport <rppt@kernel.org>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> > Build-tested only, with and without CONFIG_UNACCEPTED_MEMORY.
> >
> >  arch/x86/platform/efi/efi.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> 
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> 
> I can take this via efi/urgent if desired.

It is not urgent on my part. It can wait the next merge window, unless
someone else needs it now.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
