Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C7B420897;
	Mon, 14 Sep 2026 09:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377749; cv=none; b=r6d6UF7IYv0cvMpTdzm/PSobmPh7nKw5YIp/i9YnrniWWpdXNWUTF9zaQuwAr6N80ITUtbfwvGBR+yVY49xnICY9xHTdEHUSv2GPLUKsiBrO0ijJycQNJ2LdT+7yIgo+H4if6S2GaLGMjKQLdHUeSw1SUQ6ZRenaamsv8D7+4So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377749; c=relaxed/simple;
	bh=l1vzsOfhsFZq93BiP7aFzUsiv0IMtDncs4AVYzcTaZE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZM5kJJF5suvy0Irz7xzborz44Ng1ScpshdBn7YYhU52TdgHygigrADlGW3xuIwXaKcrDq0tiP2ouUkFIw9uT5k+WjCogD8V5+2SqipGPwfR6UXtb6ACj5Vj6RxjiUysmVRUDC/Iy2sDVcvSPKoRh/mR7VE/spRL17ppjmDYum3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/q9/7+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/q9/7+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04D81F00898;
	Mon, 14 Sep 2026 09:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789377747;
	bh=uki1B8//a8y/AGrwtR+zPRw8RRYXCi63rXRxRzPghWk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B/q9/7+gFTFhtmGHio65Z1lr1T0aniQW7+V5KkGCIpOnfYp2DDzANQ2Yr1/C/Mo8D
	 JqzDf2qIPZWxaiKcADAeKEAA8oA6EPXRge6i+lbMHWFkeqdjmIRA9tCgNpH8SIcKZf
	 XYBqgC6C4rjQ7O2mIzgrO+PBF62oQmp/fSBkbB9fEykj9vD5vXFYkLKJWtRdmoJilA
	 /RhTAnfgkcQLlMCLm9ESA6ZWpXaHsHctGl22pJ28StRSk2J5pJS/a9//dVemOHemnO
	 Cn0m+0kuToiklAGjiUr8ZmY5ML+T0/SnAi59g/EyVbtrio3di0Xp30s2h5YxwnkSzi
	 X/wdy+csDFksw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 10:22:00 +0100
Subject: [PATCH v2 01/21] kbuild: do not allocate .modinfo in vmlinux
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-build-speedup-v2-1-39817ec5db23@kernel.org>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
In-Reply-To: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
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
 linux-hardening@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4498; i=ljs@kernel.org;
 h=from:subject:message-id; bh=l1vzsOfhsFZq93BiP7aFzUsiv0IMtDncs4AVYzcTaZE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKW79lfuEmqJ1P2d9sOF0aJnatYutPNu6/s8KrbfKvqx
 tWS1xu8O0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR404Mf4Wcwmz+ntDJlS+b
 tSTiz2aOJxesX3k0h57kaX9x8/jkmycZ/hdwT4reL3PLJL3WafbuU8+mKswLdmSzW2Ce/HaiQ28
 ZGysA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Commit 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
placed MODULE_INFO() strings in the .modinfo section in vmlinux.unstripped,
however it left the section allocatable, so it gets assigned an address and
on arm64, arm and riscv, the section is tagged as PT_LOAD.

This is useless as the data is ultimately stripped anyway.

Doing this results in a lot of unnecessary work - each pass copies the
whole file, 450 MIB with relocations for an x86 allmodconfig build and 250
MiB for an arm64 allmodconfig build.

This adds ~0.7s on the serial tail of every build for arm64 and ~0.2s for
x86 (the tail is single-threaded work done after parallel work has
finished).

Nothing requires .modinfo to exist at an address, so fix this by using
--dump-section which prevents the allocation.

Image, bzImage, System.map and modules.builtin.modinfo are unchanged and
the stripped vmlinux differs only in its program headers.

The objcopy passes are on the serial tail of every build that links
vmlinux, no-op builds are unchanged.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 defconfig, touch mm/vma.c, gcc       11.2s    11.1s    -0.15s (-1%)
  x86 defconfig, touch mm/vma.c, clang     11.3s    11.1s    -0.19s (-2%)
  x86 defconfig, clean, gcc                32.5s    32.3s    -0.16s (-1%)
  x86 defconfig, clean, clang              34.5s    34.2s    -0.26s (-1%)
  x86 allmodconfig, touch mm/vma.c, gcc    40.1s    39.7s    -0.44s (-1%)

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |  2 +-
 scripts/Makefile.vmlinux          | 22 ++++------------------
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b2988aa12f66..7be9e0321867 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -855,7 +855,7 @@
 		KLP_SYMID
 
 #define MODINFO								\
-		.modinfo : { *(.modinfo) . = ALIGN(8); }
+		.modinfo (INFO) : { *(.modinfo) . = ALIGN(8); }
 
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index fcae1e432d9a..88881826335c 100644
--- a/scripts/Makefile.vmlinux
+++ b/scripts/Makefile.vmlinux
@@ -89,11 +89,8 @@ remove-section-$(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS) += '.rel.*'
 
 remove-symbols := -w --strip-unneeded-symbol='__mod_device_table__*'
 
-# To avoid warnings: "empty loadable segment detected at ..." from GNU objcopy,
-# it is necessary to remove the PT_LOAD flag from the segment.
 quiet_cmd_strip_relocs = OBJCOPY $@
-      cmd_strip_relocs = $(OBJCOPY) $(patsubst %,--set-section-flags %=noload,$(remove-section-y)) $< $@; \
-                         $(OBJCOPY) $(addprefix --remove-section=,$(remove-section-y)) $(remove-symbols) $@
+      cmd_strip_relocs = $(OBJCOPY) $(addprefix --remove-section=,$(remove-section-y)) $(remove-symbols) $< $@
 
 targets += vmlinux
 vmlinux: vmlinux.unstripped FORCE
@@ -102,21 +99,10 @@ vmlinux: vmlinux.unstripped FORCE
 # modules.builtin.modinfo
 # ---------------------------------------------------------------------------
 
-# .modinfo in vmlinux.unstripped is aligned to 8 bytes for compatibility with
-# tools that expect vmlinux to have sufficiently aligned sections but the
-# additional bytes used for padding .modinfo to satisfy this requirement break
-# certain versions of kmod with
-#
-#   depmod: ERROR: kmod_builtin_iter_next: unexpected string without modname prefix
-#
-# Strip the trailing padding bytes after extracting .modinfo to comply with
-# what kmod expects to parse.
 quiet_cmd_modules_builtin_modinfo = GEN     $@
-      cmd_modules_builtin_modinfo = $(cmd_objcopy); \
-                                    sed -i 's/\x00\+$$/\x00/g' $@; \
-                                    chmod -x $@
-
-OBJCOPYFLAGS_modules.builtin.modinfo := -j .modinfo -O binary
+      cmd_modules_builtin_modinfo = $(OBJCOPY) -O binary -j .modinfo --dump-section .modinfo=$@ $< $@.tmp; \
+                                    rm -f $@.tmp; \
+                                    sed -i 's/\x00\+$$/\x00/g' $@
 
 targets += modules.builtin.modinfo
 modules.builtin.modinfo: vmlinux.unstripped FORCE

-- 
2.55.0

