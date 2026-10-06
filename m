Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D413D5C05;
	Tue,  6 Oct 2026 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319347; cv=none; b=Oa4PV20rPwHYyZrOByW9F0fTpwaoV4WPUud++yqFq3K/sx/Jz8qkpnRRTs5Q+A/nsfmzbQdxj0XJbzhEUln5ntnXWPet1281cU2W1ADar8566boYysaITyYtKEVOQE9DPKOJoUhYgRnmbYVr7b0ij08Hyuhbr4i6g3DnhUirKxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319347; c=relaxed/simple;
	bh=t9ViRMTSh54X8wtED+hoKIuuW65gzfe/BbcVMHXD2PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmK4UvxdkD3UD3s8pX3QGWkJyZEISGnAhQwASh9z88ROfkj96y+u9SUr+r5pr8622OyD2QWWZnHp8jXA8Q8FTuv68biYMDheVO4vD5e3yvHuT6VGP/UHFuB+Q7dtrHSK8EDVNgJKWMrP/roYXzXVQF0j4fBH3gw9IaPCdqAOSoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cvvl5jSE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cvvl5jSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DF31F0089D;
	Tue,  6 Oct 2026 20:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791319345;
	bh=RgFf/YhqSFb/oEnYpnkaAPWq48mTxMazcGc6rbc4AZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cvvl5jSEOXg9kKUKUWtTY5Wkin2vDrqMNjWvAYOOSF5j2fjUPSrj67jeGMypzt0/o
	 3+euQ6VWc2bEfuB19QkzhmrG+qEfaRRsCfNcpaqHWCaypdkS04EcNbYq0ovM8w+rSt
	 zDxLqpt9UKrwQX/wDgdCuxu+/zpLTmknDecCflMBP+4yWGCqAIAHALlkY3v8j8vQ/J
	 CaLscaeJ1iN39+7S41tmQz2prBA9cTPVi79SCaM63RhC/vEn4WWz5oj6vm/DWXxDH8
	 CrXlWNsoyF+yiILFUuif3XO7zpcCd0C9l3hILgYvxk4TuwGe09oYqC93I3O+fva0R8
	 ufDH0Pl8g8R8Q==
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-efi@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v1 2/3] efi/libstub: Build the x86 stub from KBUILD_CFLAGS
Date: Tue,  6 Oct 2026 13:42:22 -0700
Message-ID: <20261006204224.1536491-2-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006204210.i.137-kees@kernel.org>
References: <20261006204210.i.137-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4579; i=kees@kernel.org; h=from:subject; bh=t9ViRMTSh54X8wtED+hoKIuuW65gzfe/BbcVMHXD2PE=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlHY/WC1Y+7mx87daBOpXrJ7IgJu1pnB5ydNP/Iu0/HC swZvabv6ihlYRDjYpAVU2QJsnOPc/F42x7uPlcRZg4rE8gQBi5OAZjI7FeMDKcPxZ52ZY+rX2BS 757mtfaw3fLc9SqTV80OeBe8JV3l9wJGhvsXSny2v4lp0lfU8izkdPx542OdzfZQmQtCvfH73ke uZwYA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

The x86 stub replaces KBUILD_CFLAGS with a short list of its own, so new
kernel-wide compiler options go missing, unless explicitly remembered
or when lacking them breaks the build, e.g. commit 5ff8ad3909524
("kbuild: Add '-fms-extensions' to areas with dedicated CFLAGS")
did. Today, several still go missing that are provided to non-x86
stub builds, e.g. -ftrivial-auto-var-init, -fzero-call-used-regs,
-fstrict-flex-arrays=3, and the various kernel's warnings.

Flip the x86 option logic to match the other architectures. Since the
x86 stub is linked into the decompressor rather than the kernel proper,
remove the kernel code model, the i386 register calling convention,
and the kernel's reduced stack alignment, along with the retpoline and
return thunks and the call padding, which only the kernel provides,
and disable kernel stack erasing as the other architectures do. The
existing -mcmodel=small, -march=i386, and -fPIC still get overrides.
Build with -fcf-protection=none, since nothing enables IBT while the
stub runs: the firmware applies forward-edge CFI only to images that
advertise it, which bzImage does not.

