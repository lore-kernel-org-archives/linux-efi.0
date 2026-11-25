Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587362;
	b=1IEDOQVCquU8/e1tpBDUf/F9cw6iEMH5+h5b9/EpcHUBAj+Ri2TSvOrJSs1uCdPvmd6E
	 jbIcpkYa7zxfs7+fjff1WdskmOWILJ7c2eaYWf1ILqQfl72FIklplp2lyHp9qIhBfDoIi
	 V5vrn7XSaeRDIBOybrYZlPrh48TPUzQEHE9aEcEm3nPEsfXtEEUhHYtX4h1QeYjrd6RHM
	 tmAwN0aOywHTx2A9KQoM+RNN4YXW3BGe0kiObyGY4iZ6jOcCfQurBaBgyUSHnxAkx9ei8
	 f8wRmO43pJb7DyW0dcfPrGRZMqQdPJqD7oKVGqUijV6Sq1k8sCtbcigLQT8nMWyKxng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587362;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=t9I8cNuBP7ebVAP5Sxu6FvkQwNvgLeon4MVqc5DF214=;
	b=AnyBmjYbw8nPyw9cXKp/O+7vnGDOeEaBdZ/afn9CBGKOvpKIcqNkApIYEvnY4IWTTaK6
	 YekLZhPPlFtPFSjb8igF8wDP0KKpzMI31YVslzfjEdFB02wsbz67WkQfyVDa3d0nYY4hL
	 X5TaBEGsmprQ99WKkMwuhrIQwOqvsgBOc1jobVVx/kBjautXNIyseGG4dyABrRhhe1EN+
	 bCURNrdNH119E9Vmc3i4WOb962YjqnUrMYEYs+rf+S+egsjH7vlYPYTb6c6/YibYm5edC
	 xI6ZSPBxEp72aqxAsPOeeyo7UDH2uqERRingbQdSbUPFb5JKhdfluRvIVuYQEvqN+zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ivbZwJOp;
	arc=none smtp.remote-ip=74.125.82.72
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A34606D321
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8A34606D321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ivbZwJOp
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1b588e4bd7fso487235c88.0
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587361; x=1796192161; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t9I8cNuBP7ebVAP5Sxu6FvkQwNvgLeon4MVqc5DF214=;
        b=ivbZwJOpPv/6NNhlpS3wz/ZLJ0hoQnjVbUki17WYWLWq+l7Yjezc3cPUB7CxjnYXtq
         KoTEV1kVgRLgMuDcSxlVMzjcWjh/GVgcBNkWQrTE1hO4B7cL97N7skz0d6XAscMBq+qr
         GBjoow9C1JV1/8aULMGCA3QeJxDDU+KB0erHOJ8EK1/JM3KfctgswqqJXcISoN6mfVIf
         IX3wziW/AGRgLHmePJLvDTdLM/pD74qdb+/S/o+nl/QlRCQePjSIvAQNUdmQxTMUTu/Q
         KwJ8zHiFnbZHYfW4GeCRJB/6OD+hVP1lvq09kEBl0lg7P/4JrH43/46zsbZdIEvnZq8G
         fm1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587361; x=1796192161;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t9I8cNuBP7ebVAP5Sxu6FvkQwNvgLeon4MVqc5DF214=;
        b=VhB9y0QvPemsAyJ0n5xJY1AHzUugThsbWoRxy8RL7uRy3r3fB26ooEpT0OgbKwyDl2
         Ht+wnb4j9VBGYIvo7ymGLQT/Fr5Cf9BkJ6VIahGCQjmvYF/IVqMDjTj5z6lm71Lt/BVq
         T9sZ8RjkJY8assNaMcglL4CbEocsIG/tXaViFIMCd0azMkFXYY8V2dhRgBSHdj5Ytu5U
         TTxEG6w+0uyNqimcMnUr0VK+zpMN/zwVpyO+iN9McV4IQeAB5Ubindwee7P0DWLdFZWO
         Oa3Z2MQbNmlgSwdn90XyURvmburZnylQ+qiJ3CMi6qKyAal0UHuFIVBB96pR9lNPG4Ig
         0oJw==
X-Forwarded-Encrypted: i=1; AL+hErFabJNgGpL1r/UJZa9oShwlcB6iTcofyB/EbJTDxNmMZeMVF0v+2KjYVzWI3gzz8cKtf9IbObSKlEM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+vITF0GlirzDieT//3SwcnxZQrPwycB6WghbM2ujxOEDGyY3l+
	lSfuyE5WYeTgx65qInxNhdPrR3kk5kyzdL0lSTMF5+vv55QQDXAiM9PQF7YW7EIwW0T44Z7e63+
	+0ftW3bKPmg==
