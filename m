Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748CC3E1738;
	Wed, 23 Sep 2026 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183970; cv=none; b=mlRfrvFZhmPFDSM9x5GQbSR8R+YCg28JXNRkrUGcCeAgQeT+hLlszmtRWHlPfZpRwXb+nTnmUoTq7azgW9Fl+BkWALTHnUcYMFdn7jspUAqE9EQDnKpmTQGfcYSKz40YtyR0n5e18cnTaoSROVPwaLiatm5OvSrNbcntVzvb+NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183970; c=relaxed/simple;
	bh=MLUfGBmyVIicidewYxyd0wSyemJP9IVOSHNNzSMSLro=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g4RbC0TOOr/iCGzM5JOHEe56oP9g/y6p1mS91SkRgBLTuT0fymEHp0++SE01Lmhjji/j1U1F/+3WkgFQ3Tj6MDhh97rrmz69BYq5UIxSW8yoGGI2S2rEaSKNl+Ktcqg0Vd//Htc6Emh4w/HlsLu1LIaAGHqqHgTu4LxbkJqfEBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IdX2Jlv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IdX2Jlv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6B51F00893;
	Wed, 23 Sep 2026 17:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790183968;
	bh=Rr99y5k7+go2x3zYNVayaOE+WWHPPjrM2nwS9MChYr0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IdX2Jlv2q9z4c18/1je4x2BTqsOkbTh+Qltdmxsno7HZAIpDyNFFU0CFcnlFf95va
	 0k3k35Ze7aMEr7uQIIbNrS9W2tPkFiBb3GohT9Z7bTZs9YMoQFGnjbTjAuQABHMAPN
	 nVq9sTjBGCox1kmTyBgfpNUHD0IjWyHKy8js1n08rN/dWVKvCdTNUnsPzmT63Ry1Pa
	 uYM00Op9MLN/4mWp8vDLNJALjCIq3bmDEA29TE2UOTjd3Gbd5UVMATWLZMRlfmA5YX
	 eDT12AYno1FVKahrIU3ZPiWwvb1wyXilIbovcfnNBbMXd0C4Wpa/X9ocugwn7VY7BF
	 2bSTibPzT/ALw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 23 Sep 2026 18:17:54 +0100
Subject: [PATCH v4 05/22] kbuild: do not sort nm output where the order is
 irrelevant
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-build-speedup-v4-5-73128809a4a4@kernel.org>
References: <20260923-build-speedup-v4-0-73128809a4a4@kernel.org>
In-Reply-To: <20260923-build-speedup-v4-0-73128809a4a4@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, 
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
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
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 linux-hardening@vger.kernel.org, Petr Pavlu <petr.pavlu@suse.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Nicolas Schier <n.schier@fritz.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5086; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MLUfGBmyVIicidewYxyd0wSyemJP9IVOSHNNzSMSLro=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2cF5ac2pzhUtH/aYM2S3FiwqvzVXaJ/2sVGr9XqPy4
 qR/Nxb86ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE4lcx/NPbOHNVy0KPdcrM
 FhdEbFuTnSYx2lwPe/burntDcOmqr7IMf3j8l79wD1qtMuF//kzbBdqmV7+1ladn8B5m2f+lYCL
 /XAYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Unless instructed otherwise, nm sorts by name.

There are places where this is unnecessary - an invocation from
scripts/sorttable every vmlinux link, scripts/check-function-names.sh run
after every vmlinux.o link, and the x86 VOFFSET and ZOFFSET listings
between vmlinux and bzImage.

Both GNU nm and llvm-nm accept the same '-p' parameter to disable sorting
in these instances, so use that to prevent this unnecessary work.

