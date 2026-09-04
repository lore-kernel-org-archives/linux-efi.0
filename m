Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A0A369D45
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 01:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788484807; cv=none; b=b9yFhoV+jndMab1HS88IAp4XSMccglO+dDnhgQpzWEtjg0uwsJVFuK+kHAXvH0+FPqzNxYiyqJiEO3+CxqPtuv5dl/8ssVvLUpwasA4gimIthos31wOnMGSCp6zIhJro+8VEkx+yE/EBMSCDGInI2z3OjlIt8mVtpBDhGifMqVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788484807; c=relaxed/simple;
	bh=oXghULZQP5z/j8O8DwSIl930v8B9ioftFHOPhE8OqdI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R0oSQj7Y5T5bIN28KNK9fHHC0UFtT/gapqIvbMYrUr7va/oCSoiOG6oJyHiXZeV+impi22eSqjVfAhhSeYd8Gne3mMLMJUtW/5zjxVziQ8zZj3he+vldhY6ZXUF7X4IYqo9U6Ky5V7EuksPEKvKHogDZMFEZCf8ff4dBeTD98Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BslwH27b; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BslwH27b"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oXghULZQP5z/j8O8DwSIl930v8B9ioftFHOPhE8OqdI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788484801; v=1; x=1789089601;
 b=BslwH27bA5fLwi9nsQVPxwSHOsXUmmf92PCRHVpYoWFZF6hE80AU2ozPwSiYsJCqRWRBkKqn
 BQ+DWAtxoUrYhIWD9BNnnBTHitU8o2c3ADTZrfXAHRMbFwPuWplLxCbxYBltIWJGi2Kfdw/MPyI
 KUp/NwkyLa1rANJ6cLkfqZY4=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9c8df039287fc77a;
	Fri, 04 Sep 2026 01:20:01 +0000
X-Mizu-Trace-ID: 9c8df039287fc77a
X-Migadu-Flow: FLOW_OUT
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Date: Fri, 04 Sep 2026 01:18:38 +0000
Subject: [PATCH RFC 6/8] arm64: ftrace: Support CALL_OPS on kernels built
 with kCFI
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-b4-arm64-callops-kcfi-v1-6-ce6687739b0c@linux.dev>
References: <20260904-b4-arm64-callops-kcfi-v1-0-ce6687739b0c@linux.dev>
In-Reply-To: <20260904-b4-arm64-callops-kcfi-v1-0-ce6687739b0c@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 Puranjay Mohan <puranjay@kernel.org>, Xu Kuohai <xukuohai@huaweicloud.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Sami Tolvanen <samitolvanen@google.com>, Kees Cook <kees@kernel.org>
Cc: Leon Hwang <leon.hwang@linux.dev>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org, 
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 Ben Cressey <ben@cressey.dev>, 
 "Florent Revest (Anthropic)" <florent.revest@linux.dev>, 
 "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
X-Mailer: b4 0.15.2

