Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795391924;
	b=sO7Y+5EYX88zkqFL23IlFr/2PBXAw4aVfMBNDLWxaCZdaSEcCrhF+UraMoBeC1GXCIVy
	 SgasXufzhrO7pKLsW5trmdOsYGqrS9L9oiRSy5E2wrmsrUPKPm5IJSXMzVLlnmWnYzB/3
	 qwT4sWDt1FEgQ6XEqcuIIqHeqT2ozGzmavpHltL3oXd/ceG7kHJ6E/ov+gtGT6JUEvEWW
	 ULNsLmiOxP8XrEo2R3BJZb01OZf1MVVDGgYMHvIWzYeo/5GfcqWFgZJilWvZvqssxXBtr
	 f3x1yQbkWdDnqyNNbvduM3gwX6T1yqSdW2mdIJkymCdMtHiAehs3GFF8dGGBxIHeZHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795391924;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=KM+gRrDkT2gH8BOukvcqAEmqlVoiFZL6X/+IhP5Fdqw=;
	b=kt+nezPia+bRsmu/B1r+Jwv633ELZ9F+0dmMfMI4yPamtBWtgY4BqLmCWYq+D87SNhAs
	 ECuBX7Ezmu7XhPJkuO/0Ai5FTE08oyXH/U8vLxGfVsKMaRhiYrcyf/HdVGhEwnJu78Ocj
	 6KZW9Sx43yeOTf20bDMLRaU96MGHR/qt9G/W0of4ALy4z86T5Nto5sLT2n+KMhxDEfrei
	 4zFzXR8lJmIwKDVfis9pjBjC2qCRRCrcIYN+E0v9GdTjq6WMtMIQJr23ae/R6AEt/Xa3f
	 HpxDABOh1D3/ueOWevZagHoEk1LdiH/bXCdflFFWku+i4/N9IDSdzZfI5S7Oa/IilPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PLe2FtIS;
	arc=none smtp.remote-ip=74.125.82.199
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B57F606A691
	for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 23:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B57F606A691
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PLe2FtIS
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3846d5f54c1so3500668eec.1
        for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 15:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795391921; x=1795996721; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KM+gRrDkT2gH8BOukvcqAEmqlVoiFZL6X/+IhP5Fdqw=;
        b=PLe2FtISDBtAFINIHArSCOUujM7hsy/JZlZBo2DfrVrW7NyANpIu9Nn0/NOa6kZ1R+
         dkU36mVgxAZw4bz7JqMDN0WWtNgR0Uu5YMYFwyP8aWpUrCdhFs8JoRaKPVMyXgeHDS15
         SRXDeBWETM/t8Cc3bMOZ2Ns43eQ0yYLJZXzqogkn6/fHRUm4SOfq9OnBV9g18WT5A65+
         LE8ltw5B/uq9r6f7KUEuOaSN86kDR2GLFSGlsKcygRkstz08jYVwFOiWq3qvqEfbilYZ
         O3rKD8Lv/sEu8PhbDHQZZ6D+Fq4Nrv7DcWJYFNEIRlJQaGGUxIhczk1pViKJ+OtLwMD3
         9VTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795391921; x=1795996721;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KM+gRrDkT2gH8BOukvcqAEmqlVoiFZL6X/+IhP5Fdqw=;
        b=cYOFjE/GEOzOddB2q0mc4+yCggmV4Fu0PxMTHbJenr4sChQg8uDLuElHz4aDEh/KBk
         +JmPXqYKUUv427wgZFHM4lmG8h/EpqYvLnektZVsStVabF36cQyw4p8rSOfPP4hxW2Y1
         AFF74CSZBEazbQUEhHQhvep9dNkbdIS+IlKp6ZjejTMU5IDf9FV7PpReN04gf5SvfBGL
         Bc6fY4+ZNaEgCBhApwoJZ42XcqA2VVHWBm3++2ZmbLNNvk+ZxVH4O3KXDfolhXUWCSd8
         J5qBb2UcKWmMNJqaDBWv97XkBo3RahYnq0Bx/bopJ5/0LrU2rm7+DZkeYZlXiP11AeUJ
         J2Sw==
X-Forwarded-Encrypted: i=1; AL+hErHOyJuihiaGV6EuklL+P/l6M0amcI2EEqZmiqpzApauLaO6llHfmQu8AFrAl38feSUvm/qA75Ff0v8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/C7LOeGnvVcenyZIzn4l0cedFETDve/EKcc0zeJSoX5WHVMsLp
	j869M/YOR8MdGwCcLkjZ1Nh/OKKliZXp2jK+b+f9jZ3GKC4EFHpj77zOsvo10ZYrg10NkK/yxFn
	IhwpJ5fChBA==
X-Received: from dycai24.prod.google.com ([2002:a05:7300:fb18:b0:385:58ae:e3af])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:69d4:b0:386:5adb:ac25
 with SMTP id 5a478bee46e88-3865adbb1d2mr7699576eec.22.1795391920425; Sun, 22
 Nov 2026 15:58:40 -0800 (PST)
Date: Sun, 22 Nov 2026 15:57:47 -0800
In-Reply-To: <20261122235757.3456048-1-irogers@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261122235757.3456048-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261122235757.3456048-2-irogers@google.com>
Subject: [RFC PATCH v1 01/11] unwind: Add Minimal DWARF CFI bytecode
 interpreter and KUnit tests
From: Ian Rogers <irogers@google.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, 
	mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, acme@kernel.org, namhyung@kernel.org, 
	linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, 
	ojeda@kernel.org, rust-for-linux@vger.kernel.org, ardb@kernel.org, 
	linux-efi@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	kvmarm@lists.linux.dev, shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, 
	dylanbhatch@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a strictly bounded DWARF Call Frame Information (.eh_frame /
.eh_frame_hdr) interpreter (CONFIG_UNWIND_DWARF_CFI) matching SFrame's
stack-unwinding state model and security properties, without requiring
new toolchain sections or duplicating user-space unwind metadata.

Instead of implementing a general DWARF expression virtual machine or
tracking arbitrary architectural register arrays, struct dwarf_cfi_row
tracks only:
 - CFA = (SP | FP | prologue scratch reg) + cfa_off, or fixed-pattern
   indirect CFA *(FP + off) (DRAP stack realignment) / *(SP + off)
   (signal trampolines)
 - Frame pointer save rule (SAME, *(CFA + off), *(FP + off), *(SP + off))
 - Return address save rule (SAME in link register, *(CFA + off),
   *(SP + off), or UNDEFINED for bottom-of-stack termination), plus
   AArch64 PAC-RET signing state (DW_CFA_AARCH64_negate_ra_state)

Callee-saved general-purpose register spill/restore opcodes are decoded
and ignored in O(1) space. General DW_OP_* expressions, DW_CFA_set_loc
backward PC jumps, DW_CFA_register rules on {SP, FP, RA}, and
DW_EH_PE_indirect pointer encodings are unconditionally rejected with
-EINVAL. CIEs (<= 128 B), FDEs (<= 4096 B), LEB128 operands (<= 5 B),
and DW_CFA_remember_state nesting (<= 4 entries) execute in a single
forward pass with zero dynamic memory allocations, zero locks, and
Spectre v1 / v1.1 nospec hardening (array_index_nospec() and
barrier_nospec()) across all windowed user stream, expression-buffer,
and state-stack accesses.

Also provide shared RCU-safe loadable-module .eh_frame indexing helpers
(dwarf_cfi_mod_alloc(), dwarf_cfi_mod_free_rcu(), dwarf_cfi_mod_eval())
and a built-in KUnit test suite (CONFIG_UNWIND_DWARF_CFI_KUNIT_TEST)
covering SP/FP frames, ignored GPR spills, shrink-wrapped state stacks,
DRAP and sigreturn frames, ARM64 PAC-RET and RISC-V leaf frames,
security rejections, and live kernel stack walks.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/Kconfig                     |   16 +
 arch/arm64/Kconfig               |    3 -
 include/linux/unwind_dwarf_cfi.h |  174 +++
 kernel/unwind/Makefile           |   13 +-
 kernel/unwind/dwarf_cfi.c        | 1842 ++++++++++++++++++++++++++++++
 kernel/unwind/dwarf_cfi_kunit.c  |  625 ++++++++++
 6 files changed, 2669 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/unwind_dwarf_cfi.h
 create mode 100644 kernel/unwind/dwarf_cfi.c
 create mode 100644 kernel/unwind/dwarf_cfi_kunit.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 1163736de1f9..03399120aa8f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -500,6 +500,22 @@ config HAVE_HARDLOCKUP_DETECTOR_ARCH
 	  It uses the same command line parameters, and sysctl interface,
 	  as the generic hardlockup detectors.
 
+config UNWIND_TABLES
+	bool
+
+config UNWIND_DWARF_CFI
+	bool
+
+config UNWIND_DWARF_CFI_KUNIT_TEST
+	bool "KUnit tests for Minimal DWARF CFI unwinder" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y && UNWIND_DWARF_CFI
+	default KUNIT_ALL_TESTS
+	help
+	  Builds KUnit tests for the Minimal DWARF Call Frame Information (CFI)
+	  bytecode interpreter and stack unwinder.  Covers SP/FP-based frames,
+	  callee-saved GPR opcode skipping, shrink-wrapped state stacks, DRAP
+	  stack realignment, malformed bytecode rejections, and live walks.
+
 config UNWIND_USER
 	bool
 
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9b08b2457a55..ee0f263f477d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -413,9 +413,6 @@ config KASAN_SHADOW_OFFSET
 	default 0xeffffff800000000 if ARM64_VA_BITS_36 && KASAN_SW_TAGS
 	default 0xffffffffffffffff
 
-config UNWIND_TABLES
-	bool
-
 source "arch/arm64/Kconfig.platforms"
 
 menu "Kernel Features"
