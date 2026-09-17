Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14072DB79F;
	Thu, 17 Sep 2026 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668453; cv=none; b=VkAuqxq/tIy0WpgwKii50A7leUuYmCwNMMUvs9Ba0AQEgIbSLSaANMmrGLaWGiL3BJiusStA1plEFzVpYOLhmZqEsgg3h3g5pYenOOXSiOQlhSx8MYvV04UBzoXOtHt4DgUokSyOTxmKrZt9J0jleNqPSOhp1liVELkL0LGG/v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668453; c=relaxed/simple;
	bh=/WUUCUCrY0n8UD4Ij3SPFZU1RUDohk4x45hKVB/ltwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npVHQXhL1LN4TTx6P5yByJW3vu3cSBaU/7NpVDZFKVmF2PB6sAkeEOkwC7PvOvwKv0C6C5UhdTf18DYYIPak6Ww6WlOMVFdLWDWyH2Mh/nvsdIEM8gZtPNcgZPZjb5YJEGSAcf8Me/tsYCFkvyxSVnfhGFOfABjXwu8dvcCdE5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bMn7ORv1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bMn7ORv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6921F00893;
	Thu, 17 Sep 2026 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789668451;
	bh=viQgRYHIEFe0k/ff14IbY6lVzAdW1zkXbr9bUlMI+rg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bMn7ORv1g80cagRJ3YCff/5zL4g3PXxuA1qi00EmB4bZvEFGoi4CJ4yHb+g9s6BbQ
	 3MrWL5Y4JWcSM7AeU+paNQHYmuTYxoDJzvW4h9OLrKwcawgkhMWH4Efhh/dfUkxWb3
	 rYb58mAO4E8oasOIIFZNouqnWjg0yADb00w7b0W3R0tDx1yZ4V4NOVL+pNgEieEYxc
	 IB5HpeREfzlaN1Jr0ZNb6M9MqvnYIfgvDKlU7ECCSpNnKCbvEJJFqQcG7j1U7jfuEJ
	 MNf2LAr/lKaT/2t1mIHT1mcvP8VMQcadrPLWdnTAkAPwr1qXe0+GS5yOrN6tHG6bDy
	 0ontRWLXZSnWg==
