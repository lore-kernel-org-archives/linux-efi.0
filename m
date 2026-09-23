Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EE33B8950;
	Wed, 23 Sep 2026 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184046; cv=none; b=m051nB2rxDvMiqTeG+N1BWRhvb4cG7MKwDI+AL+eq9FKR9zjQHb8R10/Bx8LOpcXOyZbqEDy96fCOZrbkfm9WydIRTz9YxfBFBWAlltC32I5qHqitw+VKuGDTbO8N0XK97xJE7dVuB/dM+weNXdftRONqH+qZv7UySq3HH8S1Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184046; c=relaxed/simple;
	bh=2ycKJa3Z+VPxjsH2ZNqIj7aez7jMdJGovrqulxA0Kxk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X41/RpsrC9nD70x8QOBevtciojlvdzavcGieb/Nasx5E+ManABAh9qlVyzlEYmJMRSIzcM7aAhtiTR8fbNykQHyYDaZnifGkCB8AvE0JfEFNLeCRCRM7Jn+BRmyxeL3anPRSZOcMfedDVNqH0oMHCysfHAl0YOn55bHNl79WlkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qr9bHBGN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qr9bHBGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E441F000FF;
	Wed, 23 Sep 2026 17:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790184044;
	bh=nAtazO6mnI0TAu3XSRj1hcNvKpCr7+vo326YW4gA3HQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Qr9bHBGN0mF2HQTspSD3iLMXyTcdzORmlolCOHaxAer4eQhNxjF0zCmtK3Clxr7iP
	 6RwQ49+v55ui0QH+aAZ0ihxlyxcPPhTXmXuVElYcKELkGfuc9M1g6urv3+w03OH8fG
	 frgkaKADBOCeq512byiCkewp2+fi3lLBup4wVOUsEqGXMkcpaaLZCTuxI/fGnbFgL8
	 8KZJwLdF1dw2EakkP8ScBh+o4Rte/vxWr1GBR7XhoRJG9xLVFquIcFEk29wtD8mSJ3
	 +LO51la90FiWZm4NL6xGSquO+U45Omw5tZ+rq4WepLpysS5Xr9sC77yE5TMvOs0lOE
	 zqqBzQxw4iupA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 23 Sep 2026 18:18:00 +0100
Subject: [PATCH v4 11/22] kbuild: move the toolchain checks into
 scripts/Kconfig.toolchain
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-build-speedup-v4-11-73128809a4a4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14806; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2ycKJa3Z+VPxjsH2ZNqIj7aez7jMdJGovrqulxA0Kxk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2cF7m6dYWXchlHRSooTdh/6oljn5Vh33T7aLvMZzMj
 Gcrz5raUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgInsaGdk6Ks6ynb6616R/UHc
 boVT89O5n2qFPzg8gT3xLvOO7mnh+Qz/8xMET0c0bWW4pBTJqVS8JW/2xu/KWxUNlKpu57rO+Nv
 IBAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

init/Kconfig opens with two hundred lines identifying the compiler,
assembler, linker and rustc and probing which options they support, none of
it to do with init.

Move them into their own file, sourced from the top of init/Kconfig, so
that the next commit can add to them without growing init/Kconfig further.

Also update MAINTAINERS to put the new file in the KCONFIG entry.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 MAINTAINERS               |   1 +
 init/Kconfig              | 197 +--------------------------------------------
 scripts/Kconfig.toolchain | 198 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 200 insertions(+), 196 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6215fcb07770..46c4f7e3061c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14057,6 +14057,7 @@ Q:	https://patchwork.kernel.org/project/linux-kbuild/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux.git
 F:	Documentation/kbuild/kconfig*
 F:	scripts/Kconfig.include
+F:	scripts/Kconfig.toolchain
 F:	scripts/kconfig/
 
 KCORE
