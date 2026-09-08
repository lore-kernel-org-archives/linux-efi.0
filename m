Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CD43BFE5B;
	Tue,  8 Sep 2026 20:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901091; cv=none; b=ce5PA00EuyXGMduJHjdf5k2uejyWGp6kU7nBpqloGTZAeLWVBKVB5/An3gFJNpN9wuWG5jxVZrA9xG7r70E2wnt9kN0MOePDmz1CbAo3ihvI/hd+Z/2oTCmXYpaU8Ok/BLi9mJvxRzTFbLsOnQl0jY+ZqYVhfyjA5XNCs2lrc3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901091; c=relaxed/simple;
	bh=BVONI6jQ5HybHDV5xL2pZB9mTVCT/1taKfTC6TZq7QU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VxqQV+U4Lz9RXEsO9QQywqWPD2GavjJk61dgcvBKBuulLb9TF290ULfaGZQq/a0g49UJugdDzAJCii2HINGFZFwuDIpGWpiOdQqd4NZ7/59n75j2N2P15IPvNo8KP4v2HAuTJSIu9thXYr//OWQ0lWtabltkK1dyUBQFFpvDsE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6rggv9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6rggv9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E691F00A3A;
	Tue,  8 Sep 2026 20:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901089;
	bh=xaxaPWmODXOjjlSFAfNKSXoU8O/l4eGEkzuqZMX6HWQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=H6rggv9q/tqtwuJX+Nwnp4lY2ozHj4VQ5i0Y16GL8w+yU1t76vD0CS6i5+Sr3AVWO
	 p2ycfVE2VZLJaqXC3Ftc2E/BsDkT7Wtg3NVdblWIC9JoeEZ37amFQwS6p+m1nT+C/K
	 H0KgY/1eKmvkFYZPZsrvneN68tJph23iQjjz4nk9KBYKbsldKEALwVxxfvRDLtNNJV
	 kCfMs/aREKAUjAW8bryL2PpEHIsQvMZWmbMnKTo4ezQuAptgrLWsFfjX05vp/GDCc4
	 /zA6bG1vEOUPHQR2L8uvZ1QI+rAzBcnOSvRhcxhe2X3sr2ZMkE2h39tEpMKcHgfjEm
	 LmBCKOMgymiLg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:55:14 +0100
Subject: [PATCH 14/23] modpost: cache section relocation mismatch state
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-build-speedup-v1-14-5dc1ac01672d@kernel.org>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
In-Reply-To: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
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
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4714; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BVONI6jQ5HybHDV5xL2pZB9mTVCT/1taKfTC6TZq7QU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWlJnfNprw8zHn24UTPjhnP3jU/kWvzGSNGNeaBclTs
 +8k52Z86ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEDAoZ/kpoL/yXFnp0nZ1w
 o/aSTce/NLTou57y6vzx10JSy0Vv7VSGn4zJfzZ6V19S/Zb2wsF+CveRr11reMp+tWm+4BJM8Z5
 ZwQQA
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
  x86 defconfig, touch mm/vma.c, gcc        8.6s     8.4s    -0.16s (-2%)
  x86 defconfig, touch mm/vma.c, clang      7.7s     7.5s    -0.15s (-2%)
  x86 allmodconfig, touch mm/vma.c, gcc    38.2s    33.5s     -4.6s (-12%)
  x86 allmodconfig, touch mm/vma.c, clang  35.0s    31.1s     -4.0s (-11%)

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

