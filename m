Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B90A3D79E2;
	Tue,  8 Sep 2026 20:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901001; cv=none; b=urih2cfanEXBMZICvs2QVdTMAT7GF952BMV38WIpG/BbTy0ja1k3IA3TUxggZqbcfW7Ztel36K0GNFJXh9GOaLCCbKIzs+PBrXj6ES58QIHhE+H3uK50BvhM4vRPwfQHAUgzucWV2h2GUid0C58cjxo8ZE984YwjkKuJ89bVPoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901001; c=relaxed/simple;
	bh=N13ZqN50eOU7uY3QR0adbXAgcslOg42oxhOb+TbiiNY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rDMcDVwPC1AIpulPML4oNvR8Qp+gLWUFgYP8zU2MlExix51BOUummMDKr83W/nT4Iho9I+PehXvOZeqQIzzG9Q0kJs+eMfkkz7GHMY5eCFWvEhrqUYYCqky804haGXLfGvp209SamAah+dVEbk29V4+OWompa4HsXfkdqYx2BpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ia7otobC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ia7otobC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D80F1F00A3A;
	Tue,  8 Sep 2026 20:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901000;
	bh=i4mmShyVZGlgCcDLfFsSbEgGMvI3VWrUjGiN2LoMKxY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ia7otobCwNkhAtHa/irExbcNB39utNz/W3ids/Ovxn6+xF9yjVuSRttrN3bvH3Q88
	 eEUZ47xB5oUWgq73QBzX+L5v4SNhDmB8A/tobfOM2Lr2Ctw13MxEcooPf/B9vpxj8S
	 Co85Z+fqnbnrJIWyihZVcv2KJwi5weDsPwwhfZaANjyYd7nkLmO98km3QVVAIBkz2K
	 bunSAccE/1l/tzbk6UQMnLrwAFgBjckXWiBugdVPaiP19tJHqEDaYifEUYetj4UK6q
	 sy0IFHIS+L1yHhDjd62WWvz0/Y0QNHUXwZqBsJJXLEpJ+2RnYopzAk7D70CoL42Gj/
	 uL3Jpl3v1nl8A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:55:06 +0100
Subject: [PATCH 06/23] kbuild: only emit vmlinux relocations when required
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-build-speedup-v1-6-5dc1ac01672d@kernel.org>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
In-Reply-To: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
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
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3331; i=ljs@kernel.org;
 h=from:subject:message-id; bh=N13ZqN50eOU7uY3QR0adbXAgcslOg42oxhOb+TbiiNY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWlJkt3xWaebJaeGL+Iy2LKP8PquXzJH3nb+NPU+v7v
 +ri19ncHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIVSYjw28ziSzFyOPHLuxN
 d+HOdz7m1O692N/s6NnTf+UL4/Q0VzD8s3+t5hF984P3AqmC154yZ368DXzBtN93Ts1vtiDP7ms
 R/AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

A kernel build consists of more than one linking pass on vmlinux.o and
vmlinux, at minimum two, and with CONFIG_KALLSYMS and BTF enabled on x86-64
for example there are 5 such stages.

For architectures that build their own relocation tables (x86, riscv, mips,
s390), vmlinux is linked with the --emit-relocs parameter specified.

However, this is only required on the final vmlinux link.

Symbol tables of trial links preceding it don't need it because they
already check that System.map matches kallsyms symbols on each build.

GNU ld is slow at emitting relocation tables, so this results in a
reduction in build time.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 defconfig, touch mm/vma.c, gcc        9.8s     9.4s    -0.43s (-4%)
  x86 defconfig, clean, gcc                28.6s    28.1s    -0.47s (-2%)
  x86 allmodconfig, touch mm/vma.c, gcc    44.0s    42.7s     -1.3s (-3%)

Note that this has little impact on LLVM ld which performs this operation
more efficiently.

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Makefile                 | 4 +++-
 scripts/Makefile.vmlinux | 3 ++-
 scripts/link-vmlinux.sh  | 6 ++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 66654fa71655..85eb2fd026cb 100644
--- a/Makefile
+++ b/Makefile
@@ -1263,8 +1263,10 @@ LDFLAGS_vmlinux += --orphan-handling=$(CONFIG_LD_ORPHAN_WARN_LEVEL)
 endif
 
 ifneq ($(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS),)
-LDFLAGS_vmlinux	+= --emit-relocs --discard-none
+LDFLAGS_vmlinux	+= --discard-none
+LDFLAGS_vmlinux_relocs := --emit-relocs
 endif
+export LDFLAGS_vmlinux_relocs
 
 # Align the architecture of userspace programs with the kernel
 USERFLAGS_FROM_KERNEL := --target=%
diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index fcae1e432d9a..4b54aaeca65d 100644
--- a/scripts/Makefile.vmlinux
+++ b/scripts/Makefile.vmlinux
@@ -64,7 +64,8 @@ ARCH_POSTLINK := $(wildcard $(srctree)/arch/$(SRCARCH)/Makefile.postlink)
 
 # Final link of vmlinux with optional arch pass after final link
 cmd_link_vmlinux =							\
-	$< "$(LD)" "$(KBUILD_LDFLAGS)" "$(LDFLAGS_vmlinux)" "$@";	\
+	$< "$(LD)" "$(KBUILD_LDFLAGS)" "$(LDFLAGS_vmlinux)" "$@"	\
+	   "$(LDFLAGS_vmlinux_relocs)";					\
 	$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
 
 targets += vmlinux.unstripped .vmlinux.export.o
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 970ca10f8fa9..09c5222ccb94 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -32,6 +32,7 @@ LD="$1"
 KBUILD_LDFLAGS="$2"
 LDFLAGS_vmlinux="$3"
 VMLINUX="$4"
+LDFLAGS_vmlinux_relocs="$5"
 
 is_enabled() {
 	grep -q "^$1=y" include/config/auto.conf
@@ -96,6 +97,11 @@ vmlinux_link()
 		ldflags="${ldflags} ${wl}--strip-debug"
 	fi
 
+	# Only the final link actually requires the relocations.
+	if [ "${output}" = "${VMLINUX}" ] && [ -n "${LDFLAGS_vmlinux_relocs}" ]; then
+		ldflags="${ldflags} ${wl}${LDFLAGS_vmlinux_relocs}"
+	fi
+
 	if [ -n "${generate_map}" ];  then
 		ldflags="${ldflags} ${wl}-Map=vmlinux.map"
 	fi

-- 
2.55.0

