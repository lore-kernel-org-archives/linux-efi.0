Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587414;
	b=N5al2VUKsG8EK7WxsKu3iNrHXnu8x/RaWgI3hUf5t9SVHu3Il1CNkUzoYB+CMYIiuf8p
	 6PtnIO9A6Fj/IjvKz2Ctxi8X3me3dw+jce0iT604unrSIFCqtt8hHqAZ3wZSq+dlSPnqz
	 BqtSVPRsvQdGeN0WUVABgwPffjqX0GJUVlbmg/bFPMI/orPrSCb3gVljvqVTFsJo79603
	 g5adVllMNcB42hoiPs/6A1Ck2Qac1V8nEsLcUuGCjEt2vZ2mRFIO3K75lDS2D5vXeTc1c
	 ksH63IGOk2RMO1mh19a9zp9YUVDVecsI8FZ6QmyLN1xw/lp0SHR5+8DSXj/IykXhMkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587414;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=aK4o1KtNSct914ybInt90HQJKGGS9p5ZPE/6mzCvfcY=;
	b=Vmmp4A4KMytnzQOGiTBeBc+NzAefp0DBWin63/9BPLBavX7hLCPnZYzFjAHC7+bIyyWH
	 UTuaU7nFeqTDlLWBLDITsjGD6Rg2CbaXPZsfvv09hChNeGcqlc3R2dk4mLOw3DvS4KD2D
	 SdKAtlwPRO5MJBAuv1QKI3RK11sprinODenokDXHrNLw7FiDXgQ+kP3bWjLJPLOFHU6YN
	 FvE3YWQPyChDlL0dtGEGdZiyZfB27lk6OTN1T3hyLedcUdIKOzArFYc9sBcEXSikUjxM9
	 bs0fk91If8grFo0SI2J1zQjRainvE7ceVSqOoMjDjfDqubHyyT3qG21zJovxYMsV80A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZMGCM3lR;
	arc=none smtp.remote-ip=74.125.82.71
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEEB606BD24
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EEEB606BD24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZMGCM3lR
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1b25d977b91so5808350c88.1
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587412; x=1796192212; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aK4o1KtNSct914ybInt90HQJKGGS9p5ZPE/6mzCvfcY=;
        b=ZMGCM3lR9EzbkO8QIqkDdzk0vcoih8Uk4Vw6t3UTzqvEfnzU5qk9ODgUwHR0v1kPZB
         kmPGPD6iWwCDStLXh+GYMmnsjB8HPJ8VpU7pPHVRd//iH2otsxrRcDLj5QL/JQnXB2H7
         kxlF9K9Pqz2KFGGlODj18HCTbtxIYT+93WXFYOQD/sPlw77ZZ5sYpphyYPi8aYcGUAN7
         O8BOm1Vh3+23XRzkv2PheKcBXJNZTM98nI5xYaT0jJ2h5dypwqMrlbXrCafbl/Bdd8QN
         SQGNlNqiHh75W78Ai+KisuSCmNdYidY6WHT74uYW4oqoXRtjaTZ95DQd4zYV54+/kK0I
         shfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587412; x=1796192212;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aK4o1KtNSct914ybInt90HQJKGGS9p5ZPE/6mzCvfcY=;
        b=B6LO093crPLoJPLghdXpGiqnhLTnLuKL9QVftRuYU6KSsMj1nuuGy8rzrFr6BWmKTE
         ZBovutvJa6hYldjXon9Ar6nCWnsAZq1gd7hwIJc54/Rb9SnvbIKFhgmxgHZK0OjGozC3
         XnU6QO14KMiGFIv6lI1GtqxHTC7sbkzyHUtkcPO/oCSeB0xFn9Ua/SUHVCJh/lMvJ2Q9
         BQ6qTT47YC5DNGbe0qASsfTj+GeW7n/1SI8iKdeVdp0OeqTL2lign0mdmb1j+gsD6DnU
         RhCk+DsRsOQpxEkJOMneNZnI/ZFb6bhS1WrMMCJ1lh6by3x0m960cayNB4+muAvJ2TB/
         vaxQ==
X-Forwarded-Encrypted: i=1; AL+hErG5MxRBqFrQ5mH1fVxN4lMm0ElvFycNfPaoEqWLOTmKXRwopcNyLTjeKBT8EK3B068pt91fLwJi/8s=@vger.kernel.org
X-Gm-Message-State: APuU4Z/cJtS0vapk2Hi7Obeb/QcQ5AOx2WHxQ2w/95EqPMHcEYHoiMuE
	amd2G5kotj2E+U7CpWteVaMpv7saUu1W0Xnatkd1/rZUru+FLfp0SfFbX8wRBdCXuBsD+Xlzd3l
	RQ4c9eo/gig==
X-Received: from dldz9-n2.prod.google.com ([2002:a05:701b:4189:20b0:1b5:9ce:e6d5])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:ea26:b0:1b5:58e:b547
 with SMTP id a92af1059eb24-1b5568aa9admr19561132c88.22.1795587411607; Tue, 24
 Nov 2026 22:16:51 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:20 -0800
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
Message-ID: <20261125061523.1540234-28-irogers@google.com>
Subject: [RFC PATCH v2 27/30] tools/unwind: Add multi-arch symbolic
 instruction lifters for verify_cfi
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

Add the symbolic stack/register abstract domain (verify_insn.hpp),
per-architecture Tier-2 instruction lifters (stepInstructionX86(),
stepInstructionArm64(), stepInstructionRiscv(), and
normalizeRiscvControlFlow()), and the conservative Tier-1 MCInstrDesc /
MCRegisterInfo register-def clobber fallback (clobberGenericDefs()) in
verify_insn_arch.cpp.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/unwind/Makefile             |   3 +-
 tools/unwind/verify_insn.hpp      | 103 ++++
 tools/unwind/verify_insn_arch.cpp | 757 ++++++++++++++++++++++++++++++
 3 files changed, 862 insertions(+), 1 deletion(-)
 create mode 100644 tools/unwind/verify_insn.hpp
 create mode 100644 tools/unwind/verify_insn_arch.cpp

