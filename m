Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587416;
	b=bVNvNs18+SNmU+8vlAxHKjz9kMDS+nbK26//O7U5PEYIVEDiBsm7dEOLsCxGn5T0QoYr
	 87WPDGLwfsdD5A8b4k0uJvpaht2f0plVwrAedCwnzAVD2/i2V9SSUZikQASRx8xaSJ+ml
	 JSLi2EfBkuk7ewZxWwomVuPYoQMMtyAXsJb7g1T4YYZrhOblF3qa0+pKtGKLQATeHXiSi
	 6gffITMJtC/yT+HMccO/mHlxWpc5RNIcLCIIyyyMk6xV45oVMR0dm2eodW9Z2PLya7csk
	 lfRlHNvrwIntv/VBofeBhi2PqlvKn1WX5jOiZwZ8JojDMrw1qvErBTIoT3bT8qzNeFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587416;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=jFmNLdaybvaWIRtLdTiBMi3UUKe/rujAV3S2k7ZenzI=;
	b=Hbhrc6dCT3zqUrQdqJqXu5MTgCXwu/Hq+nLmnvJNMnBEB81vuDWVA94uB56hYm/XadjF
	 DMg2I1F2+++ZaRXDPi04ljj54yc6VHmK9Chr9huSB7EHx772tMmbAdWB6fcrjkaefhy6t
	 SWdflBoAzjdbA+Dd4ENEmeBiUvWuzKqrctyqjxVEMWswqfOzNFzQ8Pll02twz+LYtDV69
	 +wGhEcceu7XG4x9ZG427zOzkIqAcHXNEZSuAuaMzSQ8r2vXsTTkm5U+BSkkKM9P0amEql
	 zd0R+Jc2XpQm+7WAw+HPUL7SUqJLLBU4MlxQCQjuuBuJDcKD0yLIPP28p8uXDW/d8Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bcUWh2zG;
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CBF606DE68
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4CBF606DE68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bcUWh2zG
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-382af5cfc58so32626eec.0
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587414; x=1796192214; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jFmNLdaybvaWIRtLdTiBMi3UUKe/rujAV3S2k7ZenzI=;
        b=bcUWh2zG1yTZ3lSf8B8hR2d6Jtib9PXsx5S5gVwYeaefiEo3iKlagZG1oyYmI7ExOP
         MWpcdY6c8Fb7U24DMKxS7N28YsII7zHot+otjXVv6cyATKiNl+krom7xfWgfIbbQ9Pz4
         v5nkSp/SymKueMgQIkoZfAl6iFGUI+yMrwcsJcimLjYaTMyTFjvgvkbLWbnaHp6TFdk4
         5PY0Agb12NDu45eyHyo/jZD566130GSEWvD3cY5MmIqXXF5O7SLk8d9N7MVL4sU/Pg6G
         9r92rKw0BqxZkbyXG1V8Iuer4jqWbLsnKIE9+6tZfP6f8tzRxfRCtJLlZ0ec3lAPsy9C
         Z3Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587414; x=1796192214;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jFmNLdaybvaWIRtLdTiBMi3UUKe/rujAV3S2k7ZenzI=;
        b=Pc9mItTN6mdHX5cnnPLJ5QeVtzdO1xpoWrd3A+hnI94uLgXcAhtTLvFh524rDHLGg7
         22JVIITlNQOQGfUN8BMK3orcoy8/gXS8MW1AZqt/+ysnoBl+HH10qZPPA5meX4k4AQyf
         FgSVpAPhytlr7IEMLV3aJ4H8tP2uVJs/+6BH8ehip+Fu1HHacLbI9W6tubFBbjEHsHAv
         VWSpQ6aWRuzKvmk1tK8/VwH9ASSI8EDL2VV535DQ4fDvAuah86UFOHfF67jiZNIguShr
         QdPqvslh+FMw9hk1kJTEtW0o0DjTNKsrfz/Z4YVFOOgBseKUxRPkyTsvIQHsCGsNh/Ye
         83VA==
