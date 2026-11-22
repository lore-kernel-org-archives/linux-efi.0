Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795391929;
	b=BILYXHpG4cHCMUSR4ugyUGxU0qA+gz6zK33mOcXA89dsNoTrGVwZsUhOpHx0YXNyKMvh
	 zplqQq5htTh+JAegmO/9w32MMR4ummyUYRO9Tvz9SvDd4ihOWh5njxxiGwze2HIgTrWWH
	 HKo7t8fdV/Nu3F/sIrSY2zK0D+hL8Y697xeEkxQTvo7nsI/YaLi7olEgBAbCgZqtVPCCY
	 rc8NVMGjpwF7Sncf14SPqDMh7l6b/01zDwf00XBqWmRJYbn5VQXLR396WXLeuNBnZTWtT
	 LC33rG9WWy+bBRX6EWLqh+Zvy6jfRdksdXa3k0FWi1QHu0QP/dHxcdTyokuK6wwwEJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795391929;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=4mT2SQ+MNehWDiqnlnYwhVOekOJqOh8dA7p91MHzWoA=;
	b=rxN8pY4d5I5Hzf53q9ovNa3gy0ZXorPAqW45daBnTqG8/XdMqLQY/zYrJuACqnU64mAi
	 kp8SZpQmCifUOzgfc0OPkLhqbeUxCTzrD5jiBUdn7LAHtKcTOqM1UAynVcvpxCV2yOcmT
	 csK5UHnTEnHeTKHJdzmQh43xNWeWdh8C8nYmYGBYDehKcsYmuv+Lt9vHRiWqrAkUbEHZr
	 tW5/QVtTzKWbvFGAAdPqRMUM+tHRtXeGz/PFQ4TB2ApGVAgv/h6Yxo3ekV8GRgfMQyvZj
	 BO5MyfGzA55VxKNr+4qwHx+pQiKGOz87gM6f5JiuVkO46p3zjIq7UjJD2zLipeUVyGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="MYFXm/VW";
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A589A606A698
	for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 23:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A589A606A698
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MYFXm/VW
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-370230d93efso9007015eec.1
        for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 15:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795391927; x=1795996727; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4mT2SQ+MNehWDiqnlnYwhVOekOJqOh8dA7p91MHzWoA=;
        b=MYFXm/VWbeUhDkuo6k4TT/Ls/e4JI6F1hNY1IlojpFaNx8BvQzbEoFL0e1bNpMzZ+N
         43ehMMmDvzGLFy9Fkvt3Tmx+heb3Y29m5zAbgaKsVv8sF0YkSIX0NOQ1rHdeeoQBZl5n
         nZC243kNIxNiVOcgBHbUs1IVfrVjBbZxNFnvCiXZhawRJvmy9s32ZI9LlgVUFWXffEGw
         Di+HnZpHs6sFJwXLfc+5UDkHrasxT0ja5Vi0+qA9RiRuUkBAooRzu90Veq+hph7/eiQt
         Ay72piHQ6I8yNuMMnPFxLvyplh723mTitv+z5aEc9v5ckiVBOesXNMsHjiB3XqaKT3Jh
         xF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795391927; x=1795996727;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4mT2SQ+MNehWDiqnlnYwhVOekOJqOh8dA7p91MHzWoA=;
        b=0IA5Wazc2LRf1Nx1spLnbUhmd5spWA1fUnkrqwJXFYeCajcUndPvUUMX4G0C7R/E8Q
         L8hSw7uuiuZ7us1SBd6YFnJ2MKBYY9BULM8mdZi9yP4+q4IGpXbrRLjj9fy0zraN82ks
         P07VhPUyDbw6dKLxJr6xHHDKRvHGmCfhFKQUsb28q8WMA2NYgeE1RMK/UrXCYp+8zy+U
         g81/TifNqvo1ylsDZesYDFMRPsfnePdi67C/OU2lX+8jNmvqiReH1KSerbWorQz63okp
         Liz43gwuNQNmJbTcFRe37r/t9ZCDrFVRbD2IGQhit2bc7reGFyhVaX5APP44jlgB5lew
         CezQ==
X-Forwarded-Encrypted: i=1; AL+hErGQkuC61Qjt+AbgHqGtbCISD3CwS5Zmj/NN4oxHWxz9viajTxfcCPbhwhjMapd2FtUpzJLOFLfIW9A=@vger.kernel.org
X-Gm-Message-State: APuU4Z9sqzIq+Dd+hayFYFdqSFeGDb7itdFU/Nc2GKaPipB/7p3O98jZ
	N56Vrrqr/zcXx5MjYTZUmVh2RFVwnL/W7GB3YgqsfF2o8vAbgif2cu/yJrOmfdXcpk1r/mw3Nvr
	oEkp5bBgn0g==
X-Received: from dybut8.prod.google.com ([2002:a05:7301:e0c8:b0:36a:1f25:64f4])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:618f:20b0:386:ad3b:a48a
 with SMTP id 5a478bee46e88-386ad3ba7cfmr2073567eec.5.1795391926282; Sun, 22
 Nov 2026 15:58:46 -0800 (PST)
Date: Sun, 22 Nov 2026 15:57:48 -0800
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
Message-ID: <20261122235757.3456048-3-irogers@google.com>
Subject: [RFC PATCH v1 02/11] unwind_user: Support Minimal DWARF CFI
 user-space unwinding
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

Extend the generic user-space unwinder (kernel/unwind/user.c) with
UNWIND_USER_TYPE_CFI (CONFIG_HAVE_UNWIND_USER_CFI), resolving ELF
PT_GNU_EH_FRAME headers across executable VMAs in kernel/unwind/user_cfi.c
and enabling 64-bit and 32-bit compat user unwinding on x86.

