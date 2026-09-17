Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314725326BF;
	Thu, 17 Sep 2026 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664501; cv=none; b=nOWHoM4QepcOmYTo4Zb8g5mAPeUfngcfErI07kkC6G58jgl5vca9xkLrOWgO/lGEM4/K5fPZ20cHkOI+ibjuq/Hv1BNFc5B7kMRYTfKLbr03Bz6HNvkykLSU9zPfGy3Xuu8csXpL0v6k9ATaTFSSP0WJd5npUlavQ5B59WiAFaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664501; c=relaxed/simple;
	bh=msP+aYCFQRejiYJEioJy/luaDngihA3wohgZTYNaII4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hg2wOPq7a7uw2WLXhubMfCpwrgosuCjV2JDr2QFMepK8sJ4ZdnnqAvznN9Fya+1HSf5ajfQH9qc+/UPQBihmKeoMAeHxZv/rTGUMNFgOb+EathsSQ19w16Dg+gC4RuBJsb2N7TMhNygx9EeGW8zRNvp5mJyHIBZoGdzY+9tPw2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jjMFDSGy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jjMFDSGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C7F1F000FF;
	Thu, 17 Sep 2026 17:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789664500;
	bh=cMuDnpqJUB2Uf77ZbSuAlr2PpXfKCDvn1QWiL0hTFpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jjMFDSGyVlsre2OTckTLEm8iZBL2xUblNcOIL6hTWSU7fqk30T66IbsSK2lBLpw99
	 Li0P7WzjAKSSjpIhMssr2/0fCf0fePT4FXZNY5GuZ/FcFSms6av9+BT1r6C06UZ0B9
	 YyiYY8EBcVeOnXLjcd6vPNwWKdPZ7Ojf8w/cOCKB6I8RSa3RsWc+cc2xiueU4LSg6Y
	 mTS14dGRBrFfm6udeioEHK9A/Qe+EJHHb6efM8/5J03WRPVZuuozRUxr+mqbzw8IWB
	 vGGCU1Scz8EtSVp7LCMJD1RAOQFIbsQ3d9+6UsobnTpT5OVJDcELlyNi8o09hYdcU3
	 9Sr5bwOZ7smLA==
Date: Thu, 17 Sep 2026 10:01:39 -0700
From: Kees Cook <kees@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 14/20] kbuild: batch module finalisation
Message-ID: <202609171000.CD7797EA3@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-14-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-14-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:24PM +0100, Lorenzo Stoakes (ARM) wrote:
> With the .mod.S change in place, module finalisation on allmodconfig builds
> consists of a large number of very short-lived jobs.
> 
> For allmodconfig x86-64 this can be on the order of ~22,000 jobs of a few
> milliseconds in duration each.
> 
> Each job entails processing ~22k .cmd files, so the combination of heavy
> overhead and small individual job results in a lot of unnecessary and
> repeated work even with all cores being utilised.
> 
> The solution is to batch by a number of jobs. Determining which value makes
> sense was done empirically.
> 
> On a 128-thread threadripper box doing an allmodconfig build, best of
> 2, *.ko, *.mod.o deleted each time:
> 
>     modules per chunk    instances    wall
>     -----------------    ---------    ------
>                     1        11171    10.22s
>                     2         5586     6.72s
>                     4         2793     4.97s
>                     8         1397     4.26s
>                    16          699     4.05s
>                    32          350     4.05s
>                    64          175     4.07s
>                   128           88     4.05s
>                   256           44     4.03s
>                   512           22     4.18s
> 
> Wall time flattens for 16-256 module batches.
> 
> A slower/lower core machine will do better with fewer modules-per-batch, a
> faster/higher core machine will do better with more modules-per-batch.
> 
> Therefore, take the midpoint which works in the most margin in either
> direction - 128 modules per batch.

This is easy to tweak, so if we get negative feedback on this for
smaller machines, it's an easy fix.

> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
