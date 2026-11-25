Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587399;
	b=sGMUIcsFCScwXJCXxjXXmtlWZ2zTevJoWEAhW5j/iIHklPSOfv5O3skjXYGUoggT7kfu
	 DcZPo0FfSMy/45OC296i+BA7/8ZZRcTAgTSJi1hVlK5R9/Q+1ede4un2mCmR055MTFYrp
	 IdS9Xd+l/MziwOhZhEVhkYM3iqJbGuMYxjOlk3QiEQ4bCFYf/mmZYEgBtb9OmaaJF3WrT
	 MdOi7+KGtjECJ2ZpiUxE068goVrL8dlbh8qeZWxd2TKgCa5JKC6aAcveqFyD1P6+RoPlu
	 M4NCdM5v7/9W2y51vgi/ISsPY+2cW9aYWHPdQwqcSfvIUnMiSn6gxwY3ifXDl3qJdAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587399;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=aajn/8LcP4bWu3au0+O3opUba5V5ruiLTgKiznF6dW0=;
	b=0RdXUzDq8z7qeqzl1pM2uWqFO5poStvnTvlkRW/GnvDfOc/w+cgkkLlI/SLABKTYe1F7
	 r+9YCJFTqv5sw01zBnoSkUfNyK9+bgHxn25gum5VCTOo6OwSL4pM2LPZleenLmo7A8LC2
	 y1YOZKpf0jLstozGxgPLb3h0R6UOpG+CwwZy5rbEmJXHoMPEtURQR+g2k1qXb+dQeaOzt
	 JIlKB9XwhDKK7dSz8v5dAWxizL4DuYAGMFfFescSYuRo4Za1Q14fcK1nB51vDYylvo6Yc
	 yqhvbKkeeIC0D8bduZIOENXVCZXoefWud7jqy2++eSPknGYczRRXi+3SOPLCOubptOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kUnemsy4;
	arc=none smtp.remote-ip=209.85.160.72
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834F8606B8F7
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 834F8606B8F7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kUnemsy4
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-46509ab0149so4101508fac.2
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587397; x=1796192197; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aajn/8LcP4bWu3au0+O3opUba5V5ruiLTgKiznF6dW0=;
        b=kUnemsy4QQI753M8cJpfjjvfttoZa9q20+jvCaCBS8lySVD8OIYiJTOBjr7hrsFLNf
         5+H81GVUaimeX7wACxbcQcnCMQM162uGMxhmD7u0C8tmz74Q96GHpi/XWBN0bVgizuaY
         pNlzj3+dDzOLSyJMts6sB6P8gFmfd5WLjabX5vY1IyXk2Z9bYAX64CF668NfnTZD+Bej
         +k6db5vptQb5Ar8mzLkO/UtpwfH3oA0g33YmzkkrhcWbsj+fXKoKMVFmiHDAZz0zs7ji
         x2trfFqSfLoXNjuDCfE/kFqN8kXVoE8xn2Qqk5V14tU8wOY3CPf7SkKW9pLjoDfJY76V
         mLQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587397; x=1796192197;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aajn/8LcP4bWu3au0+O3opUba5V5ruiLTgKiznF6dW0=;
        b=QoZfxXvQqBXa64L5oKp5GhEM5LnBJq/L3CWqg+0FPtO4C81l9CtX4eMcf77PnIrl+d
         M1GB1trZRI9BDKUN+SmiqV7KFuBMhP/Db2r8fFGqa8WzbNZ4jBMuJ1I15cg9VqCpwxX8
         N4fMiN4VjAU7jxJ67kVZmTvgd7n6otuQSwf27bvJhx1Rkdl0HWxmpvNhPbO93No8ZYRz
         KwaiudVazkUplDdmMvzTHX5p8dqxRLLkb+gTfJS8dPFXxEujvwUaNonXXQiG1nY5bSse
         V2IbbUWfNM7jCaFjtuDPh2Adzp6QCvYeKS4IaWMpt4FrmmXtPLpW/FUZc0bYmDqmJVc1
         lg6w==
