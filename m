Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795391962;
	b=q3HAubWsg+2pz2ahkMza7iEbcCnRxcrq5P8d286vlbyHQeBR7WzlP6iEIv4j7D97/Nsf
	 2+eOpcPjKM26JAZwd+LF2mmuPntR8NA0xBjeKCBTytkMwfGxnm4HmeJa55Csbuc3GZSRp
	 DdfX3aADyxGMt9vyJZW7UPLqGEzAZbXzXrgS+rOSuG/Y0JB8bQh/C9wubcWoGKV5L0JGo
	 3MALKSvNq6S4BMqmp+pwHz+pnNnI5W8iz0MpRQPpVjmnaG/F2jXNo5+crshLTFEosGTlB
	 BngXCf9ZDmjiDoM0NkCuf9WHq7W5KBO93SxAceVWKDQvY8iQhfPKv0z18w8UR/6yj/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795391962;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=KyZ9uJ626I12Njxv0j4mlzZ8UPtaacK9Ww2cyWkY9Po=;
	b=ghEhknNCWTDXMC5ZRwmIUDbPkQs05ATqHBwcaxruHUQj6BgX9E5RrSDuq5UqG0vwT3pU
	 v+4YQQZcdEuO6KjT/EHip/LVnO/TroSdK13oJqr7x74ZUzjtifmLFnGTFXi7xsHj/F2vA
	 /E1B/mHgvSl9goFkt/ZwvtglGoK3JJ4toAuR6UZkLx7ssInsA7GvZ/4UXhP/4gzoiECtQ
	 eEQJrtg4bGzbVimR/lpZSwW5SPfz/FHrV9zKesTXZKGHFD7w5m09Mn43WUO0u1ea4YaPh
	 KmxoOqiG6kqooez4hwFBLFo9xg1GAPi6Zc6/tEC9QgyJOZ6CScCX35dnT1RxhrXfQ7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="LVhW0/AA";
	arc=none smtp.remote-ip=74.125.82.197
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0793D606A333
	for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 23:59:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0793D606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LVhW0/AA
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-382af5cfc58so8160889eec.0
        for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 15:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795391961; x=1795996761; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KyZ9uJ626I12Njxv0j4mlzZ8UPtaacK9Ww2cyWkY9Po=;
        b=LVhW0/AANVxJAQwT6mhQoaTJ2b9TFO1WVD5TUQ0TUHNDjNjhsCNBVG9ohXjOFBwV5X
         1NPByY2mhKcyn3qfYG9ZhxoKBf5JqCibeh7B0hgeAXDx+f9fP/MgJNlns9prztlQhTbn
         0dVFZ0v9fAd5hqxIOPlrd91juN5zVCtbrTnz5OeD/7JVFHFlFwEEKEKnoFOIRhjP+BVD
         eWmnoZsfx03MbEDJruouN6gSntbjYHdazetxMUkMx0hF/7Q8IwXeiBDpxquNyltJep5B
         7iz30w3a5cpeGODgTzpi+g3bgGz+GeCec/FkBe1DK4LXzgYas7weIQjhPXGpqntRbu3y
         xyJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795391961; x=1795996761;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KyZ9uJ626I12Njxv0j4mlzZ8UPtaacK9Ww2cyWkY9Po=;
        b=Acbf27PZSBvElh4xv8qfk14OSo24K33oXaEDs2QI5NvI38LavkUyJhI8XP+IJue/IH
         BThmqgQ/quGpNzxWm9wnUcdgCUe5Ap+bmxq0FbG/2sMdidGUDRvj6Nx1ALZrU2gFa+h2
         VyNQIUDYx/30abFgrmZrk65erFLGzqoJMJ1keMONJVWxG3BjHjKN45N65ugOJg/JWwNg
         iGhqe2r0QUNRuYrnTfsSMJdAh7e7+tRpv3opxQ3SqGmPi/6rx7uM9e+x9e46mCSu8hcf
         nvsB1h0BrmoXTtmb7aeZAs3oMel7TVpbtb0uSmZMyEkKKTLF3z1cG7DPOWgnzMSfu+vy
         rngw==