Key design details:
 - Find the executable VMA and its base ELF mapping (vm_pgoff == 0)
   under mmap_read_lock_killable(), then drop mmap_read_lock() before
   issuing any faultable copy_from_user() reads.
 - Cache VMA -> PT_GNU_EH_FRAME lookups (including negative lookups for
   anonymous/JIT VMAs so unwind_user_next() falls back per frame to FP)
   in a 4-slot per-walk cache on struct unwind_user_state.
 - Fence non-masked access_ok() checks in get_user_word() with
   barrier_nospec() so chained cfa_indirect user stack loads cannot
   speculatively dereference kernel addresses on architectures without
   branchless uaccess pointer masking.
 - Provide overridable unwind_user_frame_pointer() and
   unwind_user_sigreturn() hooks alongside unwind_user_link_register()
   and unwind_user_strip_pac(), and allow up to UNWIND_USER_MAX_SIGNALS
   signal frames per walk to switch stacks (supporting SA_ONSTACK
   alternate signal stacks and signal trampolines without leading NOPs).
 - Support link-register leaf frames (ra_from_reg when state->ra_valid
   is true, clearing ra_valid after the first step so subsequent frames
   enforce strict cfa > sp progression), DRAP/sigframe indirect CFA
   rules, and clean bottom-of-stack termination on DW_CFA_undefined or
   zero RA.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/Kconfig                       |   5 +
 arch/x86/Kconfig                   |   1 +
 arch/x86/include/asm/unwind_user.h |  47 ++++
 include/linux/unwind_user.h        |  78 ++++++
 include/linux/unwind_user_types.h  |  92 ++++++-
 kernel/unwind/Makefile             |   1 +
 kernel/unwind/user.c               | 155 +++++++++++-
 kernel/unwind/user_cfi.c           | 378 +++++++++++++++++++++++++++++
 8 files changed, 740 insertions(+), 17 deletions(-)
 create mode 100644 kernel/unwind/user_cfi.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 03399120aa8f..340a7ecbfc68 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -523,6 +523,11 @@ config HAVE_UNWIND_USER_FP
 	bool
 	select UNWIND_USER
 
+config HAVE_UNWIND_USER_CFI
+	bool
+	select UNWIND_USER
+	select UNWIND_DWARF_CFI
+
 config HAVE_PERF_REGS
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58dce0b66179..c8096cf66c38 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -300,6 +300,7 @@ config X86
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UACCESS_VALIDATION		if HAVE_OBJTOOL
 	select HAVE_UNSTABLE_SCHED_CLOCK
+	select HAVE_UNWIND_USER_CFI		if X86_64
 	select HAVE_UNWIND_USER_FP		if X86_64
 	select HAVE_USER_RETURN_NOTIFIER
 	select VDSO_GETRANDOM			if X86_64
diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index 6e469044e4de..1a6be08968c3 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -4,9 +4,17 @@
 
 #ifdef CONFIG_UNWIND_USER
 
+#include <linux/unwind_dwarf_cfi.h>
 #include <asm/ptrace.h>
 #include <asm/uprobes.h>
 
+/**
+ * unwind_user_word_size() - Return the user-space word size in bytes on x86
+ * @regs: User-mode register state.
+ *
+ * Return: 8 for 64-bit user mode, 4 for 32-bit IA-32/compat mode, or 0 for
+ * VM86 mode stacks which cannot be unwound.
+ */
 static inline int unwind_user_word_size(struct pt_regs *regs)
 {
 	/* We can't unwind VM86 stacks */
@@ -15,22 +23,61 @@ static inline int unwind_user_word_size(struct pt_regs *regs)
 	return user_64bit_mode(regs) ? 8 : 4;
 }
 
+/**
+ * unwind_user_cfi_arch() - Populate x86/x86-64 DWARF register numbers
+ * @ws: User word size in bytes (8 for x86-64, 4 for i386).
+ * @arch: Output DWARF CFI architecture descriptor.
+ *
+ * Return: true if @ws is 4 or 8, false otherwise.
+ */
+static inline bool unwind_user_cfi_arch(unsigned int ws,
+					struct dwarf_cfi_arch *arch)
+{
+	if (ws == 8) {
+		*arch = (struct dwarf_cfi_arch){
+			.ws	= 8,
+			.sp_reg	= 7,	/* %rsp */
+			.fp_reg	= 6,	/* %rbp */
+			.ra_reg	= 16,	/* %rip */
+		};
+		return true;
+	}
+	if (ws == 4) {
+		*arch = (struct dwarf_cfi_arch){
+			.ws	= 4,
+			.sp_reg	= 4,	/* %esp */
+			.fp_reg	= 5,	/* %ebp */
+			.ra_reg	= 8,	/* %eip */
+		};
+		return true;
+	}
+	return false;
+}
+
 #endif /* CONFIG_UNWIND_USER */
 
 #ifdef CONFIG_HAVE_UNWIND_USER_FP
 
+/* Standard x86 frame record: {saved_bp, ret_addr} at [bp, bp + 2 * ws). */
 #define ARCH_INIT_USER_FP_FRAME(ws)			\
 	.cfa_off	=  2*(ws),			\
 	.ra_off		= -1*(ws),			\
 	.fp_off		= -2*(ws),			\
 	.use_fp		= true,
 
+/* At function entry before push %rbp: return address is at [sp, sp + ws). */
 #define ARCH_INIT_USER_FP_ENTRY_FRAME(ws)		\
 	.cfa_off	=  1*(ws),			\
 	.ra_off		= -1*(ws),			\
 	.fp_off		= 0,				\
 	.use_fp		= false,
 
