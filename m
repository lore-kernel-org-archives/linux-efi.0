Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587383;
	b=LRMeEs5Cctg7jqGWNjPC70UxycBweAOKgA8JEV8rRFOfHSOh37onQS1YhCgsmA5rjPp5
	 G6fQ0Oi5tWbfjorT/8GVYCA5yRZ3K3BSuZy8Xfrz/4AJUuUSIVatEjsjOn30bmfj+z9Fw
	 vXftMX2ZW1f/C3+WV9TQqk0Aow3QYDmMEVU/P91Pkl1tq96w0PBDzD/3JOJ0+CllHY8gx
	 oErSYYPqRv94mn4hm47wl+NeRJZaFchQF7NlUKxbOv+WGISnhM6mwoAl2qsM7SUnqVCt8
	 6uGpq2cJ5eyFhrcquf2noRwePPW6BDR7Y2AdLpHOtnNCJLBl8nz/Q8FUa4FkKhLrfhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587383;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ywKwgtuRpN9MyEk19nVCKZKbPQPWCVIyqELiP62icEQ=;
	b=iiOPlqzTvL8B/TQbtdTxJ0g7BZEuoTfMgCRrSlwidqqyfTrpMT9Hja9UsVhPPuQ+Iedg
	 W5o57Z3X8/jqOAGCXjaW4sGdwgaPYw5qminl3BbIQNhjJzcdcqpfEvGg6dKgzLhG1ZVcP
	 FZdz13v8F0SEHKw/WEfnQFkCd84DIYfunXCloIIZLOx4HmWkOQcnZcA3HNHArMK+zZDnL
	 PHBvmoWKKVPQ/bo9S303M+pNBtYJsycG2ptgfPoVp0fTlie3mkoio4f52J5Cd9EsKzzTz
	 J6BIc/3DkFJa2nQpxi9oj5BHZLYI4o43xtrYl90Bgoi8SuhbLJADSwX978V28f5x/gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AGjyqzgA;
	arc=none smtp.remote-ip=74.125.82.69
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EED860A6F51
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EED860A6F51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AGjyqzgA
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-154e9d2d94fso393905c88.0
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587382; x=1796192182; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ywKwgtuRpN9MyEk19nVCKZKbPQPWCVIyqELiP62icEQ=;
        b=AGjyqzgAlwhstMycXjxGjksnbQe0pyofKOIb2ZOL/odiRLW1nKo2iIEhF8/rmt2u18
         w7DOOU+PByQ4VvJjWLXCgVm91t7UH+BCR5FfdtVDTxCfLNBDqyD2cRKcIErOxGsvjkJF
         thrjMVHfnob36NmEM1PO42mcA8OtDgj/PufTe+aDQfuldqo9p8tmG9OMf96O6nYULshu
         pYEweMIj+8y+khb/EVaXaK1/4ugubkn0p/o6CGHkou6JpdIz/qXAiO8l1re7veVjr/WV
         OlUABYAJvlF/i2VEI2beyYe51R0FnDUkbxdVCxMDHbZ46Bl7xUyLUypD/Yfhhb/pjYF+
         Q7lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587382; x=1796192182;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ywKwgtuRpN9MyEk19nVCKZKbPQPWCVIyqELiP62icEQ=;
        b=DwQeNpQUYST4Nonat47Z4THY6WQmh72RpJZlytWI01JexcQN77t4NTFtIcCLNgV1G2
         mHphKqKSGTemSrR1qy0CPhZxWFDEj07czH04bNQDzW0cIzR7CPe7N363LYI8MeV/eKLd
         JiOZnZELJDR3Jl4IyA0eVVkcSIko9NQ7HLlRUtaKTHylxWWWPbdi4/TiPtrXqdoXbDvd
         j5aMCvIjoXIbwvad7H3nNOMyGJnbJKb9I/oh5ITuqrfVvJjfrTcjyKSzhRuApkSDCHYU
         fb7IlBBRQ6NCcpzH05bBl4jWteTP0MssQUN4o83nEip0eylfH0XLLoGrYubgVhVI7MWi
         LPOA==
X-Forwarded-Encrypted: i=1; AL+hErGHIdxhKbkngP9E7nQS8RkfdVbDnHGSh9Y0pBJY672XaITQ85sMSJjC1II207whUWyJKrfo6tr5dJo=@vger.kernel.org
X-Gm-Message-State: APuU4Z+24SXSuUyjVwRwf0EDSQQf69l6W4BdvjJoKxvSkZjWsqNZEBSE
	E35t+p6Df012c0DEdYVXBzERY11O3gB0U/v0PsVK50/PRwXVTNDBgnrBN96PNaflsBtwCdbQXEj
	5Ucx6+Y5l2A==
X-Received: from dlbrc1-n1.prod.google.com ([2002:a05:7022:ea81:10b0:196:a46:fc4b])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:f907:b0:1a7:979f:ecc0
 with SMTP id a92af1059eb24-1b5568d8bd4mr15019505c88.27.1795587380985; Tue, 24
 Nov 2026 22:16:20 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:05 -0800
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
Message-ID: <20261125061523.1540234-13-irogers@google.com>
Subject: [RFC PATCH v2 12/30] x86/unwind: Add Minimal DWARF CFI kernel unwinder
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