X-Forwarded-Encrypted: i=1; AL+hErFVICEW3x24D/6yLHhvglKPoKJVHhk/ralVSNRAG9ptmzIUrj4YI8Q0Psfay90ouM/lWlMxYVmCBrY=@vger.kernel.org
X-Gm-Message-State: APuU4Z+fpAY/6bbiwgR8Q7Tci+Jyv9XNxa2pcoBSnChmnDCdJEdAZreW
	IwGOfcrC0QgbSjA/un7XuNj++VYtT/gj0P8yrC9Dum16HRaGAadRBUVFGLMCJeFG3u1osEEJBdc
	7FmQc/OZ+Ug==
X-Received: from dycqw15-n1.prod.google.com ([2002:a05:7300:c00f:10b0:36f:5688:8a11])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:700a:b0:384:988d:6ec2
 with SMTP id 5a478bee46e88-3856f6524acmr11225588eec.33.1795391960856; Sun, 22
 Nov 2026 15:59:20 -0800 (PST)
Date: Sun, 22 Nov 2026 15:57:56 -0800
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
Message-ID: <20261122235757.3456048-11-irogers@google.com>
Subject: [RFC PATCH v1 10/11] selftests/perf_events: Add Minimal DWARF CFI
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
	nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, 
	ojeda@kernel.org, rust-for-linux@vger.kernel.org, ardb@kernel.org, 
	linux-efi@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	kvmarm@lists.linux.dev, shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, 
	dylanbhatch@google.com, Ian Rogers <irogers@google.com>
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
 5. Anonymous RX JIT-style frame-pointer stubs lacking .eh_frame_hdr,
    exercising per-frame CFI -> FP -> CFI -> FP -> CFI fallback and
    negative VMA caching in find_user_eh_frame_hdr()

Signed-off-by: Ian Rogers <irogers@google.com>
---
 .../testing/selftests/perf_events/.gitignore  |   1 +
 tools/testing/selftests/perf_events/Makefile  |   4 +-
 .../selftests/perf_events/unwind_user_cfi.c   | 447 ++++++++++++++++++
 3 files changed, 451 insertions(+), 1 deletion(-)
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
index 000000000000..3f9fb8500824
--- /dev/null
+++ b/tools/testing/selftests/perf_events/unwind_user_cfi.c
@@ -0,0 +1,447 @@
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
+#ifndef PERF_RECORD_CALLCHAIN_DEFERRED
+#define PERF_RECORD_CALLCHAIN_DEFERRED 22
+#endif
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
+static const uint32_t jit_stub_code[] = {
+	0xd503245fU,			/* bti    c */
+	0xa9bf7bfdU,			/* stp    x29, x30, [sp, #-16]! */
+	0x910003fdU,			/* mov    x29, sp */
+	0xaa0003e9U,			/* mov    x9, x0 */
+	0x2a0103e0U,			/* mov    w0, w1 */
+	0xd63f0120U,			/* blr    x9 */
+	0xa8c17bfdU,			/* ldp    x29, x30, [sp], #16 */
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
+	char pad[32];
+	int res;
+
+	expect_ip_bridge = caller_return_ip();
+	memset(pad, x + 5, sizeof(pad));
+	asm volatile("" : "+m"(pad) :: "memory");
+	res = g_jit_fn ? g_jit_fn(cfi_shrink_wrap, x) : cfi_shrink_wrap(x);
+	asm volatile("" : "+m"(pad) :: "memory");
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
+	char pad[32];
+	int res;
+
+	expect_ip_drap = caller_return_ip();
+	memset(pad, x + 9, sizeof(pad));
+	asm volatile("" : "+m"(pad) :: "memory");
+	res = g_jit_fn ? g_jit_fn(cfi_jit_bridge, x) : cfi_jit_bridge(x);
+	asm volatile("" : "+m"(pad) :: "memory");
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
2.56.1.750.gf70dc682cf-goog

