Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006BE427FB0;
	Mon, 14 Sep 2026 09:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377868; cv=none; b=GfYVnUuKSyKIIl0OfVAlJCis9fQgbfJZdScuIWY8yz4H8XR2qSMwMoFfy2iu4XkpicGO9XGJ9zWSpZ61SWdQHNwDz1sfjh1m2V6xz0RYhKlKUKRP8GPC8F6b5aPDaZK4cfUDs2JXd9YUv+HWoFQ+pf4Djp5/uqMfn5JPkhRwoJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377868; c=relaxed/simple;
	bh=teVhiHZnjUrn1fzyPfRhipqPjCBw61heiLWKqLcnwSs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U+CZUDm2fmDnDkC72ui9Nx9OegfAmQv1mOn7njMVzE+ys7fzdP4arZBRznE5ywGFw744btaL9yfruEAAC3hXmybTXcNs1+HmZNB3LThz+0QKyASDum+7y0nSgCfXPdn8YHASCE8R+y4M6ANj5VTWFIhJluk50M6tKMDVGdnyDwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+VGqsl8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+VGqsl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FEE1F0089A;
	Mon, 14 Sep 2026 09:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789377866;
	bh=H0OwrUJWpAVtFVlfv4PWaJZr6f5hIm/JQBDkb/y9PBo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=J+VGqsl8CJNXBFQw1X0Wvt+XwvT/RUE28ob2ZblAZa0jXFrzUuCQZaP8EkEPpCcFf
	 IOTNFv1qTGMlupbP4Xt5auhRRULpXvCQAUJFKVsu2OKjsNbPMoTLGX4qASpYQhHk06
	 oJK/VAHWuxZ8+isIXA5/wNnU4JHoHOFADNFy4DNQhlDepBjWPYnFwk1oi4/e7XFaCk
	 +sqCqUlsdBf/oXkYi9a/xL6YwYI2Tt/x7Ef62Zw7VPpWx8tCfEGfrCgdQRTN1BuKje
	 E7zmeNQSw2GG60jS3oaI8ky7r1VmBXipF/McGthAcN+8wq5ylMfPAeoK9j9rpH/abU
	 CI7QOJqLtbkgA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 10:22:14 +0100
Subject: [PATCH v2 15/21] objtool: cache relocations, do less work
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-build-speedup-v2-15-39817ec5db23@kernel.org>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
In-Reply-To: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
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
 linux-hardening@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=13556; i=ljs@kernel.org;
 h=from:subject:message-id; bh=teVhiHZnjUrn1fzyPfRhipqPjCBw61heiLWKqLcnwSs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKW7zn4znve3Ev68VIC83WOrRVvnXEoIsYsNeCQQHZok
 HiG3ay7HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIizbD/6RXa8oVXLl/pPj1
 ZAq6zbruaXaYbd6iie27fNTfad55upCRYYnptXL7Ogdb8/RTklsa04Tu1OXxS1Zy5G4Us1v8atN
 7JgA=
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

This relies upon the entries within a section being sorted, which is the
case for all sections supplied to objtool by the link step during the
kernel build.

For cases where sections are supplied out of order, grown one relocation
at a time (e.g. livepatch) or created by objtool itself, fall back to using
the existing hash mechanism.

DWARF sections are a special case - their relocations are never looked up
by destination at all and only need to be on their symbol's list for
elf_update_sym_relocs().

So do not index or hash DWARF relocations at all - however add a mechanism
such that if one were ever looked up, a linear scan will be used.

This is meaningful in practice as on an x86-64 kernel build with
CONFIG_DEBUG_INFO set objtool processing of vmlinux.o is dominated by DWARF
section processing.

For an allmodconfig build ~9 million relocations were hashed, and ~8.2
million of those were DWARF sections, which added overhead on cache miss
and pollution of the hash table. This is now eliminated.

The hash, when used, is read-mostly (every jump, call and memory operand)
and several relocations share a key due to the 16-byte stride, so keep the
hash sparse by scaling the hash by the number of objects to be hashed.