Add CONFIG_UNWINDER_DWARF_CFI as a selectable x86-64 kernel stack
unwinder in arch/x86/kernel/unwind_dwarf.c, implementing the asm/unwind.h
and HAVE_RELIABLE_STACKTRACE interfaces over compiler-generated
.eh_frame and linker-generated --eh-frame-hdr tables:
 - Build kernel C and Rust objects with asynchronous unwind tables and
   -fomit-frame-pointer while suppressing unwind tables in boot/startup
   and purgatory objects.
 - Place .eh_frame_hdr and .eh_frame inside RO_DATA via
   ARCH_RODATA_SECTIONS, index loadable module .eh_frame sections via
   dwarf_cfi_mod_alloc()/dwarf_cfi_mod_free_rcu(), and enable BPF
   exception stack walks in arch/x86/net/bpf_jit_comp.c.
 - Unwind across task, IRQ, exception, ftrace, fgraph, rethook, BPF, and
   call_on_stack() frames, while rejecting in-kernel pt_regs exception
   boundaries in arch_stack_walk_reliable().

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/x86/Kconfig               |   2 +-
 arch/x86/Kconfig.debug         |  13 +
 arch/x86/Makefile              |   7 +
 arch/x86/boot/startup/Makefile |   1 +
 arch/x86/include/asm/module.h  |   5 +
 arch/x86/include/asm/unwind.h  |  15 +-
 arch/x86/kernel/Makefile       |   4 +
 arch/x86/kernel/module.c       |  11 +-
 arch/x86/kernel/stacktrace.c   |   8 +-
 arch/x86/kernel/unwind_dwarf.c | 674 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux.lds.S  |  16 +
 arch/x86/net/bpf_jit_comp.c    |  12 +-
 arch/x86/purgatory/Makefile    |   1 +
 13 files changed, 754 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/kernel/unwind_dwarf.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c8096cf66c38..517c2b728752 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -287,7 +287,7 @@ config X86
 	select MMU_GATHER_MERGE_VMAS
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
 	select HAVE_REGS_AND_STACK_ACCESS_API
-	select HAVE_RELIABLE_STACKTRACE		if UNWINDER_ORC || STACK_VALIDATION
+	select HAVE_RELIABLE_STACKTRACE		if UNWINDER_ORC || UNWINDER_DWARF_CFI || STACK_VALIDATION
 	select HAVE_FUNCTION_ARG_ACCESS_API
 	select HAVE_SETUP_PER_CPU_AREA
 	select HAVE_SOFTIRQ_ON_OWN_STACK
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index c95c3aaadf97..bd894d76360c 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -246,6 +246,19 @@ config UNWINDER_ORC
 	  Enabling this option will increase the kernel's runtime memory usage
 	  by roughly 2-4MB, depending on your kernel config.
 
+config UNWINDER_DWARF_CFI
+	bool "Minimal DWARF CFI unwinder"
+	depends on X86_64
+	select UNWIND_DWARF_CFI
+	select UNWIND_TABLES
+	help
+	  This option enables the Minimal DWARF Call Frame Information (CFI)
+	  unwinder for kernel stack traces.  It interprets a strictly bounded
+	  subset of compiler-generated .eh_frame / .eh_frame_hdr tables
+	  matching SFrame's stack state model (PC advances, SP/FP-based CFA
+	  offsets, and FP/RA stack offsets) without requiring frame pointers
+	  in C code or objtool ORC table generation.
+
 config UNWINDER_FRAME_POINTER
 	bool "Frame pointer unwinder"
 	select ARCH_WANT_FRAME_POINTERS
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b7e08519b8c1..70c3308653dd 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -208,7 +208,14 @@ endif
 # Workaround for a gcc prelease that unfortunately was shipped in a suse release
 KBUILD_CFLAGS += -Wno-sign-compare
 #
+ifdef CONFIG_UNWINDER_DWARF_CFI
+KBUILD_CFLAGS += -fasynchronous-unwind-tables
+KBUILD_RUSTFLAGS += -Cforce-unwind-tables=y -Zuse-sync-unwind=n
+KBUILD_RUSTFLAGS += $(if $(call rustc-min-version,109800),,-Zllvm_module_flag=uwtable:u32:2:max)
+LDFLAGS_vmlinux += --eh-frame-hdr
+else
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
+endif
 
 # Avoid indirect branches in kernel to deal with Spectre
 ifdef CONFIG_MITIGATION_RETPOLINE
diff --git a/arch/x86/boot/startup/Makefile b/arch/x86/boot/startup/Makefile
index 5e499cfb29b5..4e3ad26bfc04 100644
--- a/arch/x86/boot/startup/Makefile
+++ b/arch/x86/boot/startup/Makefile
@@ -7,6 +7,7 @@ KBUILD_CFLAGS		+= -D__DISABLE_EXPORTS -mcmodel=small -fPIC \
 			   $(DISABLE_LATENT_ENTROPY_PLUGIN) \
 			   -fno-stack-protector -D__NO_FORTIFY \
 			   -fno-jump-tables \
+			   -fno-unwind-tables -fno-asynchronous-unwind-tables \
 			   -include $(srctree)/include/linux/hidden.h
 
 # disable ftrace hooks and LTO
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 3c2de4ce3b10..da990da59e2b 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -12,11 +12,16 @@ struct its_array {
 #endif
 };
 
+struct mod_dwarf_cfi_index;
+
 struct mod_arch_specific {
 #ifdef CONFIG_UNWINDER_ORC
 	unsigned int num_orcs;
 	int *orc_unwind_ip;
 	struct orc_entry *orc_unwind;
+#endif
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	struct mod_dwarf_cfi_index __rcu *dwarf_cfi_index;
 #endif
 	struct its_array its_pages;
 };
