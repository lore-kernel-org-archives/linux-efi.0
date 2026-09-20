Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523183CB541;
	Sun, 20 Sep 2026 03:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789876106; cv=none; b=NA/LeuJsWEIPD2wokqvLxV7hFQaQgPESwDygfcv8w3+0XIBXfZMbwsaRJtFfb/3Koum5EbX+YS1L4PBR+s7bY1BH3OvGTvn1ovHTl7r6BjHhE200XJX3PZgogJg0RqWI7BpbSDZoi+LueQNCuSRsJ+x0WqD7V/s8JxCwqy5HnNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789876106; c=relaxed/simple;
	bh=GSrtFVQAoq72BuT4l8bSIy6B2kt0Hd5qAgqf+SK4zMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ajp3i2J+MOgHiq4Hmw3p5FHfTHG4Z1MD8VAiCwaZr77KBEIP5rC6LU/PzuajvJCiTMDHwFxJhPz23e/xPVGoSiSBqI72HkUVFBQ60/fdE/IEDvL8iukunYpNEh/BgAqh8KkHYEgEtIRzxyTuF4xsVJNMHFvmSxPow2Z0IEO+jWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBC6aBoZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBC6aBoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2AA1F00893;
	Sun, 20 Sep 2026 03:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789876104;
	bh=ybCr0oF8quCv/avwZgHBTOG1l69Dfvx6Rf/qRs6G0NM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YBC6aBoZFH8ZoVIjcCysvgKQWPCeAZnK7xSXqRi8+dyWiyNvuz6IjqFWVKI+gEzA3
	 oaMZt+GfiWWPwZO+L7WtXR6zTVPWm8J5aEQddxqJ9e8w9wdXf9cgyQkwYsShqX/3y3
	 N6q33sbNYcxGvAtrsYo3EEQ1xP8Sx7eo8YiTsMCwsBDDR8h5oUZoUzzWD7hn+yryq/
	 dmoy7MMUFxy9hhJgZ1IuBPQFuWfx1BGqdpXi0ELNTQT7jOC3pbUc6TgXZiNsFdvHgO
	 2IPsOuX8fnt1Lpf/zBLFIb5c3OeIqw4T36I3/T9Np3Fk0ATdmUGrQeHxMxPs1dTCJs
	 9OLkkJAmVBHTA==
Date: Sat, 19 Sep 2026 20:48:24 -0700
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
Subject: Re: [PATCH v3 09/20] kbuild: implement and use depcheck to check
 dependency timestamps
Message-ID: <202609192047.17BD9B1F@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-9-9ecf4163ff36@kernel.org>
 <202609171117.35BFDCC13@keescook>
 <aq6-KMkAx7q_xLO4@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq6-KMkAx7q_xLO4@gremlin>

On Sat, Sep 19, 2026 at 05:57:36PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 17, 2026 at 11:42:50AM -0700, Kees Cook wrote:
> > On Thu, Sep 17, 2026 at 05:06:19PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > [...]
> > > +static bool next_line(const char **pos, const char *end, struct line *line)
> >
> > There is a lot of string handling in here. I know you're going for speed,
> > but it just feels like a python script doing all this would be much more
> > readable without wrecking speed compared to C much. Yes, C will win out,
> > but the maintainability of this helper does not fill me with joy. :P
> 
> Well I had the LLM look at that and for an allmodconfig python's startup time
> would take 40s of CPU time _alone_ and it'd kill the no op improvement. So C it
> has to be :)

Yikes, that's huge. C it is. ;)

-- 
Kees Cook