The output of objtool before and after this change was confirmed to be
byte-for-byte identical both for x86_64 defconfig and allmodconfig with
gcc and clang.

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
 tools/objtool/elf.c                 | 246 +++++++++++++++++++++++++++++++++---
 tools/objtool/include/objtool/elf.h |   2 +
 2 files changed, 231 insertions(+), 17 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index a791f4ea6ec1..5ee11301a5a3 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -316,18 +316,117 @@ struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *nam
 	return NULL;
 }
 
-/* If there are multiple matches, return the first one in the range */
-struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
+static bool is_dwarf_section(struct section *sec)
+{
+	return !strncmp(sec->name, ".debug_", 7);
+}
+
+/* Cache relocations at a 64 byte granularity. */
+#define RELOC_CACHE_INDEX_SHIFT	6
+
+static unsigned long reloc_cache_index(unsigned long offset)
+{
+	return offset >> RELOC_CACHE_INDEX_SHIFT;
+}
+
+static unsigned int reloc_cache_nr_windows(const struct section *rsec)
+{
+	const unsigned long size = sec_size(rsec->base);
+
+	return (size >> RELOC_CACHE_INDEX_SHIFT) + 1;
+}
+
+static int init_reloc_cache(struct section *rsec)
+{
+	const unsigned int nr_relocs = sec_num_entries(rsec);
+	const unsigned int nr_windows = reloc_cache_nr_windows(rsec);
+	unsigned int reloc_idx, next_cache_idx = 0;
+
+	rsec->reloc_cache = malloc(nr_windows * sizeof(unsigned int));
+	if (!rsec->reloc_cache) {
+		ERROR_GLIBC("malloc");
+		return -1;
+	}
+
+	/* Populate relocation indexes reloc cache index -> reloc index. */
+	for (reloc_idx = 0; reloc_idx < nr_relocs; reloc_idx++) {
+		struct reloc *reloc = &rsec->relocs[reloc_idx];
+		const unsigned long offset = reloc_offset(reloc);
+		const unsigned long cache_idx = reloc_cache_index(offset);
+
+		if (cache_idx >= nr_windows)
+			break;
+
+		while (next_cache_idx <= cache_idx)
+			rsec->reloc_cache[next_cache_idx++] = reloc_idx;
+	}
+
+	while (next_cache_idx < nr_windows)
+		rsec->reloc_cache[next_cache_idx++] = nr_relocs;
+
+	rsec->sorted = true;
+	return 0;
+}
+
+static void free_reloc_cache(struct section *rsec)
+{
+	free(rsec->reloc_cache);
+	rsec->reloc_cache = NULL;
+	rsec->sorted = false;
+}
+
+static struct reloc *find_reloc_sorted(struct section *rsec,
 				       unsigned long offset, unsigned int len)
 {
-	struct reloc *reloc, *r = NULL;
-	struct section *rsec;
-	unsigned long o;
+	struct reloc *relocs = rsec->relocs;
+	const unsigned int nr_relocs = sec_num_entries(rsec);
+	const unsigned long cache_idx = reloc_cache_index(offset);
+	unsigned int reloc_idx, i;
 
-	rsec = sec->rsec;
-	if (!rsec)
+	if (cache_idx >= reloc_cache_nr_windows(rsec))
+		return NULL;
+
+	reloc_idx = rsec->reloc_cache[cache_idx];
+
+	/*
+	 * Scan through all relocations covered by cache entry to find the
+	 * first at or after offset. Relocations are sorted by offset.
+	 */
+	for (i = reloc_idx; i < nr_relocs; i++) {
+		struct reloc *reloc = &relocs[i];
+		const unsigned long curr_offset = reloc_offset(reloc);
+
+		if (curr_offset >= offset)
+			break;
+
+		reloc_idx++;
+	}
+
+	/* Nothing found, or the first candidate lies beyond the range. */
+	if (reloc_idx >= nr_relocs ||
+	    reloc_offset(&relocs[reloc_idx]) >= offset + len)
 		return NULL;
 
+	/* If there are duplicate entries, return the last. */
+	for (i = reloc_idx; i < nr_relocs - 1; i++) {
+		struct reloc *reloc = &relocs[i];
+		struct reloc *next_reloc = &relocs[i + 1];
+
+		if (reloc_offset(next_reloc) != reloc_offset(reloc))
+			break;
+		reloc_idx++;
+	}
+
+	return &relocs[reloc_idx];
+}
+
+/* Not indexed, so look it up in the hash. */
+static struct reloc *find_reloc_hash(const struct elf *elf, struct section *rsec,
+				     unsigned long offset, unsigned int len)
+{
+	unsigned long o;
+	struct reloc *reloc, *r = NULL;
+
 	for_offset_range(o, offset, offset + len) {
 		elf_hash_for_each_possible(elf, reloc, reloc, hash,
 					   sec_offset_hash(rsec, o)) {
@@ -347,14 +446,48 @@ struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *se
 	return r;
 }
 
-struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset)
+/* Should never be invoked, provided as a backstop. */
+static struct reloc *find_reloc_linear(struct section *rsec,
+				       unsigned long offset, unsigned int len)
 {
-	return find_reloc_by_dest_range(elf, sec, offset, 1);
+	struct reloc *reloc, *first = NULL;
+
+	WARN("%s: linear scan for sec %s with %u relocs at offset %lu len %u",
+	     __func__, rsec->name, sec_num_entries(rsec), offset, len);
+
+	for_each_reloc(rsec, reloc) {
+		if (reloc_offset(reloc) < offset ||
+		    reloc_offset(reloc) >= offset + len)
+			continue;
+
+		if (!first || reloc_offset(reloc) < reloc_offset(first))
+			first = reloc;
+	}
+
+	return first;
 }
 
-static bool is_dwarf_section(struct section *sec)
+/* If there are multiple matches, return the first one in the range. */
+struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
+				       unsigned long offset, unsigned int len)
 {
-	return !strncmp(sec->name, ".debug_", 7);
+	struct section *rsec = sec->rsec;
+
+	if (!rsec)
+		return NULL;
+
+	if (rsec->sorted)
+		return find_reloc_sorted(rsec, offset, len);
+
+	if (rsec->hashed)
+		return find_reloc_hash(elf, rsec, offset, len);
+
+	return find_reloc_linear(rsec, offset, len);
+}
+
+struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset)
+{
+	return find_reloc_by_dest_range(elf, sec, offset, 1);
 }
 
 static int read_sections(struct elf *elf)