diff --git a/arch/x86/include/asm/unwind.h b/arch/x86/include/asm/unwind.h
index 7cede4dc21f0..49bf73193927 100644
--- a/arch/x86/include/asm/unwind.h
+++ b/arch/x86/include/asm/unwind.h
@@ -20,7 +20,7 @@ struct unwind_state {
 	struct llist_node *kr_cur;
 #endif
 	bool error;
-#if defined(CONFIG_UNWINDER_ORC)
+#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_DWARF_CFI)
 	bool signal, full_regs;
 	unsigned long sp, bp, ip;
 	struct pt_regs *regs, *prev_regs;
@@ -64,7 +64,8 @@ void unwind_start(struct unwind_state *state, struct task_struct *task,
 	__unwind_start(state, task, regs, first_frame);
 }
 
-#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_FRAME_POINTER)
+#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_DWARF_CFI) || \
+	defined(CONFIG_UNWINDER_FRAME_POINTER)
 /*
  * If 'partial' returns true, only the iret frame registers are valid.
  */
@@ -75,7 +76,7 @@ static inline struct pt_regs *unwind_get_entry_regs(struct unwind_state *state,
 		return NULL;
 
 	if (partial) {
-#ifdef CONFIG_UNWINDER_ORC
+#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_DWARF_CFI)
 		*partial = !state->full_regs;
 #else
 		*partial = false;
@@ -92,7 +93,7 @@ static inline struct pt_regs *unwind_get_entry_regs(struct unwind_state *state,
 }
 #endif
 
-#ifdef CONFIG_UNWINDER_ORC
+#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_DWARF_CFI)
 void unwind_init(void);
 void unwind_module_init(struct module *mod, void *orc_ip, size_t orc_ip_size,
 			void *orc, size_t orc_size);
@@ -103,6 +104,12 @@ void unwind_module_init(struct module *mod, void *orc_ip, size_t orc_ip_size,
 			void *orc, size_t orc_size) {}
 #endif
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+void unwind_module_cleanup(struct module *mod);
+#else
+static inline void unwind_module_cleanup(struct module *mod) {}
+#endif
+
 static inline
 unsigned long unwind_recover_rethook(struct unwind_state *state,
 				     unsigned long addr, unsigned long *addr_p)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 31f46fd00527..117cf86617cb 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -18,6 +18,7 @@ CFLAGS_REMOVE_early_printk.o = -pg
 CFLAGS_REMOVE_head64.o = -pg
 CFLAGS_REMOVE_head32.o = -pg
 CFLAGS_REMOVE_rethook.o = -pg
+CFLAGS_REMOVE_unwind_dwarf.o = -pg
 endif
 
 KASAN_SANITIZE_head$(BITS).o				:= n
@@ -25,6 +26,7 @@ KASAN_SANITIZE_dumpstack.o				:= n
 KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
 KASAN_SANITIZE_stacktrace.o				:= n
 KASAN_SANITIZE_paravirt.o				:= n
+KASAN_SANITIZE_unwind_dwarf.o				:= n
 
 # With some compiler versions the generated code results in boot hangs, caused
 # by several compilation units. To be safe, disable all instrumentation.
@@ -41,6 +43,7 @@ KCOV_INSTRUMENT_stacktrace.o				:= n
 KCOV_INSTRUMENT_dumpstack.o				:= n
 KCOV_INSTRUMENT_dumpstack_$(BITS).o			:= n
 KCOV_INSTRUMENT_unwind_orc.o				:= n
+KCOV_INSTRUMENT_unwind_dwarf.o				:= n
 KCOV_INSTRUMENT_unwind_frame.o				:= n
 KCOV_INSTRUMENT_unwind_guess.o				:= n
 
@@ -159,6 +162,7 @@ obj-$(CONFIG_SCHED_MC_PRIO)		+= itmt.o
 obj-$(CONFIG_X86_UMIP)			+= umip.o
 
 obj-$(CONFIG_UNWINDER_ORC)		+= unwind_orc.o
+obj-$(CONFIG_UNWINDER_DWARF_CFI)	+= unwind_dwarf.o
 obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
 obj-$(CONFIG_UNWINDER_GUESS)		+= unwind_guess.o
 
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 33080ad889b7..9cfd60619acc 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -228,7 +228,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    struct module *me)
 {
 	const Elf_Shdr *s, *alt = NULL,
-		*orc = NULL, *orc_ip = NULL,
+		*orc = NULL, *orc_ip = NULL, *eh_frame = NULL,
 		*retpolines = NULL, *returns = NULL, *ibt_endbr = NULL,
 		*calls = NULL, *cfi = NULL;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
@@ -240,6 +240,8 @@ int module_finalize(const Elf_Ehdr *hdr,
 			orc = s;
 		if (!strcmp(".orc_unwind_ip", secstrings + s->sh_name))
 			orc_ip = s;
+		if (!strcmp(".eh_frame", secstrings + s->sh_name))
+			eh_frame = s;
 		if (!strcmp(".retpoline_sites", secstrings + s->sh_name))
 			retpolines = s;
 		if (!strcmp(".return_sites", secstrings + s->sh_name))
@@ -299,14 +301,19 @@ int module_finalize(const Elf_Ehdr *hdr,
 		apply_seal_endbr(iseg, iseg + ibt_endbr->sh_size);
 	}
 
-	if (orc && orc_ip)
+	if (IS_ENABLED(CONFIG_UNWINDER_ORC) && orc && orc_ip)
 		unwind_module_init(me, (void *)orc_ip->sh_addr, orc_ip->sh_size,
 				   (void *)orc->sh_addr, orc->sh_size);
+	if (IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) && eh_frame &&
+	    (eh_frame->sh_flags & SHF_ALLOC) && eh_frame->sh_addr)
+		unwind_module_init(me, /*orc_ip=*/NULL, /*orc_ip_size=*/0,
+				   (void *)eh_frame->sh_addr, eh_frame->sh_size);
 
 	return 0;
 }
 
 void module_arch_cleanup(struct module *mod)
 {
+	unwind_module_cleanup(mod);
 	its_free_mod(mod);
 }
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 9412ac4ddf46..995810b61999 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -49,10 +49,12 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 			/*
 			 * Kernel mode registers on the stack indicate an
 			 * in-kernel interrupt or exception (e.g., preemption
-			 * or a page fault), which can make frame pointers
-			 * unreliable.
+			 * or a page fault), which can make frame pointers or
+			 * compiler-generated DWARF CFI (across unannotated
+			 * inline assembly stack adjustments) unreliable.
 			 */
-			if (IS_ENABLED(CONFIG_FRAME_POINTER))
+			if (IS_ENABLED(CONFIG_FRAME_POINTER) ||
+			    IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI))
 				return -EINVAL;
 		}
 
