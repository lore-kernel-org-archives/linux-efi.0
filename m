Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256863C7691;
	Wed, 23 Sep 2026 17:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184132; cv=none; b=B61bxOfJ8dhZ4aLDEPjdik9pQSF3MBd2trpL+Bi2nWu3q05HuRlj4klgG2jPxzF548oQnEz22cZ6fCsIt7O+hatowfvMvHblUwI2YmOx3GV+96f0rxHN6E4a6DyKDC7EuTJMclfkCd/2sNzJdJjPS0d+kAjeRLuLMRcZgLY9Sqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184132; c=relaxed/simple;
	bh=1MNx2aSSjSgi0WUnp9kWu6YKYuPNVv4LhqSB+6OA3nE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ppGluNJLci+WlegD+PdbPM7N6xkMn3WEHf5W6k+CtNLITbjWCtgFVgK1/7tuZVz3AlFqxkGH78RqzWtN04jdszuZ4NOGhcxc+Dg+XReYe0MQDt+dvGi+mTPVp1CBI1TtsfGcN8akIAMHVNrUObJ2+fKKCr2h2EgW9T/DNCgtRjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPsDCIGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPsDCIGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280DB1F000FF;
	Wed, 23 Sep 2026 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790184131;
	bh=flxRB0RNwZz3AOlLZeEynIEfspQVvaUpjYF/Tjf2+64=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UPsDCIGDyg1u84TMdOj16FUNyBreuz/tc7euMiNjyhkmq6UrVq3SdvmLqHg4e0OWD
	 XTTb1La8nHitRQtByr9yWWn47ViPBBI3QelGrraZ6k/o0WRGHb9VDDjO1s/Kc7Pf+Y
	 5j8bZMXhe+IsQMpY8tg0UtFIgkfpsY4Ds0QSWk198HRZ6UbFGJFzFnFCWpH/iQcRlT
	 7D7j5U4nv8bKw6C+CZO7ZpDcMsT4lNYc+8+QGUjSmVaseyrcagM+C/npSW0DJGRoa3
	 czc6bfrZdQMbOL4XtnxMVSzRINdwMhBfnWXvy4HLCAfrLNZJA0SF7mORqg46BvplSl
	 voF8XL6yvIH7g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 23 Sep 2026 18:18:07 +0100
Subject: [PATCH v4 18/22] objtool: size the instruction hash to the text
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-build-speedup-v4-18-73128809a4a4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5734; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1MNx2aSSjSgi0WUnp9kWu6YKYuPNVv4LhqSB+6OA3nE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2cF7lXihiJcLXFaF869vqaPZeM+2GPX1SCxUn615el
 e/24tLXjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzk+21Ghh+778em2s+Izjub
 fcrG7NNd7elhhzk5gm4I1zq3BPrvt2H47xDW7p90dtYWqTOnH+2ZY+KsqrR0duqr21PM63i9jnp
 dZwYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

The instruction hash is a fixed 2^20 buckets, which for an x86-64
allmodconfig vmlinux.o of ~16 million instructions leaves find_insn()
walking chains of four or more entries.

Size it by the amount of text to be decoded instead, at one bucket per
OFFSET_STRIDE window, as sec_offset_hash() keys on those and anything
finer would sit empty.

This gives 2^20 buckets (8 MiB) for a defconfig vmlinux.o and 2^22 (32 MiB)
for allmodconfig, so it is not an egregious use of memory.

The output of objtool before and after this change was confirmed to be
byte-for-byte identical for x86_64 defconfig and allmodconfig.

On a 128-thread machine, objtool on the gcc allmodconfig vmlinux.o goes
from 9.0s to 6.8s. A defconfig vmlinux.o already had 2^20 buckets and is
unchanged.

objtool on vmlinux.o is on the serial tail of every build that links
vmlinux, no-op builds are unchanged.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 allmodconfig, touch mm/vma.c, gcc    28.0s    25.7s     -2.4s (-8%)
  x86 allmodconfig, touch mm/vma.c, clang  26.2s    24.1s     -2.0s (-8%)

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/objtool/check.c                   | 58 +++++++++++++++++++++++++++++++--
 tools/objtool/include/objtool/objtool.h |  3 +-
 tools/objtool/objtool.c                 |  1 -
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 464f6c9d9ff0..62a3e1d4e9e5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -38,12 +38,22 @@ struct disas_context *objtool_disas_ctx;
 
 size_t sym_name_max_len;
 
