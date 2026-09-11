Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF3143DEDA;
	Fri, 11 Sep 2026 10:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123761; cv=none; b=oLjc1PvsEroXpnOxpVB//0YPvTw2NWyzKNcE2nv+QkYHUgaHcEMnxhJg/oJ14KhduLRW9dJexIRs1cjTsuZNJzkuJDiNkViyGSBA/gOvjV+oKPHO3ljBq/W6Ac48kp821Klqge4fDvpMlsUwSAtsmujqa/1Zv9lRaDVYLf1zxGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123761; c=relaxed/simple;
	bh=FhpVzfkM/2dJ8IqMwnylA1HfEdd29gKqvTPkEU5THZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tM+pXTF7VquaPNda8zdeYDwm1ZkVvII8vXrSzn2LNBtkH1z6+h52s7dRiy2iBqbWWl0lo1VSwJsdBm5bbtAsrLOGSXWql+HcoMYSnCnDZGdz5NIUvCmtTHf1hSD4CIqxY8hbB2LFWGSSlZJOHvHLuBUi1WaLlbOBRFbtof7gBmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WiXwnb2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WiXwnb2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43CD1F000FF;
	Fri, 11 Sep 2026 10:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789123759;
	bh=2cS6Zi4iecA8/WRpl/dxFtp9Ml8fWtC6CKWWl6oDTEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WiXwnb2bSPhVBOFtwAV2PFncYRx1awBTnuFlQ929vhtJg6Ka9nuJywA2UGoNQmwWT
	 IF7VzTnkK0hQ56wEqlH1C7sBB7dByg96e1nOE8TDugDVKYL7Dgi+T4m1GMD4dkNAMU
	 vbA8xiRKOsb/KHI9sBAcXY4DzjflLSnNBKL661TkUMxJcAvYXKJpq0G4KWqqRYUkdh
	 KmKA/KF2Z0EwVAu0MQjRTlmTBYJviSRdTL1PF/wrBy9aEQjDqqdqjpm0E82HpTR+mr
	 iCvw8Z7TKGWaZPG2ZZWkYqIkLDJXno4xA8YcegZLEWJ8MBXXr/EpyWXUtHfOzi0T0g
	 gyeooq1pbSMtQ==
Date: Fri, 11 Sep 2026 11:49:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 17/23] modpost: perform srcversion hashing in parallel
Message-ID: <aqPcXcJVif1SLrDF@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-17-5dc1ac01672d@kernel.org>
 <20260910113259.743b9686@pumpkin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910113259.743b9686@pumpkin>

I'm likely going to be dropping this patch from the series:

https://lore.kernel.org/linux-modules/20260731-module_ver_remove-v2-0-c9163858f382@linuxfoundation.org/

I don't really agree with the points below but not really worth getting into if
the patch is going away :)