Date: Thu, 17 Sep 2026 11:07:31 -0700
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
Subject: Re: [PATCH v3 07/20] kallsyms: reimplement mksysmap in C
Message-ID: <202609171046.146CAE972B@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-7-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-7-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:17PM +0100, Lorenzo Stoakes (ARM) wrote:
> mksysmap is a sed script consisting of 30 patterns which link-vmlinux.sh
> uses to generate *.syms files, and which kallsyms is then called against to
> generate *.kallsyms files, with the final vmlinux build ultimately
> generating System.map.
> 
> For an x86-64 allmodconfig build, this involves three nm runs over a 250
> MiB file and half a million lines written and read each time - 0.5s per
> pass for llvm-nm, and 0.2s for GNU nm, with parsing on top of that.
> 
> This is unnecessary, instead have kallsyms simply read the ELF file
> directly making use of the existing elf-parse library in scripts/.
> 
> This changes kallsyms such that its input is no longer the output from nm,
> but rather an ELF file.
> 
> However, if the input file is empty, it outputs an empty table, which
> retains the same behaviour on first pass that the build system expects.
> 
> System.map is byte-identical to nm | mksysmap for GNU nm and llvm-nm on
> two x86 configurations each, and for llvm-nm on arm64, arm, s390 and
> loongarch defconfigs, so are the kallsyms tables of every pass.
> 
> Relinking vmlinux, link steps included:
> 
>                         before    after
>   allmodconfig clang     9.1s     7.9s
>   allmodconfig gcc       7.8s     7.6s
>   defconfig clang        3.7s     3.0s
>   defconfig gcc          3.5s     3.4s
> 
> Whole build, 128-thread Threadripper 9980X, best of N runs:
> 
>                                          before   after     delta
>                                          -------------------------------
>   x86 defconfig, touch mm/vma.c, gcc        9.1s     8.6s    -0.43s (-5%)
>   x86 defconfig, touch mm/vma.c, clang      9.0s     8.0s     -1.1s (-12%)
>   x86 defconfig, clean, gcc                29.5s    28.9s    -0.64s (-2%)
>   x86 defconfig, clean, clang              31.2s    29.8s     -1.4s (-5%)
>   x86 allmodconfig, touch mm/vma.c, gcc    35.8s    35.0s    -0.77s (-2%)
>   x86 allmodconfig, touch mm/vma.c, clang  35.8s    33.7s     -2.0s (-6%)
> 
> Assisted-by: LLM
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  scripts/Makefile          |   4 +-
>  scripts/kallsyms-sysmap.c | 269 ++++++++++++++++++++++++++++++++++++++++++++++
>  scripts/kallsyms.c        | 162 ++++++++++++++++------------
>  scripts/kallsyms.h        |  44 ++++++++
>  scripts/link-vmlinux.sh   |  15 +--
>  scripts/mksysmap          |  94 ----------------
>  6 files changed, 415 insertions(+), 173 deletions(-)
> 
> diff --git a/scripts/Makefile b/scripts/Makefile
> index 3434a82a119f..d46932113b5f 100644
> --- a/scripts/Makefile
> +++ b/scripts/Makefile
> @@ -3,7 +3,7 @@
>  # scripts contains sources for various helper programs used throughout
>  # the kernel for the build process.
>  
> -hostprogs-always-$(CONFIG_KALLSYMS)			+= kallsyms
> +hostprogs-always-y				+= kallsyms
>  hostprogs-always-$(BUILD_C_RECORDMCOUNT)		+= recordmcount
>  hostprogs-always-$(CONFIG_BUILDTIME_TABLE_SORT)		+= sorttable
>  hostprogs-always-$(CONFIG_ASN1)				+= asn1_compiler
> @@ -13,6 +13,7 @@ hostprogs-always-$(CONFIG_RUST_KERNEL_DOCTESTS)		+= rustdoc_test_builder
>  hostprogs-always-$(CONFIG_RUST_KERNEL_DOCTESTS)		+= rustdoc_test_gen
>  hostprogs-always-$(CONFIG_TRACEPOINTS)			+= tracepoint-update
>  
> +kallsyms-objs := kallsyms.o kallsyms-sysmap.o elf-parse.o
>  sorttable-objs := sorttable.o elf-parse.o
>  tracepoint-update-objs := tracepoint-update.o elf-parse.o
>  
> @@ -30,6 +31,7 @@ rustdoc_test_builder-rust := y
>  rustdoc_test_gen-rust := y
>  
>  HOSTCFLAGS_tracepoint-update.o = -I$(srctree)/tools/include
> +HOSTCFLAGS_kallsyms-sysmap.o = -I$(srctree)/tools/include
>  HOSTCFLAGS_elf-parse.o = -I$(srctree)/tools/include
>  HOSTCFLAGS_sorttable.o = -I$(srctree)/tools/include
>  HOSTLDLIBS_sorttable = -lpthread
> diff --git a/scripts/kallsyms-sysmap.c b/scripts/kallsyms-sysmap.c
> new file mode 100644
> index 000000000000..64b2e11d0344
> --- /dev/null
> +++ b/scripts/kallsyms-sysmap.c
> @@ -0,0 +1,269 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Obtain symbols from vmlinux for usage by kallsyms. Replaces mksysmap.
> + *
> + * To retain compatibility, it provides the same output as nm, only faster.
> + */
> +
> +#include <ctype.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <xalloc.h>
> +
> +#include "elf-parse.h"
> +#include "kallsyms.h"
> +
> +/* The mapped file and its symbol table. */
> +struct elf_file {
> +	void *base;
> +	size_t size;
> +	const char *shdrs;
> +	unsigned int shnum, shentsize;
> +	const char *shstrtab;
> +	Elf_Shdr *symtab;
> +	const char *strtab;
> +	size_t nr_syms;
> +};
> +
> +/* What mksysmap dropped from System.map, by name. */
> +static const char *const sysmap_omit_prefixes[] = {
> +	"$", ".L", "__efistub_", "__pi_$", "__pi_.L", "__kvm_nvhe_$",
> +	"__kvm_nvhe_.L", "__kcfi_typeid_", "__kvm_nvhe___kcfi_typeid_",
> +	"__pi___kcfi_typeid_", "__crc_", "__kstrtab_", "__kstrtabns_",
> +	"__mod_device_table__",
> +};

I really think these need to be 1 per line with the comments from
scripts/mksysmap retained. It's going to be changed over time, and we
want to be able to review the rationale for entries without having to
dig through commit history.

> +static const char *const sysmap_omit_suffixes[] = {
> +	"_from_arm", "_from_thumb", "_veneer",
> +};
> +static const char *const sysmap_omit_names[] = {
> +	"L0", "_SDA_BASE_", "_SDA2_BASE_",
> +};

Same for these 2 tables.

