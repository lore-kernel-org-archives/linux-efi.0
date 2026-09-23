Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FA83E6DFF;
	Wed, 23 Sep 2026 17:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184059; cv=none; b=EvqQwt3wWyBLuW+clYJRdp0m998FBJdqK/29ACyzjU1AT3+KxzX/f1IvZsdK5YqDPq1DusvRvv6u+QoQrNCI9Ymex/MIVE/5XuVBWwLqpY8whCO5qdJU5q/0rTw90OmpOzUiGYI3/yyv4pgWDfbDNYrcEiUxGSLvGt/z62qb2Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184059; c=relaxed/simple;
	bh=PDJB8j9sKc9Q/yg7cUV7TTvciusJhucipt52hAU2ZhY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AeFFN2URadWO+hqWqvnlwp3Ze6tmafAMR5sEy1pMAN/80XVnGLiQqNB/da06Oc9NGVXJXo5/oiL7pCzcDokVFJ46v9Y3yxMh3b+B3+JhdAyCALza7y66BOZEFB3Z0T4RuqefigiFTiSdMLFsNmsRpt5yfXvVZm3ioECDLEI8ANk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4ivzPGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4ivzPGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B380F1F00893;
	Wed, 23 Sep 2026 17:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790184056;
	bh=B1ULND6qUkIjbcoTYBYFJ2YhtgqM4e1Z1reiowbMJ8k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n4ivzPGHFOaVKa0QM4qp2cl2pNZbc5XzOdstT6g/HfEo5a5jBkxSx30mSH+AdQFxy
	 qh/4kP+atkWGJ12sRHfF5BC4Hr40Yq971TO+GkE3/7UuXYYYUHrw9CmjdZz34wiivg
	 E1qlleJKnrfo8QwtUxJHyuKWZbPtfF51cCvHLxgEsoHy8Vp8T65suXiIZck7r6LD1h
	 nC0g+CpMaK5vaKpiwnO0J5JTrm8C8zfj3v+u4Bz8Ol2C2vBLHCef/fj/MYg9WKN2H6
	 HT/aItgJrz80pPqDJlwkiKjHdRx0pQd/NDS2rvmAZxi0dCVok5YDDuO/0HKCr38Akj
	 vRAPLlEhkZvuw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 23 Sep 2026 18:18:01 +0100
Subject: [PATCH v4 12/22] kbuild: avoid re-running compiler and linker
 probes
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-build-speedup-v4-12-73128809a4a4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=18854; i=ljs@kernel.org;
 h=from:subject:message-id; bh=PDJB8j9sKc9Q/yg7cUV7TTvciusJhucipt52hAU2ZhY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2cF5+cW7Oi8ofPw/7TXxRM1M57JnkyW/PVSU9Xv9yz
 zQQ2Cv4s6OUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATmfGd4X+a+5E7fKf/5cZe
 db9Y3GV04dtJfpmHWRymkRWX3Dy3bLvEyPBtR15Bo/riG8w3D/1PLmVO/bwz6f865sSpRtueTnt
 jUcoGAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Each kernel make invocation begins with ~30 compiler and linker runs each
of which performs duplicate probe for a number of compiler and linker
options.

This is useless work - the compiler and its version is known, so use these
to determine which options are available, once.

Using the newly introduced cc-option-str, track the result of each probe in
CC_OPT_*, LD_OPT_* variables and have Makefile's simply append the symbol.

Some care has to be taken around negative options, i.e. -Wno-xxx, as gcc
accepts an unknown -Wno- without complaint and only complains later, so
instead probe the positive form for these cases.

Use CC_HAS_* For those probes that gate a Makefile conditional rather than
a simple option, as per the established pattern for this.

This change avoids a subtle issue with ppc32 (big endian) - clang doesn't
accept -fno-stack-clash-protection on this sub-target, so keep this option
in the Makefile.

With gcc and clang, defconfig and allmodconfig, the recorded command
lines are unchanged, a build with nothing to do rebuilds nothing and W=1
continues to function correctly.

