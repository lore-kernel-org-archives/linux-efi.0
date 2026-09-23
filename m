Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CB73EA94C;
	Wed, 23 Sep 2026 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184078; cv=none; b=MKS79S9Op/zbz+vr416oZLmOOgVR6dd3TH+v8he8VrtqT51YIVLmfhG9a1kZy1Kj9N8/t9p04FD3e+T96+uu98yK0GWKHRn2nn+ljTDH5JNcDqWZW/0RqZYG7I2RHoW4lUIsqB0RpqZ7JPVTh1B5D27QcTz51uOsIaDrTLHPecU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184078; c=relaxed/simple;
	bh=Ec1/kqBneOXNUE0gtcHjI1qdlGW1hFvqVFIOwSgkaek=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WeW9g7QU0WSzxz3qZjPphr8SX7QdtYPHI7pHzAbSKrkkpl1haMVabZ//u1EFsKVtALlaIT8ghDdh+HKVR4lF9Cg1C2ceiBgQYiJ7MAvVxGc0mxuuaq0ctLhVX3PtaQT+SczeSfYtehdlmZk+2TXPQy0+MG1nEBjMLJ/2ykTkFy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOIjIFNy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOIjIFNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4D81F000FF;
	Wed, 23 Sep 2026 17:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790184069;
	bh=B/2HtZkmT+u7/JWW+lpRsHLnC+c6qMifLdIPC//XmMc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dOIjIFNyYMZVkaNYw7B1juz2dOCBElSaPHpI+UtrvhExEprOU9xI8O6IE32T/HaCN
	 g7rwjr8MHf6ce/9Mgng/9QdYv11wNTKSjSWnN7p7G/7O6w9SCefLJ7YH8Z5irQUvRW
	 2vDh4ZT7dWQwsO2KAnrOf5iYyVF+UWUWRhtQ7f+pFgzTHiQnNWuI0EZYNCNI0cZCGr
	 iyjP244uAUmb0n0y5x6WzgyxUV35IZdG5qijOet1qIeXF85pcsHPZm1x8DUxsxlxy7
	 TpDjNm5pj45DrpTaPQKyrAlqRJ2YNzDiWerPj2VHqSnb81LmSXqjnPDJbCbdJlmN17
	 yIqm0e5qFgJUQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 23 Sep 2026 18:18:02 +0100
Subject: [PATCH v4 13/22] modpost: cache section relocation mismatch state
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-build-speedup-v4-13-73128809a4a4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4714; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Ec1/kqBneOXNUE0gtcHjI1qdlGW1hFvqVFIOwSgkaek=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2cF6Z8Vrf3M3J/OM99Rk7W8yf/jUSt9hryKe+fLLWh
 wlP+AxtO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARkTsM/6NLN7vfW1DwMIDR
 eGXj8qbctQ766nnPp20tiKr348qKLWb4nyJ0b4Js+o/oEOfvnwNUkgsCU/uCRA5UV0Rccn75vSy
 EFwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

For every relocation modpost invokes check_section_mismatch() to determine
whether there is any kind of mismatch between the source and destination,
and if so which classification applies.

Each time it does this it invokes section_mismatch() which iterates
through the sectioncheck[] array every time it's called.

When walked a relocation section the source is fixed and there aren't many
targets, so the same names are looked up over and over again.

Therefore cache not only mismatch categorisation but also whether a
mismatch even exists for a given section and look up the sections in the
cache.

Special indices (undefined, absolute, common) take the uncached path as
before.

This results in very significant speed ups for allmodconfig incremental
builds.

modpost is on the serial tail of every build that links vmlinux.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 defconfig, touch mm/vma.c, gcc        8.5s     8.3s    -0.14s (-2%)
  x86 defconfig, touch mm/vma.c, clang      7.7s     7.6s    -0.13s (-2%)
  x86 allmodconfig, touch mm/vma.c, gcc    33.9s    29.4s     -4.5s (-13%)
  x86 allmodconfig, touch mm/vma.c, clang  31.9s    27.9s     -4.0s (-13%)

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 scripts/mod/modpost.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 75374c64b8cc..0fd43c8a89ea 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1155,12 +1155,67 @@ static void check_export_symbol(struct module *mod, struct elf_info *elf,
 			 name);
 }
 