X-Received: from dlec1-n2.prod.google.com ([2002:a05:701b:4281:20b0:1ab:a092:67c3])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701b:2083:10b0:164:4e36:f956
 with SMTP id a92af1059eb24-1b5568b47a4mr17852731c88.16.1795587360305; Tue, 24
 Nov 2026 22:16:00 -0800 (PST)
Date: Tue, 24 Nov 2026 22:14:55 -0800
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
Message-ID: <20261125061523.1540234-3-irogers@google.com>
Subject: [RFC PATCH v2 02/30] unwind: Add KUnit tests for Minimal DWARF CFI interpreter
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

Add a built-in KUnit test suite (CONFIG_UNWIND_DWARF_CFI_KUNIT_TEST) in
kernel/unwind/dwarf_cfi_kunit.c exercising the Minimal DWARF CFI
interpreter across:
 - SP-based and FP-based stack frames and ignored callee-saved GPR spills
 - Shrink-wrapped DW_CFA_remember_state / DW_CFA_restore_state stacks
 - DRAP stack realignment and 64-bit / 32-bit vdso32 sigreturn frames
 - ARM64 PAC-RET (DW_CFA_AARCH64_negate_ra_state) and RISC-V leaf frames
 - Malformed bytecode, negative sdata4 range, and overflow rejections
 - Linear .eh_frame scanning (dwarf_cfi_scan_eh_frame_kmem()) and live
   CALLER_ADDR0/1 and kernel stack walks

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/Kconfig                    |  10 +
 kernel/unwind/Makefile          |   1 +
 kernel/unwind/dwarf_cfi_kunit.c | 767 ++++++++++++++++++++++++++++++++
 3 files changed, 778 insertions(+)
 create mode 100644 kernel/unwind/dwarf_cfi_kunit.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 5ed64e6cc72e..03399120aa8f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -506,6 +506,16 @@ config UNWIND_TABLES
 config UNWIND_DWARF_CFI
 	bool
 
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
 
diff --git a/kernel/unwind/Makefile b/kernel/unwind/Makefile
index f772fc607985..73a1ccc2ad77 100644
--- a/kernel/unwind/Makefile
+++ b/kernel/unwind/Makefile
@@ -9,3 +9,4 @@ KCOV_INSTRUMENT_dwarf_cfi.o := n
 
 obj-$(CONFIG_UNWIND_DWARF_CFI)		+= dwarf_cfi.o
 obj-$(CONFIG_UNWIND_USER)		+= user.o deferred.o