Doing this improves all builds, but has a particularly positive impact on
no-op builds (builds where nothing has changed).

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 defconfig, no-op make, gcc           0.78s    0.60s    -0.18s (-23%)
  x86 defconfig, no-op make, clang         0.94s    0.66s    -0.28s (-30%)
  x86 defconfig, touch mm/vma.c, gcc        8.6s     8.5s    -0.16s (-2%)
  x86 defconfig, touch mm/vma.c, clang      8.0s     7.7s    -0.24s (-3%)
  x86 defconfig, clean, clang              29.8s    29.4s    -0.37s (-1%)
  x86 allmodconfig, no-op make, gcc        12.9s    12.7s    -0.23s (-2%)
  x86 allmodconfig, no-op make, clang      14.2s    13.9s    -0.29s (-2%)
  x86 allmodconfig, touch mm/vma.c, clang  32.2s    31.9s    -0.30s (-1%)

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Makefile                              | 23 +++++------
 arch/arm64/kernel/pi/Makefile         |  2 +-
 arch/riscv/kernel/pi/Makefile         |  2 +-
 arch/x86/Kconfig                      | 17 ++++++++
 arch/x86/Makefile                     | 12 +++---
 drivers/firmware/efi/libstub/Makefile |  2 +-
 scripts/Kconfig.toolchain             | 74 +++++++++++++++++++++++++++++++++++
 scripts/Makefile.warn                 | 28 ++++++-------
 8 files changed, 126 insertions(+), 34 deletions(-)

diff --git a/Makefile b/Makefile
index 554c9003a4d9..cbfee8d325a5 100644
--- a/Makefile
+++ b/Makefile
@@ -946,8 +946,8 @@ KBUILD_RUSTFLAGS += -Coverflow-checks=$(if $(CONFIG_RUST_OVERFLOW_CHECKS),y,n)
 ifdef CONFIG_CC_IS_GCC
 # gcc-10 renamed --param=allow-store-data-races=0 to
 # -fno-allow-store-data-races.
-KBUILD_CFLAGS	+= $(call cc-option,--param=allow-store-data-races=0)
-KBUILD_CFLAGS	+= $(call cc-option,-fno-allow-store-data-races)
+KBUILD_CFLAGS	+= $(CONFIG_CC_OPT_ALLOW_STORE_DATA_RACES_PARAM)
+KBUILD_CFLAGS	+= $(CONFIG_CC_OPT_NO_ALLOW_STORE_DATA_RACES)
 endif
 
 ifdef CONFIG_READABLE_ASM
@@ -1011,18 +1011,20 @@ endif
 endif
 
 # Explicitly clear padding bits during variable initialization
-KBUILD_CFLAGS += $(call cc-option,-fzero-init-padding-bits=all)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_ZERO_INIT_PADDING_BITS)
 
 # While VLAs have been removed, GCC produces unreachable stack probes
 # for the randomize_kstack_offset feature. Disable it for all compilers.
+# Probed here rather than in Kconfig as clang only accepts it for some
+# sub-targets, so the architecture's flags matter.
 KBUILD_CFLAGS	+= $(call cc-option, -fno-stack-clash-protection)
 
 # Get details on warnings generated due to GCC value tracking.
-KBUILD_CFLAGS	+= $(call cc-option, -fdiagnostics-show-context=2)
+KBUILD_CFLAGS	+= $(CONFIG_CC_OPT_DIAGNOSTICS_SHOW_CONTEXT)
 
 # Show inlining notes for __attribute__((warning/error)) call chains.
 # GCC supports this unconditionally while Clang 23+ provides a flag.
-KBUILD_CFLAGS	+= $(call cc-option, -fdiagnostics-show-inlining-chain)
+KBUILD_CFLAGS	+= $(CONFIG_CC_OPT_DIAGNOSTICS_SHOW_INLINING_CHAIN)
 
 # Clear used registers at func exit (to reduce data lifetime and ROP gadgets).
 ifdef CONFIG_ZERO_CALL_USED_REGS
@@ -1033,7 +1035,7 @@ ifdef CONFIG_FUNCTION_TRACER
 ifdef CONFIG_FTRACE_MCOUNT_USE_CC
   CC_FLAGS_FTRACE	+= -mrecord-mcount
   ifdef CONFIG_HAVE_NOP_MCOUNT
-    ifeq ($(call cc-option-yn, -mnop-mcount),y)
+    ifdef CONFIG_CC_HAS_MNOP_MCOUNT
       CC_FLAGS_FTRACE	+= -mnop-mcount
       CC_FLAGS_USING	+= -DCC_USING_NOP_MCOUNT
     endif
@@ -1051,8 +1053,7 @@ ifdef CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
   endif
 endif
 ifdef CONFIG_HAVE_FENTRY
