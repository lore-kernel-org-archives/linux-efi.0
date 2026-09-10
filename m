Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF22047CC82;
	Thu, 10 Sep 2026 12:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789043146; cv=none; b=gPUbWCk2mZNjHQLpD1LCDIc7EW4xao29F5vIvcCSrPfMWiVJnzjYqN1Mhcd1AsfrSkfOueKAyvzeoViZPeUwhnIDduJH6Jb7DFYEi1q2Ef3EEVBFQKj7TYDjkIwbXCoAQQx/YCOh4COVxnyxotm347/o+N5VUHuQ5uLlALBkX28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789043146; c=relaxed/simple;
	bh=BO6TOgtbP8xX9WEKqa3BajNVFuzPTWio3Zhgdhs9daE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kpVupIXh/kidnQOpib9mro4JBMwaVwX2kzAJ3jpdTWBvhlwfhC5HotuC1EQmtwjFOKb+MXa9/vDQOaRQVYNFryRxGWZSvkpBCRAAnVfyIEu03jAO1w9nsC0Vfa1Sw/pTXff0fN/8Sk8y6+mJ96s5Qu6j9r9plWBSmtj6UT/Jq5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PI8pDV1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PI8pDV1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C331F000FF;
	Thu, 10 Sep 2026 12:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789043144;
	bh=r3Gniwpo9ILrHoRb1aFF/nqXCtCQyWfCq/qLdr8+214=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PI8pDV1prtOGYW7AWbHlLpNTedtkWAPrIKf1M5A7RKP0hM+8yxmyoUu6OFEVzKG/q
	 XixS2nm/5Eou4W/qCEB3ONp1Yc9ZySHO3GOg3k4oPK0F+5UPjC9PFm6ZW6SwjCcivm
	 9Ix17KysnbobtA/5+LI+/oa9NAk6lS57l9t3ZAlcJcP/DM5W+fxMmXWRhVgFkMqB7N
	 7xbpELojA6FZ71lAWC+hAB+XLJAikRriFccjpI8n+0t10y+9OF2Bo8NK/7xrY72Tg1
	 wxA/kLVbRVcP7aI18eu+UVFWzMsGpo1WD8uaVzVKCtPcgRQTaYdb3Iy3Y+/rhyOZM5
	 jRCLkt9dwKK9w==
Date: Thu, 10 Sep 2026 14:25:26 +0200
From: "Nicolas Schier (FRITZ!)" <nsc@kernel.org>
To: =?iso-8859-1?Q?Bj=F6rn?= Baron <bjorn3_gh@protonmail.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
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
	Gary Guo <gary@garyguo.net>, Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 20/23] kbuild: rust: parallelise rustc front end
Message-ID: <aqKhtoJZC0tt3OGj@derry.ads.avm.de>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-20-5dc1ac01672d@kernel.org>
 <t8iID_-Rgtrxxg-f1ZfdOg1xmm7YedvOT4pgDFEXKxoIeu29-JooZ3SSlbze088O0kLSOdgP7xN_Bo9Xm_lO1x51Gd-gIgT-tFPfwM_gCEw=@protonmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <t8iID_-Rgtrxxg-f1ZfdOg1xmm7YedvOT4pgDFEXKxoIeu29-JooZ3SSlbze088O0kLSOdgP7xN_Bo9Xm_lO1x51Gd-gIgT-tFPfwM_gCEw=@protonmail.com>

On Wed, Sep 09, 2026 at 10:22:33AM +0000, Björn Baron wrote:
[...]
> I tried implementing this a couple of years ago, but back then
> if I recall correctly either binutils ar or llvm-ar was unable to produce a
> thin archive referencing members of another archive like Kbuild expects to
> do. I'm not familiar enough with Kbuild to know how to skip the thin
> archive production.

You might be referencing to llvm-ar <= 14, cp.
https://git.kernel.org/stable/c/a48bd961fb20
https://github.com/llvm/llvm-project/commit/d17c54d17de22d2961a04163f3dbc8e973de89b8


-- 
Nicolas
