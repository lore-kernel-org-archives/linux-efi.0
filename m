Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795391957;
	b=ydlmCQLtcsajnKyxVrX/gTATK11/1EUfhw2TP/zrI/oq0O3g2PhYtm5zYZBJyp7000de
	 aSWCqI+EgvQy6DgUnOABEcickPG6kZ48bS1ZnqjQSOBSPdGXo2Wll8sf4i2eoKi3eQMzD
	 jmGmPZgsxRlDTczBPSGTvkX/xZFeCi5shRvYairzeE8Np/iuvcWgCS0JplJncmu3d37SH
	 EP/q/y1MLaGP9B3aX/421VRQk+KC932wF/sPs3tn6nUB7zFhhueYb/UfBLDCBds5b9pYH
	 494Vx5oFwUqHzrIRVHfpt5pd2Mp0cMFHEanLZ6q6MsTYVWxbS3MFJn5v7S1yO8aGnMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795391957;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=NQMhY0Ufq+yefDIapbuCygCDSizrd5aAXBdJ11e7584=;
	b=NSREIypoPb06cJ/8A6UBoaLHmSg65OwTFgYRkF7KWBlxzkCuv47rUEpbAqHBZJTo57oJ
	 waAMGg7TZ9ULG/PsVr5z9eeXRYEqZoQQhqoVSQbaXFkvW4QhQQdfz8GfYMpELwtcJHEL2
	 lxrpQeIWYcFRxPQhcLdHRmTT4k/DxaIt3P9/N1rGZo1LKwgoD1tu9crcuE/NUQrVuHO3t
	 NdpxCScqLY4FoJ/1QAD9JySgfAKkoQ6B0wEo3yjzCT5HEU2jDFVVs+wA6msV4odPuw17k
	 FC/EhzRiudmoDTrJk4IWO3RJh1j+XJmuwe35n4ThfXG3nqtv0YhEq7SEr66aA6kKGkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LetEVFxg;
	arc=none smtp.remote-ip=74.125.82.199
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484D4606A6BE
	for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 23:59:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 484D4606A6BE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LetEVFxg
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso3830878eec.1
        for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 15:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795391954; x=1795996754; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NQMhY0Ufq+yefDIapbuCygCDSizrd5aAXBdJ11e7584=;
        b=LetEVFxgjhlcdTfBTqOJDX5apD4qUt6qoH1/JHyLsdPCtDxN8vfXeXuLJZs2P56vam
         d00BfqJXO3am8rAosLZ2yn+Y+VDQe/HxSS/yhAlMEeRVoNI6FIIsHkLtFem1RKisT3UF
         dtGMSgZBGiIZ1Y5YZHQSuf0PT0mcPz+JxcJsYprnfOhrS/RSoqZkWOT7EbtZiYTdq1Hy
         x2jQ5Asbhwz5pddGUmXuCxJ0v1B6EgC9HLZFjJ7UPUm21GvkRXL7SNWVd8YxuNVRya5v
         wvyA5OjoBcGqx82omq4cx6gL0D9u/h16eCR5OArFVFWuirHUSWyRCo6hVwJceZ/HevJt
         F6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795391954; x=1795996754;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NQMhY0Ufq+yefDIapbuCygCDSizrd5aAXBdJ11e7584=;
        b=xRsEnfT8ooespVMGsMFwyLPgQBlJWEaRn8jDB5HhKQvConczLLswhX2VC8ua8bE1sW
         8bVA315uBaZATZekaqXv79F5LDN9XyPqStbDTUpHyd9Uh+ra9F59q6lI952USNXEiksr
         aqFe2XXqvrskZ2R8kjYs6/Ek/5aTqd7kRkv9Qoj3Klqk7vkYwW1gW9PCTeUImhcNQ1tf
         bbFYEgXk2eHHsqQWELIHZfqsN3LM9pT+3cpWcAnJxV4JVWX3zWpQG41EYPggsSXJR9AR
         sM1KuISbEc5Rg4/o/+RzBMQhi3771Mb5oTgoDJDlKWIZ8/OIA7lSh82FqhTOsV0kY9vo
         605Q==