-  # s390-linux-gnu-gcc did not support -mfentry until gcc-9.
-  ifeq ($(call cc-option-yn, -mfentry),y)
+  ifdef CONFIG_CC_HAS_MFENTRY
     CC_FLAGS_FTRACE	+= -mfentry
     CC_FLAGS_USING	+= -DCC_USING_FENTRY
   endif
@@ -1160,7 +1161,7 @@ NOSTDINC_FLAGS += -nostdinc
 # the kernel uses only C99 flexible arrays for dynamically sized trailing
 # arrays. Enforce this for everything that may examine structure sizes and
 # perform bounds checking.
-KBUILD_CFLAGS += $(call cc-option, -fstrict-flex-arrays=3)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_STRICT_FLEX_ARRAYS)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= -fno-strict-overflow
@@ -1243,11 +1244,11 @@ LDFLAGS_vmlinux += --build-id=sha1
 # COMDAT-deduplicated sections. Use --force-group-allocation to resolve these
 # groups when linking modules. The option is available from ld.bfd 2.29 and
 # ld.lld 19.1.0.
-KBUILD_LDFLAGS_MODULE += $(call ld-option,--force-group-allocation)
+KBUILD_LDFLAGS_MODULE += $(CONFIG_LD_OPT_FORCE_GROUP_ALLOCATION)
 
 KBUILD_LDFLAGS	+= -z noexecstack
 ifeq ($(CONFIG_LD_IS_BFD),y)
-KBUILD_LDFLAGS	+= $(call ld-option,--no-warn-rwx-segments)
+KBUILD_LDFLAGS	+= $(CONFIG_LD_OPT_NO_WARN_RWX_SEGMENTS)
 endif
 
 ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
diff --git a/arch/arm64/kernel/pi/Makefile b/arch/arm64/kernel/pi/Makefile
index be92d73c25b2..4a0cbedfdcd6 100644
--- a/arch/arm64/kernel/pi/Makefile
+++ b/arch/arm64/kernel/pi/Makefile
@@ -9,7 +9,7 @@ KBUILD_CFLAGS	:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) -fpie \
 		   -include $(srctree)/include/linux/hidden.h \
 		   -D__DISABLE_EXPORTS -ffreestanding -D__NO_FORTIFY \
 		   -fno-asynchronous-unwind-tables -fno-unwind-tables \
-		   $(call cc-option,-fno-addrsig)
+		   $(CONFIG_CC_OPT_NO_ADDRSIG)
 
 # this code may run with the MMU off so disable unaligned accesses
 CFLAGS_map_range.o += -mstrict-align
diff --git a/arch/riscv/kernel/pi/Makefile b/arch/riscv/kernel/pi/Makefile
index bc098edac898..4c8e52b3f176 100644
--- a/arch/riscv/kernel/pi/Makefile
+++ b/arch/riscv/kernel/pi/Makefile
@@ -8,7 +8,7 @@ KBUILD_CFLAGS	:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) -fpie \
 		   -include $(srctree)/include/linux/hidden.h \
 		   -D__DISABLE_EXPORTS -ffreestanding \
 		   -fno-asynchronous-unwind-tables -fno-unwind-tables \
-		   $(call cc-option,-fno-addrsig)
+		   $(CONFIG_CC_OPT_NO_ADDRSIG)
 
 # Disable LTO
 KBUILD_CFLAGS	:= $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15fd9ec5ecac..0fea2fc4ba1d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2364,6 +2364,23 @@ config CC_HAS_KCFI_ARITY
 	def_bool $(cc-option,-fsanitize=kcfi -fsanitize-kcfi-arity)
 	depends on CC_IS_CLANG && !RUST
 
+config CC_OPT_INDIRECT_BRANCH_CS_PREFIX
+	def_string "$(cc-option-str,-mindirect-branch-cs-prefix)"
+
+config CC_OPT_CF_PROTECTION_NONE
+	def_string "$(cc-option-str,-fcf-protection=none)"
+
+# with jump tables off: the compilers use NOTRACK for them, which kernel IBT
+# does not allow
+config CC_OPT_CF_PROTECTION_BRANCH
+	def_string "$(cc-option-str,-fcf-protection=branch -fno-jump-tables)"
+
+config CC_OPT_FALIGN_JUMPS
+	def_string "$(cc-option-str,-falign-jumps=1)"
+
+config CC_OPT_FALIGN_LOOPS
+	def_string "$(cc-option-str,-falign-loops=1)"
+
 config FUNCTION_PADDING_CFI
 	int
 	default 59 if FUNCTION_ALIGNMENT_64B
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 598f178102ee..aac30ba51b2f 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -20,7 +20,7 @@ ifdef CONFIG_CC_IS_CLANG
 RETPOLINE_CFLAGS	:= -mretpoline-external-thunk
 RETPOLINE_VDSO_CFLAGS	:= -mretpoline
 endif