X-Forwarded-Encrypted: i=1; AL+hErF0f7TCaF4Bi0jiwewcXHheLkf037/BV7YK9OFgtdm6NM6ChGyttClB0qyPYKK0s7zPbMO5XgKDvyc=@vger.kernel.org
X-Gm-Message-State: APuU4Z8EjQhDA77Kv8Dgc2afjwPiUAQo4R7u5E0NgX1sY5Rc0PwyYeSX
	r3QfnfP4BUmDYXLNUG2vDxCJHNFl1OpeNRKjiqnLZRAMZTHOG0gBwh1PB7nlTpkPEsAwbKnW+Wf
	mwEr3ib5kPw==
X-Received: from oakt7-n1.prod.google.com ([2002:a05:687c:41c7:10b0:494:50e2:71dd])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6870:c087:b0:4a9:58d3:b60c
 with SMTP id 586e51a60fabf-4bc835713b6mr16383166fac.32.1795587397055; Tue, 24
 Nov 2026 22:16:37 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:13 -0800
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
Message-ID: <20261125061523.1540234-21-irogers@google.com>
Subject: [RFC PATCH v2 20/30] selftests/perf_events: Add Minimal DWARF CFI
 deferred user unwind test
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

Add a multi-architecture kselftest (unwind_user_cfi) under
tools/testing/selftests/perf_events/ exercising deferred user-space
callchain unwinding (PERF_RECORD_CALLCHAIN_DEFERRED) compiled with
-O2 -fomit-frame-pointer -fasynchronous-unwind-tables across:
 1. Standard SP-based frames with the architectural frame-pointer
    register (%rbp / x29 / s0) explicitly clobbered
 2. Dynamic alloca() VLA FP-based frames (DW_CFA_def_cfa_register)
 3. 64-byte stack-realigned frames (DRAP on x86-64)
 4. Shrink-wrapped early-return functions (remember_state/restore_state)
 5. Anonymous RX JIT-style frame-pointer stubs lacking .eh_frame_hdr
    (including a >16-byte AArch64 frame testing state->sp_valid across
    FP -> CFI transitions), exercising per-frame CFI -> FP -> CFI -> FP
    -> CFI fallback and negative VMA caching in find_user_eh_frame_hdr()

Skip gracefully via dl_iterate_phdr() if the test binary lacks
PT_GNU_EH_FRAME (e.g. 32-bit ARM EHABI builds using .ARM.exidx).

Signed-off-by: Ian Rogers <irogers@google.com>
---
 .../testing/selftests/perf_events/.gitignore  |   1 +
 tools/testing/selftests/perf_events/Makefile  |   4 +-
 .../selftests/perf_events/unwind_user_cfi.c   | 482 ++++++++++++++++++
 3 files changed, 486 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/perf_events/unwind_user_cfi.c

diff --git a/tools/testing/selftests/perf_events/.gitignore b/tools/testing/selftests/perf_events/.gitignore
index 4931b3b6bbd3..4567b6563646 100644
--- a/tools/testing/selftests/perf_events/.gitignore
+++ b/tools/testing/selftests/perf_events/.gitignore
@@ -3,3 +3,4 @@ sigtrap_threads
 remove_on_exec
 watermark_signal
 mmap
+unwind_user_cfi
diff --git a/tools/testing/selftests/perf_events/Makefile b/tools/testing/selftests/perf_events/Makefile
index 2e5d85770dfe..6a3a774544e8 100644
--- a/tools/testing/selftests/perf_events/Makefile
+++ b/tools/testing/selftests/perf_events/Makefile
@@ -2,5 +2,7 @@
 CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 LDFLAGS += -lpthread
 
-TEST_GEN_PROGS := sigtrap_threads remove_on_exec watermark_signal mmap
+TEST_GEN_PROGS := sigtrap_threads remove_on_exec watermark_signal mmap unwind_user_cfi
 include ../lib.mk
