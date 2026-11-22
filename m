Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795391936;
	b=ah/SVkGHAld8dgsAJ33SFaaaKB4/MeN1wkv/95S7rGITZN1Gd2dcYUWe10coYTTG4Dqp
	 K+FXdXCCBPmpK8a8LBbaXXu083XPuf8eO4+0e00stncHNCX9E4HoUWnfMarCFfr1zKtXk
	 j3QI8dD4YoxhyAF2CPaKi7I7zn5mFC8YyQ5T3Ga0BOn6OW3+PXDG0qbTF+OMzSJRJqobP
	 pmVWgeGPWKXxrQl2yE45Mat/kedc37cv4tBFkZXROUgChkrDkeJVHQ+5rtxEid9plsb1+
	 IVl9IPOJl1wEgoOgojWkuiCGBRbm6lLix0OLasM0QvW8EC1Go0Dxugmvk6+m31apPhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795391936;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=09hczlEa/IAKtpVREuSn8p6rY2QTIPxFA39wXK+BQFk=;
	b=SQfpJVwts2glXYdlPJF38T8ojRGyjnhbg5bkiZQdd4FItw579FgIidINPunurNfoNywe
	 XbR8jePq4FEXn/gsspdlqMaMjimrNI4zWpXQakfLGoaEIzweWsjBVQSXcrnMSenlUq4H8
	 ItQcZ5wqmJDHh7SRbxo/3h5OuLJZ7//lxzzrCGtq8OrVDPK0po+Wua8rdwvBp2WedPZSN
	 YNUuL0aw3NU/z6U0LXWmbP+DQ4cyiUGgtg2KfmEjXfc6ptWTnnIt76onm2Ueiuy1+t9si
	 +Y6HcTjwLYjOnjv0y7FqIKyZW5k+1GUfZ299aeKR8dMxdEMvbFUNjaBMglX3Dw6UjLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=akvPhLI3;
	arc=none smtp.remote-ip=74.125.82.70
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5101A606A330
	for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 23:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5101A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=akvPhLI3
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1b55f4f3bb8so1228653c88.0
        for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 15:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795391935; x=1795996735; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=09hczlEa/IAKtpVREuSn8p6rY2QTIPxFA39wXK+BQFk=;
        b=akvPhLI3MDu6r3MjwvL1+tyGas0zv4SH0oMOw5l97vVzCJrh/Cm8uiwwPwxwkCCsa+
         uiuqlVk8BdavZl8XvysGxtJ+Bz2sZPtfPNAiZubxJb28xNphk/P2qWV7UKrldBtFDkA/
         BAYeH01Toy8SF4y7Rqip0UZnST6S/rAANmA6+KiSqCH1nS45xTRquaCX2uCXpyLwT8Yp
         TYRhwnzrw5ootHNCFu/Cd8ya/MfsErSxHkzRSSvi4JVYXynOBjg+E2OjTrihsRkGtbqJ
         r1bFqh2xANaES9OsOGqlj3VDPIn5IaPfxgPBGNwqd52FD2QCIaVooBZ3+gKZEB9sjFUH
         0Vuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795391935; x=1795996735;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=09hczlEa/IAKtpVREuSn8p6rY2QTIPxFA39wXK+BQFk=;
        b=E55FX/ZCwZ8/9a+1p5Y3A8wmf3H0yfw1cGxQGwbBJC3xJAeHZx9iRYCycII0/stb8p
         6hJa4bM/oMQmlXAcsq+2uSQY4cBu2PgFK9tXn0HXMDuWCe9mOqQRbf6UJK7ZEz8x/v9g
         cYSxrLBXPulg76foNe4GaY0YDrMSWja58d+Go0cfRR0LjQD7tiN0HcAnnl1kawlR2lHE
         74ZYVYrccY/sNy4iqfjJ/3hW44FMIdY6eqnyxtAE2mWu7NL4kEqyzyZ86F5kDiHfhMgz
         /g2FdEqHUPYBJcl0U7Mf3tPdLV4eakGYr3xhOFRDpp/CCsuB6dwNSjqz70i/OjZDnZvy
         u/OA==
X-Forwarded-Encrypted: i=1; AL+hErH7SocuSFA2hzN6gdkhSFIdVEEcWiHLu0RHRfwuBtt2iARQ8i3n4JI4CeCnqCB9LhsbsLSoOUqsHiQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z9DMYsKNxLaBEok64aKFsNdpVJ5cyut+ZrPlp2dDVcwHCcwgE6I
	Wp42uw+Z7JCZ1tXfdnumg43/XURviYz7I9Jf58KGxZJ0ow8nCfTP2Ea4k4H2jub8dZD2MkiARs8
	sSLGCvKK4Sw==
X-Received: from dlgw20-n2.prod.google.com ([2002:a05:701a:cc94:20b0:1b5:75d1:3c1e])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:3d14:b0:151:6e80:baa9
 with SMTP id a92af1059eb24-1b55687f17dmr15324404c88.12.1795391933906; Sun, 22
 Nov 2026 15:58:53 -0800 (PST)
Date: Sun, 22 Nov 2026 15:57:49 -0800
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
Message-ID: <20261122235757.3456048-4-irogers@google.com>
Subject: [RFC PATCH v1 03/11] scripts, unwind: Add build-time .eh_frame minifier
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

Add a standalone C build-time ELF relocatable (.o) .eh_frame minifier
(scripts/min_eh_frame.c, enabled by CONFIG_UNWINDER_DWARF_CFI_MINIFY)
supporting x86-64, ARM64, and RISC-V with zero external library or
scripting dependencies.

During Kbuild compilation (C, Rust, and post-LTO composite objects),
scripts/min_eh_frame rewrites .eh_frame (both SHT_PROGBITS and
SHT_X86_64_UNWIND) in place to:
 - Strip callee-saved GPR spill/restore opcodes (%rbx/%r12-%r15 on
   x86-64, x19-x28 on ARM64, s1-s11 on RISC-V) and DW_CFA_GNU_args_size
   while preserving CFA, FP, RA, shrink-wrap state-stack, DRAP, and
   ARM64 DW_CFA_AARCH64_negate_ra_state (0x2d) transitions.
 - Normalize CIEs and coalesce consecutive unrelocated PC-advance
   instructions while remapping sorted .rela.eh_frame relocations
   (including RISC-V R_RISCV_SET6/SUB6 and ADD32/SUB32 relaxation pairs).

Across full vmlinux builds on x86-64 (69,958 FDEs), ARM64 (69,765 FDEs),
and RISC-V (55,296 FDEs), minification achieves 100.00% FDE coverage and
reduces .eh_frame size 18%-28% below SFrame v3 (.sframe).

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/Kconfig               |   10 +
 rust/Makefile              |    4 +-
 scripts/Makefile           |    1 +
 scripts/Makefile.build     |   12 +-
 scripts/Makefile.lib       |   13 +-
 scripts/Makefile.vmlinux_o |    8 +-
 scripts/min_eh_frame.c     | 1719 ++++++++++++++++++++++++++++++++++++
 7 files changed, 1761 insertions(+), 6 deletions(-)
 create mode 100644 scripts/min_eh_frame.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 340a7ecbfc68..6509265065e1 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -528,6 +528,16 @@ config HAVE_UNWIND_USER_CFI
 	select UNWIND_USER
 	select UNWIND_DWARF_CFI
 
+config UNWINDER_DWARF_CFI_MINIFY
+	bool "Minify .eh_frame tables at build time"
+	depends on UNWINDER_DWARF_CFI
+	default y
+	help
+	  Strip unneeded callee-saved register opcodes and coalesce PC-advance
+	  bytecodes in .eh_frame sections at build time, reducing kernel unwind
+	  table memory usage while ensuring only Minimal DWARF CFA bytecodes
+	  remain in vmlinux and modules.
+
 config HAVE_PERF_REGS
 	bool
 	help
diff --git a/rust/Makefile b/rust/Makefile
index 0165626decbe..1238b4ac661d 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -668,7 +668,8 @@ quiet_cmd_rustc_library = $(if $(skip_clippy),RUSTC,$(RUSTC_OR_CLIPPY_QUIET)) L
 		$(CC_FLAGS_RUST_INLINE_HELPERS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@ \
 		$(cmd_ld_single)) \
 	$(if $(rustc_objcopy),;$(OBJCOPY) $(rustc_objcopy) $@) \
-	$(cmd_objtool)
+	$(cmd_objtool) \
+	$(cmd_min_eh_frame)
 
 rust-analyzer:
 	$(Q)MAKEFLAGS= $(srctree)/scripts/generate_rust_analyzer.py \
@@ -721,6 +722,7 @@ endif
 define rule_rustc_library
 	$(call cmd_and_fixdep,rustc_library)
 	$(call cmd,gen_objtooldep)
+	$(call cmd,gen_min_eh_framedep)
 	$(call cmd,gendwarfksyms)
 endef
 
diff --git a/scripts/Makefile b/scripts/Makefile
index d7fbb7ca098b..c392610b65dd 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -12,6 +12,7 @@ hostprogs-always-$(CONFIG_SYSTEM_EXTRA_CERTIFICATE)	+= insert-sys-cert
 hostprogs-always-$(CONFIG_RUST_KERNEL_DOCTESTS)		+= rustdoc_test_builder
 hostprogs-always-$(CONFIG_RUST_KERNEL_DOCTESTS)		+= rustdoc_test_gen
 hostprogs-always-$(CONFIG_TRACEPOINTS)			+= tracepoint-update
+hostprogs-always-$(CONFIG_UNWINDER_DWARF_CFI_MINIFY)	+= min_eh_frame
 
 kallsyms-objs := kallsyms.o kallsyms-sysmap.o elf-parse.o
 sorttable-objs := sorttable.o elf-parse.o
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 6127feb970c6..ced0f630f566 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -281,6 +281,10 @@ ifdef CONFIG_OBJTOOL
 $(obj)/%.o: private objtool-enabled = $(if $(is-standard-object),$(if $(delay-objtool),$(is-single-obj-m),y))
 endif
 
