Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D06C1A262A;
	Sat, 19 Sep 2026 17:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789839776; cv=none; b=LX5JyS/mVKatbkbkeNdg9mkm6lqsPgaa48t1OOy/cLxHC2tXRhipF2QZCGDCTcHGc/WZpRXBK/kFzgk814qfTsrIPaxi1wX+ET8NAH6Z0dsVP3ZyYi3xyUoHy0CBDFAfNjXR9l04NT7flsJuze/jfR4VCRIEqBbUypf0pMYA6Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789839776; c=relaxed/simple;
	bh=gX6kP0uYz6vCcANyl/YmCbeJHsGjeKSgylWNMLy9yew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iiF1KE5amVO+HuW3VIW9Dmxyh+RJapmG1anSdBzwps9ebdTl8n57vRqCpiqeY02buUuJ5JBY5rKOTerXZICpiH6iljVHBkoZYLo4YVOW2inp9m1qWnyIFmrvjXMUcVKIN48ahLU/IyBJvhNxKLmq+bjgFiXrHJC/K1kuj9F/OsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggnnBtdi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggnnBtdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AA21F000FF;
	Sat, 19 Sep 2026 17:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789839775;
	bh=EmKMaNISpoD+G1Wl72W0nnHSvdTJBbpXkv1m5kyJz2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ggnnBtdi6oPvTc6LR8VCsrfY7orLsXOlCoJnnxw13VrUFRrRVhWMt5OAF2Opcj4ZB
	 YcIj4CllvKnSlvek+Z3wchBQHqdTiimX32aDKEaeVtMBpKvttmHxupE66jvcdbZsDs
	 LBKKyRaP+EZtC9uNq49fUEONC+dlrc+drK6RLUfOspsQKYhlEZ8fYPdjr2D3RUX7BE
	 dG9EDgFG4VB868oRySp7/V9e7xeDOTmKtslQFScCq8nE7IzwsTtsZJNjWCYbxKXMcI
	 AM6G1OmVdI7U9BlXwceEYSQcUcvmGvRTGTSUgpHsIMbGLxJBna3mI5nOv4Lu47rPgT
	 Lizsy0etFY2yg==
Date: Sat, 19 Sep 2026 18:42:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
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
Subject: Re: [PATCH v3 20/20] kbuild: compress the kernel with pigz if
 available
Message-ID: <aq7JTyKVMljWOxer@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-20-9ecf4163ff36@kernel.org>
 <3be3dca3bee5695972e5419a1198bfee40a1ede7.camel@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3be3dca3bee5695972e5419a1198bfee40a1ede7.camel@mailbox.org>

On Fri, Sep 18, 2026 at 04:27:39PM +0200, Manuel Ebner wrote:
> Hi Lorenzo,
>
> On Thu, 2026-09-17 at 17:06 +0100, Lorenzo Stoakes (ARM) wrote:
> > The gzip step of a kernel build is very lengthy, especially for larger
> > builds such as allmodconfig.
> >
> > ...
> >
> > Whole build, 128-thread Threadripper 9980X, best of N runs:
> >
> >                                          before   after     delta
> >                                          -------------------------------
> >   x86 defconfig, touch mm/vma.c, gcc        7.7s     6.0s     -1.7s (-22%)
> >   x86 defconfig, touch mm/vma.c, clang      6.9s     5.4s     -1.5s (-21%)
> >   x86 defconfig, clean, gcc                28.2s    26.3s     -1.8s (-6%)
> >   x86 defconfig, clean, clang              28.7s    27.2s     -1.5s (-5%)
> >   x86 allmodconfig, touch mm/vma.c, gcc    23.7s    15.4s     -8.3s (-35%)
> >   x86 allmodconfig, touch mm/vma.c, clang  22.5s    15.6s     -7.0s (-31%)
> >   x86 allmodconfig, clean, gcc            294.1s   278.6s     -15.5s (-5%)
> >   x86 allmodconfig, clean, clang          283.9s   266.8s     -17.1s (-6%)
>
> That's good to hear.

:)

>
>
> > Suggested-by: Kees Cook <kees@kernel.org>
> > Link: https://zlib.net/pigz/
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  Documentation/kbuild/kbuild.rst   | 17 +++++++++++++++++
> >  Documentation/process/changes.rst |  8 ++++++++
> >  Makefile                          |  5 ++++-
> >  kernel/Makefile                   |  6 +++++-
> >  scripts/Makefile.lib              |  4 ++--
>
> Please add a line to
> scripts/ver_linux

Ack, done for v4!

>
> >  scripts/jobserver-exec            |  3 ++-
> >  tools/lib/python/jobserver.py     | 13 +++++++++++++
> >  7 files changed, 51 insertions(+), 5 deletions(-)
> >
> > diff --git a/Documentation/kbuild/kbuild.rst b/Documentation/kbuild/kbuild.rst
> > index 5a9013bacfb7..e71a692a559a 100644
> > --- a/Documentation/kbuild/kbuild.rst
> > +++ b/Documentation/kbuild/kbuild.rst
> > @@ -110,6 +110,23 @@ HOSTLDLIBS
> >  ----------
> >  Additional libraries to link against when building host programs.
> >
> > +KGZIP
> > +-----
> > +The gzip program used for compressed modules, packaging and the embedded
>
> Could you also add gzip to changes.rst and ver_linux while you are at it?
> Rest looks good to me.

I'd rather leave that out of this series tbh, if I listed it then I have to
choose a minimum version that and feels out of scope.

One for a follow-up?

> Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>

Thanks!

>
> Thanks
>  Manuel
>
> > +kernel configuration. Defaults to gzip.
> > +
> > +KPGZIP
> > +------
> > +The gzip program used for the compressed kernel image. Defaults to pigz (a
> > +parallel implementation of gzip), run under scripts/jobserver-exec so that it
> > +uses the job slots make has free, if pigz is installed, otherwise to
> > +``KGZIP``. Set ``KPGZIP=`` on the make command line to use another program.
> > +
> > +KBZIP2, KLZOP, LZMA, LZ4, XZ, ZSTD
> > +----------------------------------
> > +The compressor programs for the other formats. Each defaults to the program
> > +of the same name.
> > +
> >  .. _userkbuildflags:
> >
> >  USERCFLAGS
> > diff --git a/Documentation/process/changes.rst b/Documentation/process/changes.rst
> > index 0aa232b117b5..28f2ca63318e 100644
> > --- a/Documentation/process/changes.rst
> > +++ b/Documentation/process/changes.rst
> > @@ -55,6 +55,7 @@ nfs-utils              1.0.5            showmount --version
>
> + gzip
>
> >  openssl & libcrypto    1.0.0            openssl version
> >  pahole                 1.26             pahole --version
> >  pcmciautils            004              pccardctl -V
> > +pigz (optional)        2.4              pigz --version
> >  PPP                    2.4.0            pppd --version
> >  procps                 3.2.0            ps --version
> >  Python                 3.9.x            python3 --version
> > @@ -206,6 +207,13 @@ GNU AWK
> >  GNU AWK is needed if you want kernel builds to generate address range data for
> >  builtin modules (CONFIG_BUILTIN_MODULE_RANGES).
> >
> > +pigz (optional)
> > +---------------
> > +
> > +pigz is a parallel implementation of gzip. If it is installed the compressed
> > +kernel image is produced with it rather than with gzip, see ``KPGZIP`` in
> > +Documentation/kbuild/kbuild.rst.
> > +
> >  System utilities
> >  ****************
> >
> > diff --git a/Makefile b/Makefile
> > ...
>

--
Cheers, Lorenzo