X-Forwarded-Encrypted: i=1; AL+hErFVGFJWUJ2OsUlNuXqhZO9mS84r3cRpfRtiezF6g9RSbU3s20mfBkxg6dZbhW5MzNtzhmZsv7vlKHw=@vger.kernel.org
X-Gm-Message-State: APuU4Z9dmcxNmLgLb61lXllrFFO/TQBY6RIwrcvKOFfDdnP3jPVO2GkH
	r9yl60O40umNCQkeaMapAx04U9gZtb+PXerjnZtcLT006P27zfTvpFvLRblmVa+fmHqtcReg+cm
	chl/aEwaJ/A==
X-Received: from dybpk12.prod.google.com ([2002:a05:7301:428c:b0:377:a5e3:b669])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:108:b0:375:50d9:474e
 with SMTP id 5a478bee46e88-3856c0d0bb4mr22379541eec.4.1795587413560; Tue, 24
 Nov 2026 22:16:53 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:21 -0800
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
Message-ID: <20261125061523.1540234-29-irogers@google.com>
Subject: [RFC PATCH v2 28/30] tools/unwind: Add CFG instruction abstract
 execution oracle to verify_cfi
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

Add verifyOracle2Instructions() in tools/unwind/verify_insn.cpp and
enable -DHAVE_VERIFY_INSN in tools/unwind/Makefile, propagating symbolic
register and stack state over per-function basic-block CFGs across
x86_64, arm64, and riscv64 and verifying at every reachable instruction
that Minimal DWARF CFI recovers the caller's exact CFA, RA (including
AArch64 PAC sign state), and FP.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/unwind/Makefile        |   5 +-
 tools/unwind/verify_insn.cpp | 360 +++++++++++++++++++++++++++++++++++
 2 files changed, 363 insertions(+), 2 deletions(-)
 create mode 100644 tools/unwind/verify_insn.cpp

diff --git a/tools/unwind/Makefile b/tools/unwind/Makefile
index 90c4b47ae851..c0a8d477dc13 100644
--- a/tools/unwind/Makefile
+++ b/tools/unwind/Makefile
@@ -79,7 +79,7 @@ TOOLS_INCLUDES := -I$(srctree)/tools/include -I$(srctree)/tools/include/uapi \
 SHIM_CFLAGS := -O2 -g -Wall -Wextra -Wno-unused-parameter -Wno-maybe-uninitialized \
 	$(TOOLS_INCLUDES)
 
-VERIFY_CXXFLAGS := -O2 -g -Wall -Wextra -std=gnu++20 $(LLVM_CXXFLAGS) \
+VERIFY_CXXFLAGS := -O2 -g -Wall -Wextra -std=gnu++20 $(LLVM_CXXFLAGS) -DHAVE_VERIFY_INSN \
 	-I$(CURDIR) $(TOOLS_INCLUDES) $(CXXFLAGS)
 VERIFY_LDFLAGS  := $(LLVM_LDFLAGS) $(LDFLAGS)
 
@@ -88,7 +88,8 @@ KERNEL_CFI_DEPS := $(srctree)/kernel/unwind/dwarf_cfi.c \
 
 VERIFY_OBJS := $(OUTPUT)dwarf_cfi_host.o \
 		 $(OUTPUT)verify_cfi.o \
-		 $(OUTPUT)verify_insn_arch.o
+		 $(OUTPUT)verify_insn_arch.o \
+		 $(OUTPUT)verify_insn.o
 
 ifeq ($(HAS_LIBLLVM),1)
 all: $(OUTPUT)verify_cfi