+ifdef CONFIG_UNWINDER_DWARF_CFI_MINIFY
+$(obj)/%.o: private min-eh-frame-enabled = $(if $(filter-out scripts/mod/empty.o,$@),$(is-standard-object))
+endif
+
 ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
 cmd_warn_shared_object = $(if $(word 2, $(modname-multi)),$(warning $(kbuild-file): $*.o is added to multiple modules: $(modname-multi)))
 endif
@@ -371,11 +375,13 @@ quiet_cmd_rustc_o_rs = $(RUSTC_OR_CLIPPY_QUIET) $(quiet_modtag) $@
 		$(CC) $(CLANG_FLAGS) $(filter-out $(CC_FLAGS_LTO),$(KBUILD_CFLAGS)) \
 		$(CC_FLAGS_RUST_INLINE_HELPERS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@ \
 		$(cmd_ld_single)) \
-	$(cmd_objtool)
+	$(cmd_objtool) \
+	$(cmd_min_eh_frame)
 
 define rule_rustc_o_rs
 	$(call cmd_and_fixdep,rustc_o_rs)
 	$(call cmd,gen_objtooldep)
+	$(call cmd,gen_min_eh_framedep)
 endef
 
 $(obj)/%.o: $(obj)/%.rs FORCE
@@ -518,14 +524,16 @@ $(obj)/lib.a: $(lib-y) FORCE
 	$(call if_changed,ar)
 
 quiet_cmd_ld_multi_m = LD [M]  $@
-      cmd_ld_multi_m = $(LD) $(ld_flags) -r -o $@ @$< $(cmd_objtool)
+      cmd_ld_multi_m = $(LD) $(ld_flags) -r -o $@ @$< $(cmd_objtool) $(cmd_min_eh_frame)
 
 define rule_ld_multi_m
 	$(call cmd_and_savecmd,ld_multi_m)
 	$(call cmd,gen_objtooldep)
+	$(call cmd,gen_min_eh_framedep)
 endef
 
 $(multi-obj-m): private objtool-enabled := $(delay-objtool)
+$(multi-obj-m): private min-eh-frame-enabled := $(CONFIG_LTO_CLANG)
 $(multi-obj-m): private part-of-module := y
 $(multi-obj-m): %.o: %.mod FORCE
 	$(call if_changed_rule,ld_multi_m)
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 19e96b30a122..b27bcd50daf7 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -222,6 +222,12 @@ objtool-enabled := y
 
 endif # CONFIG_OBJTOOL
 
+ifdef CONFIG_UNWINDER_DWARF_CFI_MINIFY
+min_eh_frame := $(objtree)/scripts/min_eh_frame
+cmd_min_eh_frame = $(if $(min-eh-frame-enabled), ; $(min_eh_frame) $@)
+cmd_gen_min_eh_framedep = $(if $(min-eh-frame-enabled), { echo ; echo '$@: $$(wildcard $(min_eh_frame))' ; } >> $(dot-target).cmd)
+endif
+
 # Useful for describing the dependency of composite objects
 # Usage:
 #   $(call multi_depend, multi_used_targets, suffix_to_remove, suffix_to_add)
@@ -265,7 +271,8 @@ endif
 quiet_cmd_cc_o_c = CC $(quiet_modtag)  $@
       cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $< \
 		$(cmd_ld_single) \
-		$(cmd_objtool)
+		$(cmd_objtool) \
+		$(cmd_min_eh_frame)
 
 define rule_cc_o_c
 	$(call cmd_and_fixdep,cc_o_c)
@@ -273,17 +280,19 @@ define rule_cc_o_c
 	$(call cmd,checksrc)
 	$(call cmd,checkdoc)
 	$(call cmd,gen_objtooldep)
+	$(call cmd,gen_min_eh_framedep)
 	$(call cmd,gen_symversions_c)
 	$(call cmd,record_mcount)
 	$(call cmd,warn_shared_object)
 endef
 
 quiet_cmd_as_o_S = AS $(quiet_modtag)  $@
-      cmd_as_o_S = $(CC) $(a_flags) -c -o $@ $< $(cmd_objtool)
+      cmd_as_o_S = $(CC) $(a_flags) -c -o $@ $< $(cmd_objtool) $(cmd_min_eh_frame)
 
 define rule_as_o_S
 	$(call cmd_and_fixdep,as_o_S)
 	$(call cmd,gen_objtooldep)
+	$(call cmd,gen_min_eh_framedep)
 	$(call cmd,gen_symversions_S)
 	$(call cmd,warn_shared_object)
 endef
diff --git a/scripts/Makefile.vmlinux_o b/scripts/Makefile.vmlinux_o
index 0b37bd5dc3a4..160d43fbb393 100644
--- a/scripts/Makefile.vmlinux_o
+++ b/scripts/Makefile.vmlinux_o
@@ -52,6 +52,10 @@ vmlinux-objtool-args-$(if $(KLP_SYMIDS),y)		+= --klp-symids
 
 objtool-args = $(vmlinux-objtool-args-y) --link
 
+ifdef CONFIG_UNWINDER_DWARF_CFI_MINIFY
+min-eh-frame-enabled := $(CONFIG_LTO_CLANG)
+endif
+
 # Link of vmlinux.o used for section mismatch analysis
 # ---------------------------------------------------------------------------
 
@@ -64,13 +68,15 @@ quiet_cmd_ld_vmlinux.o = LD      $@
 	$(addprefix -T , $(initcalls-lds)) \
 	--whole-archive vmlinux.a --no-whole-archive \
 	--start-group $(KBUILD_VMLINUX_LIBS) --end-group \
-	$(cmd_objtool)
+	$(cmd_objtool) \
+	$(cmd_min_eh_frame)
 
 cmd_check_function_names = $(srctree)/scripts/check-function-names.sh $@
 
 define rule_ld_vmlinux.o
 	$(call cmd_and_savecmd,ld_vmlinux.o)
 	$(call cmd,gen_objtooldep)
+	$(call cmd,gen_min_eh_framedep)
 	$(call cmd,check_function_names)
 endef
 