+
+$(OUTPUT)/unwind_user_cfi: CFLAGS += $(TOOLS_INCLUDES) -O2 -fomit-frame-pointer -fasynchronous-unwind-tables
diff --git a/tools/testing/selftests/perf_events/unwind_user_cfi.c b/tools/testing/selftests/perf_events/unwind_user_cfi.c
new file mode 100644
index 000000000000..a36e9f4d39e2
--- /dev/null
+++ b/tools/testing/selftests/perf_events/unwind_user_cfi.c
@@ -0,0 +1,482 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * unwind_user_cfi.c - Multi-arch selftest for Minimal DWARF CFI user unwinding.
+ *
+ * Verifies that deferred user-space stack unwinding (PERF_RECORD_CALLCHAIN_DEFERRED)
+ * accurately walks user callchains compiled with -fomit-frame-pointer across:
+ *   1. Standard SP-based frames with the frame-pointer register (%rbp / x29 / s0)
+ *      explicitly clobbered to defeat FP unwinding
+ *   2. Dynamic alloca()/VLA FP-based frames (DW_CFA_def_cfa_register)
+ *   3. 64-byte aligned stack-realigned frames (DRAP on x86-64)
+ *   4. Multi-return shrink-wrapped epilogue functions (remember/restore_state)
+ *   5. Anonymous RX JIT-style frame-pointer stubs lacking .eh_frame_hdr,
+ *      verifying per-frame CFI -> FP -> CFI -> FP -> CFI hybrid fallback and
+ *      negative VMA caching in find_user_eh_frame_hdr()
+ */
+
+#define _GNU_SOURCE
+#include <alloca.h>
+#include <errno.h>
+#include <inttypes.h>
+#include <link.h>
+#include <linux/perf_event.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <time.h>
+#include <unistd.h>
+
+#include "../kselftest.h"
+#undef __always_inline
+#undef __attribute_const__
+#undef __must_check
+#undef __printf
+#include "../../../../include/linux/compiler_attributes.h"
+
+struct perf_record_deferred {
+	struct perf_event_header header;
+	uint64_t cookie;
+	uint64_t nr;
+	uint64_t ips[];
+};
+
+/*
+ * Tiny architecture-specific machine-code stubs for:
+ *   int jit_stub(int (*fn)(int), int arg);
+ *
+ * Mapped into an anonymous PROT_READ | PROT_EXEC VMA without an ELF header or
+ * PT_GNU_EH_FRAME segment. Each stub establishes a standard architectural
+ * frame-pointer record before calling fn(arg), forcing unwind_user_next() to
+ * fall back from UNWIND_USER_TYPE_CFI to UNWIND_USER_TYPE_FP on the JIT frames
+ * and resume UNWIND_USER_TYPE_CFI on the surrounding -fomit-frame-pointer C
+ * frames.
+ */
+#if defined(__x86_64__)
+#define HAVE_JIT_FP_STUB 1
+static const uint8_t jit_stub_code[] = {
+	0xf3, 0x0f, 0x1e, 0xfa,		/* endbr64 */
+	0x55,				/* push   %rbp */
+	0x48, 0x89, 0xe5,		/* mov    %rsp, %rbp */
+	0x48, 0x89, 0xf8,		/* mov    %rdi, %rax */
+	0x89, 0xf7,			/* mov    %esi, %edi */
+	0xff, 0xd0,			/* call   *%rax */
+	0x5d,				/* pop    %rbp */
+	0xc3,				/* ret */
+};
+#elif defined(__i386__)
+#define HAVE_JIT_FP_STUB 1
+static const uint8_t jit_stub_code[] = {
+	0xf3, 0x0f, 0x1e, 0xfb,		/* endbr32 */
+	0x55,				/* push   %ebp */
+	0x89, 0xe5,			/* mov    %esp, %ebp */
+	0x83, 0xec, 0x04,		/* sub    $4, %esp */
+	0xff, 0x75, 0x0c,		/* pushl  12(%ebp) */
+	0xff, 0x55, 0x08,		/* call   *8(%ebp) */
+	0x83, 0xc4, 0x08,		/* add    $8, %esp */
+	0x5d,				/* pop    %ebp */
+	0xc3,				/* ret */
+};
+#elif defined(__aarch64__)
+#define HAVE_JIT_FP_STUB 1
+/*
+ * Allocate a 32-byte frame (> 16 bytes) with {x29, x30} at [sp, #0] per
+ * AArch64 PCS so fp + 16 != caller_sp, exercising state->sp_valid tracking.
+ */
+static const uint32_t jit_stub_code[] = {
+	0xd503245fU,			/* bti    c */
+	0xa9be7bfdU,			/* stp    x29, x30, [sp, #-32]! */
+	0x910003fdU,			/* mov    x29, sp */
+	0xaa0003e9U,			/* mov    x9, x0 */
+	0x2a0103e0U,			/* mov    w0, w1 */
+	0xd63f0120U,			/* blr    x9 */
+	0xa8c27bfdU,			/* ldp    x29, x30, [sp], #32 */
+	0xd65f03c0U,			/* ret */
+};
+#elif defined(__riscv) && __riscv_xlen == 64
+#define HAVE_JIT_FP_STUB 1
+static const uint32_t jit_stub_code[] = {
+	0xff010113U,			/* addi   sp, sp, -16 */
+	0x00813023U,			/* sd     s0, 0(sp) */
+	0x00113423U,			/* sd     ra, 8(sp) */
+	0x01010413U,			/* addi   s0, sp, 16 */
+	0x00050313U,			/* mv     t1, a0 */
+	0x00058513U,			/* mv     a0, a1 */
+	0x000300e7U,			/* jalr   ra, 0(t1) */
+	0x00813083U,			/* ld     ra, 8(sp) */
+	0x00013403U,			/* ld     s0, 0(sp) */
+	0x01010113U,			/* addi   sp, sp, 16 */
+	0x00008067U,			/* ret */
+};
+#else
+#define HAVE_JIT_FP_STUB 0
+#endif
+
+static int (*g_jit_fn)(int (*fn)(int), int arg);
+
+static uintptr_t expect_ip_leaf;
+static uintptr_t expect_ip_shrink;
+static uintptr_t expect_ip_jit;
+static uintptr_t expect_ip_bridge;
+static uintptr_t expect_ip_drap;
+static uintptr_t expect_ip_vla;
+static uintptr_t expect_ip_clobber;
+static uintptr_t expect_ip_main;
+
+static __always_inline uintptr_t caller_return_ip(void)
+{
+	return (uintptr_t)__builtin_extract_return_addr(__builtin_return_address(0));
+}
+
+static long sys_perf_event_open(struct perf_event_attr *attr, pid_t pid,
+				int cpu, int group_fd, unsigned long flags)
+{
+	return syscall(__NR_perf_event_open, attr, pid, cpu, group_fd, flags);
+}
+
+noinline __noclone
+static void cfi_do_nanosleep(const struct timespec *ts)
+{
+	expect_ip_leaf = caller_return_ip();
+	asm volatile("" ::: "memory");
+	nanosleep(ts, /*rem=*/NULL);
+	asm volatile("" ::: "memory");
+}
+
+noinline __noclone
+static void cfi_leaf_sleep(void)
+{
+	struct timespec ts = { .tv_sec = 0, .tv_nsec = 1000 * 1000 };
+
+	expect_ip_shrink = caller_return_ip();
+	asm volatile("" ::: "memory");
+	cfi_do_nanosleep(&ts);
+	asm volatile("" ::: "memory");
+}
+
+/* 4. Shrink-wrapped early-return epilogue before main call */
+noinline __noclone
+static int cfi_shrink_wrap(int mode)
+{
+	expect_ip_jit = caller_return_ip();
+	if (mode < 0)
+		return -1;
+
+	{
+		char pad[32];
+
+		memset(pad, mode, sizeof(pad));
+		asm volatile("" : "+m"(pad) :: "memory");
+		cfi_leaf_sleep();
+		return pad[0];
+	}
+}
+
+/*
+ * 5. Hybrid CFI -> FP -> CFI -> FP -> CFI bridge:
+ *    cfi_pre_jit -> jit_stub #1 -> cfi_jit_bridge -> cfi_mid_jit ->
+ *    jit_stub #2 -> cfi_shrink_wrap
+ *
+ * Invoking the anonymous RX JIT stub twice with -fomit-frame-pointer C frames
+ * in between exercises both per-frame CFI<->FP transitions and negative VMA
+ * cache insertion + hit in find_user_eh_frame_hdr().
+ */
+noinline __noclone
+static int cfi_mid_jit(int x)
+{
+	size_t sz;
+	char *pad;
+	int res;
+
+	expect_ip_bridge = caller_return_ip();
+	asm volatile("" : "+r"(x));
+	sz = (size_t)((x & 0xf) + 32);
+	pad = alloca(sz);
+	memset(pad, x + 5, sz);
+	asm volatile("" : "+m"(*(char (*)[32])pad) :: "memory");
+	res = g_jit_fn ? g_jit_fn(cfi_shrink_wrap, x) : cfi_shrink_wrap(x);
+	asm volatile("" : "+m"(*(char (*)[32])pad) :: "memory");
+	return res + pad[0];
+}
+
+noinline __noclone
+static int cfi_jit_bridge(int x)
+{
+	char pad[32];
+	int res;
+
+	memset(pad, x + 7, sizeof(pad));
+	asm volatile("" : "+m"(pad) :: "memory");
+	res = cfi_mid_jit(x);
+	asm volatile("" : "+m"(pad) :: "memory");
+	return res + pad[0];
+}
+
+noinline __noclone
+static int cfi_pre_jit(int x)
+{
+	size_t sz;
+	char *pad;
+	int res;
+
+	expect_ip_drap = caller_return_ip();
+	asm volatile("" : "+r"(x));
+	sz = (size_t)((x & 0xf) + 32);
+	pad = alloca(sz);
+	memset(pad, x + 9, sz);
+	asm volatile("" : "+m"(*(char (*)[32])pad) :: "memory");
+	res = g_jit_fn ? g_jit_fn(cfi_jit_bridge, x) : cfi_jit_bridge(x);
+	asm volatile("" : "+m"(*(char (*)[32])pad) :: "memory");
+	return res + pad[0];
+}
+
+/* 3. 64-byte aligned local buffer forcing stack realignment (DRAP on x86-64) */
+noinline __noclone
+static int cfi_drap_realigned(int x)
+{
+	uint8_t __aligned(64) aligned_buf[128];
+
+	expect_ip_vla = caller_return_ip();
+	memset(aligned_buf, x + 3, sizeof(aligned_buf));
+	asm volatile("" : "+m"(aligned_buf) :: "memory");
+	return cfi_pre_jit(x) + aligned_buf[0];
+}
+
+/* 2. Dynamic VLA / alloca() forcing FP-based CFA (DW_CFA_def_cfa_register) */
+noinline __noclone
+static int cfi_vla_fp_frame(int n)
+{
+	size_t sz;
+	char *dyn;
+
+	expect_ip_clobber = caller_return_ip();
+	asm volatile("" : "+r"(n));
+	sz = (size_t)((n & 0x3f) + 32);
+	dyn = alloca(sz);
+
+	memset(dyn, n, sz);
+	asm volatile("" : "+m"(*(char (*)[32])dyn) :: "memory");
+	return cfi_drap_realigned(n + dyn[0]);
+}
+
+/* 1. SP-based frame with FP (%rbp / x29 / s0) clobbered to defeat FP unwinding */
+noinline __noclone
+static int cfi_clobber_fp(int x)
+{
+#if defined(__x86_64__)
+	register long bad_fp asm("rbp") = 0x13579bdfL + x;
+#elif defined(__aarch64__)
+	register long bad_fp asm("x29") = 0x13579bdfL + x;
+#elif defined(__riscv)
+	register long bad_fp asm("s0") = 0x13579bdfL + x;
+#else
+	long bad_fp = 0x13579bdfL + x;
+#endif
+	char pad[48];
+
+	expect_ip_main = caller_return_ip();
+	asm volatile("" : "+r"(x));
+	memset(pad, x, sizeof(pad));
+	asm volatile("" : "+r"(bad_fp), "+m"(pad) :: "memory");
+	return cfi_vla_fp_frame(x + 1) ^ (int)bad_fp ^ pad[1];
+}
+
+static int check_main_eh_frame_cb(struct dl_phdr_info *info, size_t size,
+				  void *data)
+{
+	bool *has_eh_frame = data;
+
+	(void)size;
+	if (!info->dlpi_name || info->dlpi_name[0] != '\0')
+		return 0;
+
+	for (int i = 0; i < info->dlpi_phnum; i++) {
+		if (info->dlpi_phdr[i].p_type == PT_GNU_EH_FRAME &&
+		    info->dlpi_phdr[i].p_memsz > 0) {
+			*has_eh_frame = true;
+			return 1;
+		}
+	}
+	return 1;
+}
+
+int main(void)
+{
+	struct perf_event_attr attr;
+	struct perf_event_mmap_page *mpage;
+	size_t page_sz = (size_t)sysconf(_SC_PAGESIZE);
+	size_t mmap_len = (1 + 16) * page_sz;
+	void *jit_page = MAP_FAILED;
+	uint8_t *ring;
+	uint64_t head, tail;
+	bool got_deferred = false;
+	bool saw_leaf = false, saw_shrink = false, saw_jit = false;
+	bool saw_bridge = false, saw_drap = false, saw_vla = false;
+	bool saw_clobber = false, saw_main = false;
+	bool saw_full_chain = false;
+	bool has_eh_frame = false;
+	int fd, arg = 1;
+
+	ksft_print_header();
+	ksft_set_plan(1);
+
+#if !defined(__x86_64__) && !defined(__i386__) && !defined(__aarch64__) && \
+	!defined(__arm__) && !defined(__riscv)
+	ksft_test_result_skip("Architecture lacks Minimal DWARF CFI user unwind support\n");
+	ksft_finished();
+#endif
+
+	dl_iterate_phdr(check_main_eh_frame_cb, &has_eh_frame);
+	if (!has_eh_frame) {
+		ksft_test_result_skip("Test binary lacks PT_GNU_EH_FRAME\n");
+		ksft_finished();
+	}
+
+#if HAVE_JIT_FP_STUB
+	jit_page = mmap(/*addr=*/NULL, page_sz, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, /*fd=*/-1, /*offset=*/0);
+	if (jit_page != MAP_FAILED) {
+		memcpy(jit_page, jit_stub_code, sizeof(jit_stub_code));
+		if (mprotect(jit_page, page_sz, PROT_READ | PROT_EXEC) == 0) {
+			__builtin___clear_cache((char *)jit_page,
+						(char *)jit_page + sizeof(jit_stub_code));
+			g_jit_fn = (int (*)(int (*)(int), int))jit_page;
+		} else {
+			ksft_print_msg("W^X JIT mprotect unavailable (%s); skipping JIT stub\n",
+				       strerror(errno));
+			munmap(jit_page, page_sz);
+			jit_page = MAP_FAILED;
+		}
+	}
+#endif
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_SOFTWARE;
+	attr.size = sizeof(attr);
+	attr.config = PERF_COUNT_SW_CONTEXT_SWITCHES;
+	attr.sample_period = 1;
+	attr.sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_CALLCHAIN;
+	attr.disabled = 1;
+	attr.defer_callchain = 1;
+	attr.defer_output = 1;
+
+	fd = (int)sys_perf_event_open(&attr, /*pid=*/0, /*cpu=*/-1,
+				      /*group_fd=*/-1, /*flags=*/0);
+	if (fd < 0) {
+		if (jit_page != MAP_FAILED)
+			munmap(jit_page, page_sz);
+		if (errno == EACCES || errno == EPERM || errno == EINVAL) {
+			ksft_test_result_skip("perf_event_open(defer_callchain) unavailable: %s\n",
+					      strerror(errno));
+			ksft_finished();
+		}
+		ksft_exit_fail_msg("perf_event_open failed: %s\n", strerror(errno));
+	}
+
+	mpage = mmap(/*addr=*/NULL, mmap_len, PROT_READ | PROT_WRITE,
+		     MAP_SHARED, fd, /*offset=*/0);
+	if (mpage == MAP_FAILED) {
+		if (jit_page != MAP_FAILED)
+			munmap(jit_page, page_sz);
+		close(fd);
+		ksft_exit_fail_msg("mmap failed: %s\n", strerror(errno));
+	}
+
+	ioctl(fd, PERF_EVENT_IOC_RESET, 0);
+	ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);
+
+	asm volatile("" : "+r"(arg));
+	cfi_clobber_fp(arg);
+
+	ioctl(fd, PERF_EVENT_IOC_DISABLE, 0);
+
+	ring = (uint8_t *)mpage + page_sz;
+	head = __atomic_load_n(&mpage->data_head, __ATOMIC_ACQUIRE);
+	tail = mpage->data_tail;
+
+	while (tail < head) {
+		size_t mask = 16 * page_sz - 1;
+		struct perf_event_header *hdr =
+			(struct perf_event_header *)(ring + (tail & mask));
+
+		if (hdr->type == PERF_RECORD_CALLCHAIN_DEFERRED) {
+			struct perf_record_deferred *rec = (void *)hdr;
+			bool c_leaf = false, c_shrink = false, c_bridge = false;
+			bool c_drap = false, c_vla = false, c_clobber = false;
+			bool c_main = false, c_jit_ok = false;
+			unsigned int c_jit_hits = 0;
+
+			got_deferred = true;
+			for (uint64_t i = 0; i < rec->nr; i++) {
+				uintptr_t ip = (uintptr_t)rec->ips[i];
+
+				if (ip == expect_ip_leaf)
+					c_leaf = true;
+				else if (ip == expect_ip_shrink)
+					c_shrink = true;
+				else if (ip == expect_ip_jit)
+					c_jit_hits++;
+				else if (ip == expect_ip_bridge)
+					c_bridge = true;
+				else if (ip == expect_ip_drap)
+					c_drap = true;
+				else if (ip == expect_ip_vla)
+					c_vla = true;
+				else if (ip == expect_ip_clobber)
+					c_clobber = true;
+				else if (ip == expect_ip_main)
+					c_main = true;
+			}
+
+#if HAVE_JIT_FP_STUB
+			if (g_jit_fn) {
+				uintptr_t jb = (uintptr_t)jit_page;
+
+				c_jit_ok = expect_ip_jit >= jb &&
+					   expect_ip_jit < jb + sizeof(jit_stub_code) &&
+					   c_jit_hits >= 2;
+			} else {
+				c_jit_ok = c_jit_hits >= 1;
+			}
+#else
+			c_jit_ok = c_jit_hits >= 1;
+#endif
+			saw_leaf |= c_leaf;
+			saw_shrink |= c_shrink;
+			saw_jit |= c_jit_ok;
+			saw_bridge |= c_bridge;
+			saw_drap |= c_drap;
+			saw_vla |= c_vla;
+			saw_clobber |= c_clobber;
+			saw_main |= c_main;
+
+			if (c_leaf && c_shrink && c_jit_ok && c_bridge &&
+			    c_drap && c_vla && c_clobber && c_main)
+				saw_full_chain = true;
+		}
+		tail += hdr->size;
+	}
+
+	munmap(mpage, mmap_len);
+	if (jit_page != MAP_FAILED)
+		munmap(jit_page, page_sz);
+	close(fd);
+
+	if (!got_deferred) {
+		ksft_test_result_skip("No PERF_RECORD_CALLCHAIN_DEFERRED records\n");
+		ksft_finished();
+	}
+
+	ksft_print_msg("def=%d ok=%d leaf=%d shr=%d jit=%d br=%d drap=%d vla=%d fp=%d entry=%d\n",
+		       got_deferred, saw_full_chain, saw_leaf, saw_shrink,
+		       saw_jit, saw_bridge, saw_drap, saw_vla, saw_clobber,
+		       saw_main);
+
+	ksft_test_result(saw_full_chain,
+			 "unwind_user Minimal DWARF CFI across SP, VLA, DRAP, shrink-wrap, and hybrid JIT FP frames\n");
+	ksft_finished();
+}
-- 
2.56.1.831.g720f3f5937-goog

