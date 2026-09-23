Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19D73E638D;
	Wed, 23 Sep 2026 17:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184120; cv=none; b=VtshV8zkdYMIphAj6qOvZhW+isgztfMsxaiZBmbMXk/Ihr7Wh9LHxL9j+CQx8bNwZqmgd4dHFt5emZhErHTR163bwCQOhyGh5yxe7e0S4i5fNcDhO6v6Ndxkeq2Ha6jKPNA5CqCcf50dMOpqKBGSrKwTxrVwXi/u9PnUz8YyTsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184120; c=relaxed/simple;
	bh=aJWLamm/eoktlyXTzsOgfNH7XQ176gtamMWPuQOOBas=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tun/nK9RZgwAQX/IrZbpRg+zX4haf0hHnI3PTaXVxXR9Rwjh0vDc7XHeHsXoIq2KwgZ8R9I9ZXqMzW6Y/It/Bal0g8FwHzTzfkdj2id2Nu+D4q7EUualbMFJfDlIz2B0Mr1Pa77gFBrmGw9hn4hZT7AY1GcEFjb5YtHFnotaIdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lYUbZGgl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lYUbZGgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7041F00898;
	Wed, 23 Sep 2026 17:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790184118;
	bh=F36zB3TpAmg2T+DbkpmIrcomfVdouXy+Zww1GXGCAOQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lYUbZGgl9IRhManv28ZjkgoGdTU6BwVX748h6h8D5i6ybhwkDF1pnVhuBu7ilVyoW
	 eSqOIj7e83feUnGPwIzchnAIIGI3uFGlNMM0Vb5+6vly0Lm/98CCnL3FIGegmRIqbC
	 4RDLmK1QsDTrr43/um9pYA2gBMNV9VZ/QW4DL7dZbVw780hFkDt3gxbViKqcqs8AT2
	 iebgWegbB+rEbFGxEiSOgEpZsrOfTW81BhZsl8tRVDG7v0yUTyECL1FoSVvy59MibH
	 CNwaF79JIsCfPmVmAJPq0Ndw8jOuay3ryigu8ZqqBTBi9B4WIF/UkcgeNjh+VSEL6W
	 Ofu+uqvxUGbfQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 23 Sep 2026 18:18:06 +0100
Subject: [PATCH v4 17/22] objtool: cache relocations, do less work,
 eliminate relocation hash
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-build-speedup-v4-17-73128809a4a4@kernel.org>
References: <20260923-build-speedup-v4-0-73128809a4a4@kernel.org>
In-Reply-To: <20260923-build-speedup-v4-0-73128809a4a4@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, 
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 linux-hardening@vger.kernel.org, Petr Pavlu <petr.pavlu@suse.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=14487; i=ljs@kernel.org;
 h=from:subject:message-id; bh=aJWLamm/eoktlyXTzsOgfNH7XQ176gtamMWPuQOOBas=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2cF4JnbbAzLtNMMRzz2f5ssNTOPaq1sjVGQtLWyaYW
 37q+RXYUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIlMr2Zk6OE78t9x71a7hf3h
 Ee++ZwZKXxRYKNaua8ixaNavvP4N6xkZ1pk11RmE9d0trxaQP+awQkTrS1H3idUHV7DxXEl49M+
 fCQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Instruction relocations are looked up by destination in objtool via a hash
which is keyed on a 16-byte (OFFSET_STRIDE) window within the section being
walked.

It iterates through each 16-byte window, looking up relocations over
several passes, before moving on to the next 16-byte window, caching only
when a relocation is not found saving further lookups in this case.

Improve upon this by introducing a per-section relocation cache storing the
first relocation at or after each 64-byte window of data (an empirically
determined index range), indexed by chunk.

The lookup is implemented an array lookup and touches no shared state, so
can be used from multiple threads.

The index runs over the relocations in offset order. Usually this is how
they are input, however if not, each section is sorted once, storing
their offsets in reloc_order[].