X-Forwarded-Encrypted: i=1; AL+hErH4Lb0TFSff3nBuMv8nTZA97A6ePdLzwdIQ3wsRXlmZ9T736cmWXHdFviDiD1Dl7ezQ2TV+MU5GedM=@vger.kernel.org
X-Gm-Message-State: APuU4Z/UGrJgv79zLe72qsvpZjD54u2IEAm6Sdm+J1dLhWLe+Tj5m4k4
	oJnzEbcrUT76uat7HivPRAMobgWQIxLYny+SycuCeg9JcFRzFVGbgv1sm/tPEPyVFmj3eT4OgXH
	J+ZdSltvJ8Q==
X-Received: from dyaz21-n1.prod.google.com ([2002:a05:693c:6395:10b0:386:a65f:c08e])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:6e9a:b0:383:71a:2b14
 with SMTP id 5a478bee46e88-3856f14bb69mr9511315eec.10.1795391954063; Sun, 22
 Nov 2026 15:59:14 -0800 (PST)
Date: Sun, 22 Nov 2026 15:57:54 -0800
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
Message-ID: <20261122235757.3456048-9-irogers@google.com>
Subject: [RFC PATCH v1 08/11] riscv: unwind_user: Support Minimal DWARF CFI
 and FP user unwinding
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

Wire up CONFIG_HAVE_UNWIND_USER_CFI and CONFIG_HAVE_UNWIND_USER_FP on
MMU-enabled RISC-V kernels by adding arch/riscv/include/asm/unwind_user.h
and unwind_user_sigreturn():

 - Define DWARF CFI register mappings for RV64 and RV32/compat user
   tasks (sp=2, fp/s0=8, ra=1).
 - Provide unwind_user_link_register() reading regs->ra for leaf-frame
   unwinding and ARCH_INIT_USER_FP_FRAME matching the RISC-V psABI
   frame layout (CFA = s0, RA at s0 - ws, saved s0 at s0 - 2*ws).
 - Implement unwind_user_sigreturn() (and compat_unwind_user_sigreturn())
   to recover pc, ra, sp, and s0 from rt_sigframe.uc.uc_mcontext.sc_regs
   across __vdso_rt_sigreturn (whose vDSO FDE omits register rules so
   libgcc takes its instruction-matching sigcontext fallback), supporting
   interrupted leaf functions, -fomit-frame-pointer frames, and
   SA_ONSTACK alternate signal stacks.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/riscv/Kconfig                   |  2 +
 arch/riscv/include/asm/signal32.h    |  8 +++
 arch/riscv/include/asm/unwind_user.h | 81 ++++++++++++++++++++++++++++
 arch/riscv/kernel/compat_signal.c    | 44 +++++++++++++++
 arch/riscv/kernel/signal.c           | 62 +++++++++++++++++++++
 5 files changed, 197 insertions(+)
 create mode 100644 arch/riscv/include/asm/unwind_user.h

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index e7891a2a89da..84b61c755db3 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -202,6 +202,8 @@ config RISCV
 	select HAVE_SAMPLE_FTRACE_DIRECT_MULTI
 	select HAVE_STACKPROTECTOR
 	select HAVE_SYSCALL_TRACEPOINTS
+	select HAVE_UNWIND_USER_CFI if MMU
+	select HAVE_UNWIND_USER_FP if MMU
 	select HOTPLUG_PARALLEL if HOTPLUG_CPU
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
diff --git a/arch/riscv/include/asm/signal32.h b/arch/riscv/include/asm/signal32.h
index 96dc56932e76..2c3e8eae56e5 100644
--- a/arch/riscv/include/asm/signal32.h
+++ b/arch/riscv/include/asm/signal32.h
@@ -3,9 +3,12 @@
 #ifndef __ASM_SIGNAL32_H
 #define __ASM_SIGNAL32_H
 
+struct unwind_user_state;
+
 #if IS_ENABLED(CONFIG_COMPAT)
 int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 			  struct pt_regs *regs);
+bool compat_unwind_user_sigreturn(struct unwind_user_state *state);
 #else
 static inline
 int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
@@ -13,6 +16,11 @@ int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 {
 	return -1;
 }
+static inline
+bool compat_unwind_user_sigreturn(struct unwind_user_state *state)
+{
+	return false;
+}
 #endif
 
 #endif