CALL_OPS and kCFI have been mutually exclusive on arm64 since commit
baaf553d3bc3 ("arm64: Implement HAVE_DYNAMIC_FTRACE_WITH_CALL_OPS").
kCFI checks the type hash at a fixed offset before the entry point, so
every function needs the same number of prefix NOPs. Before clang 21,
prefix NOPs came only with an entry in ftrace's table, and untraced
functions had none. Since commit 9315e22b0c0a ("arm64: ftrace: allow
DIRECT_CALLS without CALL_OPS") a kCFI kernel can attach BPF
trampolines. But without CALL_OPS, a trampoline out of BL range is
reached through ftrace_caller, ~10 ns more per call than on a CALL_OPS
kernel, plus ~4 ns for every extra ftrace_ops registered.

Clang 21 added a third argument to -fpatchable-function-entry that names
the section the entries go to [1]. Point it at a section the linker
scripts already drop and a function gets prefix NOPs with no entry in
ftrace's table. When CFI and CALL_OPS are both enabled, compile every
object with
-fpatchable-function-entry=M,M,.discard.patchable_function_entries,
where M is CONFIG_ARM64_FUNCTION_PREFIX_NOPS.

Gate CALL_OPS under CFI on ARM64_CFI_PERMITS_CALL_OPS, which needs
clang 21 or newer and RUST off. rustc has its own flag for the prefix
NOPs and this patch does not pass it, so Rust functions would have no
prefix and a different hash offset.

M is 3 because the ops pointer needs an aligned 8-byte slot inside the
prefix NOPs, and the 4-byte hash puts the NOPs at offset 4. A traced
function, with the two entry NOPs from CC_FLAGS_FTRACE, then looks
like this:

  func-16:            .word <hash>    // kCFI type hash
  func-12:            NOP
  func-08:            NOP             // ops pointer, 8 bytes
  func-04:            NOP             //
  func+00:    func:   NOP             // To be patched to MOV X9, LR
  func+04:            NOP             // To be patched to BL <caller>

Size of .text in vmlinux on a defconfig-based config with clang 21.1.4:

  Kernel                 || .text bytes | Delta       | Delta
  =======================++=============+=============+=======
  kCFI, base             ||  21,023,888 |             |
  kCFI, M = 3            ||  22,031,504 |  +1,007,616 | +4.8%
  -----------------------++-------------+-------------+-------

Numbers below are from a KVM guest on a Graviton4 host, v7.3-rc1 with
and without this series. The workload is a fentry program on
__arm64_sys_getpid, 20M calls per pass, six passes per boot, six
boots, each cell the call with the program attached minus the call
without it. The in-range rows are the same kernels booted with nokaslr.

  Kernel            | Trampoline   | Extra      || Per-call cost (ns)
                    | vs. BL range | ftrace_ops || Median | Min  | Max
  ==================+==============+============++========+======+======
  kCFI, base        | out of range |          0 ||   32.9 | 32.6 | 33.4
  kCFI, base        | out of range |         16 ||   92.6 | 92.4 | 96.3
  kCFI, base        | in range     |          0 ||   21.3 | 21.0 | 21.8
  ------------------+--------------+------------++--------+------+------
  kCFI, this series | out of range |          0 ||   22.7 | 22.0 | 22.9
  kCFI, this series | out of range |         16 ||   22.1 | 21.9 | 22.4
  kCFI, this series | in range     |          0 ||   22.4 | 22.1 | 22.6
  ------------------+--------------+------------++--------+------+------

Out of range this saves ~10 ns per call and the cost stops growing
with extra ftrace_ops. In range both kernels branch straight to
the trampoline and the numbers roughly match.

ftracetest and the BPF trampoline, struct_ops and kprobe_multi
selftests pass with CFI enforcing.

[1] https://github.com/llvm/llvm-project/pull/131230

Reviewed-by: Ben Cressey <ben@cressey.dev>
Reviewed-by: Florent Revest (Anthropic) <florent.revest@linux.dev>
Assisted-by: LLM
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
---
 arch/arm64/Kconfig                    | 15 ++++++++++++++-
 arch/arm64/Makefile                   | 12 +++++++++++-
 arch/arm64/kernel/pi/Makefile         |  2 ++
 arch/arm64/kernel/vdso/Makefile       |  2 +-
 drivers/firmware/efi/libstub/Makefile |  2 +-
 5 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9fbcf12a3808b..6e5fa009c11af 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -190,7 +190,8 @@ config ARM64
 	select HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS \
 		if DYNAMIC_FTRACE_WITH_ARGS
 	select HAVE_DYNAMIC_FTRACE_WITH_CALL_OPS \
-		if (DYNAMIC_FTRACE_WITH_ARGS && !CFI && \
+		if (DYNAMIC_FTRACE_WITH_ARGS && \
+		    (!CFI || ARM64_CFI_PERMITS_CALL_OPS) && \
 		    (CC_IS_CLANG || !CC_OPTIMIZE_FOR_SIZE))
 	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY \
 		if DYNAMIC_FTRACE_WITH_ARGS
@@ -276,8 +277,20 @@ config GCC_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS
 	def_bool CC_IS_GCC
 	depends on $(cc-option,-fpatchable-function-entry=2)
 
+config CC_HAS_PATCHABLE_FUNCTION_ENTRY_SECTION
+	# The section argument needs clang 21 or later:
+	# https://github.com/llvm/llvm-project/pull/131230
+	def_bool $(cc-option,-fpatchable-function-entry=1$(comma)1$(comma).discard.patchable_function_entries)
+
+config ARM64_CFI_PERMITS_CALL_OPS
+	def_bool y
+	depends on CFI
+	depends on CC_HAS_PATCHABLE_FUNCTION_ENTRY_SECTION
+	depends on !RUST
+
 config ARM64_FUNCTION_PREFIX_NOPS
 	int
+	default 3 if DYNAMIC_FTRACE_WITH_CALL_OPS && CFI
 	default 2 if DYNAMIC_FTRACE_WITH_CALL_OPS
 	default 0
 
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 6b005c8fef706..653c1ed6ef38f 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -142,7 +142,17 @@ CHECKFLAGS	+= -D__aarch64__
 
 ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_CALL_OPS),y)
   KBUILD_CPPFLAGS += -DCC_USING_PATCHABLE_FUNCTION_ENTRY
