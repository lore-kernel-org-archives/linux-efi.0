Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9485C2E266C;
	Sun, 20 Sep 2026 03:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789876003; cv=none; b=JozroZQhK+jNCY7AbZ/Xw3QYkcVChe79P54u+1xtvg5IvytOjtTzmGGfc13l+6dYPBavQaDCm5M63/7ziAeZKKtWsr2r2Btd06eFgOiG+w2E3lYZ3D4nSP/ZksmgOAutot94KtGBeVwpD1pPOlefQNFzbIez572/6+l7gb0l1h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789876003; c=relaxed/simple;
	bh=ZbWAqJRTY3VosimGz01P04wQqhvs31GplZgQSEgfbFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pFQCSaknNLTw92BKf+9EYPPu8NPFsrDG4Rg75OjW8VyWPgf6N3Gv1jpBEo5PPHRl1UCE9128nhralT6yjjYTLHmLLOPoa2DZSlSwq+3+4fn2cqXtVqXajaCBuzDBsT/GHc7tioHzcLR0szWuScLtkx2IMTMYvvDVLO1pYVYHjj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pq1c/x2e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pq1c/x2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2021F000FF;
	Sun, 20 Sep 2026 03:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789876002;
	bh=RAgjdNuY0GHwXBswA5NShTSJab25cAeZ2wGxG0I/vUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pq1c/x2eNDaaA3FhHkOhGuCnsEwXECeh01hVEHOpDv8HFPU3D8PLxh2wVU0nylDaJ
	 7EaPp5slBBZUiOqsjhzEs7IgscKJPgdM3bXnpCs8IVuHJRaG5hD0rrtfwkhInaUah2
	 UEwXWAbH8m3JDS27foafZhT7dYncShEItD34AqEMdXClbdFXPJauYFWvvxe4hWYd96
	 N8ZnwsnLY9Xqn+sIDhK7K9lW5wcmPeM+9vJTKsXnZtJMmVVGCpp7vNL+wlt5H2W4zk
	 L6Y0Pud3rjcJlvf9NtFTivJRz4pQVpslkC4pi8p+/DINuR9TeguqodaZGqQrIxp572
	 Ic8aE8TCrC2FA==
Date: Sat, 19 Sep 2026 20:46:42 -0700
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
Message-ID: <202609192045.24A5A4E876@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-9-9ecf4163ff36@kernel.org>
 <202609171117.35BFDCC13@keescook>
 <202609171229.31BB336E1@keescook>
 <aq6_JcIy6gOsN4oa@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq6_JcIy6gOsN4oa@gremlin>

On Sat, Sep 19, 2026 at 06:02:46PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 17, 2026 at 01:59:26PM -0700, Kees Cook wrote:
> > So, yeah, it makes me nervous, and it may make incremental builds less
> > idempotent. But I can't really find extant problems and the demo is
> > slightly contrived, but not exactly an impossible situation.
> 
> Ack thanks for this!
> 
> There is definitely an issue here, your example is fine in the stock kernel
> but one run late in v3.
> 
> Solution is to have depcheck treat any dependency that is itself a target
> of the same run as never being 'fresh' (it already reads every .cmd file in
> the directory so has all the dependency information it needs), so that's
> fixed in v4.
> 
> Confirmed that it fixes the demo'd bug here, that touching a header
> rebuilds exactly the same objects as it did before and that noop build perf
> was not harmed by the change.

Oh very nice! Thank you for finding a solution there. :)

-- 
Kees Cook