New flags that change code generation or semantics in a plain x86_64
defconfig hardening.config stub:

Hardening:
	-ftrivial-auto-var-init=zero
	-fzero-init-padding-bits=all
	-fstrict-flex-arrays=3
	-fno-strict-overflow
	-fno-delete-null-pointer-checks
	-fno-allow-store-data-races
	-fno-jump-tables (from the default IBT config)

C semantics:
	-funsigned-char
	-fno-common

x86 code generation:
	-mno-sse2 -mno-3dnow -mno-avx -mno-sse4a
	 (stub already added -mno-mmx -mno-sse)
	-mno-80387 -mno-fp-ret-in-387 -mskip-rax-setup
	-falign-jumps=1 -falign-loops=1 -fmin-function-alignment=16
	-fomit-frame-pointer -fconserve-stack
	-fno-stack-clash-protection -fno-stack-check -fno-builtin-wcslen

Warnings (lots and lots, but notably):
	-Wall -Wextra -Wundef -Wmissing-prototypes
	-Wvla-larger-than=1 -Wimplicit-fallthrough=5

Present but with no effect, because the stub's later flags override them:
	-O2, overridden by -Os
	-fstack-protector-* flags, overridden by -fno-stack-protector
	-fno-PIE, overridden by -fPIC
	-fcf-protection=branch, overridden by -fcf-protection=none
	the stack-erase plugin, loaded and then disabled

Build tested ARCH=x86_64 defconfig hardening.config, plus retpolines,
return thunks, call depth tracking, IBT, GCC plugins, and EFI mixed
mode, with GCC 16.2.0 and Clang 24.0.0git, and ARCH=i386 defconfig
hardening.config with GCC 16.2.0. Each booted through the EFI stub to
userspace under QEMU with x64 and IA32 OVMF, the latter in mixed mode
for x86_64.

Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 77a2b2d74f3f..1f588591f458 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -6,18 +6,22 @@
 # enabled, even if doing so doesn't break the build.
 #
 
-# non-x86 reuses KBUILD_CFLAGS, x86 does not
 cflags-y			:= $(KBUILD_CFLAGS)
 
-cflags-$(CONFIG_X86_32)		:= -march=i386
-cflags-$(CONFIG_X86_64)		:= -mcmodel=small
-cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ $(CC_FLAGS_DIALECT) \
-				   -fPIC -fno-strict-aliasing -mno-red-zone \
-				   -mno-mmx -mno-sse -fshort-wchar \
-				   -Wno-pointer-sign \
-				   $(call cc-disable-warning, address-of-packed-member) \
-				   -fno-asynchronous-unwind-tables \
-				   $(CLANG_FLAGS)
+# x86 links the stub into the decompressor rather than the kernel proper, so
+# drop the kernel's code model, calling convention, and stack alignment, and
+# the mitigations that rely on thunks and patch sites only the kernel has.
+cflags-$(CONFIG_X86)		:= $(filter-out -mcmodel=kernel \
+				     -mregparm=3 -freg-struct-return \
+				     -mpreferred-stack-boundary=% \
+				     -mstack-alignment=% \
+				     $(RETPOLINE_CFLAGS) $(RETHUNK_CFLAGS) \
+				     $(PADDING_CFLAGS), $(cflags-y))
+cflags-$(CONFIG_X86_32)		+= -march=i386
+cflags-$(CONFIG_X86_64)		+= -mcmodel=small
+cflags-$(CONFIG_X86)		+= -fPIC $(DISABLE_KSTACK_ERASE)
+# Nothing enables IBT while the stub runs, so ENDBR would only take space.
+cflags-$(CONFIG_X86)		+= $(call cc-option,-fcf-protection=none)
 
 # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
 # disable the stackleak plugin
-- 
2.55.0