This is done lazily on lookup, so nothing pays the cost that doesn't have
to, and if everything is sorted nothing does.

The output of objtool before and after this change was confirmed to be
byte-for-byte identical both for x86_64 defconfig and allmodconfig with
gcc and clang.

objtool on the gcc allmodconfig vmlinux.o goes from 10.5s to 9.0s, clang
from 9.8s to 8.3s and gcc defconfig from 2.08s to 1.79s, with peak memory
down ~90 MiB on allmodconfig.

Similar performance was also noted on a worst case scenario for unsorted
input (gcc but lld for linking), which confirms that the sorting mechanism
works correctly with little overhead.

objtool on vmlinux.o is on the serial tail of every build that links
vmlinux, no-op builds are unchanged.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 defconfig, touch mm/vma.c, gcc        8.3s     8.2s    -0.14s (-2%)
  x86 defconfig, touch mm/vma.c, clang      7.6s     7.3s    -0.25s (-3%)
  x86 defconfig, clean, gcc                28.9s    28.6s    -0.22s (-1%)
  x86 defconfig, clean, clang              29.4s    29.1s    -0.28s (-1%)
  x86 allmodconfig, touch mm/vma.c, gcc    29.4s    28.0s     -1.4s (-5%)
  x86 allmodconfig, touch mm/vma.c, clang  27.9s    26.2s     -1.7s (-6%)

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/objtool/elf.c                 | 280 ++++++++++++++++++++++++++++--------
 tools/objtool/include/objtool/elf.h |  10 +-
 2 files changed, 221 insertions(+), 69 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 98a110e3e8f5..bd463b5df38c 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -316,35 +316,220 @@ struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *nam
 	return NULL;
 }
 
