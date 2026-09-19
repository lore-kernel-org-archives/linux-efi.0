Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAF928DB54;
	Sat, 19 Sep 2026 17:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789837386; cv=none; b=Nc9KSe3fUvtkTexr522uxL2YXoZ4R7duOuf7OIoU4Gp2uYJzv2R+AzD+Op1yCKs61tADbl6UHqnSz8uR65l1aKoUTE30M3/qJvWwSKVyqUilGKECYiu3S85EuvGq5Hub419si/BX+xCN0Hs8P9YxR/ANUvG2vNYtjYnhf23/YsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789837386; c=relaxed/simple;
	bh=TAa1bMwkQvIf/oN+Ztl931Gdz6WHWnyxSiV0qpQhvQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCWeBq6487/Y/PLDfii+6TfIFI7+bCK5RVfiix1E+vVCrVETL5Ev01L9qZxF3F74HlocGqVbHzLvTFRvLooN0pCR36ir2DLW+q2WDZQGZq5sAgCmsEcIQZE0ffJTyGi37wnMpVCc1RS9ykHxqMhb1jvPU68oTk00mnyL7Y4M9qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9VqRAss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9VqRAss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FD21F000FF;
	Sat, 19 Sep 2026 17:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789837380;
	bh=8Ps8EuU/pBUVLBEfXx0I7uLw4cLhs9w6iC1Fghr3+O8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e9VqRAss7Iao5If7P13+rkpzpzvixxSAziXX7dNQfp0tPH65Y2m15feiyrFl9un3D
	 yPLife1BNLjYaANsWnWgHahhGc4+LGvc6Zjkm+OcfOuZuPLQ/0SP88mC9QrTG7j7mw
	 Dd5h0IY9GnZHfv9qBTxZHTV3BF8mjNHoa+TGDGydjjErrIU08/BvbSPGbsolfYvnZZ
	 LNqH/8gLvDhPMr/O56E/cZWED3EBd6/Kj5M7XmwtAQ2WGxjCHINYzaDNYFCD8w3zt7
	 SJXZi+D732+gaND1y2WEl8d3zKE8m5FcCgh5O4Zn9FYUhzLGafZGo/IubNz/w0YGZL
	 GtcPOr6EmL8Xg==
Date: Sat, 19 Sep 2026 18:02:46 +0100
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
Message-ID: <aq6_JcIy6gOsN4oa@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-9-9ecf4163ff36@kernel.org>
 <202609171117.35BFDCC13@keescook>
 <202609171229.31BB336E1@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609171229.31BB336E1@keescook>

