Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326134D1795;
	Thu, 17 Sep 2026 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667059; cv=none; b=dfb7h7fyMV+/86lyezunLN5/BkY+TgJSgM4aRPdtuJC6JlC9H594jKpmBUF6I7gtyzIe0v0FwWbP7obpfFHRNiXRQYHX01kNiZdStMa6UYA2kBniw4PU6jXOGKkr9eco6zhZeFFlnA4LQFnAr1PTBVIlyh/LpQ7VqzrzI3rpQ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667059; c=relaxed/simple;
	bh=hv3na7/nQgMbxQLaY+j3n5VbiUqmgVcku9u0PT/EKF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sA1meZaIXdsvlyYkWscRRB8iTtCbjR7CX3vx37r2mar/RRiVd7E3PAQR+rOK4VFR7TfRbixW+UeeJ1P1hovg12TcaAXMRyqxkvWgfQB7Q4Y0FNLu8ld70NcE+ET4m0s+/aLdRPKQVzYXMq/bacC9pFf1aKKNOcdMqh+nt2BS5Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ldr4nFBF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ldr4nFBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F4B1F00893;
	Thu, 17 Sep 2026 17:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789667057;
	bh=o8t0uG7E/uqhNTiPvbHo7UwXr4W2cYCMc4ofCJI1mX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ldr4nFBFOw6TPOxueHSHbklvn48Qy3syIjOsXs7I6UcQTE2m/oKdxy7UwJF+Qfcqk
	 YltPrrl6XBEeGlpvlgPo/VXJNfUeIm/FAvUkQ68c3yX35vmOWW7lkuPQAx4cTD/XCK
	 fdmLzL6Nra8hQ2fNt+ui9fSmG9R6Clo2VmKHYbCCwnaTTE8KbDAwidHmiXdSYNI85U
	 W0jt/FttxkfT1qLWZHJGExQQvu8UEPGgfzswfk9D/jfQVw+ArkwzTkWIZe316OF1iL
	 V9zCji0IocQ2CZCKK4LUKQ6zrX6UcmEBFvSFxrckHT4qvWyD6Yg1axxPfyWQCQo2mD
	 +EudT3LXTkexA==
Date: Thu, 17 Sep 2026 10:44:17 -0700
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
Subject: Re: [PATCH v3 06/20] elf-parse: add section flags, symbol binding
 and a read-only mapping
Message-ID: <202609171044.EF5672D54@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-6-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-6-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:16PM +0100, Lorenzo Stoakes (ARM) wrote:
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