> +
> +/* __<alnum>*Thunk_: the linker's range extension thunks on arm. */
> +static bool is_range_thunk(const char *name)
> +{
> +	const char *p;
> +
> +	if (!string_starts_with(name, "__"))
> +		return false;
> +	for (p = name + 2; isalnum((unsigned char)*p); p++)
> +		;
> +	return p - name >= 7 && *p == '_' && strncmp(p - 5, "Thunk", 5) == 0;
> +}
> +
> +/* __UNIQUE_ID_modinfo_<n>: the MODULE_INFO() strings of built-in code. */
> +static bool is_modinfo_id(const char *name)
> +{
> +	static const char prefix[] = "__UNIQUE_ID_modinfo_";
> +	const char *p;
> +
> +	if (!string_starts_with(name, prefix))
> +		return false;
> +	for (p = name + strlen(prefix); isdigit((unsigned char)*p); p++)
> +		;
> +	return !*p;
> +}

I'm less excited about these "open coded" regular expression matches.
Having to do this feels like it'll make future exceptions annoying to
add. Can't there be another class of table that is just regular
expressions? It is probably faster to keep the prefix/suffix/exact
tables as-is, but is_range_thunk() and is_modinfo_id() just feel clunky
compared to the more expressive re, e.g. r'^__UNIQUE_ID_modinfo[0-9]*$'