On Thu, Sep 17, 2026 at 01:59:26PM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2026 at 11:42:50AM -0700, Kees Cook wrote:
> > On Thu, Sep 17, 2026 at 05:06:19PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > This can be done faster in C, so implement scripts/basic/depcheck to do so.
> > >
> > > It does as little work as possible, reading the .cmd files from a
> > > directory's targets and running stat on each dependency only a single time.
> >
> > Doesn't this run the risk of missing transitive deps?
> >
> > C.cmd:	C.o depends on A.c and B.c and B.h
> > B.cmd:	B.h depends on B.data and B.script
> >
> > depcheck looks at C.o and B.h's times and is happy so it drops C.cmd file,
> > but then see B.script has changed compared to B.h, so it keeps B.cmd,
> > and then the build runs and doesn't have the C.o dep list any more,
> > and C.o goes unbuilt?
> >
> > Also, I don't think this handles if_changed commands at all? The kbuild
> > rebuild condition is timestamps plus if_changed's command-line check.
>
> tl;dr: I spent way too long looking at this. I think my conclusion is
> "Hm, this makes some cases of missed Makefile deps on generated files
> harder to find, but there don't *appear* to be any obviously wrong
> instances of this in the tree."
>
> Long version:
>
> There does appear to be a problem in the case of generated targets where
> the Makefile deps are build-order correct but lack explicit deps. As
> in, a clean build generates the needed dependencies due to some prior
> explicit Makefile rule dependency, and a later source-level "#include"
> for the generated file exists (and the build doesn't fail since the
> included file got generated before the source that "#include"d it got
> built), and then the normal dep tracking (-Wp,-MMD,... -> .cmd) catches
> it and any direct changes to that dep would normally get noticed going
> forward on incremental builds.
>
> However, with the depcheck .cmd pruning, changes to transitive deps
> (either via file contents or Kconfig options) will go unnoticed during
> incremental builds without that explicit dep (but stock doesn't miss
> it). Though actually it's kind of worse because it'll get noticed on
> rebuild #N+1 for N level of transitive depth, so something will break,
> and then you build again, and the changes from 2 builds ago suddenly
> get rebuilt...
>
> I think you maybe encountered an instance of this in your series, too,
> but it got exposed due to a clean build no longer having the ordering
> correct:
> https://lore.kernel.org/lkml/20260917-build-speedup-v3-18-9ecf4163ff36@kernel.org/
>
> See the trailing diff for a demo:
>
>
>   git apply demo.diff
>   make O=b defconfig
>   # simulate a earlier-stage header generation...
>   make O=b lib/byfile_anchor.o lib/byconf_anchor.o
>   make O=b lib/
>
>   # trigger 1: the header's input file changes
>   echo FROMFILE-two > lib/byfile_gen.in
>   make O=b lib/
>
>   # trigger 2: a Kconfig value changes; no file is touched
>   ./scripts/config --file b/.config --set-str LOCALVERSION -demo2
>   make O=b lib/
>
>   # what each object ended up holding
>   strings b/lib/byfile_anchor.o | grep FROMFILE-    # FROMFILE-two   both trees
>   strings b/lib/byfile_victim.o | grep FROMFILE-    # FROMFILE-two   stock
>                                                     # FROMFILE-one   patched  <-- stale
>
>   strings b/lib/byconf_anchor.o | grep CONF-        # CONF--demo2    both trees
>   strings b/lib/byconf_victim.o | grep CONF-        # CONF--demo2    stock
>                                                     # CONF-          patched  <-- stale
>
>
> This means adding depcheck would silently expose any current (and future)
> missing explicit deps on generated files where those files get generated
> by either an earlier build stage or an earlier rule. :(
>
> I went looking for the kind of missed Makefile dep for a generated file,
> and while it's not a very grep-able condition, I did look at stuff that
> fell into include/generated/, but it's safe due to the prepare/archprepare
> ordering AFAICT. So then I looked at places where -I had $(obj) added to
> it, and all of those seemed to have explicit Makefile deps too. Well, all
> except for arch/x86/boot/compressed/sev-handle-vc.c which includes
> "../../lib/inat.c" but that seems safe today due to ordering from
> arch/x86/lib/ being needed before arch/x86/boot/compressed/.
>
> So, yeah, it makes me nervous, and it may make incremental builds less
> idempotent. But I can't really find extant problems and the demo is
> slightly contrived, but not exactly an impossible situation.

Ack thanks for this!

There is definitely an issue here, your example is fine in the stock kernel
but one run late in v3.

Solution is to have depcheck treat any dependency that is itself a target
of the same run as never being 'fresh' (it already reads every .cmd file in
the directory so has all the dependency information it needs), so that's
fixed in v4.

Confirmed that it fixes the demo'd bug here, that touching a header
rebuilds exactly the same objects as it did before and that noop build perf
was not harmed by the change.

>
> -Kees
>
>
> diff --git a/lib/Makefile b/lib/Makefile
> index dfab958327c5c..aed0bd9eb7d6a 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -350,3 +350,36 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
>  obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
>
>  subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
> +
> +# --- depcheck demo ---
> +obj-y += byfile_anchor.o byfile_victim.o byconf_anchor.o byconf_victim.o
> +
> +quiet_cmd_byfile = GENFILE $@
> +      cmd_byfile = printf '\#define BYFILE_STR "%s"\n' "$$(cat $<)" > $@
> +
> +quiet_cmd_byconf = GENCONF $@
> +      cmd_byconf = printf '\#define BYCONF_STR "CONF-%s"\n' '$(CONFIG_LOCALVERSION)' > $@
> +
> +# Regenerated when its input file changes.
> +$(obj)/byfile_gen.h: $(src)/byfile_gen.in FORCE
> +	$(call if_changed,byfile)
> +
> +# No input file: regenerated only when its command line changes, which here
> +# means when CONFIG_LOCALVERSION changes. No file is touched.
> +$(obj)/byconf_gen.h: FORCE
> +	$(call if_changed,byconf)
> +
> +targets += byfile_gen.h byconf_gen.h
> +
> +# The anchors declare the dependency. That is what generates the headers on
> +# a clean build: fixdep only records a header once the object has compiled
> +# successfully, so on a first build there is no .cmd file to rely on. The
> +# victims include the same headers without declaring them, so the only
> +# record of that edge is the deps_ list in their .cmd files.
> +$(obj)/byfile_anchor.o: $(obj)/byfile_gen.h
> +$(obj)/byconf_anchor.o: $(obj)/byconf_gen.h
> +
> +CFLAGS_byfile_anchor.o += -I$(obj)
> +CFLAGS_byfile_victim.o += -I$(obj)
> +CFLAGS_byconf_anchor.o += -I$(obj)
> +CFLAGS_byconf_victim.o += -I$(obj)
> diff --git a/lib/byconf_anchor.c b/lib/byconf_anchor.c
> new file mode 100644
> index 0000000000000..8035eaa352a3b
> --- /dev/null
> +++ b/lib/byconf_anchor.c
> @@ -0,0 +1,3 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "byconf_gen.h"
> +const char byconf_anchor_marker[] = BYCONF_STR;
> diff --git a/lib/byconf_victim.c b/lib/byconf_victim.c
> new file mode 100644
> index 0000000000000..285a8de8bdf6e
> --- /dev/null
> +++ b/lib/byconf_victim.c
> @@ -0,0 +1,3 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "byconf_gen.h"
> +const char byconf_victim_marker[] = BYCONF_STR;
> diff --git a/lib/byfile_anchor.c b/lib/byfile_anchor.c
> new file mode 100644
> index 0000000000000..9ea0b8ad55963
> --- /dev/null
> +++ b/lib/byfile_anchor.c
> @@ -0,0 +1,3 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "byfile_gen.h"
> +const char byfile_anchor_marker[] = BYFILE_STR;
> diff --git a/lib/byfile_gen.in b/lib/byfile_gen.in
> new file mode 100644
> index 0000000000000..7da9e5e0cd83c
> --- /dev/null
> +++ b/lib/byfile_gen.in
> @@ -0,0 +1 @@
> +FROMFILE-one
> diff --git a/lib/byfile_victim.c b/lib/byfile_victim.c
> new file mode 100644
> index 0000000000000..763c5ef8f1514
> --- /dev/null
> +++ b/lib/byfile_victim.c
> @@ -0,0 +1,3 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "byfile_gen.h"
> +const char byfile_victim_marker[] = BYFILE_STR;
>
>
> --
> Kees Cook

--
Cheers, Lorenzo
