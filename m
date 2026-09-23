Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CDA3E3D86;
	Wed, 23 Sep 2026 17:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183995; cv=none; b=lwy6OVBnDRTP7L5ruC8yBmIJxZZEMRXyDyaEZPxftSN7LjXPevF6Hlzw92cJsLdUVFSC4Czh26zkAe1Sw9/RLyFJfFEeUQrfqtNIAt1ooGFefyVBuvQx3nxYJDccC7nh5XVF/Sxevs/aYNo1awtD9b5sKegCt54sdICV8zZH+Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183995; c=relaxed/simple;
	bh=9hDjEg13EL4FExzQs0DxiR/XhX7dDNwNUMkWv7ScVTs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TAifhQEgmGE5g+hhGgeRtfPYqDXlLBGMc1Qn+fkz9crjOV6BR0ZolpNkoEccYt5XCiUhUeh3k1XzFzEV64kYi7lD4kUrduBKyU390jT1gWt9L0vS3ARVwFmekefSVJG8TNMhmt2fezGHePX/ol7+VS+067OEeSzFeCxW+5/7/28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLMsKyzq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLMsKyzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AE51F00893;
	Wed, 23 Sep 2026 17:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790183994;
	bh=4krp5buGr3rR5dSLar2s7FglGNHp9YTI3G1tX/l0RKk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MLMsKyzqMIeBr0SN/dLWueI2/s9AiF+y3GfTKqerkq2RIP6oxDn1b532GYLP+Bd47
	 IfXrIwVbPNbbSoDMEYuXIKVQBDPtRVxScqfiAShicf2ky4HSmDa7YFTlKYd4qi9vlJ
	 NI3lFEdhVdxHBUt9+XxQ5Xy8861CASog0Zd9VJrSKQrBqZS7M4MMddznDZI8TNetsH
	 jy4UeUfBxI61tVj89+g3yJITd7Ks2sxjB/HqcMTqrU47cXttV1lg3AOOX7qEp8vZxd
	 /RIYjh9bSz0fJFozrjabp9OU9LLUioPR0pBYU3zhWB6WJAS/83BvVR3LgIiOTzRw7u
	 9kMHfhhpZ9QaQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 23 Sep 2026 18:17:56 +0100
Subject: [PATCH v4 07/22] elf-parse: add section flags, symbol binding and
 mapping helpers
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-build-speedup-v4-7-73128809a4a4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9261; i=ljs@kernel.org;
 h=from:subject:message-id; bh=9hDjEg13EL4FExzQs0DxiR/XhX7dDNwNUMkWv7ScVTs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2cF6uDMr7dJm5T8ggJXPXGnEFsSkvBS81fz43x7Fx3
 ycvPdmWjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEykI4jhv0vld5afe0KNglaU
 SqbuW3S/fKvp1YrpMtypmfw6jqcbfBgZJu6Q+X6aa8bJHI5nNhtVj4o/fMbgFj69ru5J4aa50RY
 HuAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Extend elf-parse to be able to read the symbol table of vmlinux in
kallsyms.

This requires the ability to open ELF files in read-only mode, so provide
elf_map_ro() to do so.

It also requires accessors for section flags and symbol bindings, so
provide these via shdr_flags() and sym_bind().

It's useful to be able to open an ELF file, map it, and then have easy
access to its section headers, names and symbol table, so introduce struct
elf_file to store this.

In order to obtain this data also provide elf_open_ro() and elf_close().

Also, check for the file being an ELF file first in elf_parse(). This is
the logical thing to check for first, but additionally prevents kallsyms
from having to check this it self.

Assisted-by: LLM
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 scripts/elf-parse.c | 103 +++++++++++++++++++++++++++++++++++++++++++++-------
 scripts/elf-parse.h |  54 +++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 13 deletions(-)

diff --git a/scripts/elf-parse.c b/scripts/elf-parse.c
index 99869ff91a8c..ce1c2a670244 100644
--- a/scripts/elf-parse.c
+++ b/scripts/elf-parse.c
@@ -17,15 +17,21 @@ struct elf_funcs elf_parser;
  * Get the whole file as a programming convenience in order to avoid
  * malloc+lseek+read+free of many pieces.  If successful, then mmap
  * avoids copying unused pieces; else just read the whole file.
- * Open for both read and write.
+ * Open for both read and write if writable is true, otherwise open
+ * read-only.
  */