-/* If there are multiple matches, return the first one in the range */
+static bool is_dwarf_section(struct section *sec)
+{
+	return !strncmp(sec->name, ".debug_", 7);
+}
+
+/* Index the first relocation at or after each 64 byte window of the base. */
+#define RELOC_CACHE_INDEX_SHIFT	6
+
+static unsigned long reloc_cache_index(unsigned long offset)
+{
+	return offset >> RELOC_CACHE_INDEX_SHIFT;
+}
+
+static void reloc_cache_free(struct section *rsec)
+{
+	free(rsec->reloc_cache);
+	free(rsec->reloc_order);
+	rsec->reloc_cache = NULL;
+	rsec->reloc_order = NULL;
+	rsec->nr_cache_windows = 0;
+	rsec->nr_indexed = 0;
+	rsec->sorted = false;
+}
+
+/* The relocation at a position of the section's offset order. */
+static struct reloc *reloc_at(struct section *rsec, unsigned int pos)
+{
+	unsigned int reloc_idx = pos;
+
+	if (rsec->reloc_order)
+		reloc_idx = rsec->reloc_order[pos];
+
+	return &rsec->relocs[reloc_idx];
+}
+
+static bool relocs_in_order(struct section *rsec)
+{
+	const unsigned int nr_relocs = sec_num_entries(rsec);
+	unsigned int i;
+
+	for (i = 1; i < nr_relocs; i++) {
+		struct reloc *prev = &rsec->relocs[i - 1];
+		struct reloc *reloc = &rsec->relocs[i];
+
+		if (reloc_offset(reloc) < reloc_offset(prev))
+			return false;
+	}
+
+	return true;
+}
+
+/* qsort() passes no context, so the relocations being sorted live here. */
+static struct reloc *sort_relocs;
+
+static int compare_reloc_order(const void *a, const void *b)
+{
+	const unsigned int *idx_a = a;
+	const unsigned int *idx_b = b;
+	const unsigned long offset_a = reloc_offset(&sort_relocs[*idx_a]);
+	const unsigned long offset_b = reloc_offset(&sort_relocs[*idx_b]);
+
+	if (offset_a < offset_b)
+		return -1;
+	if (offset_a > offset_b)
+		return 1;
+
+	/* Equal offsets stay in file order. */
+	if (*idx_a < *idx_b)
+		return -1;
+	return 1;
+}
+
+/*
+ * gcc emits the relocations of its jumps in a second pass, so its objects,
+ * and a vmlinux.o lld links from them, are out of order: sort them once.
+ */
+static int reloc_order_build(struct section *rsec)
+{
+	const unsigned int nr_relocs = sec_num_entries(rsec);
+	unsigned int i;
+
+	rsec->reloc_order = malloc(nr_relocs * sizeof(*rsec->reloc_order));
+	if (!rsec->reloc_order) {
+		ERROR_GLIBC("malloc");
+		return -1;
+	}
+
+	for (i = 0; i < nr_relocs; i++)
+		rsec->reloc_order[i] = i;
+
+	sort_relocs = rsec->relocs;
+	qsort(rsec->reloc_order, nr_relocs, sizeof(*rsec->reloc_order),
+	      compare_reloc_order);
+
+	return 0;
+}
+
+/* Grow the index to cover the base section, new windows start past the end. */
+static int reloc_cache_resize(struct section *rsec)
+{
+	const unsigned int nr_windows = reloc_cache_index(sec_size(rsec->base)) + 1;
+	unsigned int *cache;
+
+	if (nr_windows <= rsec->nr_cache_windows)
+		return 0;
+
+	cache = realloc(rsec->reloc_cache, nr_windows * sizeof(*cache));
+	if (!cache) {
+		ERROR_GLIBC("realloc");
+		return -1;
+	}
+
+	while (rsec->nr_cache_windows < nr_windows)
+		cache[rsec->nr_cache_windows++] = rsec->nr_indexed;
+	rsec->reloc_cache = cache;
+
+	return 0;
+}
+
+/*
+ * Index the next relocation. It must follow the previous one in position and
+ * offset, otherwise the index is dropped and the next lookup rebuilds it.
+ */
+static int reloc_cache_add(struct section *rsec, unsigned int pos)
+{
+	struct reloc *reloc = reloc_at(rsec, pos);
+	const unsigned long offset = reloc_offset(reloc);
+	const unsigned long window = reloc_cache_index(offset);
+	unsigned long first_window = 0;
+
+	if (pos != rsec->nr_indexed)
+		goto unsorted;
+
+	if (pos) {
+		struct reloc *prev = reloc_at(rsec, pos - 1);
+		const unsigned long prev_offset = reloc_offset(prev);
+
+		if (offset < prev_offset)
+			goto unsorted;
+		first_window = reloc_cache_index(prev_offset) + 1;
+	}
+
+	if (reloc_cache_resize(rsec))
+		return -1;
+	if (window >= rsec->nr_cache_windows)
+		goto unsorted;
+
+	while (first_window <= window)
+		rsec->reloc_cache[first_window++] = pos;
+	rsec->nr_indexed = pos + 1;
+
+	return 0;
+
+unsorted:
+	reloc_cache_free(rsec);
+	return 0;
+}
+
+static unsigned long num_relocs_sorted;
+
+static int init_reloc_cache(struct section *rsec)
+{
+	const unsigned int nr_relocs = sec_num_entries(rsec);
+	unsigned int pos;
+
+	reloc_cache_free(rsec);
+	if (!relocs_in_order(rsec)) {
+		if (reloc_order_build(rsec))
+			return -1;
+		num_relocs_sorted += nr_relocs;
+	}
+
+	rsec->sorted = true;
+	for (pos = 0; pos < nr_relocs; pos++) {
+		if (reloc_cache_add(rsec, pos))
+			return -1;
+	}
+
+	return 0;
+}
+
+static bool reloc_in_range(struct reloc *reloc, unsigned long offset,
+			   unsigned int len)
+{
+	return reloc_offset(reloc) >= offset && reloc_offset(reloc) < offset + len;
+}
+
+/* If there are multiple matches, return the first one in the range. */
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				       unsigned long offset, unsigned int len)
 {
-	struct reloc *reloc, *r = NULL;
-	struct section *rsec;
-	unsigned long o;
+	struct section *rsec = sec->rsec;
+	unsigned long cache_idx;
+	unsigned int pos;
 
-	rsec = sec->rsec;
 	if (!rsec)
 		return NULL;
 
-	for_offset_range(o, offset, offset + len) {
-		elf_hash_for_each_possible(elf, reloc, reloc, hash,
-					   sec_offset_hash(rsec, o)) {
-			if (reloc->sec != rsec)
-				continue;
+	if (!rsec->sorted && init_reloc_cache(rsec))
+		exit(1);
 
-			if (reloc_offset(reloc) >= offset &&
-			    reloc_offset(reloc) < offset + len) {
-				if (!r || reloc_offset(reloc) < reloc_offset(r))
-					r = reloc;
-			}
-		}
-		if (r && (reloc_offset(r) & OFFSET_STRIDE_MASK) == o)
-			return r;
+	cache_idx = reloc_cache_index(offset);
+	if (cache_idx >= rsec->nr_cache_windows)
+		return NULL;
+
+	/* The index gives a lower bound, scan on from there. */
+	for (pos = rsec->reloc_cache[cache_idx]; pos < rsec->nr_indexed; pos++) {
+		struct reloc *reloc = reloc_at(rsec, pos);
+
+		if (reloc_offset(reloc) >= offset)
+			return reloc_in_range(reloc, offset, len) ? reloc : NULL;
 	}
 
-	return r;
+	return NULL;
 }
 
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset)
@@ -352,11 +537,6 @@ struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, uns
 	return find_reloc_by_dest_range(elf, sec, offset, 1);
 }
 
