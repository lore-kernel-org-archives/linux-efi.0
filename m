Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E51C4F68C5;
	Thu, 17 Sep 2026 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663954; cv=none; b=BePlOYkIpSGpD+I7Pgh9ROfA9o+jIio9RTUjVT8IRUeCTULXb1w3ollrIL2sKJri8RZK1YqCNI6W9lahJ+YXA5zKBeothxhHrL5UkirYM5Cr+qAFlS4GMutAS8F62yvCIUemkvOGOOG7mw03zZ1bwNilwsmanI43LWuaJkM3lwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663954; c=relaxed/simple;
	bh=7X4pBO5Gfn34VCD0w+WxEYTb4YRWIG1+GLdVToPUjuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7dr0WG+0E/F/06MrUfeky4KBv0w+r13prrosoQZLrZY1WKSPwfm4a5YOhzmmng+Y0coUXf//rQztJ5gAm+2IJpKANJ+9oKBxt1JZuBC2BeDiru1VM5ZOzaNog7jUdsdJMXailUlL7pdH0mxAaTgSVgFUusIcNEj9gHvcJfEIa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijR8wbuK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijR8wbuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76E91F00893;
	Thu, 17 Sep 2026 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663952;
	bh=6HEIePW/GlQEOC8t0u6x4RNSCvywoj94H5Dv9GmwVto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ijR8wbuK+jfGWDzkXgnzvZ2zbZocAjn+YYg2G2izTt209ujOut6uhGYc+G6GX5lg/
	 Gsx7nEaWC8+EQEKcPf1WJmXyVbPnBLAl8/kbkIWc1ooxh/XzVfvd6j+MKv0rcsIFWt
	 XuLgs4GNdDKtxqsYTGzyNKMi+OoU5PuCMoK9PvI3mSPATlCkOAyuYNZSl+bntxvupf
	 9zaaJXZp7TakObvOzc7p4Uuk8jmTwCG6/Hb9i36amD6PLyhqI7RK6+RPeweQi0O37V
	 N185d8gTHUhEV7vlo36kgNPaz6aVZKuH3qa7AIrFO0Q/lOZq7CZxkaCdoYttrF8ICb
	 n6NPpwAvriCEA==
Date: Thu, 17 Sep 2026 09:52:32 -0700
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
Subject: Re: [PATCH v3 01/20] kbuild: do not allocate .modinfo in vmlinux
Message-ID: <202609170950.480F90A28@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-1-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-1-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:11PM +0100, Lorenzo Stoakes (ARM) wrote:
> -# .modinfo in vmlinux.unstripped is aligned to 8 bytes for compatibility with
> -# tools that expect vmlinux to have sufficiently aligned sections but the
> -# additional bytes used for padding .modinfo to satisfy this requirement break
> -# certain versions of kmod with
> -#
> -#   depmod: ERROR: kmod_builtin_iter_next: unexpected string without modname prefix
> -#
> -# Strip the trailing padding bytes after extracting .modinfo to comply with
> -# what kmod expects to parse.

This comment still seems useful here (afaict the stripping is still
happening with the "sed"). Maybe better to leave it, or future readers
are left wondering what the sed is for?

>  quiet_cmd_modules_builtin_modinfo = GEN     $@
> -      cmd_modules_builtin_modinfo = $(cmd_objcopy); \
> -                                    sed -i 's/\x00\+$$/\x00/g' $@; \
> -                                    chmod -x $@
> -
> -OBJCOPYFLAGS_modules.builtin.modinfo := -j .modinfo -O binary
> +      cmd_modules_builtin_modinfo = $(OBJCOPY) -O binary -j .modinfo --dump-section .modinfo=$@ $< $@.tmp; \
> +                                    rm -f $@.tmp; \
> +                                    sed -i 's/\x00\+$$/\x00/g' $@

Otherwise, looks good. With the comment back (or rewritten):

Reviewed-by: Kees Cook <kees@kernel.org>

-Kees

-- 
Kees Cook
