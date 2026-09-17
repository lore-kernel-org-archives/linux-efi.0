Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F8831E852;
	Thu, 17 Sep 2026 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661212; cv=none; b=dlcDNVfS9vOO/RdDH/RdBxnl7K3kvyJw8YwhDOqIKQoH30Sw32aJgr2zKDKf34Bt1FjJkivvKk2/u1b5z5fFGcLxyegxSpr2kSlepyDyFkdYDtJe3WXUeadzEnTjco06831uh5mKkQu5Oq8QxoLZHvytV8cKyrC8u4yQyTfUxDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661212; c=relaxed/simple;
	bh=l1vzsOfhsFZq93BiP7aFzUsiv0IMtDncs4AVYzcTaZE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qfZnzf+uruhNKSeYLJ7sJPXCpdPmrr6n/0ajTgR86YO5UXysib3QnvixPPsfs2HKQIZVAeU3lUrNF7yUKt/tEUn47CgxtFoLGJhpl6xp6vxXwRrLPp4KlvNU5OEGNeusy+hhN1Aq+VpN4+HcTLW99i8vZr1g+SDMnKWNezLEi+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSMYLQve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSMYLQve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696041F000FF;
	Thu, 17 Sep 2026 16:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789661211;
	bh=uki1B8//a8y/AGrwtR+zPRw8RRYXCi63rXRxRzPghWk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TSMYLQvevSmCMIQXZwH4IdgOEa03i1Y2ZGsU+7rSmg1QbUE8rcWHe/bU98D97TMD9
	 LEiz+Mi3ivMNHMslS4SK/y0WYyPspGGN/gIAGxVkgbQehhQA2x0g3Azi99T9ozy+La
	 oQ1W3hYVy7jcgnX0TezIbP+Dz/CQz4vVIK/+hHj1YLX6aIRQ5qSLbBNX4ysI4+lARw
	 ZE37de5YgvYGLz6cok+wwYv2rW0VySI+Xv7uaVXjo+LtxBAyGggDwP1R5tevt5sWtH
	 2RQSJfZxxeT3y3LKcH79e4qBYAOtrJHp15AlS1rS4hnW5UIJu8Q4L7XuXfB/ZOvrvO
	 /1HkwrElUharQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:06:11 +0100
Subject: [PATCH v3 01/20] kbuild: do not allocate .modinfo in vmlinux
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-build-speedup-v3-1-9ecf4163ff36@kernel.org>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
In-Reply-To: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
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
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLW8P9pjAkMtjVYIrIsJlycfxL3+5fz1rlv5Dx3su9H+
 qngxGNsHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIrwaG/w4MvdqCB8UOfk8/
 GhH7YdGq9RbFze3Ta45qyLv82LZn8WNGht3t3y+/z5YLvZfw+nbHrrebsp+ZM5dtnr/Y+tPxc/5
 GVWwA
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