-static bool is_dwarf_section(struct section *sec)
-{
-	return !strncmp(sec->name, ".debug_", 7);
-}
-
 static int read_sections(struct elf *elf)
 {
 	Elf_Scn *s = NULL;
@@ -1071,8 +1251,10 @@ struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
 	set_reloc_type(elf, reloc, type);
 	set_reloc_addend(elf, reloc, addend);
 
-	if (!is_dwarf_section(rsec->base))
-		elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
+	if (rsec->reloc_order)
+		reloc_cache_free(rsec);
+	else if (rsec->sorted && reloc_cache_add(rsec, reloc_idx))
+		return NULL;
 	set_sym_next_reloc(reloc, sym->relocs);
 	sym->relocs = reloc;
 
@@ -1126,12 +1308,11 @@ struct reloc *elf_init_reloc_data_sym(struct elf *elf, struct section *sec,
 
 static int read_relocs(struct elf *elf)
 {
-	unsigned long nr_reloc, max_reloc = 0, nr_hashed = 0;
+	unsigned long nr_reloc, max_reloc = 0;
 	struct section *rsec;
 	struct reloc *reloc;
 	unsigned int symndx;
 	struct symbol *sym;
-	bool hashed;
 	int i;
 
 	list_for_each_entry(rsec, &elf->sections, list) {
@@ -1146,23 +1327,6 @@ static int read_relocs(struct elf *elf)
 
 		rsec->base->rsec = rsec;
 
-		/*
-		 * DWARF relocations are never looked up by destination, they
-		 * only need to be on their symbol's list.
-		 */
-		if (!is_dwarf_section(rsec->base))
-			nr_hashed += sec_num_entries(rsec);
-	}
-
-	if (!elf_alloc_hash(reloc, nr_hashed))
-		return -1;
-
-	list_for_each_entry(rsec, &elf->sections, list) {
-		if (!is_reloc_sec(rsec))
-			continue;
-
-		hashed = !is_dwarf_section(rsec->base);
-
 		/* nr_alloc_relocs=0: libelf owns d_buf */
 		rsec->nr_alloc_relocs = 0;
 
@@ -1184,21 +1348,24 @@ static int read_relocs(struct elf *elf)
 				return -1;
 			}
 
-			if (hashed)
-				elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
 			set_sym_next_reloc(reloc, sym->relocs);
 			sym->relocs = reloc;
 
 			nr_reloc++;
 		}
 		max_reloc = max(max_reloc, nr_reloc);
+
+		/* DWARF relocs are never looked up, so are not worth indexing. */
+		if (is_dwarf_section(rsec->base))
+			continue;
+		if (init_reloc_cache(rsec))
+			return -1;
 	}
 
 	if (opts.stats) {
 		printf("max_reloc: %lu\n", max_reloc);
 		printf("num_relocs: %lu\n", elf->num_relocs);
-		printf("num_relocs_hashed: %lu\n", nr_hashed);
-		printf("reloc_bits: %d\n", elf->reloc_bits);
+		printf("num_relocs_sorted: %lu\n", num_relocs_sorted);
 	}
 
 	return 0;
@@ -1345,8 +1512,7 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 	if (!elf_alloc_hash(section,		1000) ||
 	    !elf_alloc_hash(section_name,	1000) ||
 	    !elf_alloc_hash(symbol,		10000) ||
-	    !elf_alloc_hash(symbol_name,	10000) ||
-	    !elf_alloc_hash(reloc,		100000))
+	    !elf_alloc_hash(symbol_name,	10000))
 		return NULL;
 
 	null		= elf_create_section(elf, NULL, 0, 0, SHT_NULL, 0, 0);