On Thu, Sep 10, 2026 at 11:32:59AM +0100, David Laight wrote:
> On Tue, 08 Sep 2026 21:55:17 +0100
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > modpost does a lot of single-threaded work hashing files from each object's
> > .cmd file.
> >
> > This makes the build slower than it needs to be, so do this work in
> > parallel.
> >
> > This is egregious for allmodconfig builds - for instance x86-64 can end up
> > opening 200,000 files individually and hashing them all serially.
> >
> > Parallelise this operation by maintaining a thread pool for the hashing
> > work.
> >
> > Combined with the per-file hashing commit this cuts modpost's run time
> > nearly in half for an allmodconfig build.
> >
> > Module.symvers and every *.mod.S are byte for byte the same.
> >
> > modpost is on the serial tail of every allmodconfig build, however
> > defconfig does not set CONFIG_MODULE_SRCVERSION_ALL and is unchanged.
> >
> > Whole build, 128-thread Threadripper 9980X, best of N runs:
> >
> >                                          before   after     delta
> >                                          -------------------------------
> >   x86 allmodconfig, touch mm/vma.c, gcc    33.4s    30.2s     -3.2s (-10%)
> >   x86 allmodconfig, touch mm/vma.c, clang  31.1s    28.1s     -3.0s (-10%)
> >
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  scripts/mod/Makefile     |  1 +
> >  scripts/mod/modpost.c    | 72 ++++++++++++++++++++++++++++++++++++++++++++++--
> >  scripts/mod/modpost.h    |  2 ++
> >  scripts/mod/sumversion.c |  3 +-
> >  4 files changed, 74 insertions(+), 4 deletions(-)
> >
> > diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
> > index fbd5099e0441..fdd486184f9c 100644
> > --- a/scripts/mod/Makefile
> > +++ b/scripts/mod/Makefile
> > @@ -5,6 +5,7 @@ hostprogs-always-y	+= modpost mk_elfconfig
> >  always-y		+= empty.o
> >
> >  modpost-objs	:= modpost.o file2alias.o sumversion.o symsearch.o
> > +HOSTLDLIBS_modpost := -lpthread
> >
> >  devicetable-offsets-file := devicetable-offsets.h
> >
> > diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> > index 550ccd753ed8..882169e51851 100644
> > --- a/scripts/mod/modpost.c
> > +++ b/scripts/mod/modpost.c
> > @@ -16,6 +16,7 @@
> >  #include <fnmatch.h>
> >  #include <stdio.h>
> >  #include <ctype.h>
> > +#include <pthread.h>
> >  #include <string.h>
> >  #include <limits.h>
> >  #include <stdbool.h>
> > @@ -1717,8 +1718,7 @@ static void read_symbols(const char *modname)
> >  	if (!mod->is_vmlinux) {
> >  		version = get_modinfo(&info, "version");
> >  		if (version || all_versions)
> > -			get_src_version(mod->name, mod->srcversion,
> > -					sizeof(mod->srcversion) - 1);
> > +			mod->need_srcversion = true;
> >  	}
> >
> >  	parse_elf_finish(&info);
> > @@ -1736,6 +1736,72 @@ static void read_symbols(const char *modname)
> >  	}
> >  }
> >
> > +static struct module **srcversion_mods;
> > +static unsigned int nr_srcversion_mods, next_srcversion_mod;
> > +
> > +static bool get_next_src_version(void)
> > +{
> > +	struct module *mod;
> > +	unsigned int idx;
> > +
> > +	idx = __sync_fetch_and_add(&next_srcversion_mod, 1);
>
> When I've done this is the past, adding 'a few' items was faster
> because it reduced the contention on the counter.
> (Although there were probably some very cheap 'actions'.)
>
> > +	if (idx >= nr_srcversion_mods)
> > +		return false;
> > +	mod = srcversion_mods[idx];
> > +
> > +	get_src_version(mod->name, mod->srcversion,
> > +			sizeof(mod->srcversion) - 1);
> > +	return true;
> > +}
> > +
> > +static void *srcversion_worker(void *arg)
> > +{
> > +	while (get_next_src_version())
> > +		;
>
> I don't think the extra function call helps.
>
> > +
> > +	return NULL;
> > +}
> > +
> > +static void hash_srcversions(void)
> > +{
> > +	unsigned int i = 0;
> > +	struct module *mod;
> > +	pthread_t *threads;
> > +	long nr_threads;
> > +
> > +	list_for_each_entry(mod, &modules, list)
> > +		if (mod->need_srcversion)
> > +			nr_srcversion_mods++;
> > +
> > +	if (!nr_srcversion_mods)
> > +		return;
> > +
> > +	srcversion_mods = xmalloc(nr_srcversion_mods * sizeof(*srcversion_mods));
> > +
> > +	list_for_each_entry(mod, &modules, list)
> > +		if (mod->need_srcversion)
> > +			srcversion_mods[i++] = mod;
> > +
> > +	nr_threads = sysconf(_SC_NPROCESSORS_ONLN);
>
> One thread per cpu is probably a few to many.
> It might be worth adding a command line parameter for the 'max threads'.
> Possibly with -n meaning 'all but n'.
>
> > +	nr_threads = nr_threads < 1 ? 1 : nr_threads; /* On error assume 1. */
> > +	if (nr_threads > nr_srcversion_mods)
> > +		nr_threads = nr_srcversion_mods;
> > +
> > +	sumversion_init();
> > +	threads = xmalloc(nr_threads * sizeof(*threads));
> > +	for (i = 0; i < nr_threads; i++) {
> > +		if (pthread_create(&threads[i], NULL, srcversion_worker, NULL)) {
> > +			perror("pthread_create");
> > +			exit(1);
> > +		}
> > +	}
>
> The main code can call srcversion_worker() here.
>
> David
>
> > +	for (i = 0; i < nr_threads; i++)
> > +		pthread_join(threads[i], NULL);
> > +
> > +	free(threads);
> > +	free(srcversion_mods);
> > +}
> > +
> >  static void read_symbols_from_files(const char *filename)
> >  {
> >  	FILE *in = stdin;
> > @@ -2729,6 +2795,8 @@ int main(int argc, char **argv)
> >  	if (files_source)
> >  		read_symbols_from_files(files_source);
> >
> > +	hash_srcversions();
> > +
> >  	list_for_each_entry(mod, &modules, list) {
> >  		keep_no_trim_symbols(mod);
> >
> > diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
> > index d5f6d82837d5..10d5f8f2f293 100644
> > --- a/scripts/mod/modpost.h
> > +++ b/scripts/mod/modpost.h
> > @@ -127,6 +127,7 @@ struct module {
> >  	bool has_init;
> >  	bool has_cleanup;
> >  	char	     srcversion[25];
> > +	bool need_srcversion;
> >  	// Missing namespace dependencies
> >  	struct list_head missing_namespaces;
> >  	// Actual imported namespaces
> > @@ -213,6 +214,7 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
> >  			Elf_Sym *sym, const char *symname);
> >
> >  /* sumversion.c */
> > +void sumversion_init(void);
> >  void get_src_version(const char *modname, char sum[], unsigned sumlen);
> >
> >  /* from modpost.c */
> > diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
> > index 5501d6aa0bea..4521b92ef868 100644
> > --- a/scripts/mod/sumversion.c
> > +++ b/scripts/mod/sumversion.c
> > @@ -249,7 +249,7 @@ static int parse_comment(const char *file, unsigned long len)
> >  /* FIXME: Handle .s files differently (eg. # starts comments) --RR */
> >  static bool stop_char[256];
> >
> > -static void sumversion_init(void)
> > +void sumversion_init(void)
> >  {
> >  	static bool done;
> >  	int chr;
> > @@ -402,7 +402,6 @@ static int parse_source_files(const char *objfile, struct md4_ctx *md)
> >  				     line, strerror(errno));
> >  				goto out_file;
> >  			}
> > -
> >  		}
> >
> >  	}
> >
>

--
Cheers, Lorenzo