diff --git a/include/linux/unwind_dwarf_cfi.h b/include/linux/unwind_dwarf_cfi.h
new file mode 100644
index 000000000000..66abb9ee24b9
--- /dev/null
+++ b/include/linux/unwind_dwarf_cfi.h
@@ -0,0 +1,174 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_UNWIND_DWARF_CFI_H
+#define _LINUX_UNWIND_DWARF_CFI_H
+
+#include <linux/types.h>
+
+/*
+ * Minimal DWARF Call Frame Information (CFI) unwinder subset.
+ *
+ * Evaluates a strictly bounded, non-Turing-complete subset of .eh_frame and
+ * .eh_frame_hdr tables matching SFrame's stack-unwinding state model (plus
+ * fixed-pattern DRAP stack-realignment and signal-frame expressions):
+ *  - Advances PC monotonically through a single FDE (no backward jumps)
+ *  - Tracks CFA = (SP | FP | scratch) + cfa_off or *(FP/SP + cfa_off)
+ *  - Tracks stack save offsets for FP and RA (ignoring callee-saved GPR spills)
+ *  - Rejects general DWARF expressions, register-to-register rules on SP/FP/RA,
+ *    and DW_EH_PE_indirect pointer dereferences.
+ */
+
+/* Hard safety bounds enforced on CIE/FDE lengths, offsets, and state stack */
+#define DWARF_CFI_MAX_CIE_LEN		128U
+#define DWARF_CFI_MAX_FDE_LEN		4096U
+#define DWARF_CFI_MAX_CIE_DELTA		(64U * 1024U * 1024U)
+#define DWARF_CFI_MAX_FDE_COUNT		(4U * 1024U * 1024U)
+#define DWARF_CFI_MAX_STATE_STACK	4U
+
+/**
+ * enum dwarf_cfi_base - Base register or addressing mode for computing the CFA
+ * @DWARF_CFI_BASE_UNDEFINED: CFA rule has not been established yet.
+ * @DWARF_CFI_BASE_SP: CFA = stack pointer + cfa_off.
+ * @DWARF_CFI_BASE_FP: CFA = frame pointer + cfa_off.
+ * @DWARF_CFI_BASE_FP_INDIRECT: DRAP stack realignment: CFA = *(FP + cfa_off).
+ * @DWARF_CFI_BASE_SP_INDIRECT: Signal trampoline frame: CFA = *(SP + cfa_off).
+ * @DWARF_CFI_BASE_REG: Transient prologue/epilogue scratch register:
+ *                      CFA = reg(cfa_reg) + cfa_off.
+ */
+enum dwarf_cfi_base {
+	DWARF_CFI_BASE_UNDEFINED = 0,
+	DWARF_CFI_BASE_SP,
+	DWARF_CFI_BASE_FP,
+	DWARF_CFI_BASE_FP_INDIRECT,
+	DWARF_CFI_BASE_SP_INDIRECT,
+	DWARF_CFI_BASE_REG,
+};
+
+/**
+ * enum dwarf_cfi_rule - Recovery rule for the caller's FP or return address
+ * @DWARF_CFI_RULE_SAME: Register retains its value from the current frame
+ *                       (e.g. leaf function link register or unmodified FP).
+ * @DWARF_CFI_RULE_OFFSET: Saved on the stack at *(CFA + off).
+ * @DWARF_CFI_RULE_FP_OFFSET: Saved relative to FP at *(FP + off) (DRAP frame).
+ * @DWARF_CFI_RULE_SP_OFFSET: Saved relative to SP at *(SP + off) (sigframe).
+ * @DWARF_CFI_RULE_UNDEFINED: Explicitly undefined (DW_CFA_undefined); marks
+ *                            the bottom of a stack (e.g. _start or clone).
+ */
+enum dwarf_cfi_rule {
+	DWARF_CFI_RULE_SAME = 0,
+	DWARF_CFI_RULE_OFFSET,
+	DWARF_CFI_RULE_FP_OFFSET,
+	DWARF_CFI_RULE_SP_OFFSET,
+	DWARF_CFI_RULE_UNDEFINED,
+};
+
+/**
+ * struct dwarf_cfi_arch - Architecture DWARF register numbers and word size
+ * @ws: Target address/word size in bytes (4 or 8).
+ * @sp_reg: DWARF register number for the stack pointer.
+ * @fp_reg: DWARF register number for the frame pointer.
+ * @ra_reg: Default DWARF return-address column number.
+ */
+struct dwarf_cfi_arch {
+	u8 ws;
+	u8 sp_reg;
+	u8 fp_reg;
+	u8 ra_reg;
+};
+
+/**
+ * struct dwarf_cfi_row - Evaluated Minimal DWARF unwind state at a target PC
+ * @cfa_off: Byte offset added to the CFA base register before or as the CFA.
+ * @fp_off: Byte offset used to load the saved FP when @fp_rule is an offset.
+ * @ra_off: Byte offset used to load the saved RA when @ra_rule is an offset.
+ * @cfa_base: CFA computation mode (&enum dwarf_cfi_base).
+ * @cfa_reg: DWARF register number when @cfa_base is %DWARF_CFI_BASE_REG.
+ * @fp_rule: Recovery rule for the frame pointer (&enum dwarf_cfi_rule).
+ * @ra_rule: Recovery rule for the return address (&enum dwarf_cfi_rule).
+ * @signal: True if the CIE carries the 'S' signal/interrupt frame augmentation,
+ *          indicating that the saved PC points directly to the interrupted
+ *          instruction rather than after a call instruction.
+ * @ra_signed: True on AArch64 when DW_CFA_AARCH64_negate_ra_state indicates
+ *             that the saved return address carries a PAC signature.
+ */
+struct dwarf_cfi_row {
+	s32 cfa_off;
+	s32 fp_off;
+	s32 ra_off;
+	u8 cfa_base;
+	u8 cfa_reg;
+	u8 fp_rule;
+	u8 ra_rule;
+	bool signal;
+	bool ra_signed;
+};
+
+/**
+ * struct eh_frame_hdr_entry - Binary-search index entry for an FDE
+ * @start_off: Signed 32-bit offset from the table base (or entry field) to the
+ *             FDE's initial PC location.
+ * @fde_off: Signed 32-bit offset from the table base (or entry field) to the
+ *           start of the FDE record in .eh_frame.
+ */
+struct eh_frame_hdr_entry {
+	s32 start_off;
+	s32 fde_off;
+};
+
+#ifdef CONFIG_UNWIND_DWARF_CFI
+
+extern const u8 __start_eh_frame_hdr[];
+extern const u8 __stop_eh_frame_hdr[];
+extern const u8 __start_eh_frame[];
+extern const u8 __stop_eh_frame[];
+
+int dwarf_cfi_eval_fde_kmem(const u8 *fde, const u8 *eh_start,
+			    const u8 *eh_end, unsigned long pc,
+			    const struct dwarf_cfi_arch *arch,
+			    struct dwarf_cfi_row *out_row);
+
+int dwarf_cfi_unwind_eh_frame_hdr(const u8 *hdr, size_t hdr_size,
+				  const u8 *eh_start, const u8 *eh_end,
+				  unsigned long pc,
+				  const struct dwarf_cfi_arch *arch,
+				  struct dwarf_cfi_row *out_row);
+
+int dwarf_cfi_scan_eh_frame_kmem(const u8 *eh_start, size_t eh_size,
+				 const struct dwarf_cfi_arch *arch,
+				 unsigned long base_addr,
+				 struct eh_frame_hdr_entry *entries,
+				 unsigned int max_entries,
+				 unsigned int *out_count);
+
+int dwarf_cfi_unwind_user_eh_frame_hdr(unsigned long hdr_uaddr,
+				       size_t hdr_size, unsigned long pc,
+				       const struct dwarf_cfi_arch *arch,
+				       struct dwarf_cfi_row *out_row);
+
+#if defined(CONFIG_UNWINDER_DWARF_CFI) && defined(CONFIG_MODULES)
+/**
+ * struct mod_dwarf_cfi_index - Sorted FDE lookup table for a loadable module
+ * @num_fdes: Number of sorted FDE index entries in @entries.
+ * @eh_frame: Pointer to the module's in-memory SHF_ALLOC .eh_frame section;
+ *            also serves as the base address for @entries offsets.
+ * @eh_frame_size: Size in bytes of the module's .eh_frame section.
+ * @entries: Sorted binary-search table mapping PCs to module FDEs.
+ */
+struct mod_dwarf_cfi_index {
+	unsigned int num_fdes;
+	const u8 *eh_frame;
+	size_t eh_frame_size;
+	struct eh_frame_hdr_entry entries[] __counted_by(num_fdes);
+};
+
+struct mod_dwarf_cfi_index *dwarf_cfi_mod_alloc(const void *eh_frame,
+						size_t eh_frame_size,
+						const struct dwarf_cfi_arch *arch);
+void dwarf_cfi_mod_free_rcu(struct mod_dwarf_cfi_index *idx);
+int dwarf_cfi_mod_eval(const struct mod_dwarf_cfi_index *idx, unsigned long ip,
+		       const struct dwarf_cfi_arch *arch,
+		       struct dwarf_cfi_row *out_row);
+#endif
+
+#endif /* CONFIG_UNWIND_DWARF_CFI */
+
+#endif /* _LINUX_UNWIND_DWARF_CFI_H */
diff --git a/kernel/unwind/Makefile b/kernel/unwind/Makefile
index eae37bea54fd..73a1ccc2ad77 100644
--- a/kernel/unwind/Makefile
+++ b/kernel/unwind/Makefile
@@ -1 +1,12 @@
- obj-$(CONFIG_UNWIND_USER)	+= user.o deferred.o
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_dwarf_cfi.o = $(CC_FLAGS_FTRACE)
+endif
+KASAN_SANITIZE_dwarf_cfi.o := n
+KCSAN_SANITIZE_dwarf_cfi.o := n
+UBSAN_SANITIZE_dwarf_cfi.o := n
+KMSAN_SANITIZE_dwarf_cfi.o := n
+KCOV_INSTRUMENT_dwarf_cfi.o := n
+
+obj-$(CONFIG_UNWIND_DWARF_CFI)		+= dwarf_cfi.o
+obj-$(CONFIG_UNWIND_USER)		+= user.o deferred.o
+obj-$(CONFIG_UNWIND_DWARF_CFI_KUNIT_TEST) += dwarf_cfi_kunit.o
diff --git a/kernel/unwind/dwarf_cfi.c b/kernel/unwind/dwarf_cfi.c
new file mode 100644
index 000000000000..3e474bce1ab5
--- /dev/null
+++ b/kernel/unwind/dwarf_cfi.c
@@ -0,0 +1,1842 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Minimal DWARF Call Frame Information (CFI) bytecode interpreter.
+ *
+ * Implements a strictly bounded subset of .eh_frame / .eh_frame_hdr matching
+ * SFrame's expressiveness: PC advancement, SP/FP-based CFA offsets, and FP/RA
+ * stack save offsets. Callee-saved GPR spills are decoded and ignored; DWARF
+ * expressions and indirect pointer encodings are rejected.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/nospec.h>
+#include <linux/overflow.h>
+#if defined(CONFIG_UNWINDER_DWARF_CFI) && defined(CONFIG_MODULES)
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+#endif
+#include <linux/string.h>
+#include <linux/uaccess.h>
+#include <linux/unaligned.h>
+#include <linux/unwind_dwarf_cfi.h>
+
+/* DWARF Call Frame Instruction opcodes */
+#define DW_CFA_nop				0x00
+#define DW_CFA_set_loc				0x01
+#define DW_CFA_advance_loc1			0x02
+#define DW_CFA_advance_loc2			0x03
+#define DW_CFA_advance_loc4			0x04
+#define DW_CFA_offset_extended			0x05
+#define DW_CFA_restore_extended			0x06
+#define DW_CFA_undefined			0x07
+#define DW_CFA_same_value			0x08
+#define DW_CFA_register				0x09
+#define DW_CFA_remember_state			0x0a
+#define DW_CFA_restore_state			0x0b
+#define DW_CFA_def_cfa				0x0c
+#define DW_CFA_def_cfa_register			0x0d
+#define DW_CFA_def_cfa_offset			0x0e
+#define DW_CFA_def_cfa_expression		0x0f
+#define DW_CFA_expression			0x10
+#define DW_CFA_offset_extended_sf		0x11
+#define DW_CFA_def_cfa_sf			0x12
+#define DW_CFA_def_cfa_offset_sf		0x13
+#define DW_CFA_val_offset			0x14
+#define DW_CFA_val_offset_sf			0x15
+#define DW_CFA_val_expression			0x16
+#define DW_CFA_AARCH64_negate_ra_state		0x2d
+#define DW_CFA_GNU_args_size			0x2e
+#define DW_CFA_GNU_negative_offset_extended	0x2f
+
+/* Fixed DWARF expression opcodes for DRAP stack-realigned frames */
+#define DW_OP_deref				0x06
+#define DW_OP_breg0				0x70
+
+/* Exception Header Pointer Encoding formats */
+#define DW_EH_PE_omit		0xff
+#define DW_EH_PE_FORM		0x0f
+#define DW_EH_PE_absptr		0x00
+#define DW_EH_PE_uleb128	0x01
+#define DW_EH_PE_udata2		0x02
+#define DW_EH_PE_udata4		0x03
+#define DW_EH_PE_udata8		0x04
+#define DW_EH_PE_sleb128	0x09
+#define DW_EH_PE_sdata2		0x0a
+#define DW_EH_PE_sdata4		0x0b
+#define DW_EH_PE_sdata8		0x0c
+
+#define DW_EH_PE_ADJUST		0x70
+#define DW_EH_PE_abs		0x00
+#define DW_EH_PE_pcrel		0x10
+#define DW_EH_PE_datarel	0x30
+#define DW_EH_PE_indirect	0x80
+
+#define DWARF_CFI_WIN_SIZE	128U
+
+/**
+ * struct dwarf_cfi_cie - Parsed Common Information Entry (CIE) attributes
+ * @code_align: Multiplier applied to DW_CFA_advance_loc* deltas.
+ * @data_align: Signed multiplier applied to factored register/CFA offsets.
+ * @ra_reg: DWARF register column holding the return address for this CIE.
+ * @fde_enc: DW_EH_PE_* pointer encoding for FDE initial_location and range.
+ * @has_z: True if the CIE augmentation string starts with 'z' (length-prefixed
+ *         augmentation data present in both CIE and FDEs).
+ * @signal: True if the CIE augmentation string includes 'S' (signal/interrupt
+ *          frame where PC is not decremented before FDE lookup).
+ */
+struct dwarf_cfi_cie {
+	u32 code_align;
+	s32 data_align;
+	u8 ra_reg;
+	u8 fde_enc;
+	bool has_z;
+	bool signal;
+};
+
+/**
+ * struct dwarf_cfi_stream - Bounded byte reader over kernel or user memory
+ * @buf: Active byte buffer (direct kernel pointer or @scratch window).
+ * @pos: Current byte offset within @buf.
+ * @win_len: Number of valid bytes currently available in @buf.
+ * @rem_after_win: Remaining bytes in user memory after the current window.
+ * @next_uaddr: Next user virtual address to copy when refilling @scratch.
+ * @cur_base_addr: Virtual address corresponding to @buf[0] (used for
+ *                 DW_EH_PE_pcrel pointer decoding).
+ * @scratch: Caller-supplied %DWARF_CFI_WIN_SIZE stack buffer for user streams.
+ * @is_user: False for zero-copy kernel memory, true for windowed user memory.
+ */
+struct dwarf_cfi_stream {
+	const u8 *buf;
+	size_t pos;
+	size_t win_len;
+	size_t rem_after_win;
+	unsigned long next_uaddr;
+	unsigned long cur_base_addr;
+	u8 *scratch;
+	bool is_user;
+};
+
+static __always_inline void cfi_stream_init_kmem(struct dwarf_cfi_stream *s,
+						 const u8 *ptr, size_t len)
+{
+	s->buf = ptr;
+	s->pos = 0;
+	s->win_len = len;
+	s->rem_after_win = 0;
+	s->next_uaddr = 0;
+	s->cur_base_addr = (unsigned long)ptr;
+	s->scratch = NULL;
+	s->is_user = false;
+}
+
+static int cfi_stream_init_user(struct dwarf_cfi_stream *s, unsigned long uaddr,
+				size_t len, u8 *scratch)
+{
+	size_t chunk = min_t(size_t, len, DWARF_CFI_WIN_SIZE);
+
+	if (chunk && copy_from_user(scratch, (const void __user *)uaddr, chunk))
+		return -EFAULT;
+
+	s->buf = scratch;
+	s->pos = 0;
+	s->win_len = chunk;
+	s->rem_after_win = len - chunk;
+	s->next_uaddr = uaddr + chunk;
+	s->cur_base_addr = uaddr;
+	s->scratch = scratch;
+	s->is_user = true;
+	return 0;
+}
+
+static __always_inline bool cfi_stream_empty(const struct dwarf_cfi_stream *s)
+{
+	return s->pos >= s->win_len && (!s->is_user || s->rem_after_win == 0);
+}
+
+static __always_inline unsigned long
+cfi_stream_addr(const struct dwarf_cfi_stream *s)
+{
+	return s->cur_base_addr + s->pos;
+}
+
+static noinline int cfi_stream_refill(struct dwarf_cfi_stream *s)
+{
+	size_t chunk;
+
+	if (!s->is_user || !s->rem_after_win || !s->scratch)
+		return -EINVAL;
+
+	chunk = min_t(size_t, s->rem_after_win, DWARF_CFI_WIN_SIZE);
+	if (copy_from_user(s->scratch, (const void __user *)s->next_uaddr, chunk))
+		return -EFAULT;
+
+	s->cur_base_addr = s->next_uaddr;
+	s->next_uaddr += chunk;
+	s->rem_after_win -= chunk;
+	s->pos = 0;
+	s->win_len = chunk;
+	return 0;
+}
+
+static __always_inline int cfi_read_u8(struct dwarf_cfi_stream *s, u8 *val)
+{
+	size_t idx;
+
+	if (unlikely(s->pos >= s->win_len)) {
+		int err;
+
+		if (!s->is_user)
+			return -EINVAL;
+		err = cfi_stream_refill(s);
+		if (err)
+			return err;
+	}
+	/*
+	 * Prevent Spectre v1 OOB reads past the 128-byte user stack window if
+	 * a preceding bounds check in cfi_skip_bytes() or here mispredicts.
+	 */
+	idx = s->is_user ? array_index_nospec(s->pos, DWARF_CFI_WIN_SIZE) :
+			   s->pos;
+	s->pos = idx + 1;
+	*val = s->buf[idx];
+	return 0;
+}
+
+static __always_inline int cfi_read_bytes(struct dwarf_cfi_stream *s,
+					  void *dst, size_t n)
+{
+	u8 *out = dst;
+
+	if (likely(n <= s->win_len && s->pos <= s->win_len - n)) {
+		size_t idx = s->is_user ?
+			array_index_nospec(s->pos, DWARF_CFI_WIN_SIZE - n + 1) :
+			s->pos;
+
+		memcpy(out, s->buf + idx, n);
+		s->pos = idx + n;
+		return 0;
+	}
+
+	if (!s->is_user)
+		return -EINVAL;
+
+	while (n--) {
+		int err = cfi_read_u8(s, out++);
+
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static int cfi_skip_bytes(struct dwarf_cfi_stream *s, size_t n)
+{
+	size_t avail = (s->win_len - s->pos) + s->rem_after_win;
+
+	if (n > avail)
+		return -EINVAL;
+
+	while (n > 0) {
+		size_t in_win = s->win_len - s->pos;
+
+		if (n <= in_win) {
+			barrier_nospec();
+			s->pos += n;
+			return 0;
+		}
+		if (!s->is_user)
+			return -EINVAL;
+		n -= in_win;
+		s->pos = s->win_len;
+		if (n > 0) {
+			int err = cfi_stream_refill(s);
+
+			if (err)
+				return err;
+		}
+	}
+	return 0;
+}
+
+static noinline int cfi_read_uleb128_u32_slow(struct dwarf_cfi_stream *s,
+					      u32 val, u32 *out)
+{
+	unsigned int shift = 7;
+
+	for (;;) {
+		u8 b;
+		int err = cfi_read_u8(s, &b);
+
+		if (err)
+			return err;
+
+		if (shift == 28 && ((b & 0x7f) > 0x0f || (b & 0x80)))
+			return -EOVERFLOW;
+
+		val |= (u32)(b & 0x7f) << shift;
+		if (!(b & 0x80)) {
+			*out = val;
+			return 0;
+		}
+		shift += 7;
+	}
+}
+
+static __always_inline int cfi_read_uleb128_u32(struct dwarf_cfi_stream *s,
+						u32 *out)
+{
+	u8 b;
+	int err = cfi_read_u8(s, &b);
+
+	if (unlikely(err))
+		return err;
+	if (likely(!(b & 0x80))) {
+		*out = b;
+		return 0;
+	}
+	return cfi_read_uleb128_u32_slow(s, b & 0x7f, out);
+}
+
+static noinline int cfi_read_sleb128_s32_slow(struct dwarf_cfi_stream *s,
+					      u32 val, s32 *out)
+{
+	unsigned int shift = 7;
+
+	for (;;) {
+		u8 b;
+		int err = cfi_read_u8(s, &b);
+
+		if (err)
+			return err;
+
+		if (shift == 28) {
+			u8 top = b & 0x78;
+
+			if ((b & 0x80) || (top != 0x00 && top != 0x78))
+				return -EOVERFLOW;
+		}
+
+		val |= (u32)(b & 0x7f) << shift;
+		shift += 7;
+		if (!(b & 0x80)) {
+			if (shift < 32 && (b & 0x40))
+				val |= ~0U << shift;
+			*out = (s32)val;
+			return 0;
+		}
+	}
+}
+
+static __always_inline int cfi_read_sleb128_s32(struct dwarf_cfi_stream *s,
+						s32 *out)
+{
+	u8 b;
+	int err = cfi_read_u8(s, &b);
+
+	if (unlikely(err))
+		return err;
+	if (likely(!(b & 0x80))) {
+		*out = (b & 0x40) ? (s32)((u32)b | ~0x7fU) : (s32)b;
+		return 0;
+	}
+	return cfi_read_sleb128_s32_slow(s, b & 0x7f, out);
+}
+
+static int cfi_encoded_ptr_size(u8 enc, u8 ws)
+{
+	if (enc == DW_EH_PE_omit)
+		return 0;
+
+	switch (enc & DW_EH_PE_FORM) {
+	case DW_EH_PE_absptr:
+		return ws;
+	case DW_EH_PE_udata2:
+	case DW_EH_PE_sdata2:
+		return 2;
+	case DW_EH_PE_udata4:
+	case DW_EH_PE_sdata4:
+		return 4;
+	case DW_EH_PE_udata8:
+	case DW_EH_PE_sdata8:
+		return 8;
+	default:
+		return -EINVAL;
+	}
+}
+
+/**
+ * cfi_read_encoded_ptr() - Decode a DW_EH_PE_* pointer from a CFI stream
+ * @s: Input byte stream.
+ * @enc: DWARF Exception Header pointer encoding byte.
+ * @ws: Target word size in bytes (4 or 8).
+ * @datarel_base: Base address added when @enc uses DW_EH_PE_datarel.
+ * @out: Decoded virtual address (0 when @enc is DW_EH_PE_omit).
+ *
+ * Decodes fixed-width and LEB128 pointer encodings with abs, pcrel, or datarel
+ * adjustments without ever dereferencing memory: any DW_EH_PE_indirect flag is
+ * strictly rejected with -EINVAL.
+ *
+ * Return: 0 on success, -EFAULT on user copy fault, -EOVERFLOW on LEB128
+ * overflow, or -EINVAL on unsupported or indirect encodings.
+ */
+static int cfi_read_encoded_ptr(struct dwarf_cfi_stream *s, u8 enc, u8 ws,
+				unsigned long datarel_base, unsigned long *out)
+{
+	unsigned long field_addr = cfi_stream_addr(s);
+	s64 raw = 0;
+	u8 buf[8];
+	int err;
+
+	if (enc == DW_EH_PE_omit) {
+		*out = 0;
+		return 0;
+	}
+	if (enc & DW_EH_PE_indirect)
+		return -EINVAL;
+
+	switch (enc & DW_EH_PE_FORM) {
+	case DW_EH_PE_absptr:
+		err = cfi_read_bytes(s, buf, ws);
+		if (err)
+			return err;
+		raw = (ws == 8) ? (s64)get_unaligned_le64(buf) :
+				  (s64)get_unaligned_le32(buf);
+		break;
+	case DW_EH_PE_udata2:
+		err = cfi_read_bytes(s, buf, 2);
+		if (err)
+			return err;
+		raw = get_unaligned_le16(buf);
+		break;
+	case DW_EH_PE_sdata2:
+		err = cfi_read_bytes(s, buf, 2);
+		if (err)
+			return err;
+		raw = (s16)get_unaligned_le16(buf);
+		break;
+	case DW_EH_PE_udata4:
+		err = cfi_read_bytes(s, buf, 4);
+		if (err)
+			return err;
+		raw = get_unaligned_le32(buf);
+		break;
+	case DW_EH_PE_sdata4:
+		err = cfi_read_bytes(s, buf, 4);
+		if (err)
+			return err;
+		raw = (s32)get_unaligned_le32(buf);
+		break;
+	case DW_EH_PE_udata8:
+	case DW_EH_PE_sdata8:
+		err = cfi_read_bytes(s, buf, 8);
+		if (err)
+			return err;
+		raw = (s64)get_unaligned_le64(buf);
+		break;
+	case DW_EH_PE_uleb128: {
+		u32 uval;
+
+		err = cfi_read_uleb128_u32(s, &uval);
+		if (err)
+			return err;
+		raw = uval;
+		break;
+	}
+	case DW_EH_PE_sleb128: {
+		s32 sval;
+
+		err = cfi_read_sleb128_s32(s, &sval);
+		if (err)
+			return err;
+		raw = sval;
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	switch (enc & DW_EH_PE_ADJUST) {
+	case DW_EH_PE_abs:
+		*out = (unsigned long)raw;
+		break;
+	case DW_EH_PE_pcrel:
+		*out = field_addr + (unsigned long)raw;
+		break;
+	case DW_EH_PE_datarel:
+		*out = datarel_base + (unsigned long)raw;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (ws == 4)
+		*out = (u32)*out;
+
+	return 0;
+}
+
+static __always_inline int cfi_factored_offset(s64 factor_operand,
+					       s32 data_align, s32 *out)
+{
+	s64 prod;
+
+	if (unlikely(check_mul_overflow(factor_operand, (s64)data_align, &prod)))
+		return -EOVERFLOW;
+	if (unlikely(prod < S32_MIN || prod > S32_MAX))
+		return -EOVERFLOW;
+
+	*out = (s32)prod;
+	return 0;
+}
+
+static __always_inline bool cfi_cfa_is_reg_off(const struct dwarf_cfi_row *row)
+{
+	return row->cfa_base == DWARF_CFI_BASE_SP ||
+	       row->cfa_base == DWARF_CFI_BASE_FP ||
+	       row->cfa_base == DWARF_CFI_BASE_REG;
+}
+
+static int cfi_set_cfa_reg(u32 reg, const struct dwarf_cfi_arch *arch,
+			   struct dwarf_cfi_row *row)
+{
+	if (reg > U8_MAX)
+		return -EINVAL;
+	if (reg == arch->sp_reg) {
+		row->cfa_base = DWARF_CFI_BASE_SP;
+		row->cfa_reg = (u8)reg;
+		return 0;
+	}
+	if (reg == arch->fp_reg) {
+		row->cfa_base = DWARF_CFI_BASE_FP;
+		row->cfa_reg = (u8)reg;
+		return 0;
+	}
+	/*
+	 * Allow transient prologue/epilogue DRAP scratch registers so scanning
+	 * reaches the body's FP/FP_INDIRECT state (or recovers from pt_regs).
+	 */
+	row->cfa_base = DWARF_CFI_BASE_REG;
+	row->cfa_reg = (u8)reg;
+	return 0;
+}
+
+/*
+ * Match ONLY the fixed 3-part DRAP / sigreturn CFA indirect pattern:
+ *   DW_OP_breg(fp_reg | sp_reg) <sleb128>, DW_OP_deref  =>  CFA = *(reg + off)
+ * All other DWARF expressions are rejected.
+ */
+static int cfi_parse_indirect_cfa_expr(struct dwarf_cfi_stream *s, u32 expr_len,
+				       const struct dwarf_cfi_arch *arch,
+				       struct dwarf_cfi_row *row)
+{
+	struct dwarf_cfi_stream es;
+	u8 expr_buf[8], op0, op_end;
+	enum dwarf_cfi_base base;
+	s32 off;
+	int err;
+
+	if (expr_len < 3 || expr_len > 7)
+		return -EINVAL;
+	/* Prevent Spectre v1.1 speculative stack overflow of expr_buf[8] */
+	barrier_nospec();
+
+	err = cfi_read_bytes(s, expr_buf, expr_len);
+	if (err)
+		return err;
+
+	cfi_stream_init_kmem(&es, expr_buf, expr_len - 1);
+	err = cfi_read_u8(&es, &op0);
+	if (err)
+		return err;
+
+	if (arch->fp_reg <= 31 && op0 == (u8)(DW_OP_breg0 + arch->fp_reg))
+		base = DWARF_CFI_BASE_FP_INDIRECT;
+	else if (arch->sp_reg <= 31 && op0 == (u8)(DW_OP_breg0 + arch->sp_reg))
+		base = DWARF_CFI_BASE_SP_INDIRECT;
+	else
+		return -EINVAL;
+
+	err = cfi_read_sleb128_s32(&es, &off);
+	if (err || !cfi_stream_empty(&es))
+		return -EINVAL;
+
+	op_end = expr_buf[expr_len - 1];
+	if (op_end != DW_OP_deref)
+		return -EINVAL;
+
+	row->cfa_base = base;
+	row->cfa_off = off;
+	return 0;
+}
+
+/*
+ * Match ONLY the fixed 2-part DRAP / sigreturn register save pattern:
+ *   DW_OP_breg(fp_reg | sp_reg) <sleb128>   =>   saved reg at *(FP/SP + off)
+ */
+static int cfi_parse_reg_expr(struct dwarf_cfi_stream *s, u32 reg, u32 expr_len,
+			      const struct dwarf_cfi_arch *arch, u8 ra_reg,
+			      struct dwarf_cfi_row *row)
+{
+	struct dwarf_cfi_stream es;
+	u8 expr_buf[8], op0;
+	enum dwarf_cfi_rule rule;
+	s32 off;
+	int err;
+
+	if (expr_len < 2 || expr_len > 6)
+		return -EINVAL;
+	/* Prevent Spectre v1.1 speculative stack overflow of expr_buf[8] */
+	barrier_nospec();
+
+	err = cfi_read_bytes(s, expr_buf, expr_len);
+	if (err)
+		return err;
+
+	cfi_stream_init_kmem(&es, expr_buf, expr_len);
+	err = cfi_read_u8(&es, &op0);
+	if (err)
+		return err;
+
+	if (arch->fp_reg <= 31 && op0 == (u8)(DW_OP_breg0 + arch->fp_reg))
+		rule = DWARF_CFI_RULE_FP_OFFSET;
+	else if (arch->sp_reg <= 31 && op0 == (u8)(DW_OP_breg0 + arch->sp_reg))
+		rule = DWARF_CFI_RULE_SP_OFFSET;
+	else
+		return -EINVAL;
+
+	err = cfi_read_sleb128_s32(&es, &off);
+	if (err || !cfi_stream_empty(&es))
+		return -EINVAL;
+
+	if (reg == arch->fp_reg) {
+		row->fp_rule = rule;
+		row->fp_off = off;
+		return 0;
+	}
+	if (reg == ra_reg && rule == DWARF_CFI_RULE_SP_OFFSET) {
+		row->ra_rule = rule;
+		row->ra_off = off;
+		return 0;
+	}
+	if (reg == arch->sp_reg && rule == DWARF_CFI_RULE_SP_OFFSET &&
+	    row->cfa_base == DWARF_CFI_BASE_SP_INDIRECT && off == row->cfa_off)
+		return 0;
+
+	return -EINVAL;
+}
+
+static void cfi_apply_reg_rule(u32 reg, enum dwarf_cfi_rule rule, s32 off,
+			       const struct dwarf_cfi_arch *arch, u8 ra_reg,
+			       struct dwarf_cfi_row *row)
+{
+	if (reg == arch->fp_reg) {
+		row->fp_rule = rule;
+		row->fp_off = off;
+	} else if (reg == ra_reg) {
+		row->ra_rule = rule;
+		row->ra_off = off;
+	}
+	/* All other general-purpose registers are intentionally ignored. */
+}
+
+static void cfi_restore_reg(u32 reg, const struct dwarf_cfi_arch *arch,
+			    u8 ra_reg, const struct dwarf_cfi_row *cie_row,
+			    struct dwarf_cfi_row *row)
+{
+	if (reg == arch->fp_reg) {
+		row->fp_rule = cie_row->fp_rule;
+		row->fp_off = cie_row->fp_off;
+	} else if (reg == ra_reg) {
+		row->ra_rule = cie_row->ra_rule;
+		row->ra_off = cie_row->ra_off;
+	}
+}
+
+static __always_inline int cfi_advance_pc(unsigned long *loc, u32 delta,
+					  u32 code_align)
+{
+	unsigned long step;
+
+	if (likely(code_align == 1)) {
+		if (unlikely(check_add_overflow(*loc, (unsigned long)delta, loc)))
+			return -EOVERFLOW;
+		return 0;
+	}
+
+	if (check_mul_overflow((unsigned long)delta, (unsigned long)code_align, &step) ||
+	    check_add_overflow(*loc, step, loc))
+		return -EOVERFLOW;
+	return 0;
+}
+
+/**
+ * dwarf_cfi_exec_insns() - Execute Minimal DWARF CFA instructions up to a PC
+ * @s: Stream positioned at the start of CIE or FDE CFA instructions.
+ * @cie: Parsed CIE attributes providing alignment factors and @ra_reg.
+ * @arch: Target architecture DWARF register numbers.
+ * @cie_row: Initial CIE unwind row for DW_CFA_restore* (NULL while parsing CIE).
+ * @row: In/out unwind row updated in place as instructions execute.
+ * @check_pc: True when evaluating an FDE up to @target_pc; false for CIE init.
+ * @start_pc: Initial PC of the FDE when @check_pc is true.
+ * @target_pc: Target PC at which to stop FDE execution (inclusive).
+ *
+ * Interprets the strictly bounded Minimal DWARF CFA subset in a single forward
+ * pass with a 4-entry state stack for shrink-wrapped functions. Backward PC
+ * jumps (DW_CFA_set_loc), register-to-register rules on SP/FP/RA, and general
+ * DWARF expressions are rejected.
+ *
+ * Return: 0 on success, -EFAULT on user stream fault, -EOVERFLOW on arithmetic
+ * or LEB128 overflow, or -EINVAL on unsupported or malformed opcodes.
+ */
+static int dwarf_cfi_exec_insns(struct dwarf_cfi_stream *s,
+				const struct dwarf_cfi_cie *cie,
+				const struct dwarf_cfi_arch *arch,
+				const struct dwarf_cfi_row *cie_row,
+				struct dwarf_cfi_row *row,
+				bool check_pc, unsigned long start_pc,
+				unsigned long target_pc)
+{
+	struct dwarf_cfi_row state_stack[DWARF_CFI_MAX_STATE_STACK];
+	unsigned int stack_depth = 0;
+	unsigned long loc = start_pc;
+
+	while (!cfi_stream_empty(s) && (!check_pc || loc <= target_pc)) {
+		u8 op, hi, lo;
+		u32 reg, uval;
+		s32 sval, off;
+		int err;
+
+		err = cfi_read_u8(s, &op);
+		if (err)
+			return err;
+
+		hi = op & 0xc0;
+		lo = op & 0x3f;
+
+		if (hi == 0x40) {
+			/* DW_CFA_advance_loc */
+			err = cfi_advance_pc(&loc, lo, cie->code_align);
+			if (err)
+				return err;
+			continue;
+		}
+		if (hi == 0x80) {
+			/* DW_CFA_offset */
+			err = cfi_read_uleb128_u32(s, &uval);
+			if (err)
+				return err;
+			if (lo == arch->fp_reg || lo == cie->ra_reg) {
+				err = cfi_factored_offset(uval, cie->data_align, &off);
+				if (err)
+					return err;
+				cfi_apply_reg_rule(lo, DWARF_CFI_RULE_OFFSET,
+						   off, arch, cie->ra_reg, row);
+			}
+			continue;
+		}
+		if (hi == 0xc0) {
+			/* DW_CFA_restore */
+			if (cie_row)
+				cfi_restore_reg(lo, arch, cie->ra_reg, cie_row, row);
+			continue;
+		}
+
+		switch (op) {
+		case DW_CFA_nop:
+			break;
+
+		case DW_CFA_advance_loc1: {
+			u8 d8;
+
+			err = cfi_read_u8(s, &d8);
+			if (err)
+				return err;
+			err = cfi_advance_pc(&loc, d8, cie->code_align);
+			if (err)
+				return err;
+			break;
+		}
+
+		case DW_CFA_advance_loc2: {
+			u8 b2[2];
+
+			err = cfi_read_bytes(s, b2, 2);
+			if (err)
+				return err;
+			err = cfi_advance_pc(&loc, get_unaligned_le16(b2),
+					     cie->code_align);
+			if (err)
+				return err;
+			break;
+		}
+
+		case DW_CFA_advance_loc4: {
+			u8 b4[4];
+
+			err = cfi_read_bytes(s, b4, 4);
+			if (err)
+				return err;
+			err = cfi_advance_pc(&loc, get_unaligned_le32(b4),
+					     cie->code_align);
+			if (err)
+				return err;
+			break;
+		}
+
+		case DW_CFA_def_cfa:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			err = cfi_read_uleb128_u32(s, &uval);
+			if (err)
+				return err;
+			if (uval > (u32)S32_MAX)
+				return -EOVERFLOW;
+			err = cfi_set_cfa_reg(reg, arch, row);
+			if (err)
+				return err;
+			row->cfa_off = (s32)uval;
+			break;
+
+		case DW_CFA_def_cfa_sf:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			err = cfi_read_sleb128_s32(s, &sval);
+			if (err)
+				return err;
+			err = cfi_factored_offset(sval, cie->data_align, &off);
+			if (err)
+				return err;
+			err = cfi_set_cfa_reg(reg, arch, row);
+			if (err)
+				return err;
+			row->cfa_off = off;
+			break;
+
+		case DW_CFA_def_cfa_register:
+			if (!cfi_cfa_is_reg_off(row))
+				return -EINVAL;
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			err = cfi_set_cfa_reg(reg, arch, row);
+			if (err)
+				return err;
+			break;
+
+		case DW_CFA_def_cfa_offset:
+			if (!cfi_cfa_is_reg_off(row))
+				return -EINVAL;
+			err = cfi_read_uleb128_u32(s, &uval);
+			if (err)
+				return err;
+			if (uval > (u32)S32_MAX)
+				return -EOVERFLOW;
+			row->cfa_off = (s32)uval;
+			break;
+
+		case DW_CFA_def_cfa_offset_sf:
+			if (!cfi_cfa_is_reg_off(row))
+				return -EINVAL;
+			err = cfi_read_sleb128_s32(s, &sval);
+			if (err)
+				return err;
+			err = cfi_factored_offset(sval, cie->data_align, &off);
+			if (err)
+				return err;
+			row->cfa_off = off;
+			break;
+
+		case DW_CFA_offset_extended:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			err = cfi_read_uleb128_u32(s, &uval);
+			if (err)
+				return err;
+			if (reg == arch->fp_reg || reg == cie->ra_reg) {
+				err = cfi_factored_offset(uval, cie->data_align, &off);
+				if (err)
+					return err;
+				cfi_apply_reg_rule(reg, DWARF_CFI_RULE_OFFSET,
+						   off, arch, cie->ra_reg, row);
+			}
+			break;
+
+		case DW_CFA_offset_extended_sf:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			err = cfi_read_sleb128_s32(s, &sval);
+			if (err)
+				return err;
+			if (reg == arch->fp_reg || reg == cie->ra_reg) {
+				err = cfi_factored_offset(sval, cie->data_align, &off);
+				if (err)
+					return err;
+				cfi_apply_reg_rule(reg, DWARF_CFI_RULE_OFFSET,
+						   off, arch, cie->ra_reg, row);
+			}
+			break;
+
+		case DW_CFA_GNU_negative_offset_extended:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			err = cfi_read_uleb128_u32(s, &uval);
+			if (err)
+				return err;
+			if (reg == arch->fp_reg || reg == cie->ra_reg) {
+				err = cfi_factored_offset(-(s64)uval,
+							  cie->data_align, &off);
+				if (err)
+					return err;
+				cfi_apply_reg_rule(reg, DWARF_CFI_RULE_OFFSET,
+						   off, arch, cie->ra_reg, row);
+			}
+			break;
+
+		case DW_CFA_restore_extended:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			if (cie_row)
+				cfi_restore_reg(reg, arch, cie->ra_reg, cie_row, row);
+			break;
+
+		case DW_CFA_undefined:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			cfi_apply_reg_rule(reg, DWARF_CFI_RULE_UNDEFINED,
+					   /*off=*/0, arch, cie->ra_reg, row);
+			break;
+
+		case DW_CFA_same_value:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			cfi_apply_reg_rule(reg, DWARF_CFI_RULE_SAME, /*off=*/0,
+					   arch, cie->ra_reg, row);
+			break;
+
+		case DW_CFA_remember_state:
+			if (stack_depth >= DWARF_CFI_MAX_STATE_STACK)
+				return -EINVAL;
+			stack_depth = array_index_nospec(stack_depth,
+							 DWARF_CFI_MAX_STATE_STACK);
+			state_stack[stack_depth++] = *row;
+			break;
+
+		case DW_CFA_restore_state: {
+			unsigned int idx;
+
+			if (!stack_depth)
+				return -EINVAL;
+			idx = array_index_nospec(stack_depth - 1,
+						 DWARF_CFI_MAX_STATE_STACK);
+			stack_depth = idx;
+			*row = state_stack[idx];
+			break;
+		}
+
+		case DW_CFA_GNU_args_size:
+			err = cfi_read_uleb128_u32(s, &uval);
+			if (err)
+				return err;
+			break;
+
+		case DW_CFA_AARCH64_negate_ra_state:
+			if (arch->ws != 8 || arch->ra_reg != 30)
+				return -EINVAL;
+			row->ra_signed = !row->ra_signed;
+			break;
+
+		case DW_CFA_register:
+			/* Ignorable only if targeting an untracked GPR */
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			err = cfi_read_uleb128_u32(s, &uval);
+			if (err)
+				return err;
+			if (reg == arch->sp_reg || reg == arch->fp_reg ||
+			    reg == cie->ra_reg)
+				return -EINVAL;
+			break;
+
+		case DW_CFA_val_offset:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			err = cfi_read_uleb128_u32(s, &uval);
+			if (err)
+				return err;
+			if (reg == arch->sp_reg || reg == arch->fp_reg ||
+			    reg == cie->ra_reg)
+				return -EINVAL;
+			break;
+
+		case DW_CFA_val_offset_sf:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			err = cfi_read_sleb128_s32(s, &sval);
+			if (err)
+				return err;
+			if (reg == arch->sp_reg || reg == arch->fp_reg ||
+			    reg == cie->ra_reg)
+				return -EINVAL;
+			break;
+
+		case DW_CFA_def_cfa_expression:
+			err = cfi_read_uleb128_u32(s, &uval);
+			if (err)
+				return err;
+			err = cfi_parse_indirect_cfa_expr(s, uval, arch, row);
+			if (err)
+				return err;
+			break;
+
+		case DW_CFA_expression:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			err = cfi_read_uleb128_u32(s, &uval);
+			if (err)
+				return err;
+			if (reg == arch->fp_reg || reg == arch->sp_reg ||
+			    reg == cie->ra_reg) {
+				err = cfi_parse_reg_expr(s, reg, uval, arch,
+							 cie->ra_reg, row);
+				if (err)
+					return err;
+				break;
+			}
+			err = cfi_skip_bytes(s, uval);
+			if (err)
+				return err;
+			break;
+
+		case DW_CFA_val_expression:
+			err = cfi_read_uleb128_u32(s, &reg);
+			if (err)
+				return err;
+			err = cfi_read_uleb128_u32(s, &uval);
+			if (err)
+				return err;
+			if (reg == arch->sp_reg || reg == arch->fp_reg ||
+			    reg == cie->ra_reg)
+				return -EINVAL;
+			err = cfi_skip_bytes(s, uval);
+			if (err)
+				return err;
+			break;
+
+		/*
+		 * Strictly rejected: backward PC jumps and unknown opcodes.
+		 */
+		case DW_CFA_set_loc:
+		default:
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * dwarf_cfi_parse_cie() - Parse a CIE header and its initial CFA instructions
+ * @s: Bounded stream covering the CIE body (after length and CIE ID fields).
+ * @arch: Target architecture DWARF register numbers and word size.
+ * @cie: Output parsed CIE attributes.
+ * @cie_row: Output initial unwind row established by the CIE's instructions.
+ *
+ * Supports CIE versions 1, 3, and 4 and 'z' augmentation strings containing
+ * 'R', 'L', 'P', 'S', and 'B' (skipping LSDA/personality encodings without
+ * dereferencing pointers).
+ *
+ * Return: 0 on success, -EFAULT on user copy fault, -EOVERFLOW on LEB128
+ * overflow, or -EINVAL on unsupported CIE headers or instructions.
+ */
+static int dwarf_cfi_parse_cie(struct dwarf_cfi_stream *s,
+			       const struct dwarf_cfi_arch *arch,
+			       struct dwarf_cfi_cie *cie,
+			       struct dwarf_cfi_row *cie_row)
+{
+	char aug[8];
+	unsigned int aug_idx = 0;
+	u8 version;
+	u32 ra_col;
+	int err;
+
+	memset(cie, 0, sizeof(*cie));
+	cie->fde_enc = DW_EH_PE_absptr;
+
+	err = cfi_read_u8(s, &version);
+	if (err)
+		return err;
+	if (version != 1 && version != 3 && version != 4)
+		return -EINVAL;
+
+	/* Read NUL-terminated augmentation string (bounded to 7 chars) */
+	for (;;) {
+		u8 ch;
+
+		err = cfi_read_u8(s, &ch);
+		if (err)
+			return err;
+		if (ch == '\0') {
+			aug[aug_idx] = '\0';
+			break;
+		}
+		if (aug_idx >= sizeof(aug) - 1)
+			return -EINVAL;
+		aug_idx = array_index_nospec(aug_idx, sizeof(aug) - 1);
+		aug[aug_idx++] = (char)ch;
+	}
+
+	if (version == 4) {
+		u8 addr_sz, seg_sz;
+
+		err = cfi_read_u8(s, &addr_sz);
+		if (err)
+			return err;
+		err = cfi_read_u8(s, &seg_sz);
+		if (err)
+			return err;
+		if (addr_sz != arch->ws || seg_sz != 0)
+			return -EINVAL;
+	}
+
+	err = cfi_read_uleb128_u32(s, &cie->code_align);
+	if (err)
+		return err;
+	err = cfi_read_sleb128_s32(s, &cie->data_align);
+	if (err)
+		return err;
+	if (!cie->code_align || !cie->data_align)
+		return -EINVAL;
+
+	if (version == 1) {
+		u8 ra8;
+
+		err = cfi_read_u8(s, &ra8);
+		if (err)
+			return err;
+		ra_col = ra8;
+	} else {
+		err = cfi_read_uleb128_u32(s, &ra_col);
+		if (err)
+			return err;
+	}
+	if (ra_col > U8_MAX)
+		return -EINVAL;
+	cie->ra_reg = (u8)ra_col;
+
+	if (aug[0] == 'z') {
+		u32 aug_len;
+		unsigned long aug_end;
+		unsigned int i;
+
+		cie->has_z = true;
+		err = cfi_read_uleb128_u32(s, &aug_len);
+		if (err)
+			return err;
+		if (aug_len > DWARF_CFI_MAX_CIE_LEN)
+			return -EINVAL;
+
+		aug_end = cfi_stream_addr(s) + aug_len;
+		for (i = 1; aug[i] != '\0'; i++) {
+			u8 enc;
+			int psize;
+
+			if (cfi_stream_addr(s) > aug_end)
+				return -EINVAL;
+
+			switch (aug[i]) {
+			case 'R':
+				err = cfi_read_u8(s, &cie->fde_enc);
+				if (err)
+					return err;
+				if (cie->fde_enc & DW_EH_PE_indirect)
+					return -EINVAL;
+				break;
+			case 'L':
+				/* LSDA encoding byte; never dereferenced */
+				err = cfi_read_u8(s, &enc);
+				if (err)
+					return err;
+				break;
+			case 'P':
+				/* Personality encoding + pointer; skipped without deref */
+				err = cfi_read_u8(s, &enc);
+				if (err)
+					return err;
+				psize = cfi_encoded_ptr_size(enc & ~DW_EH_PE_indirect,
+							     arch->ws);
+				if (psize < 0)
+					return psize;
+				err = cfi_skip_bytes(s, psize);
+				if (err)
+					return err;
+				break;
+			case 'S':
+				cie->signal = true;
+				break;
+			case 'B':
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+
+		if (cfi_stream_addr(s) > aug_end)
+			return -EINVAL;
+		if (cfi_stream_addr(s) < aug_end) {
+			err = cfi_skip_bytes(s, aug_end - cfi_stream_addr(s));
+			if (err)
+				return err;
+		}
+	} else if (aug[0] != '\0') {
+		return -EINVAL;
+	}
+
+	memset(cie_row, 0, sizeof(*cie_row));
+	cie_row->signal = cie->signal;
+
+	return dwarf_cfi_exec_insns(s, cie, arch, /*cie_row=*/NULL, cie_row,
+				    /*check_pc=*/false, /*start_pc=*/0,
+				    /*target_pc=*/0);
+}
+
+/**
+ * dwarf_cfi_eval_fde_streams() - Evaluate a CIE/FDE stream pair at @pc
+ * @cie_s: Bounded stream over the CIE body.
+ * @fde_s: Bounded stream over the FDE body.
+ * @pc: Target instruction pointer to unwind.
+ * @arch: Target architecture DWARF register descriptor.
+ * @out_row: Output Minimal DWARF unwind row at @pc.
+ *
+ * Return: 0 on success, -ENOENT if @pc lies outside the FDE's address range,
+ * -EFAULT on user copy fault, -EOVERFLOW on overflow, or -EINVAL on malformed
+ * CIE/FDE contents.
+ */
+static int dwarf_cfi_eval_fde_streams(struct dwarf_cfi_stream *cie_s,
+				      struct dwarf_cfi_stream *fde_s,
+				      unsigned long pc,
+				      const struct dwarf_cfi_arch *arch,
+				      struct dwarf_cfi_row *out_row)
+{
+	struct dwarf_cfi_cie cie;
+	struct dwarf_cfi_row cie_row, row;
+	unsigned long init_loc, pc_range, end_loc;
+	int err;
+
+	err = dwarf_cfi_parse_cie(cie_s, arch, &cie, &cie_row);
+	if (err)
+		return err;
+
+	if (likely(cie.fde_enc == (DW_EH_PE_pcrel | DW_EH_PE_sdata4) &&
+		   fde_s->pos + 8 <= fde_s->win_len)) {
+		unsigned long faddr = cfi_stream_addr(fde_s);
+		s32 rel = (s32)get_unaligned_le32(fde_s->buf + fde_s->pos);
+		u32 rng = get_unaligned_le32(fde_s->buf + fde_s->pos + 4);
+
+		fde_s->pos += 8;
+		init_loc = faddr + (long)rel;
+		if (arch->ws == 4)
+			init_loc = (u32)init_loc;
+		pc_range = rng;
+	} else {
+		err = cfi_read_encoded_ptr(fde_s, cie.fde_enc, arch->ws,
+					   /*datarel_base=*/0, &init_loc);
+		if (err)
+			return err;
+		err = cfi_read_encoded_ptr(fde_s, cie.fde_enc & DW_EH_PE_FORM,
+					   arch->ws, /*datarel_base=*/0,
+					   &pc_range);
+		if (err)
+			return err;
+	}
+
+	if (!pc_range || check_add_overflow(init_loc, pc_range, &end_loc))
+		return -EINVAL;
+	if (pc < init_loc || pc >= end_loc)
+		return -ENOENT;
+
+	if (cie.has_z) {
+		u32 aug_len;
+
+		err = cfi_read_uleb128_u32(fde_s, &aug_len);
+		if (err)
+			return err;
+		err = cfi_skip_bytes(fde_s, aug_len);
+		if (err)
+			return err;
+	}
+
+	row = cie_row;
+	err = dwarf_cfi_exec_insns(fde_s, &cie, arch, &cie_row, &row,
+				   /*check_pc=*/true, init_loc, pc);
+	if (err)
+		return err;
+
+	*out_row = row;
+	return 0;
+}
+
+/**
+ * dwarf_cfi_eval_fde_kmem() - Evaluate an in-kernel FDE record at @pc
+ * @fde: Pointer to the start of the FDE record within [@eh_start, @eh_end).
+ * @eh_start: Start of the containing kernel/module .eh_frame section.
+ * @eh_end: End (exclusive) of the containing kernel/module .eh_frame section.
+ * @pc: Target kernel instruction pointer.
+ * @arch: Target architecture DWARF register descriptor.
+ * @out_row: Output Minimal DWARF unwind row at @pc.
+ *
+ * Validates CIE/FDE bounds within [@eh_start, @eh_end) and executes the FDE
+ * directly in kernel memory with zero allocations, making it safe in atomic,
+ * NMI, and noinstr contexts.
+ *
+ * Return: 0 on success, -ENOENT if @pc is outside the FDE's PC range, or
+ * -EINVAL / -EOVERFLOW if the FDE or CIE is malformed or out of bounds.
+ */
+int dwarf_cfi_eval_fde_kmem(const u8 *fde, const u8 *eh_start,
+			    const u8 *eh_end, unsigned long pc,
+			    const struct dwarf_cfi_arch *arch,
+			    struct dwarf_cfi_row *out_row)
+{
+	struct dwarf_cfi_stream cie_s, fde_s;
+	u32 fde_len, cie_delta, cie_len, cie_id;
+	const u8 *cie;
+
+	if (eh_end < eh_start || fde < eh_start || fde >= eh_end ||
+	    (size_t)(eh_end - fde) < 8)
+		return -EINVAL;
+
+	fde_len = get_unaligned_le32(fde);
+	cie_delta = get_unaligned_le32(fde + 4);
+	if (fde_len <= 4 || fde_len > DWARF_CFI_MAX_FDE_LEN || cie_delta < 4)
+		return -EINVAL;
+	if ((size_t)(eh_end - fde) - 4 < (size_t)fde_len)
+		return -EINVAL;
+	if ((size_t)((fde + 4) - eh_start) < cie_delta)
+		return -EINVAL;
+
+	cie = (fde + 4) - cie_delta;
+	if (cie < eh_start || cie >= eh_end || (size_t)(eh_end - cie) < 8)
+		return -EINVAL;
+
+	cie_len = get_unaligned_le32(cie);
+	cie_id = get_unaligned_le32(cie + 4);
+	if (cie_id != 0 || cie_len <= 4 || cie_len > DWARF_CFI_MAX_CIE_LEN)
+		return -EINVAL;
+	if ((size_t)(eh_end - cie) - 4 < (size_t)cie_len)
+		return -EINVAL;
+
+	cfi_stream_init_kmem(&cie_s, cie + 8, cie_len - 4);
+	cfi_stream_init_kmem(&fde_s, fde + 8, fde_len - 4);
+
+	return dwarf_cfi_eval_fde_streams(&cie_s, &fde_s, pc, arch, out_row);
+}
+
+static inline unsigned long eh_hdr_entry_addr(unsigned long hdr_base,
+					      unsigned long entry_addr,
+					      s32 off, u8 table_enc, u8 ws)
+{
+	unsigned long addr;
+
+	if ((table_enc & DW_EH_PE_ADJUST) == DW_EH_PE_pcrel)
+		addr = entry_addr + (long)off;
+	else
+		addr = hdr_base + (long)off;
+
+	return (ws == 4) ? (u32)addr : addr;
+}
+
+/**
+ * dwarf_cfi_unwind_eh_frame_hdr() - Look up and evaluate kernel CFI via hdr
+ * @hdr: Pointer to the kernel's .eh_frame_hdr section.
+ * @hdr_size: Size in bytes of @hdr.
+ * @eh_start: Start of the kernel's .eh_frame section.
+ * @eh_end: End (exclusive) of the kernel's .eh_frame section.
+ * @pc: Target kernel instruction pointer.
+ * @arch: Target architecture DWARF register descriptor.
+ * @out_row: Output Minimal DWARF unwind row at @pc.
+ *
+ * Performs an O(log N) binary search over the sorted version-1 .eh_frame_hdr
+ * lookup table and evaluates the matching FDE in [@eh_start, @eh_end). Safe in
+ * NMI and noinstr contexts.
+ *
+ * Return: 0 on success, -ENOENT if @pc is not covered by any FDE in @hdr, or
+ * -EINVAL / -EOVERFLOW on invalid header or FDE encodings.
+ */
+int dwarf_cfi_unwind_eh_frame_hdr(const u8 *hdr, size_t hdr_size,
+				  const u8 *eh_start, const u8 *eh_end,
+				  unsigned long pc,
+				  const struct dwarf_cfi_arch *arch,
+				  struct dwarf_cfi_row *out_row)
+{
+	unsigned long hdr_base = (unsigned long)hdr;
+	unsigned long fde_cnt_ul, fde_addr;
+	const size_t ent_sz = sizeof(struct eh_frame_hdr_entry);
+	const u8 *table;
+	u32 lo, hi;
+	u8 table_enc;
+
+	if (!hdr || hdr_size < 12 || hdr[0] != 1)
+		return -EINVAL;
+
+	table_enc = hdr[3];
+	if (table_enc != (DW_EH_PE_datarel | DW_EH_PE_sdata4) &&
+	    table_enc != (DW_EH_PE_pcrel | DW_EH_PE_sdata4))
+		return -EINVAL;
+
+	if (likely(hdr[1] == (DW_EH_PE_pcrel | DW_EH_PE_sdata4) &&
+		   hdr[2] == DW_EH_PE_udata4)) {
+		fde_cnt_ul = get_unaligned_le32(hdr + 8);
+		if (!fde_cnt_ul || fde_cnt_ul > DWARF_CFI_MAX_FDE_COUNT)
+			return -EINVAL;
+		if (hdr_size - 12 < fde_cnt_ul * ent_sz)
+			return -EINVAL;
+		table = hdr + 12;
+	} else {
+		struct dwarf_cfi_stream hs;
+		unsigned long eh_ptr;
+		int err;
+
+		cfi_stream_init_kmem(&hs, hdr + 4, hdr_size - 4);
+		err = cfi_read_encoded_ptr(&hs, hdr[1], arch->ws, hdr_base,
+					   &eh_ptr);
+		if (err)
+			return err;
+		err = cfi_read_encoded_ptr(&hs, hdr[2], arch->ws, hdr_base,
+					   &fde_cnt_ul);
+		if (err)
+			return err;
+
+		if (!fde_cnt_ul || fde_cnt_ul > DWARF_CFI_MAX_FDE_COUNT)
+			return -EINVAL;
+		if ((hs.win_len - hs.pos) < fde_cnt_ul * ent_sz)
+			return -EINVAL;
+
+		table = hs.buf + hs.pos;
+	}
+
+	lo = 0;
+	hi = (u32)fde_cnt_ul;
+	if (likely(table_enc == (DW_EH_PE_datarel | DW_EH_PE_sdata4))) {
+		while (lo < hi) {
+			u32 mid = lo + (hi - lo) / 2;
+			const u8 *ent = table + (size_t)mid * ent_sz;
+			s32 off = (s32)get_unaligned_le32(ent);
+
+			if (hdr_base + (long)off <= pc)
+				lo = mid + 1;
+			else
+				hi = mid;
+		}
+		if (!lo)
+			return -ENOENT;
+		fde_addr = hdr_base +
+			   (long)(s32)get_unaligned_le32(table + (size_t)(lo - 1) * ent_sz + 4);
+	} else {
+		while (lo < hi) {
+			u32 mid = lo + (hi - lo) / 2;
+			const u8 *ent = table + (size_t)mid * ent_sz;
+			unsigned long e_pc = (unsigned long)ent +
+					     (long)(s32)get_unaligned_le32(ent);
+
+			if (e_pc <= pc)
+				lo = mid + 1;
+			else
+				hi = mid;
+		}
+		if (!lo)
+			return -ENOENT;
+		{
+			const u8 *fent = table + (size_t)(lo - 1) * ent_sz + 4;
+
+			fde_addr = (unsigned long)fent +
+				   (long)(s32)get_unaligned_le32(fent);
+		}
+	}
+
+	return dwarf_cfi_eval_fde_kmem((const u8 *)fde_addr, eh_start, eh_end,
+				       pc, arch, out_row);
+}
+
+static bool cfi_s32_rel_offset(unsigned long target, unsigned long base,
+			       s32 *out)
+{
+	unsigned long diff;
+
+	if (target >= base) {
+		diff = target - base;
+		if (diff > (unsigned long)S32_MAX)
+			return false;
+		*out = (s32)diff;
+		return true;
+	}
+
+	diff = base - target;
+	if (diff > (unsigned long)S32_MAX + 1UL)
+		return false;
+	*out = (diff == (unsigned long)S32_MAX + 1UL) ? S32_MIN : -(s32)diff;
+	return true;
+}
+
+/**
+ * dwarf_cfi_scan_eh_frame_kmem() - Scan a kernel .eh_frame to index its FDEs
+ * @eh_start: Start of the in-memory .eh_frame section.
+ * @eh_size: Size in bytes of the .eh_frame section.
+ * @arch: Target architecture DWARF register descriptor.
+ * @base_addr: Reference base address from which @entries offsets are computed.
+ * @entries: Optional output array of &struct eh_frame_hdr_entry (NULL to only
+ *           count FDEs).
+ * @max_entries: Capacity of @entries when @entries is non-NULL.
+ * @out_count: Output number of valid FDEs discovered in [@eh_start, +@eh_size).
+ *
+ * Used at module load time (and in tests) to construct a binary-search FDE
+ * lookup table when the linker has not emitted a separate .eh_frame_hdr.
+ *
+ * Return: 0 on success, -ENOSPC if @entries is non-NULL and smaller than the
+ * FDE count, -EOVERFLOW if an offset exceeds s32 range from @base_addr, or
+ * -EINVAL on malformed CIE/FDE records.
+ */
+int dwarf_cfi_scan_eh_frame_kmem(const u8 *eh_start, size_t eh_size,
+				 const struct dwarf_cfi_arch *arch,
+				 unsigned long base_addr,
+				 struct eh_frame_hdr_entry *entries,
+				 unsigned int max_entries,
+				 unsigned int *out_count)
+{
+	const u8 *p = eh_start;
+	const u8 *eh_end = eh_start + eh_size;
+	unsigned int count = 0;
+
+	if (!arch || arch->ws != sizeof(unsigned long))
+		return -EINVAL;
+
+	while (p < eh_end && (size_t)(eh_end - p) >= 4) {
+		u32 len = get_unaligned_le32(p);
+		u32 cie_delta;
+		const u8 *entry_end;
+
+		if (len == 0)
+			break;
+		if (len <= 4 || len == U32_MAX ||
+		    (size_t)(eh_end - p) - 4 < (size_t)len)
+			return -EINVAL;
+
+		entry_end = p + 4 + len;
+		cie_delta = get_unaligned_le32(p + 4);
+
+		if (cie_delta != 0) {
+			/* FDE: resolve CIE to decode initial_loc */
+			const u8 *cie;
+			u32 cie_len;
+			struct dwarf_cfi_stream cie_s, fde_s;
+			struct dwarf_cfi_cie parsed_cie;
+			struct dwarf_cfi_row dummy_row;
+			unsigned long init_loc;
+			s32 rel_pc, rel_fde;
+			int err;
+
+			if (cie_delta < 4 ||
+			    (size_t)((p + 4) - eh_start) < cie_delta)
+				return -EINVAL;
+			cie = (p + 4) - cie_delta;
+			if (cie < eh_start || cie >= eh_end ||
+			    (size_t)(eh_end - cie) < 8)
+				return -EINVAL;
+			cie_len = get_unaligned_le32(cie);
+			if (cie_len <= 4 || cie_len > DWARF_CFI_MAX_CIE_LEN ||
+			    (size_t)(eh_end - cie) - 4 < (size_t)cie_len ||
+			    get_unaligned_le32(cie + 4) != 0)
+				return -EINVAL;
+
+			cfi_stream_init_kmem(&cie_s, cie + 8, cie_len - 4);
+			err = dwarf_cfi_parse_cie(&cie_s, arch, &parsed_cie, &dummy_row);
+			if (err)
+				return err;
+
+			cfi_stream_init_kmem(&fde_s, p + 8, len - 4);
+			err = cfi_read_encoded_ptr(&fde_s, parsed_cie.fde_enc,
+						   arch->ws, /*datarel_base=*/0,
+						   &init_loc);
+			if (err)
+				return err;
+
+			if (!cfi_s32_rel_offset(init_loc, base_addr, &rel_pc) ||
+			    !cfi_s32_rel_offset((unsigned long)p, base_addr,
+						&rel_fde))
+				return -EOVERFLOW;
+
+			if (entries) {
+				if (count >= max_entries)
+					return -ENOSPC;
+				entries[count].start_off = rel_pc;
+				entries[count].fde_off = rel_fde;
+			}
+			count++;
+		}
+
+		p = entry_end;
+	}
+
+	*out_count = count;
+	return 0;
+}
+
+/**
+ * dwarf_cfi_unwind_user_eh_frame_hdr() - Evaluate user-space CFI from user hdr
+ * @hdr_uaddr: User virtual address of the binary's PT_GNU_EH_FRAME segment.
+ * @hdr_size: Size in bytes of the PT_GNU_EH_FRAME segment.
+ * @pc: Target user instruction pointer.
+ * @arch: User architecture DWARF register descriptor (native or compat).
+ * @out_row: Output Minimal DWARF unwind row at @pc.
+ *
+ * Binary-searches the user .eh_frame_hdr table via copy_from_user() and
+ * streams the matching FDE and its CIE through bounded 128-byte stack windows.
+ * Must be called in sleepable task context (calls might_fault()).
+ *
+ * Return: 0 on success, -ENOENT if @pc is not covered by @hdr_uaddr, -EFAULT
+ * on unmapped user memory, or -EINVAL / -EOVERFLOW on invalid encodings.
+ */
+int dwarf_cfi_unwind_user_eh_frame_hdr(unsigned long hdr_uaddr,
+				       size_t hdr_size, unsigned long pc,
+				       const struct dwarf_cfi_arch *arch,
+				       struct dwarf_cfi_row *out_row)
+{
+	struct dwarf_cfi_stream hs, cie_s, fde_s;
+	unsigned long eh_ptr, fde_cnt_ul, table_uaddr, fde_uaddr, cie_uaddr;
+	const size_t ent_sz = sizeof(struct eh_frame_hdr_entry);
+	u8 cie_win[DWARF_CFI_WIN_SIZE], fde_win[DWARF_CFI_WIN_SIZE];
+	u8 hdr_prefix[28];
+	u8 fde_hdr[8], cie_hdr[8];
+	u32 fde_len, cie_delta, cie_len, cie_id;
+	u32 lo, hi;
+	bool have_match = false;
+	size_t prefix_len;
+	u8 table_enc;
+	int err;
+
+	might_fault();
+
+	if (!hdr_uaddr || hdr_size < 12)
+		return -EINVAL;
+
+	prefix_len = min_t(size_t, hdr_size, sizeof(hdr_prefix));
+	if (copy_from_user(hdr_prefix, (const void __user *)hdr_uaddr, prefix_len))
+		return -EFAULT;
+
+	if (hdr_prefix[0] != 1)
+		return -EINVAL;
+
+	table_enc = hdr_prefix[3];
+	if (table_enc != (DW_EH_PE_datarel | DW_EH_PE_sdata4) &&
+	    table_enc != (DW_EH_PE_pcrel | DW_EH_PE_sdata4))
+		return -EINVAL;
+
+	cfi_stream_init_kmem(&hs, hdr_prefix + 4, prefix_len - 4);
+	hs.cur_base_addr = hdr_uaddr + 4;
+
+	err = cfi_read_encoded_ptr(&hs, hdr_prefix[1], arch->ws, hdr_uaddr, &eh_ptr);
+	if (err)
+		return err;
+	err = cfi_read_encoded_ptr(&hs, hdr_prefix[2], arch->ws, hdr_uaddr, &fde_cnt_ul);
+	if (err)
+		return err;
+
+	if (!fde_cnt_ul || fde_cnt_ul > DWARF_CFI_MAX_FDE_COUNT)
+		return -EINVAL;
+
+	table_uaddr = cfi_stream_addr(&hs);
+	if (hdr_size - (table_uaddr - hdr_uaddr) < fde_cnt_ul * ent_sz)
+		return -EINVAL;
+
+	lo = 0;
+	hi = (u32)fde_cnt_ul;
+	while (lo < hi) {
+		u32 mid = lo + (hi - lo) / 2;
+		unsigned long ent_uaddr = table_uaddr + (size_t)mid * ent_sz;
+		struct eh_frame_hdr_entry ent;
+		unsigned long e_pc;
+
+		if (copy_from_user(&ent, (const void __user *)ent_uaddr, sizeof(ent)))
+			return -EFAULT;
+
+		e_pc = eh_hdr_entry_addr(hdr_uaddr, ent_uaddr,
+					 le32_to_cpu((__force __le32)ent.start_off),
+					 table_enc, arch->ws);
+		if (e_pc <= pc) {
+			unsigned long foff_uaddr =
+				ent_uaddr + offsetof(struct eh_frame_hdr_entry, fde_off);
+
+			fde_uaddr = eh_hdr_entry_addr(hdr_uaddr, foff_uaddr,
+						      le32_to_cpu((__force __le32)ent.fde_off),
+						      table_enc, arch->ws);
+			have_match = true;
+			lo = mid + 1;
+		} else {
+			hi = mid;
+		}
+	}
+
+	if (!have_match)
+		return -ENOENT;
+
+	if (copy_from_user(fde_hdr, (const void __user *)fde_uaddr, sizeof(fde_hdr)))
+		return -EFAULT;
+
+	fde_len = get_unaligned_le32(fde_hdr);
+	cie_delta = get_unaligned_le32(fde_hdr + 4);
+	if (fde_len <= 4 || fde_len > DWARF_CFI_MAX_FDE_LEN ||
+	    cie_delta < 4 || cie_delta > DWARF_CFI_MAX_CIE_DELTA)
+		return -EINVAL;
+	if (fde_uaddr + 4 < cie_delta)
+		return -EINVAL;
+
+	cie_uaddr = (fde_uaddr + 4) - cie_delta;
+	if (copy_from_user(cie_hdr, (const void __user *)cie_uaddr, sizeof(cie_hdr)))
+		return -EFAULT;
+
+	cie_len = get_unaligned_le32(cie_hdr);
+	cie_id = get_unaligned_le32(cie_hdr + 4);
+	if (cie_id != 0 || cie_len <= 4 || cie_len > DWARF_CFI_MAX_CIE_LEN)
+		return -EINVAL;
+
+	err = cfi_stream_init_user(&cie_s, cie_uaddr + 8, cie_len - 4, cie_win);
+	if (err)
+		return err;
+	err = cfi_stream_init_user(&fde_s, fde_uaddr + 8, fde_len - 4, fde_win);
+	if (err)
+		return err;
+
+	return dwarf_cfi_eval_fde_streams(&cie_s, &fde_s, pc, arch, out_row);
+}
+
+#if defined(CONFIG_UNWINDER_DWARF_CFI) && defined(CONFIG_MODULES)
+static int cmp_eh_hdr_entry(const void *a, const void *b)
+{
+	const struct eh_frame_hdr_entry *ea = a;
+	const struct eh_frame_hdr_entry *eb = b;
+
+	return (ea->start_off > eb->start_off) - (ea->start_off < eb->start_off);
+}
+
+/**
+ * dwarf_cfi_mod_alloc() - Allocate and sort a module .eh_frame lookup index
+ * @eh_frame: Pointer to the module's SHF_ALLOC .eh_frame section.
+ * @eh_frame_size: Size in bytes of @eh_frame.
+ * @arch: Target architecture DWARF register descriptor.
+ *
+ * Performs a two-pass scan over @eh_frame to count and populate relative FDE
+ * index entries and sorts them by initial PC offset for binary search.
+ *
+ * Return: Newly allocated &struct mod_dwarf_cfi_index on success, or NULL if
+ * @eh_frame is empty, malformed, or memory allocation fails.
+ */
+struct mod_dwarf_cfi_index *dwarf_cfi_mod_alloc(const void *eh_frame,
+						size_t eh_frame_size,
+						const struct dwarf_cfi_arch *arch)
+{
+	struct mod_dwarf_cfi_index *idx;
+	unsigned int num_fdes = 0;
+	unsigned long base;
+
+	if (!eh_frame || !eh_frame_size)
+		return NULL;
+
+	base = (unsigned long)eh_frame;
+	if (dwarf_cfi_scan_eh_frame_kmem(eh_frame, eh_frame_size, arch, base,
+					 /*entries=*/NULL, /*max_entries=*/0,
+					 &num_fdes) || !num_fdes)
+		return NULL;
+
+	idx = kmalloc(struct_size(idx, entries, num_fdes), GFP_KERNEL);
+	if (!idx)
+		return NULL;
+
+	idx->num_fdes = num_fdes;
+	idx->eh_frame = eh_frame;
+	idx->eh_frame_size = eh_frame_size;
+
+	if (dwarf_cfi_scan_eh_frame_kmem(eh_frame, eh_frame_size, arch, base,
+					 idx->entries, num_fdes, &num_fdes)) {
+		kfree(idx);
+		return NULL;
+	}
+	idx->num_fdes = num_fdes;
+
+	sort(idx->entries, idx->num_fdes, sizeof(idx->entries[0]),
+	     cmp_eh_hdr_entry, /*swap_func=*/NULL);
+	return idx;
+}
+
+/**
+ * dwarf_cfi_mod_free_rcu() - Free a module CFI index after an RCU grace period
+ * @idx: Module CFI index previously unpublished from mod->arch (may be NULL).
+ */
+void dwarf_cfi_mod_free_rcu(struct mod_dwarf_cfi_index *idx)
+{
+	if (idx)
+		kfree_rcu_mightsleep(idx);
+}
+
+/**
+ * dwarf_cfi_mod_eval() - Look up and evaluate a module FDE at @ip
+ * @idx: RCU-protected module CFI index (may be NULL).
+ * @ip: Target module instruction pointer.
+ * @arch: Target architecture DWARF register descriptor.
+ * @out_row: Output Minimal DWARF unwind row at @ip.
+ *
+ * Caller must hold an RCU or RCU-sched read lock keeping both @idx and the
+ * module's core/init .eh_frame memory alive across the evaluation.
+ *
+ * Return: 0 on success, -ENOENT if @idx is NULL or no FDE covers @ip, or
+ * -EINVAL / -EOVERFLOW on invalid FDE bytecode.
+ */
+int dwarf_cfi_mod_eval(const struct mod_dwarf_cfi_index *idx, unsigned long ip,
+		       const struct dwarf_cfi_arch *arch,
+		       struct dwarf_cfi_row *out_row)
+{
+	unsigned long base;
+	u32 lo, hi, found = 0;
+	bool have_match = false;
+	const u8 *fde;
+
+	if (!idx || !idx->num_fdes)
+		return -ENOENT;
+
+	base = (unsigned long)idx->eh_frame;
+	lo = 0;
+	hi = idx->num_fdes;
+	while (lo < hi) {
+		u32 mid = lo + (hi - lo) / 2;
+		unsigned long e_pc = base + (long)idx->entries[mid].start_off;
+
+		if (e_pc <= ip) {
+			found = mid;
+			have_match = true;
+			lo = mid + 1;
+		} else {
+			hi = mid;
+		}
+	}
+
+	if (!have_match)
+		return -ENOENT;
+
+	fde = (const u8 *)(base + (long)idx->entries[found].fde_off);
+	return dwarf_cfi_eval_fde_kmem(fde, idx->eh_frame,
+				       idx->eh_frame + idx->eh_frame_size,
+				       ip, arch, out_row);
+}
+#endif /* CONFIG_UNWINDER_DWARF_CFI && CONFIG_MODULES */
diff --git a/kernel/unwind/dwarf_cfi_kunit.c b/kernel/unwind/dwarf_cfi_kunit.c
new file mode 100644
index 000000000000..8d63fb5535be
--- /dev/null
+++ b/kernel/unwind/dwarf_cfi_kunit.c
@@ -0,0 +1,625 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit tests for Minimal DWARF Call Frame Information (CFI) unwinder.
+ */
+
+#include <kunit/test.h>
+#include <linux/kernel.h>
+#include <linux/stacktrace.h>
+#include <linux/unaligned.h>
+#include <linux/unwind_dwarf_cfi.h>
+
+static __always_inline unsigned long record_here_ip(void)
+{
+	unsigned long ip;
+
+#if defined(__x86_64__)
+	asm volatile("1: lea 1b(%%rip), %0" : "=r"(ip));
+#elif defined(__aarch64__)
+	asm volatile("1: adr %0, 1b" : "=r"(ip));
+#elif defined(__riscv)
+	asm volatile("1: auipc %0, 0" : "=r"(ip));
+#else
+	ip = _THIS_IP_;
+#endif
+	return ip;
+}
+
+static const struct dwarf_cfi_arch test_x86_64_arch = {
+	.ws	= 8,
+	.sp_reg	= 7,	/* rsp */
+	.fp_reg	= 6,	/* rbp */
+	.ra_reg	= 16,	/* rip */
+};
+
+static const struct dwarf_cfi_arch test_arm64_arch = {
+	.ws	= 8,
+	.sp_reg	= 31,	/* sp */
+	.fp_reg	= 29,	/* x29 */
+	.ra_reg	= 30,	/* x30 (lr) */
+};
+
+static const struct dwarf_cfi_arch test_riscv64_arch = {
+	.ws	= 8,
+	.sp_reg	= 2,	/* sp (x2) */
+	.fp_reg	= 8,	/* s0/fp (x8) */
+	.ra_reg	= 1,	/* ra (x1) */
+};
+
+/*
+ * Helper to construct a compact [CIE | FDE] .eh_frame blob in kernel memory
+ * with absptr encoding so tests can use arbitrary synthetic PCs.
+ */
+struct test_eh_blob {
+	u8 buf[256];
+	size_t fde_off;
+	size_t total_len;
+};
+
+static void build_arch_eh_blob(struct test_eh_blob *b,
+			       const struct dwarf_cfi_arch *arch,
+			       u8 code_align, u8 data_align_sleb,
+			       const char *aug, u8 fde_enc,
+			       const u8 *cie_insns, size_t cie_insns_len,
+			       unsigned long init_pc, unsigned long pc_range,
+			       const u8 *fde_insns, size_t fde_insns_len)
+{
+	u8 *p = b->buf;
+	size_t cie_start = 0, cie_len_pos, fde_start, fde_len_pos;
+
+	memset(b, 0, sizeof(*b));
+
+	/* CIE */
+	cie_len_pos = p - b->buf;
+	p += 4;
+	put_unaligned_le32(0, p);
+	p += 4;
+	*p++ = 1;
+	memcpy(p, aug, strlen(aug) + 1);
+	p += strlen(aug) + 1;
+	*p++ = code_align;
+	*p++ = data_align_sleb;
+	*p++ = arch->ra_reg;
+	if (aug[0] == 'z') {
+		*p++ = 1;
+		*p++ = fde_enc;
+	}
+	memcpy(p, cie_insns, cie_insns_len);
+	p += cie_insns_len;
+	while ((p - b->buf) & 3)
+		*p++ = 0x00;
+	put_unaligned_le32((u32)((p - b->buf) - cie_start - 4),
+			   b->buf + cie_len_pos);
+
+	/* FDE */
+	fde_start = p - b->buf;
+	b->fde_off = fde_start;
+	fde_len_pos = fde_start;
+	p += 4;
+	put_unaligned_le32((u32)((p - b->buf) - cie_start), p);
+	p += 4;
+	put_unaligned_le64(init_pc, p);
+	p += 8;
+	put_unaligned_le64(pc_range, p);
+	p += 8;
+	if (aug[0] == 'z')
+		*p++ = 0;
+	memcpy(p, fde_insns, fde_insns_len);
+	p += fde_insns_len;
+	while ((p - b->buf) & 3)
+		*p++ = 0x00;
+	put_unaligned_le32((u32)((p - b->buf) - fde_start - 4),
+			   b->buf + fde_len_pos);
+
+	b->total_len = p - b->buf;
+}
+
+static void build_test_eh_blob(struct test_eh_blob *b, const char *aug,
+			       u8 fde_enc, unsigned long init_pc,
+			       unsigned long pc_range,
+			       const u8 *fde_insns, size_t fde_insns_len)
+{
+	static const u8 x86_cie_insns[] = { 0x0c, 7, 8, 0x80 | 16, 1 };
+
+	build_arch_eh_blob(b, &test_x86_64_arch, /*code_align=*/1,
+			   /*data_align_sleb=*/0x78, aug, fde_enc,
+			   x86_cie_insns, sizeof(x86_cie_insns),
+			   init_pc, pc_range, fde_insns, fde_insns_len);
+}
+
+static void test_cfi_sp_and_ignored_gprs(struct kunit *test)
+{
+	/*
+	 * Simulate a typical -fomit-frame-pointer function at 0x1000..0x1040:
+	 *   +0..+1: push %r12 -> advance_loc 2, def_cfa_offset 16, offset r12 at cfa-16
+	 *   +2..+2: push %rbx -> advance_loc 1, def_cfa_offset 24, offset rbx at cfa-24
+	 *   +3..+6: sub $32, %rsp -> advance_loc 4, def_cfa_offset 56
+	 *   +7:     GNU_args_size 16
+	 */
+	static const u8 insns[] = {
+		0x40 | 2,		/* DW_CFA_advance_loc 2 -> 0x1002 */
+		0x0e, 16,		/* DW_CFA_def_cfa_offset 16 */
+		0x80 | 12, 2,		/* DW_CFA_offset r12, 2 (ignored) */
+		0x40 | 1,		/* DW_CFA_advance_loc 1 -> 0x1003 */
+		0x0e, 24,		/* DW_CFA_def_cfa_offset 24 */
+		0x80 | 3, 3,		/* DW_CFA_offset rbx, 3 (ignored) */
+		0x40 | 4,		/* DW_CFA_advance_loc 4 -> 0x1007 */
+		0x0e, 56,		/* DW_CFA_def_cfa_offset 56 */
+		0x2e, 16,		/* DW_CFA_GNU_args_size 16 (ignored) */
+	};
+	struct test_eh_blob blob;
+	struct dwarf_cfi_row row;
+
+	build_test_eh_blob(&blob, "zR", 0x04 /* udata8 abs */, 0x1000, 0x40,
+			   insns, sizeof(insns));
+
+	/* At entry (0x1000): CFA = rsp + 8, RA = cfa - 8, FP = same */
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x1000,
+					&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_SP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 8);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_SAME);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.ra_off, -8);
+
+	/* Mid-prologue (0x1002): CFA = rsp + 16 */
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x1002,
+					&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 16);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_SAME);
+
+	/* Body (0x1020): CFA = rsp + 56, r12/rbx spills ignored */
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x1020,
+					&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_SP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 56);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_SAME);
+
+	/* Out-of-range PC (0x1040) returns -ENOENT */
+	KUNIT_EXPECT_EQ(test, -ENOENT,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x1040,
+					&test_x86_64_arch, &row));
+}
+
+static void test_cfi_fp_and_remember_restore(struct kunit *test)
+{
+	/*
+	 * Simulate an FP frame with a mid-function shrink-wrapped epilogue:
+	 *   0x2001: def_cfa_offset 16, offset rbp at cfa-16
+	 *   0x2004: def_cfa_register rbp
+	 *   0x2010: remember_state; def_cfa rsp, 8; restore rbp (early ret)
+	 *   0x2012: restore_state (cold tail still uses rbp frame)
+	 */
+	static const u8 insns[] = {
+		0x40 | 1,		/* advance 1 -> 0x2001 */
+		0x0e, 16,		/* def_cfa_offset 16 */
+		0x80 | 6, 2,		/* offset rbp(6), cfa-16 */
+		0x40 | 3,		/* advance 3 -> 0x2004 */
+		0x0d, 6,		/* def_cfa_register rbp(6) */
+		0x40 | 12,		/* advance 12 -> 0x2010 */
+		0x0a,			/* DW_CFA_remember_state */
+		0x0c, 7, 8,		/* def_cfa rsp(7), 8 */
+		0xc0 | 6,		/* restore rbp(6) */
+		0x40 | 2,		/* advance 2 -> 0x2012 */
+		0x0b,			/* DW_CFA_restore_state */
+	};
+	struct test_eh_blob blob;
+	struct dwarf_cfi_row row;
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x2000, 0x30, insns, sizeof(insns));
+
+	/* In body (0x2008): CFA = rbp + 16, FP = *(cfa - 16) */
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x2008,
+					&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_FP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 16);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.fp_off, -16);
+
+	/* At early ret (0x2011): CFA = rsp + 8, FP restored to SAME */
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x2011,
+					&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_SP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 8);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_SAME);
+
+	/* After restore_state (0x2020): back to CFA = rbp + 16, FP at cfa-16 */
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x2020,
+					&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_FP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 16);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.fp_off, -16);
+}
+
+static void test_cfi_drap_realigned_frame(struct kunit *test)
+{
+	/*
+	 * Simulate GCC x86-64 DRAP stack-realigned function (e.g. shrink_lruvec):
+	 *   0x2805: def_cfa r10, 0
+	 *   0x2810: DW_CFA_expression rbp(6), [DW_OP_breg6(0x76), 0]
+	 *   0x281a: DW_CFA_def_cfa_expression [DW_OP_breg6(0x76), -40(0x58), DW_OP_deref(0x06)]
+	 *           DW_CFA_expression r12(12), [DW_OP_breg6(0x76), -32(0x60)] (ignored)
+	 */
+	static const u8 insns[] = {
+		0x40 | 5,			/* advance 5 -> 0x2805 */
+		0x0c, 10, 0,			/* def_cfa r10(10), 0 */
+		0x40 | 11,			/* advance 11 -> 0x2810 */
+		0x10, 6, 2, 0x76, 0x00,		/* expression rbp: breg6 + 0 */
+		0x40 | 10,			/* advance 10 -> 0x281a */
+		0x0f, 3, 0x76, 0x58, 0x06,	/* def_cfa_expr: *(breg6 - 40) */
+		0x10, 12, 2, 0x76, 0x60,	/* expression r12: ignored */
+	};
+	struct test_eh_blob blob;
+	struct dwarf_cfi_row row;
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x2800, 0x40, insns, sizeof(insns));
+
+	/* Transient prologue at 0x2806: DWARF_CFI_BASE_REG (r10) */
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x2806,
+					&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_REG);
+	KUNIT_EXPECT_EQ(test, row.cfa_reg, 10);
+
+	/* Function body at 0x2820: CFA = *(rbp - 40), FP = *(rbp + 0) */
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x2820,
+					&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_FP_INDIRECT);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, -40);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_FP_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.fp_off, 0);
+}
+
+static void test_cfi_sigreturn_frame(struct kunit *test)
+{
+	/*
+	 * Matches glibc x86-64 __restore_rt ("zRS") FDE:
+	 *   DW_CFA_def_cfa_expression [DW_OP_breg7 + 160, DW_OP_deref]
+	 *   DW_CFA_expression r6 (rbp), [DW_OP_breg7 + 120]
+	 *   DW_CFA_expression r7 (rsp), [DW_OP_breg7 + 160]
+	 *   DW_CFA_expression r16 (rip), [DW_OP_breg7 + 168]
+	 */
+	static const u8 sig_insns[] = {
+		0x0f, 4, 0x77, 0xa0, 0x01, 0x06,
+		0x10, 6, 3, 0x77, 0xf8, 0x00,
+		0x10, 7, 3, 0x77, 0xa0, 0x01,
+		0x10, 16, 3, 0x77, 0xa8, 0x01,
+	};
+	struct test_eh_blob blob;
+	struct dwarf_cfi_row row;
+
+	build_test_eh_blob(&blob, "zRS", 0x04, 0x2c00, 0x10,
+			   sig_insns, sizeof(sig_insns));
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x2c01,
+					&test_x86_64_arch, &row));
+	KUNIT_EXPECT_TRUE(test, row.signal);
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_SP_INDIRECT);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 160);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_SP_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.fp_off, 120);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_SP_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.ra_off, 168);
+}
+
+static void test_cfi_arm64_pac_and_riscv_leaf(struct kunit *test)
+{
+	/*
+	 * AArch64 CIE: code_align=4, data_align=-8 (0x78), ra_reg=30,
+	 * initial: DW_CFA_def_cfa sp(31), 0 (RA starts as SAME in x30).
+	 * FDE at 0x4000..0x4020:
+	 *   +4  (0x4004): paciasp -> DW_CFA_AARCH64_negate_ra_state (0x2d)
+	 *   +8  (0x4008): stp x29,x30,[sp,#-32]! -> cfa=sp+32, x29@-32, x30@-24, x19@-16
+	 *   +24 (0x4018): ldp x29,x30,[sp],#32   -> restore x19/x29/x30, cfa=sp+0
+	 *   +28 (0x401c): autiasp -> DW_CFA_AARCH64_negate_ra_state (0x2d)
+	 */
+	static const u8 arm64_cie[] = { 0x0c, 31, 0 };
+	static const u8 arm64_fde[] = {
+		0x41, 0x2d,
+		0x41, 0x0e, 32, 0x80 | 29, 4, 0x80 | 30, 3, 0x80 | 19, 2,
+		0x44, 0xc0 | 19, 0xc0 | 29, 0xc0 | 30, 0x0e, 0,
+		0x41, 0x2d,
+	};
+	/*
+	 * RISC-V CIE: code_align=1, data_align=-4 (0x7c), ra_reg=1,
+	 * initial: DW_CFA_def_cfa sp(2), 0 (RA starts as SAME in x1/ra).
+	 * FDE at 0x5000..0x501a:
+	 *   +2 (0x5002): c.addi16sp -16 -> cfa=sp+16
+	 *   +6 (0x5006): sd s0, 0(sp); sd ra, 8(sp) -> s0(8)@-16, ra(1)@-8
+	 */
+	static const u8 rv_cie[] = { 0x0c, 2, 0 };
+	static const u8 rv_fde[] = {
+		0x42, 0x0e, 16,
+		0x44, 0x80 | 8, 4, 0x80 | 1, 2,
+	};
+	struct test_eh_blob blob;
+	struct dwarf_cfi_row row;
+
+	build_arch_eh_blob(&blob, &test_arm64_arch, /*code_align=*/4,
+			   /*data_align_sleb=*/0x78, "zR", /*fde_enc=*/0x04,
+			   arm64_cie, sizeof(arm64_cie), /*init_pc=*/0x4000,
+			   /*pc_range=*/0x20, arm64_fde, sizeof(arm64_fde));
+
+	/* Entry leaf state at 0x4000: CFA=sp+0, RA=SAME (unsigned) */
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x4000,
+					&test_arm64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_SP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 0);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_SAME);
+	KUNIT_EXPECT_FALSE(test, row.ra_signed);
+
+	/* Body at 0x400c: CFA=sp+32, FP@cfa-32, RA@cfa-24 (PAC-signed) */
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x400c,
+					&test_arm64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 32);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.fp_off, -32);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.ra_off, -24);
+	KUNIT_EXPECT_TRUE(test, row.ra_signed);
+
+	/* Epilogue after autiasp at 0x401c: CFA=sp+0, RA=SAME (unsigned) */
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x401c,
+					&test_arm64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 0);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_SAME);
+	KUNIT_EXPECT_FALSE(test, row.ra_signed);
+
+	/* DW_CFA_AARCH64_negate_ra_state (0x2d) must be rejected on x86_64 */
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x400c,
+					&test_x86_64_arch, &row));
+
+	/* RISC-V leaf + non-leaf prologue */
+	build_arch_eh_blob(&blob, &test_riscv64_arch, /*code_align=*/1,
+			   /*data_align_sleb=*/0x7c, "zR", /*fde_enc=*/0x04,
+			   rv_cie, sizeof(rv_cie), /*init_pc=*/0x5000,
+			   /*pc_range=*/0x1a, rv_fde, sizeof(rv_fde));
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x5000,
+					&test_riscv64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 0);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_SAME);
+
+	KUNIT_ASSERT_EQ(test, 0,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x5008,
+					&test_riscv64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 16);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.fp_off, -16);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.ra_off, -8);
+}
+
+static void test_cfi_security_rejections(struct kunit *test)
+{
+	/* 1. Arbitrary DW_CFA_def_cfa_expression must be rejected */
+	static const u8 expr_insns[] = { 0x0f, 0x01, 0x57 };
+	/* 2. Arbitrary DW_CFA_expression on RA (rip=16) must be rejected */
+	static const u8 ra_expr_insns[] = { 0x10, 16, 2, 0x76, 0x00 };
+	/* 3. Excessive remember_state nesting (> 4) must be rejected */
+	static const u8 deep_state_insns[] = { 0x0a, 0x0a, 0x0a, 0x0a, 0x0a };
+	/* 4. DW_CFA_set_loc must be rejected */
+	static const u8 set_loc_insns[] = { 0x01, 0, 0, 0, 0, 0, 0, 0, 0 };
+	/* 7. 5-byte SLEB128 outside s32 range (5th byte 0x08 / 0x77) must return -EOVERFLOW */
+	static const u8 sleb_pos_ovf[] = { 0x13, 0x80, 0x80, 0x80, 0x80, 0x08 };
+	static const u8 sleb_neg_ovf[] = { 0x13, 0x80, 0x80, 0x80, 0x80, 0x77 };
+	/* 8. DW_CFA_def_cfa_offset after indirect CFA expression must return -EINVAL */
+	static const u8 def_off_after_ind[] = { 0x0f, 3, 0x76, 0x58, 0x06, 0x0e, 16 };
+	struct test_eh_blob blob;
+	struct dwarf_cfi_row row;
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   expr_insns, sizeof(expr_insns));
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x3004,
+					&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   ra_expr_insns, sizeof(ra_expr_insns));
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x3004,
+					&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   deep_state_insns, sizeof(deep_state_insns));
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x3004,
+					&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   set_loc_insns, sizeof(set_loc_insns));
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x3004,
+					&test_x86_64_arch, &row));
+
+	/* 5. DW_EH_PE_indirect (0x80) in CIE 'R' encoding must be rejected */
+	build_test_eh_blob(&blob, "zR", /*fde_enc=*/0x80 | 0x04,
+			   /*init_pc=*/0x3000, /*pc_range=*/0x20,
+			   /*fde_insns=*/NULL, /*fde_insns_len=*/0);
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x3004,
+					&test_x86_64_arch, &row));
+
+	/* 6. Out-of-bounds FDE pointers (fde >= eh_end or fde < eh_start) must not underflow */
+	build_test_eh_blob(&blob, "zR", /*fde_enc=*/0x04, /*init_pc=*/0x3000,
+			   /*pc_range=*/0x20, /*fde_insns=*/NULL,
+			   /*fde_insns_len=*/0);
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.total_len + 64, blob.buf,
+					blob.buf + blob.total_len, 0x3004,
+					&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.total_len, blob.buf,
+					blob.buf + blob.total_len, 0x3004,
+					&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   sleb_pos_ovf, sizeof(sleb_pos_ovf));
+	KUNIT_EXPECT_EQ(test, -EOVERFLOW,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x3004,
+					&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   sleb_neg_ovf, sizeof(sleb_neg_ovf));
+	KUNIT_EXPECT_EQ(test, -EOVERFLOW,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x3004,
+					&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   def_off_after_ind, sizeof(def_off_after_ind));
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+		dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+					blob.buf + blob.total_len, 0x3004,
+					&test_x86_64_arch, &row));
+}
+
+struct live_walk_ctx {
+	unsigned long *entries;
+	unsigned int size;
+	unsigned long leaf_ip;
+	unsigned long realign_ip;
+	unsigned long mid_ip;
+	unsigned long caller_ip;
+};
+
+static noinline unsigned int unwind_test_leaf(struct live_walk_ctx *ctx)
+{
+	unsigned int nr;
+
+	nr = stack_trace_save(ctx->entries, ctx->size, /*skipnr=*/0);
+	ctx->leaf_ip = record_here_ip();
+	OPTIMIZER_HIDE_VAR(nr);
+	return nr;
+}
+
+static noinline unsigned int unwind_test_realigned(struct live_walk_ctx *ctx)
+{
+	/* Force dynamic stack realignment (DRAP) on 8-byte aligned kernel stack */
+	u8 __aligned(64) aligned_buf[64];
+	unsigned int nr;
+
+	aligned_buf[0] = (u8)ctx->size;
+	asm volatile("" : "+m"(aligned_buf) :: "memory");
+	nr = unwind_test_leaf(ctx);
+	ctx->realign_ip = record_here_ip();
+	OPTIMIZER_HIDE_VAR(nr);
+	return nr;
+}
+
+static noinline unsigned int unwind_test_mid(struct live_walk_ctx *ctx,
+					     int depth)
+{
+	unsigned long local_buf[4];
+	unsigned int nr;
+
+	local_buf[0] = depth;
+	asm volatile("" : "+m"(local_buf) :: "memory");
+	if (depth > 1)
+		nr = unwind_test_mid(ctx, depth - 1);
+	else
+		nr = unwind_test_realigned(ctx);
+	ctx->mid_ip = record_here_ip();
+	OPTIMIZER_HIDE_VAR(nr);
+	return nr;
+}
+
+static inline bool ip_within(unsigned long ip, unsigned long ref_ip)
+{
+	return ip + 256 >= ref_ip && ip <= ref_ip + 256;
+}
+
+static void test_live_kernel_stack_walk(struct kunit *test)
+{
+	unsigned long entries[32];
+	struct live_walk_ctx ctx = {
+		.entries = entries,
+		.size = ARRAY_SIZE(entries),
+	};
+	unsigned int nr, i;
+	int rel_nr;
+	bool saw_leaf = false, saw_realign = false, saw_mid = false, saw_caller = false;
+
+	nr = unwind_test_mid(&ctx, /*depth=*/3);
+	ctx.caller_ip = record_here_ip();
+	KUNIT_ASSERT_GT(test, nr, 4U);
+
+	for (i = 0; i < nr; i++) {
+		unsigned long sym_ip = entries[i];
+
+		if (ip_within(sym_ip, ctx.leaf_ip))
+			saw_leaf = true;
+		if (ip_within(sym_ip, ctx.realign_ip))
+			saw_realign = true;
+		if (ip_within(sym_ip, ctx.mid_ip))
+			saw_mid = true;
+		if (ip_within(sym_ip, ctx.caller_ip))
+			saw_caller = true;
+	}
+
+	KUNIT_EXPECT_TRUE(test, saw_leaf);
+	KUNIT_EXPECT_TRUE(test, saw_realign);
+	KUNIT_EXPECT_TRUE(test, saw_mid);
+	KUNIT_EXPECT_TRUE(test, saw_caller);
+
+	if (IS_ENABLED(CONFIG_HAVE_RELIABLE_STACKTRACE)) {
+		rel_nr = stack_trace_save_tsk_reliable(current, entries,
+						       ARRAY_SIZE(entries));
+		KUNIT_EXPECT_GT(test, rel_nr, 0);
+	}
+}
+
+static struct kunit_case dwarf_cfi_test_cases[] = {
+	KUNIT_CASE(test_cfi_sp_and_ignored_gprs),
+	KUNIT_CASE(test_cfi_fp_and_remember_restore),
+	KUNIT_CASE(test_cfi_drap_realigned_frame),
+	KUNIT_CASE(test_cfi_sigreturn_frame),
+	KUNIT_CASE(test_cfi_arm64_pac_and_riscv_leaf),
+	KUNIT_CASE(test_cfi_security_rejections),
+	KUNIT_CASE(test_live_kernel_stack_walk),
+	{}
+};
+
+static struct kunit_suite dwarf_cfi_test_suite = {
+	.name = "unwind_dwarf_cfi",
+	.test_cases = dwarf_cfi_test_cases,
+};
+
+kunit_test_suites(&dwarf_cfi_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for Minimal DWARF CFI unwinder");
+MODULE_LICENSE("GPL");
-- 
2.56.1.750.gf70dc682cf-goog

