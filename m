Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D113F39E4;
	Fri, 18 Sep 2026 21:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789767900; cv=none; b=hF6J8V13ZBvNhN8cS7C391yFicN8g6hY0N5JmoPqMiKPMia7+pB6sfmbdkbOo+Dq4Ph5tn5u8EJOMCYe0Nib1/2E4mDP69VdFa0BYH80WXpcIQDFqWP6JN/c1iXxI7i2Xu/dLXECBNoYDYAXGmEJMkdT50bnnvXfR/43R1+2lcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789767900; c=relaxed/simple;
	bh=pB79VHlpA+TkebC+eoaQyn5Kz80rPPXxTUFHDOYD60w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Smkd08Anm5cjISdPCQIwLGRC8KDZ1f7N+RsGp+6Ad+nepSLgH7mknXAwyu0WwwICQpHgDRzihqZ++K5rO+vJNYBoMAEDYfHAgrJzieuZytAa6+RF3e/xeGkwhdpi151PzsAZlnBoh1kS66bnbT1itexvEQ2GPmqH/hwnFUbTzTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQgYxZq6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQgYxZq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1BC1F000FF;
	Fri, 18 Sep 2026 21:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789767898;
	bh=47m5/bJCgqXHCsjMSTXZ8M+LCbGDWvPi6WjYg4kX/jU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eQgYxZq6FXvKH9oDFtee+HUr1yeIZxSpuhfKzG1seQYttwpI24UKyuXHn7jyDVfKJ
	 8B3QLdmLhccFogToNJW/mylPAMPCFS9WdkQ84ip47Eji0yUmqQ6oDepD/SqoUvANq9
	 2lM9+502xtuc/N/I8n57CgkWnk/mXLENx699zyZdqG2PR4ZxKtETI/CX+veFWIC+HI
	 wuv5zlX6befx13kct1lJOp1DISqgLN96CdJCJ3J6P9HqaSDFNAAnesC6lVHR33lN13
	 Tdmalrg19iUoGWhuTSmBQGHsLIz/VVwzo53Q4JxgbC7+JvY7iEFw3dDeNQdje3R4Xq
	 QGTEKWccmhUUA==
Date: Fri, 18 Sep 2026 14:44:45 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Nicolas Schier <n.schier@fritz.com>
Cc: Kees Cook <kees@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20260918214445.GA3589065@ax162>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-1-9ecf4163ff36@kernel.org>
 <202609170950.480F90A28@keescook>
 <20260918005142.GA1585590@ax162>
 <20260918-meek-spectral-nightingale-53d88d@l-nschier-aarch64>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-meek-spectral-nightingale-53d88d@l-nschier-aarch64>

On Fri, Sep 18, 2026 at 07:09:30PM +0200, Nicolas Schier wrote:
> Yes, thanks.  Looks good to me and I think it's a good idea to apply 
> that patch first.
> 
> for Nathans patch:  Reviewed-by: Nicolas Schier <n.schier@fritz.com>

Thanks, I have pushed this to kbuild-next-speedups as

  36d4a11b56aa ("kbuild: Remove alignment on .modinfo section")

which Lorenzo can base on. I have also tentatively included the patches
that are basically ready in my eyes based on consensus and review so far
for initial build testing. I do see some comments on some of those
patches though, so I will hold off on fully applying them until the next
revision. If there are any other changes that we should consider taking
quickly on the next revision, please feel free to point them out, it is
a bit hard to follow these threads sometimes :)

[1]: https://git.kernel.org/kbuild/l/kbuild-next-speedups

> [ Lorenzo's patch, updated by Nathan ]
> [...]
> > diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
> > index 6833b517cacb..95b523fe4f9e 100644
> > --- a/scripts/Makefile.vmlinux
> > +++ b/scripts/Makefile.vmlinux
> 
> [...]
> > @@ -103,10 +100,7 @@ vmlinux: vmlinux.unstripped FORCE
> >  # ---------------------------------------------------------------------------
> >  
> >  quiet_cmd_modules_builtin_modinfo = GEN     $@
> > -      cmd_modules_builtin_modinfo = $(cmd_objcopy); \
> > -                                    chmod -x $@
> > -
> > -OBJCOPYFLAGS_modules.builtin.modinfo := -j .modinfo -O binary
> > +      cmd_modules_builtin_modinfo = $(OBJCOPY) -O binary -j .modinfo --dump-section .modinfo=$@ $< /dev/null
> 
> By shifting from "$(cmd_objcopy)" to "$(OBJCOPY) + args", 
> $(OBJCOPYFLAGS) is dropped.  It this by intention?

I am not sure it matters in this case since I don't think there are
global OBJCOPYFLAGS, I only see instances that come from specific rules
but I might be missing something.

-- 
Cheers,
Nathan