-RETPOLINE_CFLAGS	+= $(call cc-option,-mindirect-branch-cs-prefix)
+RETPOLINE_CFLAGS	+= $(CONFIG_CC_OPT_INDIRECT_BRANCH_CS_PREFIX)
 
 ifdef CONFIG_MITIGATION_RETHUNK
 RETHUNK_CFLAGS		:= -mfunction-return=thunk-extern
@@ -52,7 +52,7 @@ REALMODE_CFLAGS	:= $(CC_FLAGS_DIALECT) -m16 -g -Os \
 		   -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
-		   -mno-mmx -mno-sse $(call cc-option,-fcf-protection=none)
+		   -mno-mmx -mno-sse $(CONFIG_CC_OPT_CF_PROTECTION_NONE)
 
 REALMODE_CFLAGS += -ffreestanding
 REALMODE_CFLAGS += -fno-stack-protector
@@ -99,10 +99,10 @@ ifeq ($(CONFIG_X86_KERNEL_IBT),y)
 #
 #   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=104816
 #
-KBUILD_CFLAGS += $(call cc-option,-fcf-protection=branch -fno-jump-tables)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_CF_PROTECTION_BRANCH)
 KBUILD_RUSTFLAGS += -Zcf-protection=branch $(if $(call rustc-min-version,109300),-Cjump-tables=n,-Zno-jump-tables)
 else
-KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_CF_PROTECTION_NONE)
 endif
 
 ifeq ($(CONFIG_X86_32),y)
@@ -138,10 +138,10 @@ else
         KBUILD_CFLAGS += -m64
 
         # Align jump targets to 1 byte, not the default 16 bytes:
-        KBUILD_CFLAGS += $(call cc-option,-falign-jumps=1)
+        KBUILD_CFLAGS += $(CONFIG_CC_OPT_FALIGN_JUMPS)
 
         # Pack loops tightly as well:
-        KBUILD_CFLAGS += $(call cc-option,-falign-loops=1)
+        KBUILD_CFLAGS += $(CONFIG_CC_OPT_FALIGN_LOOPS)
 
         # Don't autogenerate traditional x87 instructions
         KBUILD_CFLAGS += -mno-80387
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 77a2b2d74f3f..415f63105b48 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -40,7 +40,7 @@ KBUILD_CFLAGS			:= $(subst $(CC_FLAGS_FTRACE),,$(cflags-y)) \
 				   -D__NO_FORTIFY \
 				   -ffreestanding \
 				   -fno-stack-protector \
-				   $(call cc-option,-fno-addrsig) \
+				   $(CONFIG_CC_OPT_NO_ADDRSIG) \
 				   -D__DISABLE_EXPORTS
 
 #
diff --git a/scripts/Kconfig.toolchain b/scripts/Kconfig.toolchain
index fac36246451f..d708a175fe48 100644
--- a/scripts/Kconfig.toolchain
+++ b/scripts/Kconfig.toolchain
@@ -144,6 +144,80 @@ config CC_HAS_ASSUME
 config CC_HAS_NO_PROFILE_FN_ATTR
 	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
 