diff --git a/init/Kconfig b/init/Kconfig
index 8583d9f06c52..352601b44b5c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1,201 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config CC_VERSION_TEXT
-	string
-	default "$(CC_VERSION_TEXT)"
-	help
-	  This is used in unclear ways:
-
-	  - Re-run Kconfig when the compiler is updated
-	    The 'default' property references the environment variable,
-	    CC_VERSION_TEXT so it is recorded in include/config/auto.conf.cmd.
-	    When the compiler is updated, Kconfig will be invoked.
-
-	  - Ensure full rebuild when the compiler is updated
-	    include/linux/compiler-version.h contains this option in the comment
-	    line so fixdep adds include/config/CC_VERSION_TEXT into the
-	    auto-generated dependency. When the compiler is updated, syncconfig
-	    will touch it and then every file will be rebuilt.
-
-config CC_IS_GCC
-	def_bool $(success,test "$(cc-name)" = GCC)
-
-config GCC_VERSION
-	int
-	default $(cc-version) if CC_IS_GCC
-	default 0
-
-config CC_IS_CLANG
-	def_bool $(success,test "$(cc-name)" = Clang)
-
-config CLANG_VERSION
-	int
-	default $(cc-version) if CC_IS_CLANG
-	default 0
-
-config AS_IS_GNU
-	def_bool $(success,test "$(as-name)" = GNU)
-
-config AS_IS_LLVM
-	def_bool $(success,test "$(as-name)" = LLVM)
-
-config AS_VERSION
-	int
-	# Use clang version if this is the integrated assembler
-	default CLANG_VERSION if AS_IS_LLVM
-	default $(as-version)
-
-config LD_IS_BFD
-	def_bool $(success,test "$(ld-name)" = BFD)
-
-config LD_VERSION
-	int
-	default $(ld-version) if LD_IS_BFD
-	default 0
-
-config LD_IS_LLD
-	def_bool $(success,test "$(ld-name)" = LLD)
-
-config LLD_VERSION
-	int
-	default $(ld-version) if LD_IS_LLD
-	default 0
-
-config RUSTC_VERSION
-	int
-	default $(rustc-version)
-	help
-	  It does not depend on `RUST` since that one may need to use the version
-	  in a `depends on`.
-
-config RUST_IS_AVAILABLE
-	def_bool $(success,$(srctree)/scripts/rust_is_available.sh)
-	help
-	  This shows whether a suitable Rust toolchain is available (found).
-
-	  Please see Documentation/rust/quick-start.rst for instructions on how
-	  to satisfy the build requirements of Rust support.
-
-	  In particular, the Makefile target 'rustavailable' is useful to check
-	  why the Rust toolchain is not being detected.
-
-config RUSTC_LLVM_VERSION
-	int
-	default $(rustc-llvm-version)
-
-config RUSTC_LLVM_MAJOR_VERSION
-	int
-	default $(shell,expr $(rustc-llvm-version) / 10000)
 