+/**
+ * unwind_user_at_function_start() - Check if @regs is at a function entry point
+ * @regs: User-mode register state.
+ *
+ * Return: true if stopped on an entry uprobe before the frame prologue ran.
+ */
 static inline bool unwind_user_at_function_start(struct pt_regs *regs)
 {
 	return is_uprobe_at_func_entry(regs);
diff --git a/include/linux/unwind_user.h b/include/linux/unwind_user.h
index 64618618febd..dcd87012ab82 100644
--- a/include/linux/unwind_user.h
+++ b/include/linux/unwind_user.h
@@ -16,6 +16,12 @@
 #endif
 
 #ifndef unwind_user_at_function_start
+/**
+ * unwind_user_at_function_start() - Default stub for function-entry detection
+ * @regs: User-mode register state.
+ *
+ * Return: false when the architecture does not override entry detection.
+ */
 static inline bool unwind_user_at_function_start(struct pt_regs *regs)
 {
 	return false;
@@ -23,6 +29,78 @@ static inline bool unwind_user_at_function_start(struct pt_regs *regs)
 #define unwind_user_at_function_start unwind_user_at_function_start
 #endif
 
+#ifndef unwind_user_frame_pointer
+/**
+ * unwind_user_frame_pointer() - Default helper returning @regs's frame pointer
+ * @regs: User-mode register state.
+ *
+ * Return: Architectural user frame pointer from frame_pointer(@regs).
+ */
+static inline unsigned long unwind_user_frame_pointer(struct pt_regs *regs)
+{
+	return frame_pointer(regs);
+}
+#define unwind_user_frame_pointer unwind_user_frame_pointer
+#endif
+
+#ifndef unwind_user_link_register
+/**
+ * unwind_user_link_register() - Default stub for architectures without an LR
+ * @regs: User-mode register state.
+ * @ra: Unused output link register pointer.
+ *
+ * Return: false on architectures where calls push the return address on stack.
+ */
+static inline bool unwind_user_link_register(struct pt_regs *regs,
+					     unsigned long *ra)
+{
+	return false;
+}
+#define unwind_user_link_register unwind_user_link_register
+#endif
+
+#ifndef unwind_user_strip_pac
+/**
+ * unwind_user_strip_pac() - Default no-op PAC stripping helper
+ * @ip: Recovered user instruction pointer.
+ * @ra_signed: Whether CFI marked the return address as PAC-signed.
+ *
+ * Return: @ip unchanged on architectures without pointer authentication.
+ */
+static inline unsigned long unwind_user_strip_pac(unsigned long ip,
+						  bool ra_signed)
+{
+	return ip;
+}
+#define unwind_user_strip_pac unwind_user_strip_pac
+#endif
+
+#ifndef unwind_user_sigreturn
+/**
+ * unwind_user_sigreturn() - Default stub for arch signal-trampoline unwinding
+ * @state: Current user unwind state.
+ *
+ * Return: false on architectures whose signal trampolines unwind via CFI/FP.
+ */
+static inline bool unwind_user_sigreturn(struct unwind_user_state *state)
+{
+	return false;
+}
+#define unwind_user_sigreturn unwind_user_sigreturn
+#endif
+
+#ifdef CONFIG_HAVE_UNWIND_USER_CFI
+int unwind_user_next_cfi(struct unwind_user_state *state,
+			 struct unwind_user_frame *out_frame, bool *out_signal);
+#else
+static inline int unwind_user_next_cfi(struct unwind_user_state *state,
+				       struct unwind_user_frame *out_frame,
+				       bool *out_signal)
+{
+	return -EINVAL;
+}
+#endif
+
 int unwind_user(struct unwind_stacktrace *trace, unsigned int max_entries);
 
 #endif /* _LINUX_UNWIND_USER_H */
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 412729a269bc..9d00315dbbb9 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -4,41 +4,123 @@
 
 #include <linux/types.h>
 
-/*
- * Unwind types, listed in priority order: lower numbers are attempted first if
- * available.
+/**
+ * enum unwind_user_type_bits - Priority bit indices for user-space unwinders
+ * @UNWIND_USER_TYPE_CFI_BIT: Bit index for Minimal DWARF CFI (.eh_frame_hdr).
+ * @UNWIND_USER_TYPE_FP_BIT: Bit index for architectural frame-pointer chains.
+ * @NR_UNWIND_USER_TYPE_BITS: Total number of user-space unwind method bits.
+ *
+ * Listed in priority order: lower bit indices are attempted first on each
+ * frame when enabled in &unwind_user_state.available_types.
  */
 enum unwind_user_type_bits {
-	UNWIND_USER_TYPE_FP_BIT =		0,
+	UNWIND_USER_TYPE_CFI_BIT =		0,
+	UNWIND_USER_TYPE_FP_BIT =		1,
 
 	NR_UNWIND_USER_TYPE_BITS,
 };
 
+/**
+ * enum unwind_user_type - Bitmask values identifying a user-space unwind method
+ * @UNWIND_USER_TYPE_NONE: No active unwind method (initial or terminal state).
+ * @UNWIND_USER_TYPE_CFI: Unwind using Minimal DWARF CFI via PT_GNU_EH_FRAME.
+ * @UNWIND_USER_TYPE_FP: Unwind using architectural frame-pointer records.
+ */
 enum unwind_user_type {
-	/* Type "none" for the start of stack walk iteration. */
 	UNWIND_USER_TYPE_NONE =			0,
+	UNWIND_USER_TYPE_CFI =			BIT(UNWIND_USER_TYPE_CFI_BIT),
 	UNWIND_USER_TYPE_FP =			BIT(UNWIND_USER_TYPE_FP_BIT),
 };
 
+/**
+ * struct unwind_stacktrace - Captured user-space callchain buffer
+ * @nr: Number of instruction pointers stored in @entries.
+ * @entries: Caller-allocated array of user instruction pointers.
+ */
 struct unwind_stacktrace {
 	unsigned int	nr;
 	unsigned long	*entries;
 };
 
+/**
+ * struct unwind_user_frame - Evaluated unwind rule for stepping one user frame
+ * @cfa_off: Byte offset added to FP (when @use_fp is true) or SP to form CFA.
+ * @ra_off: Byte offset from CFA (or SP when @ra_from_sp is true) to saved RA.
+ * @fp_off: Byte offset from CFA, FP, or SP to saved caller FP (0 if unchanged,
+ *          unless @fp_from_fp or @fp_from_sp is set).
+ * @use_fp: True if the CFA base register is FP rather than SP.
+ * @cfa_indirect: True if the computed CFA address must be dereferenced once in
+ *                user memory (DRAP or signal trampoline frame).
+ * @fp_from_fp: True if saved FP is located at *(state->fp + @fp_off).
+ * @fp_from_sp: True if saved FP is located at *(old_sp + @fp_off).
+ * @ra_from_sp: True if saved RA is located at *(old_sp + @ra_off).
+ * @ra_from_reg: True if RA is still in @state->ra rather than on the stack.
+ * @ra_signed: True if the recovered RA carries an AArch64 PAC signature.
+ */
 struct unwind_user_frame {
 	s32 cfa_off;
 	s32 ra_off;
 	s32 fp_off;
 	bool use_fp;
+	bool cfa_indirect;
+	bool fp_from_fp;
+	bool fp_from_sp;
+	bool ra_from_sp;
+	bool ra_from_reg;
+	bool ra_signed;
+};
+
+/**
+ * struct unwind_user_cfi_cache - Per-walk cache entry mapping a VMA to EH_FRAME
+ * @vma_start: Start virtual address of the cached executable VMA.
+ * @vma_end: End virtual address (exclusive) of the cached executable VMA.
+ * @eh_hdr_uaddr: User virtual address of PT_GNU_EH_FRAME (0 for negative cache
+ *                entries when an executable VMA has no PT_GNU_EH_FRAME).
+ * @eh_hdr_size: Size in bytes of the PT_GNU_EH_FRAME segment.
+ * @valid: True if this cache slot holds a populated entry.
+ */
+struct unwind_user_cfi_cache {
+	unsigned long	vma_start;
+	unsigned long	vma_end;
+	unsigned long	eh_hdr_uaddr;
+	size_t		eh_hdr_size;
+	bool		valid;
 };
 
+#define UNWIND_USER_MAX_SIGNALS	4U
+
+/**
+ * struct unwind_user_state - Iteration state for a user-space stack walk
+ * @ip: Current frame's user instruction pointer.
+ * @sp: Current frame's user stack pointer.
+ * @fp: Current frame's user frame pointer.
+ * @ra: Link register value for leaf/topmost frames when @ra_valid is true.
+ * @ws: User word size in bytes (4 for compat 32-bit tasks, 8 for 64-bit tasks).
+ * @current_type: Unwind method used for the current step.
+ * @available_types: Bitmask of &enum unwind_user_type methods available.
+ * @cfi_cache_next: Round-robin replacement cursor into @cfi_cache.
+ * @cfi_cache: Small per-walk cache of executable VMA PT_GNU_EH_FRAME lookups.
+ * @nr_signals: Number of signal frames unwound so far during this walk.
+ * @ra_valid: True if @ra holds a live link register value for this frame.
+ * @signal: True if the current frame was entered from a signal trampoline, so
+ *          @ip points directly at the interrupted instruction rather than
+ *          immediately after a call instruction.
+ * @topmost: True when unwinding the innermost interrupted user frame.
+ * @done: True once the stack walk has reached the bottom or terminated.
+ */
 struct unwind_user_state {
 	unsigned long				ip;
 	unsigned long				sp;
 	unsigned long				fp;
+	unsigned long				ra;
 	unsigned int				ws;
 	enum unwind_user_type			current_type;
 	unsigned int				available_types;
+	unsigned int				cfi_cache_next;
+	struct unwind_user_cfi_cache		cfi_cache[4];
+	unsigned int				nr_signals;
+	bool					ra_valid;
+	bool					signal;
 	bool					topmost;
 	bool					done;
 };
diff --git a/kernel/unwind/Makefile b/kernel/unwind/Makefile
index 73a1ccc2ad77..954083868790 100644
--- a/kernel/unwind/Makefile
+++ b/kernel/unwind/Makefile
@@ -9,4 +9,5 @@ KCOV_INSTRUMENT_dwarf_cfi.o := n
 
 obj-$(CONFIG_UNWIND_DWARF_CFI)		+= dwarf_cfi.o
 obj-$(CONFIG_UNWIND_USER)		+= user.o deferred.o
+obj-$(CONFIG_HAVE_UNWIND_USER_CFI)	+= user_cfi.o
 obj-$(CONFIG_UNWIND_DWARF_CFI_KUNIT_TEST) += dwarf_cfi_kunit.o
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 90ab3c1a205e..1f1cb6c83cf0 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
-* Generic interfaces for unwinding user space
-*/
+ * Generic interfaces for unwinding user space.
+ */
 #include <linux/kernel.h>
+#include <linux/nospec.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/unwind_user.h>
@@ -11,14 +12,38 @@
 #define for_each_user_frame(state) \
 	for (unwind_user_start(state); !(state)->done; unwind_user_next(state))
 
+/**
+ * get_user_word() - Read a native or compat-sized word from the user stack
+ * @word: Output zero-extended word value.
+ * @base: Base user virtual address.
+ * @off: Signed byte offset from @base.
+ * @ws: Word size in bytes (4 for compat 32-bit tasks, sizeof(long) otherwise).
+ *
+ * Return: 0 on success, or -EFAULT if the user memory access faults.
+ */
 static inline int
 get_user_word(unsigned long *word, unsigned long base, int off, unsigned int ws)
 {
 	unsigned long __user *addr = (void __user *)base + off;
+
+	/*
+	 * On architectures whose get_user() uses a conditional access_ok()
+	 * branch rather than branchless address masking, fence bad access_ok()
+	 * speculation so chained cfa_indirect stack reads cannot transiently
+	 * dereference kernel addresses.
+	 */
+	if (!can_do_masked_user_access()) {
+		if (!access_ok(addr, ws)) {
+			*word = 0;
+			return -EFAULT;
+		}
+		barrier_nospec();
+	}
 #ifdef CONFIG_COMPAT
 	if (ws == sizeof(int)) {
 		unsigned int data;
 		int ret = get_user(data, (unsigned int __user *)addr);
+
 		*word = data;
 		return ret;
 	}
@@ -26,45 +51,97 @@ get_user_word(unsigned long *word, unsigned long base, int off, unsigned int ws)
 	return get_user(*word, addr);
 }
 
+/**
+ * unwind_user_next_common() - Apply an evaluated &struct unwind_user_frame rule
+ * @state: Current user unwind state to advance to the caller frame.
+ * @frame: Frame CFA, RA, and FP recovery rule.
+ * @signal: True if @frame unwinds a signal trampoline (allowing bounded stack
+ *          switching across alternate signal stacks).
+ *
+ * Computes the caller's CFA, validates alignment and monotonic stack progress,
+ * reads and strips PAC bits from the return address, optionally recovers the
+ * saved frame pointer, and updates @state.
+ *
+ * Return: 0 on success, -ENOENT if the recovered return address is 0 (marking
+ * @state->done), or -EINVAL on invalid alignment, stack regression, or fault.
+ */
 static int unwind_user_next_common(struct unwind_user_state *state,
-				   const struct unwind_user_frame *frame)
+				   const struct unwind_user_frame *frame,
+				   bool signal)
 {
+	unsigned long old_sp = state->sp;
 	unsigned long cfa, fp, ra;
 
+	if (signal && state->nr_signals >= UNWIND_USER_MAX_SIGNALS)
+		return -EINVAL;
+
 	/* Get the Canonical Frame Address (CFA) */
 	if (frame->use_fp) {
-		if (state->fp < state->sp)
+		if (!signal && state->fp < state->sp)
 			return -EINVAL;
 		cfa = state->fp;
 	} else {
 		cfa = state->sp;
 	}
 	cfa += frame->cfa_off;
+	if (frame->cfa_indirect && get_user_word(&cfa, cfa, /*off=*/0, state->ws))
+		return -EINVAL;
 
 	/* Make sure that stack is not going in wrong direction */
-	if (cfa <= state->sp)
+	if (frame->ra_from_reg) {
+		if (!state->ra_valid || (!signal && cfa < state->sp))
+			return -EINVAL;
+	} else if (!signal && cfa <= state->sp) {
 		return -EINVAL;
+	}
 
 	/* Make sure that the address is word aligned */
 	if (cfa & (state->ws - 1))
 		return -EINVAL;
 
 	/* Get the Return Address (RA) */
-	if (get_user_word(&ra, cfa, frame->ra_off, state->ws))
+	if (frame->ra_from_reg) {
+		ra = state->ra;
+	} else if (get_user_word(&ra, frame->ra_from_sp ? old_sp : cfa,
+				 frame->ra_off, state->ws)) {
 		return -EINVAL;
+	}
+	ra = unwind_user_strip_pac(ra, frame->ra_signed);
+	if (!ra) {
+		state->done = true;
+		return -ENOENT;
+	}
 
 	/* Get the Frame Pointer (FP) */
-	if (frame->fp_off && get_user_word(&fp, cfa, frame->fp_off, state->ws))
-		return -EINVAL;
+	if (frame->fp_from_fp) {
+		if (get_user_word(&fp, state->fp, frame->fp_off, state->ws))
+			return -EINVAL;
+	} else if (frame->fp_from_sp) {
+		if (get_user_word(&fp, old_sp, frame->fp_off, state->ws))
+			return -EINVAL;
+	} else if (frame->fp_off) {
+		if (get_user_word(&fp, cfa, frame->fp_off, state->ws))
+			return -EINVAL;
+	}
 
 	state->ip = ra;
 	state->sp = cfa;
-	if (frame->fp_off)
+	if (frame->fp_from_fp || frame->fp_from_sp || frame->fp_off)
 		state->fp = fp;
+	if (signal)
+		state->nr_signals++;
+	state->signal = signal;
+	state->ra_valid = false;
 	state->topmost = false;
 	return 0;
 }
 
+/**
+ * unwind_user_next_fp() - Step one user frame using architectural frame records
+ * @state: Current user unwind state.
+ *
+ * Return: 0 on success, or a negative errno from unwind_user_next_common().
+ */
 static int unwind_user_next_fp(struct unwind_user_state *state)
 {
 	struct pt_regs *regs = task_pt_regs(current);
@@ -73,15 +150,28 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 		const struct unwind_user_frame fp_entry_frame = {
 			ARCH_INIT_USER_FP_ENTRY_FRAME(state->ws)
 		};
-		return unwind_user_next_common(state, &fp_entry_frame);
+		return unwind_user_next_common(state, &fp_entry_frame,
+					       /*signal=*/false);
 	}
 
 	const struct unwind_user_frame fp_frame = {
 		ARCH_INIT_USER_FP_FRAME(state->ws)
 	};
-	return unwind_user_next_common(state, &fp_frame);
+	return unwind_user_next_common(state, &fp_frame, /*signal=*/false);
 }
 