diff --git a/arch/riscv/include/asm/unwind_user.h b/arch/riscv/include/asm/unwind_user.h
new file mode 100644
index 000000000000..a2c2068df4ad
--- /dev/null
+++ b/arch/riscv/include/asm/unwind_user.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_RISCV_UNWIND_USER_H
+#define _ASM_RISCV_UNWIND_USER_H
+
+#ifdef CONFIG_UNWIND_USER
+
+#include <linux/compat.h>
+#include <linux/unwind_dwarf_cfi.h>
+#include <linux/unwind_user_types.h>
+#include <asm/ptrace.h>
+
+/**
+ * unwind_user_word_size() - Return the user-space word size in bytes on RISC-V
+ * @regs: User-mode register state.
+ *
+ * Return: 4 for RV32 compat user tasks, or sizeof(unsigned long) otherwise.
+ */
+static inline int unwind_user_word_size(struct pt_regs *regs)
+{
+	if (IS_ENABLED(CONFIG_COMPAT) && is_compat_task())
+		return 4;
+	return sizeof(unsigned long);
+}
+
+/**
+ * unwind_user_link_register() - Fetch the user link register (ra/x1) from @regs
+ * @regs: User-mode register state.
+ * @ra: Output link register value.
+ *
+ * Return: Always true on RISC-V.
+ */
+static inline bool unwind_user_link_register(struct pt_regs *regs,
+					     unsigned long *ra)
+{
+	*ra = regs->ra;
+	return true;
+}
+#define unwind_user_link_register unwind_user_link_register
+
+/**
+ * unwind_user_cfi_arch() - Populate RISC-V DWARF register numbers
+ * @ws: User word size in bytes (4 for RV32, 8 for RV64).
+ * @arch: Output DWARF CFI architecture descriptor.
+ *
+ * Return: true if @ws is 4 or 8, false otherwise.
+ */
+static inline bool unwind_user_cfi_arch(unsigned int ws,
+					struct dwarf_cfi_arch *arch)
+{
+	if (ws == 8 || ws == 4) {
+		*arch = (struct dwarf_cfi_arch){
+			.ws	= (u8)ws,
+			.sp_reg	= 2,	/* sp (x2) */
+			.fp_reg	= 8,	/* s0/fp (x8) */
+			.ra_reg	= 1,	/* ra (x1) */
+		};
+		return true;
+	}
+	return false;
+}
+
+bool unwind_user_sigreturn(struct unwind_user_state *state);
+#define unwind_user_sigreturn unwind_user_sigreturn
+
+#endif /* CONFIG_UNWIND_USER */
+
+#ifdef CONFIG_HAVE_UNWIND_USER_FP
+
+/*
+ * Standard RISC-V psABI frame record stores {saved_s0, saved_ra} at
+ * [s0 - 2 * ws, s0), with s0 pointing to the caller's stack pointer (CFA).
+ */
+#define ARCH_INIT_USER_FP_FRAME(ws)			\
+	.cfa_off	=  0,				\
+	.ra_off		= -1 * (ws),			\
+	.fp_off		= -2 * (ws),			\
+	.use_fp		= true,
+
+#endif /* CONFIG_HAVE_UNWIND_USER_FP */
+
+#endif /* _ASM_RISCV_UNWIND_USER_H */
diff --git a/arch/riscv/kernel/compat_signal.c b/arch/riscv/kernel/compat_signal.c
index cf3eb33a11e4..d549c3f46ae8 100644
--- a/arch/riscv/kernel/compat_signal.c
+++ b/arch/riscv/kernel/compat_signal.c
@@ -5,6 +5,7 @@
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
 #include <linux/linkage.h>
+#include <linux/unwind_user.h>
 
 #include <asm/csr.h>
 #include <asm/signal32.h>
@@ -243,3 +244,46 @@ int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 
 	return 0;
 }