@@ -1526,6 +1692,8 @@ struct section *elf_create_section(struct elf *elf, const char *name,
 	sec->sh.sh_type = type;
 	sec->sh.sh_addralign = align;
 	sec->sh.sh_flags = flags;
+	/* Relocations objtool adds are indexed as they come. */
+	sec->sorted = type == SHT_RELA;
 
 	if (name) {
 		sec->name = strdup(name);
@@ -1651,16 +1819,6 @@ static int elf_alloc_reloc(struct elf *elf, struct section *rsec)
 	}
 
 	memcpy(new_relocs, old_relocs, nr_relocs_old * sizeof(struct reloc));
-
-	for (int i = 0; i < nr_relocs_old && !is_dwarf_section(rsec->base); i++) {
-		struct reloc *old = &old_relocs[i];
-		struct reloc *new = &new_relocs[i];
-		u32 key = reloc_hash(old);
-
-		elf_hash_del(reloc, &old->hash, key);
-		elf_hash_add(reloc, &new->hash, key);
-	}
-
 	free(old_relocs);
 done:
 	rsec->relocs = new_relocs;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index a82517a76a0f..baa4f76b1800 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -59,6 +59,8 @@ struct section {
 	const char *name;
 	int idx;
 	bool _changed, text, rodata, noinstr, init, truncate;
+	bool sorted;
+	unsigned int *reloc_cache, *reloc_order, nr_cache_windows, nr_indexed;
 	struct reloc *relocs;
 	unsigned long nr_alloc_relocs;
 	struct section *twin;
@@ -106,7 +108,6 @@ struct symbol {
 };
 
 struct reloc {
-	struct elf_hash_node hash;
 	struct section *sec;
 	struct symbol *sym;
 	unsigned long _sym_next_reloc;
@@ -127,13 +128,11 @@ struct elf {
 	int symbol_name_bits;
 	int section_bits;
 	int section_name_bits;
-	int reloc_bits;
 
 	struct elf_hash_node **symbol_hash;
 	struct elf_hash_node **symbol_name_hash;
 	struct elf_hash_node **section_hash;
 	struct elf_hash_node **section_name_hash;
-	struct elf_hash_node **reloc_hash;
 
 	struct section *section_data;
 	struct symbol *symbol_data;
@@ -575,9 +574,4 @@ static inline u32 sec_offset_hash(struct section *sec, unsigned long offset)
 	return ol;
 }
 
-static inline u32 reloc_hash(struct reloc *reloc)
-{
-	return sec_offset_hash(reloc->sec, reloc_offset(reloc));
-}
-
 #endif /* _OBJTOOL_ELF_H */

-- 
2.55.0