+/**
+ * unwind_user_next() - Advance @state to the next outer user-space stack frame
+ * @state: Current user unwind state.
+ *
+ * Checks architectural signal-trampoline unwinding first, then attempts each
+ * enabled method in @state->available_types in priority order (Minimal DWARF
+ * CFI first, falling back per frame to frame pointers when an executable
+ * mapping such as JIT code lacks .eh_frame_hdr).
+ *
+ * Return: 0 on success, or -EINVAL when no unwind method succeeds or the walk
+ * has reached the bottom of the stack (setting @state->done).
+ */
 static int unwind_user_next(struct unwind_user_state *state)
 {
 	unsigned long iter_mask = state->available_types;
@@ -90,11 +180,28 @@ static int unwind_user_next(struct unwind_user_state *state)
 	if (state->done)
 		return -EINVAL;
 
+	if (state->nr_signals < UNWIND_USER_MAX_SIGNALS &&
+	    unwind_user_sigreturn(state)) {
+		state->nr_signals++;
+		return 0;
+	}
+
 	for_each_set_bit(bit, &iter_mask, NR_UNWIND_USER_TYPE_BITS) {
 		enum unwind_user_type type = BIT(bit);
 
 		state->current_type = type;
 		switch (type) {
+		case UNWIND_USER_TYPE_CFI: {
+			struct unwind_user_frame frame;
+			bool signal = false;
+
+			if (!unwind_user_next_cfi(state, &frame, &signal) &&
+			    !unwind_user_next_common(state, &frame, signal))
+				return 0;
+			if (state->done)
+				break;
+			continue;
+		}
 		case UNWIND_USER_TYPE_FP:
 			if (!unwind_user_next_fp(state))
 				return 0;
@@ -112,6 +219,16 @@ static int unwind_user_next(struct unwind_user_state *state)
 	return -EINVAL;
 }
 
+/**
+ * unwind_user_start() - Initialize user-space stack unwinding from current task
+ * @state: Unwind state structure to initialize.
+ *
+ * Populates @state from task_pt_regs(current) if the current task is a user
+ * task with valid user-mode registers.
+ *
+ * Return: 0 on success, or -EINVAL if current is a kernel thread, not in user
+ * mode, or running in an unsupported execution mode (e.g. x86 VM86).
+ */
 static int unwind_user_start(struct unwind_user_state *state)
 {
 	struct pt_regs *regs = task_pt_regs(current);
@@ -123,12 +240,15 @@ static int unwind_user_start(struct unwind_user_state *state)
 		return -EINVAL;
 	}
 
+	if (IS_ENABLED(CONFIG_HAVE_UNWIND_USER_CFI))
+		state->available_types |= UNWIND_USER_TYPE_CFI;
 	if (IS_ENABLED(CONFIG_HAVE_UNWIND_USER_FP))
 		state->available_types |= UNWIND_USER_TYPE_FP;
 
 	state->ip = instruction_pointer(regs);
 	state->sp = user_stack_pointer(regs);
-	state->fp = frame_pointer(regs);
+	state->fp = unwind_user_frame_pointer(regs);
+	state->ra_valid = unwind_user_link_register(regs, &state->ra);
 	state->ws = unwind_user_word_size(regs);
 	if (!state->ws) {
 		state->done = true;
@@ -139,6 +259,17 @@ static int unwind_user_start(struct unwind_user_state *state)
 	return 0;
 }
 
+/**
+ * unwind_user() - Capture a user-space stack trace for the current task
+ * @trace: Output stack trace descriptor with caller-allocated @trace->entries.
+ * @max_entries: Maximum number of instruction pointers to store in @trace.
+ *
+ * Must be called in sleepable task context (e.g. syscall return / task_work
+ * deferred unwinding) because user stack and ELF .eh_frame_hdr reads may fault.
+ *
+ * Return: 0 on success (including 0 entries for kernel threads), or -EINVAL if
+ * @max_entries is 0.
+ */
 int unwind_user(struct unwind_stacktrace *trace, unsigned int max_entries)
 {
 	struct unwind_user_state state;
diff --git a/kernel/unwind/user_cfi.c b/kernel/unwind/user_cfi.c
new file mode 100644
index 000000000000..f3abd58eacd3
--- /dev/null
+++ b/kernel/unwind/user_cfi.c
@@ -0,0 +1,378 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * User-space Minimal DWARF CFI unwinding via ELF PT_GNU_EH_FRAME.
+ */
+
+#include <linux/elf.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/mmap_lock.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/unwind_dwarf_cfi.h>
+#include <linux/unwind_user.h>
+
+#define USER_CFI_MAX_PHDRS	64U
+#define USER_CFI_MAX_VMA_STEPS	8U
+
+/**
+ * parse_user_elf64_eh_hdr() - Locate PT_GNU_EH_FRAME in a 64-bit user ELF image
+ * @elf_base: User virtual address of the mapped ELF64 header (file offset 0).
+ * @hdr_uaddr: Output user virtual address of the PT_GNU_EH_FRAME segment.
+ * @hdr_size: Output size in bytes of the PT_GNU_EH_FRAME segment.
+ *
+ * Reads the 64-bit ELF header and up to %USER_CFI_MAX_PHDRS program headers
+ * from user memory, computes the mapping load bias from the file-offset-0
+ * PT_LOAD segment, and resolves the runtime address of PT_GNU_EH_FRAME.
+ * Must be called without holding mmap_lock because copy_from_user() may fault.
+ *
+ * Return: 0 on success, -ENOENT if no non-empty PT_GNU_EH_FRAME or base
+ * PT_LOAD segment exists, -EINVAL if the ELF header is invalid, or -EFAULT on
+ * an unmapped user read.
+ */
+static int parse_user_elf64_eh_hdr(unsigned long elf_base,
+				   unsigned long *hdr_uaddr, size_t *hdr_size)
+{
+	Elf64_Ehdr ehdr;
+	unsigned long load_bias = 0;
+	bool have_load0 = false, have_eh = false;
+	Elf64_Addr eh_vaddr = 0;
+	Elf64_Xword eh_memsz = 0;
+	unsigned int i;
+
+	if (copy_from_user(&ehdr, (const void __user *)elf_base, sizeof(ehdr)))
+		return -EFAULT;
+
+	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
+	    ehdr.e_ident[EI_CLASS] != ELFCLASS64 ||
+	    ehdr.e_phentsize != sizeof(Elf64_Phdr) ||
+	    !ehdr.e_phnum || ehdr.e_phnum > USER_CFI_MAX_PHDRS)
+		return -EINVAL;
+
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		Elf64_Phdr phdr;
+		unsigned long p_addr = elf_base + ehdr.e_phoff +
+				       (size_t)i * sizeof(phdr);
+
+		if (copy_from_user(&phdr, (const void __user *)p_addr, sizeof(phdr)))
+			return -EFAULT;
+
+		if (phdr.p_type == PT_LOAD && !have_load0 && phdr.p_offset == 0) {
+			load_bias = elf_base - ALIGN_DOWN(phdr.p_vaddr, PAGE_SIZE);
+			have_load0 = true;
+		} else if (phdr.p_type == PT_GNU_EH_FRAME) {
+			eh_vaddr = phdr.p_vaddr;
+			eh_memsz = phdr.p_memsz;
+			have_eh = true;
+		}
+	}
+
+	if (!have_load0 || !have_eh || !eh_memsz)
+		return -ENOENT;
+
+	*hdr_uaddr = load_bias + eh_vaddr;
+	*hdr_size = (size_t)eh_memsz;
+	return 0;
+}
+
+/**
+ * parse_user_elf32_eh_hdr() - Locate PT_GNU_EH_FRAME in a 32-bit user ELF image
+ * @elf_base: User virtual address of the mapped ELF32 header (file offset 0).
+ * @hdr_uaddr: Output user virtual address of the PT_GNU_EH_FRAME segment.
+ * @hdr_size: Output size in bytes of the PT_GNU_EH_FRAME segment.
+ *
+ * 32-bit compat counterpart to parse_user_elf64_eh_hdr(). Must be called
+ * without holding mmap_lock.
+ *
+ * Return: 0 on success, -ENOENT if no non-empty PT_GNU_EH_FRAME or base
+ * PT_LOAD segment exists, -EINVAL if the ELF header is invalid, or -EFAULT on
+ * an unmapped user read.
+ */
+static int parse_user_elf32_eh_hdr(unsigned long elf_base,
+				   unsigned long *hdr_uaddr, size_t *hdr_size)
+{
+	Elf32_Ehdr ehdr;
+	unsigned long load_bias = 0;
+	bool have_load0 = false, have_eh = false;
+	Elf32_Addr eh_vaddr = 0;
+	Elf32_Word eh_memsz = 0;
+	unsigned int i;
+
+	if (copy_from_user(&ehdr, (const void __user *)elf_base, sizeof(ehdr)))
+		return -EFAULT;
+
+	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
+	    ehdr.e_ident[EI_CLASS] != ELFCLASS32 ||
+	    ehdr.e_phentsize != sizeof(Elf32_Phdr) ||
+	    !ehdr.e_phnum || ehdr.e_phnum > USER_CFI_MAX_PHDRS)
+		return -EINVAL;
+
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		Elf32_Phdr phdr;
+		unsigned long p_addr = elf_base + ehdr.e_phoff +
+				       (size_t)i * sizeof(phdr);
+
+		if (copy_from_user(&phdr, (const void __user *)p_addr, sizeof(phdr)))
+			return -EFAULT;
+
+		if (phdr.p_type == PT_LOAD && !have_load0 && phdr.p_offset == 0) {
+			load_bias = elf_base - ALIGN_DOWN((unsigned long)phdr.p_vaddr,
+							  PAGE_SIZE);
+			have_load0 = true;
+		} else if (phdr.p_type == PT_GNU_EH_FRAME) {
+			eh_vaddr = phdr.p_vaddr;
+			eh_memsz = phdr.p_memsz;
+			have_eh = true;
+		}
+	}
+
+	if (!have_load0 || !have_eh || !eh_memsz)
+		return -ENOENT;
+
+	*hdr_uaddr = load_bias + eh_vaddr;
+	*hdr_size = (size_t)eh_memsz;
+	return 0;
+}
+
+/**
+ * lookup_vma_elf_base_locked() - Find the ELF base mapping for an executable IP
+ * @mm: Address space of the current user task (mmap_lock held for read).
+ * @ip: User instruction pointer to resolve.
+ * @vma_start: Output start address of the executable VMA containing @ip.
+ * @vma_end: Output end address of the executable VMA containing @ip (left
+ *           unchanged if @ip does not lie in an executable VMA).
+ * @elf_base: Output start address of the file-offset-0 ELF header mapping.
+ *
+ * Modern linkers (-z separate-code) often place the ELF header in a preceding
+ * read-only VMA at vm_pgoff == 0 while mapping .text into a separate VM_EXEC
+ * VMA with vm_pgoff > 0. Walk up to %USER_CFI_MAX_VMA_STEPS preceding VMAs
+ * backed by the same file to locate the vm_pgoff == 0 mapping, while also
+ * supporting single-VMA binaries and special mappings such as [vdso].
+ *
+ * Return: true if an ELF base mapping was found and stored in *@elf_base,
+ * false otherwise.
+ */
+static bool lookup_vma_elf_base_locked(struct mm_struct *mm, unsigned long ip,
+				       unsigned long *vma_start,
+				       unsigned long *vma_end,
+				       unsigned long *elf_base)
+{
+	struct vm_area_struct *vma = vma_lookup(mm, ip);
+	struct vm_area_struct *prev;
+	struct file *target_file;
+	unsigned int steps = 0;
+
+	if (!vma || !(vma->vm_flags & VM_EXEC))
+		return false;
+
+	*vma_start = vma->vm_start;
+	*vma_end = vma->vm_end;
+
+	if (vma_is_anonymous(vma) || !vma->vm_file) {
+		if (vma->vm_pgoff == 0) {
+			/* Special mappings such as [vdso] */
+			*elf_base = vma->vm_start;
+			return true;
+		}
+		return false;
+	}
+
+	if (vma->vm_pgoff == 0) {
+		*elf_base = vma->vm_start;
+		return true;
+	}
+
+	target_file = vma->vm_file;
+	{
+		VMA_ITERATOR(vmi, mm, vma->vm_start);
+
+		while (steps++ < USER_CFI_MAX_VMA_STEPS &&
+		       (prev = vma_prev(&vmi)) != NULL) {
+			if (vma_is_anonymous(prev) || prev->vm_file != target_file)
+				break;
+			if (prev->vm_pgoff == 0) {
+				*elf_base = prev->vm_start;
+				return true;
+			}
+		}
+	}
+
+	return false;
+}
+
+/**
+ * find_user_eh_frame_hdr() - Resolve PT_GNU_EH_FRAME for a user IP with caching
+ * @state: User unwind walk state holding the per-walk VMA cache.
+ * @ip: Lookup instruction pointer in current->mm.
+ * @out_hdr_uaddr: Output user virtual address of .eh_frame_hdr.
+ * @out_hdr_size: Output size in bytes of .eh_frame_hdr.
+ *
+ * Consults @state->cfi_cache before taking mmap_read_lock_killable(). Negative
+ * lookups for executable VMAs lacking ELF headers or PT_GNU_EH_FRAME (such as
+ * JIT regions) are also cached with eh_hdr_uaddr == 0 to avoid repeated lock
+ * acquisitions during a stack walk.
+ *
+ * Return: 0 on success, -ENOENT if no PT_GNU_EH_FRAME covers @ip's VMA,
+ * -EINTR if killed while waiting for mmap_lock, -EFAULT on user copy fault, or
+ * -EINVAL if current->mm is absent or @state->ws is unsupported.
+ */
+static int find_user_eh_frame_hdr(struct unwind_user_state *state,
+				  unsigned long ip,
+				  unsigned long *out_hdr_uaddr,
+				  size_t *out_hdr_size)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long vma_start = 0, vma_end = 0, elf_base = 0;
+	bool found_base;
+	unsigned int i, slot;
+	int err;
+
+	if (!mm)
+		return -EINVAL;
+
+	/* Check per-walk VMA cache first */
+	for (i = 0; i < ARRAY_SIZE(state->cfi_cache); i++) {
+		const struct unwind_user_cfi_cache *c = &state->cfi_cache[i];
+
+		if (c->valid && ip >= c->vma_start && ip < c->vma_end) {
+			if (!c->eh_hdr_uaddr)
+				return -ENOENT;
+			*out_hdr_uaddr = c->eh_hdr_uaddr;
+			*out_hdr_size = c->eh_hdr_size;
+			return 0;
+		}
+	}
+
+	/*
+	 * Resolve the executable VMA and its base ELF mapping (pgoff == 0)
+	 * under mmap_read_lock, then drop mmap_read_lock BEFORE any faultable
+	 * copy_from_user() calls.
+	 */
+	if (mmap_read_lock_killable(mm))
+		return -EINTR;
+
+	found_base = lookup_vma_elf_base_locked(mm, ip, &vma_start, &vma_end,
+						&elf_base);
+	mmap_read_unlock(mm);
+
+	if (!vma_end)
+		return -ENOENT;
+
+	slot = state->cfi_cache_next++ % ARRAY_SIZE(state->cfi_cache);
+	state->cfi_cache[slot].vma_start = vma_start;
+	state->cfi_cache[slot].vma_end = vma_end;
+	state->cfi_cache[slot].eh_hdr_uaddr = 0;
+	state->cfi_cache[slot].eh_hdr_size = 0;
+	state->cfi_cache[slot].valid = true;
+
+	if (!found_base)
+		return -ENOENT;
+
+	if (state->ws == 8)
+		err = parse_user_elf64_eh_hdr(elf_base, out_hdr_uaddr, out_hdr_size);
+	else if (state->ws == 4)
+		err = parse_user_elf32_eh_hdr(elf_base, out_hdr_uaddr, out_hdr_size);
+	else
+		return -EINVAL;
+
+	if (err)
+		return err;
+
+	state->cfi_cache[slot].eh_hdr_uaddr = *out_hdr_uaddr;
+	state->cfi_cache[slot].eh_hdr_size = *out_hdr_size;
+	return 0;
+}
+
+/**
+ * unwind_user_next_cfi() - Compute the Minimal DWARF CFI frame rule for @state
+ * @state: Current user-space unwind state (may set @state->done on bottom).
+ * @out_frame: Output frame recovery rule for unwind_user_next_common().
+ * @out_signal: Set to true if the evaluated FDE represents a signal frame.
+ *
+ * Looks up the user binary's PT_GNU_EH_FRAME table, evaluates the Minimal
+ * DWARF CFI bytecode at @state->ip (or @state->ip - 1 for normal call return
+ * addresses), and translates the resulting &struct dwarf_cfi_row into a
+ * &struct unwind_user_frame.
+ *
+ * Return: 0 on success, -ENOENT if no FDE covers @state->ip or if
+ * DW_CFA_undefined marks the bottom of the stack (setting @state->done), or a
+ * negative errno (-EINVAL, -EFAULT, -EOVERFLOW, -EINTR) on failure.
+ */
+int unwind_user_next_cfi(struct unwind_user_state *state,
+			 struct unwind_user_frame *out_frame, bool *out_signal)
+{
+	struct dwarf_cfi_arch arch;
+	struct dwarf_cfi_row row;
+	unsigned long lookup_ip, hdr_uaddr;
+	size_t hdr_size;
+	int err;
+
+	if (!unwind_user_cfi_arch(state->ws, &arch))
+		return -EINVAL;
+
+	lookup_ip = (state->topmost || state->signal) ? state->ip : state->ip - 1;
+
+	err = find_user_eh_frame_hdr(state, lookup_ip, &hdr_uaddr, &hdr_size);
+	if (!err)
+		err = dwarf_cfi_unwind_user_eh_frame_hdr(hdr_uaddr, hdr_size,
+							 lookup_ip, &arch, &row);
+	if (err == -ENOENT && lookup_ip != state->ip) {
+		/*
+		 * A signal trampoline without a leading NOP has state->ip at
+		 * the exact start of its FDE, where state->ip - 1 misses.
+		 */
+		err = find_user_eh_frame_hdr(state, state->ip, &hdr_uaddr,
+					     &hdr_size);
+		if (!err)
+			err = dwarf_cfi_unwind_user_eh_frame_hdr(hdr_uaddr,
+								 hdr_size,
+								 state->ip,
+								 &arch, &row);
+		if (!err && !row.signal)
+			err = -ENOENT;
+	}
+	if (err)
+		return err;
+
+	/* Explicit DW_CFA_undefined on RA marks bottom of stack (_start/clone) */
+	if (row.ra_rule == DWARF_CFI_RULE_UNDEFINED) {
+		state->done = true;
+		return -ENOENT;
+	}
+
+	if (row.cfa_base != DWARF_CFI_BASE_SP &&
+	    row.cfa_base != DWARF_CFI_BASE_FP &&
+	    row.cfa_base != DWARF_CFI_BASE_FP_INDIRECT &&
+	    row.cfa_base != DWARF_CFI_BASE_SP_INDIRECT)
+		return -EINVAL;
+	if (row.ra_rule == DWARF_CFI_RULE_SAME) {
+		if (!state->ra_valid)
+			return -EINVAL;
+	} else if (row.ra_rule != DWARF_CFI_RULE_OFFSET &&
+		   row.ra_rule != DWARF_CFI_RULE_SP_OFFSET) {
+		return -EINVAL;
+	}
+
+	memset(out_frame, 0, sizeof(*out_frame));
+	out_frame->use_fp = (row.cfa_base == DWARF_CFI_BASE_FP ||
+			     row.cfa_base == DWARF_CFI_BASE_FP_INDIRECT);
+	out_frame->cfa_indirect = (row.cfa_base == DWARF_CFI_BASE_FP_INDIRECT ||
+				   row.cfa_base == DWARF_CFI_BASE_SP_INDIRECT);
+	out_frame->cfa_off = row.cfa_off;
+	out_frame->ra_from_reg = (row.ra_rule == DWARF_CFI_RULE_SAME);
+	out_frame->ra_from_sp = (row.ra_rule == DWARF_CFI_RULE_SP_OFFSET);
+	out_frame->ra_signed = row.ra_signed;
+	out_frame->ra_off = row.ra_off;
+	if (row.fp_rule == DWARF_CFI_RULE_OFFSET) {
+		out_frame->fp_off = row.fp_off;
+	} else if (row.fp_rule == DWARF_CFI_RULE_FP_OFFSET) {
+		out_frame->fp_from_fp = true;
+		out_frame->fp_off = row.fp_off;
+	} else if (row.fp_rule == DWARF_CFI_RULE_SP_OFFSET) {
+		out_frame->fp_from_sp = true;
+		out_frame->fp_off = row.fp_off;
+	}
+	*out_signal = row.signal;
+	return 0;
+}
-- 
2.56.1.750.gf70dc682cf-goog

