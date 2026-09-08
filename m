Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE503C4B81;
	Tue,  8 Sep 2026 20:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901192; cv=none; b=ObBupEnVVERFZVfxYjlOlR7Bz0Guhsn9Mw4rwIJVAnOzupRlY66/+R69XmMlIKoDNNWO9BNex+1ZGlv7hEPQWNmpZMwdWPgC2NIWlvqTNQBPIfdC8i8yF2i6fyenmyCByzhGTh1tN8Ix/vU95FcKZXenVCJ9FjCgULbpvEJVvyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901192; c=relaxed/simple;
	bh=/cGfZoMmr7KpIZ+1dXwGv9v2Wc3LWJWwGs5e7Tz+VNE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d5vsW7b5PpgZyy/q6vQOQmWPRPId1EeCNnpmq+5rJ9+OG+9cE7IDMjx2omfaDATU3N8s+w9hsPyZqaszU8Wp/o4BsunjqU5q9O1QF0CpG2oWOgrpg+2/aSuGJ7GkWLthGNzGJiMszm6zf5stDa2ni+Y0I7GdiU+6AjqZG/8z7Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MdO7GGCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MdO7GGCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8613E1F00A3A;
	Tue,  8 Sep 2026 20:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901191;
	bh=8qApsahOXbBIqOceZevDiK3r7godzpGwnSgF9lGt9lA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MdO7GGCn0+KpMxsISFASdD9dBeQiWmdJV6zH6t4gzZ5v/IkbEVIfcTsiIALXNtNLj
	 dFKVRsqLpM4VxR9/cgaCaaIM8If6JAXGEv7nzSsfCRev6+enJY4RHrDFyU7NHQ5Qvp
	 xOoik+kf2au/vKN9QZt/hbZQRAsBSK1fRwamdkGXQIrTgIHSfo5GeIVS91y7sTeNAs
	 RMryxLxJ9s2KHaRhVjS7PJ7AQyWgKEtnuhencnKFV7WGH+LmQdpFNF0YkmKpDJWnO7
	 38B+TFNamLP1eHAQtxCYJp3TkHMPKvdowdf0jA/KR6oeDesYCBg+6wnzjzvIKo4VyJ
	 t9x2EB5VjgNtA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:55:23 +0100
Subject: [PATCH 23/23] kbuild: use pigz for gzip compression if available
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-build-speedup-v1-23-5dc1ac01672d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4672; i=ljs@kernel.org;
 h=from:subject:message-id; bh=/cGfZoMmr7KpIZ+1dXwGv9v2Wc3LWJWwGs5e7Tz+VNE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWlFnOe8Tg5bZ6llWidBaDf//HKzIea68pJ4U1fnOvK
 UmZvHdqRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZykJuR4eic7LZFB/flfLzG
 vKvj/Y0bez9vyL3NYrPz78pFPrkRJjoM/x2cp17LlWRaKbL+v5h5m22pf93yr542HzPtHxn9vL9
 kHisA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

The gzip step of a kernel build is very lengthily, especially for larger
builds such as allmodconfig.

gzip itself cannot be run in parallel, however an alternative tool exists
that can, providing the same feature set as gzip itself - pigz - which
works as a drop-in replacement.

On a 128-core Threadripper, gzip -9 of a 36 MiB x86-64 vmlinux.bin takes
1.6s, and with pigz it takes 0.09s, so the performance increase is
significant.

It is already possible to specify the KGZIP environmental variable to make
use of pigz, however it seems sensible to make use of pigz if it is
available.

Therefore default to using pigz if it is available on the system upon which
the kernel is being built, otherwise fall back to gzip.

The output is byte-for-byte identical between pigz/gzip invocations, but
gzip and pigz do not produce the same stream as one another.

Therefore, for reproducible builds, the same set of tools should be used.

This seems to already be an implicit requirement in any case, but update
the reproducible build documentation to make this clear.

Also update the kbuild documentation to reflect the change.

Every x86 build ends with the compression of vmlinux.bin, 36MB for
defconfig and over 200MB for allmodconfig, no-op builds are unchanged.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 defconfig, touch mm/vma.c, gcc        7.4s     5.4s     -2.0s (-27%)
  x86 defconfig, touch mm/vma.c, clang      6.6s     4.9s     -1.7s (-26%)
  x86 defconfig, clean, gcc                26.2s    24.4s     -1.8s (-7%)
  x86 defconfig, clean, clang              25.8s    24.3s     -1.5s (-6%)
  x86 allmodconfig, touch mm/vma.c, gcc    23.7s    15.3s     -8.4s (-35%)
  x86 allmodconfig, touch mm/vma.c, clang  22.1s    15.2s     -6.9s (-31%)
  x86 allmodconfig, clean, gcc            291.4s   275.2s     -16.2s (-6%)
  x86 allmodconfig, clean, clang          278.3s   265.7s     -12.6s (-5%)

Link: https://zlib.net/pigz/
Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Documentation/kbuild/kbuild.rst              | 13 +++++++++++++
 Documentation/kbuild/reproducible-builds.rst | 16 ++++++++++++++++
 Makefile                                     |  2 +-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/Documentation/kbuild/kbuild.rst b/Documentation/kbuild/kbuild.rst
index 5a9013bacfb7..ebfc2319d6da 100644
--- a/Documentation/kbuild/kbuild.rst
+++ b/Documentation/kbuild/kbuild.rst
@@ -110,6 +110,19 @@ HOSTLDLIBS
 ----------
 Additional libraries to link against when building host programs.
 
+KGZIP
+-----
+The gzip compressor used for the compressed kernel image, compressed
+modules and packaging.
+
+If unset, it defaults to pigz (a parallel implementation of gzip) if available,
+otherwise gzip.
+
+KBZIP2, KLZOP, LZMA, LZ4, XZ, ZSTD
+----------------------------------
+The compressor programs for the other formats. Each defaults to the program
+of the same name.
+
 .. _userkbuildflags:
 
 USERCFLAGS
diff --git a/Documentation/kbuild/reproducible-builds.rst b/Documentation/kbuild/reproducible-builds.rst
index bc1eb82211df..b95586df2cb5 100644
--- a/Documentation/kbuild/reproducible-builds.rst
+++ b/Documentation/kbuild/reproducible-builds.rst
@@ -76,6 +76,22 @@ include generated files.  You should ensure the source tree is
 pristine by running ``make mrproper`` or ``git clean -d -f -x`` before
 building a source package.
 
+Compression tools
+-----------------
+
+The compressed kernel image, compressed modules and packages are produced
+using the binary specified by the environment variable ``KGZIP`` (described
+in Documentation/kbuild/kbuild.rst).
+
+This variable defaults to ``pigz`` if installed (a parallel implementation
+of gzip), or ``gzip`` otherwise.
+
+The generated output between two invocations of identical builds with
+either of the default tools will be byte-for-byte equivalent.
+
+However, for reproducible builds, ensure the same tool is used on all build
+hosts, as different tools may generate different output from one another.
+
 Module signing
 --------------
 
diff --git a/Makefile b/Makefile
index 3805f72428cb..5cb819034372 100644
--- a/Makefile
+++ b/Makefile
@@ -561,7 +561,7 @@ PERL		= perl
 PYTHON3		= python3
 CHECK		= sparse
 BASH		= bash
-KGZIP		= gzip
+KGZIP		:= $(if $(shell command -v pigz 2>/dev/null),pigz,gzip)
 KBZIP2		= bzip2
 KLZOP		= lzop
 LZMA		= lzma

-- 
2.55.0

