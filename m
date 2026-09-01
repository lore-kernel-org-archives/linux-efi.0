Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFCD485509;
	Tue,  1 Sep 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281855; cv=none; b=rbMMO2zFMP+2WmrtpJFHCcFq15iyqCwGiXQMIKk/Jjgbhuq99qf09qAq+CNuY2ybDMsb4TIGTpkcp6Ty2fEr8WoffEuHAG0zSNSDIbvWgwLGujrSFpbPxCiBI3BtYyzGwYcVlp7T+TeAFkGFhI+9xTNEan5UngCKzJbbSFexNoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281855; c=relaxed/simple;
	bh=6ACAmfuXfuayPo9P9g+Tv5LmBGEjhYAQa2wbUFO4lTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdPNF4RLwjoJy9FqrubRIY4MjFriZxhA46/0qvj6TkWsZsFG6u4A22l7ak0RTB1FtKicvm/wU1RWGN2XRd0ar53jpPrnt3rBgB7BGwJa7sCmTYbu+3FNXrEtaL7Jax2SGAEUSAqOMoCwEfxRO+vyge21Sh0+/l+UOm6LmABNiSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=McJBLdbI; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="McJBLdbI"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id 33CB820B700D; Tue,  1 Sep 2026 09:56:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 33CB820B700D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281815;
	bh=hQRN4nwUQeOBU7mz2RGA5hRCIuLQcM69ucNk/JxMyq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McJBLdbIW34shC6NMxxZowCBbWf/pha9V9i+9tjZkpTT0ieqmUv5i8DdSqK5u6KXH
	 9tzHtrXxmw5I4AC/gdYenlH8uhNSfdfX5QFy4IcA4WNTiYvhJNe9O8+HnNY4RferGx
	 UyOxDVK2MZxmT8ShmihDRUfuoUlXMegLoWSzIKgk=
From: Thara Gopinath <tgopinath@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	ardb@kernel.org,
	ilias.apalodimas@linaro.org
Cc: James.Bottomley@HansenPartnership.com,
	"longli@microsoft.com--cc=tzimmermann"@suse.de, javierm@redhat.com,
	lszubowi@redhat.com, francescopompo2@gmail.com,
	tgopinath@microsoft.com, x86@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Thara Gopinath <tgopinath@linux.microsoft.com>
Subject: [RFC PATCH 10/12] arch: x86: hyperv: hv_vtl_vsm: Introduce vtlcall
Date: Tue,  1 Sep 2026 09:55:24 -0700
Message-ID: <20260901165647.3160413-11-tgopinath@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A vtlcall is the mechanism by which a lower VTL (VTL0) transitions
into a higher VTL (VTL1) on Microsoft Hyper-V. It is issued as a
call to a fixed offset within the hypercall page; the hypervisor
saves the lower-VTL context, restores the upper-VTL context, and
resumes execution at the upper VTL. Control returns to VTL0 when
the upper VTL executes a vtlreturn.

Introduce the x86 VTL0-side vtlcall infrastructure:

  - hv_vsm_vtlcall(): runtime entry point. Preserves state VTL1 can
    clobber (IRQs, FPU, CR2) and invokes the assembly trampoline.
    Returns the signed 64-bit status the secure kernel places in a3.

  - hv_vsm_init_vtlcall(u64 vtl_call_offset): one-shot initializer
    that installs the vtlcall target into a static_call. The offset
    is passed in by the caller so the register read stays outside
    arch code, mirroring mshv_vtl_return_call_init().

  - struct hv_vtlcall_param and CONFIG_HYPERV_VSM API in
    include/hyperv/vsm.h, with no-op stubs when VSM is disabled.

  - __hv_vsm_vtlcall assembly trampoline in mshv_vtl_asm.S, plus
    asm-offsets for the argument block.

Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 arch/x86/hyperv/Makefile           |  2 +-
 arch/x86/hyperv/hv_vtl_vsm.c       | 29 ++++++++++++
 arch/x86/hyperv/mshv-asm-offsets.c |  8 ++++
 arch/x86/hyperv/mshv_vtl_asm.S     | 75 ++++++++++++++++++++++++++++++
 include/hyperv/vsm.h               | 22 +++++++++
 5 files changed, 135 insertions(+), 1 deletion(-)

diff --git a/arch/x86/hyperv/Makefile b/arch/x86/hyperv/Makefile
index 1fdc20e239243..430f5f2bca40a 100644
--- a/arch/x86/hyperv/Makefile
+++ b/arch/x86/hyperv/Makefile
@@ -2,7 +2,7 @@
 obj-y			:= hv_init.o mmu.o nested.o irqdomain.o ivm.o
 obj-$(CONFIG_X86_64)	+= hv_apic.o
 obj-$(CONFIG_HYPERV_VTL_MODE)	+= hv_vtl.o mshv_vtl_asm.o