+config CC_OPT_ZERO_INIT_PADDING_BITS
+	def_string "$(cc-option-str,-fzero-init-padding-bits=all)"
+
+config CC_OPT_NO_ADDRSIG
+	def_string "$(cc-option-str,-fno-addrsig)"
+
+config CC_OPT_DIAGNOSTICS_SHOW_CONTEXT
+	def_string "$(cc-option-str,-fdiagnostics-show-context=2)"
+
+config CC_OPT_DIAGNOSTICS_SHOW_INLINING_CHAIN
+	def_string "$(cc-option-str,-fdiagnostics-show-inlining-chain)"
+
+config CC_OPT_STRICT_FLEX_ARRAYS
+	def_string "$(cc-option-str,-fstrict-flex-arrays=3)"
+
+# gcc-10 renamed --param=allow-store-data-races=0 to -fno-allow-store-data-races
+config CC_OPT_ALLOW_STORE_DATA_RACES_PARAM
+	def_string "$(cc-option-str,--param=allow-store-data-races=0)" if CC_IS_GCC
+
+config CC_OPT_NO_ALLOW_STORE_DATA_RACES
+	def_string "$(cc-option-str,-fno-allow-store-data-races)" if CC_IS_GCC
+
+config CC_HAS_MNOP_MCOUNT
+	def_bool $(cc-option,-mnop-mcount)
+
+# s390-linux-gnu-gcc did not support -mfentry until gcc-9.
+config CC_HAS_MFENTRY
+	def_bool $(cc-option,-mfentry)
+
+config LD_OPT_FORCE_GROUP_ALLOCATION
+	def_string "$(ld-option-str,--force-group-allocation)"
+
+config LD_OPT_NO_WARN_RWX_SEGMENTS
+	def_string "$(ld-option-str,--no-warn-rwx-segments)"
+
+config CC_OPT_WNO_ADDRESS_OF_PACKED_MEMBER
+	def_string "-Wno-address-of-packed-member" if $(cc-option,-Waddress-of-packed-member)
+
+config CC_OPT_WNO_FORMAT_OVERFLOW_NON_KPRINTF
+	def_string "-Wno-format-overflow-non-kprintf" if CC_IS_CLANG && $(cc-option,-Wformat-overflow-non-kprintf)
+
+config CC_OPT_WNO_FORMAT_TRUNCATION_NON_KPRINTF
+	def_string "-Wno-format-truncation-non-kprintf" if CC_IS_CLANG && $(cc-option,-Wformat-truncation-non-kprintf)
+
+config CC_OPT_WNO_DEFAULT_CONST_INIT_UNSAFE
+	def_string "-Wno-default-const-init-unsafe" if CC_IS_CLANG && $(cc-option,-Wdefault-const-init-unsafe)
+
+config CC_OPT_WNO_DANGLING_POINTER
+	def_string "-Wno-dangling-pointer" if $(cc-option,-Wdangling-pointer)
+
+config CC_OPT_WVLA_LARGER_THAN
+	def_string "$(cc-option-str,-Wvla-larger-than=1)"
+
+config CC_HAS_WSTRINGOP_OVERFLOW
+	def_bool $(cc-option,-Wstringop-overflow)
+
+config CC_OPT_WNO_UNTERMINATED_STRING_INITIALIZATION
+	def_string "-Wno-unterminated-string-initialization" if $(cc-option,-Wunterminated-string-initialization)
+
+config CC_OPT_WERROR_DESIGNATED_INIT
+	def_string "$(cc-option-str,-Werror=designated-init)"
+
+config CC_OPT_WENUM_CONVERSION
+	def_string "$(cc-option-str,-Wenum-conversion)"
+
+config CC_OPT_WNO_PACKED_NOT_ALIGNED
+	def_string "-Wno-packed-not-aligned" if $(cc-option,-Wpacked-not-aligned)
+
+config CC_OPT_WNO_FORMAT_OVERFLOW
+	def_string "-Wno-format-overflow" if $(cc-option,-Wformat-overflow)
+
+config CC_OPT_WNO_STRINGOP_TRUNCATION
+	def_string "-Wno-stringop-truncation" if $(cc-option,-Wstringop-truncation)
+
 config CC_HAS_COUNTED_BY
 	bool
 	# clang needs to be at least 20.1.0 to avoid potential crashes
diff --git a/scripts/Makefile.warn b/scripts/Makefile.warn
index 35af7d6c6d18..556fa249ca07 100644
--- a/scripts/Makefile.warn
+++ b/scripts/Makefile.warn
@@ -17,7 +17,7 @@ KBUILD_CFLAGS += -Werror=strict-prototypes
 KBUILD_CFLAGS += -Wno-format-security
 KBUILD_CFLAGS += -Wno-trigraphs
 KBUILD_CFLAGS += -Wno-frame-address
-KBUILD_CFLAGS += $(call cc-option, -Wno-address-of-packed-member)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WNO_ADDRESS_OF_PACKED_MEMBER)
 KBUILD_CFLAGS += -Wmissing-declarations
 KBUILD_CFLAGS += -Wmissing-prototypes
 
@@ -30,8 +30,8 @@ KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds
 ifdef CONFIG_CC_IS_CLANG
 # Clang checks for overflow/truncation with '%p', while GCC does not:
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=111219
-KBUILD_CFLAGS += $(call cc-option, -Wno-format-overflow-non-kprintf)
-KBUILD_CFLAGS += $(call cc-option, -Wno-format-truncation-non-kprintf)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WNO_FORMAT_OVERFLOW_NON_KPRINTF)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WNO_FORMAT_TRUNCATION_NON_KPRINTF)
 
 # Clang may emit a warning when a const variable, such as the dummy variables
 # in typecheck(), or const member of an aggregate type are not initialized,