@@ -1071,7 +1204,8 @@ struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
 	set_reloc_type(elf, reloc, type);
 	set_reloc_addend(elf, reloc, addend);
 
-	elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
+	if (rsec->hashed)
+		elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
 	set_sym_next_reloc(reloc, sym->relocs);
 	sym->relocs = reloc;
 
@@ -1123,18 +1257,44 @@ struct reloc *elf_init_reloc_data_sym(struct elf *elf, struct section *sec,
 			      elf_data_rela_type(elf));
 }
 
+static u64 raw_reloc_offset(const struct section *rsec, unsigned int idx)
+{
+	const void *entry = rsec->data->d_buf + idx * rsec->sh.sh_entsize;
+
+	if (rsec->sh.sh_entsize < sizeof(Elf64_Rel))
+		return ((const Elf32_Rela *)entry)->r_offset;
+
+	return ((const Elf64_Rela *)entry)->r_offset;
+}
+
+static bool reloc_sec_in_order(struct section *rsec)
+{
+	const unsigned int nr_relocs = sec_num_entries(rsec);
+	u64 prev_offset = 0;
+	unsigned int i;
+
+	for (i = 0; i < nr_relocs; i++) {
+		/* Called before relocs exist, so look at raw entry. */
+		const u64 offset = raw_reloc_offset(rsec, i);
+
+		if (offset < prev_offset)
+			return false;
+		prev_offset = offset;
+	}
+
+	return true;
+}
+
 static int read_relocs(struct elf *elf)
 {
-	unsigned long nr_reloc, max_reloc = 0;
+	unsigned long nr_reloc, max_reloc = 0, nr_hashed = 0;
 	struct section *rsec;
 	struct reloc *reloc;
 	unsigned int symndx;
 	struct symbol *sym;
+	bool hashed;
 	int i;
 
-	if (!elf_alloc_hash(reloc, elf->num_relocs))
-		return -1;
-
 	list_for_each_entry(rsec, &elf->sections, list) {
 		if (!is_reloc_sec(rsec))
 			continue;
@@ -1147,6 +1307,28 @@ static int read_relocs(struct elf *elf)
 
 		rsec->base->rsec = rsec;
 
+		/* DWARF relocs are never looked up. */
+		if (is_dwarf_section(rsec->base))
+			continue;
+		if (reloc_sec_in_order(rsec)) {
+			rsec->sorted = true;
+			continue;
+		}
+
+		rsec->hashed = true;
+		nr_hashed += sec_num_entries(rsec);
+	}
+
+	/* Read mostly, so avoid collisions and keep the hash sparse. */
+	if (!elf_alloc_hash(reloc, nr_hashed * OFFSET_STRIDE))
+		return -1;
+
+	list_for_each_entry(rsec, &elf->sections, list) {
+		if (!is_reloc_sec(rsec))
+			continue;
+
+		hashed = rsec->hashed;
+
 		/* nr_alloc_relocs=0: libelf owns d_buf */
 		rsec->nr_alloc_relocs = 0;
 
@@ -1168,18 +1350,23 @@ static int read_relocs(struct elf *elf)
 				return -1;
 			}
 
-			elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
+			if (hashed)
+				elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
 			set_sym_next_reloc(reloc, sym->relocs);
 			sym->relocs = reloc;
 
 			nr_reloc++;
 		}
 		max_reloc = max(max_reloc, nr_reloc);
