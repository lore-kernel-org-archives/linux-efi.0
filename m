Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4E73D3326;
	Tue,  8 Sep 2026 20:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900979; cv=none; b=kBcMJzsogYMkhbJHDjKF1gBsthzjNkFhRHHJtPh6zqPsTeRrB+uqw2ZYcW6iW7MZ5Dfxdm6wSIs4NffAQoKN3obHQuKxg+7yN2dWa20zW0Q/NhHtsaOn0L6kp5sL/XqTZ0pipZv0HkbokDAzF6QHdXELP67i1VC9galBtcraxmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900979; c=relaxed/simple;
	bh=qlI+vtmJCyqlOtepyI2T6wkgajjnp3VDGZ2zqEVGU5k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gQUCPdusRvFGnlxwBLjf1a0JHrFQlCMZBdjUS4VASEexKKb5BQcUjrUigi4dfx3rTOB7itKtIMC+ZIgPZoY3Kq29B24qAK1IXIDZb1avNTodmMQk2l1MD+Kz3EQYlQbHuR3JKs4vbyaaiR1w/KAK1kutOIbpapM3dyKBZPvv8Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RO4VT5Sp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RO4VT5Sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CD41F00A3A;
	Tue,  8 Sep 2026 20:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900977;
	bh=gzOTfxSGylhKOntm1gQtYgz8iaN6ExlVVoWePFdIyaU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RO4VT5Sp7Sz2IeKw7Z0XAlH8xzntgrKZT4ZGArJJgdkmJLC0D0eEwYzcerI1gi8Le
	 TMxew8PSqEod5Aq3Xuv1s5niu3ckEBaUAn2yyPnxjS1Mre7LJrI+BbVWtF90RXxAbv
	 weU8CgHS8yRwbnEo+I70jMfPawtjOhY//TZKsCX51vXsUEWRSu+90aBsU5JRwZU/Np
	 LcAYdzco6wAekH4dLPr9A8N1dcnJcQBLgVzbO36zYKxUC9GwNoPKMRzB74Ovs9J6US
	 g15V0rkMUXDjFqL0MWJ/5cdi/Y2rPKXi/w+j0klBK5BowkRuVtBJZgjAD+519B7wAQ
	 +jOMr51D1K5fA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:55:04 +0100
Subject: [PATCH 04/23] kallsyms: output binary data to speed output and
 kallsyms assembly
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-build-speedup-v1-4-5dc1ac01672d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8922; i=ljs@kernel.org;
 h=from:subject:message-id; bh=qlI+vtmJCyqlOtepyI2T6wkgajjnp3VDGZ2zqEVGU5k=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWlJlNFlBsyjzodtpulmNMHNexqB1iaUXs5dt79u58U
 WwkzL+2o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABO5p8zIsCFw8coXKtv3NYc3
 s11NFZzzaJ6S5jS7jqMBulqiOe112gz/s9Qy7pRdm7vcuFBe81zVOiXbWewcNdxcPGWP8pl5iia
 yAAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

kallsyms generates an assembly file that consists mostly of .byte entries
containing compressed names, token strings and name-sorted sequence
numbers.

For an x86-64 build with 158k symbols that is a 37 MiB .S file which takes
0.57s to assemble each of the two to three times it is built over a kernel
build.

Each time it is generated it also takes kallsyms a similar amount of time
to output it.

Avoid this overhead by instead outputting this data as binary and importing
it into the assembly using the .incbin directive.

Tables that are wider than a byte remain part of the assembly to ensure
endianness and relative relocations are performed correctly.

With this change, the output assembly file shrinks from 37 MiB to 9.8 MiB,
with a 2.6 MiB binary data file alongside it, and the object remains
identical.

The generated binary file is deleted correctly on build clean along with
all other ephemeral data.

On an x86-64 system with CONFIG_KALLSYMS_ALL set:

                       before   after    delta
  scripts/kallsyms     0.24s    0.18s    0.06s
  assemble             0.57s    0.16s    0.41s

Per kallsyms invocation/assembly, for a total of 0.47s time saving upon
invocation.

An incremental build on the same system was reduced from 11.15s to 9.65s,
indicating a total of 1.5 seconds saved over the build.