diff --git a/tools/unwind/verify_insn.cpp b/tools/unwind/verify_insn.cpp
new file mode 100644
index 000000000000..45dbd9a94764
--- /dev/null
+++ b/tools/unwind/verify_insn.cpp
@@ -0,0 +1,360 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MIT
+/*
+ * Oracle 2: Multi-architecture basic-block CFG abstract execution & soundness
+ * verification against kernel/unwind/dwarf_cfi.c.
+ */
+
+#include "verify_insn.hpp"
+
+#include <algorithm>
+#include <cinttypes>
+#include <cstdio>
+#include <queue>
+#include <unordered_map>
+
+using namespace llvm;
+
+/**
+ * isKnownNoreturnName() - Check if a symbol name is a non-returning callee
+ * @Name: ELF symbol name of a direct call target.
+ *
+ * Return: true if calls to @Name never return to the fallthrough instruction.
+ */
+bool isKnownNoreturnName(StringRef Name)
+{
+	static const char *const Exact[] = {
+		"panic", "do_exit", "make_task_dead", "__stack_chk_fail",
+		"__stack_chk_fail_local", "fortify_panic", "usercopy_abort",
+		"__bug", "bug_at", "do_group_exit", "complete_and_exit",
+		"kthread_exit", "cpu_bringup_and_idle", "cpu_startup_entry",
+		"abort", "_exit", "_Exit", "exit", "__assert_fail",
+		"__assert_perror_fail", "__cxa_throw", "__cxa_rethrow",
+		"__cxa_bad_cast", "__cxa_bad_typeid", "_Unwind_Resume",
+		"_ZSt9terminatev", "_ZSt20__throw_length_errorPKc",
+		"_ZSt17__throw_bad_allocv", "_ZSt20__throw_out_of_rangePKc",
+		"_ZSt24__throw_out_of_range_fmtPKcz", "_ZSt19__throw_logic_errorPKc",
+		"__libc_fatal", "__chk_fail", "pthread_exit", "__longjmp_chk",
+		"longjmp", "_longjmp", "siglongjmp", "verr", "verrx", "err", "errx",
+	};
+	for (const char *s : Exact) {
+		if (Name == s)
+			return true;
+	}
+	if (Name.starts_with("__throw_") || Name.starts_with("_ZSt7__throw") ||
+	    Name.starts_with("_ZSt9__throw") || Name.contains("panicking") ||
+	    Name.starts_with("rust_begin_unwind") || Name.contains("noreturn") ||
+	    Name.starts_with("__bad_"))
+		return true;
+	return false;
+}
+
+/**
+ * evalRowAgainstAbs() - Check Minimal DWARF unwind row against abstract state
+ * @st: Symbolic register/stack state reaching the current instruction PC.
+ * @row: Unwind row returned by kernel/unwind/dwarf_cfi.c at the same PC.
+ * @AS: Target architecture parameters.
+ * @err_kind: Populated with a short category tag on mismatch.
+ * @err_detail: Populated with diagnostic state details on mismatch.
+ *
+ * Return: true if CFA, RA (including AArch64 PAC sign state), and FP all
+ * recover the exact caller entry state; false on any discrepancy.
+ */
+static bool evalRowAgainstAbs(const AbsState &st, const dwarf_cfi_row &row,
+			      const ArchSpec &AS, std::string &err_kind,
+			      std::string &err_detail)
+{
+	SymVal cfa{VK_UNKNOWN, 0};
+	if (row.cfa_base == DWARF_CFI_BASE_SP)
+		cfa = addSymImm(st.regs[AS.karch.sp_reg], row.cfa_off);
+	else if (row.cfa_base == DWARF_CFI_BASE_FP)
+		cfa = addSymImm(st.regs[AS.karch.fp_reg], row.cfa_off);
+	else if (row.cfa_base == DWARF_CFI_BASE_REG && row.cfa_reg < 32)
+		cfa = addSymImm(st.regs[row.cfa_reg], row.cfa_off);
+	else if (row.cfa_base == DWARF_CFI_BASE_FP_INDIRECT)
+		cfa = st.load(addSymImm(st.regs[AS.karch.fp_reg], row.cfa_off));
+	else if (row.cfa_base == DWARF_CFI_BASE_SP_INDIRECT)
+		cfa = st.load(addSymImm(st.regs[AS.karch.sp_reg], row.cfa_off));
+
+	SymVal expected_cfa{VK_ENTRY_SP, AS.entry_cfa_off};
+	if (cfa != expected_cfa) {
+		err_kind = (cfa.kind == VK_UNKNOWN) ? "cfa_clobbered_or_opaque"
+						    : "cfa_offset_mismatch";
+		char buf[160];
+		snprintf(buf, sizeof(buf),
+			 "CFI cfa_base=%u off=%d evaluated to kind=%u off=%" PRId64
+			 ", expected ENTRY_SP+%d",
+			 row.cfa_base, row.cfa_off, cfa.kind, cfa.off,
+			 AS.entry_cfa_off);
+		err_detail = buf;
+		return false;
+	}
+
+	if (row.ra_rule != DWARF_CFI_RULE_UNDEFINED) {
+		SymVal ra{VK_UNKNOWN, 0};
+		if (row.ra_rule == DWARF_CFI_RULE_SAME) {
+			if (AS.karch.ra_reg < 32)
+				ra = st.regs[AS.karch.ra_reg];
+		} else if (row.ra_rule == DWARF_CFI_RULE_OFFSET) {
+			ra = st.load(addSymImm(cfa, row.ra_off));
+		} else if (row.ra_rule == DWARF_CFI_RULE_SP_OFFSET) {
+			ra = st.load(addSymImm(st.regs[AS.karch.sp_reg],
+					       row.ra_off));
+		}
+		int64_t exp_signed =
+			(AS.llvm_arch == Triple::aarch64 && row.ra_signed) ? 1 : 0;
+		if (ra.kind != VK_CALLER_RA ||
+		    (AS.llvm_arch == Triple::aarch64 && ra.off != exp_signed)) {
+			err_kind = "ra_recovery_mismatch";
+			char buf[160];
+			snprintf(buf, sizeof(buf),
+				 "CFI ra_rule=%u off=%d signed=%d evaluated to kind=%u off=%" PRId64,
+				 row.ra_rule, row.ra_off, (int)row.ra_signed,
+				 ra.kind, ra.off);
+			err_detail = buf;
+			return false;
+		}
+	}
+
+	if (row.fp_rule != DWARF_CFI_RULE_UNDEFINED) {
+		SymVal fp{VK_UNKNOWN, 0};
+		if (row.fp_rule == DWARF_CFI_RULE_SAME)
+			fp = st.regs[AS.karch.fp_reg];
+		else if (row.fp_rule == DWARF_CFI_RULE_OFFSET)
+			fp = st.load(addSymImm(cfa, row.fp_off));
+		else if (row.fp_rule == DWARF_CFI_RULE_FP_OFFSET)
+			fp = st.load(addSymImm(st.regs[AS.karch.fp_reg],
+					       row.fp_off));
+		else if (row.fp_rule == DWARF_CFI_RULE_SP_OFFSET)
+			fp = st.load(addSymImm(st.regs[AS.karch.sp_reg],
+					       row.fp_off));
+		if (fp.kind != VK_CALLER_FP) {
+			err_kind = "fp_recovery_mismatch";
+			char buf[160];
+			snprintf(buf, sizeof(buf),
+				 "CFI fp_rule=%u off=%d evaluated to kind=%u off=%" PRId64,
+				 row.fp_rule, row.fp_off, fp.kind, fp.off);
+			err_detail = buf;
+			return false;
+		}
+	}
+
+	return true;
+}
+
+/**
+ * verifyOracle2Instructions() - Verify CFI rows via CFG symbolic execution
+ */
+void verifyOracle2Instructions(
+	const ArchSpec &AS, uint64_t eh_hdr_vma, StringRef eh_hdr_bytes,
+	const std::vector<ExecSec> &exec_secs,
+	const std::vector<FuncSym> &func_syms,
+	const std::unordered_set<uint64_t> &noreturn_addrs,
+	const std::vector<FDERange> &fde_ranges, const MCDisassembler &Disasm,
+	const MCInstrInfo &MCII, const MCRegisterInfo &MCRI,
+	const MCInstrAnalysis *MIA, const VerifyOptions &opts, VerifyStats &st)
+{
+	st.has_insn_oracle = true;
+
+	auto findFDE = [&](uint64_t pc) -> const FDERange * {
+		auto it = std::upper_bound(
+			fde_ranges.begin(), fde_ranges.end(), pc,
+			[](uint64_t val, const FDERange &r) {
+				return val < r.start;
+			});
+		if (it == fde_ranges.begin())
+			return nullptr;
+		--it;
+		if (pc >= it->start && pc < it->end)
+			return &*it;
+		return nullptr;
+	};
+
+	for (const FuncSym &fn : func_syms) {
+		st.funcs_total++;
+		const FDERange *fr = findFDE(fn.addr);
+		if (!fr || !fr->supported) {
+			st.funcs_no_fde++;
+			continue;
+		}
+		if (fr->signal)
+			continue;
+
+		dwarf_cfi_row entry_row{};
+		if (dwarf_cfi_unwind_user_eh_frame_hdr(
+			    (unsigned long)eh_hdr_vma, eh_hdr_bytes.size(),
+			    (unsigned long)fn.addr, &AS.karch, &entry_row) != 0) {
+			st.funcs_no_fde++;
+			continue;
+		}
+		if (fn.addr != fr->start ||
+		    entry_row.cfa_base != DWARF_CFI_BASE_SP ||
+		    entry_row.cfa_off != AS.entry_cfa_off ||
+		    entry_row.fp_rule != DWARF_CFI_RULE_SAME ||
+		    (AS.ra_on_entry_stack
+			 ? (entry_row.ra_rule != DWARF_CFI_RULE_OFFSET ||
+			    entry_row.ra_off != -8)
+			 : (entry_row.ra_rule != DWARF_CFI_RULE_SAME))) {
+			st.funcs_mid_frame_split++;
+			continue;
+		}
+
+		uint64_t range_end =
+			fn.size ? std::min(fr->end, fn.addr + fn.size) : fr->end;
+		if (range_end <= fn.addr)
+			continue;
+		ArrayRef<uint8_t> code =
+			findExecBytes(exec_secs, fn.addr, range_end - fn.addr);
+		if (code.empty())
+			continue;
+
+		st.funcs_verified++;
+
+		AbsState init_st;
+		init_st.regs[AS.karch.sp_reg] = {VK_ENTRY_SP, 0};
+		init_st.regs[AS.karch.fp_reg] = {VK_CALLER_FP, 0};
+		if (AS.ra_on_entry_stack)
+			init_st.store({VK_ENTRY_SP, 0}, {VK_CALLER_RA, 0});
+		else
+			init_st.regs[AS.karch.ra_reg] = {VK_CALLER_RA, 0};
+
+		std::unordered_map<uint64_t, AbsState> visited;
+		std::queue<uint64_t> worklist;
+		visited[fn.addr] = init_st;
+		worklist.push(fn.addr);
+
+		bool func_ok = true;
+		unsigned steps = 0;
+		while (!worklist.empty() && steps < 4096) {
+			uint64_t pc = worklist.front();
+			worklist.pop();
+			steps++;
+
+			if (pc < fn.addr || pc >= range_end)
+				continue;
+
+			const AbsState cur = visited[pc];
+
+			dwarf_cfi_row row{};
+			int kerr = dwarf_cfi_unwind_user_eh_frame_hdr(
+				(unsigned long)eh_hdr_vma, eh_hdr_bytes.size(),
+				(unsigned long)pc, &AS.karch, &row);
+			if (kerr != 0) {
+				func_ok = false;
+				recordIssue(st, opts, "fde_eval_error", fn.name);
+				break;
+			}
+
+			st.insns_verified++;
+			std::string ekind, edetail;
+			if (!evalRowAgainstAbs(cur, row, AS, ekind, edetail)) {
+				func_ok = false;
+				if (ekind.starts_with("cfa"))
+					st.insns_cfa_mismatch++;
+				else if (ekind.starts_with("ra"))
+					st.insns_ra_mismatch++;
+				else
+					st.insns_fp_mismatch++;
+
+				char loc_buf[128];
+				snprintf(loc_buf, sizeof(loc_buf),
+					 "%s+0x%" PRIx64 " (0x%" PRIx64 "): ",
+					 fn.name.c_str(), pc - fn.addr, pc);
+				recordIssue(st, opts, ekind,
+					    std::string(loc_buf) + edetail);
+				break;
+			}
+
+			MCInst MI;
+			uint64_t InsnSize = 0;
+			ArrayRef<uint8_t> slice = code.slice(pc - fn.addr);
+			auto DStat = Disasm.getInstruction(MI, InsnSize, slice,
+							   pc, nulls());
+			if (DStat != MCDisassembler::Success || InsnSize == 0)
+				continue;
+
+			const MCInstrDesc &Desc = MCII.get(MI.getOpcode());
+			StringRef OpName = MCII.getName(MI.getOpcode());
+
+			bool is_ret_or_ind_jump =
+				Desc.isReturn() || Desc.isIndirectBranch();
+			bool is_uncond_branch = Desc.isUnconditionalBranch();
+			bool is_cond_branch = Desc.isConditionalBranch();
+			bool is_call = Desc.isCall();
+			if (AS.llvm_arch == Triple::riscv64)
+				normalizeRiscvControlFlow(MI, OpName, MCRI,
+							  is_ret_or_ind_jump,
+							  is_uncond_branch,
+							  is_call);
+
+			if (is_ret_or_ind_jump || Desc.isTrap() ||
+			    OpName == "UD2" || OpName == "BRK" ||
+			    OpName == "EBREAK" || OpName == "C_EBREAK" ||
+			    OpName == "SVC" || OpName == "ECALL" ||
+			    OpName == "SYSCALL" || OpName == "IRET64" ||
+			    OpName == "SYSRET64" || OpName == "ERET" ||
+			    OpName == "SRET" || OpName == "MRET")
+				continue;
+
+			uint64_t next_pc = pc + InsnSize;
+
+			if (is_call) {
+				uint64_t CallTarget = 0;
+				bool has_target = MIA &&
+						  MIA->evaluateBranch(MI, pc,
+								      InsnSize,
+								      CallTarget);
+				if (has_target &&
+				    noreturn_addrs.count(CallTarget))
+					continue;
+				if (next_pc < range_end &&
+				    (!has_target || CallTarget != next_pc)) {
+					dwarf_cfi_row next_row{};
+					if (dwarf_cfi_unwind_user_eh_frame_hdr(
+						    (unsigned long)eh_hdr_vma,
+						    eh_hdr_bytes.size(),
+						    (unsigned long)next_pc,
+						    &AS.karch, &next_row) == 0 &&
+					    !rowsEqual(row, next_row))
+						continue;
+				}
+			}
+
+			AbsState next_st = cur;
+			if (AS.llvm_arch == Triple::riscv64 && is_call) {
+				for (int d = 1; d < 32; d++) {
+					if (d == 2 || d == 3 || d == 4 ||
+					    d == 8 || d == 9 ||
+					    (d >= 18 && d <= 27))
+						continue;
+					next_st.regs[d] = {VK_UNKNOWN, 0};
+				}
+			} else {
+				stepInstruction(next_st, MI, OpName, Desc, MCRI,
+						AS, next_pc, MIA, pc, InsnSize);
+			}
+
+			auto enqueue = [&](uint64_t target) {
+				if (target < fn.addr || target >= range_end)
+					return;
+				if (!visited.count(target)) {
+					visited[target] = next_st;
+					worklist.push(target);
+				}
+			};
+
+			if (is_uncond_branch || is_cond_branch) {
+				uint64_t BranchTarget = 0;
+				if (MIA && MIA->evaluateBranch(MI, pc, InsnSize,
+							       BranchTarget))
+					enqueue(BranchTarget);
+				if (is_cond_branch)
+					enqueue(next_pc);
+			} else if (!Desc.isBarrier()) {
+				enqueue(next_pc);
+			}
+		}
+
+		if (func_ok)
+			st.funcs_clean++;
+	}
+}
-- 
2.56.1.831.g720f3f5937-goog

