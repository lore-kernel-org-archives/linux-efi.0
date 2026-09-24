Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4CF43F8DE
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289372; cv=none; b=ekIB5SF8DKFj2mpMTdS+vXuB/Ek2uqNY2gPEEMoPpDbivLU+EP1nC5ArvqUoEd3z0mPh/7hWd8dktQUKWnRAtN9gAY+DEqulWg+0czWxJtya5+EiNbhVFf8S4vjd0jd13sVsqO+7xPlT7dX2KA1mdZgoNwFK3NYWYgW2JRY7FrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289372; c=relaxed/simple;
	bh=KWzjCrXxXC1mrZWmAQxMmdx2xq0eTkpdm5eISaRI2fA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Z9ennbZgPi7DT8tUVV643gPMMh1zDn3941RRxqEOfcm6XDVViDP2ZY3peS/mvOw27B6W3FqNBrKxyWs8G3YFbpezt60yGCgmbRYjwL2832EOKrqb+c1VTnJrK4mwFKnvaI0aReOzyHcG/J5P3NokXZ1BHcG0v7UBbzFSgMkuYnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FQWqfe51; arc=none smtp.client-ip=91.218.175.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FQWqfe51"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KWzjCrXxXC1mrZWmAQxMmdx2xq0eTkpdm5eISaRI2fA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790289366; v=1; x=1790894166;
 b=FQWqfe51OuCdj2jOK83/kNYU/GYGxLUswbe4XuTISNExIQy845eK0R2jB97HfS0WgHYwUvP2
 5hoYb+30hLh21OWnLddBaONXGVrsUqjyMAeyzttSboDR6bEnU8IX5k1Er3QbX8OsKUAmXZdyK3X
 YHfpZKaGEGVM9i6cIIcsZ2HQ=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8b83c7835642c7f3;
	Thu, 24 Sep 2026 22:36:05 +0000
X-Mizu-Trace-ID: 8b83c7835642c7f3
X-Migadu-Flow: FLOW_OUT
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Subject: [PATCH v2 0/9] arm64: ftrace: support CALL_OPS on kernels built
 with kCFI
Date: Thu, 24 Sep 2026 22:35:44 +0000
Message-Id: <20260924-b4-arm64-callops-kcfi-v2-0-587865b6d991@linux.dev>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMCltWoC/4WOQQ6CMBREr0K69ssHmyKuvIdh0ZaPVLGQFhoM4
 e5SXLpw+SYzL7MwT86QZ5dkYY6C8aa3G+SHhOlW2juBqTdmOeYCS+SgOEj3Ehy07Lp+8PDUjQG
 OmAmimjcK2bYdHDVm3r236st+Ug/SY5TFhpKeQDlpdRujbkgVT/fwVx/7rfFj79770ZBF779PI
 QMETUKci+JUKtTXzthpPtYUWLWu6wdgFOE//AAAAA==
X-Change-ID: 20260904-b4-arm64-callops-kcfi-40016eed4fb0
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
 sashiko-bot@kernel.org, 
 "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>, 
 Ben Cressey <ben@cressey.dev>, 
 "Florent Revest (Anthropic)" <florent.revest@linux.dev>
X-Mailer: b4 0.15.2

CALL_OPS and kCFI have been mutually exclusive on arm64 since commit
baaf553d3bc3 ("arm64: Implement HAVE_DYNAMIC_FTRACE_WITH_CALL_OPS").
kCFI checks the type hash at a fixed offset before the entry point, so
every function needs the same number of prefix NOPs. Before clang 21 the
compiler could not emit prefix NOPs without also adding the function to
ftrace's table. Since commit 9315e22b0c0a ("arm64: ftrace: allow
DIRECT_CALLS without CALL_OPS") a kCFI kernel can attach BPF
trampolines. A trampoline out of BL range is reached through
ftrace_caller. That path costs ~10 ns more per call than on a CALL_OPS
kernel, plus ~4 ns for every extra ftrace_ops registered. Clang 21 takes
a section name as a third argument of -fpatchable-function-entry [1].
This series uses it to give every function three prefix NOPs while
keeping untraced functions out of ftrace's table, and enables CALL_OPS
under kCFI. The per-call cost drops by ~10 ns and stops growing with the
number of ftrace_ops registered.

Patch 1 frees the page group of a module whose patch sites are all
skipped, which patch 2 can cause. Patch 2 lets core ftrace skip a
patch site the architecture rejects, which patch 5 relies on. Patch 3
takes the sorttable entry offset from Kconfig. Patch 4 lets notrace
keep the prefix NOPs. Patch 5 makes the arm64 prefix layout
configurable and refuses patch sites that do not fit. Patch 6 applies
the prefix count where the type hash is emitted or read by hand.
Patch 7 adds the compiler probe and enables CALL_OPS under CFI. Patch 8
uses five NOPs on ThinLTO kernels with BTI. Patch 9 gives Rust
functions the same prefix NOPs.