The kallsyms runs and their assembly are on the serial tail of every build
that links vmlinux, no-op builds are unchanged.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 defconfig, touch mm/vma.c, gcc       10.8s     9.9s    -0.92s (-8%)
  x86 defconfig, touch mm/vma.c, clang     10.7s     9.5s     -1.2s (-11%)
  x86 defconfig, clean, gcc                29.5s    28.7s    -0.81s (-3%)
  x86 defconfig, clean, clang              29.7s    28.6s     -1.1s (-4%)
  x86 allmodconfig, touch mm/vma.c, gcc    45.3s    44.0s     -1.3s (-3%)
  x86 allmodconfig, touch mm/vma.c, clang  42.9s    40.2s     -2.7s (-6%)

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 scripts/kallsyms.c      | 97 ++++++++++++++++++++++++++++++++++++++-----------
 scripts/link-vmlinux.sh |  2 +-
 2 files changed, 77 insertions(+), 22 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 350d118c3b9e..61c5eb537ed4 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -5,7 +5,10 @@
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
  *
- * Usage: kallsyms [--all-symbols] in.map > out.S
+ * Usage: kallsyms [--all-symbols] [--pc-relative] in.map out.bin > out.S
+ *
+ *      The byte tables go to out.bin and are pulled into out.S with .incbin;
+ *  wider tables stay assembler source for endianness and relocations.
  *
  *      Table compression uses all the unused char codes on the symbols and
  *  maps these to the most used substrings (tokens). For instance, it might
@@ -102,7 +105,7 @@ static void sym_arr_free(struct sym_arr *arr)
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: kallsyms [--all-symbols] in.map > out.S\n");
+	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--pc-relative] in.map out.bin > out.S\n");
 	exit(1);
 }
 
@@ -319,6 +322,40 @@ static void output_label(const char *label)
 	printf("%s:\n", label);
 }
 
+static void write_bin(FILE *file, const void *data, size_t len)
+{
+	if (fwrite(data, 1, len, file) == len)
+		return;
+
+	perror("kallsyms: write");
+	exit(EXIT_FAILURE);
+}
+
+static void write_byte_bin(FILE *file, unsigned char byte)
+{
+	write_bin(file, &byte, 1);
+}
+
+static long bin_pos(FILE *file)
+{
+	const long pos = ftell(file);
+
+	if (pos < 0) {
+		perror("kallsyms: ftell");
+		exit(EXIT_FAILURE);
+	}
+
+	return pos;
+}
+
+static void write_incbin(const char *filename, long start, long end)
+{
+	if (start >= end)
+		return;
+
+	printf("\t.incbin \"%s\", %ld, %ld\n", filename, start, end - start);
+}
+
 /* uncompress a compressed symbol. When this function is called, the best table
  * might still be compressed itself, so the function needs to be recursive */
 static int expand_symbol(const unsigned char *data, int len, char *result)
@@ -371,11 +408,12 @@ static void sort_symbols_by_name(void)
 	qsort(table, table_cnt, sizeof(table[0]), compare_names);
 }
 
