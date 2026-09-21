Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9854A48F024;
	Mon, 21 Sep 2026 12:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994954; cv=none; b=T5SOWWm+g6Gs5MoyQwd3DsY3Remg+oIzR3SkOnUg9A/bNrIXbPfstC8vKatKyUSq1b0mJp998GfUMyNfSgd75L2RG4fx4xo0ycMZzZqGHzk5dIYxhhsRrivm/0DwmvyXTUuR+S+7lCi2+jsYNwl1rHz0dfXKaLFfNd8mqULZ810=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994954; c=relaxed/simple;
	bh=jExRX4G5OIZIjwoiUOBNVln0eNxdFkmvZs010Fu3Un0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TR3stX5w5vbCdloWaVqwlYKRoeDYFy9NX0EgOmv0hjQ5OxVeQsCyuseNwBKg9r3J384yn3Bl61UO5BexKWIubMgJYs6KH1JgZtSRRTkkpvr45il0QCpAczMX560K23Bk0wm8L/GjgAIPpYkQIuvo0Bb7dbKSnuQ6L/HkW998+FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYZuZoBS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYZuZoBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C9B1F000FF;
	Mon, 21 Sep 2026 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789994951;
	bh=jExRX4G5OIZIjwoiUOBNVln0eNxdFkmvZs010Fu3Un0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CYZuZoBSJafqz1gUdp9RzqB0IKQ+dGBhAKDxXduLxsehFa3rE/j7EwJk6mle0ok2S
	 Kn2XKnlXlvc3M6Nkpk0J+ERuWqkHl3XjoR0AByqpMedzdifr/tERuEMOci5ntShoY0
	 3BB6RqN0IBpdZ6In9mYJSndT9jm3ItxyBjkB2Bk61tsbkX2eUJaDIJuZnF1StwBNFd
	 ekjNCgH2frChTpdzEIuOFt157B109FY9aD3KbpoaVJIEgrkXBSKpA1ixhaL2hjPlX3
	 J+ML1u7s3cOiw6Hi6lg1BdAOYcCvaE9THduolTNeortqDnodKZHo9g8Iq5ttNwhQvH
	 sfLBOM3SiOd6g==
Date: Mon, 21 Sep 2026 13:48:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Petr Pavlu <petr.pavlu@suse.com>
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, Jonathan Corbet <corbet@lwn.net>, 
	Randy Dunlap <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 13/21] modpost: emit module descriptors as assembly
Message-ID: <arEnCzzQa9XDd4LT@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-13-39817ec5db23@kernel.org>
 <95baacfb-d8d9-4d2f-bc89-592df6f6f8e3@suse.com>
 <arEZrFmXeCO4hZpP@gremlin>
 <2b27bb4b-47e3-45ed-a26a-4b9de2b20542@suse.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b27bb4b-47e3-45ed-a26a-4b9de2b20542@suse.com>

On Mon, Sep 21, 2026 at 02:36:30PM +0200, Petr Pavlu wrote:
> On 9/21/26 1:57 PM, Lorenzo Stoakes (ARM) wrote:
> > (note there's a v3 see [0])
> >
> > [0]: https://lore.kernel.org/linux-kbuild/20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org/
>
> Thanks, I missed it.
>
> > On Mon, Sep 21, 2026 at 01:25:09PM +0200, Petr Pavlu wrote:
> >> On 9/14/26 11:22 AM, Lorenzo Stoakes (ARM) wrote:
> >>> The sections were confirmed to be byte-for-byte identical to the C version
> >>> produced - each of .modinfo, .gnu.linkonce.this_module, __ksymtab*,
> >>> __ksymtab_strings, __kcrctab*, __kflagstab*, __versions,
> >>> __version_ext_crcs, __version_ext_names and their relocations - for all
> >>> 8,135 modules of a clang allmodconfig build with CONFIG_COMPILE_TEST off
> >>> and CONFIG_MODVERSIONS, CONFIG_EXTENDED_MODVERSIONS and
> >>> CONFIG_MODULE_SRCVERSION_ALL on, and for a sample built with gcc.
> >>
> >> Lowering the data to assembly loses debug information for __this_module,
> >> specifically that it has type `struct module`. It might be worth
> >
> > No, it keeps it - every module includes linux/module.h, and the extern
> > declaration of __this_module carries the type, so all of the stuff gdb
> > needs (e.g. ptype, p & field access), DWARF etc. is all there in the same
> > way as with .mod.c.
> >
> > Have confirmed locally.
>
> An extern declaration alone shouldn't cause its name and type to be
> included in debug information. They should appear only when the variable
> is referenced by some code.

Ack yeah sorry my mistake, I had the LLM check that and should have known
better than to trust it without reviewing what it said (as I have done for
the most part for everything in this series).

>
> Testing with a simple module that previously referenced __this_module
> only in .mod.c and in no other file, such as lib/test_module.c, shows
> that the .ko no longer contains debug information for this variable.
>
> I've verified this behavior with GCC 16 and Clang 19.

Ack confirmed locally.

Can put a fix in module-common.c.

The LLM came up with a reference as an alternative:

static struct module *const __this_module_dbg __used __section(".discard.this_module") = &__this_module;

Would that work? Or should we go with your original suggestion? -

__weak __section(".discard.this_module") struct module __this_module;

>
> --
> Cheers,
> Petr

--
Cheers, Lorenzo
