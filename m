Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590387;
	b=dIIgPRqJ962MxUGm4nQ7WSJ3TKu/23pdBezFUKWbCZE7S+msz8Mtkq99qCItPxeth2jV
	 2PgTkPCUZUEI+bD1h7Qz6+9wZG6Mu/g4RJdLYSdu4C3Bu1fPFqLWrxoaAZFdVprc8mudp
	 yiunXd39lDgUfhOHHVlNbH0LX+8ObukcMEbBIPyBwEldqkHzkzEzVbT+XtEVCdH72xDIC
	 GbTVo56HUaMxAlx9fsZ1CG2kCNOQztbtqwoUOeBUmjao8lcU1qRcwvS/1rQcUC94ACpQu
	 mS9+nLndEI3Z0wXz+ntmfShTfWoj/JhjGxEmtvj088fYdVrX3eJ/Y/IZov+uvGgfcDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590387;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=3zoNNk1d4+l6Vcv3rwez/mLT6TEALah7PZbGHzg8Ngk=;
	b=bzRTbtrBDkqHegMalOb0MXJZo3n39AOwII0S8LPwXBtTQ1GfVn+Iqt3kr+CP502pDkNV
	 rqjq3Cthk6ZhFzVMc+uSciGnJPCFmiLN5Ps3XOrD0P+JkIR2CSptW7TS6pZJl28gqHMsD
	 hUvfHLC0K4s2S2GgPQQ9yZsi3Ph8UPh9ZBc/1mGu3mm1nlx0m4rB/bilnkejemgHlXIJ8
	 Clcdj63nET6h8FYqMAUO28beHCX5V2dUyaXn2DiA5j2oLQ8cJdKpRaD4HgQuCgryuEAxe
	 qtJATVCvSfK+eD66vkyP66GqA9PYRfo1SaobyWaCbvTXHuFXK/FwrE1tFdAtTwKo33w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GuzWGKz/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF87606A692;
	Wed, 25 Nov 2026 07:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GuzWGKz/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7327F1F008B2;
	Wed, 25 Nov 2026 07:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590386;
	bh=3zoNNk1d4+l6Vcv3rwez/mLT6TEALah7PZbGHzg8Ngk=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=GuzWGKz/NC+MFAupsf+H2O+45+TZBrRQgmpQ3+mBE/Dm/GFpUUzwy6tG13BysFZrk
	 MKGuIJXd5MapwPcofUIZo6LtAIh3BNLrVN+dWYRDVzn9VcWwQs7IwecJhJ/jpU6zkY
	 AaUV4i4dvQpaLIS3x4l9Gu6m7byd3lZRWS9Mfk4LEbpx1myTm1rI1FpcdC9eJWsUHd
	 sFZyp6BKH4POVV9C0GdjtU/suz3xC5eYQdxsMYdRhxHFX0nETcvlO8Hu+DX4ve3NyG
	 7d+p4BAHnLjPwlhffHL72O8SuXRSzLhuxcRBSr3H7KKPfDsLSSlXiOdU2vUMNZPFJE
	 BHiqm4Ml3Ad0A==
Content-Type: multipart/mixed; boundary="===============2586286009394444528=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <4c1cf2d3c9f5248593453fd7749b58a25eb2a167caf209cd23935d59f10b2c11@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-27-irogers@google.com>
References: <20261125061523.1540234-27-irogers@google.com>
Subject: Re: [RFC PATCH v2 26/30] tools/unwind: Add standalone libLLVM Minimal DWARF CFI verifier
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:06:22 +0000 (UTC)

--===============2586286009394444528==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> tools/unwind: Add standalone libLLVM Minimal DWARF CFI verifier

TL;DR:
- Makefile: possibly unreliable LLVM detection; wrong LLVM 21 requirement
  message
- C++ objects may not rebuild after dwarf_cfi_row changes, possibly causing
  stale-layout memory errors
- Mismatch diagnostics omit differing fields; misleading comment (nit)

> diff --git a/tools/unwind/Makefile b/tools/unwind/Makefile
> new file mode 100644
> --- /dev/null
> +++ b/tools/unwind/Makefile

