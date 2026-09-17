Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF464C10E8;
	Thu, 17 Sep 2026 17:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666567; cv=none; b=Kkixci2/33v898egBeTYLZ6fw060DZkoXknNlJCV2s0rv3dA+D/S/NB9yW3LXzvFxqoJ0/OGtcj4FvhZkwmGtyzpRyNWV5oBhbUY6I9oM6GTBENnkEb/7gO+q6MG2g77NtWt1jBy3nE2Hmehqfhc0tSFug0dMjlPlNIzsoJ0dFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666567; c=relaxed/simple;
	bh=90ob/hDnCCTxyePugnGrn5AtKvqDzbY34xoSKzFkgAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFqBpVWkrXGhL7z/IJDXuwa/2FcgesPJh3Eh7PV2ZwQQJ8LzYIWxcXpmKkW+5lIVG4idOFksfLf4vOKPdfBBn1pyNpPt6eg8CkVAzGYb9F20TU8rjBCXYt/9SYBl3uwqXmW/Go2Af8JHun6XdD4vYZPBahfEZDF/5d9VPPiSosQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FA9DCRPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FA9DCRPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B581F00893;
	Thu, 17 Sep 2026 17:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666566;
	bh=A6BEPHfJejrl2NMcgOgt++Vj4JDcXR1qLSxmja4QVCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FA9DCRPWrubMAvnERnORM+6SiKp9G+5NEqmT8NLgc4cw8+dM5yUrexfPpKjZLgq2G
	 T6oWf4KbCUmdYWp4a6Ywf8JfoTGT19RAZu31rQshkBuXwW7VLXnDk/VYLMkCmg4K8R
	 bM8vXaHND7xJmLktiCGijMcbFy419jIeCIc8G471IqC7MEqrUuNGmUAmdXUYx9OW5W
	 5Zu1pDrZCZsqA61toqo4ozSI8k4UMSZNJ+1guH3onThUccGMN57qEZxQVdY3A8ZVro
	 LoH28RiDHXGljskteGln8hIsDd8zLZeDNYpFqe/qobZNYHPFWTpnkMXfzmbQSQAFNV
	 i6cs5n/Bksa6A==
Date: Thu, 17 Sep 2026 10:36:06 -0700
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
Subject: Re: [PATCH v3 03/20] kallsyms: output binary data to speed output
 and kallsyms assembly
Message-ID: <202609171034.703D529782@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-3-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-3-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:13PM +0100, Lorenzo Stoakes (ARM) wrote:
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

A clear win. :)

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