+/*
+ * mismatch_cache[section index] ->
+ *   0 - uncached.
+ *  -1 - no mismatch.
+ *  >0 - mismatch index + 1.
+ */
+static int *mismatch_cache;
+
+static void init_mismatch_cache(unsigned int num_sections)
+{
+	mismatch_cache = xcalloc(num_sections, sizeof(*mismatch_cache));
+}
+
+static void reset_mismatch_cache(unsigned int num_sections)
+{
+	memset(mismatch_cache, 0, num_sections * sizeof(*mismatch_cache));
+}
+
+static void free_mismatch_cache(void)
+{
+	free(mismatch_cache);
+	mismatch_cache = NULL;
+}
+
+static const struct sectioncheck
+*cache_mismatch(unsigned int secndx, const struct sectioncheck *mismatch)
+{
+	if (!mismatch) {
+		mismatch_cache[secndx] = -1;
+		return NULL;
+	}
+
+	mismatch_cache[secndx] = (mismatch - sectioncheck) + 1;
+	return mismatch;
+}
+
+static const struct sectioncheck *get_section_mismatch(const char *fromsec,
+		const struct elf_info *elf, unsigned int secndx)
+{
+	int cached;
+
+	if (secndx >= elf->num_sections)
+		return section_mismatch(fromsec, sec_name(elf, secndx));
+
+	cached = mismatch_cache[secndx];
+	if (cached < 0)
+		return NULL;
+	if (cached > 0)
+		return &sectioncheck[cached - 1];
+
+	return cache_mismatch(secndx,
+			      section_mismatch(fromsec, sec_name(elf, secndx)));
+}
+
 static void check_section_mismatch(struct module *mod, struct elf_info *elf,
 				   Elf_Sym *sym,
 				   unsigned int fsecndx, const char *fromsec,
 				   Elf_Addr faddr, Elf_Addr taddr)
 {
-	const char *tosec = sec_name(elf, get_secindex(elf, sym));
+	const unsigned int to_secndx = get_secindex(elf, sym);
+	const char *tosec = sec_name(elf, to_secndx);
 	const struct sectioncheck *mismatch;
 
 	if (module_enabled && elf->export_symbol_secndx == fsecndx) {
@@ -1168,7 +1223,7 @@ static void check_section_mismatch(struct module *mod, struct elf_info *elf,
 		return;
 	}
 
-	mismatch = section_mismatch(fromsec, tosec);
+	mismatch = get_section_mismatch(fromsec, elf, to_secndx);
 	if (!mismatch)
 		return;
 
@@ -1445,6 +1500,8 @@ static void check_sec_ref(struct module *mod, struct elf_info *elf)
 {
 	int i;
 
+	init_mismatch_cache(elf->num_sections);
+
 	/* Walk through all sections */
 	for (i = 0; i < elf->num_sections; i++) {
 		Elf_Shdr *sechdr = &elf->sechdrs[i];
@@ -1461,6 +1518,9 @@ static void check_sec_ref(struct module *mod, struct elf_info *elf)
 			if (match(secname, section_white_list))
 				continue;
 
+			/* Reset cache per-section. */
+			reset_mismatch_cache(elf->num_sections);
+
 			start = sym_get_data_by_offset(elf, i, 0);
 			stop = start + sechdr->sh_size;
 
@@ -1472,6 +1532,8 @@ static void check_sec_ref(struct module *mod, struct elf_info *elf)
 					    start, stop);
 		}
 	}
+
+	free_mismatch_cache();
 }
 
 static char *remove_dot(char *s)

-- 
2.55.0