@@ -43,7 +43,7 @@ KBUILD_CFLAGS += $(call cc-option, -Wno-format-truncation-non-kprintf)
 # disabled with this same switch, there should not be too much coverage lost
 # because -Wuninitialized will still flag when an uninitialized const variable
 # is used.
-KBUILD_CFLAGS += $(call cc-option, -Wno-default-const-init-unsafe)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WNO_DEFAULT_CONST_INIT_UNSAFE)
 else
 
 # gcc inanely warns about local variables called 'main'
@@ -54,7 +54,7 @@ endif
 KBUILD_CFLAGS += -Wno-type-limits
 
 # These result in bogus false positives
-KBUILD_CFLAGS += $(call cc-option, -Wno-dangling-pointer)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WNO_DANGLING_POINTER)
 
 # Stack Variable Length Arrays (VLAs) must not be used in the kernel.
 # Function array parameters should, however, be usable, but -Wvla will
@@ -62,7 +62,7 @@ KBUILD_CFLAGS += $(call cc-option, -Wno-dangling-pointer)
 # types, so depend on GCC for now to keep stack VLAs out of the tree.
 # https://github.com/llvm/llvm-project/issues/57098
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=98217
-KBUILD_CFLAGS += $(call cc-option,-Wvla-larger-than=1)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WVLA_LARGER_THAN)
 
 # disable pointer signed / unsigned warnings in gcc 4.0
 KBUILD_CFLAGS += -Wno-pointer-sign
@@ -73,11 +73,11 @@ KBUILD_CFLAGS += -Wno-pointer-sign
 KBUILD_CFLAGS += -Wcast-function-type
 
 # Currently, disable -Wstringop-overflow for GCC 11, globally.
-KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERFLOW) += $(call cc-option, -Wno-stringop-overflow)
-KBUILD_CFLAGS-$(CONFIG_CC_STRINGOP_OVERFLOW) += $(call cc-option, -Wstringop-overflow)
+KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERFLOW) += $(if $(CONFIG_CC_HAS_WSTRINGOP_OVERFLOW),-Wno-stringop-overflow)
+KBUILD_CFLAGS-$(CONFIG_CC_STRINGOP_OVERFLOW) += $(if $(CONFIG_CC_HAS_WSTRINGOP_OVERFLOW),-Wstringop-overflow)
 
 # Currently, disable -Wunterminated-string-initialization as broken
-KBUILD_CFLAGS += $(call cc-option, -Wno-unterminated-string-initialization)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WNO_UNTERMINATED_STRING_INITIALIZATION)
 
 # The allocators already balk at large sizes, so silence the compiler
 # warnings for bounds checks involving those possible values. While
@@ -100,10 +100,10 @@ KBUILD_CFLAGS += -Werror=date-time
 KBUILD_CFLAGS += -Werror=incompatible-pointer-types
 
 # Require designated initializers for all marked structures
-KBUILD_CFLAGS += $(call cc-option,-Werror=designated-init)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WERROR_DESIGNATED_INIT)
 
 # Warn if there is an enum types mismatch
-KBUILD_CFLAGS += $(call cc-option,-Wenum-conversion)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WENUM_CONVERSION)
 
 KBUILD_CFLAGS += -Wunused
 
@@ -125,12 +125,12 @@ else
 # Suppress them by using -Wno... except for W=1.
 KBUILD_CFLAGS += -Wno-unused-but-set-variable
 KBUILD_CFLAGS += -Wno-unused-const-variable
-KBUILD_CFLAGS += $(call cc-option, -Wno-packed-not-aligned)
-KBUILD_CFLAGS += $(call cc-option, -Wno-format-overflow)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WNO_PACKED_NOT_ALIGNED)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WNO_FORMAT_OVERFLOW)
 ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS += -Wno-format-truncation
 endif
-KBUILD_CFLAGS += $(call cc-option, -Wno-stringop-truncation)
+KBUILD_CFLAGS += $(CONFIG_CC_OPT_WNO_STRINGOP_TRUNCATION)
 
 KBUILD_CFLAGS += -Wno-override-init # alias for -Wno-initializer-overrides in clang
 

-- 
2.55.0