[ ... ]

> +FEATURE_USER := .verify_cfi
> +FEATURE_TESTS := llvm
> +FEATURE_DISPLAY := llvm

Is feature-llvm reliable here?  FEATURE_TESTS is replaced with llvm, but
nothing calls $(call feature_check,llvm) before the later
"ifeq ($(feature-llvm),1)".

In tools/build/Makefile.feature, when test-all.bin builds,
$(foreach feat,$(FEATURE_TESTS),$(call feature_set,$(feat))) sets
feature-llvm to 1 without compiling test-llvm.cpp, since test-all.c is C
and cannot include the C++ LLVM test.  On such a host the display can
print "llvm: [ on ]" whether or not LLVM is installed, and only the later
DWARFUnwindTable.h wildcard keeps the build from proceeding.

On hosts where test-all.bin fails, the slow path runs test-llvm.bin, which
links "llvm-config --libs Core BPF".  Can an LLVM built without the BPF
target, which verify_cfi does not need, make feature-llvm 0 and skip the
tool?

Would an explicit $(call feature_check,llvm), or dropping the
Makefile.feature probe in favour of the header check alone, make detection
consistent with the "when libLLVM is detected via
tools/build/Makefile.feature" wording in the commit message?

[ ... ]

> +ifeq ($(HAS_LIBLLVM),1)
> +all: $(OUTPUT)verify_cfi
> +else
> +all:
> +ifeq ($(REQUIRE_LLVM),1)
> +	$(error libLLVM 17+ development headers/libraries not found (LLVM_CONFIG=$(LLVM_CONFIG)))
> +else
> +	@echo "  SKIP    verify_cfi (libLLVM dev files not found; set LLVM_CONFIG=...)"
> +endif
> +endif

The real gate is:

    ifneq ($(wildcard $(LLVM_INCDIR)/llvm/DebugInfo/DWARF/LowLevel/DWARFUnwindTable.h),)

but that header does not exist before LLVM 21, and verify_cfi.cpp calls
llvm::dwarf::createUnwindTable().  On a host with LLVM 17-20 development
files installed, REQUIRE_LLVM=1 fails with "libLLVM 17+ development
headers/libraries not found (LLVM_CONFIG=llvm-config-18)", and the default
build prints "libLLVM dev files not found".  Both messages are wrong for
that case.

The same applies to LLVM_CONFIG_CANDIDATES, which lists llvm-config-20
through llvm-config-18 even though they can never pass the header check.
Should the message and the candidate list state LLVM 21 as the minimum?

> +$(OUTPUT)dwarf_cfi_host.o: dwarf_cfi_host.c dwarf_cfi_host.h $(KERNEL_CFI_DEPS)
> +	$(QUIET_CC)$(HOSTCC) $(SHIM_CFLAGS) -c $< -o $@
> +
> +$(OUTPUT)%.o: %.cpp $(wildcard *.hpp) dwarf_cfi_host.h
> +	$(QUIET_CXX)$(HOSTCXX) $(VERIFY_CXXFLAGS) -c $< -o $@

Is QUIET_CXX defined anywhere?  tools/scripts/Makefile.include defines
QUIET_CC, QUIET_LINK and QUIET_CLANG, but a grep for QUIET_CXX only finds
this line.  In a default build the C++ objects would echo the full
$(HOSTCXX) command line with every flag from llvm-config --cxxflags,
instead of a short "CXX" line.

Also, KERNEL_CFI_DEPS (including tools/include/linux/unwind_dwarf_cfi.h)
is only a prerequisite of dwarf_cfi_host.o.  verify_cfi.cpp allocates
struct dwarf_cfi_row and uses struct dwarf_cfi_arch and passes them to
dwarf_cfi_unwind_user_eh_frame_hdr() and dwarf_cfi_unwind_eh_frame_hdr().

If a developer changes struct dwarf_cfi_row and reruns make -C
tools/unwind, only dwarf_cfi_host.o is rebuilt, and verify_cfi.o keeps the
old layout.  Can the kernel code then write a larger dwarf_cfi_row into a
smaller C++ stack object, or read fields at different offsets?  Should
$(KERNEL_CFI_DEPS), or at least the unwind_dwarf_cfi.h copy, be a
prerequisite of the C++ rule too?

