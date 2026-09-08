Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A2E3CD8C5;
	Tue,  8 Sep 2026 20:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901125; cv=none; b=mrhbw7rH3eI3kx3QSJMbrpyY9T7Ejty/fFP3ICUgPLHqoYHCzfJTEStBNzWErcNIpUVl+xPwHCyGH+A5ar3+19cYCrfySURlnxQMg6WXqbpRY7oH615V/i/Lga9bsGEvNABRuFTnHyBCeB1mLpsiHvrq/2OgYN7/e0hTM2xAHw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901125; c=relaxed/simple;
	bh=WICQxA7wSs1OjQCOKkZs0RphLh6aY8TzrexzGYQ5YdM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ke5BHrag9u1AkSd0gOFceicMTwuTBFlgN4L55RzbC25I48TCKzXrtGm9DvWMHqOJstsGewTF+MuKmdJST6S80Q/DXRlIBW81F/PRQUU05RqOJUkRy8dNIio1anyuQBr9LFl5J7Tr+aqBcNKRHsrgeO1Tn/ScPXvqkz2lE/PmSm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6lx/od9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6lx/od9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABE81F00A3D;
	Tue,  8 Sep 2026 20:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901123;
	bh=uqBq8a6PBmwcf0p2yuh6c4ut6ERzykBEHjxf3/hGkX8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=e6lx/od9mLRaFbj6pD8WjdyUrpu387L5oUbxsS74POQpizvsu2X9B5alOW1uFj8y5
	 BogpoBtibbPrlFDz4Ec3/AdNz6xfPwZHUB5guwX01WhFo9UMbOB2aUsI9pZsrRRAP4
	 wLq+X3qQGbQ3EeoOOjm9JR1UCr2lqd+VX4HE/xOvgXCQToYgf4Uq0lu6WcIoU831NT
	 3Zr0ZWhdRXCFxU99AazeTkyNbDJRABmRLmC5/jK+DX1UXfCtMjxQZsFLerx/2qIlYU
	 IYr/jQMlMujoHloJcSVIewZGRNZ7u1U02GBUq6x7y5XXIcE7+DXZzJcawr7XnyLaFC
	 RprAR8YIz6BTg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:55:17 +0100
Subject: [PATCH 17/23] modpost: perform srcversion hashing in parallel
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-build-speedup-v1-17-5dc1ac01672d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5781; i=ljs@kernel.org;
 h=from:subject:message-id; bh=WICQxA7wSs1OjQCOKkZs0RphLh6aY8TzrexzGYQ5YdM=;
 b=kA0DAAoWz53NioHifxQByyZiAGqgdjiivqgxWMcAzwXiFMjxhapr5eptu4LqrpJHxWdzErhUN
 Yh1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmqgdjgACgkQz53NioHifxRJhQD+KkKD
 qLzGPYKtOKR3m+zxpGn6XPTCEmJRgn6E7DzMTooBAIO2t2bh9xq8Miz8ic/o7YF92YFvKDtRCsm
 kxE2EVJsK
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

modpost does a lot of single-threaded work hashing files from each object's
.cmd file.

This makes the build slower than it needs to be, so do this work in
parallel.

This is egregious for allmodconfig builds - for instance x86-64 can end up
opening 200,000 files individually and hashing them all serially.

Parallelise this operation by maintaining a thread pool for the hashing
work.

Combined with the per-file hashing commit this cuts modpost's run time
nearly in half for an allmodconfig build.

Module.symvers and every *.mod.S are byte for byte the same.

modpost is on the serial tail of every allmodconfig build, however
defconfig does not set CONFIG_MODULE_SRCVERSION_ALL and is unchanged.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 allmodconfig, touch mm/vma.c, gcc    33.4s    30.2s     -3.2s (-10%)
  x86 allmodconfig, touch mm/vma.c, clang  31.1s    28.1s     -3.0s (-10%)

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 scripts/mod/Makefile     |  1 +
 scripts/mod/modpost.c    | 72 ++++++++++++++++++++++++++++++++++++++++++++++--
 scripts/mod/modpost.h    |  2 ++
 scripts/mod/sumversion.c |  3 +-
 4 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index fbd5099e0441..fdd486184f9c 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -5,6 +5,7 @@ hostprogs-always-y	+= modpost mk_elfconfig
 always-y		+= empty.o
 
 modpost-objs	:= modpost.o file2alias.o sumversion.o symsearch.o