-config RUSTC_CLANG_LLVM_COMPATIBLE
-	bool
-	default y if CC_IS_CLANG && RUSTC_LLVM_MAJOR_VERSION = $(shell,expr $(cc-version) / 10000)
-	help
-	  This indicates whether Rust and Clang use LLVM of the same major
-	  version.
-
-	  Operations involving handling LLVM IR or bitcode (e.g. cross-language
-	  LTO) require the same LLVM major version to work properly. For best
-	  compatibility it is recommended that the exact same LLVM is used.
-
-config ARCH_HAS_CC_CAN_LINK
-	bool
-
-config CC_CAN_LINK
-	bool
-	default ARCH_CC_CAN_LINK if ARCH_HAS_CC_CAN_LINK
-	default $(cc_can_link_user,$(m64-flag)) if 64BIT
-	default $(cc_can_link_user,$(m32-flag))
-
-# Fixed in GCC 14, 13.3, 12.4 and 11.5
-# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113921
-config GCC_ASM_GOTO_OUTPUT_BROKEN
-	bool
-	depends on CC_IS_GCC
-	default y if GCC_VERSION < 110500
-	default y if GCC_VERSION >= 120000 && GCC_VERSION < 120400
-	default y if GCC_VERSION >= 130000 && GCC_VERSION < 130300
-
-config CC_HAS_ASM_GOTO_OUTPUT
-	def_bool y
-	depends on !GCC_ASM_GOTO_OUTPUT_BROKEN
-	depends on $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
-
-config CC_HAS_ASM_GOTO_TIED_OUTPUT
-	depends on CC_HAS_ASM_GOTO_OUTPUT
-	# Detect buggy gcc and clang, fixed in gcc-11 clang-14.
-	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
-
-config TOOLS_SUPPORT_RELR
-	def_bool $(success,env "CC=$(CC)" "LD=$(LD)" "NM=$(NM)" "OBJCOPY=$(OBJCOPY)" $(srctree)/scripts/tools-support-relr.sh)
-
-config CC_HAS_ASM_INLINE
-	def_bool $(success,echo 'void foo(void) { asm inline (""); }' | $(CC) -x c - -c -o /dev/null)
-
-config CC_HAS_ASSUME
-	bool
-	# clang needs to be at least 19.1.0 since the meaning of the assume
-	# attribute changed:
-	# https://github.com/llvm/llvm-project/commit/c44fa3e8a9a44c2e9a575768a3c185354b9f6c17
-	default y if CC_IS_CLANG && CLANG_VERSION >= 190100
-	# supported since gcc 13.1.0
-	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106654
-	default y if CC_IS_GCC && GCC_VERSION >= 130100
-
-config CC_HAS_NO_PROFILE_FN_ATTR
-	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
-
-config CC_HAS_COUNTED_BY
-	bool
-	# clang needs to be at least 20.1.0 to avoid potential crashes
-	# when building structures that contain __counted_by
-	# https://github.com/ClangBuiltLinux/linux/issues/2114
-	# https://github.com/llvm/llvm-project/commit/160fb1121cdf703c3ef5e61fb26c5659eb581489
-	default y if CC_IS_CLANG && CLANG_VERSION >= 200100
-	# supported since gcc 15.1.0
-	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
-	default y if CC_IS_GCC && GCC_VERSION >= 150100
-
-config CC_HAS_COUNTED_BY_PTR
-	bool
-	# supported since clang 22
-	default y if CC_IS_CLANG && CLANG_VERSION >= 220100
-	# supported since gcc 16.0.0
-	default y if CC_IS_GCC && GCC_VERSION >= 160000
-
-config CC_HAS_BROKEN_COUNTED_BY_REF
-	bool
-	# https://github.com/llvm/llvm-project/issues/182575
-	default y if CC_IS_CLANG && CLANG_VERSION < 220100
-
-config CC_HAS_ALLOC_TOKEN
-	def_bool $(cc-option,-falloc-token-max=123)
-
-config CC_HAS_MULTIDIMENSIONAL_NONSTRING
-	def_bool $(success,echo 'char tag[][4] __attribute__((__nonstring__)) = { };' | $(CC) $(CLANG_FLAGS) -x c - -c -o /dev/null -Werror)
-
-config LD_CAN_USE_KEEP_IN_OVERLAY
-	# ld.lld prior to 21.0.0 did not support KEEP within an overlay description
-	# https://github.com/llvm/llvm-project/pull/130661
-	def_bool LD_IS_BFD || LLD_VERSION >= 210000
-
-config RUSTC_HAS_SPAN_FILE
-	def_bool RUSTC_VERSION >= 108800
-
-config RUSTC_HAS_UNNECESSARY_TRANSMUTES
-	def_bool RUSTC_VERSION >= 108800
-
-config RUSTC_HAS_FILE_WITH_NUL
-	def_bool RUSTC_VERSION >= 108900
-
-config RUSTC_HAS_FILE_AS_C_STR
-	def_bool RUSTC_VERSION >= 109100
-
-config RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS
-	def_bool RUSTC_VERSION >= 109800
-
-config PAHOLE_VERSION
-	int
-	default "$(PAHOLE_VERSION)"
+source "scripts/Kconfig.toolchain"
 
 config CONSTRUCTORS
 	bool
