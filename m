Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D141A406822;
	Tue,  8 Sep 2026 20:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901114; cv=none; b=J0GwMPyN5VJQhpggC8lWihr5Gag6ltV/t+7qLca88hjvYkeRjWiqOrDgrVMwuG7ebH7W/7XWj8rQxCSk0uFGbcoWdXgNYR+TzOu3gBcRxWp7mSkWsAynVKww//zyKCGde5xojQBgAiqu791+HT4mGYRceP5R5CekLFJJTywIff4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901114; c=relaxed/simple;
	bh=Gelur0DpysKwUODmcguGccgt6clYJhYW6IXRF54x23c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=H8aWYkfIlCbeW2aGWkYSDFAx+RstSZbJXo5Th6/hs6CrQfsghVRWe7iPxf4KXOWUZuu5csJ5Bm/gfYvPGGxGMaFaEpAjRPEPhtT5ZKyIciGZJpn/SIKYji85brBaz3DD6AqDtfWGeVusopUqwhoC+El9tiWEijVeryeQUQZYvQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UoHfTkok; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UoHfTkok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9201F00A3A;
	Tue,  8 Sep 2026 20:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901112;
	bh=pI6ihjInprs3EsyWvkPxTax/MQzOf/BnFtLX0/4DRHk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UoHfTkokxUxDvJUJNI0gY83ydEKYo9TV+HnOqobx9nDhcAVm/5ftXE/PQ7RqP+BMO
	 ZyNOVUWijWGwyRLnZpuAPq5SxPKytoYXq7wgOdivVdtNjQfwe+ocBe2vDMAOD8d7V1
	 RsDmC4+N4D7PIO+TALKkFcNyfZZcRR07hBdcp/S94BKuCdvcNMEv/cI3X5AjYLxugm
	 XKh/n+j+/McakEWmmtsT3cbxhZeE4kdsKTd/8NM6HGZ4SwRYBmtXXhTNkgZtSEUlQ3
	 ZCQgq76v3wYtOYUL+u8spfd7WcLC4Szxy4RN/QFJ/uA/4JUlNWXFcLSfwsen26eFNb
	 njbLnnbezVWGw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:55:16 +0100
Subject: [PATCH 16/23] kbuild: batch module finalisation
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-build-speedup-v1-16-5dc1ac01672d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4146; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Gelur0DpysKwUODmcguGccgt6clYJhYW6IXRF54x23c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWlFmYvV7lYBfmt0UvYf2hCVfScyq9LfxLQ2YW+h7eP
 fWgmm5YRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACayjp2R4TZvs0gN81KrvwzJ
 L/SZsyo77jQfeuBvJ66+aH6oZd2CZIb/ocsudvxk8HW7K32qrMbi6ffWnO6Pp8IsA5t3/m9c966
 TCQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Module finalisation on allmodconfig builds consists of a large number of
very short-lived jobs, and the make job dispatcher cannot possibly dispatch
jobs fast enough.

For allmodconfig x86-64 this can be on the order of ~22,000 jobs of a few
milliseconds in duration each.

However per-job cost grows with the variables the instance holds, here the
savedcmd_* of every .mod.o and .ko read back from the .cmd files, since it
walks them all to build each child's environment.

This makes module finalisation very inefficient when large numbers of
modules are being built.

Fix this by splitting modules.order into chunks of 128 at a time, run in
parallel.

Each instance holds only its own modules' variables and the top-level one
reads no per-module .cmd files at all, the same rules serve both levels,
and an instance is told its chunk with modfinal-first=<index>.

"make modules" with every *.mod.o and *.ko deleted goes from 28.9s to 15.9s
with clang 22. No-op "make modules" goes from 5.6s to 4.8s, as checking the
22,000 targets is spread over the chunks too.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 allmodconfig, no-op make, gcc         1.9s     1.2s    -0.74s (-39%)
  x86 allmodconfig, no-op make, clang       2.4s     1.6s    -0.77s (-32%)
  x86 allmodconfig, clean, gcc            304.5s   291.4s     -13.1s (-4%)
  x86 allmodconfig, clean, clang          301.7s   297.0s     -4.7s (-2%)

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 scripts/Makefile.modfinal | 26 +++++++++++++++++++++++++-
 scripts/mod/sumversion.c  |  4 ++--
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 75e9effdf02c..858fa798090b 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -13,9 +13,30 @@ include $(srctree)/scripts/Makefile.lib
 # find all modules listed in modules.order
 modules := $(call read-file, modules.order)
 
+modfinal-chunk-size := 128
+
+ifdef modfinal-first
+
+# this instance handles the chunk of modules.order starting at $(modfinal-first)
+modules := $(wordlist $(modfinal-first), $(words $(modules)), $(modules))
+modules := $(wordlist 1, $(modfinal-chunk-size), $(modules))
+
 __modfinal: $(modules:%.o=%.ko)
 	@:
 
+else
+
+modfinal-chunks := $(addprefix chunk-, $(shell seq 1 $(modfinal-chunk-size) $(words $(modules))))
+
+PHONY += $(modfinal-chunks)
+$(modfinal-chunks): .module-common.o
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modfinal modfinal-first=$(@:chunk-%=%)
+
+__modfinal: $(modfinal-chunks)
+	@:
+
+endif
+
 # modname and part-of-module are set to make c_flags define proper module flags
 modname = $(notdir $(@:.mod.o=))
 part-of-module = y
@@ -58,7 +79,10 @@ ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 endif
 	+$(call cmd,check_tracepoint)
 
-targets += $(modules:%.o=%.ko) $(modules:%.o=%.mod.o) .module-common.o
+targets += .module-common.o
+ifdef modfinal-first
+targets += $(modules:%.o=%.ko) $(modules:%.o=%.mod.o)
+endif
 
 # Add FORCE to the prerequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------
diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index 2cbadd3cd97d..5501d6aa0bea 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -249,7 +249,7 @@ static int parse_comment(const char *file, unsigned long len)
 /* FIXME: Handle .s files differently (eg. # starts comments) --RR */
 static bool stop_char[256];
 
-static void init_stop_chars(void)
+static void sumversion_init(void)
 {
 	static bool done;
 	int chr;
@@ -274,7 +274,7 @@ static int parse_file(const char *fname, struct md4_ctx *md)
 	len = strlen(file);
 	if (!len)
 		goto out_file;
-	init_stop_chars();
+	sumversion_init();
 	buf = xmalloc(len); /* File output buffer. */
 
 	for (i = 0; i < len; i++) {

-- 
2.55.0

