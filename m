Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1555D42AF86;
	Mon, 14 Sep 2026 09:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377894; cv=none; b=V/lvE65hFZ31M/gN2cdobDuvDjRidpKqH0WGbMaZuVSzkAjy9gcf3pshSZEBW7959NUEjiaCtDOdnqfkb11cCYOAEeh/vO7jvntTWLFAtSFwBVvHZB4sYLXDwVu6qlrdIj262vqbaFUBiEPl4jgBTM6Ivz6cbdurp9rRg6LjC/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377894; c=relaxed/simple;
	bh=9iG9qS6AGuVzz+DVqJCGQaA7fnTb/NXKN1FW+0AWki8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mGxb8bNW6zWfiOTv0zhJntEorifjTnjtaFLCEvw2hE4DbR9XFa+8C5Wo4Uqcz2mJlNjmYRX55Hh2tB0utRLwgsAeTMfV9waZrQpXM1eZSLlayaI6NbO4e3f2qLQkofl2eM5il2ODF9lxK+6CGLop3LTP5ju4GV9W7XtOlvlY+Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UB3C0Z5m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UB3C0Z5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F3D1F00899;
	Mon, 14 Sep 2026 09:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789377892;
	bh=jMlk8ESG3VZosnVPda+JnxrYfeoPZS29Gj5h4KPFBVk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UB3C0Z5mPs8gzBFSkClKgPRe6YkPx+LN/6Ej67xkNnWJZS/RA732odZUOqE+c9F/D
	 /auxIyF/OxkBAvo3QwtH+zFLWbEUPDwQU/kuKLyyfXD7b8mLIlfwNsmrFS04bSKBcM
	 s9mbsEPeCUpkXjN9KonE2vhaRkMqKXnKFbRH+I/45HZxXNp4GcxLLFkweDHkoxBe0L
	 N5tBxyIq5qSjT2h37GgI+8sA9fBDVN+6sSG0UOZhWuju7P5O751iq260OhYhPpQ9a0
	 99Dca7tQVF7OcRh/U/BR8Y/Dw2ID5OlFZom25Yuv8Q3KrunRrXuejfbHgBGPofkCi+
	 ju2qJcOyrcSrg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 10:22:17 +0100
Subject: [PATCH v2 18/21] kbuild: rust: optionally parallelise rustc front
 end
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-build-speedup-v2-18-39817ec5db23@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3400; i=ljs@kernel.org;
 h=from:subject:message-id; bh=9iG9qS6AGuVzz+DVqJCGQaA7fnTb/NXKN1FW+0AWki8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKW7zm0x8Xkb6Fl9DRLeRHmlQ/Wn/BgiQ2Pq6jMiRDa+
 jbn3L9vHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIsSSG/1kuxizKkQtqG1hz
 4ypWuag5mDxO2MHU+JWNTbNfuW5WDyPDRRb7U5PW7zELVIgNP252qKX6rCPL1Of2ovlsFYmHfsz
 jBQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Rust crates are compiled in a serial chain on the critical path - core,
bindings, kernel crates and then the drivers - each a rustc invocation.

With CONFIG_RUST set and every rust driver enabled, the entire chain takes
around 25 seconds on a 128-thread machine, with the associated C code
taking 24 seconds.

Each time a change is made to any of the bindings, it triggers a rebuild.

rustc has a parallel front end, enabled with -Zthreads, available since
rust 1.84 [0] and therefore on every rustc the kernel supports.

It is not yet stable and its output is not reproducible, so it cannot be
used by default - stabilisation is being worked on [1].

Add optional build parameter KBUILD_RUST_THREADS, which when set passes
that many threads to rustc.

The threads are taken from make's jobserver, so a parallel build is not
oversubscribed. It was found that benefits level off at 8 threads (16 was
found to be around the same, and 32 slower).

Generated output was confirmed byte-for-byte identical.

Observed build time changes with KBUILD_RUST_THREADS=8 (rustc 1.98, clang):

                                        before    after
  core.o                                   7.7s     4.9s
  bindings.o                               4.3s     3.1s
  kernel.o                                 2.0s     1.4s
  clean build                             39.3s    34.6s
  touch rust/kernel/lib.rs                12.9s    12.1s
  touch rust/bindings/bindings_helper.h   19.5s    17.5s

Whole build, 128-thread Threadripper 9980X, KBUILD_RUST_THREADS=8, best of
N runs:

                                         before   after     delta
                                         -------------------------------
  x86 defconfig+RUST, clean               41.0s    36.4s     -4.6s (-11%)
  x86 defconfig+RUST, touch lib.rs         8.3s     7.7s    -0.56s (-7%)

Link: https://github.com/rust-lang/rust/pull/132282 [0]
Link: https://github.com/rust-lang/compiler-team/issues/1005 [1]
Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Documentation/kbuild/kbuild.rst | 7 +++++++
 Makefile                        | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/kbuild/kbuild.rst b/Documentation/kbuild/kbuild.rst
index 5a9013bacfb7..9b2b127676c3 100644
--- a/Documentation/kbuild/kbuild.rst
+++ b/Documentation/kbuild/kbuild.rst
@@ -134,6 +134,13 @@ See make help for the full list.
 
 Setting "V=..." takes precedence over KBUILD_VERBOSE.
 
+KBUILD_RUST_THREADS
+-------------------
+The number of threads rustc's parallel front end may use, passed to it as
+``-Zthreads``. Unset by default, as the parallel front end is not yet
+stable and its output is not reproducible. The gain levels off at 8
+threads.
+
 KBUILD_EXTMOD
 -------------
 Set the directory to look for the kernel source when building external
diff --git a/Makefile b/Makefile
index 8263fc8a86b3..4ef504c1ace2 100644
--- a/Makefile
+++ b/Makefile
@@ -1206,6 +1206,10 @@ KBUILD_RUSTFLAGS += --remap-path-prefix=$(srcroot)/= --remap-path-scope=macro
 endif
 endif
 
+ifneq ($(KBUILD_RUST_THREADS),)
+KBUILD_RUSTFLAGS += -Zthreads=$(KBUILD_RUST_THREADS)
+endif
+
 # include additional Makefiles when needed
 include-y			:= scripts/Makefile.warn
 include-$(CONFIG_DEBUG_INFO)	+= scripts/Makefile.debug

-- 
2.55.0