> diff --git a/tools/unwind/dwarf_cfi_host.h b/tools/unwind/dwarf_cfi_host.h
> new file mode 100644
> --- /dev/null
> +++ b/tools/unwind/dwarf_cfi_host.h

[ ... ]

> +/*
> + * Note: In C++ files using LLVM headers, include this header AFTER <llvm/...>
> + * headers (matching tools/perf/util/llvm-c-helpers.cpp) because
> + * tools/include/linux/compiler.h defines macros such as 'noinline' that
> + * conflict with LLVM attribute declarations.
> + */

This isn't a bug, but is this comment accurate?  This header never
includes compiler.h.  Its only include is:

    #include <linux/unwind_dwarf_cfi.h>

which resolves to tools/include/linux/unwind_dwarf_cfi.h, and that only
includes <linux/types.h>.  tools/include/linux/types.h includes
<stdbool.h>, <stddef.h>, <stdint.h>, <asm/types.h> and
<asm/posix_types.h>, so linux/compiler.h and its 'noinline' macro are not
reached from this header.

What this header does bring in is tools/include/linux/types.h, which
defines __must_check, __cold, __force, __user and __bitwise as macros.
Could the comment name the macros this header actually introduces, or be
dropped if there is no real ordering constraint?

> diff --git a/tools/unwind/verify_cfi.cpp b/tools/unwind/verify_cfi.cpp
> new file mode 100644
> --- /dev/null
> +++ b/tools/unwind/verify_cfi.cpp

[ ... ]

> +			if (err_u != 0 || !rowsEqual(krow_user, *exp)) {
> +				st.llvm_vs_kernel_mismatches++;
> +				char buf[200];
> +				snprintf(buf, sizeof(buf),
> +					 "PC=0x%" PRIx64 " err_u=%d kernel(cfa=%u:%d fp=%u:%d ra=%u:%d)"
> +					 " llvm(cfa=%u:%d fp=%u:%d ra=%u:%d)",
> +					 pc, err_u, krow_user.cfa_base,
> +					 krow_user.cfa_off, krow_user.fp_rule,
> +					 krow_user.fp_off, krow_user.ra_rule,
> +					 krow_user.ra_off, exp->cfa_base,
> +					 exp->cfa_off, exp->fp_rule,
> +					 exp->fp_off, exp->ra_rule,
> +					 exp->ra_off);
> +				recordIssue(st, opts, "llvm_vs_kernel_dwarf",
> +					    buf);
> +			}

[ ... ]

> +				if (err_k != err_u ||
> +				    (err_u == 0 &&
> +				     !rowsEqual(krow_kmem, krow_user)))
> +					st.kmem_vs_user_mismatches++;

Does this sample omit fields that rowsEqual() compares?  rowsEqual()
returns false when sp_rule, signal or ra_signed differ, when cfa_reg
differs under DWARF_CFI_BASE_REG, or when sp_off differs under
DWARF_CFI_RULE_OFFSET, but the sample only prints cfa_base:cfa_off,
fp_rule:fp_off and ra_rule:ra_off.

For example, if the kernel and LLVM disagree about ra_signed after
DW_CFA_AARCH64_negate_ra_state, the mismatch is counted and the tool
exits 1, but the sample reads:

    kernel(cfa=1:16 fp=1:-16 ra=1:-8) llvm(cfa=1:16 fp=1:-16 ra=1:-8)

which hides the field that actually differs.  The same holds for the
signal flag, sp_rule and the CFA register.

Similarly, a kmem-vs-user disagreement only increments
st.kmem_vs_user_mismatches and never calls recordIssue().  verifyFile()
then fails the file and prints only the count, with no PC, error codes or
rows.  Could the sample include sp_rule:sp_off, cfa_reg, signal and
ra_signed, and could the kmem path call recordIssue() with the PC,
err_k/err_u and both rows?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============2586286009394444528==--