diff --git a/scripts/Kconfig.toolchain b/scripts/Kconfig.toolchain
new file mode 100644
index 000000000000..fac36246451f
--- /dev/null
+++ b/scripts/Kconfig.toolchain
@@ -0,0 +1,198 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config CC_VERSION_TEXT
+	string
+	default "$(CC_VERSION_TEXT)"
+	help
+	  This is used in unclear ways:
+
+	  - Re-run Kconfig when the compiler is updated
+	    The 'default' property references the environment variable,
+	    CC_VERSION_TEXT so it is recorded in include/config/auto.conf.cmd.
+	    When the compiler is updated, Kconfig will be invoked.
+
+	  - Ensure full rebuild when the compiler is updated
+	    include/linux/compiler-version.h contains this option in the comment
+	    line so fixdep adds include/config/CC_VERSION_TEXT into the
+	    auto-generated dependency. When the compiler is updated, syncconfig
+	    will touch it and then every file will be rebuilt.
+
+config CC_IS_GCC
+	def_bool $(success,test "$(cc-name)" = GCC)
+
+config GCC_VERSION
+	int
+	default $(cc-version) if CC_IS_GCC
+	default 0
+
+config CC_IS_CLANG
+	def_bool $(success,test "$(cc-name)" = Clang)
+
+config CLANG_VERSION
+	int
+	default $(cc-version) if CC_IS_CLANG
+	default 0
+
+config AS_IS_GNU
+	def_bool $(success,test "$(as-name)" = GNU)
+
+config AS_IS_LLVM
+	def_bool $(success,test "$(as-name)" = LLVM)
+
+config AS_VERSION
+	int
+	# Use clang version if this is the integrated assembler
+	default CLANG_VERSION if AS_IS_LLVM
+	default $(as-version)
+
+config LD_IS_BFD
+	def_bool $(success,test "$(ld-name)" = BFD)
+
+config LD_VERSION
+	int
+	default $(ld-version) if LD_IS_BFD
+	default 0
+
+config LD_IS_LLD
+	def_bool $(success,test "$(ld-name)" = LLD)
+
+config LLD_VERSION
+	int
+	default $(ld-version) if LD_IS_LLD
+	default 0
+
+config RUSTC_VERSION
+	int
+	default $(rustc-version)
+	help
+	  It does not depend on `RUST` since that one may need to use the version
+	  in a `depends on`.
+
+config RUST_IS_AVAILABLE
+	def_bool $(success,$(srctree)/scripts/rust_is_available.sh)
+	help
+	  This shows whether a suitable Rust toolchain is available (found).
+
+	  Please see Documentation/rust/quick-start.rst for instructions on how
+	  to satisfy the build requirements of Rust support.
+
+	  In particular, the Makefile target 'rustavailable' is useful to check
+	  why the Rust toolchain is not being detected.
+
+config RUSTC_LLVM_VERSION
+	int
+	default $(rustc-llvm-version)
+
+config RUSTC_LLVM_MAJOR_VERSION
+	int
+	default $(shell,expr $(rustc-llvm-version) / 10000)
+
+config RUSTC_CLANG_LLVM_COMPATIBLE
+	bool
+	default y if CC_IS_CLANG && RUSTC_LLVM_MAJOR_VERSION = $(shell,expr $(cc-version) / 10000)
+	help
+	  This indicates whether Rust and Clang use LLVM of the same major
+	  version.
+
+	  Operations involving handling LLVM IR or bitcode (e.g. cross-language
+	  LTO) require the same LLVM major version to work properly. For best
+	  compatibility it is recommended that the exact same LLVM is used.
+
+config ARCH_HAS_CC_CAN_LINK
+	bool
+
+config CC_CAN_LINK
+	bool
+	default ARCH_CC_CAN_LINK if ARCH_HAS_CC_CAN_LINK
+	default $(cc_can_link_user,$(m64-flag)) if 64BIT
+	default $(cc_can_link_user,$(m32-flag))
+
+# Fixed in GCC 14, 13.3, 12.4 and 11.5
+# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113921
+config GCC_ASM_GOTO_OUTPUT_BROKEN
+	bool
+	depends on CC_IS_GCC
+	default y if GCC_VERSION < 110500
+	default y if GCC_VERSION >= 120000 && GCC_VERSION < 120400
+	default y if GCC_VERSION >= 130000 && GCC_VERSION < 130300
+
+config CC_HAS_ASM_GOTO_OUTPUT
+	def_bool y
+	depends on !GCC_ASM_GOTO_OUTPUT_BROKEN
+	depends on $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
+
+config CC_HAS_ASM_GOTO_TIED_OUTPUT
+	depends on CC_HAS_ASM_GOTO_OUTPUT
+	# Detect buggy gcc and clang, fixed in gcc-11 clang-14.
+	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
+
+config TOOLS_SUPPORT_RELR
+	def_bool $(success,env "CC=$(CC)" "LD=$(LD)" "NM=$(NM)" "OBJCOPY=$(OBJCOPY)" $(srctree)/scripts/tools-support-relr.sh)
+
+config CC_HAS_ASM_INLINE
+	def_bool $(success,echo 'void foo(void) { asm inline (""); }' | $(CC) -x c - -c -o /dev/null)
+
+config CC_HAS_ASSUME
+	bool
+	# clang needs to be at least 19.1.0 since the meaning of the assume
+	# attribute changed:
+	# https://github.com/llvm/llvm-project/commit/c44fa3e8a9a44c2e9a575768a3c185354b9f6c17
+	default y if CC_IS_CLANG && CLANG_VERSION >= 190100
+	# supported since gcc 13.1.0
+	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106654
+	default y if CC_IS_GCC && GCC_VERSION >= 130100
+
+config CC_HAS_NO_PROFILE_FN_ATTR
+	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
+
+config CC_HAS_COUNTED_BY
+	bool
+	# clang needs to be at least 20.1.0 to avoid potential crashes
+	# when building structures that contain __counted_by
+	# https://github.com/ClangBuiltLinux/linux/issues/2114
+	# https://github.com/llvm/llvm-project/commit/160fb1121cdf703c3ef5e61fb26c5659eb581489
+	default y if CC_IS_CLANG && CLANG_VERSION >= 200100
+	# supported since gcc 15.1.0
+	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
+	default y if CC_IS_GCC && GCC_VERSION >= 150100
+
+config CC_HAS_COUNTED_BY_PTR
+	bool
+	# supported since clang 22
+	default y if CC_IS_CLANG && CLANG_VERSION >= 220100
+	# supported since gcc 16.0.0
+	default y if CC_IS_GCC && GCC_VERSION >= 160000
+
+config CC_HAS_BROKEN_COUNTED_BY_REF
+	bool
+	# https://github.com/llvm/llvm-project/issues/182575
+	default y if CC_IS_CLANG && CLANG_VERSION < 220100
+
+config CC_HAS_ALLOC_TOKEN
+	def_bool $(cc-option,-falloc-token-max=123)
+
+config CC_HAS_MULTIDIMENSIONAL_NONSTRING
+	def_bool $(success,echo 'char tag[][4] __attribute__((__nonstring__)) = { };' | $(CC) $(CLANG_FLAGS) -x c - -c -o /dev/null -Werror)
+
+config LD_CAN_USE_KEEP_IN_OVERLAY
+	# ld.lld prior to 21.0.0 did not support KEEP within an overlay description
+	# https://github.com/llvm/llvm-project/pull/130661
+	def_bool LD_IS_BFD || LLD_VERSION >= 210000
+
+config RUSTC_HAS_SPAN_FILE
+	def_bool RUSTC_VERSION >= 108800
+
+config RUSTC_HAS_UNNECESSARY_TRANSMUTES
+	def_bool RUSTC_VERSION >= 108800
+
+config RUSTC_HAS_FILE_WITH_NUL
+	def_bool RUSTC_VERSION >= 108900
+
+config RUSTC_HAS_FILE_AS_C_STR
+	def_bool RUSTC_VERSION >= 109100
+
+config RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS
+	def_bool RUSTC_VERSION >= 109800
+
+config PAHOLE_VERSION
+	int
+	default "$(PAHOLE_VERSION)"

-- 
2.55.0