The cost is text size, 4.8% of .text on a defconfig-based build with
CFI and 7.4% with ThinLTO and BTI. CALL_OPS under CFI needs clang 21 or
later, and Rust 1.98 or later with RUST=y. Commit d3359af21fc9e ("arm64:
bti: Disable in-kernel BTI with recent versions of Clang") turns BTI
off on clang 21 or later, so a mainline build has one or the other
today. A module must be built with the same prefix count as its kernel,
since vermagic does not carry the count.

Numbers below are from a KVM guest on a Graviton4 host, v7.3-rc1 with
and without this series, clang 21.1.4. Cost of a fentry program on a
syscall, per call, the call with the program attached minus the call
without it:

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

Mark Rutland discussed the uniform prefix with a section for untraced
entries in 2022 [2]. His review of the DIRECT_CALLS series raised the
cost of the ftrace_caller path [3]. Josh Poimboeuf's objtool support
for arm64 livepatch [4] detects the prefix by the CALL_OPS layout and
treats kCFI and CALL_OPS as never meeting, which this series changes.

[1] https://github.com/llvm/llvm-project/pull/131230
[2] https://lore.kernel.org/all/Y1LBGZPMfCZ8A1bl@FVFF77S0Q05N/
[3] https://lore.kernel.org/all/amjnf5gz0xP5PTSB@J2N7QTR9R3/
[4] https://lore.kernel.org/all/cover.1786230311.git.jpoimboe@kernel.org/

---
Changes in v2:
- Drop the RFC tag.
- New patch 1: free the page group of a module whose patch sites are
  all skipped (sashiko on v1 patch 1). Tested on arm64 under KVM with
  KASAN: a module built without the prefix NOPs, loaded 20 times,
  leaks one page group per load without it and none with it.
- Patch 2: comment the new check in ftrace_process_locs() (Steven
  Rostedt).
- Patch 3: comment the 0 case of the sorttable Makefile guard (bpf-ci).
- Patches 4 and 9: reword the bindgen comments, the flag can go because
  removing it does not change the ABI (Miguel Ojeda).
- Patch 9: filter -fpatchable-function-entry out of bindgen's flags on
  the bindgen_c_flags_final line, so GCC builds are covered too
  (Miguel Ojeda).
- Link to v1: https://patch.msgid.link/20260904-b4-arm64-callops-kcfi-v1-0-ce6687739b0c@linux.dev

---
Jose Fernandez (Anthropic) (9):
      ftrace: Do not leak a module's empty page group
      ftrace: Let ftrace_call_adjust() reject a patch site
      scripts/sorttable: Make the arm64 before_func offset configurable
      compiler_types: Let notrace keep the function prefix NOPs
      arm64: ftrace: Make the CALL_OPS prefix layout configurable
      arm64: cfi: Use CONFIG_ARM64_FUNCTION_PREFIX_NOPS for the type hash offset
      arm64: ftrace: Support CALL_OPS on kernels built with kCFI
      arm64: ftrace: Use five prefix NOPs on ThinLTO kernels with BTI
      arm64: ftrace: Allow CALL_OPS on kCFI kernels built with Rust

 arch/arm64/Kconfig                    |  27 +++++++-
 arch/arm64/Makefile                   |  15 ++++-
 arch/arm64/include/asm/cfi.h          |   8 +++
 arch/arm64/include/asm/ftrace.h       |  16 +++++
 arch/arm64/include/asm/linkage.h      |  11 ++++
 arch/arm64/kernel/entry-ftrace.S      |  16 ++---
 arch/arm64/kernel/ftrace.c            | 120 +++++++++++++++++++---------------
 arch/arm64/kernel/pi/Makefile         |   2 +
 arch/arm64/kernel/vdso/Makefile       |   2 +-
 arch/arm64/net/bpf_jit_comp.c         |   8 ++-
 drivers/firmware/efi/libstub/Makefile |   2 +-
 include/linux/compiler_types.h        |   9 +++
 kernel/trace/ftrace.c                 |  19 ++++++
 rust/Makefile                         |   7 +-
 scripts/Makefile                      |   4 ++
 scripts/sorttable.c                   |   7 +-
 16 files changed, 206 insertions(+), 67 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260904-b4-arm64-callops-kcfi-40016eed4fb0

Best regards,
--  
Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>

