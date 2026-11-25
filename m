Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587392;
	b=xm7HPoyWF9l1McTy/9LwVr7hk7RIqLjOY879+6GE95kQgGNRpcJQZljUxw6rOWHw1qmA
	 vuJxdp/4wQeYCCGjR/Rnf3Kjwt7tetEmmK5YvwZWrZNkMBbMgzH3/naBnW0mDku+JGUFk
	 r29lTw1buqUCkAbkmodq7bvmJgMTVqi3H12Q40EVZToQA+2VgNiDgMjUBWspMimTzKwvz
	 vJi3xHiRw416dI50lcqzEIN4AQzUwnBGEFH0m2pPh2XTb2FbV4k7kim6F7O36oxYc7Di+
	 3uof+94h89WnGxadNhBFFzz77vvtRQq4fd5uyKShVy76rjq3z1nZhwJ1jUBBgyE06xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ziD/5SVNpVvJrFTksFhEkRTwEv+vEsuDld5BMClPtX4=;
	b=gQyfF4BhIbnjl1T/BdC+fPtIvMfFhXiKbkvMTsGGmFD8IoROHYbrmETHYNWcz0G0rx1R
	 7kjCJc92XNKJ7ry2Y2eP2aQMvM5SeLAQcFgNagROiX6OHaJmo/Ni2oltEind3GyuMgp+1
	 YcEps6gO6TmYcJgE3ltwYgIeoy+dk9djebYu4QIkcKUtRgZC4CsX834QGgRDKEp9HH2So
	 v19bWUIlpVPkBfQsIj7aBGlaGUMoriKLWV2KItVebfxT3n/vW7ptXuKBwE7kfteFzutHQ
	 8zu+l9PDsG0Z62avVQQMqruL4fNSgDaHn/nTu4sddyNzR50mahLfM5YqjgI/C2EMruA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NEnG92tt;
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C484606A998
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C484606A998
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NEnG92tt
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3846d5f54c1so6513711eec.1
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587392; x=1796192192; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ziD/5SVNpVvJrFTksFhEkRTwEv+vEsuDld5BMClPtX4=;
        b=NEnG92tt6kO9bt4FCS99WQkK3qEJBec9HLuvC1SAcRCNgTrKeerNcK+hVj49d2m/JZ
         coDBMXgoc+U6nwekXKyWRlltsBXvV/YamFeRUhbCMyrdaXfKGM1pEEkXyf9w4yJIYEaV
         XAQwF+yZMXk2YLC4N7ws2xKxm36WuimAIp/zOrMZsH8z5Lv1m3KUor7M5HKw6qTz2c67
         OnnQarZgAsmneZS3i51fo8rGuSR0S7KTBg0g7rIsaBMzgDA1mrs1EL0qF/LU1dT+rct9
         BiHdpEBzERanUPkb8nCL7/SvIaRmg9z9Z7GjKZmWnRjkEE/mcMv5t6d9IMpXtFQIJn6Z
         lWOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587392; x=1796192192;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ziD/5SVNpVvJrFTksFhEkRTwEv+vEsuDld5BMClPtX4=;
        b=f1t957i6PTTXTSckN0hfm1KRHAvSvAsqSkfB7z1XlGkXag1rmAuozgafPdvUdZVmTB
         G54F5fvq5Z5Hc7ABrFtHgksHaXX9Odyq4JGS65ng8F++Es9FPhr1azEvxBBpMHk4JFDE
         PZZhWHOU2Bko4QgdU715kXfBrUDj4EbL1H67sm9sCMeFtoAH4l3tjd8VujuTtNO0ZqgK
         8LGTr0W/HV//br2xtIy4VybHrsGwexZAcRa0ubtloplKC8Aq3TASzmqCfFRKL4e8iHt/
         XQ81hlURa+uVq8mzgn+GkdrT7M8b2g6h0jV9XBG+Ie1gc0tQe+cIOy0F2Kp7PT/pKGJT
         UVpQ==