> +static bool sysmap_omits(const char *name, char type)
> +{
> +	size_t i;
> +
> +	/* Absolute, undefined and debugging symbols. */
> +	if (type == 'a' || type == 'N' || type == 'U' || type == 'w')
> +		return true;
> +
> +	for (i = 0; i < ARRAY_SIZE(sysmap_omit_prefixes); i++)
> +		if (string_starts_with(name, sysmap_omit_prefixes[i]))
> +			return true;
> +	for (i = 0; i < ARRAY_SIZE(sysmap_omit_suffixes); i++)
> +		if (string_ends_with(name, sysmap_omit_suffixes[i]))
> +			return true;
> +	for (i = 0; i < ARRAY_SIZE(sysmap_omit_names); i++)
> +		if (strcmp(name, sysmap_omit_names[i]) == 0)
> +			return true;
> +
> +	return is_range_thunk(name) || is_modinfo_id(name) ||
> +	       strstr(name, ".long_branch.") || strstr(name, ".plt_branch.");

And then mixing data-driven search with in-line patterns I don't like.
The .long_branch. and .plt_branch. matches should be in a new "any
position" table, IMO.

> +/* nm's letter for a symbol defined in a section, as BFD classifies it. */
> +static char section_symbol_type(Elf_Shdr *shdr, const char *secname)
> +{
> +	static const char *const debug_prefixes[] = {
> +		".debug", ".zdebug", ".gnu.debuglto_.debug_",
> +		".gnu.linkonce.wi.", ".line", ".stab",
> +	};

I worry about maintenance overhead on this: are we going to have to
chase changes to "nm" when other debug prefixes get added here?

> +	const uint64_t flags = shdr_flags(shdr);
> +	size_t i;
> +
> +	if (flags & SHF_EXECINSTR)
> +		return 't';
> +	if (flags & SHF_ALLOC) {
> +		if (shdr_type(shdr) == SHT_NOBITS)
> +			return 'b';
> +		return flags & SHF_WRITE ? 'd' : 'r';
> +	}
> +	for (i = 0; i < ARRAY_SIZE(debug_prefixes); i++)
> +		if (string_starts_with(secname, debug_prefixes[i]))
> +			return 'N';
> +	if (shdr_type(shdr) != SHT_NOBITS && !(flags & SHF_WRITE))
> +		return 'n';
> +	return '?';

And to that end: instead of "?" shouldn't this fail hard when a section
symbol type is unknown to the tool?

> +}
> +
> +/* The letter nm prints for a symbol, or 0 for one it leaves out. */
> +static char elf_symbol_type(const struct elf_file *elf, Elf_Sym *sym)
> +{
> +	unsigned int bind = sym_bind(sym), type = sym_type(sym);
> +	unsigned int shndx = sym_shndx(sym);
> +	Elf_Shdr *shdr;
> +	char c;
> +
> +	if (type == STT_SECTION || type == STT_FILE)
> +		return 0;
> +	if (shndx == SHN_COMMON)
> +		return 'C';
> +	if (shndx == SHN_UNDEF) {
> +		if (bind == STB_WEAK)
> +			return type == STT_OBJECT ? 'v' : 'w';
> +		return 'U';
> +	}
> +	if (type == STT_GNU_IFUNC)
> +		return 'i';
> +	if (bind == STB_WEAK)
> +		return type == STT_OBJECT ? 'V' : 'W';
> +	if (bind == STB_GNU_UNIQUE)
> +		return 'u';
> +	if (bind != STB_GLOBAL && bind != STB_LOCAL)
> +		return '?';
> +
> +	if (shndx == SHN_ABS) {
> +		c = 'a';
> +	} else if (shndx < elf->shnum) {
> +		shdr = elf_section(elf, shndx);
> +		c = section_symbol_type(shdr, elf_section_name(elf, shdr));
> +	} else {
> +		return '?';

Same concerns...

> +	}
> +
> +	return bind == STB_GLOBAL ? toupper(c) : c;
> +}
> +
> +/* nm -n order: by address, then by name. */
> +static int compare_symbols(const void *a, const void *b)
> +{
> +	const struct sysmap_symbol *sa = a, *sb = b;
> +
> +	if (sa->addr != sb->addr)
> +		return sa->addr < sb->addr ? -1 : 1;
> +	return strcmp(sa->name, sb->name);
> +}
> +
> +static void elf_open(struct elf_file *elf, const char *path)
> +{
> +	Elf_Ehdr *ehdr;
> +	unsigned int i;
> +
> +	elf->base = elf_map_ro(path, &elf->size, (1 << ET_EXEC) | (1 << ET_DYN));
> +	if (!elf->base)
> +		exit(EXIT_FAILURE);
> +
> +	ehdr = elf->base;
> +	elf->shdrs = (const char *)elf->base + ehdr_shoff(ehdr);
> +	elf->shnum = ehdr_shnum(ehdr);
> +	elf->shentsize = ehdr_shentsize(ehdr);
> +	elf->shstrtab = (const char *)elf->base +
> +			shdr_offset(elf_section(elf, ehdr_shstrndx(ehdr)));
> +
> +	for (i = 0; i < elf->shnum && !elf->symtab; i++)
> +		if (shdr_type(elf_section(elf, i)) == SHT_SYMTAB)
> +			elf->symtab = elf_section(elf, i);
> +
> +	if (!elf->symtab) {
> +		fprintf(stderr, "%s: no symbol table\n", path);
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	elf->strtab = (const char *)elf->base +
> +		      shdr_offset(elf_section(elf, shdr_link(elf->symtab)));
> +	elf->nr_syms = shdr_size(elf->symtab) / shdr_entsize(elf->symtab);
> +}

These 2 functions kind of feel like they should live in elfparse instead?

> +
> +/* The symbols "nm -n | mksysmap" would list, in that order. */
> +static struct sysmap_symbol *elf_read_symbols(const struct elf_file *elf,
> +					   size_t *nr_kept)
> +{
> +	struct sysmap_symbol *syms = xmalloc(elf->nr_syms * sizeof(*syms));
> +	size_t i, n = 0;
> +
> +	for (i = 1; i < elf->nr_syms; i++) {
> +		Elf_Sym *sym = elf_symbol(elf, i);
> +		const char *name = elf->strtab + sym_name(sym);
> +		char type = elf_symbol_type(elf, sym);
> +
> +		if (!type || sysmap_omits(name, type))
> +			continue;
> +
> +		syms[n].addr = sym_value(sym);
> +		syms[n].name = name;
> +		syms[n].type = type;
> +		n++;
> +	}
> +
> +	qsort(syms, n, sizeof(*syms), compare_symbols);
> +	*nr_kept = n;
> +	return syms;
> +}

And this one too, with maybe a "maybe_omit" callback passed in so this
mksysmap could pass sysmap_omits in as?

> -static void read_map(const char *in)
> +static void add_table_entry(struct sym_entry *sym)
>  {
> -	FILE *fp;
> -	struct sym_entry *sym;
> -	char *buf = NULL;
> -	size_t buflen = 0;
> +	sym->seq = table_cnt;
>  
> -	fp = fopen(in, "r");
> -	if (!fp) {
> -		perror(in);
> -		exit(1);
> +	if (table_cnt >= table_size) {
> +		table_size += 10000;
> +		table = xrealloc(table, sizeof(*table) * table_size);

I realize this is just moving logic around, but traditional xrealloc
loop uses doubling. I think this was linear only because it wanted to
jump-start the initial allocation size to 10000 entries. Could be:

	table_size = table_size ? table_size * 2 : 10000;

But maybe even that initial allocation number should be bumped up?

> [...]
> +	if (optind + 1 == argc) {
> +		read_elf(in, sysmap_out);
> +		if (fclose(sysmap_out)) {

This needs to check ferror() too.

> +			perror(sysmap);
> +			exit(EXIT_FAILURE);
> +		}
> +		return 0;
> +	}
> +
>  	out_bin_name = argv[optind + 1];
>  	out_bin_file = fopen(out_bin_name, "w");
>  	if (!out_bin_file) {
> @@ -852,7 +868,11 @@ int main(int argc, char **argv)
>  		exit(EXIT_FAILURE);
>  	}
>  
> -	read_map(argv[optind]);
> +	read_elf(in, sysmap_out);
> +	if (sysmap_out && fclose(sysmap_out)) {

Same: this needs to check ferror() too.


-Kees

-- 
Kees Cook