+obj-$(CONFIG_UNWIND_DWARF_CFI_KUNIT_TEST) += dwarf_cfi_kunit.o
diff --git a/kernel/unwind/dwarf_cfi_kunit.c b/kernel/unwind/dwarf_cfi_kunit.c
new file mode 100644
index 000000000000..5e8e0ff2ec36
--- /dev/null
+++ b/kernel/unwind/dwarf_cfi_kunit.c
@@ -0,0 +1,767 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit tests for Minimal DWARF Call Frame Information (CFI) unwinder.
+ */
+
+#include <kunit/test.h>
+#include <linux/ftrace.h>
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
+static const struct dwarf_cfi_arch test_i386_arch = {
+	.ws	= 4,
+	.sp_reg	= 4,	/* esp */
+	.fp_reg	= 5,	/* ebp */
+	.ra_reg	= 8,	/* eip */
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
+	if (cie_insns_len) {
+		memcpy(p, cie_insns, cie_insns_len);
+		p += cie_insns_len;
+	}
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
+	if ((fde_enc & 0x07) == 0x03 || (arch->ws == 4 && (fde_enc & 0x0f) == 0)) {
+		put_unaligned_le32((u32)init_pc, p);
+		p += 4;
+		put_unaligned_le32((u32)pc_range, p);
+		p += 4;
+	} else {
+		put_unaligned_le64(init_pc, p);
+		p += 8;
+		put_unaligned_le64(pc_range, p);
+		p += 8;
+	}
+	if (aug[0] == 'z')
+		*p++ = 0;
+	if (fde_insns_len) {
+		memcpy(p, fde_insns, fde_insns_len);
+		p += fde_insns_len;
+	}
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
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x1000,
+						&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_SP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 8);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_SAME);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.ra_off, -8);
+
+	/* Mid-prologue (0x1002): CFA = rsp + 16 */
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x1002,
+						&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 16);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_SAME);
+
+	/* Body (0x1020): CFA = rsp + 56, r12/rbx spills ignored */
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x1020,
+						&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_SP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 56);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_SAME);
+
+	/* Out-of-range PC (0x1040) returns -ENOENT */
+	KUNIT_EXPECT_EQ(test, -ENOENT,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x1040,
+						&test_x86_64_arch, &row));
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
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x2008,
+						&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_FP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 16);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.fp_off, -16);
+
+	/* At early ret (0x2011): CFA = rsp + 8, FP restored to SAME */
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x2011,
+						&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_SP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 8);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_SAME);
+
+	/* After restore_state (0x2020): back to CFA = rbp + 16, FP at cfa-16 */
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x2020,
+						&test_x86_64_arch, &row));
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
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x2806,
+						&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_REG);
+	KUNIT_EXPECT_EQ(test, row.cfa_reg, 10);
+
+	/* Function body at 0x2820: CFA = *(rbp - 40), FP = *(rbp + 0) */
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x2820,
+						&test_x86_64_arch, &row));
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
+	/*
+	 * Matches 32-bit x86 vdso32 __kernel_rt_sigreturn ("zRS", data_align=-4):
+	 *   DW_CFA_def_cfa esp(4), 160 (&sigcontext)
+	 *   DW_CFA_offset_extended_sf eip(8), -14 (+56)
+	 *   DW_CFA_offset_extended_sf esp(4), -7  (+28)
+	 *   DW_CFA_offset_extended_sf ebp(5), -6  (+24)
+	 */
+	static const u8 vdso32_cie[] = { 0x0c, 4, 4 };
+	static const u8 vdso32_sig_insns[] = {
+		0x0c, 4, 0xa0, 0x01,
+		0x11, 8, 0x72,
+		0x11, 4, 0x79,
+		0x11, 5, 0x7a,
+	};
+	struct test_eh_blob blob;
+	struct dwarf_cfi_row row;
+
+	build_test_eh_blob(&blob, "zRS", 0x04, 0x2c00, 0x10,
+			   sig_insns, sizeof(sig_insns));
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x2c01,
+						&test_x86_64_arch, &row));
+	KUNIT_EXPECT_TRUE(test, row.signal);
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_SP_INDIRECT);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 160);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_SP_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.fp_off, 120);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_SP_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.ra_off, 168);
+
+	build_arch_eh_blob(&blob, &test_i386_arch, /*code_align=*/1,
+			   /*data_align_sleb=*/0x7c, "zRS", /*fde_enc=*/0x03,
+			   vdso32_cie, sizeof(vdso32_cie), /*init_pc=*/0x2d00,
+			   /*pc_range=*/0x08, vdso32_sig_insns,
+			   sizeof(vdso32_sig_insns));
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x2d00,
+						&test_i386_arch, &row));
+	KUNIT_EXPECT_TRUE(test, row.signal);
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_SP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 160);
+	KUNIT_EXPECT_EQ(test, row.sp_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.sp_off, 28);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.fp_off, 24);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.ra_off, 56);
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
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x4000,
+						&test_arm64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_base, DWARF_CFI_BASE_SP);
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 0);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_SAME);
+	KUNIT_EXPECT_FALSE(test, row.ra_signed);
+
+	/* Body at 0x400c: CFA=sp+32, FP@cfa-32, RA@cfa-24 (PAC-signed) */
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x400c,
+						&test_arm64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 32);
+	KUNIT_EXPECT_EQ(test, row.fp_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.fp_off, -32);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_OFFSET);
+	KUNIT_EXPECT_EQ(test, row.ra_off, -24);
+	KUNIT_EXPECT_TRUE(test, row.ra_signed);
+
+	/* Epilogue after autiasp at 0x401c: CFA=sp+0, RA=SAME (unsigned) */
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x401c,
+						&test_arm64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 0);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_SAME);
+	KUNIT_EXPECT_FALSE(test, row.ra_signed);
+
+	/* DW_CFA_AARCH64_negate_ra_state (0x2d) must be rejected on x86_64 */
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x400c,
+						&test_x86_64_arch, &row));
+
+	/* RISC-V leaf + non-leaf prologue */
+	build_arch_eh_blob(&blob, &test_riscv64_arch, /*code_align=*/1,
+			   /*data_align_sleb=*/0x7c, "zR", /*fde_enc=*/0x04,
+			   rv_cie, sizeof(rv_cie), /*init_pc=*/0x5000,
+			   /*pc_range=*/0x1a, rv_fde, sizeof(rv_fde));
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x5000,
+						&test_riscv64_arch, &row));
+	KUNIT_EXPECT_EQ(test, row.cfa_off, 0);
+	KUNIT_EXPECT_EQ(test, row.ra_rule, DWARF_CFI_RULE_SAME);
+
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x5008,
+						&test_riscv64_arch, &row));
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
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x3004,
+						&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   ra_expr_insns, sizeof(ra_expr_insns));
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x3004,
+						&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   deep_state_insns, sizeof(deep_state_insns));
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x3004,
+						&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   set_loc_insns, sizeof(set_loc_insns));
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x3004,
+						&test_x86_64_arch, &row));
+
+	/* 5. DW_EH_PE_indirect (0x80) in CIE 'R' encoding must be rejected */
+	build_test_eh_blob(&blob, "zR", /*fde_enc=*/0x80 | 0x04,
+			   /*init_pc=*/0x3000, /*pc_range=*/0x20,
+			   /*fde_insns=*/NULL, /*fde_insns_len=*/0);
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x3004,
+						&test_x86_64_arch, &row));
+
+	/* 6. Out-of-bounds FDE pointers (fde >= eh_end or fde < eh_start) must not underflow */
+	build_test_eh_blob(&blob, "zR", /*fde_enc=*/0x04, /*init_pc=*/0x3000,
+			   /*pc_range=*/0x20, /*fde_insns=*/NULL,
+			   /*fde_insns_len=*/0);
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.total_len + 64, blob.buf,
+						blob.buf + blob.total_len, 0x3004,
+						&test_x86_64_arch, &row));
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.total_len, blob.buf,
+						blob.buf + blob.total_len, 0x3004,
+						&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   sleb_pos_ovf, sizeof(sleb_pos_ovf));
+	KUNIT_EXPECT_EQ(test, -EOVERFLOW,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x3004,
+						&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   sleb_neg_ovf, sizeof(sleb_neg_ovf));
+	KUNIT_EXPECT_EQ(test, -EOVERFLOW,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x3004,
+						&test_x86_64_arch, &row));
+
+	build_test_eh_blob(&blob, "zR", 0x04, 0x3000, 0x20,
+			   def_off_after_ind, sizeof(def_off_after_ind));
+	KUNIT_EXPECT_EQ(test, -EINVAL,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len, 0x3004,
+						&test_x86_64_arch, &row));
+
+	/*
+	 * 9. Slow-path DW_EH_PE_sdata4 (0x0b) FDE pc_range with bit 31 set
+	 * (0xffffffe0) must be decoded unsigned rather than sign-extending to
+	 * 0xffffffffffffffe0 on 64-bit platforms.
+	 */
+#ifdef CONFIG_64BIT
+	build_test_eh_blob(&blob, "zR", /*fde_enc=*/0x0b,
+			   /*init_pc=*/0x10, /*pc_range=*/0xffffffe0UL,
+			   /*fde_insns=*/NULL, /*fde_insns_len=*/0);
+	KUNIT_EXPECT_EQ(test, -ENOENT,
+			dwarf_cfi_eval_fde_kmem(blob.buf + blob.fde_off, blob.buf,
+						blob.buf + blob.total_len,
+						0x100000000UL, &test_x86_64_arch,
+						&row));
+#endif
+}
+
+static void test_cfi_scan_eh_frame(struct kunit *test)
+{
+	const struct dwarf_cfi_arch native_arch = {
+		.ws	= sizeof(unsigned long),
+		.sp_reg	= 7,
+		.fp_reg	= 6,
+		.ra_reg	= 16,
+	};
+	static const u8 cie_insns[] = { 0x0c, 7, sizeof(unsigned long) };
+	struct test_eh_blob b1, b2;
+	struct eh_frame_hdr_entry entries[2];
+	u8 combined[512];
+	unsigned long base;
+	unsigned int count = 0;
+	size_t fde2_len;
+
+	base = (unsigned long)combined;
+	build_arch_eh_blob(&b1, &native_arch, /*code_align=*/1,
+			   /*data_align_sleb=*/0x78, "zR", /*fde_enc=*/0x00,
+			   cie_insns, sizeof(cie_insns), base + 0x100, 0x20,
+			   /*fde_insns=*/NULL, /*fde_insns_len=*/0);
+	build_arch_eh_blob(&b2, &native_arch, /*code_align=*/1,
+			   /*data_align_sleb=*/0x78, "zR", /*fde_enc=*/0x00,
+			   cie_insns, sizeof(cie_insns), base + 0x200, 0x30,
+			   /*fde_insns=*/NULL, /*fde_insns_len=*/0);
+
+	memset(combined, 0, sizeof(combined));
+	memcpy(combined, b1.buf, b1.total_len);
+	fde2_len = b2.total_len - b2.fde_off;
+	memcpy(combined + b1.total_len, b2.buf + b2.fde_off, fde2_len);
+	/* Point second FDE's CIE_pointer back to the shared CIE at offset 0 */
+	put_unaligned_le32((u32)(b1.total_len + 4), combined + b1.total_len + 4);
+
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_scan_eh_frame_kmem(combined,
+						     b1.total_len + fde2_len + 4,
+						     &native_arch, base,
+						     /*entries=*/NULL,
+						     /*max_entries=*/0, &count));
+	KUNIT_EXPECT_EQ(test, count, 2U);
+
+	KUNIT_EXPECT_EQ(test, -ENOSPC,
+			dwarf_cfi_scan_eh_frame_kmem(combined,
+						     b1.total_len + fde2_len + 4,
+						     &native_arch, base, entries,
+						     /*max_entries=*/1, &count));
+
+	KUNIT_ASSERT_EQ(test, 0,
+			dwarf_cfi_scan_eh_frame_kmem(combined,
+						     b1.total_len + fde2_len + 4,
+						     &native_arch, base, entries,
+						     ARRAY_SIZE(entries), &count));
+	KUNIT_EXPECT_EQ(test, count, 2U);
+	KUNIT_EXPECT_EQ(test, entries[0].start_off, 0x100);
+	KUNIT_EXPECT_EQ(test, entries[0].fde_off, (s32)b1.fde_off);
+	KUNIT_EXPECT_EQ(test, entries[1].start_off, 0x200);
+	KUNIT_EXPECT_EQ(test, entries[1].fde_off, (s32)b1.total_len);
+}
+
+#ifdef CONFIG_STACKTRACE
+struct live_walk_ctx {
+	unsigned long *entries;
+	unsigned int size;
+	unsigned long leaf_ip;
+	unsigned long realign_ip;
+	unsigned long mid_ip;
+	unsigned long caller_ip;
+	unsigned long caller_addr0;
+	unsigned long caller_addr1;
+};
+
+static noinline unsigned int unwind_test_leaf(struct live_walk_ctx *ctx)
+{
+	unsigned int nr;
+
+	nr = stack_trace_save(ctx->entries, ctx->size, /*skipnr=*/0);
+	ctx->caller_addr0 = CALLER_ADDR0;
+	ctx->caller_addr1 = CALLER_ADDR1;
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
+	KUNIT_EXPECT_TRUE(test, ip_within(ctx.caller_addr0, ctx.realign_ip));
+	if (ctx.caller_addr1)
+		KUNIT_EXPECT_TRUE(test, ip_within(ctx.caller_addr1, ctx.mid_ip));
+
+	if (IS_ENABLED(CONFIG_HAVE_RELIABLE_STACKTRACE)) {
+		rel_nr = stack_trace_save_tsk_reliable(current, entries,
+						       ARRAY_SIZE(entries));
+		KUNIT_EXPECT_GT(test, rel_nr, 0);
+	}
+}
+#else
+static void test_live_kernel_stack_walk(struct kunit *test)
+{
+	kunit_skip(test, "CONFIG_STACKTRACE disabled");
+}
+#endif /* CONFIG_STACKTRACE */
+
+static struct kunit_case dwarf_cfi_test_cases[] = {
+	KUNIT_CASE(test_cfi_sp_and_ignored_gprs),
+	KUNIT_CASE(test_cfi_fp_and_remember_restore),
+	KUNIT_CASE(test_cfi_drap_realigned_frame),
+	KUNIT_CASE(test_cfi_sigreturn_frame),
+	KUNIT_CASE(test_cfi_arm64_pac_and_riscv_leaf),
+	KUNIT_CASE(test_cfi_security_rejections),
+	KUNIT_CASE(test_cfi_scan_eh_frame),
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
2.56.1.831.g720f3f5937-goog