diff --git a/tools/unwind/Makefile b/tools/unwind/Makefile
index ca6b84dbd31a..90c4b47ae851 100644
--- a/tools/unwind/Makefile
+++ b/tools/unwind/Makefile
@@ -87,7 +87,8 @@ KERNEL_CFI_DEPS := $(srctree)/kernel/unwind/dwarf_cfi.c \
 		   $(srctree)/tools/include/linux/unwind_dwarf_cfi.h
 
 VERIFY_OBJS := $(OUTPUT)dwarf_cfi_host.o \
-		 $(OUTPUT)verify_cfi.o
+		 $(OUTPUT)verify_cfi.o \
+		 $(OUTPUT)verify_insn_arch.o
 
 ifeq ($(HAS_LIBLLVM),1)
 all: $(OUTPUT)verify_cfi
diff --git a/tools/unwind/verify_insn.hpp b/tools/unwind/verify_insn.hpp
new file mode 100644
index 000000000000..c0d2711b716e
--- /dev/null
+++ b/tools/unwind/verify_insn.hpp
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MIT */
+#ifndef _TOOLS_UNWIND_VERIFY_INSN_H
+#define _TOOLS_UNWIND_VERIFY_INSN_H
+
+#include "verify_cfi.hpp"
+
+/**
+ * enum ValKind - Symbolic lattice value kinds tracked in registers and stack
+ * @VK_UNKNOWN: Clobbered, runtime-dependent, or unmodeled value.
+ * @VK_ENTRY_SP: Value equal to function-entry SP + @off.
+ * @VK_ALIGNED_SP: Post-realignment SP + @off (after `and $-align, sp` DRAP).
+ * @VK_CALLER_FP: Preserved caller frame pointer value at function entry.
+ * @VK_CALLER_RA: Preserved caller return address (@off == 1 when PAC-signed).
+ * @VK_CONST: Known 64-bit integer constant (e.g. >4KB frame size setup).
+ */
+enum ValKind : uint8_t {
+	VK_UNKNOWN = 0,
+	VK_ENTRY_SP,
+	VK_ALIGNED_SP,
+	VK_CALLER_FP,
+	VK_CALLER_RA,
+	VK_CONST,
+};
+
+struct SymVal {
+	ValKind kind = VK_UNKNOWN;
+	int64_t off = 0;
+
+	bool operator==(const SymVal &o) const
+	{
+		return kind == o.kind && (kind == VK_UNKNOWN || off == o.off);
+	}
+	bool operator!=(const SymVal &o) const { return !(*this == o); }
+};
+
+struct StackKey {
+	uint8_t base; // VK_ENTRY_SP or VK_ALIGNED_SP
+	int64_t off;
+	bool operator<(const StackKey &o) const
+	{
+		return base != o.base ? base < o.base : off < o.off;
+	}
+	bool operator==(const StackKey &o) const
+	{
+		return base == o.base && off == o.off;
+	}
+};
+
+/**
+ * struct AbsState - Per-PC abstract machine state during CFG symbolic execution
+ * @regs: Symbolic values of DWARF registers 0..31.
+ * @stack: Sparse symbolic stack slots keyed by (ENTRY_SP | ALIGNED_SP) + offset.
+ */
+struct AbsState {
+	SymVal regs[32];
+	std::map<StackKey, SymVal> stack;
+
+	SymVal load(const SymVal &addr) const
+	{
+		if (addr.kind != VK_ENTRY_SP && addr.kind != VK_ALIGNED_SP)
+			return {VK_UNKNOWN, 0};
+		auto it = stack.find({(uint8_t)addr.kind, addr.off});
+		if (it == stack.end())
+			return {VK_UNKNOWN, 0};
+		return it->second;
+	}
+
+	void store(const SymVal &addr, const SymVal &val)
+	{
+		if (addr.kind != VK_ENTRY_SP && addr.kind != VK_ALIGNED_SP)
+			return;
+		StackKey k{(uint8_t)addr.kind, addr.off};
+		if (val.kind == VK_UNKNOWN)
+			stack.erase(k);
+		else
+			stack[k] = val;
+	}
+};
+
+int mcRegToDwarf32(const llvm::MCRegisterInfo &MCRI, llvm::MCRegister Reg,
+		   llvm::Triple::ArchType Arch);
+
+SymVal addSymImm(SymVal base, int64_t delta);
+SymVal addSymVals(SymVal a, SymVal b);
+SymVal subSymVals(SymVal a, SymVal b);
+
+void clobberGenericDefs(AbsState &st, const llvm::MCInst &MI,
+			const llvm::MCInstrDesc &Desc,
+			const llvm::MCRegisterInfo &MCRI,
+			const ArchSpec &AS);
+
+bool stepInstruction(AbsState &st, const llvm::MCInst &MI,
+		     llvm::StringRef OpName, const llvm::MCInstrDesc &Desc,
+		     const llvm::MCRegisterInfo &MCRI, const ArchSpec &AS,
+		     uint64_t NextPC, const llvm::MCInstrAnalysis *MIA,
+		     uint64_t CurPC, uint64_t InsnSize);
+
+void normalizeRiscvControlFlow(const llvm::MCInst &MI, llvm::StringRef OpName,
+			       const llvm::MCRegisterInfo &MCRI,
+			       bool &is_ret_or_ind_jump, bool &is_uncond_branch,
+			       bool &is_call);
+
+#endif /* _TOOLS_UNWIND_VERIFY_INSN_H */
diff --git a/tools/unwind/verify_insn_arch.cpp b/tools/unwind/verify_insn_arch.cpp
new file mode 100644
index 000000000000..3005c8a9d9bd
--- /dev/null
+++ b/tools/unwind/verify_insn_arch.cpp
@@ -0,0 +1,757 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MIT
+/*
+ * Per-architecture Tier-2 symbolic instruction lifters (x86_64, arm64, riscv64)
+ * and Tier-1 generic MCInstrDesc register-def clobber fallback for verify_cfi.
+ */
+
+#include "verify_insn.hpp"
+
+using namespace llvm;
+
+/**
+ * mcRegToDwarf32() - Map an LLVM physical MCRegister to DWARF reg 0..31
+ * @MCRI: Target MCRegisterInfo table.
+ * @Reg: Physical register operand from an MCInst.
+ * @Arch: Target architecture type.
+ *
+ * Resolves both full-width registers and sub-registers (e.g. %eax -> %rax on
+ * x86_64, w29 -> x29 on AArch64) via super-register traversal. On AArch64,
+ * LLVM's getDwarfRegNum() maps both XZR/WZR (zero sink) and SP/WSP to DWARF
+ * number 31 because they share architectural 5-bit encoding 31 in different
+ * instruction classes; XZR and WZR are explicitly filtered out so flag-setting
+ * compares (`cmp` -> `SUBS XZR, ...`) never clobber the stack pointer.
+ *
+ * Return: DWARF register number in [0, 31], or -1 if unmapped / zero sink.
+ */
+int mcRegToDwarf32(const MCRegisterInfo &MCRI, MCRegister Reg,
+		   Triple::ArchType Arch)
+{
+	if (!Reg.isValid() || Reg.id() == 0)
+		return -1;
+	if (Arch == Triple::aarch64) {
+		StringRef N = MCRI.getName(Reg);
+		if (N == "XZR" || N == "WZR")
+			return -1;
+	}
+	int64_t d = MCRI.getDwarfRegNum(Reg, /*isEH=*/true);
+	if (d >= 0 && d < 32)
+		return (int)d;
+	for (MCPhysReg Super : MCRI.superregs(Reg)) {
+		if (Arch == Triple::aarch64) {
+			StringRef SN = MCRI.getName(Super);
+			if (SN == "XZR" || SN == "WZR")
+				continue;
+		}
+		int64_t sd = MCRI.getDwarfRegNum(Super, /*isEH=*/true);
+		if (sd >= 0 && sd < 32)
+			return (int)sd;
+	}
+	return -1;
+}
+
+SymVal addSymImm(SymVal base, int64_t delta)
+{
+	if (base.kind == VK_ENTRY_SP || base.kind == VK_ALIGNED_SP ||
+	    base.kind == VK_CONST)
+		return {base.kind, (int64_t)((uint64_t)base.off + (uint64_t)delta)};
+	return {VK_UNKNOWN, 0};
+}
+
+SymVal addSymVals(SymVal a, SymVal b)
+{
+	if (a.kind == VK_CONST && b.kind == VK_CONST)
+		return {VK_CONST, (int64_t)((uint64_t)a.off + (uint64_t)b.off)};
+	if ((a.kind == VK_ENTRY_SP || a.kind == VK_ALIGNED_SP) &&
+	    b.kind == VK_CONST)
+		return {a.kind, (int64_t)((uint64_t)a.off + (uint64_t)b.off)};
+	if (a.kind == VK_CONST &&
+	    (b.kind == VK_ENTRY_SP || b.kind == VK_ALIGNED_SP))
+		return {b.kind, (int64_t)((uint64_t)b.off + (uint64_t)a.off)};
+	return {VK_UNKNOWN, 0};
+}
+
+SymVal subSymVals(SymVal a, SymVal b)
+{
+	if (b.kind == VK_CONST)
+		return addSymVals(a, {VK_CONST, (int64_t)(-(uint64_t)b.off)});
+	return {VK_UNKNOWN, 0};
+}
+
+/**
+ * clobberGenericDefs() - Tier-1 conservative register-def clobber fallback
+ * @st: Abstract state updated in place.
+ * @MI: Decoded LLVM MCInst.
+ * @Desc: Instruction descriptor providing explicit/implicit register defs.
+ * @MCRI: Target register alias hierarchy.
+ * @AS: Target architecture specification.
+ *
+ * Marks every architectural DWARF register (0..31) modified by @MI (explicit
+ * def operands, implicit defs, and sub-/super-register aliases) as VK_UNKNOWN,
+ * and clobbers ABI caller-saved registers across call instructions.
+ */
+void clobberGenericDefs(AbsState &st, const MCInst &MI, const MCInstrDesc &Desc,
+			const MCRegisterInfo &MCRI, const ArchSpec &AS)
+{
+	auto clobberPhys = [&](MCRegister R) {
+		if (!R.isValid() || R.id() == 0)
+			return;
+		if (AS.llvm_arch == Triple::aarch64) {
+			StringRef RN = MCRI.getName(R);
+			if (RN == "XZR" || RN == "WZR")
+				return;
+		}
+		for (MCPhysReg Alias : MCRI.sub_and_superregs_inclusive(R)) {
+			if (AS.llvm_arch == Triple::aarch64) {
+				StringRef AN = MCRI.getName(Alias);
+				if (AN == "XZR" || AN == "WZR")
+					continue;
+			}
+			int64_t d = MCRI.getDwarfRegNum(Alias, /*isEH=*/true);
+			if (d >= 0 && d < 32) {
+				if (AS.llvm_arch == Triple::riscv64 && d == 0)
+					continue;
+				st.regs[d] = {VK_UNKNOWN, 0};
+			}
+		}
+	};
+
+	unsigned numDefs = Desc.getNumDefs();
+	for (unsigned i = 0; i < numDefs && i < MI.getNumOperands(); i++) {
+		if (MI.getOperand(i).isReg())
+			clobberPhys(MI.getOperand(i).getReg());
+	}
+	for (MCPhysReg Imp : Desc.implicit_defs())
+		clobberPhys(Imp);
+
+	if (Desc.isCall()) {
+		for (int d = 0; d < 32; d++) {
+			if (AS.llvm_arch == Triple::x86_64) {
+				if (d == 3 || d == 6 || d == 7 ||
+				    (d >= 12 && d <= 15))
+					continue;
+				st.regs[d] = {VK_UNKNOWN, 0};
+			} else if (AS.llvm_arch == Triple::aarch64) {
+				if ((d >= 19 && d <= 29) || d == 31)
+					continue;
+				st.regs[d] = {VK_UNKNOWN, 0};
+			} else if (AS.llvm_arch == Triple::riscv64) {
+				if (d == 0 || d == 2 || d == 3 || d == 4 ||
+				    d == 8 || d == 9 || (d >= 18 && d <= 27))
+					continue;
+				st.regs[d] = {VK_UNKNOWN, 0};
+			}
+		}
+	}
+}
+
+struct InsnStepCtx {
+	const MCInst &MI;
+	const MCRegisterInfo &MCRI;
+	const ArchSpec &AS;
+	const MCInstrAnalysis *MIA;
+	uint64_t CurPC;
+	uint64_t NextPC;
+	uint64_t InsnSize;
+
+	int regD(unsigned idx) const
+	{
+		if (idx >= MI.getNumOperands() || !MI.getOperand(idx).isReg())
+			return -1;
+		return mcRegToDwarf32(MCRI, MI.getOperand(idx).getReg(),
+				      AS.llvm_arch);
+	}
+
+	SymVal getRegVal(const AbsState &st, int d) const
+	{
+		if (d < 0 || d >= 32)
+			return {VK_UNKNOWN, 0};
+		if (AS.llvm_arch == Triple::riscv64 && d == 0)
+			return {VK_CONST, 0};
+		return st.regs[d];
+	}
+
+	void setRegVal(AbsState &st, int d, SymVal v) const
+	{
+		if (d < 0 || d >= 32)
+			return;
+		if (AS.llvm_arch == Triple::riscv64 && d == 0)
+			return;
+		st.regs[d] = v;
+	}
+};
+
+/**
+ * stepInstructionX86() - Tier-2 symbolic lifter for x86-64 frame instructions
+ * @st: Abstract register/stack state updated in place.
+ * @OpName: LLVM MC opcode name (e.g. "PUSH64r", "SUB64ri8", "LEA64r").
+ * @Desc: Instruction descriptor.
+ * @ctx: Disassembled instruction context.
+ *
+ * Models x86-64 prologue, epilogue, DRAP (`lea 8(%rsp), %r10; and $-64, %rsp;
+ * pushq -8(%r10)`), frame-pointer (`push %rbp; mov %rsp, %rbp; leave`), and
+ * PIC `call next_pc` stack effects.
+ *
+ * Return: true if @OpName was modeled; false to trigger generic clobbering.
+ */
+static bool stepInstructionX86(AbsState &st, StringRef OpName,
+			       const MCInstrDesc &Desc, const InsnStepCtx &ctx)
+{
+	const MCInst &MI = ctx.MI;
+
+	if (Desc.isCall()) {
+		uint64_t Target = 0;
+		if (ctx.MIA &&
+		    ctx.MIA->evaluateBranch(MI, ctx.CurPC, ctx.InsnSize,
+					    Target) &&
+		    Target == ctx.NextPC) {
+			st.regs[7] = addSymImm(st.regs[7], -8);
+			st.store(st.regs[7], {VK_UNKNOWN, 0});
+			return true;
+		}
+		clobberGenericDefs(st, MI, Desc, ctx.MCRI, ctx.AS);
+		return true;
+	}
+	if (OpName.starts_with("PUSH64r")) {
+		int src = ctx.regD(0);
+		st.regs[7] = addSymImm(st.regs[7], -8);
+		st.store(st.regs[7], ctx.getRegVal(st, src));
+		return true;
+	}
+	if (OpName == "PUSHF64" || OpName.starts_with("PUSH64i") ||
+	    OpName == "PUSH64rmm" || OpName == "PUSH64rmr") {
+		st.regs[7] = addSymImm(st.regs[7], -8);
+		st.store(st.regs[7], {VK_UNKNOWN, 0});
+		return true;
+	}
+	if (OpName.starts_with("POP64r")) {
+		int dst = ctx.regD(0);
+		SymVal loaded = st.load(st.regs[7]);
+		st.regs[7] = addSymImm(st.regs[7], 8);
+		if (dst != 7)
+			ctx.setRegVal(st, dst, loaded);
+		return true;
+	}
+	if (OpName == "POPF64" || OpName == "POP64rmm") {
+		st.regs[7] = addSymImm(st.regs[7], 8);
+		return true;
+	}
+	if (OpName == "LEAVE64") {
+		st.regs[7] = st.regs[6];
+		st.regs[6] = st.load(st.regs[7]);
+		st.regs[7] = addSymImm(st.regs[7], 8);
+		return true;
+	}
+	if (OpName == "MOV64rr" || OpName == "MOV64rr_REV") {
+		ctx.setRegVal(st, ctx.regD(0), ctx.getRegVal(st, ctx.regD(1)));
+		return true;
+	}
+	if (OpName == "MOV32ri" || OpName == "MOV64ri" ||
+	    OpName == "MOV64ri32") {
+		int dst = ctx.regD(0);
+		if (MI.getNumOperands() >= 2 && MI.getOperand(1).isImm()) {
+			int64_t imm = MI.getOperand(1).getImm();
+			if (OpName == "MOV32ri")
+				imm = (uint32_t)imm;
+			ctx.setRegVal(st, dst, {VK_CONST, imm});
+			return true;
+		}
+	}
+	if (OpName == "XOR32rr" || OpName == "XOR64rr") {
+		int dst = ctx.regD(0), s1 = ctx.regD(1), s2 = ctx.regD(2);
+		if (s1 >= 0 && s1 == s2) {
+			ctx.setRegVal(st, dst, {VK_CONST, 0});
+			return true;
+		}
+	}
+	if ((OpName == "ADD64ri8" || OpName == "ADD64ri32" ||
+	     OpName == "SUB64ri8" || OpName == "SUB64ri32") &&
+	    MI.getNumOperands() >= 3 && MI.getOperand(2).isImm()) {
+		int dst = ctx.regD(0), src = ctx.regD(1);
+		int64_t imm = MI.getOperand(2).getImm();
+		if (OpName.starts_with("SUB"))
+			imm = (int64_t)(-(uint64_t)imm);
+		ctx.setRegVal(st, dst, addSymImm(ctx.getRegVal(st, src), imm));
+		return true;
+	}
+	if (OpName == "ADD64rr" || OpName == "SUB64rr") {
+		int dst = ctx.regD(0), s1 = ctx.regD(1), s2 = ctx.regD(2);
+		ctx.setRegVal(st, dst,
+			      OpName == "ADD64rr"
+				  ? addSymVals(ctx.getRegVal(st, s1),
+					       ctx.getRegVal(st, s2))
+				  : subSymVals(ctx.getRegVal(st, s1),
+					       ctx.getRegVal(st, s2)));
+		return true;
+	}
+	if ((OpName == "AND64ri8" || OpName == "AND64ri32") &&
+	    MI.getNumOperands() >= 3 && MI.getOperand(2).isImm()) {
+		int dst = ctx.regD(0), src = ctx.regD(1);
+		int64_t mask = MI.getOperand(2).getImm();
+		if (dst == 7 && src == 7 && mask < 0 && (mask & 0x7) == 0) {
+			st.regs[7] = {VK_ALIGNED_SP, 0};
+			return true;
+		}
+	}
+	if (OpName == "LEA64r" && MI.getNumOperands() >= 6) {
+		int dst = ctx.regD(0), base = ctx.regD(1), idx = ctx.regD(3);
+		if (base >= 0 && MI.getOperand(2).isImm() &&
+		    MI.getOperand(2).getImm() == 1 && idx < 0 &&
+		    MI.getOperand(4).isImm()) {
+			ctx.setRegVal(st, dst,
+				      addSymImm(ctx.getRegVal(st, base),
+						MI.getOperand(4).getImm()));
+			return true;
+		}
+	}
+	if (OpName == "MOV64mr" && MI.getNumOperands() >= 6) {
+		int base = ctx.regD(0), idx = ctx.regD(2), src = ctx.regD(5);
+		if (base >= 0 && MI.getOperand(1).isImm() &&
+		    MI.getOperand(1).getImm() == 1 && idx < 0 &&
+		    MI.getOperand(3).isImm()) {
+			st.store(addSymImm(ctx.getRegVal(st, base),
+					   MI.getOperand(3).getImm()),
+				 ctx.getRegVal(st, src));
+			return true;
+		}
+	}
+	if (OpName == "MOV64rm" && MI.getNumOperands() >= 6) {
+		int dst = ctx.regD(0), base = ctx.regD(1), idx = ctx.regD(3);
+		if (base >= 0 && MI.getOperand(2).isImm() &&
+		    MI.getOperand(2).getImm() == 1 && idx < 0 &&
+		    MI.getOperand(4).isImm()) {
+			ctx.setRegVal(st, dst,
+				      st.load(addSymImm(ctx.getRegVal(st, base),
+							MI.getOperand(4).getImm())));
+			return true;
+		}
+	}
+	return false;
+}
+
+/**
+ * stepInstructionArm64() - Tier-2 symbolic lifter for AArch64 instructions
+ * @st: Abstract register/stack state updated in place.
+ * @OpName: LLVM MC opcode name (e.g. "STPXpre", "LDPXi", "PACIASP").
+ * @ctx: Disassembled instruction context.
+ *
+ * Models AAPCS64 frame setup and teardown including Pointer Authentication
+ * (`paciasp`/`autiasp`), >4KB stack-frame constant materialization, and paired
+ * or single stack spills/reloads.
+ *
+ * Return: true if @OpName was modeled; false to trigger generic clobbering.
+ */
+static bool stepInstructionArm64(AbsState &st, StringRef OpName,
+				 const InsnStepCtx &ctx)
+{
+	const MCInst &MI = ctx.MI;
+
+	if (OpName == "PACIASP" || OpName == "PACIBSP" ||
+	    OpName == "AUTIASP" || OpName == "AUTIBSP") {
+		if (st.regs[30].kind == VK_CALLER_RA)
+			st.regs[30].off ^= 1;
+		return true;
+	}
+	if (OpName == "HINT" && MI.getNumOperands() >= 1 &&
+	    MI.getOperand(0).isImm()) {
+		int64_t h = MI.getOperand(0).getImm();
+		if (h == 25 || h == 27 || h == 29 || h == 31) {
+			if (st.regs[30].kind == VK_CALLER_RA)
+				st.regs[30].off ^= 1;
+			return true;
+		}
+	}
+	if ((OpName == "ADDXri" || OpName == "SUBXri") &&
+	    MI.getNumOperands() >= 4 && MI.getOperand(2).isImm() &&
+	    MI.getOperand(3).isImm()) {
+		int dst = ctx.regD(0), src = ctx.regD(1);
+		unsigned sh = (unsigned)MI.getOperand(3).getImm() & 0x3f;
+		int64_t imm = (int64_t)((uint64_t)MI.getOperand(2).getImm() << sh);
+		if (OpName == "SUBXri")
+			imm = (int64_t)(-(uint64_t)imm);
+		ctx.setRegVal(st, dst, addSymImm(ctx.getRegVal(st, src), imm));
+		return true;
+	}
+	if (OpName == "ORRXrs" && MI.getNumOperands() >= 4 &&
+	    MI.getOperand(3).isImm() && MI.getOperand(3).getImm() == 0) {
+		if (MI.getOperand(1).isReg() &&
+		    StringRef(ctx.MCRI.getName(MI.getOperand(1).getReg())) == "XZR") {
+			ctx.setRegVal(st, ctx.regD(0),
+				      ctx.getRegVal(st, ctx.regD(2)));
+			return true;
+		}
+	}
+	if (OpName == "MOVZXi" && MI.getNumOperands() >= 3 &&
+	    MI.getOperand(1).isImm() && MI.getOperand(2).isImm()) {
+		unsigned sh = (unsigned)MI.getOperand(2).getImm() & 0x3f;
+		uint64_t v = ((uint64_t)MI.getOperand(1).getImm()) << sh;
+		ctx.setRegVal(st, ctx.regD(0), {VK_CONST, (int64_t)v});
+		return true;
+	}
+	if (OpName == "MOVNXi" && MI.getNumOperands() >= 3 &&
+	    MI.getOperand(1).isImm() && MI.getOperand(2).isImm()) {
+		unsigned sh = (unsigned)MI.getOperand(2).getImm() & 0x3f;
+		uint64_t v = ~(((uint64_t)MI.getOperand(1).getImm()) << sh);
+		ctx.setRegVal(st, ctx.regD(0), {VK_CONST, (int64_t)v});
+		return true;
+	}
+	if (OpName == "MOVKXi" && MI.getNumOperands() >= 4 &&
+	    MI.getOperand(2).isImm() && MI.getOperand(3).isImm()) {
+		SymVal cur = ctx.getRegVal(st, ctx.regD(1));
+		if (cur.kind == VK_CONST) {
+			unsigned sh = (unsigned)MI.getOperand(3).getImm() & 0x3f;
+			uint64_t u = ((uint64_t)cur.off & ~(0xffffULL << sh)) |
+				     (((uint64_t)MI.getOperand(2).getImm() &
+				       0xffffULL) << sh);
+			ctx.setRegVal(st, ctx.regD(0), {VK_CONST, (int64_t)u});
+			return true;
+		}
+	}
+	if ((OpName == "ADDXrs" || OpName == "SUBXrs" ||
+	     OpName == "ADDXrx" || OpName == "SUBXrx") &&
+	    MI.getNumOperands() >= 4 && MI.getOperand(3).isImm()) {
+		int dst = ctx.regD(0), s1 = ctx.regD(1), s2 = ctx.regD(2);
+		SymVal v2 = ctx.getRegVal(st, s2);
+		int64_t imm_arg = MI.getOperand(3).getImm();
+		bool ok_shift = false;
+		if (OpName.ends_with("rs") && (imm_arg & ~0x3f) == 0) {
+			if (v2.kind == VK_CONST)
+				v2.off = (int64_t)((uint64_t)v2.off << imm_arg);
+			ok_shift = (imm_arg == 0 || v2.kind == VK_CONST);
+		} else if (OpName.ends_with("rx") &&
+			   ((imm_arg >> 3) == 3 || (imm_arg >> 3) == 7) &&
+			   (imm_arg & 7) == 0) {
+			ok_shift = true;
+		}
+		if (ok_shift) {
+			ctx.setRegVal(st, dst,
+				      OpName.starts_with("ADD")
+					  ? addSymVals(ctx.getRegVal(st, s1), v2)
+					  : subSymVals(ctx.getRegVal(st, s1), v2));
+			return true;
+		}
+	}
+	if (OpName == "ANDXri" && ctx.regD(0) == 31) {
+		st.regs[31] = {VK_ALIGNED_SP, 0};
+		return true;
+	}
+
+	auto scaleOf = [](StringRef N) -> int64_t {
+		if (N.contains("Q"))
+			return 16;
+		if (N.contains("X") || N.contains("D"))
+			return 8;
+		if (N.contains("W") || N.contains("S"))
+			return 4;
+		if (N.contains("H"))
+			return 2;
+		return 1;
+	};
+
+	if ((OpName == "STPXpre" || OpName == "STPWpre" ||
+	     OpName == "STPDpre" || OpName == "STPQpre") &&
+	    MI.getNumOperands() >= 5 && MI.getOperand(4).isImm()) {
+		int wb = ctx.regD(0), r1 = ctx.regD(1), r2 = ctx.regD(2);
+		int base = ctx.regD(3);
+		SymVal addr = addSymImm(ctx.getRegVal(st, base),
+					MI.getOperand(4).getImm() * scaleOf(OpName));
+		ctx.setRegVal(st, wb, addr);
+		if (OpName == "STPXpre") {
+			st.store(addr, ctx.getRegVal(st, r1));
+			st.store(addSymImm(addr, 8), ctx.getRegVal(st, r2));
+		}
+		return true;
+	}
+	if ((OpName == "STPXpost" || OpName == "STPWpost" ||
+	     OpName == "STPDpost" || OpName == "STPQpost") &&
+	    MI.getNumOperands() >= 5 && MI.getOperand(4).isImm()) {
+		int wb = ctx.regD(0), r1 = ctx.regD(1), r2 = ctx.regD(2);
+		int base = ctx.regD(3);
+		SymVal addr = ctx.getRegVal(st, base);
+		if (OpName == "STPXpost") {
+			st.store(addr, ctx.getRegVal(st, r1));
+			st.store(addSymImm(addr, 8), ctx.getRegVal(st, r2));
+		}
+		ctx.setRegVal(st, wb,
+			      addSymImm(addr,
+					MI.getOperand(4).getImm() * scaleOf(OpName)));
+		return true;
+	}
+	if (OpName == "STPXi" && MI.getNumOperands() >= 4 &&
+	    MI.getOperand(3).isImm()) {
+		int r1 = ctx.regD(0), r2 = ctx.regD(1), base = ctx.regD(2);
+		SymVal addr = addSymImm(ctx.getRegVal(st, base),
+					MI.getOperand(3).getImm() * 8);
+		st.store(addr, ctx.getRegVal(st, r1));
+		st.store(addSymImm(addr, 8), ctx.getRegVal(st, r2));
+		return true;
+	}
+	if ((OpName == "LDPXpost" || OpName == "LDPWpost" ||
+	     OpName == "LDPDpost" || OpName == "LDPQpost") &&
+	    MI.getNumOperands() >= 5 && MI.getOperand(4).isImm()) {
+		int wb = ctx.regD(0), r1 = ctx.regD(1), r2 = ctx.regD(2);
+		int base = ctx.regD(3);
+		SymVal addr = ctx.getRegVal(st, base);
+		SymVal v1 = st.load(addr), v2 = st.load(addSymImm(addr, 8));
+		ctx.setRegVal(st, wb,
+			      addSymImm(addr,
+					MI.getOperand(4).getImm() * scaleOf(OpName)));
+		if (OpName == "LDPXpost") {
+			ctx.setRegVal(st, r1, v1);
+			ctx.setRegVal(st, r2, v2);
+		} else {
+			if (r1 >= 0)
+				ctx.setRegVal(st, r1, {VK_UNKNOWN, 0});
+			if (r2 >= 0)
+				ctx.setRegVal(st, r2, {VK_UNKNOWN, 0});
+		}
+		return true;
+	}
+	if ((OpName == "LDPXpre" || OpName == "LDPWpre" ||
+	     OpName == "LDPDpre" || OpName == "LDPQpre") &&
+	    MI.getNumOperands() >= 5 && MI.getOperand(4).isImm()) {
+		int wb = ctx.regD(0), r1 = ctx.regD(1), r2 = ctx.regD(2);
+		int base = ctx.regD(3);
+		SymVal addr = addSymImm(ctx.getRegVal(st, base),
+					MI.getOperand(4).getImm() * scaleOf(OpName));
+		ctx.setRegVal(st, wb, addr);
+		if (OpName == "LDPXpre") {
+			ctx.setRegVal(st, r1, st.load(addr));
+			ctx.setRegVal(st, r2, st.load(addSymImm(addr, 8)));
+		} else {
+			if (r1 >= 0)
+				ctx.setRegVal(st, r1, {VK_UNKNOWN, 0});
+			if (r2 >= 0)
+				ctx.setRegVal(st, r2, {VK_UNKNOWN, 0});
+		}
+		return true;
+	}
+	if (OpName == "LDPXi" && MI.getNumOperands() >= 4 &&
+	    MI.getOperand(3).isImm()) {
+		int r1 = ctx.regD(0), r2 = ctx.regD(1), base = ctx.regD(2);
+		SymVal addr = addSymImm(ctx.getRegVal(st, base),
+					MI.getOperand(3).getImm() * 8);
+		SymVal v1 = st.load(addr), v2 = st.load(addSymImm(addr, 8));
+		ctx.setRegVal(st, r1, v1);
+		ctx.setRegVal(st, r2, v2);
+		return true;
+	}
+	if ((OpName == "STRXpre" || OpName == "STRWpre" ||
+	     OpName == "STRQpre" || OpName == "STRDpre" ||
+	     OpName == "STRBpre" || OpName == "STRHpre") &&
+	    MI.getNumOperands() >= 4 && MI.getOperand(3).isImm()) {
+		int wb = ctx.regD(0), rt = ctx.regD(1), base = ctx.regD(2);
+		SymVal addr = addSymImm(ctx.getRegVal(st, base),
+					MI.getOperand(3).getImm());
+		ctx.setRegVal(st, wb, addr);
+		if (OpName == "STRXpre")
+			st.store(addr, ctx.getRegVal(st, rt));
+		return true;
+	}
+	if ((OpName == "STRXpost" || OpName == "STRWpost" ||
+	     OpName == "STRQpost" || OpName == "STRDpost" ||
+	     OpName == "STRBpost" || OpName == "STRHpost") &&
+	    MI.getNumOperands() >= 4 && MI.getOperand(3).isImm()) {
+		int wb = ctx.regD(0), rt = ctx.regD(1), base = ctx.regD(2);
+		SymVal addr = ctx.getRegVal(st, base);
+		if (OpName == "STRXpost")
+			st.store(addr, ctx.getRegVal(st, rt));
+		ctx.setRegVal(st, wb,
+			      addSymImm(addr, MI.getOperand(3).getImm()));
+		return true;
+	}
+	if ((OpName == "LDRXpost" || OpName == "LDRWpost" ||
+	     OpName == "LDRQpost" || OpName == "LDRDpost" ||
+	     OpName == "LDRBpost" || OpName == "LDRHpost") &&
+	    MI.getNumOperands() >= 4 && MI.getOperand(3).isImm()) {
+		int wb = ctx.regD(0), rt = ctx.regD(1), base = ctx.regD(2);
+		SymVal addr = ctx.getRegVal(st, base);
+		SymVal v = (OpName == "LDRXpost") ? st.load(addr)
+						  : SymVal{VK_UNKNOWN, 0};
+		ctx.setRegVal(st, wb,
+			      addSymImm(addr, MI.getOperand(3).getImm()));
+		if (rt >= 0)
+			ctx.setRegVal(st, rt, v);
+		return true;
+	}
+	if ((OpName == "LDRXpre" || OpName == "LDRWpre" ||
+	     OpName == "LDRQpre" || OpName == "LDRDpre") &&
+	    MI.getNumOperands() >= 4 && MI.getOperand(3).isImm()) {
+		int wb = ctx.regD(0), rt = ctx.regD(1), base = ctx.regD(2);
+		SymVal addr = addSymImm(ctx.getRegVal(st, base),
+					MI.getOperand(3).getImm());
+		ctx.setRegVal(st, wb, addr);
+		if (rt >= 0)
+			ctx.setRegVal(st, rt,
+				      OpName == "LDRXpre"
+					  ? st.load(addr)
+					  : SymVal{VK_UNKNOWN, 0});
+		return true;
+	}
+	if (OpName == "STRXui" && MI.getNumOperands() >= 3 &&
+	    MI.getOperand(2).isImm()) {
+		st.store(addSymImm(ctx.getRegVal(st, ctx.regD(1)),
+				   MI.getOperand(2).getImm() * 8),
+			 ctx.getRegVal(st, ctx.regD(0)));
+		return true;
+	}
+	if (OpName == "STURXi" && MI.getNumOperands() >= 3 &&
+	    MI.getOperand(2).isImm()) {
+		st.store(addSymImm(ctx.getRegVal(st, ctx.regD(1)),
+				   MI.getOperand(2).getImm()),
+			 ctx.getRegVal(st, ctx.regD(0)));
+		return true;
+	}
+	if (OpName == "LDRXui" && MI.getNumOperands() >= 3 &&
+	    MI.getOperand(2).isImm()) {
+		ctx.setRegVal(st, ctx.regD(0),
+			      st.load(addSymImm(ctx.getRegVal(st, ctx.regD(1)),
+						MI.getOperand(2).getImm() * 8)));
+		return true;
+	}
+	if (OpName == "LDURXi" && MI.getNumOperands() >= 3 &&
+	    MI.getOperand(2).isImm()) {
+		ctx.setRegVal(st, ctx.regD(0),
+			      st.load(addSymImm(ctx.getRegVal(st, ctx.regD(1)),
+						MI.getOperand(2).getImm())));
+		return true;
+	}
+	return false;
+}
+
+/**
+ * stepInstructionRiscv() - Tier-2 symbolic lifter for RISC-V (RV64GC)
+ * @st: Abstract register/stack state updated in place.
+ * @OpName: LLVM MC opcode name (e.g. "C_ADDI16SP", "C_SDSP", "LUI").
+ * @ctx: Disassembled instruction context.
+ *
+ * Models standard and RVC compressed RISC-V prologue/epilogue sequences.
+ *
+ * Return: true if @OpName was modeled; false to trigger generic clobbering.
+ */
+static bool stepInstructionRiscv(AbsState &st, StringRef OpName,
+				 const InsnStepCtx &ctx)
+{
+	const MCInst &MI = ctx.MI;
+
+	if ((OpName == "ADDI" || OpName == "C_ADDI" || OpName == "C_ADDI16SP" ||
+	     OpName == "C_ADDI4SPN" || OpName == "ADDIW" ||
+	     OpName == "C_ADDIW") &&
+	    MI.getNumOperands() >= 3 && MI.getOperand(2).isImm()) {
+		int dst = ctx.regD(0), src = ctx.regD(1);
+		SymVal v = addSymImm(ctx.getRegVal(st, src),
+				     MI.getOperand(2).getImm());
+		if ((OpName == "ADDIW" || OpName == "C_ADDIW") &&
+		    v.kind == VK_CONST)
+			v.off = (int32_t)v.off;
+		ctx.setRegVal(st, dst, v);
+		return true;
+	}
+	if ((OpName == "LUI" || OpName == "C_LUI") &&
+	    MI.getNumOperands() >= 2 && MI.getOperand(1).isImm()) {
+		int dst = ctx.regD(0);
+		int32_t s32 = (int32_t)((uint32_t)MI.getOperand(1).getImm() << 12);
+		ctx.setRegVal(st, dst, {VK_CONST, (int64_t)s32});
+		return true;
+	}
+	if (OpName == "C_LI" && MI.getNumOperands() >= 2 &&
+	    MI.getOperand(1).isImm()) {
+		ctx.setRegVal(st, ctx.regD(0),
+			      {VK_CONST, MI.getOperand(1).getImm()});
+		return true;
+	}
+	if (OpName == "C_MV" && MI.getNumOperands() >= 2) {
+		ctx.setRegVal(st, ctx.regD(0), ctx.getRegVal(st, ctx.regD(1)));
+		return true;
+	}
+	if ((OpName == "ADD" || OpName == "C_ADD" || OpName == "SUB" ||
+	     OpName == "C_SUB") &&
+	    MI.getNumOperands() >= 3) {
+		int dst = ctx.regD(0), s1 = ctx.regD(1), s2 = ctx.regD(2);
+		ctx.setRegVal(st, dst,
+			      OpName.contains("ADD")
+				  ? addSymVals(ctx.getRegVal(st, s1),
+					       ctx.getRegVal(st, s2))
+				  : subSymVals(ctx.getRegVal(st, s1),
+					       ctx.getRegVal(st, s2)));
+		return true;
+	}
+	if (OpName == "ANDI" && ctx.regD(0) == 2 && ctx.regD(1) == 2) {
+		st.regs[2] = {VK_ALIGNED_SP, 0};
+		return true;
+	}
+	if ((OpName == "SD" || OpName == "C_SDSP") &&
+	    MI.getNumOperands() >= 3 && MI.getOperand(2).isImm()) {
+		int src = ctx.regD(0), base = ctx.regD(1);
+		st.store(addSymImm(ctx.getRegVal(st, base),
+				   MI.getOperand(2).getImm()),
+			 ctx.getRegVal(st, src));
+		return true;
+	}
+	if ((OpName == "LD" || OpName == "C_LDSP") &&
+	    MI.getNumOperands() >= 3 && MI.getOperand(2).isImm()) {
+		int dst = ctx.regD(0), base = ctx.regD(1);
+		ctx.setRegVal(st, dst,
+			      st.load(addSymImm(ctx.getRegVal(st, base),
+						MI.getOperand(2).getImm())));
+		return true;
+	}
+	return false;
+}
+
+bool stepInstruction(AbsState &st, const MCInst &MI, StringRef OpName,
+		     const MCInstrDesc &Desc, const MCRegisterInfo &MCRI,
+		     const ArchSpec &AS, uint64_t NextPC,
+		     const MCInstrAnalysis *MIA, uint64_t CurPC,
+		     uint64_t InsnSize)
+{
+	InsnStepCtx ctx{MI, MCRI, AS, MIA, CurPC, NextPC, InsnSize};
+	bool handled = false;
+
+	if (AS.llvm_arch == Triple::x86_64)
+		handled = stepInstructionX86(st, OpName, Desc, ctx);
+	else if (AS.llvm_arch == Triple::aarch64)
+		handled = stepInstructionArm64(st, OpName, ctx);
+	else if (AS.llvm_arch == Triple::riscv64)
+		handled = stepInstructionRiscv(st, OpName, ctx);
+
+	if (!handled)
+		clobberGenericDefs(st, MI, Desc, MCRI, AS);
+	return handled;
+}
+
+/**
+ * normalizeRiscvControlFlow() - Classify RISC-V JAL/JALR control-flow roles
+ */
+void normalizeRiscvControlFlow(const MCInst &MI, StringRef OpName,
+			       const MCRegisterInfo &MCRI,
+			       bool &is_ret_or_ind_jump, bool &is_uncond_branch,
+			       bool &is_call)
+{
+	int rd = (MI.getNumOperands() >= 1 && MI.getOperand(0).isReg())
+		     ? mcRegToDwarf32(MCRI, MI.getOperand(0).getReg(),
+				      Triple::riscv64)
+		     : -1;
+	if (OpName == "JAL") {
+		if (rd == 0) {
+			is_uncond_branch = true;
+			is_call = false;
+		} else {
+			is_call = true;
+		}
+	} else if (OpName == "C_J") {
+		is_uncond_branch = true;
+		is_call = false;
+	} else if (OpName == "JALR") {
+		if (rd == 0) {
+			is_ret_or_ind_jump = true;
+			is_call = false;
+		} else {
+			is_call = true;
+		}
+	} else if (OpName == "C_JR") {
+		is_ret_or_ind_jump = true;
+		is_call = false;
+	} else if (OpName == "C_JALR") {
+		is_call = true;
+	}
+}
-- 
2.56.1.831.g720f3f5937-goog