Each nm run on its own, x86-64, median of 5:

                             GNU nm 2.47              llvm-nm 22
                          before  after   delta    before  after   delta
  defconfig
  sorttable, nm -S vmlinux 0.080s 0.039s -0.041s   0.265s 0.113s -0.152s
  check-function-names.sh  0.072s 0.033s -0.039s   0.244s 0.102s -0.142s
  VOFFSET                  0.077s 0.034s -0.043s   0.261s 0.113s -0.148s
  ZOFFSET                  0.007s 0.005s -0.002s   0.005s 0.005s  0.000s
  TOTAL                                  -0.125s                 -0.442s

  allmodconfig
  sorttable, nm -S vmlinux 0.156s 0.063s -0.093s   0.539s 0.223s -0.316s
  check-function-names.sh  0.149s 0.054s -0.095s   0.537s 0.217s -0.320s
  VOFFSET                  0.146s 0.052s -0.094s   0.524s 0.221s -0.303s
  ZOFFSET                  0.007s 0.005s -0.002s   0.006s 0.004s -0.002s
  TOTAL                                  -0.284s                 -0.941s

llvm-nm appears to be a lot slower than GNU nm, so these builds naturally
improve the most.

The four run one after another in the serial tail of every build that links
vmlinux so impact kernel builds directly.

In an allmodconfig the decompressor is built in parallel while the modules,
so only the two before the vmlinux link contribute to build time.

The build outputs remain unchanged.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                          before    after     delta
                                        ---------------------------------
  x86 defconfig, touch mm/vma.c, gcc        9.7s     9.5s    -0.18s (-2%)
  x86 defconfig, touch mm/vma.c, clang      9.3s     9.0s    -0.27s (-3%)
  x86 defconfig, clean, gcc                30.3s    30.1s    -0.16s (-1%)
  x86 defconfig, clean, clang              31.7s    31.2s    -0.55s (-2%)
  x86 allmodconfig, touch mm/vma.c, clang  36.4s    35.8s    -0.67s (-2%)

Assisted-by: LLM
Reviewed-by: Nicolas Schier <n.schier@fritz.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/boot/Makefile            | 2 +-
 arch/x86/boot/compressed/Makefile | 2 +-
 scripts/check-function-names.sh   | 3 ++-
 scripts/link-vmlinux.sh           | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 3f9fb3698d66..4a9bce32586d 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -74,7 +74,7 @@ SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [a-zA-Z] \(startup_32\|efi.._stub_entry\|efi\(32\)\?_pe_entry\|input_data\|kernel_info\|_end\|_ehead\|_text\|_e\?data\|_e\?sbat\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
-      cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
+      cmd_zoffset = $(NM) -p $< | sed -n $(sed-zoffset) > $@
 
 targets += zoffset.h
 $(obj)/zoffset.h: $(obj)/compressed/vmlinux FORCE
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 06934f9691d6..6ec5e031db1d 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -76,7 +76,7 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABbCDGRSTtVW] \(_text\|__start_rodata\|_sinittext\|__inittext_end\|__bss_start\|_end\)$$/\#define VO_\2 _AC(0x\1,UL)/p'
 
 quiet_cmd_voffset = VOFFSET $@
-      cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
+      cmd_voffset = $(NM) -p $< | sed -n $(sed-voffset) > $@
 
 targets += ../voffset.h
 
diff --git a/scripts/check-function-names.sh b/scripts/check-function-names.sh
index 08071133e5a5..94883e690627 100755
--- a/scripts/check-function-names.sh
+++ b/scripts/check-function-names.sh
@@ -13,7 +13,8 @@ if [ ! -f "$objfile" ]; then
 	exit 1
 fi
 
-bad_symbols=$(${NM:-nm} "$objfile" | awk '$2 ~ /^[TtWw]$/ {print $3}' | grep -E '^(startup|exit|split|unlikely|hot|unknown)(\.|$)')
+bad_symbols=$(${NM:-nm} -p "$objfile" | awk '$2 ~ /^[TtWw]$/ {print $3}' |
+	      grep -E '^(startup|exit|split|unlikely|hot|unknown)(\.|$)')
 
 if [ -n "$bad_symbols" ]; then
 	echo "$bad_symbols" | while read -r sym; do
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index e88604150d2c..970ca10f8fa9 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -161,7 +161,7 @@ mksysmap()
 
 sorttable()
 {
-	${NM} -S ${1} > .tmp_vmlinux.nm-sort
+	${NM} -p -S ${1} > .tmp_vmlinux.nm-sort
 	${objtree}/scripts/sorttable -s .tmp_vmlinux.nm-sort ${1}
 }
 

-- 
2.55.0