X-Forwarded-Encrypted: i=1; AL+hErHz+gfCyrhfkL9cYBLa08zUXd/2DAyIofAerV7JSxD4al411U+I5FxRbVDL5CKFE7O3wN+CT6N5qAQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8iDwhCSm3s4gwMj0/dGiYqVAXH5X+Bb6Ti+6oGyLL6I6/bQMwo
	bVx2JgPh08ew+LsbUgNmY7Yl54nX8VjHAgU/diexovh3fFSL7wowwQ2oC6fum9XSWjGi18wW1HU
	zJLJkP/3AEw==
X-Received: from dyba2.prod.google.com ([2002:a05:693c:63c2:b0:386:9a0b:1f64])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:60d7:b0:386:a01f:a31e
 with SMTP id 5a478bee46e88-386a01fa8a5mr13485947eec.29.1795587391007; Tue, 24
 Nov 2026 22:16:31 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:10 -0800
In-Reply-To: <20261125061523.1540234-1-irogers@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261125061523.1540234-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261125061523.1540234-18-irogers@google.com>
Subject: [RFC PATCH v2 17/30] riscv: unwind_user: Support Minimal DWARF CFI
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
	nathan@kernel.org, llvm@lists.linux.dev, nsc@kernel.org, 
	linux-kbuild@vger.kernel.org, ojeda@kernel.org, 
	rust-for-linux@vger.kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, 
	wnliu@google.com, dylanbhatch@google.com, Ian Rogers <irogers@google.com>
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
 arch/riscv/include/asm/signal32.h    |  9 +++
 arch/riscv/include/asm/unwind_user.h | 82 ++++++++++++++++++++++++++++
 arch/riscv/kernel/compat_signal.c    | 45 +++++++++++++++
 arch/riscv/kernel/signal.c           | 57 +++++++++++++++++++
 5 files changed, 195 insertions(+)
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
index 96dc56932e76..c1cbcb681aa7 100644
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
@@ -13,6 +16,12 @@ int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 {
 	return -1;
 }
+
+static inline
+bool compat_unwind_user_sigreturn(struct unwind_user_state *state)
+{
+	return false;
+}
 #endif
 
 #endif
diff --git a/arch/riscv/include/asm/unwind_user.h b/arch/riscv/include/asm/unwind_user.h
new file mode 100644
index 000000000000..d3c12a183ac9
--- /dev/null
+++ b/arch/riscv/include/asm/unwind_user.h
@@ -0,0 +1,82 @@
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
+
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
index cf3eb33a11e4..53b5be62e393 100644
--- a/arch/riscv/kernel/compat_signal.c
+++ b/arch/riscv/kernel/compat_signal.c
@@ -5,6 +5,7 @@
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
 #include <linux/linkage.h>
+#include <linux/unwind_user.h>
 
 #include <asm/csr.h>
 #include <asm/signal32.h>
@@ -243,3 +244,47 @@ int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 
 	return 0;
 }
+
+#ifdef CONFIG_UNWIND_USER
+/**
+ * compat_unwind_user_sigreturn() - Unwind an RV32 compat vDSO rt_sigreturn frame
+ * @state: Current user unwind state.
+ *
+ * Return: true if @state was at the compat vDSO __vdso_rt_sigreturn trampoline
+ * and advanced to the interrupted 32-bit user context, false otherwise.
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
+	state->sp_valid = true;
+	state->signal = true;
+	state->topmost = false;
+	return true;
+}
+#endif
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 59784dc117e4..c0d70220e4a4 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -13,6 +13,7 @@
 #include <linux/resume_user_mode.h>
 #include <linux/linkage.h>
 #include <linux/entry-common.h>
+#include <linux/unwind_user.h>
 
 #include <asm/ucontext.h>
 #include <asm/vdso.h>
@@ -587,3 +588,59 @@ bool sigaltstack_size_valid(size_t ss_size)
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
+	if (state->ws != sizeof(unsigned long) || !mm->context.vdso ||
+	    (state->sp & (sizeof(unsigned long) - 1)))
+		return false;
+
+	frame = (struct rt_sigframe __user *)state->sp;
+	sigret = (unsigned long)VDSO_SYMBOL(mm->context.vdso, rt_sigreturn);
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
+	state->sp_valid = true;
+	state->signal = true;
+	state->topmost = false;
+	return true;
+}
+#endif
-- 
2.56.1.831.g720f3f5937-goog