+
+		if (rsec->sorted && init_reloc_cache(rsec))
+			return -1;
 	}
 
 	if (opts.stats) {
 		printf("max_reloc: %lu\n", max_reloc);
 		printf("num_relocs: %lu\n", elf->num_relocs);
+		printf("num_relocs_hashed: %lu\n", nr_hashed);
 		printf("reloc_bits: %d\n", elf->reloc_bits);
 	}
 
@@ -1541,6 +1728,26 @@ struct section *elf_create_section(struct elf *elf, const char *name,
 	return sec;
 }
 
+/* A relocation was appended, abandon relocation cache and use hash instead. */
+static void copy_reloc_cache_to_hash(struct elf *elf, struct section *rsec,
+				     unsigned int nr_relocs)
+{
+	unsigned int i;
+
+	if (rsec->hashed)
+		return;
+
+	if (rsec->sorted)
+		free_reloc_cache(rsec);
+
+	for (i = 0; i < nr_relocs; i++) {
+		struct reloc *reloc = &rsec->relocs[i];
+
+		elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
+	}
+	rsec->hashed = true;
+}
+
 static int elf_alloc_reloc(struct elf *elf, struct section *rsec)
 {
 	struct reloc *old_relocs, *old_relocs_end, *new_relocs;
@@ -1686,6 +1893,8 @@ struct section *elf_create_rela_section(struct elf *elf, struct section *sec,
 
 	sec->rsec = rsec;
 	rsec->base = sec;
+	/* Relocations objtool creates are looked up through the hash. */
+	rsec->hashed = true;
 
 	return rsec;
 }
@@ -1708,6 +1917,9 @@ struct reloc *elf_create_reloc(struct elf *elf, struct section *sec,
 		return NULL;
 	}
 
+	/* A section read from the file is indexed, once grown it is hashed. */
+	copy_reloc_cache_to_hash(elf, rsec, sec_num_entries(rsec));
+
 	if (elf_alloc_reloc(elf, rsec))
 		return NULL;
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index a82517a76a0f..946b411ff1b9 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -59,6 +59,8 @@ struct section {
 	const char *name;
 	int idx;
 	bool _changed, text, rodata, noinstr, init, truncate;
+	bool hashed, sorted;
+	unsigned int *reloc_cache;
 	struct reloc *relocs;
 	unsigned long nr_alloc_relocs;
 	struct section *twin;

-- 
2.55.0