-obj-$(CONFIG_HYPERV_VSM)	+= hv_vtl_vsm.o
+obj-$(CONFIG_HYPERV_VSM)	+= hv_vtl_vsm.o mshv_vtl_asm.o
 
 $(obj)/mshv_vtl_asm.o: $(obj)/mshv-asm-offsets.h
 
diff --git a/arch/x86/hyperv/hv_vtl_vsm.c b/arch/x86/hyperv/hv_vtl_vsm.c
index edc55264c4d87..d533a8e113935 100644
--- a/arch/x86/hyperv/hv_vtl_vsm.c
+++ b/arch/x86/hyperv/hv_vtl_vsm.c
@@ -15,6 +15,7 @@
 #include <hyperv/vsm.h>
 #include <asm/msr-index.h>
 #include <asm/processor-flags.h>
+#include <hyperv/hvgdk_mini.h>
 #include <asm/mshyperv.h>
 
 /* Define PAGE size and related variables for initial secure kernel pages */
@@ -256,3 +257,31 @@ void __init hv_vsm_arch_init_vp(struct hv_init_vp_context *vp_ctx, Elf64_Addr sk
 	hv_vsm_init_gdt(vp_ctx, sk_pa);
 	hv_vsm_init_page_tables(vp_ctx, sk_pa);
 }
+
+/* Implemented in mshv_vtl_asm.S */
+void __hv_vsm_vtlcall(struct hv_vtlcall_param *args);
+
+DEFINE_STATIC_CALL_NULL(__hv_vsm_vtlcall_hypercall, void (*)(void));
+
+void __init hv_vsm_init_vtlcall(u64 vtl_call_offset)
+{
+	static_call_update(__hv_vsm_vtlcall_hypercall,
+			   (void *)((u8 *)hv_hypercall_pg + vtl_call_offset));
+}
+
+s64 hv_vsm_vtlcall(struct hv_vtlcall_param *args)
+{
+	unsigned long flags;
+	u64 cr2;
+
+	local_irq_save(flags);
+	kernel_fpu_begin_mask(0);
+	cr2 = native_read_cr2();
+	__hv_vsm_vtlcall(args);
+	native_write_cr2(cr2);
+	kernel_fpu_end();
+	local_irq_restore(flags);
+
+	/* The secure kernel returns a signed 64-bit status in a3. */
+	return (s64)args->a3;
+}
diff --git a/arch/x86/hyperv/mshv-asm-offsets.c b/arch/x86/hyperv/mshv-asm-offsets.c
index 882c1db6df16c..0f0470ddaee59 100644
--- a/arch/x86/hyperv/mshv-asm-offsets.c
+++ b/arch/x86/hyperv/mshv-asm-offsets.c
@@ -12,6 +12,7 @@
 #define COMPILE_OFFSETS
 
 #include <linux/kbuild.h>
+#include <hyperv/vsm.h>
 #include <asm/mshyperv.h>
 
 static void __used common(void)
@@ -34,4 +35,11 @@ static void __used common(void)
 		OFFSET(MSHV_VTL_CPU_CONTEXT_r15, mshv_vtl_cpu_context, r15);
 		OFFSET(MSHV_VTL_CPU_CONTEXT_cr2, mshv_vtl_cpu_context, cr2);
 	}
+
+	if (IS_ENABLED(CONFIG_HYPERV_VSM)) {
+		OFFSET(HV_VTLCALL_PARAM_a0, hv_vtlcall_param, a0);
+		OFFSET(HV_VTLCALL_PARAM_a1, hv_vtlcall_param, a1);
+		OFFSET(HV_VTLCALL_PARAM_a2, hv_vtlcall_param, a2);
+		OFFSET(HV_VTLCALL_PARAM_a3, hv_vtlcall_param, a3);
+	}
 }
diff --git a/arch/x86/hyperv/mshv_vtl_asm.S b/arch/x86/hyperv/mshv_vtl_asm.S
index f595eefad9abf..4d7007848ecd4 100644
--- a/arch/x86/hyperv/mshv_vtl_asm.S
+++ b/arch/x86/hyperv/mshv_vtl_asm.S
@@ -15,6 +15,8 @@
 #include <asm/frame.h>
 #include "mshv-asm-offsets.h"
 
