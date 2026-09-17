Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D064E0B7C;
	Thu, 17 Sep 2026 18:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671195; cv=none; b=Z1kzP0/Xijs60pQOMOweulQm/bWepPw0CKw+aIoXeC4wWkzcbdyrSMvJ4GkVHi9OmRBXDZQkeSkvxD/uRebVz8WlCHdU9QKauDKRU/MD8VYs6ecDOLpq656usTy9p1qk5MPWEh8iqloHxxN9T3XPXPn1W2XDZxtzKVHJtBd/VqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671195; c=relaxed/simple;
	bh=0XXc10LuxPPjD8Ut2DSVh2u4OycPgzdi40yURQCHxfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QhQn5Jghkllc0UD4Bd90SL3ApbkNuldSJHjHivuhph3I2IsT76CDGLBK7ohSm0I5kPCWJY+KXuJB4lqf/ntBAStsaXF+hcYDw2PRftxvjqtBnKHFOngXD858Y2+NZYkkFRU8webVFUl4FMY8OvppzKHA5Tyy5AeNeETFcOIWdk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcpkHQYf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcpkHQYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3686A1F00893;
	Thu, 17 Sep 2026 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789671194;
	bh=0oihKYd8wytojQfZkwv3d3XG7xPD4OISAVPY8R3cxfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kcpkHQYfVsftIxYMAI5mYyEK1J1hrx0e6VaZTd7q3LCRWui7RlFiJTXi1tNZxD+4c
	 gdX+pjFq23uV20OzdzfP0QmNW/0GqIcc0Fu0OwZ7q6zomSxpHPTLCvcCZGfH4MmX/Z
	 YM0rIMxKigTwRuV5utuXmehtQbel5GUXqrYBDm7yNsPI+XLv7sxkc/rgkQHPOJ4dFJ
	 pt3ZwzZXJvWi3zcvrt1vn27aR74bu+Sr1uxdhBcYgn+d+X8lM7AnJYWQRqCH17Q6f1
	 eDieijo3jn9Y6O4ORwn3pcTE2H00X9aF8G0JAZtf49WIOz0Q94f6u0zTFPn1cmErfj
	 3zN7dwkGyKTiQ==
Date: Thu, 17 Sep 2026 11:53:13 -0700
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
Subject: Re: [PATCH v3 10/20] kbuild: move the toolchain checks into
 init/Kconfig.toolchain
Message-ID: <202609171149.6454DC6@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-10-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-10-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:20PM +0100, Lorenzo Stoakes (ARM) wrote:
> Move them into their own file, sourced from the top of init/Kconfig, so
> that the next commit can add to them without growing init/Kconfig further.
> 
> No functional change.
> 
> Assisted-by: LLM
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  init/Kconfig           | 197 +-----------------------------------------------
>  init/Kconfig.toolchain | 198 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 199 insertions(+), 196 deletions(-)

Yeah, totally right to move to a separate file. I think, however, I
would prefer this wasn't in init/ though. Kbuild uses scripts/ as its
Makefile.$topic dumping ground, and Kconfig.include also lives there. To
me, this new file should be scripts/Kconfig.toolchain instead. And
arguably, this should be included by the top-level Kconfig rather than
init/Kconfig...

I defer to kbuild folks, though.

-Kees

-- 
Kees Cook