-static void write_src(void)
+static void write_src(FILE *out_bin_file, const char *out_bin_name)
 {
-	unsigned int i, k, off;
+	unsigned int i, off;
 	unsigned int best_idx[256];
 	unsigned int *markers, markers_cnt;
+	long bin_start;
 	char buf[KSYM_NAME_LEN];
 
 	printf("\t.section .rodata, \"a\"\n");
@@ -390,6 +428,7 @@ static void write_src(void)
 	markers = xmalloc(sizeof(*markers) * markers_cnt);
 
 	output_label("kallsyms_names");
+	bin_start = bin_pos(out_bin_file);
 	off = 0;
 	for (i = 0; i < table_cnt; i++) {
 		if ((i & 0xFF) == 0)
@@ -413,26 +452,24 @@ static void write_src(void)
 		/* Encode length with ULEB128. */
 		if (table[i]->len <= 0x7F) {
 			/* Most symbols use a single byte for the length. */
-			printf("\t.byte 0x%02x", table[i]->len);
+			write_byte_bin(out_bin_file, table[i]->len);
 			off += table[i]->len + 1;
 		} else {
 			/* "Big" symbols use two bytes. */
-			printf("\t.byte 0x%02x, 0x%02x",
-				(table[i]->len & 0x7F) | 0x80,
-				(table[i]->len >> 7) & 0x7F);
+			write_byte_bin(out_bin_file, (table[i]->len & 0x7F) | 0x80);
+			write_byte_bin(out_bin_file, (table[i]->len >> 7) & 0x7F);
 			off += table[i]->len + 2;
 		}
-		for (k = 0; k < table[i]->len; k++)
-			printf(", 0x%02x", table[i]->sym[k]);
+		write_bin(out_bin_file, table[i]->sym, table[i]->len);
 
 		/*
 		 * Now that we wrote out the compressed symbol name, restore the
-		 * original name and print it in the comment.
+		 * original name for the comments below.
 		 */
 		expand_symbol(table[i]->sym, table[i]->len, buf);
 		strcpy((char *)table[i]->sym, buf);
-		printf("\t/* %s */\n", table[i]->sym);
 	}
+	write_incbin(out_bin_name, bin_start, bin_pos(out_bin_file));
 	printf(".size kallsyms_names, . - kallsyms_names\n");
 	printf("\n");
 
@@ -445,13 +482,15 @@ static void write_src(void)
 	free(markers);
 
 	output_label("kallsyms_token_table");
+	bin_start = bin_pos(out_bin_file);
 	off = 0;
 	for (i = 0; i < 256; i++) {
 		best_idx[i] = off;
 		expand_symbol(best_table[i], best_table_len[i], buf);
-		printf("\t.asciz\t\"%s\"\n", buf);
+		write_bin(out_bin_file, buf, strlen(buf) + 1);
 		off += strlen(buf) + 1;
 	}
+	write_incbin(out_bin_name, bin_start, bin_pos(out_bin_file));
 	printf(".size kallsyms_token_table, . - kallsyms_token_table\n");
 	printf("\n");
 
@@ -484,12 +523,13 @@ static void write_src(void)
 
 	sort_symbols_by_name();
 	output_label("kallsyms_seqs_of_names");
-	for (i = 0; i < table_cnt; i++)
-		printf("\t.byte 0x%02x, 0x%02x, 0x%02x\t/* %s */\n",
-			(unsigned char)(table[i]->seq >> 16),
-			(unsigned char)(table[i]->seq >> 8),
-			(unsigned char)(table[i]->seq >> 0),
-		       table[i]->sym);
+	bin_start = bin_pos(out_bin_file);
+	for (i = 0; i < table_cnt; i++) {
+		write_byte_bin(out_bin_file, table[i]->seq >> 16);
+		write_byte_bin(out_bin_file, table[i]->seq >> 8);
+		write_byte_bin(out_bin_file, table[i]->seq >> 0);
+	}
+	write_incbin(out_bin_name, bin_start, bin_pos(out_bin_file));
 	printf("\n");
 }
 
@@ -798,6 +838,9 @@ static void sort_symbols(void)
 
 int main(int argc, char **argv)
 {
+	const char *out_bin_name;
+	FILE *out_bin_file;
+
 	while (1) {
 		static const struct option long_options[] = {
 			{"all-symbols",     no_argument, &all_symbols,     1},
@@ -813,14 +856,26 @@ int main(int argc, char **argv)
 			usage();
 	}
 
-	if (optind >= argc)
+	if (optind + 2 != argc)
 		usage();
 
+	out_bin_name = argv[optind + 1];
+	out_bin_file = fopen(out_bin_name, "w");
+	if (!out_bin_file) {
+		perror(out_bin_name);
+		exit(EXIT_FAILURE);
+	}
+
 	read_map(argv[optind]);
 	shrink_table();
 	sort_symbols();
 	optimize_token_table();
-	write_src();
+	write_src(out_bin_file, out_bin_name);
+
+	if (fclose(out_bin_file)) {
+		perror(out_bin_name);
+		exit(EXIT_FAILURE);
+	}
 
 	return 0;
 }
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index ab0b8125c8cb..e88604150d2c 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -132,7 +132,7 @@ kallsyms()
 	fi
 
 	info KSYMS "${2}.S"
-	scripts/kallsyms ${kallsymopt} "${1}" > "${2}.S"
+	scripts/kallsyms ${kallsymopt} "${1}" "${2}.bin" > "${2}.S"
 
 	info AS "${2}.o"
 	${CC} ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS} \

-- 
2.55.0