+#ifdef CONFIG_HYPERV_VTL_MODE
+
 	.text
 	.section .noinstr.text, "ax"
 /*
@@ -114,3 +116,76 @@ SYM_FUNC_END(__mshv_vtl_return_call)
 	.size	mshv_vtl_return_sym, 8
 mshv_vtl_return_sym:
 	.quad	__SCK____mshv_vtl_return_hypercall
+
+#endif /* CONFIG_HYPERV_VTL_MODE */
+
+#ifdef CONFIG_HYPERV_VSM
+	.text
+/*
+ * void __hv_vsm_vtlcall(struct hv_vtlcall_param *args)
+ *
+ * Perform a VTL call to switch to the upper VTL.
+ *
+ * The %rcx register is zeroed before the call and is clobbered by the
+ * hypercall. %rax is not restored by the upper VTL (passed via the assist
+ * page) but is unused and can be ignored.
+ *
+ * The args pointer is preserved on the stack across the VTL call since all
+ * argument registers are repurposed during the VTL call.
+ *
+ * Microsoft Hypervisor preserves %rsp during VTL switches.
+ */
+SYM_FUNC_START(__hv_vsm_vtlcall)
+	/* Save callee-saved registers */
+	pushq %rbp
+	mov %rsp, %rbp
+	pushq %r12
+	pushq %r13
+	pushq %r14
+	pushq %r15
+	pushq %rbx
+	pushq %rdi
+
+	/* Load struct fields into VTL calling convention registers */
+	mov HV_VTLCALL_PARAM_a3(%rdi), %r8
+	mov HV_VTLCALL_PARAM_a2(%rdi), %rdx
+	mov HV_VTLCALL_PARAM_a1(%rdi), %rsi
+	mov HV_VTLCALL_PARAM_a0(%rdi), %rdi
+
+	/* Zero %rcx */
+	xorl %ecx, %ecx
+
+	/* VTL call */
+	call STATIC_CALL_TRAMP_STR(__hv_vsm_vtlcall_hypercall)
+
+	/* Restore args pointer from stack */
+	popq %rax
+
+	/* Store results back to struct */
+	mov %rdi, HV_VTLCALL_PARAM_a0(%rax)
+	mov %rsi, HV_VTLCALL_PARAM_a1(%rax)
+	mov %rdx, HV_VTLCALL_PARAM_a2(%rax)
+	mov %r8,  HV_VTLCALL_PARAM_a3(%rax)
+
+	/* Restore callee-saved registers */
+	popq %rbx
+	popq %r15
+	popq %r14
+	popq %r13
+	popq %r12
+
+	popq %rbp
+	RET
+SYM_FUNC_END(__hv_vsm_vtlcall)
+
+/*
+ * Ensure static_call_key symbol __SCK____hv_vsm_vtlcall_hypercall is
+ * accessible. Inspired by __ADDRESSABLE(sym) macro.
+ */
+	.section	.discard.addressable,"aw"
+	.align 8
+	.type	hv_vsm_vtlcall_sym, @object
+	.size	hv_vsm_vtlcall_sym, 8
+hv_vsm_vtlcall_sym:
+	.quad	__SCK____hv_vsm_vtlcall_hypercall
+#endif /* CONFIG_HYPERV_VSM */
diff --git a/include/hyperv/vsm.h b/include/hyperv/vsm.h
index 51555c09413d5..c1fa4ef3bccde 100644
--- a/include/hyperv/vsm.h
+++ b/include/hyperv/vsm.h
@@ -11,6 +11,8 @@
 #ifndef _HYPERV_VSM_H
 #define _HYPERV_VSM_H
 
+#include <linux/types.h>
+
 /*
  * Size of memory that is initially mapped for the secure kernel by the
  * VTL0-side loader. The secure kernel image itself may be larger than
@@ -18,4 +20,24 @@
  */
 #define VSM_SK_INITIAL_MAP_SIZE		(16 * 1024 * 1024)
 
+/*
+ * Argument block passed from VTL0 to VTL1 across a vtlcall. Layout is
+ * shared with the arch-specific assembly trampoline that marshals these
+ * into registers.
+ */
+struct hv_vtlcall_param {
+	u64	a0;
+	u64	a1;
+	u64	a2;
+	u64	a3;
+} __packed;
+
+#ifdef CONFIG_HYPERV_VSM
+s64 hv_vsm_vtlcall(struct hv_vtlcall_param *args);
+void hv_vsm_init_vtlcall(u64 vtl_call_offset);
+#else
+static inline s64 hv_vsm_vtlcall(struct hv_vtlcall_param *args) { return 0; }
+static inline void hv_vsm_init_vtlcall(u64 vtl_call_offset) {}
+#endif
+
 #endif /* _HYPERV_VSM_H */
-- 
2.34.1