-  CC_FLAGS_FTRACE := -fpatchable-function-entry=4,2
+  prefix_nops := $(CONFIG_ARM64_FUNCTION_PREFIX_NOPS)
+  CC_FLAGS_FTRACE := -fpatchable-function-entry=$(shell expr $(prefix_nops) + 2),$(prefix_nops)
+  ifeq ($(CONFIG_CFI),y)
+    # Every object gets the prefix NOPs and no ftrace entry by default.
+    # CC_FLAGS_FTRACE comes later for traced objects and overrides the
+    # -fpatchable-function-entry.
+    CFI_PREFIX_CFLAGS := -fpatchable-function-entry=$(prefix_nops),$(prefix_nops),.discard.patchable_function_entries \
+			 -DCC_USING_PATCHABLE_FUNCTION_PREFIX=$(prefix_nops)
+    KBUILD_CFLAGS += $(CFI_PREFIX_CFLAGS)
+    export CFI_PREFIX_CFLAGS
+  endif
 else ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_ARGS),y)
   KBUILD_CPPFLAGS += -DCC_USING_PATCHABLE_FUNCTION_ENTRY
   CC_FLAGS_FTRACE := -fpatchable-function-entry=2
diff --git a/arch/arm64/kernel/pi/Makefile b/arch/arm64/kernel/pi/Makefile
index be92d73c25b21..df9f78dd9daec 100644
--- a/arch/arm64/kernel/pi/Makefile
+++ b/arch/arm64/kernel/pi/Makefile
@@ -18,6 +18,8 @@ CFLAGS_map_range.o += -mstrict-align
 KBUILD_CFLAGS	:= $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
 # disable LTO
 KBUILD_CFLAGS	:= $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
+# the discard section holds absolute relocations, which relacheck rejects
+KBUILD_CFLAGS	:= $(filter-out $(CFI_PREFIX_CFLAGS), $(KBUILD_CFLAGS))
 
 hostprogs	:= relacheck
 
diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 7dec05dd33b70..44f4a6622ccd2 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -38,7 +38,7 @@ ccflags-y += -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO
 CC_FLAGS_REMOVE_VDSO := $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) \
 			$(RANDSTRUCT_CFLAGS) $(KSTACK_ERASE_CFLAGS) \
 			$(GCC_PLUGINS_CFLAGS) \
-			$(CC_FLAGS_LTO) $(CC_FLAGS_CFI) \
+			$(CC_FLAGS_LTO) $(CC_FLAGS_CFI) $(CFI_PREFIX_CFLAGS) \
 			-Wmissing-prototypes -Wmissing-declarations
 
 CC_FLAGS_ADD_VDSO := -O2 -mcmodel=tiny -fasynchronous-unwind-tables
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 77a2b2d74f3f6..9fb4e23da4535 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -53,7 +53,7 @@ KBUILD_CFLAGS := $(filter-out $(RANDSTRUCT_CFLAGS), $(KBUILD_CFLAGS))
 # remove SCS flags from all objects in this directory
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
 # disable CFI
-KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_CFI) $(CFI_PREFIX_CFLAGS), $(KBUILD_CFLAGS))
 # disable LTO
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
 

-- 
2.52.0