diff --git a/arch/x86/kernel/unwind_dwarf.c b/arch/x86/kernel/unwind_dwarf.c
new file mode 100644
index 000000000000..135e1cd8b1a0
--- /dev/null
+++ b/arch/x86/kernel/unwind_dwarf.c
@@ -0,0 +1,674 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Minimal DWARF CFI kernel stack unwinder for x86-64.
+ *
+ * Unwinds kernel stacks using the link-time .eh_frame_hdr / .eh_frame tables
+ * and the strictly bounded Minimal DWARF CFA subset (matching SFrame's state
+ * model), with ENCODE_FRAME_POINTER handling entry/exception pt_regs frames.
+ */
+
+#define pr_fmt(fmt) "unwind_dwarf: " fmt
+
+#include <linux/bpf.h>
+#include <linux/export.h>
+#include <linux/ftrace.h>
+#include <linux/module.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/sched/task_stack.h>
+#include <linux/unwind_dwarf_cfi.h>
+#include <asm/ptrace.h>
+#include <asm/sections.h>
+#include <asm/stacktrace.h>
+#include <asm/unwind.h>
+
+static bool dwarf_cfi_ready __ro_after_init;
+
+static const struct dwarf_cfi_arch x86_64_cfi_arch = {
+	.ws	= 8,
+	.sp_reg	= 7,	/* %rsp */
+	.fp_reg	= 6,	/* %rbp */
+	.ra_reg	= 16,	/* %rip */
+};
+
+/* Frame-pointer fallback row for BPF JIT frames */
+static const struct dwarf_cfi_row bpf_fp_row = {
+	.cfa_base	= DWARF_CFI_BASE_FP,
+	.cfa_off	= 16,
+	.fp_rule	= DWARF_CFI_RULE_OFFSET,
+	.fp_off		= -16,
+	.ra_rule	= DWARF_CFI_RULE_OFFSET,
+	.ra_off		= -8,
+};
+
+/* Hardcoded row for IP == 0 (NULL function pointer call crash) */
+static const struct dwarf_cfi_row null_call_row = {
+	.cfa_base	= DWARF_CFI_BASE_SP,
+	.cfa_off	= sizeof(long),
+	.fp_rule	= DWARF_CFI_RULE_SAME,
+	.ra_rule	= DWARF_CFI_RULE_OFFSET,
+	.ra_off		= -(s32)sizeof(long),
+};
+
+#ifdef CONFIG_MODULES
+/**
+ * unwind_module_init() - Build Minimal DWARF CFI index for a loadable module
+ * @mod: Module being loaded.
+ * @orc_ip: Unused under CONFIG_UNWINDER_DWARF_CFI (shared prototype with ORC).
+ * @orc_ip_size: Unused under CONFIG_UNWINDER_DWARF_CFI.
+ * @eh_frame: Pointer to the module's SHF_ALLOC .eh_frame section.
+ * @eh_frame_size: Size in bytes of @eh_frame.
+ *
+ * Scans and sorts the module's FDEs and publishes the resulting index to
+ * @mod->arch.dwarf_cfi_index for RCU-protected lockless lookups.
+ */
+void unwind_module_init(struct module *mod, void *orc_ip, size_t orc_ip_size,
+			void *eh_frame, size_t eh_frame_size)
+{
+	struct mod_dwarf_cfi_index *idx;
+
+	idx = dwarf_cfi_mod_alloc(eh_frame, eh_frame_size, &x86_64_cfi_arch);
+	if (idx)
+		rcu_assign_pointer(mod->arch.dwarf_cfi_index, idx);
+}
+
+/**
+ * unwind_module_cleanup() - Unpublish and RCU-free a module's DWARF CFI index
+ * @mod: Module being unloaded or torn down on load failure.
+ */
+void unwind_module_cleanup(struct module *mod)
+{
+	struct mod_dwarf_cfi_index *idx;
+
+	idx = rcu_replace_pointer(mod->arch.dwarf_cfi_index, /*ptr=*/NULL,
+				  /*c=*/true);
+	dwarf_cfi_mod_free_rcu(idx);
+}
+
+/**
+ * dwarf_cfi_module_find() - Evaluate Minimal DWARF CFI for a module text IP
+ * @ip: Kernel instruction pointer to look up (caller holds RCU read lock).
+ * @row: Output evaluated Minimal DWARF CFI row.
+ *
+ * Return: 0 on success, -ENOENT if @ip is not in a module with an FDE, or a
+ * negative errno on invalid FDE bytecode.
+ */
+static int dwarf_cfi_module_find(unsigned long ip, struct dwarf_cfi_row *row)
+{
+	struct mod_dwarf_cfi_index *idx;
+	struct module *mod;
+
+	mod = __module_address(ip);
+	if (!mod)
+		return -ENOENT;
+
+	idx = rcu_dereference_raw(mod->arch.dwarf_cfi_index);
+	return dwarf_cfi_mod_eval(idx, ip, &x86_64_cfi_arch, row);
+}
+#else
+static int dwarf_cfi_module_find(unsigned long ip, struct dwarf_cfi_row *row)
+{
+	return -ENOENT;
+}
+#endif /* CONFIG_MODULES */
+
+static int dwarf_cfi_find(unsigned long ip, struct dwarf_cfi_row *row);
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+/**
+ * dwarf_cfi_ftrace_find() - Map dynamic ftrace trampolines to template CFI
+ * @ip: Instruction pointer potentially inside a dynamic ftrace ops trampoline.
+ * @row: Output evaluated Minimal DWARF CFI row.
+ *
+ * Dynamic ftrace trampolines are copied from ftrace_caller or
+ * ftrace_regs_caller templates at runtime and therefore have no static FDEs of
+ * their own; translate @ip to the corresponding offset in the template stub.
+ *
+ * Return: 0 on success, or -ENOENT if @ip is not in a dynamic trampoline.
+ */
+static int dwarf_cfi_ftrace_find(unsigned long ip, struct dwarf_cfi_row *row)
+{
+	struct ftrace_ops *ops;
+	unsigned long tramp_addr;
+
+	ops = ftrace_ops_trampoline(ip);
+	if (!ops)
+		return -ENOENT;
+
+	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
+		tramp_addr = (unsigned long)ftrace_regs_caller;
+	else
+		tramp_addr = (unsigned long)ftrace_caller;
+
+	tramp_addr += ip - ops->trampoline;
+	if (ip == tramp_addr)
+		return -ENOENT;
+
+	return dwarf_cfi_find(tramp_addr, row);
+}
+#else
+static int dwarf_cfi_ftrace_find(unsigned long ip, struct dwarf_cfi_row *row)
+{
+	return -ENOENT;
+}
+#endif
+
+/**
+ * dwarf_cfi_find() - Locate and evaluate the Minimal DWARF CFI row for @ip
+ * @ip: Kernel instruction pointer (caller holds RCU read lock).
+ * @row: Output evaluated Minimal DWARF CFI row.
+ *
+ * Checks NULL-call faults (ip == 0), core vmlinux .eh_frame_hdr, loadable
+ * modules, JITed BPF programs/trampolines with frame pointers, and dynamic
+ * ftrace trampolines.
+ *
+ * Return: 0 on success, -ENOENT if no unwind entry covers @ip, or a negative
+ * errno on malformed CFI data.
+ */
+static int dwarf_cfi_find(unsigned long ip, struct dwarf_cfi_row *row)
+{
+	size_t hdr_size = __stop_eh_frame_hdr - __start_eh_frame_hdr;
+	int err;
+
+	if (ip == 0) {
+		*row = null_call_row;
+		return 0;
+	}
+
+	err = dwarf_cfi_unwind_eh_frame_hdr(__start_eh_frame_hdr, hdr_size,
+					    __start_eh_frame, __stop_eh_frame,
+					    ip, &x86_64_cfi_arch, row);
+	if (!err)
+		return 0;
+
+	err = dwarf_cfi_module_find(ip, row);
+	if (!err)
+		return 0;
+
+#ifdef CONFIG_BPF_JIT
+	if (bpf_has_frame_pointer(ip)) {
+		*row = bpf_fp_row;
+		return 0;
+	}
+#endif
+
+	return dwarf_cfi_ftrace_find(ip, row);
+}
+
+/**
+ * unwind_init() - Validate vmlinux .eh_frame_hdr and enable the CFI unwinder
+ *
+ * Verifies that the linker-generated .eh_frame_hdr version-1 table and
+ * .eh_frame section are present before marking the unwinder ready during early
+ * boot.
+ */
+void __init unwind_init(void)
+{
+	size_t hdr_size = __stop_eh_frame_hdr - __start_eh_frame_hdr;
+	size_t eh_size = __stop_eh_frame - __start_eh_frame;
+
+	if (hdr_size < 12 || !eh_size || __start_eh_frame_hdr[0] != 1) {
+		pr_warn("Bad or missing .eh_frame_hdr table; disabling Minimal DWARF unwinder.\n");
+		return;
+	}
+
+	dwarf_cfi_ready = true;
+}
+
+/**
+ * unwind_get_return_address() - Return the current frame's kernel text IP
+ * @state: Current x86 unwind state.
+ *
+ * Return: Kernel text instruction pointer for @state, or 0 if unwinding is
+ * complete or @state->ip is outside kernel/module/BPF/ftrace text.
+ */
+unsigned long unwind_get_return_address(struct unwind_state *state)
+{
+	if (unwind_done(state))
+		return 0;
+
+	return __kernel_text_address(state->ip) ? state->ip : 0;
+}
+EXPORT_SYMBOL_GPL(unwind_get_return_address);
+
+/**
+ * unwind_get_return_address_ptr() - Return stack slot address holding @state's IP
+ * @state: Current x86 unwind state.
+ *
+ * Return: Pointer to the saved IP in @state->regs or at @state->sp - 8, or
+ * NULL if unwinding is complete.
+ */
+unsigned long *unwind_get_return_address_ptr(struct unwind_state *state)
+{
+	if (unwind_done(state))
+		return NULL;
+
+	if (state->regs)
+		return &state->regs->ip;
+
+	if (state->sp)
+		return (unsigned long *)state->sp - 1;
+
+	return NULL;
+}
+
+static bool stack_access_ok(struct unwind_state *state, unsigned long _addr,
+			    size_t len)
+{
+	struct stack_info *info = &state->stack_info;
+	void *addr = (void *)_addr;
+
+	if (on_stack(info, addr, len))
+		return true;
+
+	return !get_stack_info(addr, state->task, info, &state->stack_mask) &&
+	       on_stack(info, addr, len);
+}
+
+static bool deref_stack_reg(struct unwind_state *state, unsigned long addr,
+			    unsigned long *val)
+{
+	if (!stack_access_ok(state, addr, sizeof(long)))
+		return false;
+
+	*val = READ_ONCE_NOCHECK(*(unsigned long *)addr);
+	return true;
+}
+
+static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
+			     unsigned long *ip, unsigned long *sp,
+			     unsigned long *bp)
+{
+	struct pt_regs *regs = (struct pt_regs *)addr;
+
+	if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
+		return false;
+
+	*ip = READ_ONCE_NOCHECK(regs->ip);
+	*sp = READ_ONCE_NOCHECK(regs->sp);
+	*bp = READ_ONCE_NOCHECK(regs->bp);
+
+	if (!user_mode(regs) &&
+	    !on_stack(&state->stack_info, (void *)*sp, sizeof(long))) {
+		struct stack_info next_info;
+
+		if (!get_stack_info((unsigned long *)*sp, state->task,
+				    &next_info, &state->stack_mask))
+			state->stack_info = next_info;
+	}
+	return true;
+}
+
+static struct pt_regs *decode_frame_pointer(unsigned long bp)
+{
+	if (!(bp & 0x1))
+		return NULL;
+
+	return (struct pt_regs *)(bp & ~0x1UL);
+}
+
+/**
+ * get_scratch_reg() - Read a transient DRAP CFA register from @state's pt_regs
+ * @state: Current x86 unwind state.
+ * @dwarf_reg: x86-64 DWARF register number used by DW_CFA_def_cfa_register.
+ * @val: Output register value.
+ *
+ * Compilers realignment prologues/epilogues (DRAP) briefly define the CFA in a
+ * caller-saved scratch register (%r10, %rcx, etc.) for 1-2 instructions. When
+ * unwinding directly from an interrupt/exception with full pt_regs, recover
+ * that register so asynchronous unwinding succeeds at every instruction.
+ *
+ * Return: true if @dwarf_reg was recovered from full pt_regs, false otherwise.
+ */
+static bool get_scratch_reg(struct unwind_state *state, u8 dwarf_reg,
+			    unsigned long *val)
+{
+	struct pt_regs *regs = state->full_regs ? state->regs : state->prev_regs;
+
+	if (!regs)
+		return false;
+
+	switch (dwarf_reg) {
+	case 0: /* %rax */
+		*val = READ_ONCE_NOCHECK(regs->ax);
+		return true;
+	case 1: /* %rdx */
+		*val = READ_ONCE_NOCHECK(regs->dx);
+		return true;
+	case 2: /* %rcx */
+		*val = READ_ONCE_NOCHECK(regs->cx);
+		return true;
+	case 5: /* %rdi */
+		*val = READ_ONCE_NOCHECK(regs->di);
+		return true;
+	case 10: /* %r10 */
+		*val = READ_ONCE_NOCHECK(regs->r10);
+		return true;
+	case 13: /* %r13 */
+		*val = READ_ONCE_NOCHECK(regs->r13);
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool in_entry_text(unsigned long ip)
+{
+	char *addr = (char *)ip;
+
+	return (addr >= __entry_text_start && addr < __entry_text_end) ||
+	       (void *)ip == ret_from_fork_asm;
+}
+
+static bool dwarf_is_rethook_trampoline(unsigned long addr)
+{
+#ifdef CONFIG_RETHOOK
+	return is_rethook_trampoline(addr);
+#else
+	return false;
+#endif
+}
+
+/**
+ * dwarf_recover_ret_addr() - Recover ftrace_graph and rethook return addresses
+ * @state: Current x86 unwind state.
+ * @addr: Raw return address read from the stack or pt_regs.
+ * @addr_p: Stack slot address where @addr was stored.
+ *
+ * Handles both single hooks and stacked hooks in either installation order
+ * (fgraph->rethook via unwind_recover_ret_addr(), or rethook->fgraph via a
+ * follow-up ftrace_graph_ret_addr() pass).
+ *
+ * Return: Original caller instruction pointer (or 0 if rethook lookup failed).
+ */
+static unsigned long dwarf_recover_ret_addr(struct unwind_state *state,
+					    unsigned long addr,
+					    unsigned long *addr_p)
+{
+	unsigned long ret;
+
+	ret = unwind_recover_ret_addr(state, addr, addr_p);
+	return ftrace_graph_ret_addr(state->task, &state->graph_idx,
+				     ret, addr_p);
+}
+
+/**
+ * unwind_next_frame() - Advance @state to the next outer x86-64 kernel frame
+ * @state: Current x86 unwind state.
+ *
+ * Evaluates Minimal DWARF CFI for @state->ip, handles top-of-stack task
+ * pt_regs, arch_rethook_trampoline entry, %rsp-verified ENCODE_FRAME_POINTER
+ * entry/exception pt_regs transitions, and call_on_stack() IRQ stack pivots.
+ *
+ * Return: true if a valid outer frame was unwound, or false when the bottom of
+ * the stack is reached or an error terminates the walk.
+ */
+bool unwind_next_frame(struct unwind_state *state)
+{
+	enum stack_type prev_type = state->stack_info.type;
+	unsigned long prev_sp = state->sp;
+	struct dwarf_cfi_row row;
+	unsigned long lookup_ip, cfa, ip_p;
+	struct pt_regs *regs;
+	int err;
+
+	if (unwind_done(state))
+		return false;
+
+	/* Keep module .eh_frame tables alive across lookup and evaluation */
+	guard(rcu)();
+
+	if (state->regs && user_mode(state->regs))
+		goto the_end;
+
+	/*
+	 * Check if we have reached the top-of-task-stack pt_regs boundary
+	 * (syscall entry, newly forked thread, kthread, or idle thread).
+	 */
+	regs = task_pt_regs(state->task);
+	if ((void *)state->ip == ret_from_fork_asm ||
+	    state->sp == (unsigned long)regs) {
+		if (!user_mode(regs))
+			goto the_end;
+
+		if (!deref_stack_regs(state, (unsigned long)regs,
+				      &state->ip, &state->sp, &state->bp))
+			goto err;
+		state->regs = regs;
+		state->prev_regs = NULL;
+		state->full_regs = true;
+		state->signal = true;
+		return true;
+	}
+
+	if (!state->ip && !state->signal)
+		goto err;
+
+	lookup_ip = state->signal ? state->ip : state->ip - 1;
+	err = dwarf_cfi_find(lookup_ip, &row);
+	if (err) {
+		/*
+		 * Handle an interrupt/unwind starting right at the entry of
+		 * arch_rethook_trampoline() before pushq $arch_rethook_trampoline.
+		 */
+		if (state->signal && dwarf_is_rethook_trampoline(state->ip)) {
+			state->ip =
+				dwarf_recover_ret_addr(state, state->ip,
+						       (unsigned long *)(state->sp - sizeof(long)));
+			if (!state->ip || dwarf_is_rethook_trampoline(state->ip))
+				goto err;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+			if (state->ip == (unsigned long)return_to_handler)
+				goto err;
+#endif
+			state->regs = NULL;
+			state->prev_regs = NULL;
+			state->full_regs = false;
+			state->signal = true;
+			return true;
+		}
+
+		/*
+		 * Entry / interrupt / exception .S stubs without .eh_frame
+		 * encode a pointer to struct pt_regs in %rbp via
+		 * ENCODE_FRAME_POINTER (setting bit 0).  Verify that %rsp has
+		 * actually reached that pt_regs frame (or the 8-byte return
+		 * slot immediately below it in error_entry / paranoid_entry)
+		 * so a stale outer encoded %rbp never skips intermediate frames.
+		 */
+		regs = decode_frame_pointer(state->bp);
+		if (regs &&
+		    (state->sp == (unsigned long)regs ||
+		     (in_entry_text(state->ip) &&
+		      state->sp == (unsigned long)regs - sizeof(long)))) {
+			unsigned long orig_ip;
+
+			if (!deref_stack_regs(state, (unsigned long)regs,
+					      &orig_ip, &state->sp, &state->bp))
+				goto err;
+			state->ip =
+				dwarf_recover_ret_addr(state, orig_ip,
+						       (unsigned long *)(state->sp - sizeof(long)));
+			if (dwarf_is_rethook_trampoline(orig_ip) &&
+			    (!state->ip || dwarf_is_rethook_trampoline(state->ip)))
+				goto err;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+			if (dwarf_is_rethook_trampoline(orig_ip) &&
+			    state->ip == (unsigned long)return_to_handler)
+				goto err;
+#endif
+			state->regs = regs;
+			state->prev_regs = NULL;
+			state->full_regs = true;
+			state->signal = true;
+			goto check_progress;
+		}
+
+		/*
+		 * Unencoded entry assembly (pre-ENCODE_FRAME_POINTER or
+		 * post-POP_REGS) or an unaligned/encoded %rbp cannot be
+		 * unwound via a frame-pointer guess.
+		 */
+		if (in_entry_text(state->ip) || (state->bp & (sizeof(long) - 1)))
+			goto err;
+
+		/* Fallback to frame-pointer guess and mark unreliable */
+		row = bpf_fp_row;
+		state->error = true;
+	}
+
+	if (row.ra_rule == DWARF_CFI_RULE_UNDEFINED)
+		goto the_end;
+
+	if (row.ra_rule != DWARF_CFI_RULE_OFFSET)
+		goto err;
+
+	switch (row.cfa_base) {
+	case DWARF_CFI_BASE_SP: {
+		unsigned long sp_base = state->sp;
+
+		/*
+		 * call_on_stack() stores the pre-switch task-stack %rsp at the
+		 * top slot of the per-CPU IRQ stack (info.end - 1) and pivots
+		 * %rsp there before invoking the IRQ/softirq handler.
+		 */
+		if (state->stack_info.type == STACK_TYPE_IRQ &&
+		    state->sp == (unsigned long)(state->stack_info.end - 1)) {
+			if (!deref_stack_reg(state, state->sp, &sp_base))
+				goto err;
+		}
+		cfa = sp_base + row.cfa_off;
+		break;
+	}
+	case DWARF_CFI_BASE_FP:
+		cfa = state->bp + row.cfa_off;
+		break;
+	case DWARF_CFI_BASE_FP_INDIRECT:
+		if (!deref_stack_reg(state, state->bp + row.cfa_off, &cfa))
+			goto err;
+		break;
+	case DWARF_CFI_BASE_REG:
+		if (!get_scratch_reg(state, row.cfa_reg, &cfa))
+			goto err;
+		cfa += row.cfa_off;
+		break;
+	default:
+		goto err;
+	}
+
+	ip_p = cfa + row.ra_off;
+	if (!deref_stack_reg(state, ip_p, &state->ip))
+		goto err;
+
+	state->ip = dwarf_recover_ret_addr(state, state->ip,
+					   (unsigned long *)ip_p);
+	if (!state->ip || dwarf_is_rethook_trampoline(state->ip))
+		goto err;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	if (state->ip == (unsigned long)return_to_handler)
+		goto err;
+#endif
+
+	if (row.fp_rule == DWARF_CFI_RULE_OFFSET) {
+		if (!deref_stack_reg(state, cfa + row.fp_off, &state->bp))
+			goto err;
+	} else if (row.fp_rule == DWARF_CFI_RULE_FP_OFFSET) {
+		if (!deref_stack_reg(state, state->bp + row.fp_off, &state->bp))
+			goto err;
+	}
+
+	state->sp = cfa;
+	state->regs = NULL;
+	state->prev_regs = NULL;
+	state->full_regs = false;
+	state->signal = row.signal;
+
+check_progress:
+	if (state->stack_info.type == prev_type &&
+	    on_stack(&state->stack_info, (void *)state->sp, sizeof(long)) &&
+	    state->sp <= prev_sp)
+		goto err;
+
+	return true;
+
+err:
+	state->error = true;
+the_end:
+	state->stack_info.type = STACK_TYPE_UNKNOWN;
+	return false;
+}
+EXPORT_SYMBOL_GPL(unwind_next_frame);
+
+/**
+ * __unwind_start() - Initialize an x86-64 Minimal DWARF CFI kernel stack walk
+ * @state: Unwind state structure to initialize.
+ * @task: Task whose kernel stack is being unwound.
+ * @regs: Optional starting register state (e.g. from an interrupt/exception).
+ * @first_frame: Stack pointer threshold to skip frames below the caller.
+ */
+void __unwind_start(struct unwind_state *state, struct task_struct *task,
+		    struct pt_regs *regs, unsigned long *first_frame)
+{
+	memset(state, 0, sizeof(*state));
+	state->task = task;
+
+	if (!dwarf_cfi_ready)
+		goto err;
+
+	if (task_on_another_cpu(task))
+		goto err;
+
+	if (regs) {
+		if (user_mode(regs))
+			goto the_end;
+
+		state->ip = regs->ip;
+		state->sp = regs->sp;
+		state->bp = regs->bp;
+		state->regs = regs;
+		state->full_regs = true;
+		state->signal = true;
+	} else if (task == current) {
+		asm volatile("lea (%%rip), %0\n\t"
+			     "mov %%rsp, %1\n\t"
+			     "mov %%rbp, %2\n\t"
+			     : "=r" (state->ip), "=r" (state->sp),
+			       "=r" (state->bp));
+		state->signal = true;
+	} else {
+		struct inactive_task_frame *frame = (void *)task->thread.sp;
+
+		state->sp = task->thread.sp + sizeof(*frame);
+		state->bp = READ_ONCE_NOCHECK(frame->bp);
+		state->ip = READ_ONCE_NOCHECK(frame->ret_addr);
+		state->signal = (void *)state->ip == ret_from_fork_asm;
+	}
+
+	if (get_stack_info((unsigned long *)state->sp, state->task,
+			   &state->stack_info, &state->stack_mask)) {
+		void *next_page = (void *)PAGE_ALIGN((unsigned long)state->sp);
+
+		state->error = true;
+		if (get_stack_info(next_page, state->task, &state->stack_info,
+				   &state->stack_mask))
+			return;
+	}
+
+	if (regs) {
+		unwind_next_frame(state);
+		return;
+	}
+
+	while (!unwind_done(state) &&
+	       (!on_stack(&state->stack_info, first_frame, sizeof(long)) ||
+		state->sp <= (unsigned long)first_frame))
+		unwind_next_frame(state);
+
+	return;
+
+err:
+	state->error = true;
+the_end:
+	state->stack_info.type = STACK_TYPE_UNKNOWN;
+}
+EXPORT_SYMBOL_GPL(__unwind_start);
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 2438b89a4620..20f0fa33ea9c 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -21,6 +21,22 @@
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	16
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+#define ARCH_RODATA_SECTIONS						\
+	. = ALIGN(4);							\
+	.eh_frame_hdr : AT(ADDR(.eh_frame_hdr) - LOAD_OFFSET) {		\
+		__start_eh_frame_hdr = .;				\
+		*(.eh_frame_hdr)					\
+		__stop_eh_frame_hdr = .;				\
+	}								\
+	. = ALIGN(8);							\
+	.eh_frame : AT(ADDR(.eh_frame) - LOAD_OFFSET) {			\
+		__start_eh_frame = .;					\
+		*(.eh_frame) *(.eh_frame.*)				\
+		__stop_eh_frame = .;					\
+	}
+#endif
+
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 4c3e09d98131..84217ce6a283 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -5122,11 +5122,13 @@ void bpf_jit_free(struct bpf_prog *prog)
 
 bool bpf_jit_supports_exceptions(void)
 {
-	/* We unwind through both kernel frames (starting from within bpf_throw
-	 * call) and BPF frames. Therefore we require ORC unwinder to be enabled
-	 * to walk kernel frames and reach BPF frames in the stack trace.
+	/*
+	 * We unwind through both kernel frames (starting from within bpf_throw
+	 * call) and BPF frames. Therefore we require ORC or Minimal DWARF CFI
+	 * unwinder to be enabled to walk kernel frames and reach BPF frames.
 	 */
-	return IS_ENABLED(CONFIG_UNWINDER_ORC);
+	return IS_ENABLED(CONFIG_UNWINDER_ORC) ||
+	       IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI);
 }
 
 bool bpf_jit_supports_private_stack(void)
@@ -5136,7 +5138,7 @@ bool bpf_jit_supports_private_stack(void)
 
 void arch_bpf_stack_walk(bool (*consume_fn)(void *cookie, u64 ip, u64 sp, u64 bp), void *cookie)
 {
-#if defined(CONFIG_UNWINDER_ORC)
+#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_DWARF_CFI)
 	struct unwind_state state;
 	unsigned long addr;
 
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index fad91ea28fe7..ef3ae80f5c06 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -35,6 +35,7 @@ PURGATORY_CFLAGS := -mcmodel=small -ffreestanding -fno-zero-initialized-in-bss -
 PURGATORY_CFLAGS += -fpic -fvisibility=hidden
 PURGATORY_CFLAGS += $(DISABLE_KSTACK_ERASE) -DDISABLE_BRANCH_PROFILING
 PURGATORY_CFLAGS += -fno-stack-protector
+PURGATORY_CFLAGS += -fno-unwind-tables -fno-asynchronous-unwind-tables
 PURGATORY_CFLAGS += -D__DISABLE_EXPORTS -D__NO_FORTIFY
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
-- 
2.56.1.831.g720f3f5937-goog

