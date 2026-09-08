Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6593F327A;
	Tue,  8 Sep 2026 20:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901080; cv=none; b=d3C5ukxRbc6IqmLn9dFn195U/iHzaPfLUoJcXhACa5G300iESyUeqS7acNinLR/Jh4/Ynf5WTcGLgxdCRK9WkgYNfdAd7fsk2TguCndMRer+bKp6IuU/ySDL10mq3yD933U4U6E8ip45RgNneZaHABfyuIApELZ4QtGZYNBcAho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901080; c=relaxed/simple;
	bh=Mu9/3L6JwuoO4qE0B5TB19zN1X+uYA2ATdK9i0ZQjsI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KWytDAf2QKaf3SyDHbWfm2XuyJaEsXp4p1qu2ybQRYaHNNtC4E9QdNirJLl7V71IMEWvLT96Au852ga0ogwiVyfvUsy1rIiKDH/yHgoJPw6RFRkDquihQ7wKcl71sE7KT4CZTIq4zp34zMntXBG80rG57MNnnJv6croZ9tPkqjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7eOezsG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7eOezsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018651F00ACA;
	Tue,  8 Sep 2026 20:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901078;
	bh=o9XBtkaVqNcdBkr0fOqwTDFvihvtpSpEfmr2OcpAjrM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=H7eOezsG/k4L7RnezQlzDmyxYvIW6bywyEUwrvTlZzo4lKh0vtSAfck1wkSXTQ9ev
	 VmZAJpvkEPwqDX3YHmC2BMJU5vL4+Jp8Qz22aWlTQoLIDTQ8d9YGnPv4v7SZKWJmD5
	 mTT1ODPotGOg6g/x0H87aTh061dDmL+8/iK+4eYyFoJK4js88YkUgoiBLn7V8GzuoJ
	 y6i71GmBdFm8MSKvOsDdb2m+Z6GbI99drwRspDJqnv1ylIFlbuxjYAzmCi1oKczYfM
	 P+rh2C9C8oqjl+1HOSJ9/d0i9kia2cmslDtIwrafGPzwwR1QJoYTXLQFpyVjQtdJ3Y
	 OpWXnJrOCY06A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:55:13 +0100
Subject: [PATCH 13/23] modpost: hash module source per-file, not per-byte
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-build-speedup-v1-13-5dc1ac01672d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3622; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Mu9/3L6JwuoO4qE0B5TB19zN1X+uYA2ATdK9i0ZQjsI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWlJmrS6scTz06IbNlhe9Px+M2gU853vLcZxboy2Ziz
 l/vw76so5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABN5tpbhv1eSsfzRGv+JKq57
 9kz547UpXNTouVWchL6z5PO2L/VcTxj+J2n+Wl9knuH4X+q39dVyu90tolvqPb4dUZc0fis89dx
 TTgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

modpost spends a long time md4 hashing module source at a per-byte
granularity.

Fix this by doing this hashing per-file instead by accumulating a per-file
buffer in parse_file().

All 11,189 .mod.c files and Module.symvers were confirmed to be identical
with this change applied.

This is especially impactful for allmodconfig incremental builds (where
CONFIG_MODULE_SRCVERSION_ALL is set).

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 allmodconfig, touch mm/vma.c, gcc    40.6s    38.2s     -2.4s (-6%)
  x86 allmodconfig, touch mm/vma.c, clang  36.2s    35.0s     -1.2s (-3%)

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 scripts/mod/sumversion.c | 56 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 12 deletions(-)

diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index 3dd28b4d0099..2cbadd3cd97d 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -224,19 +224,11 @@ static void md4_final_ascii(struct md4_ctx *mctx, char *out, unsigned int len)
 		 mctx->hash[0], mctx->hash[1], mctx->hash[2], mctx->hash[3]);
 }
 
-static inline void add_char(unsigned char c, struct md4_ctx *md)
-{
-	md4_update(md, &c, 1);
-}
-
-static int parse_string(const char *file, unsigned long len,
-			struct md4_ctx *md)
+static int parse_string(const char *file, unsigned long len)
 {
 	unsigned long i;
 
-	add_char(file[0], md);
 	for (i = 1; i < len; i++) {
-		add_char(file[i], md);
 		if (file[i] == '"' && file[i-1] != '\\')
 			break;
 	}
@@ -255,15 +247,44 @@ static int parse_comment(const char *file, unsigned long len)
 }
 
 /* FIXME: Handle .s files differently (eg. # starts comments) --RR */
+static bool stop_char[256];
+
+static void init_stop_chars(void)
+{
+	static bool done;
+	int chr;
+
+	if (done)
+		return;
+
+	for (chr = 0; chr < 256; chr++)
+		if (chr == '\\' || chr == '"' || chr == '/' || isspace(chr))
+			stop_char[chr] = true;
+
+	done = true;
+}
+
 static int parse_file(const char *fname, struct md4_ctx *md)
 {
+	unsigned long i, len, n = 0;
+	unsigned char *buf;
 	char *file;
-	unsigned long i, len;
 
 	file = read_text_file(fname);
 	len = strlen(file);
+	if (!len)
+		goto out_file;
+	init_stop_chars();
+	buf = xmalloc(len); /* File output buffer. */
 
 	for (i = 0; i < len; i++) {
+		const unsigned char chr = file[i];
+
+		if (!stop_char[chr]) {
+			buf[n++] = file[i];
+			continue;
+		}
+
 		/* Collapse and ignore \ and CR. */
 		if (file[i] == '\\' && (i+1 < len) && file[i+1] == '\n') {
 			i++;
@@ -276,7 +297,14 @@ static int parse_file(const char *fname, struct md4_ctx *md)
 
 		/* Handle strings as whole units */
 		if (file[i] == '"') {
-			i += parse_string(file+i, len - i, md);
+			unsigned long slen = parse_string(file+i, len - i);
+
+			/* Closing quote is included if there is one. */
+			if (slen < len - i)
+				slen++;
+			memcpy(buf + n, file + i, slen);
+			n += slen;
+			i += slen - 1;
 			continue;
 		}
 
@@ -286,11 +314,15 @@ static int parse_file(const char *fname, struct md4_ctx *md)
 			continue;
 		}
 
-		add_char(file[i], md);
+		buf[n++] = file[i];
 	}
+	md4_update(md, buf, n);
+	free(buf);
+out_file:
 	free(file);
 	return 1;
 }
+
 /* Check whether the file is a static library or not */
 static bool is_static_library(const char *objfile)
 {

-- 
2.55.0

