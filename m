Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770013264F9;
	Sat, 12 Sep 2026 23:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789256394; cv=none; b=DDE2Vkdh1Nx5sBDqCXUc8yzSZ8dJ+dTBE2iU5bxUO1UdJWmBYPrI2YJ5qao6sOCzt+f3cAOXSsgju7qdNabBePXwoItWGdxvkaJ09IYG5QPa6yWwJYOLKpTSji8PJ5xkxZViYcBWJoPlMrmxzPBikPnpYWxwC/1vb4BjiuT3A0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789256394; c=relaxed/simple;
	bh=mXXWEvTL6/Escqe9caEb/Ml6MTF6C3+TLVT95QNVseM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtfJKRlRwx9JTZrytaWHZAlWlMXtWE83VGvk6hTxK8maE48D4EPcW26uOXtb0Pfpd1/v38B6roXN5/wJB0MOPKLoUK7vusVowdj/LOfiPyCeg/YiIr/aM9D3EXNK9YpFHQi3S4HzbLPTscUbkv9qUnb7ttkdhEKxJ8+SVbC2n1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TFwkGY+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TFwkGY+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F43D1F000FF;
	Sat, 12 Sep 2026 23:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789256393;
	bh=IwGn1I+rAy33y7oqaqvyvQbpwgIGskjqTBVWKdDUb9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TFwkGY+GHCJrSxsgOvjVPO4RtJHqXtY6NmWLDm51LwYQ61/GgP9YWvhSmINFXEMdP
	 GMN5nuq9/1oJNcIfvA0sK5kouCUnAKf3af81PiqZukOojdg1bLGQjQc+Ed/8Mt31Th
	 jAL7jF5k9P0Kv4FKPk8MNtZEhOFdyJEAMrUUQUa7KPl0OrltmB7H1H+Y845mJps4IB
	 OcJhLmKUZEJblr7IYgkdp35SMbUDqAiqtNxT9W6hklmhwzbALX1KGR7RHoA67+ndyO
	 ZYVcADiRjh3JK+nRFFh1roZJYSjp9Cyh/eG1OHlRjW6frqE4YLALy+cR48xc2ZtUP8
	 VPCgchE2iZZiw==
Date: Sat, 12 Sep 2026 16:39:49 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Alexey Gladkov <legion@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Peter Zijlstra <peterz@infradead.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 19/23] objtool: decode instructions and resolve branch
 targets in parallel
Message-ID: <aqXXF6otLbLtnhWw@jpoimboe>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-19-5dc1ac01672d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260908-build-speedup-v1-19-5dc1ac01672d@kernel.org>

On Tue, Sep 08, 2026 at 09:55:19PM +0100, Lorenzo Stoakes (ARM) wrote:
> +/* Only an object this large, e.g. vmlinux.o, is decoded on several threads. */
> +#define DECODE_THREADED_MIN_TEXT	SZ_8M
> +/* Only decoding and the branch passes are threaded, so more gains nothing. */
> +#define DECODE_MAX_THREADS		16
> +#define DECODE_RANGES_PER_THREAD	4
> +
> +/*
> + * sec_offset_hash() keys on OFFSET_STRIDE windows, so the instructions of a
> + * window share a chain and buckets beyond one per window would sit empty.
> + */
> +#define INSN_HASH_BYTES_PER_BUCKET	OFFSET_STRIDE
> +#define INSN_HASH_MIN_BITS		10
> +
> +static unsigned long total_text_size(struct objtool_file *file)
> +{
> +	unsigned long size = 0;
> +	struct section *sec;
> +
> +	for_each_sec(file->elf, sec)
> +		if (is_text_sec(sec))
> +			size += sec_size(sec);
> +
> +	return size;
> +}
> +
> +static int alloc_insn_hash(struct objtool_file *file, unsigned long text_size)
> +{
> +	const unsigned long nr_buckets = text_size / INSN_HASH_BYTES_PER_BUCKET;
> +	const int bits = ilog2(nr_buckets);
> +
> +	file->insn_hash_bits = max(INSN_HASH_MIN_BITS, bits);
> +	file->insn_hash = calloc(1UL << file->insn_hash_bits,
> +				 sizeof(*file->insn_hash));
> +	if (!file->insn_hash) {
> +		ERROR_GLIBC("calloc");
> +		return -1;
> +	}
> +
> +	if (opts.stats)
> +		printf("insn_hash_bits: %d\n", file->insn_hash_bits);
> +
> +	return 0;
> +}

The dynamic insn hash sizing should probably be its own patch.  It's a
standalone improvement, and much more obviously correct compared to the
rest of patch.  I suspect it will make a big difference on allyesconfig.

The rest of the patch looks ok to me, though it needs to be reviewed
very carefully (which I haven't done yet).  I'd like to see a Sashiko
review (I wasn't able to find these patches on sashiko.dev for some
reason).

-- 
Josh