diff --git a/scripts/min_eh_frame.c b/scripts/min_eh_frame.c
new file mode 100644
index 000000000000..4138a2f69dcd
--- /dev/null
+++ b/scripts/min_eh_frame.c
@@ -0,0 +1,1719 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MIT
+/*
+ * min_eh_frame.c - Build-time .eh_frame minifier for Minimal DWARF CFI.
+ *
+ * Rewrites ET_REL (.o) .eh_frame and .rela.eh_frame sections in place so only
+ * Minimal DWARF CFA bytecodes remain:
+ *  - Strips general-purpose register spills/restores (keeping only SP, FP, RA)
+ *  - Strips DW_CFA_GNU_args_size and redundant remember_state/restore_state
+ *  - Coalesces adjacent DW_CFA_advance_loc* instructions and drops trailing
+ *    PC-advance instructions after the last state transition
+ *  - Drops FDEs (and their relocations) that use unsupported DWARF expressions
+ */
+
+#include <elf.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
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
+#ifndef EM_RISCV
+#define EM_RISCV				243
+#endif
+
+#ifndef SHT_X86_64_UNWIND
+#define SHT_X86_64_UNWIND			0x70000001U
+#endif
+
+#define DW_OP_deref				0x06
+#define DW_OP_breg0				0x70
+
+#define DW_EH_PE_omit				0xff
+#define DW_EH_PE_FORM				0x0f
+#define DW_EH_PE_absptr				0x00
+#define DW_EH_PE_udata2				0x02
+#define DW_EH_PE_udata4				0x03
+#define DW_EH_PE_udata8				0x04
+#define DW_EH_PE_sdata2				0x0a
+#define DW_EH_PE_sdata4				0x0b
+#define DW_EH_PE_sdata8				0x0c
+#define DW_EH_PE_indirect			0x80
+
+/* Target architecture DWARF register numbers for SP, FP, and RA. */
+struct arch_cfg {
+	uint8_t addr_size;
+	uint8_t sp_reg;
+	uint8_t fp_reg;
+	uint8_t ra_reg;
+};
+
+/* Abstract Minimal DWARF unwind row tracked while filtering CFA opcodes. */
+struct min_row {
+	int32_t cfa_off;
+	int32_t fp_off;
+	int32_t ra_off;
+	uint8_t cfa_kind; /* 0=undef, 1=reg, 2=fp_indirect, 3=sp_indirect */
+	uint8_t cfa_reg;
+	uint8_t fp_rule;  /* 0=same, 1=cfa_off, 2=fp_off, 3=undef, 4=sp_off */
+	uint8_t ra_rule;  /* 0=same, 1=cfa_off, 3=undef, 4=sp_off */
+	bool ra_signed;
+};
+
+/* Parsed CIE metadata and its rewritten offset in the minified .eh_frame. */
+struct cie_info {
+	size_t old_off;
+	size_t new_off;
+	uint32_t code_align;
+	int32_t data_align;
+	uint8_t ra_reg;
+	uint8_t fde_enc;
+	bool has_z;
+	bool is_signal;
+	struct min_row init_row;
+};
+
+/*
+ * Buffered output event emitted by minify_insns(). Adjacent non-relocated
+ * PC-advance events are coalesced before serialization, whereas relocated
+ * DW_CFA_advance_loc* instructions (e.g. RISC-V R_RISCV_ADD/SUB pairs) are
+ * preserved verbatim with their original byte offsets recorded for relocation
+ * remapping.
+ */
+struct out_event {
+	bool is_adv;
+	bool has_reloc;
+	uint32_t adv;
+	size_t orig_off;
+	size_t new_off;
+	uint8_t bytes[16];
+	size_t len;
+};
+
+/* Mapping from an input relocated CFA instruction span to its new offset. */
+struct reloc_map {
+	size_t orig_off;
+	size_t len;
+	size_t new_off;
+};
+
+/* Wrapper preserving original .rela.eh_frame order across r_offset sorting. */
+struct indexed_rela {
+	Elf64_Rela rela;
+	size_t orig_idx;
+};
+
+/* Monotonic mapping anchor from an input .eh_frame span to output .eh_frame. */
+struct eh_anchor {
+	size_t old_off;
+	size_t len;
+	size_t new_off;
+};
+
+/* Sorted list of .eh_frame anchors for updating section-local symbols/relocs. */
+struct anchor_list {
+	struct eh_anchor *data;
+	size_t len;
+	size_t cap;
+};
+
+/* Growable output byte buffer. */
+struct byte_buf {
+	uint8_t *data;
+	size_t len;
+	size_t cap;
+};
+
+static void buf_append(struct byte_buf *b, const void *src, size_t n)
+{
+	if (!n)
+		return;
+	if (b->len + n > b->cap) {
+		size_t ncap = b->cap ? b->cap * 2 : 4096;
+
+		while (ncap < b->len + n)
+			ncap *= 2;
+		b->data = realloc(b->data, ncap);
+		if (!b->data) {
+			perror("realloc");
+			exit(1);
+		}
+		b->cap = ncap;
+	}
+	memcpy(b->data + b->len, src, n);
+	b->len += n;
+}
+
+static void buf_append_u8(struct byte_buf *b, uint8_t v)
+{
+	buf_append(b, &v, 1);
+}
+
+static uint16_t get_le16(const uint8_t *p)
+{
+	return (uint16_t)p[0] | ((uint16_t)p[1] << 8);
+}
+
+static uint32_t get_le32(const uint8_t *p)
+{
+	return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
+	       ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
+}
+
+static void put_le16(uint8_t *p, uint16_t v)
+{
+	p[0] = (uint8_t)v;
+	p[1] = (uint8_t)(v >> 8);
+}
+
+static void put_le32(uint8_t *p, uint32_t v)
+{
+	p[0] = (uint8_t)v;
+	p[1] = (uint8_t)(v >> 8);
+	p[2] = (uint8_t)(v >> 16);
+	p[3] = (uint8_t)(v >> 24);
+}
+
+static int read_uleb128(const uint8_t *buf, size_t *pos, size_t end, uint32_t *out)
+{
+	uint32_t val = 0;
+	unsigned int shift = 0;
+
+	while (*pos < end) {
+		uint8_t b = buf[(*pos)++];
+
+		if (shift == 28 && ((b & 0x7f) > 0x0f || (b & 0x80)))
+			return -1;
+		val |= (uint32_t)(b & 0x7f) << shift;
+		if (!(b & 0x80)) {
+			*out = val;
+			return 0;
+		}
+		shift += 7;
+	}
+	return -1;
+}
+
+static int read_sleb128(const uint8_t *buf, size_t *pos, size_t end, int32_t *out)
+{
+	uint32_t val = 0;
+	unsigned int shift = 0;
+
+	while (*pos < end) {
+		uint8_t b = buf[(*pos)++];
+
+		if (shift == 28) {
+			uint8_t top = b & 0x78;
+
+			if ((b & 0x80) || (top != 0x00 && top != 0x78))
+				return -1;
+		}
+		val |= (uint32_t)(b & 0x7f) << shift;
+		shift += 7;
+		if (!(b & 0x80)) {
+			if (shift < 32 && (b & 0x40))
+				val |= ~0U << shift;
+			*out = (int32_t)val;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+static size_t encode_uleb128(uint32_t val, uint8_t *out)
+{
+	size_t n = 0;
+
+	do {
+		uint8_t b = val & 0x7f;
+
+		val >>= 7;
+		if (val)
+			b |= 0x80;
+		out[n++] = b;
+	} while (val);
+	return n;
+}
+
+static size_t encode_sleb128(int32_t val, uint8_t *out)
+{
+	size_t n = 0;
+	bool more = true;
+
+	while (more) {
+		uint8_t b = val & 0x7f;
+
+		val >>= 7;
+		if ((val == 0 && !(b & 0x40)) || (val == -1 && (b & 0x40)))
+			more = false;
+		else
+			b |= 0x80;
+		out[n++] = b;
+	}
+	return n;
+}
+
+static int ptr_enc_size(uint8_t enc, uint8_t addr_size)
+{
+	if (enc == DW_EH_PE_omit)
+		return 0;
+	switch (enc & DW_EH_PE_FORM) {
+	case DW_EH_PE_absptr:
+		return addr_size;
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
+		return -1;
+	}
+}
+
+static bool rows_equal(const struct min_row *a, const struct min_row *b)
+{
+	if (a->cfa_kind != b->cfa_kind || a->cfa_off != b->cfa_off ||
+	    a->fp_rule != b->fp_rule || a->ra_rule != b->ra_rule ||
+	    a->ra_signed != b->ra_signed)
+		return false;
+	if (a->cfa_kind == 1 && a->cfa_reg != b->cfa_reg)
+		return false;
+	if ((a->fp_rule == 1 || a->fp_rule == 2 || a->fp_rule == 4) &&
+	    a->fp_off != b->fp_off)
+		return false;
+	if ((a->ra_rule == 1 || a->ra_rule == 4) &&
+	    a->ra_off != b->ra_off)
+		return false;
+	return true;
+}
+
+static int mul_s32(int64_t a, int64_t b, int32_t *out)
+{
+	int64_t prod = a * b;
+
+	if (prod < INT32_MIN || prod > INT32_MAX)
+		return -1;
+	*out = (int32_t)prod;
+	return 0;
+}
+
+static int add_adv_u32(uint32_t *acc, uint32_t delta)
+{
+	if (UINT32_MAX - *acc < delta)
+		return -1;
+	*acc += delta;
+	return 0;
+}
+
+static bool has_reloc_in_range(const Elf64_Rela *relas, size_t nrelas,
+			       size_t lo, size_t hi)
+{
+	for (size_t i = 0; i < nrelas; i++) {
+		if (relas[i].r_offset >= lo && relas[i].r_offset < hi)
+			return true;
+	}
+	return false;
+}
+
+static void flush_adv_bytes(struct byte_buf *out_bytes, uint32_t *acc)
+{
+	uint8_t abuf[5];
+	uint32_t v = *acc;
+
+	if (!v)
+		return;
+	if (v <= 0x3f) {
+		abuf[0] = 0x40 | (uint8_t)v;
+		buf_append(out_bytes, abuf, 1);
+	} else if (v <= 0xff) {
+		abuf[0] = DW_CFA_advance_loc1;
+		abuf[1] = (uint8_t)v;
+		buf_append(out_bytes, abuf, 2);
+	} else if (v <= 0xffff) {
+		abuf[0] = DW_CFA_advance_loc2;
+		put_le16(abuf + 1, (uint16_t)v);
+		buf_append(out_bytes, abuf, 3);
+	} else {
+		abuf[0] = DW_CFA_advance_loc4;
+		put_le32(abuf + 1, v);
+		buf_append(out_bytes, abuf, 5);
+	}
+	*acc = 0;
+}
+
+/*
+ * Filter a CIE or FDE instruction stream down to Minimal DWARF CFA opcodes:
+ *  - Drop untracked GPR spills/restores, DW_CFA_nop, and DW_CFA_GNU_args_size
+ *  - Elide redundant state transitions and empty remember_state/restore_state
+ *  - Coalesce non-relocated DW_CFA_advance_loc* ops into minimal encodings and
+ *    drop trailing PC advances after the final state change
+ *  - Return -1 if an FDE uses opcodes or DWARF expressions outside the Minimal
+ *    DWARF subset so the caller can drop that FDE cleanly.
+ */
+static int minify_insns(const uint8_t *insns, size_t end, size_t insns_eh_off,
+			const Elf64_Rela *insn_relas, size_t n_insn_relas,
+			const struct cie_info *cie, const struct arch_cfg *arch,
+			bool is_cie, struct min_row *io_row,
+			struct byte_buf *out_bytes,
+			struct reloc_map **out_rmaps, size_t *out_nrmaps)
+{
+	size_t cap = end + 16;
+	struct out_event *evs = calloc(cap, sizeof(*evs));
+	size_t nev = 0;
+	uint32_t pending_adv = 0;
+	struct min_row row = *io_row;
+	struct min_row cie_base = *io_row;
+	struct {
+		struct min_row saved;
+		size_t ev_idx;
+	} stack[4];
+	unsigned int sp = 0;
+	size_t pos = 0;
+	int ret = -1;
+
+	if (!evs)
+		return -1;
+
+#define EMIT_OP(raw_ptr, raw_len) do {					\
+	if (pending_adv > 0 && !is_cie) {				\
+		evs[nev].is_adv = true;					\
+		evs[nev].adv = pending_adv;				\
+		nev++;							\
+		pending_adv = 0;					\
+	}								\
+	evs[nev].is_adv = false;					\
+	evs[nev].len = (raw_len);					\
+	memcpy(evs[nev].bytes, (raw_ptr), (raw_len));			\
+	nev++;								\
+} while (0)
+
+#define EMIT_REL_ADV(op_pos, op_len) do {				\
+	if (pending_adv > 0 && !is_cie) {				\
+		evs[nev].is_adv = true;					\
+		evs[nev].adv = pending_adv;				\
+		nev++;							\
+		pending_adv = 0;					\
+	}								\
+	evs[nev].is_adv = true;						\
+	evs[nev].has_reloc = true;					\
+	evs[nev].orig_off = insns_eh_off + (op_pos);			\
+	evs[nev].len = (op_len);					\
+	memcpy(evs[nev].bytes, insns + (op_pos), (op_len));		\
+	nev++;								\
+} while (0)
+
+	while (pos < end) {
+		size_t op_start = pos;
+		uint8_t op = insns[pos++];
+		uint8_t hi = op & 0xc0;
+		uint8_t lo = op & 0x3f;
+		uint8_t tmp[16];
+		size_t tn;
+		uint32_t reg, uval;
+		int32_t sval;
+
+		if (nev + 2 >= cap) {
+			struct out_event *nevs;
+
+			cap *= 2;
+			nevs = realloc(evs, cap * sizeof(*evs));
+			if (!nevs)
+				goto out;
+			evs = nevs;
+		}
+
+		if (hi == 0x40) {
+			if (!is_cie && n_insn_relas &&
+			    has_reloc_in_range(insn_relas, n_insn_relas,
+					       insns_eh_off + op_start,
+					       insns_eh_off + pos)) {
+				EMIT_REL_ADV(op_start, 1);
+				continue;
+			}
+			if (add_adv_u32(&pending_adv, lo))
+				goto out;
+			continue;
+		}
+		if (hi == 0x80) {
+			if (read_uleb128(insns, &pos, end, &uval))
+				goto out;
+			if (lo == arch->fp_reg || lo == cie->ra_reg) {
+				int32_t off;
+
+				if (mul_s32(uval, cie->data_align, &off))
+					goto out;
+
+				if (lo == arch->fp_reg &&
+				    (row.fp_rule != 1 || row.fp_off != off)) {
+					row.fp_rule = 1;
+					row.fp_off = off;
+					tmp[0] = 0x80 | lo;
+					tn = 1 + encode_uleb128(uval, tmp + 1);
+					EMIT_OP(tmp, tn);
+				} else if (lo == cie->ra_reg &&
+					   (row.ra_rule != 1 || row.ra_off != off)) {
+					row.ra_rule = 1;
+					row.ra_off = off;
+					tmp[0] = 0x80 | lo;
+					tn = 1 + encode_uleb128(uval, tmp + 1);
+					EMIT_OP(tmp, tn);
+				}
+			}
+			continue;
+		}
+		if (hi == 0xc0) {
+			if (lo == arch->fp_reg &&
+			    (row.fp_rule != cie_base.fp_rule ||
+			     ((cie_base.fp_rule == 1 || cie_base.fp_rule == 2 ||
+			       cie_base.fp_rule == 4) &&
+			      row.fp_off != cie_base.fp_off))) {
+				row.fp_rule = cie_base.fp_rule;
+				row.fp_off = cie_base.fp_off;
+				tmp[0] = 0xc0 | lo;
+				EMIT_OP(tmp, 1);
+			} else if (lo == cie->ra_reg &&
+				   (row.ra_rule != cie_base.ra_rule ||
+				    ((cie_base.ra_rule == 1 ||
+				      cie_base.ra_rule == 4) &&
+				     row.ra_off != cie_base.ra_off))) {
+				row.ra_rule = cie_base.ra_rule;
+				row.ra_off = cie_base.ra_off;
+				tmp[0] = 0xc0 | lo;
+				EMIT_OP(tmp, 1);
+			}
+			continue;
+		}
+
+		switch (op) {
+		case DW_CFA_nop:
+			break;
+		case DW_CFA_advance_loc1:
+			if (pos + 1 > end)
+				goto out;
+			pos += 1;
+			if (!is_cie && n_insn_relas &&
+			    has_reloc_in_range(insn_relas, n_insn_relas,
+					       insns_eh_off + op_start,
+					       insns_eh_off + pos)) {
+				EMIT_REL_ADV(op_start, 2);
+				break;
+			}
+			if (add_adv_u32(&pending_adv, insns[op_start + 1]))
+				goto out;
+			break;
+		case DW_CFA_advance_loc2:
+			if (pos + 2 > end)
+				goto out;
+			pos += 2;
+			if (!is_cie && n_insn_relas &&
+			    has_reloc_in_range(insn_relas, n_insn_relas,
+					       insns_eh_off + op_start,
+					       insns_eh_off + pos)) {
+				EMIT_REL_ADV(op_start, 3);
+				break;
+			}
+			if (add_adv_u32(&pending_adv, get_le16(insns + op_start + 1)))
+				goto out;
+			break;
+		case DW_CFA_advance_loc4:
+			if (pos + 4 > end)
+				goto out;
+			pos += 4;
+			if (!is_cie && n_insn_relas &&
+			    has_reloc_in_range(insn_relas, n_insn_relas,
+					       insns_eh_off + op_start,
+					       insns_eh_off + pos)) {
+				EMIT_REL_ADV(op_start, 5);
+				break;
+			}
+			if (add_adv_u32(&pending_adv, get_le32(insns + op_start + 1)))
+				goto out;
+			break;
+		case DW_CFA_def_cfa:
+			if (read_uleb128(insns, &pos, end, &reg) ||
+			    read_uleb128(insns, &pos, end, &uval) ||
+			    reg > 255 || uval > INT32_MAX)
+				goto out;
+			if (row.cfa_kind != 1 || row.cfa_reg != reg ||
+			    row.cfa_off != (int32_t)uval) {
+				row.cfa_kind = 1;
+				row.cfa_reg = (uint8_t)reg;
+				row.cfa_off = (int32_t)uval;
+				tmp[0] = DW_CFA_def_cfa;
+				tn = 1 + encode_uleb128(reg, tmp + 1);
+				tn += encode_uleb128(uval, tmp + tn);
+				EMIT_OP(tmp, tn);
+			}
+			break;
+		case DW_CFA_def_cfa_sf:
+			if (read_uleb128(insns, &pos, end, &reg) ||
+			    read_sleb128(insns, &pos, end, &sval) || reg > 255 ||
+			    mul_s32(sval, cie->data_align, &row.cfa_off))
+				goto out;
+			row.cfa_kind = 1;
+			row.cfa_reg = (uint8_t)reg;
+			tmp[0] = DW_CFA_def_cfa_sf;
+			tn = 1 + encode_uleb128(reg, tmp + 1);
+			tn += encode_sleb128(sval, tmp + tn);
+			EMIT_OP(tmp, tn);
+			break;
+		case DW_CFA_def_cfa_register:
+			if (row.cfa_kind != 1 ||
+			    read_uleb128(insns, &pos, end, &reg) || reg > 255)
+				goto out;
+			if (row.cfa_reg != reg) {
+				row.cfa_reg = (uint8_t)reg;
+				tmp[0] = DW_CFA_def_cfa_register;
+				tn = 1 + encode_uleb128(reg, tmp + 1);
+				EMIT_OP(tmp, tn);
+			}
+			break;
+		case DW_CFA_def_cfa_offset:
+			if (row.cfa_kind != 1 ||
+			    read_uleb128(insns, &pos, end, &uval) ||
+			    uval > INT32_MAX)
+				goto out;
+			if (row.cfa_off != (int32_t)uval) {
+				row.cfa_off = (int32_t)uval;
+				tmp[0] = DW_CFA_def_cfa_offset;
+				tn = 1 + encode_uleb128(uval, tmp + 1);
+				EMIT_OP(tmp, tn);
+			}
+			break;
+		case DW_CFA_def_cfa_offset_sf:
+			if (row.cfa_kind != 1 ||
+			    read_sleb128(insns, &pos, end, &sval) ||
+			    mul_s32(sval, cie->data_align, &row.cfa_off))
+				goto out;
+			tmp[0] = DW_CFA_def_cfa_offset_sf;
+			tn = 1 + encode_sleb128(sval, tmp + 1);
+			EMIT_OP(tmp, tn);
+			break;
+		case DW_CFA_offset_extended:
+			if (read_uleb128(insns, &pos, end, &reg) ||
+			    read_uleb128(insns, &pos, end, &uval))
+				goto out;
+			if (reg == arch->fp_reg || reg == cie->ra_reg) {
+				int32_t off;
+
+				if (mul_s32(uval, cie->data_align, &off))
+					goto out;
+
+				if (reg == arch->fp_reg) {
+					row.fp_rule = 1;
+					row.fp_off = off;
+				} else {
+					row.ra_rule = 1;
+					row.ra_off = off;
+				}
+				tmp[0] = DW_CFA_offset_extended;
+				tn = 1 + encode_uleb128(reg, tmp + 1);
+				tn += encode_uleb128(uval, tmp + tn);
+				EMIT_OP(tmp, tn);
+			}
+			break;
+		case DW_CFA_offset_extended_sf:
+			if (read_uleb128(insns, &pos, end, &reg) ||
+			    read_sleb128(insns, &pos, end, &sval))
+				goto out;
+			if (reg == arch->fp_reg || reg == cie->ra_reg) {
+				int32_t off;
+
+				if (mul_s32(sval, cie->data_align, &off))
+					goto out;
+
+				if (reg == arch->fp_reg) {
+					row.fp_rule = 1;
+					row.fp_off = off;
+				} else {
+					row.ra_rule = 1;
+					row.ra_off = off;
+				}
+				tmp[0] = DW_CFA_offset_extended_sf;
+				tn = 1 + encode_uleb128(reg, tmp + 1);
+				tn += encode_sleb128(sval, tmp + tn);
+				EMIT_OP(tmp, tn);
+			}
+			break;
+		case DW_CFA_GNU_negative_offset_extended:
+			if (read_uleb128(insns, &pos, end, &reg) ||
+			    read_uleb128(insns, &pos, end, &uval))
+				goto out;
+			if (reg == arch->fp_reg || reg == cie->ra_reg) {
+				int32_t off;
+
+				if (mul_s32(-(int64_t)uval, cie->data_align, &off))
+					goto out;
+
+				if (reg == arch->fp_reg) {
+					row.fp_rule = 1;
+					row.fp_off = off;
+				} else {
+					row.ra_rule = 1;
+					row.ra_off = off;
+				}
+				tmp[0] = DW_CFA_GNU_negative_offset_extended;
+				tn = 1 + encode_uleb128(reg, tmp + 1);
+				tn += encode_uleb128(uval, tmp + tn);
+				EMIT_OP(tmp, tn);
+			}
+			break;
+		case DW_CFA_restore_extended:
+			if (read_uleb128(insns, &pos, end, &reg))
+				goto out;
+			if (reg == arch->fp_reg) {
+				row.fp_rule = cie_base.fp_rule;
+				row.fp_off = cie_base.fp_off;
+				tmp[0] = DW_CFA_restore_extended;
+				tn = 1 + encode_uleb128(reg, tmp + 1);
+				EMIT_OP(tmp, tn);
+			} else if (reg == cie->ra_reg) {
+				row.ra_rule = cie_base.ra_rule;
+				row.ra_off = cie_base.ra_off;
+				tmp[0] = DW_CFA_restore_extended;
+				tn = 1 + encode_uleb128(reg, tmp + 1);
+				EMIT_OP(tmp, tn);
+			}
+			break;
+		case DW_CFA_undefined:
+			if (read_uleb128(insns, &pos, end, &reg))
+				goto out;
+			if (reg == arch->fp_reg || reg == cie->ra_reg) {
+				if (reg == arch->fp_reg) {
+					row.fp_rule = 3;
+					row.fp_off = 0;
+				} else {
+					row.ra_rule = 3;
+					row.ra_off = 0;
+				}
+				tmp[0] = DW_CFA_undefined;
+				tn = 1 + encode_uleb128(reg, tmp + 1);
+				EMIT_OP(tmp, tn);
+			}
+			break;
+		case DW_CFA_same_value:
+			if (read_uleb128(insns, &pos, end, &reg))
+				goto out;
+			if (reg == arch->fp_reg || reg == cie->ra_reg) {
+				if (reg == arch->fp_reg) {
+					row.fp_rule = 0;
+					row.fp_off = 0;
+				} else {
+					row.ra_rule = 0;
+					row.ra_off = 0;
+				}
+				tmp[0] = DW_CFA_same_value;
+				tn = 1 + encode_uleb128(reg, tmp + 1);
+				EMIT_OP(tmp, tn);
+			}
+			break;
+		case DW_CFA_remember_state:
+			if (sp >= 4)
+				goto out;
+			tmp[0] = DW_CFA_remember_state;
+			EMIT_OP(tmp, 1);
+			stack[sp].saved = row;
+			stack[sp].ev_idx = nev - 1;
+			sp++;
+			break;
+		case DW_CFA_restore_state:
+			if (!sp)
+				goto out;
+			sp--;
+			if (!rows_equal(&stack[sp].saved, &row)) {
+				row = stack[sp].saved;
+				tmp[0] = DW_CFA_restore_state;
+				EMIT_OP(tmp, 1);
+			} else {
+				/*
+				 * Elide dead remember_state..restore_state if
+				 * no minimal ops occurred inside.
+				 */
+				size_t ridx = stack[sp].ev_idx;
+				bool only_adv = true;
+				uint32_t extra = 0;
+
+				for (size_t k = ridx + 1; k < nev; k++) {
+					if (!evs[k].is_adv || evs[k].has_reloc) {
+						only_adv = false;
+						break;
+					}
+					if (add_adv_u32(&extra, evs[k].adv))
+						goto out;
+				}
+				if (only_adv) {
+					if (add_adv_u32(&pending_adv, extra))
+						goto out;
+					nev = ridx;
+				} else {
+					tmp[0] = DW_CFA_restore_state;
+					EMIT_OP(tmp, 1);
+				}
+			}
+			break;
+		case DW_CFA_AARCH64_negate_ra_state:
+			if (arch->ra_reg != 30)
+				goto out;
+			row.ra_signed = !row.ra_signed;
+			tmp[0] = DW_CFA_AARCH64_negate_ra_state;
+			EMIT_OP(tmp, 1);
+			break;
+		case DW_CFA_GNU_args_size:
+			if (read_uleb128(insns, &pos, end, &uval))
+				goto out;
+			break;
+		case DW_CFA_register:
+		case DW_CFA_val_offset:
+			if (read_uleb128(insns, &pos, end, &reg) ||
+			    read_uleb128(insns, &pos, end, &uval))
+				goto out;
+			if (reg == arch->sp_reg || reg == arch->fp_reg ||
+			    reg == cie->ra_reg)
+				goto out;
+			break;
+		case DW_CFA_val_offset_sf:
+			if (read_uleb128(insns, &pos, end, &reg) ||
+			    read_sleb128(insns, &pos, end, &sval))
+				goto out;
+			if (reg == arch->sp_reg || reg == arch->fp_reg ||
+			    reg == cie->ra_reg)
+				goto out;
+			break;
+		case DW_CFA_def_cfa_expression: {
+			size_t epos = 1;
+
+			if (read_uleb128(insns, &pos, end, &uval) ||
+			    uval > end - pos || uval < 3 || uval > 7)
+				goto out;
+			if ((insns[pos] != (uint8_t)(DW_OP_breg0 + arch->fp_reg) &&
+			     insns[pos] != (uint8_t)(DW_OP_breg0 + arch->sp_reg)) ||
+			    insns[pos + uval - 1] != DW_OP_deref ||
+			    read_sleb128(insns + pos, &epos, uval - 1, &sval) ||
+			    epos != uval - 1)
+				goto out;
+			row.cfa_kind = (insns[pos] == (uint8_t)(DW_OP_breg0 + arch->fp_reg)) ?
+				       2 : 3;
+			row.cfa_reg = 0;
+			row.cfa_off = sval;
+			tmp[0] = DW_CFA_def_cfa_expression;
+			tn = 1 + encode_uleb128(uval, tmp + 1);
+			memcpy(tmp + tn, insns + pos, uval);
+			tn += uval;
+			pos += uval;
+			EMIT_OP(tmp, tn);
+			break;
+		}
+		case DW_CFA_expression: {
+			size_t epos = 1;
+
+			if (read_uleb128(insns, &pos, end, &reg) ||
+			    read_uleb128(insns, &pos, end, &uval) ||
+			    uval > end - pos)
+				goto out;
+			if (reg == arch->fp_reg || reg == cie->ra_reg) {
+				uint8_t fp_op = DW_OP_breg0 + arch->fp_reg;
+				uint8_t sp_op = DW_OP_breg0 + arch->sp_reg;
+				uint8_t b0 = insns[pos];
+
+				if (uval < 2 || uval > 6 ||
+				    (b0 != fp_op && b0 != sp_op) ||
+				    (reg == cie->ra_reg && b0 != sp_op) ||
+				    read_sleb128(insns + pos, &epos, uval, &sval) ||
+				    epos != uval)
+					goto out;
+				if (reg == arch->fp_reg) {
+					row.fp_rule = (b0 == fp_op) ? 2 : 4;
+					row.fp_off = sval;
+				} else {
+					row.ra_rule = 4;
+					row.ra_off = sval;
+				}
+				tmp[0] = DW_CFA_expression;
+				tn = 1 + encode_uleb128(reg, tmp + 1);
+				tn += encode_uleb128(uval, tmp + tn);
+				memcpy(tmp + tn, insns + pos, uval);
+				tn += uval;
+				pos += uval;
+				EMIT_OP(tmp, tn);
+			} else if (reg == arch->sp_reg) {
+				if (uval < 2 || uval > 6 || row.cfa_kind != 3 ||
+				    insns[pos] != (uint8_t)(DW_OP_breg0 + arch->sp_reg) ||
+				    read_sleb128(insns + pos, &epos, uval, &sval) ||
+				    epos != uval || sval != row.cfa_off)
+					goto out;
+				pos += uval;
+			} else {
+				pos += uval;
+			}
+			break;
+		}
+		case DW_CFA_val_expression:
+			if (read_uleb128(insns, &pos, end, &reg) ||
+			    read_uleb128(insns, &pos, end, &uval) ||
+			    pos + uval > end)
+				goto out;
+			if (reg == arch->sp_reg || reg == arch->fp_reg ||
+			    reg == cie->ra_reg)
+				goto out;
+			pos += uval;
+			break;
+		default:
+			goto out;
+		}
+	}
+
+	/* Drop trailing advance_loc instructions */
+	while (nev > 0 && evs[nev - 1].is_adv)
+		nev--;
+
+	{
+		uint32_t acc = 0;
+		size_t nrm = 0;
+
+		for (size_t i = 0; i < nev; i++) {
+			if (evs[i].is_adv && !evs[i].has_reloc) {
+				if (add_adv_u32(&acc, evs[i].adv))
+					goto out;
+			} else {
+				flush_adv_bytes(out_bytes, &acc);
+				evs[i].new_off = out_bytes->len;
+				if (evs[i].has_reloc)
+					nrm++;
+				buf_append(out_bytes, evs[i].bytes, evs[i].len);
+			}
+		}
+
+		if (nrm && out_rmaps && out_nrmaps) {
+			struct reloc_map *rm = calloc(nrm, sizeof(*rm));
+			size_t idx = 0;
+
+			if (!rm)
+				goto out;
+			for (size_t i = 0; i < nev; i++) {
+				if (!evs[i].has_reloc)
+					continue;
+				rm[idx].orig_off = evs[i].orig_off;
+				rm[idx].len = evs[i].len;
+				rm[idx].new_off = evs[i].new_off;
+				idx++;
+			}
+			*out_rmaps = rm;
+			*out_nrmaps = nrm;
+		}
+	}
+
+	*io_row = row;
+	ret = 0;
+out:
+#undef EMIT_REL_ADV
+#undef EMIT_OP
+	free(evs);
+	return ret;
+}
+
+static int anchor_add(struct anchor_list *al, size_t old_off, size_t len,
+		      size_t new_off)
+{
+	if (al->len == al->cap) {
+		size_t ncap = al->cap ? al->cap * 2 : 128;
+		struct eh_anchor *nd = realloc(al->data, ncap * sizeof(*nd));
+
+		if (!nd)
+			return -1;
+		al->data = nd;
+		al->cap = ncap;
+	}
+	al->data[al->len++] = (struct eh_anchor){ old_off, len, new_off };
+	return 0;
+}
+
+static int anchor_find_exact(const struct anchor_list *al, size_t old_off,
+			     size_t *out_new_off)
+{
+	size_t lo = 0, hi = al->len;
+
+	while (lo < hi) {
+		size_t mid = lo + (hi - lo) / 2;
+
+		if (al->data[mid].old_off <= old_off)
+			lo = mid + 1;
+		else
+			hi = mid;
+	}
+	if (!lo)
+		return -1;
+	lo--;
+	if (old_off == al->data[lo].old_off ||
+	    old_off - al->data[lo].old_off < al->data[lo].len) {
+		*out_new_off = al->data[lo].new_off +
+			       (old_off - al->data[lo].old_off);
+		return 0;
+	}
+	return -1;
+}
+
+static size_t anchor_clamp_map(const struct anchor_list *al, size_t old_off,
+			       size_t max_new)
+{
+	size_t mapped = 0;
+
+	if (anchor_find_exact(al, old_off, &mapped) == 0)
+		return mapped <= max_new ? mapped : max_new;
+
+	for (size_t i = al->len; i-- > 0;) {
+		if (al->data[i].old_off <= old_off) {
+			size_t end_new = al->data[i].new_off + al->data[i].len;
+
+			return end_new <= max_new ? end_new : max_new;
+		}
+	}
+	return 0;
+}
+
+static bool sym_is_in_eh_frame(const Elf64_Sym *sym, size_t sym_i,
+			       uint32_t eh_idx, const uint32_t *shndx_tab,
+			       size_t nshndx)
+{
+	if (sym->st_shndx == SHN_XINDEX)
+		return shndx_tab && sym_i < nshndx && shndx_tab[sym_i] == eh_idx;
+	if (sym->st_shndx >= SHN_LORESERVE)
+		return false;
+	return sym->st_shndx == eh_idx;
+}
+
+static int cmp_rela_off(const void *a, const void *b)
+{
+	const struct indexed_rela *ra = a;
+	const struct indexed_rela *rb = b;
+
+	if (ra->rela.r_offset != rb->rela.r_offset)
+		return (ra->rela.r_offset > rb->rela.r_offset) -
+		       (ra->rela.r_offset < rb->rela.r_offset);
+	return (ra->orig_idx > rb->orig_idx) - (ra->orig_idx < rb->orig_idx);
+}
+
+static size_t lower_bound_rela(const Elf64_Rela *relas, size_t nrelas, size_t off)
+{
+	size_t lo = 0, hi = nrelas;
+
+	while (lo < hi) {
+		size_t mid = lo + (hi - lo) / 2;
+
+		if (relas[mid].r_offset < off)
+			lo = mid + 1;
+		else
+			hi = mid;
+	}
+	return lo;
+}
+
+static int remap_fde_relocs(const Elf64_Rela *loc_relas, size_t n_loc_relas,
+			    size_t max_out_relas, size_t loc_off,
+			    size_t new_fde_off,
+			    const Elf64_Rela *insn_relas, size_t n_insn_relas,
+			    const struct reloc_map *rmaps, size_t nrmaps,
+			    size_t new_insns_base,
+			    Elf64_Rela *out_relas, size_t *out_nrelas)
+{
+	for (size_t r = 0; r < n_loc_relas; r++) {
+		if (*out_nrelas >= max_out_relas)
+			return -1;
+		out_relas[*out_nrelas] = loc_relas[r];
+		out_relas[(*out_nrelas)++].r_offset =
+			new_fde_off + 8 + (loc_relas[r].r_offset - loc_off);
+	}
+
+	for (size_t m = 0; m < nrmaps; m++) {
+		size_t lo = rmaps[m].orig_off;
+		size_t hi = lo + rmaps[m].len;
+
+		for (size_t r = 0; r < n_insn_relas; r++) {
+			if (insn_relas[r].r_offset < lo ||
+			    insn_relas[r].r_offset >= hi)
+				continue;
+			if (*out_nrelas >= max_out_relas)
+				return -1;
+			out_relas[*out_nrelas] = insn_relas[r];
+			out_relas[(*out_nrelas)++].r_offset =
+				new_insns_base + rmaps[m].new_off +
+				(insn_relas[r].r_offset - lo);
+		}
+	}
+	return 0;
+}
+
+static int parse_cie_record(const uint8_t *eh_in, size_t p, size_t rec_end,
+			    const struct arch_cfg *arch, struct cie_info *cie,
+			    size_t *out_insns_off)
+{
+	uint8_t ver;
+	const char *aug;
+	size_t aug_len_str;
+	uint32_t ra_col;
+
+	if (p >= rec_end)
+		return -1;
+	ver = eh_in[p++];
+	aug = (const char *)(eh_in + p);
+	aug_len_str = strnlen(aug, rec_end - p);
+	if (p + aug_len_str >= rec_end)
+		return -1;
+	p += aug_len_str + 1;
+	if (ver == 4) {
+		if (p + 2 > rec_end)
+			return -1;
+		p += 2;
+	}
+	if (read_uleb128(eh_in, &p, rec_end, &cie->code_align) ||
+	    read_sleb128(eh_in, &p, rec_end, &cie->data_align))
+		return -1;
+	if (ver == 1) {
+		if (p >= rec_end)
+			return -1;
+		ra_col = eh_in[p++];
+	} else if (read_uleb128(eh_in, &p, rec_end, &ra_col)) {
+		return -1;
+	}
+	cie->ra_reg = (uint8_t)ra_col;
+	cie->fde_enc = DW_EH_PE_absptr;
+
+	if (aug[0] == 'z') {
+		uint32_t alen;
+		size_t aend;
+
+		cie->has_z = true;
+		if (read_uleb128(eh_in, &p, rec_end, &alen) ||
+		    alen > rec_end - p)
+			return -1;
+		aend = p + alen;
+		for (size_t k = 1; aug[k]; k++) {
+			uint8_t penc;
+			int psz;
+
+			if (aug[k] == 'R') {
+				if (p >= aend)
+					return -1;
+				cie->fde_enc = eh_in[p++];
+				if (cie->fde_enc & DW_EH_PE_indirect)
+					return -1;
+			} else if (aug[k] == 'L') {
+				if (p >= aend)
+					return -1;
+				p++;
+			} else if (aug[k] == 'P') {
+				if (p >= aend)
+					return -1;
+				penc = eh_in[p++];
+				psz = ptr_enc_size(penc & ~DW_EH_PE_indirect,
+						   arch->addr_size);
+				if (psz < 0 || (size_t)psz > aend - p)
+					return -1;
+				p += (size_t)psz;
+			} else if (aug[k] == 'S') {
+				cie->is_signal = true;
+			} else if (aug[k] != 'B') {
+				return -1;
+			}
+		}
+		p = aend;
+	} else if (aug[0] != '\0') {
+		return -1;
+	}
+
+	*out_insns_off = p;
+	return 0;
+}
+
+/*
+ * Rewrite a 64-bit little-endian ET_REL object's .eh_frame and .rela.eh_frame
+ * sections in place. Objects with unexpected formats or external relocations
+ * into .eh_frame are left untouched (returning 0) so the build never breaks on
+ * unusual hand-crafted assembly objects.
+ */
+static int process_elf64(uint8_t *map, size_t file_size)
+{
+	Elf64_Ehdr *ehdr = (Elf64_Ehdr *)map;
+	Elf64_Shdr *shdrs;
+	uint32_t shnum, shstrndx;
+	const char *shstrtab;
+	Elf64_Shdr *eh_shdr = NULL, *rela_shdr = NULL, *sym_shdr = NULL;
+	uint32_t eh_idx = 0, sym_idx = 0;
+	Elf64_Sym *syms = NULL;
+	size_t nsyms = 0, nshndx = 0;
+	const uint32_t *shndx_tab = NULL;
+	struct arch_cfg arch;
+	const uint8_t *eh_in;
+	size_t eh_in_len;
+	Elf64_Rela *sorted_relas = NULL;
+	size_t nrelas = 0, out_nrelas = 0;
+	Elf64_Rela *out_relas = NULL;
+	struct cie_info *cies = NULL;
+	size_t ncies = 0, cies_cap = 0;
+	struct anchor_list anchors = {};
+	struct byte_buf out_eh = {};
+	size_t last_len_pos = 0;
+	bool have_last_rec = false;
+	size_t pos = 0;
+
+	if (ehdr->e_type != ET_REL)
+		return 0;
+
+	if (ehdr->e_machine == EM_X86_64)
+		arch = (struct arch_cfg){ 8, 7, 6, 16 };
+	else if (ehdr->e_machine == EM_AARCH64)
+		arch = (struct arch_cfg){ 8, 31, 29, 30 };
+	else if (ehdr->e_machine == EM_RISCV)
+		arch = (struct arch_cfg){ 8, 2, 8, 1 };
+	else
+		return 0;
+
+	if (!ehdr->e_shoff || (ehdr->e_shoff & 7) ||
+	    ehdr->e_shoff > file_size ||
+	    file_size - ehdr->e_shoff < sizeof(Elf64_Shdr))
+		return 0;
+	if (ehdr->e_shentsize != sizeof(Elf64_Shdr))
+		return -1;
+
+	shdrs = (Elf64_Shdr *)(map + ehdr->e_shoff);
+	shnum = ehdr->e_shnum ? ehdr->e_shnum : (uint32_t)shdrs[0].sh_size;
+	if (!shnum ||
+	    (size_t)shnum > (file_size - ehdr->e_shoff) / sizeof(Elf64_Shdr))
+		return -1;
+	shstrndx = (ehdr->e_shstrndx != SHN_XINDEX) ?
+		   ehdr->e_shstrndx : shdrs[0].sh_link;
+
+	if (!shstrndx || shstrndx >= shnum ||
+	    shdrs[shstrndx].sh_offset > file_size ||
+	    shdrs[shstrndx].sh_size == 0 ||
+	    shdrs[shstrndx].sh_size > file_size - shdrs[shstrndx].sh_offset)
+		return -1;
+	shstrtab = (const char *)(map + shdrs[shstrndx].sh_offset);
+
+	for (uint32_t i = 1; i < shnum; i++) {
+		size_t shstr_size = shdrs[shstrndx].sh_size;
+		uint32_t nm_off = shdrs[i].sh_name;
+
+		if ((shdrs[i].sh_type == SHT_PROGBITS ||
+		     shdrs[i].sh_type == SHT_X86_64_UNWIND) &&
+		    nm_off < shstr_size &&
+		    shstr_size - nm_off >= sizeof(".eh_frame") &&
+		    memcmp(shstrtab + nm_off, ".eh_frame",
+			   sizeof(".eh_frame")) == 0) {
+			eh_shdr = &shdrs[i];
+			eh_idx = i;
+			break;
+		}
+	}
+
+	if (!eh_shdr || eh_shdr->sh_size == 0)
+		return 0;
+	if (eh_shdr->sh_offset > file_size ||
+	    eh_shdr->sh_size > file_size - eh_shdr->sh_offset ||
+	    eh_shdr->sh_addralign > 16 ||
+	    (eh_shdr->sh_addralign & (eh_shdr->sh_addralign - 1)) != 0)
+		return -1;
+
+	for (uint32_t i = 1; i < shnum; i++) {
+		if (shdrs[i].sh_type == SHT_RELA && shdrs[i].sh_info == eh_idx) {
+			rela_shdr = &shdrs[i];
+			break;
+		}
+	}
+
+	if (rela_shdr && rela_shdr->sh_link > 0 && rela_shdr->sh_link < shnum &&
+	    shdrs[rela_shdr->sh_link].sh_type == SHT_SYMTAB) {
+		sym_idx = rela_shdr->sh_link;
+		sym_shdr = &shdrs[sym_idx];
+	} else {
+		for (uint32_t i = 1; i < shnum; i++) {
+			if (shdrs[i].sh_type == SHT_SYMTAB) {
+				sym_idx = i;
+				sym_shdr = &shdrs[i];
+				break;
+			}
+		}
+	}
+
+	if (sym_shdr && sym_shdr->sh_size > 0) {
+		if ((sym_shdr->sh_offset & 7) ||
+		    sym_shdr->sh_offset > file_size ||
+		    sym_shdr->sh_size > file_size - sym_shdr->sh_offset ||
+		    sym_shdr->sh_entsize != sizeof(Elf64_Sym) ||
+		    (sym_shdr->sh_size % sizeof(Elf64_Sym)) != 0)
+			return -1;
+		syms = (Elf64_Sym *)(map + sym_shdr->sh_offset);
+		nsyms = sym_shdr->sh_size / sizeof(Elf64_Sym);
+
+		for (uint32_t i = 1; i < shnum; i++) {
+			if (shdrs[i].sh_type == SHT_SYMTAB_SHNDX &&
+			    shdrs[i].sh_link == sym_idx) {
+				if ((shdrs[i].sh_offset & 3) ||
+				    shdrs[i].sh_offset > file_size ||
+				    shdrs[i].sh_size > file_size - shdrs[i].sh_offset ||
+				    shdrs[i].sh_entsize != sizeof(uint32_t) ||
+				    shdrs[i].sh_size != nsyms * sizeof(uint32_t))
+					return -1;
+				shndx_tab = (const uint32_t *)(map + shdrs[i].sh_offset);
+				nshndx = nsyms;
+				break;
+			}
+		}
+
+		/*
+		 * Bail out cleanly if any other relocation section references
+		 * symbols inside .eh_frame.
+		 */
+		for (uint32_t i = 1; i < shnum; i++) {
+			const Elf64_Rela *other;
+			size_t nother;
+
+			if (&shdrs[i] == rela_shdr || shdrs[i].sh_type != SHT_RELA ||
+			    shdrs[i].sh_link != sym_idx || shdrs[i].sh_size == 0)
+				continue;
+			if ((shdrs[i].sh_offset & 7) ||
+			    shdrs[i].sh_offset > file_size ||
+			    shdrs[i].sh_size > file_size - shdrs[i].sh_offset ||
+			    shdrs[i].sh_entsize != sizeof(Elf64_Rela) ||
+			    (shdrs[i].sh_size % sizeof(Elf64_Rela)) != 0)
+				return -1;
+			other = (const Elf64_Rela *)(map + shdrs[i].sh_offset);
+			nother = shdrs[i].sh_size / sizeof(Elf64_Rela);
+			for (size_t r = 0; r < nother; r++) {
+				uint32_t si = ELF64_R_SYM(other[r].r_info);
+
+				if (si < nsyms &&
+				    sym_is_in_eh_frame(&syms[si], si, eh_idx,
+						       shndx_tab, nshndx))
+					return 0;
+			}
+		}
+	}
+
+	eh_in = map + eh_shdr->sh_offset;
+	eh_in_len = eh_shdr->sh_size;
+	if (rela_shdr && rela_shdr->sh_size > 0) {
+		struct indexed_rela *idx_relas;
+		const Elf64_Rela *raw_relas;
+
+		if ((rela_shdr->sh_offset & 7) ||
+		    rela_shdr->sh_offset > file_size ||
+		    rela_shdr->sh_size > file_size - rela_shdr->sh_offset ||
+		    rela_shdr->sh_entsize != sizeof(Elf64_Rela) ||
+		    (rela_shdr->sh_size % sizeof(Elf64_Rela)) != 0)
+			return -1;
+		nrelas = rela_shdr->sh_size / sizeof(Elf64_Rela);
+		idx_relas = malloc(nrelas * sizeof(*idx_relas));
+		sorted_relas = malloc(nrelas * sizeof(Elf64_Rela));
+		out_relas = calloc(nrelas, sizeof(Elf64_Rela));
+		if (!idx_relas || !sorted_relas || !out_relas) {
+			free(idx_relas);
+			free(sorted_relas);
+			free(out_relas);
+			return -1;
+		}
+		raw_relas = (const Elf64_Rela *)(map + rela_shdr->sh_offset);
+		for (size_t i = 0; i < nrelas; i++) {
+			idx_relas[i].rela = raw_relas[i];
+			idx_relas[i].orig_idx = i;
+		}
+		qsort(idx_relas, nrelas, sizeof(*idx_relas), cmp_rela_off);
+		for (size_t i = 0; i < nrelas; i++)
+			sorted_relas[i] = idx_relas[i].rela;
+		free(idx_relas);
+	}
+
+	if (anchor_add(&anchors, /*old_off=*/0, /*len=*/0, /*new_off=*/0))
+		goto bail;
+
+	while (pos + 4 <= eh_in_len) {
+		uint32_t len = get_le32(eh_in + pos);
+		size_t rec_start = pos;
+		size_t rec_end, p;
+		uint32_t cie_id;
+
+		if (len == 0)
+			break;
+		if (len <= 4 || len == 0xffffffffU ||
+		    len > eh_in_len - pos - 4) {
+			free(anchors.data);
+			free(cies);
+			free(sorted_relas);
+			free(out_eh.data);
+			free(out_relas);
+			return -1;
+		}
+		rec_end = pos + 4 + len;
+		cie_id = get_le32(eh_in + pos + 4);
+		p = pos + 8;
+
+		if (cie_id == 0) {
+			struct cie_info cie = {};
+			struct byte_buf min_cie_insns = {};
+			struct byte_buf cie_rec = {};
+			const char *out_aug;
+			uint8_t tmp[16];
+			size_t tn;
+
+			if (parse_cie_record(eh_in, p, rec_end, &arch, &cie, &p))
+				goto bail;
+			if (ncies >= cies_cap) {
+				size_t ncap = cies_cap ? cies_cap * 2 : 64;
+				struct cie_info *ncies_arr;
+
+				ncies_arr = realloc(cies, ncap * sizeof(*cies));
+				if (!ncies_arr)
+					goto bail;
+				cies = ncies_arr;
+				cies_cap = ncap;
+			}
+
+			cie.old_off = rec_start;
+			cie.new_off = out_eh.len;
+			if (minify_insns(eh_in + p, rec_end - p, p,
+					 /*insn_relas=*/NULL,
+					 /*n_insn_relas=*/0, &cie, &arch,
+					 /*is_cie=*/true, &cie.init_row,
+					 &min_cie_insns, /*out_rmaps=*/NULL,
+					 /*out_nrmaps=*/NULL)) {
+				free(min_cie_insns.data);
+				goto bail;
+			}
+
+			/* Emit normalized compact CIE (version 1, "zR" or "zRS") */
+			out_aug = cie.is_signal ? "zRS" : "zR";
+			if (cie.fde_enc == DW_EH_PE_absptr && !cie.has_z)
+				out_aug = "";
+
+			put_le32(tmp, 0);
+			put_le32(tmp + 4, 0);
+			buf_append(&cie_rec, tmp, 8);
+			buf_append_u8(&cie_rec, 1);
+			buf_append(&cie_rec, out_aug, strlen(out_aug) + 1);
+			tn = encode_uleb128(cie.code_align, tmp);
+			buf_append(&cie_rec, tmp, tn);
+			tn = encode_sleb128(cie.data_align, tmp);
+			buf_append(&cie_rec, tmp, tn);
+			buf_append_u8(&cie_rec, cie.ra_reg);
+			if (out_aug[0] == 'z') {
+				buf_append_u8(&cie_rec, 1);
+				buf_append_u8(&cie_rec, cie.fde_enc);
+			}
+			buf_append(&cie_rec, min_cie_insns.data, min_cie_insns.len);
+			while (cie_rec.len & 3)
+				buf_append_u8(&cie_rec, DW_CFA_nop);
+			put_le32(cie_rec.data, (uint32_t)(cie_rec.len - 4));
+
+			last_len_pos = out_eh.len;
+			have_last_rec = true;
+			if (anchor_add(&anchors, rec_start, /*len=*/8,
+				       cie.new_off)) {
+				free(min_cie_insns.data);
+				free(cie_rec.data);
+				goto bail;
+			}
+			buf_append(&out_eh, cie_rec.data, cie_rec.len);
+
+			cies[ncies++] = cie;
+			free(min_cie_insns.data);
+			free(cie_rec.data);
+		} else {
+			size_t old_cie_off;
+			const struct cie_info *cie = NULL;
+			int ptr_sz;
+			size_t loc_off, fde_insns_off;
+			struct min_row fde_row;
+			struct byte_buf min_fde_insns = {};
+			struct byte_buf fde_rec = {};
+			size_t new_fde_off;
+			uint8_t hdr8[8];
+			struct reloc_map *rmaps = NULL;
+			size_t nrmaps = 0;
+			const Elf64_Rela *loc_relas = NULL, *insn_relas = NULL;
+			size_t n_loc_relas = 0, n_insn_relas = 0;
+
+			if (cie_id > rec_start + 4)
+				goto bail;
+			old_cie_off = (rec_start + 4) - cie_id;
+			for (size_t k = ncies; k-- > 0;) {
+				if (cies[k].old_off == old_cie_off) {
+					cie = &cies[k];
+					break;
+				}
+			}
+			if (!cie)
+				goto bail;
+
+			ptr_sz = ptr_enc_size(cie->fde_enc, arch.addr_size);
+			if (ptr_sz <= 0 || p + 2 * (size_t)ptr_sz > rec_end)
+				goto bail;
+			loc_off = p;
+			p += 2 * (size_t)ptr_sz;
+
+			if (cie->has_z) {
+				uint32_t alen;
+
+				if (read_uleb128(eh_in, &p, rec_end, &alen) ||
+				    p + alen > rec_end)
+					goto bail;
+				p += alen;
+			}
+			fde_insns_off = p;
+			fde_row = cie->init_row;
+
+			if (nrelas) {
+				size_t l_lo = lower_bound_rela(sorted_relas,
+							       nrelas, loc_off);
+				size_t l_hi = lower_bound_rela(sorted_relas,
+							       nrelas,
+							       loc_off + 2 * (size_t)ptr_sz);
+				size_t i_lo = lower_bound_rela(sorted_relas,
+							       nrelas,
+							       fde_insns_off);
+				size_t i_hi = lower_bound_rela(sorted_relas,
+							       nrelas, rec_end);
+
+				loc_relas = sorted_relas + l_lo;
+				n_loc_relas = l_hi - l_lo;
+				insn_relas = sorted_relas + i_lo;
+				n_insn_relas = i_hi - i_lo;
+			}
+
+			if (minify_insns(eh_in + fde_insns_off,
+					 rec_end - fde_insns_off,
+					 fde_insns_off, insn_relas,
+					 n_insn_relas, cie, &arch,
+					 /*is_cie=*/false, &fde_row,
+					 &min_fde_insns, &rmaps,
+					 &nrmaps) == 0) {
+				size_t new_insns_base;
+
+				new_fde_off = out_eh.len;
+				put_le32(hdr8, 0);
+				put_le32(hdr8 + 4,
+					 (uint32_t)((new_fde_off + 4) - cie->new_off));
+				buf_append(&fde_rec, hdr8, 8);
+				buf_append(&fde_rec, eh_in + loc_off,
+					   2 * (size_t)ptr_sz);
+				if (cie->has_z || cie->is_signal ||
+				    cie->fde_enc != DW_EH_PE_absptr)
+					buf_append_u8(&fde_rec, 0);
+				new_insns_base = new_fde_off + fde_rec.len;
+				buf_append(&fde_rec, min_fde_insns.data,
+					   min_fde_insns.len);
+				while (fde_rec.len & 3)
+					buf_append_u8(&fde_rec, DW_CFA_nop);
+				put_le32(fde_rec.data,
+					 (uint32_t)(fde_rec.len - 4));
+
+				if (remap_fde_relocs(loc_relas, n_loc_relas,
+						     nrelas, loc_off,
+						     new_fde_off, insn_relas,
+						     n_insn_relas, rmaps,
+						     nrmaps, new_insns_base,
+						     out_relas, &out_nrelas)) {
+					free(rmaps);
+					free(min_fde_insns.data);
+					free(fde_rec.data);
+					goto bail;
+				}
+
+				if (anchor_add(&anchors, rec_start,
+					       8 + 2 * (size_t)ptr_sz,
+					       new_fde_off) ||
+				    anchor_add(&anchors, fde_insns_off,
+					       /*len=*/0, new_insns_base)) {
+					free(rmaps);
+					free(min_fde_insns.data);
+					free(fde_rec.data);
+					goto bail;
+				}
+				for (size_t m = 0; m < nrmaps; m++) {
+					if (anchor_add(&anchors,
+						       rmaps[m].orig_off,
+						       rmaps[m].len,
+						       new_insns_base + rmaps[m].new_off)) {
+						free(rmaps);
+						free(min_fde_insns.data);
+						free(fde_rec.data);
+						goto bail;
+					}
+				}
+
+				last_len_pos = out_eh.len;
+				have_last_rec = true;
+				buf_append(&out_eh, fde_rec.data, fde_rec.len);
+			}
+			free(rmaps);
+			/* Unsupported FDEs are cleanly dropped along with their relocs */
+			free(min_fde_insns.data);
+			free(fde_rec.data);
+		}
+
+		pos = rec_end;
+	}
+
+	/* Pad final record with DW_CFA_nop to section alignment (8 bytes) */
+	if (have_last_rec && eh_shdr->sh_addralign > 4) {
+		size_t align = eh_shdr->sh_addralign;
+
+		while (out_eh.len & (align - 1))
+			buf_append_u8(&out_eh, DW_CFA_nop);
+		put_le32(out_eh.data + last_len_pos,
+			 (uint32_t)(out_eh.len - last_len_pos - 4));
+	}
+
+	if (anchor_add(&anchors, pos, /*len=*/0, out_eh.len) ||
+	    anchor_add(&anchors, eh_in_len, /*len=*/0, out_eh.len))
+		goto bail;
+
+	/*
+	 * Update any .rela.eh_frame relocations whose target symbol resides in
+	 * .eh_frame (e.g. R_RISCV_SUB32 subtracting FDE initial_location).
+	 */
+	for (size_t r = 0; r < out_nrelas; r++) {
+		uint32_t si = ELF64_R_SYM(out_relas[r].r_info);
+		int64_t old_target;
+		size_t new_target, new_sym_val;
+
+		if (!si)
+			continue;
+		if (!syms || si >= nsyms)
+			goto bail;
+		if (!sym_is_in_eh_frame(&syms[si], si, eh_idx, shndx_tab, nshndx))
+			continue;
+
+		old_target = (int64_t)syms[si].st_value + out_relas[r].r_addend;
+		if (old_target <= 0 || (uint64_t)old_target > eh_in_len ||
+		    anchor_find_exact(&anchors, (size_t)old_target, &new_target))
+			goto bail;
+
+		if (ELF64_ST_TYPE(syms[si].st_info) == STT_SECTION) {
+			out_relas[r].r_addend = (int64_t)new_target -
+						(int64_t)syms[si].st_value;
+		} else {
+			if (syms[si].st_value > eh_in_len ||
+			    anchor_find_exact(&anchors, (size_t)syms[si].st_value,
+					      &new_sym_val))
+				goto bail;
+			out_relas[r].r_addend = (int64_t)new_target -
+						(int64_t)new_sym_val;
+		}
+	}
+
+	if (have_last_rec && out_eh.data && out_eh.len <= eh_in_len) {
+		if (syms) {
+			for (size_t s = 1; s < nsyms; s++) {
+				if (!sym_is_in_eh_frame(&syms[s], s, eh_idx,
+							shndx_tab, nshndx) ||
+				    ELF64_ST_TYPE(syms[s].st_info) == STT_SECTION)
+					continue;
+				syms[s].st_value = anchor_clamp_map(&anchors,
+						(size_t)syms[s].st_value,
+						out_eh.len);
+			}
+		}
+		memcpy(map + eh_shdr->sh_offset, out_eh.data, out_eh.len);
+		eh_shdr->sh_size = out_eh.len;
+		if (rela_shdr && out_relas) {
+			memcpy(map + rela_shdr->sh_offset, out_relas,
+			       out_nrelas * sizeof(Elf64_Rela));
+			rela_shdr->sh_size = out_nrelas * sizeof(Elf64_Rela);
+		}
+	}
+
+	free(anchors.data);
+	free(cies);
+	free(sorted_relas);
+	free(out_eh.data);
+	free(out_relas);
+	return 0;
+
+bail:
+	/* Leave unusual/hand-crafted .eh_frame untouched rather than failing build */
+	free(anchors.data);
+	free(cies);
+	free(sorted_relas);
+	free(out_eh.data);
+	free(out_relas);
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	for (int i = 1; i < argc; i++) {
+		const char *path = argv[i];
+		struct stat st;
+		uint8_t *map;
+		int fd, rc = 0;
+
+		fd = open(path, O_RDWR);
+		if (fd < 0) {
+			perror(path);
+			return 1;
+		}
+		if (fstat(fd, &st) < 0) {
+			perror("fstat");
+			close(fd);
+			return 1;
+		}
+		if ((size_t)st.st_size < sizeof(Elf64_Ehdr)) {
+			close(fd);
+			continue;
+		}
+		map = mmap(/*addr=*/NULL, (size_t)st.st_size,
+			   PROT_READ | PROT_WRITE, MAP_SHARED, fd,
+			   /*offset=*/0);
+		if (map == MAP_FAILED) {
+			perror("mmap");
+			close(fd);
+			return 1;
+		}
+		if (memcmp(map, ELFMAG, SELFMAG) == 0 &&
+		    map[EI_DATA] == ELFDATA2LSB &&
+		    map[EI_CLASS] == ELFCLASS64)
+			rc = process_elf64(map, (size_t)st.st_size);
+
+		munmap(map, (size_t)st.st_size);
+		close(fd);
+		if (rc)
+			return 1;
+	}
+	return 0;
+}
-- 
2.56.1.750.gf70dc682cf-goog