-static void *map_file(char const *fname, size_t *size)
+static void *map_file(char const *fname, size_t *size, bool writable)
 {
-	int fd;
+	int fd, prot = PROT_READ, flags = MAP_PRIVATE;
 	struct stat sb;
 	void *addr = NULL;
 
-	fd = open(fname, O_RDWR);
+	if (writable) {
+		prot |= PROT_WRITE;
+		flags = MAP_SHARED;
+	}
+
+	fd = open(fname, writable ? O_RDWR : O_RDONLY);
 	if (fd < 0) {
 		perror(fname);
 		return NULL;
@@ -39,7 +45,7 @@ static void *map_file(char const *fname, size_t *size)
 		goto out;
 	}
 
-	addr = mmap(0, sb.st_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	addr = mmap(0, sb.st_size, prot, flags, fd, 0);
 	if (addr == MAP_FAILED) {
 		fprintf(stderr, "Could not mmap file: %s\n", fname);
 		goto out;
@@ -57,6 +63,12 @@ static int elf_parse(const char *fname, void *addr, uint32_t types)
 	Elf_Ehdr *ehdr = addr;
 	uint16_t type;
 
+	if (memcmp(ELFMAG, ehdr->e32.e_ident, SELFMAG) != 0 ||
+	    ehdr->e32.e_ident[EI_VERSION] != EV_CURRENT) {
+		fprintf(stderr, "unrecognized ELF file %s\n", fname);
+		return -1;
+	}
+
 	switch (ehdr->e32.e_ident[EI_DATA]) {
 	case ELFDATA2LSB:
 		elf_parser.r	= rle;
@@ -78,12 +90,6 @@ static int elf_parse(const char *fname, void *addr, uint32_t types)
 		return -1;
 	}
 
-	if (memcmp(ELFMAG, ehdr->e32.e_ident, SELFMAG) != 0 ||
-	    ehdr->e32.e_ident[EI_VERSION] != EV_CURRENT) {
-		fprintf(stderr, "unrecognized ELF file %s\n", fname);
-		return -1;
-	}
-
 	type = elf_parser.r2(&ehdr->e32.e_type);
 	if (!((1 << type) & types)) {
 		fprintf(stderr, "Invalid ELF type file %s\n", fname);
@@ -103,7 +109,9 @@ static int elf_parse(const char *fname, void *addr, uint32_t types)
 		elf_parser.shdr_name		= shdr32_name;
 		elf_parser.shdr_type		= shdr32_type;
 		elf_parser.shdr_entsize		= shdr32_entsize;
+		elf_parser.shdr_flags		= shdr32_flags;
 		elf_parser.sym_type		= sym32_type;
+		elf_parser.sym_bind		= sym32_bind;
 		elf_parser.sym_name		= sym32_name;
 		elf_parser.sym_value		= sym32_value;
 		elf_parser.sym_shndx		= sym32_shndx;
@@ -133,7 +141,9 @@ static int elf_parse(const char *fname, void *addr, uint32_t types)
 		elf_parser.shdr_name		= shdr64_name;
 		elf_parser.shdr_type		= shdr64_type;
 		elf_parser.shdr_entsize		= shdr64_entsize;
+		elf_parser.shdr_flags		= shdr64_flags;
 		elf_parser.sym_type		= sym64_type;
+		elf_parser.sym_bind		= sym64_bind;
 		elf_parser.sym_name		= sym64_name;
 		elf_parser.sym_value		= sym64_value;
 		elf_parser.sym_shndx		= sym64_shndx;
@@ -174,12 +184,13 @@ int elf_map_long_size(void *addr)
 	return ehdr->e32.e_ident[EI_CLASS] == ELFCLASS32 ? 4 : 8;
 }
 
-void *elf_map(char const *fname, size_t *size, uint32_t types)
+static void *__elf_map(char const *fname, size_t *size, uint32_t types,
+		       bool writable)
 {
 	void *addr;
 	int ret;
 
-	addr = map_file(fname, size);
+	addr = map_file(fname, size, writable);
 	if (!addr)
 		return NULL;
 
@@ -192,7 +203,73 @@ void *elf_map(char const *fname, size_t *size, uint32_t types)
 	return addr;
 }
 
+void *elf_map(char const *fname, size_t *size, uint32_t types)
+{
+	return __elf_map(fname, size, types, true);
+}
+
+/* For tools that only read the file. */
+void *elf_map_ro(char const *fname, size_t *size, uint32_t types)
+{
+	return __elf_map(fname, size, types, false);
+}
+
 void elf_unmap(void *addr, size_t size)
 {
 	munmap(addr, size);
 }
+
+/*
+ * Open an ELF file and map it read-only, locating its section headers, section
+ * names and symbol table which are populated in the elf out parameter.
+ *
+ * Returns 0 on success, otherwise -1.
+ */
+int elf_open_ro(char const *fname, uint32_t types, struct elf_file *elf)
+{
+	Elf_Ehdr *ehdr;
+	Elf_Shdr *first;
+	unsigned int shstrndx, i;
+
+	memset(elf, 0, sizeof(*elf));
+	elf->base = elf_map_ro(fname, &elf->size, types);
+	if (!elf->base)
+		return -1;
+
+	ehdr = elf->base;
+	elf->shdrs = (const char *)elf->base + ehdr_shoff(ehdr);
+	elf->shentsize = ehdr_shentsize(ehdr);
+	first = elf_section(elf, 0);
+
+	/* A count or index too large for the header lives in section 0. */
+	elf->shnum = ehdr_shnum(ehdr);
+	if (elf->shnum == SHN_UNDEF)
+		elf->shnum = shdr_size(first);
+	shstrndx = ehdr_shstrndx(ehdr);
+	if (shstrndx == SHN_XINDEX)
+		shstrndx = shdr_link(first);
+	elf->shstrtab = (const char *)elf->base +
+			shdr_offset(elf_section(elf, shstrndx));
+
+	for (i = 0; i < elf->shnum && !elf->symtab; i++)
+		if (shdr_type(elf_section(elf, i)) == SHT_SYMTAB)
+			elf->symtab = elf_section(elf, i);
+
+	if (!elf->symtab) {
+		fprintf(stderr, "%s: no symbol table\n", fname);
+		elf_close(elf);
+		return -1;
+	}
+
+	elf->strtab = (const char *)elf->base +
+		      shdr_offset(elf_section(elf, shdr_link(elf->symtab)));
+	elf->nr_syms = shdr_size(elf->symtab) / shdr_entsize(elf->symtab);
+
+	return 0;
+}
+
+void elf_close(struct elf_file *elf)
+{
+	elf_unmap(elf->base, elf->size);
+	elf->base = NULL;
+}
diff --git a/scripts/elf-parse.h b/scripts/elf-parse.h
index f4411e03069d..c5ad754da254 100644
--- a/scripts/elf-parse.h
+++ b/scripts/elf-parse.h
@@ -37,10 +37,12 @@ struct elf_funcs {
 	uint64_t (*shdr_offset)(Elf_Shdr *shdr);
 	uint64_t (*shdr_size)(Elf_Shdr *shdr);
 	uint64_t (*shdr_entsize)(Elf_Shdr *shdr);
+	uint64_t (*shdr_flags)(Elf_Shdr *shdr);
 	uint32_t (*shdr_link)(Elf_Shdr *shdr);
 	uint32_t (*shdr_name)(Elf_Shdr *shdr);
 	uint32_t (*shdr_type)(Elf_Shdr *shdr);
 	uint8_t (*sym_type)(Elf_Sym *sym);
+	uint8_t (*sym_bind)(Elf_Sym *sym);
 	uint32_t (*sym_name)(Elf_Sym *sym);
 	uint64_t (*sym_value)(Elf_Sym *sym);
 	uint16_t (*sym_shndx)(Elf_Sym *sym);
@@ -143,6 +145,7 @@ SHDR_ADDR(addr)
 SHDR_ADDR(offset)
 SHDR_ADDR(size)
 SHDR_ADDR(entsize)
+SHDR_ADDR(flags)
 
 SHDR_WORD(link)
 SHDR_WORD(name)
@@ -211,6 +214,21 @@ static inline uint8_t sym_type(Elf_Sym *sym)
 	return elf_parser.sym_type(sym);
 }
 
+static inline uint8_t sym64_bind(Elf_Sym *sym)
+{
+	return ELF64_ST_BIND(sym->e64.st_info);
+}
+
+static inline uint8_t sym32_bind(Elf_Sym *sym)
+{
+	return ELF32_ST_BIND(sym->e32.st_info);
+}
+
+static inline uint8_t sym_bind(Elf_Sym *sym)
+{
+	return elf_parser.sym_bind(sym);
+}
+
 SYM_ADDR(value)
 SYM_WORD(name)
 SYM_HALF(shndx)
@@ -298,8 +316,44 @@ static inline void w8le(uint64_t val, uint64_t *x)
 }
 
 void *elf_map(char const *fname, size_t *size, uint32_t types);
+void *elf_map_ro(char const *fname, size_t *size, uint32_t types);
 void elf_unmap(void *addr, size_t size);
 int elf_map_machine(void *addr);
 int elf_map_long_size(void *addr);
 
+/* A mapped file with its section headers, section names and symbol table. */
+struct elf_file {
+	void *base;
+	size_t size;
+	const char *shdrs;
+	unsigned int shnum, shentsize;
+	const char *shstrtab;
+	Elf_Shdr *symtab;
+	const char *strtab;
+	size_t nr_syms;
+};
+
+int elf_open_ro(char const *fname, uint32_t types, struct elf_file *elf);
+void elf_close(struct elf_file *elf);
+
+static inline Elf_Shdr *elf_section(const struct elf_file *elf,
+				    unsigned int index)
+{
+	return (Elf_Shdr *)(elf->shdrs + (size_t)index * elf->shentsize);
+}
+
+static inline const char *elf_section_name(const struct elf_file *elf,
+					   Elf_Shdr *shdr)
+{
+	return elf->shstrtab + shdr_name(shdr);
+}
+
+static inline Elf_Sym *elf_symbol(const struct elf_file *elf, size_t index)
+{
+	const char *base = elf->base;
+
+	return (Elf_Sym *)(base + shdr_offset(elf->symtab) +
+			   index * shdr_entsize(elf->symtab));
+}
+
 #endif /* _SCRIPTS_ELF_PARSE_H */

-- 
2.55.0