+static struct hlist_head *insn_hash_head(struct objtool_file *file,
+					 struct section *sec, unsigned long offset)
+{
+	/* Determine instruction hash based on section index and offset. */
+	const u32 sec_hash = sec_offset_hash(sec, offset);
+	const u32 hash = hash_min(sec_hash, file->insn_hash_bits);
+
+	return &file->insn_hash[hash];
+}
+
 struct instruction *find_insn(struct objtool_file *file,
 			      struct section *sec, unsigned long offset)
 {
 	struct instruction *insn;
 
-	hash_for_each_possible(file->insn_hash, insn, hash, sec_offset_hash(sec, offset)) {
+	hlist_for_each_entry(insn, insn_hash_head(file, sec, offset), hash) {
 		if (insn->sec == sec && insn->offset == offset)
 			return insn;
 	}
@@ -403,6 +413,44 @@ static void *cfi_hash_alloc(unsigned long size)
 static unsigned long nr_insns;
 static unsigned long nr_insns_visited;
 
+/*
+ * sec_offset_hash() keys on OFFSET_STRIDE windows, so the instructions of a
+ * window share a chain and buckets beyond one per window would sit empty.
+ */
+#define INSN_HASH_BYTES_PER_BUCKET	OFFSET_STRIDE
+#define INSN_HASH_MIN_BITS		10
+
+static unsigned long total_text_size(struct objtool_file *file)
+{
+	unsigned long size = 0;
+	struct section *sec;
+
+	for_each_sec(file->elf, sec)
+		if (is_text_sec(sec))
+			size += sec_size(sec);
+
+	return size;
+}
+
+static int alloc_insn_hash(struct objtool_file *file, unsigned long text_size)
+{
+	const unsigned long nr_buckets = text_size / INSN_HASH_BYTES_PER_BUCKET;
+	const int bits = ilog2(nr_buckets);
+
+	file->insn_hash_bits = max(INSN_HASH_MIN_BITS, bits);
+	file->insn_hash = calloc(1UL << file->insn_hash_bits,
+				 sizeof(*file->insn_hash));
+	if (!file->insn_hash) {
+		ERROR_GLIBC("calloc");
+		return -1;
+	}
+
+	if (opts.stats)
+		printf("insn_hash_bits: %d\n", file->insn_hash_bits);
+
+	return 0;
+}
+
 /*
  * Call the arch-specific instruction decoder for all the instructions and add
  * them to the global instruction list.
@@ -414,6 +462,9 @@ static int decode_instructions(struct objtool_file *file)
 	unsigned long offset;
 	struct instruction *insn;
 
+	if (alloc_insn_hash(file, total_text_size(file)))
+		return -1;
+
 	for_each_sec(file->elf, sec) {
 		struct instruction *insns = NULL;
 		u8 prev_len = 0;
@@ -474,7 +525,7 @@ static int decode_instructions(struct objtool_file *file)
 			if (insn->type == INSN_BUG)
 				insn->dead_end = true;
 
-			hash_add(file->insn_hash, &insn->hash, sec_offset_hash(sec, insn->offset));
+			hlist_add_head(&insn->hash, insn_hash_head(file, sec, insn->offset));
 			nr_insns++;
 		}
 
@@ -4802,6 +4853,9 @@ void free_insns(struct objtool_file *file)
 
 	for (chunk = chunks; chunk; chunk = chunk->next)
 		free(chunk->addr);
+
+	free(file->insn_hash);
+	file->insn_hash = NULL;
 }
 
 const char *objtool_disas_insn(struct instruction *insn)
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 6dc12a59ad00..79fe82b7397e 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -21,7 +21,8 @@ struct pv_state {
 
 struct objtool_file {
 	struct elf *elf;
-	DECLARE_HASHTABLE(insn_hash, 20);
+	struct hlist_head *insn_hash;
+	int insn_hash_bits;
 	struct list_head retpoline_call_list;
 	struct list_head return_thunk_list;
 	struct list_head static_call_list;
diff --git a/tools/objtool/objtool.c b/tools/objtool/objtool.c
index a4e139dee7e9..71e048f8582a 100644
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -29,7 +29,6 @@ struct objtool_file *objtool_open_read(const char *filename)
 	if (!file.elf)
 		return NULL;
 
-	hash_init(file.insn_hash);
 	INIT_LIST_HEAD(&file.retpoline_call_list);
 	INIT_LIST_HEAD(&file.return_thunk_list);
 	INIT_LIST_HEAD(&file.static_call_list);

-- 
2.55.0