+
+#ifdef CONFIG_UNWIND_USER
+/**
+ * compat_unwind_user_sigreturn() - Unwind an RV32 compat vDSO rt_sigreturn frame
+ * @state: Current user unwind state.
+ *
+ * Return: true if @state was at __compat_vdso_rt_sigreturn and advanced to the
+ * interrupted 32-bit user context, false otherwise.
+ */
+bool compat_unwind_user_sigreturn(struct unwind_user_state *state)
+{
+	struct mm_struct *mm = current->mm;
+	struct compat_rt_sigframe __user *frame;
+	struct compat_user_regs_struct cregs;
+	unsigned long sigret;
+
+	if (!mm || !mm->context.vdso || (state->sp & 3UL))
+		return false;
+
+	sigret = (unsigned long)COMPAT_VDSO_SYMBOL(mm->context.vdso,
+						   rt_sigreturn);
+	if (state->ip != sigret &&
+	    !(state->topmost && state->ip == sigret + 4))
+		return false;
+
+	frame = (struct compat_rt_sigframe __user *)state->sp;
+	if (copy_from_user(&cregs, &frame->uc.uc_mcontext.sc_regs,
+			   offsetofend(struct compat_user_regs_struct, s0)))
+		return false;
+
+	if ((cregs.sp & 3U) || !cregs.pc)
+		return false;
+
+	state->ip = cregs.pc;
+	state->ra = cregs.ra;
+	state->sp = cregs.sp;
+	state->fp = cregs.s0;
+	state->ra_valid = true;
+	state->signal = true;
+	state->topmost = false;
+	return true;
+}
+#endif
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 59784dc117e4..6472c645914d 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -13,6 +13,7 @@
 #include <linux/resume_user_mode.h>
 #include <linux/linkage.h>
 #include <linux/entry-common.h>
+#include <linux/unwind_user.h>
 
 #include <asm/ucontext.h>
 #include <asm/vdso.h>
@@ -587,3 +588,64 @@ bool sigaltstack_size_valid(size_t ss_size)
 	return ss_size > get_rt_frame_size(false);
 }
 #endif /* CONFIG_DYNAMIC_SIGFRAME */
+
+#ifdef CONFIG_UNWIND_USER
+/**
+ * unwind_user_sigreturn() - Unwind a RISC-V rt_sigreturn user signal frame
+ * @state: Current user unwind state.
+ *
+ * __vdso_rt_sigreturn carries an empty .cfi_signal_frame FDE without register
+ * rules so user-space unwinders such as libgcc take their instruction-matching
+ * sigcontext fallback. Recover pc, ra, sp, and s0 directly from
+ * &rt_sigframe.uc.uc_mcontext.sc_regs so interrupted leaf functions,
+ * -fomit-frame-pointer code, and alternate signal stacks unwind cleanly.
+ *
+ * Return: true if @state was at the rt_sigreturn trampoline and advanced to
+ * the interrupted user context, false otherwise.
+ */
+bool unwind_user_sigreturn(struct unwind_user_state *state)
+{
+	struct mm_struct *mm = current->mm;
+	struct rt_sigframe __user *frame;
+	struct user_regs_struct sc_regs;
+	unsigned long sigret;
+
+	if (!mm)
+		return false;
+
+	if (IS_ENABLED(CONFIG_COMPAT) && state->ws == 4)
+		return compat_unwind_user_sigreturn(state);
+
+	if (state->ws != sizeof(unsigned long) ||
+	    (state->sp & (sizeof(unsigned long) - 1)))
+		return false;
+
+	frame = (struct rt_sigframe __user *)state->sp;
+#ifdef CONFIG_MMU
+	if (!mm->context.vdso)
+		return false;
+	sigret = (unsigned long)VDSO_SYMBOL(mm->context.vdso, rt_sigreturn);
+#else
+	sigret = (unsigned long)&frame->sigreturn_code;
+#endif
+	if (state->ip != sigret &&
+	    !(state->topmost && state->ip == sigret + 4))
+		return false;
+
+	if (copy_from_user(&sc_regs, &frame->uc.uc_mcontext.sc_regs,
+			   offsetofend(struct user_regs_struct, s0)))
+		return false;
+
+	if ((sc_regs.sp & (sizeof(unsigned long) - 1)) || !sc_regs.pc)
+		return false;
+
+	state->ip = sc_regs.pc;
+	state->ra = sc_regs.ra;
+	state->sp = sc_regs.sp;
+	state->fp = sc_regs.s0;
+	state->ra_valid = true;
+	state->signal = true;
+	state->topmost = false;
+	return true;
+}
+#endif
-- 
2.56.1.750.gf70dc682cf-goog

