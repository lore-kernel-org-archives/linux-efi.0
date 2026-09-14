Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8DF43F8BA;
	Mon, 14 Sep 2026 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789408829; cv=none; b=OtnOSU+I53uBn3g2S6n0RlKYos9tyobyAtDQ2MWu5t5o4lOKsVM2HKVa5fPmVM66JsnY6jNNdrqX+1+cEJmZSGsqGquDiTyCF/iIRzibGc5HrreDlvHfNYSdVJvZs1bowNui58zV1nhGVWe7aZKwVsEgfP4OZ5Y3Y5gGWwkK/G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789408829; c=relaxed/simple;
	bh=3+cqU+7jmuS3Vs/6V/yEs66Msl6H9pWzW4OWZhoiFlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLlawIGd3hNFX3aGseGj9/gLxmr8TnNuoaJtdk+3IBsNLdh9jEn0Y0QNbiSl/guPC2Y+q8cP5ACwKA+LbTIs/xYrZBARroAQcD8jQx/Onrr0TjNkJm7B42VeBOnuUc47BBac8qwLV5luOLVTGw8WulqRZimuQWEfFOOEgOJ/vSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODZLqWaY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODZLqWaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B891F00893;
	Mon, 14 Sep 2026 18:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789408827;
	bh=NXbbt1iUoauMs+fLO9RzZKe19lkdH+Cr594Dnv6SVKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ODZLqWaYMLu9jeAppJFzYzDYbmDcJaGKcKFa9maRrc6IVgd+L6cfnoF+W8eb4TyYP
	 VBuHxSYqLE0IKj4JLNPRHFMrajD3oqPR0Hli5WItdUw2yzXh5Fs1Z4z4Pk7XJ9ltAI
	 lK9ar1JcXgrjYpleMvYP9gD/0aeoVIW9MHRWXi6H63l0hudVVU0iyu3NXARJ9wAmpg
	 Ta47EUvAsb1kOr/kor+xnCOr7kifair0OdB5MBceq0djdxtfuvb8ncAwhxJHq7rgYO
	 0kgGIOgELBX9Z2bS9EIKYMvoB7j/ksCVXBCRHVF9/hI3IZndRa3knP+m3HefHNC/k0
	 1UIcN90vCw8zQ==
Date: Mon, 14 Sep 2026 11:00:27 -0700
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
Subject: Re: [PATCH v2 14/21] kbuild: batch module finalisation
Message-ID: <202609141056.6AE2C82E@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-14-39817ec5db23@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-build-speedup-v2-14-39817ec5db23@kernel.org>

On Mon, Sep 14, 2026 at 10:22:13AM +0100, Lorenzo Stoakes (ARM) wrote:
> Module finalisation on allmodconfig builds consists of a large number of
> very short-lived jobs, and the make job dispatcher cannot possibly dispatch
> jobs fast enough.

This "cannot possibly" sounds like a weird LLM language intensifier. I'd
rather a concrete description of the problem, not this kind of
(redundant?) vagueness.

> [...]
> Fix this by splitting modules.order into chunks of 128 at a time, run in
> parallel.

Why "128"? This seems tied to the 128-thread test machine, but ends up
getting hard-coded, but this choice of value needs some rationale, IMO.

-- 
Kees Cook
