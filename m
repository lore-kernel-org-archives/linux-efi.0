Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7793E35674A;
	Sat, 19 Sep 2026 16:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789837073; cv=none; b=TLG/SJod9FpQL5jrwQDu38s+NEAlhxfHIKUu4dCHLNC3hmSkXvvBfyF4Zdc8HAWV9z+C+Vt8mm3uhaYKz+wnbHqLmmolGCURsU/h5CmKNyJ3jhlLFZS5N8l/Kjfgtx/bVlWr1PIKZNnNA26Z7xmiNcqedKJL7bWdqRNFI64HrKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789837073; c=relaxed/simple;
	bh=vvoDJ8lKYiIMuCHfLSf7JsyJGemVUit67i4+MUQiqmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRoN3WNDlQ0ClPlP/4K87CjeSXeVnLFpARouC0NNn8hhdSV18CLZymqDI1oJDM66xIz3eCqNQMJHPe/7SYZq3VCoN3uRedSAjo6FX/0X3E047hYAjrvBX+YaTthRM7iIO4Izrw3Ljo44cpXN2fiS2RZEF9fNX5M3ChZUiOCPBlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ib+jARSJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ib+jARSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA83C1F000FF;
	Sat, 19 Sep 2026 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789837070;
	bh=KM2tgM0uGCVk8XtquigocG7Ha/ITFid2M5zaQUDm4hQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ib+jARSJmLUOsDlTIv6OHj4xq4E/O4XHgfSasYMyRp+ithI4n9jSi9LfO7VSVfVzq
	 fAEwEVs6MPaOZa0p6cJPeyyCIQs3Ltp4Ib1xghu0J0zwWP/aDQfem9610HBBpogQ19
	 9pAze5bqN3TKajzH/HiMyUzWsJKDwmpJHciJzkoWJ5XB+KrR+SATdwTFbhKQGzHDz7
	 gEVt5gieTXgYhfd1fhpInIP5tVos/meaA3Ie61J31lGNHoa23r5N6Xa1cYy9EU4k15
	 +EWis+F9CWyyXLXiHQ9NLpyLfNxa1acVucTWZR2ydIsoeVu0JVzUIAwfvwiJz+lJoT
	 LFgHHDsyIyt8Q==
Date: Sat, 19 Sep 2026 17:57:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kees Cook <kees@kernel.org>
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
	Randy Dunlap <rdunlap@infradead.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 09/20] kbuild: implement and use depcheck to check
 dependency timestamps
Message-ID: <aq6-KMkAx7q_xLO4@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-9-9ecf4163ff36@kernel.org>
 <202609171117.35BFDCC13@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609171117.35BFDCC13@keescook>

On Thu, Sep 17, 2026 at 11:42:50AM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2026 at 05:06:19PM +0100, Lorenzo Stoakes (ARM) wrote:
> > This can be done faster in C, so implement scripts/basic/depcheck to do so.
> >
> > It does as little work as possible, reading the .cmd files from a
> > directory's targets and running stat on each dependency only a single time.
>
> Doesn't this run the risk of missing transitive deps?
>
> C.cmd:	C.o depends on A.c and B.c and B.h
> B.cmd:	B.h depends on B.data and B.script
>
> depcheck looks at C.o and B.h's times and is happy so it drops C.cmd file,
> but then see B.script has changed compared to B.h, so it keeps B.cmd,
> and then the build runs and doesn't have the C.o dep list any more,
> and C.o goes unbuilt?

No, B.h's .cmd file is still in the fragment with the full dependency list, so
make remakes B.h from B.script and C.o's saved command line is there too.

But, as you mention in the follow up :), it screws up on next bit - C.o
depending on B.h with B.h just remade. Will reply to your follow-up on that!

>
> Also, I don't think this handles if_changed commands at all? The kbuild
> rebuild condition is timestamps plus if_changed's command-line check.

It does, the fragment always has the saved command line, only the dependency
list is dropped, so if_changed compares the same as before.

>
> > diff --git a/scripts/basic/depcheck.c b/scripts/basic/depcheck.c
> > new file mode 100644
> > index 000000000000..622101c33650
> > --- /dev/null
> > +++ b/scripts/basic/depcheck.c
> > @@ -0,0 +1,441 @@
> > [...]
> > +/* What fixdep writes, see above. */
> > +#define DEPS_PREFIX		"deps_"
> > +#define DEPS_RULE_PREFIX	"$(" DEPS_PREFIX
> > +#define RULE_SUFFIX		":"
> > +#define LINE_CONTINUATION	" \\"
> > +#define WILDCARD_OPEN		"$(wildcard "
> > +#define WILDCARD_CLOSE		")"
> > +#define CMD_SUFFIX		".cmd"
> > [...]
> > +static bool is_blank(char chr)
> > [...]
> > +static bool str_ends_with(const char *str, const char *suffix)
> > [...]
> > +static bool line_starts_with(const struct line *line, const char *prefix)
> > [...]
> > +static bool line_ends_with(const struct line *line, const char *suffix)
> > [...]
> > +static bool line_is_blank(const struct line *line)
> > [...]
> > +static bool line_is_continued(const struct line *line)
> > [...]
> > +static void line_strip_continuation(struct line *line)
> > [...]
> > +static void line_trim(struct line *line)
> > [...]
> > +static bool next_line(const char **pos, const char *end, struct line *line)
>
> There is a lot of sting handling in here. I know you're going for speed,
> but it just feels like a python script doing all this would be much more
> readable without wrecking speed compared to C much. Yes, C will win out,
> but the maintainability of this helper does not fill me with joy. :P

Well I had the LLM look at that and for an allmodconfig python's startup time
would take 40s of CPU time _alone_ and it'd kill the no op improvement. So C it
has to be :)

>
> > [...]
> > +static const struct dep *lookup_dep(const char *path)
> > +{
> > +	const unsigned int key = hash_str(path);
> > +	struct dep *dep;
> > +	struct stat st;
> > +
> > +	hash_for_each_possible(dep_table, dep, hnode, key) {
> > +		if (!strcmp(dep->path, path))
> > +			return dep;
> > +	}
> > +
> > +	dep = xmalloc(sizeof(*dep) + strlen(path) + 1);
> > +	strcpy(dep->path, path);
> > +	dep->exists = !stat(path, &st);
> > +	if (dep->exists)
> > +		dep->mtime = st.st_mtim;
>
> I realize you only check "mtime" after an "exists" check, but I bristle
> at leaving a time-stamp uninitialized. Can we just add an "else
> dep->mtime = 0" here?

Ack, done for v4!

>
> -Kees
>
> --
> Kees Cook

--
Cheers, Lorenzo