+HOSTLDLIBS_modpost := -lpthread
 
 devicetable-offsets-file := devicetable-offsets.h
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 550ccd753ed8..882169e51851 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -16,6 +16,7 @@
 #include <fnmatch.h>
 #include <stdio.h>
 #include <ctype.h>
+#include <pthread.h>
 #include <string.h>
 #include <limits.h>
 #include <stdbool.h>
@@ -1717,8 +1718,7 @@ static void read_symbols(const char *modname)
 	if (!mod->is_vmlinux) {
 		version = get_modinfo(&info, "version");
 		if (version || all_versions)
-			get_src_version(mod->name, mod->srcversion,
-					sizeof(mod->srcversion) - 1);
+			mod->need_srcversion = true;
 	}
 
 	parse_elf_finish(&info);
@@ -1736,6 +1736,72 @@ static void read_symbols(const char *modname)
 	}
 }
 
+static struct module **srcversion_mods;
+static unsigned int nr_srcversion_mods, next_srcversion_mod;
+
+static bool get_next_src_version(void)
+{
+	struct module *mod;
+	unsigned int idx;
+
+	idx = __sync_fetch_and_add(&next_srcversion_mod, 1);
+	if (idx >= nr_srcversion_mods)
+		return false;
+	mod = srcversion_mods[idx];
+
+	get_src_version(mod->name, mod->srcversion,
+			sizeof(mod->srcversion) - 1);
+	return true;
+}
+
+static void *srcversion_worker(void *arg)
+{
+	while (get_next_src_version())
+		;
+
+	return NULL;
+}
+
+static void hash_srcversions(void)
+{
+	unsigned int i = 0;
+	struct module *mod;
+	pthread_t *threads;
+	long nr_threads;
+
+	list_for_each_entry(mod, &modules, list)
+		if (mod->need_srcversion)
+			nr_srcversion_mods++;
+
+	if (!nr_srcversion_mods)
+		return;
+
+	srcversion_mods = xmalloc(nr_srcversion_mods * sizeof(*srcversion_mods));
+
+	list_for_each_entry(mod, &modules, list)
+		if (mod->need_srcversion)
+			srcversion_mods[i++] = mod;
+
+	nr_threads = sysconf(_SC_NPROCESSORS_ONLN);
+	nr_threads = nr_threads < 1 ? 1 : nr_threads; /* On error assume 1. */
+	if (nr_threads > nr_srcversion_mods)
+		nr_threads = nr_srcversion_mods;
+
+	sumversion_init();
+	threads = xmalloc(nr_threads * sizeof(*threads));
+	for (i = 0; i < nr_threads; i++) {
+		if (pthread_create(&threads[i], NULL, srcversion_worker, NULL)) {
+			perror("pthread_create");
+			exit(1);
+		}
+	}
+	for (i = 0; i < nr_threads; i++)
+		pthread_join(threads[i], NULL);
+
+	free(threads);
+	free(srcversion_mods);
+}
+
 static void read_symbols_from_files(const char *filename)
 {
 	FILE *in = stdin;
@@ -2729,6 +2795,8 @@ int main(int argc, char **argv)
 	if (files_source)
 		read_symbols_from_files(files_source);
 
+	hash_srcversions();
+
 	list_for_each_entry(mod, &modules, list) {
 		keep_no_trim_symbols(mod);
 
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index d5f6d82837d5..10d5f8f2f293 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -127,6 +127,7 @@ struct module {
 	bool has_init;
 	bool has_cleanup;
 	char	     srcversion[25];
+	bool need_srcversion;
 	// Missing namespace dependencies
 	struct list_head missing_namespaces;
 	// Actual imported namespaces
@@ -213,6 +214,7 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 			Elf_Sym *sym, const char *symname);
 
 /* sumversion.c */
+void sumversion_init(void);
 void get_src_version(const char *modname, char sum[], unsigned sumlen);
 
 /* from modpost.c */
diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index 5501d6aa0bea..4521b92ef868 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -249,7 +249,7 @@ static int parse_comment(const char *file, unsigned long len)
 /* FIXME: Handle .s files differently (eg. # starts comments) --RR */
 static bool stop_char[256];
 
-static void sumversion_init(void)
+void sumversion_init(void)
 {
 	static bool done;
 	int chr;
@@ -402,7 +402,6 @@ static int parse_source_files(const char *objfile, struct md4_ctx *md)
 				     line, strerror(errno));
 				goto out_file;
 			}
-
 		}
 
 	}

-- 
2.55.0

