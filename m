Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32B942A175;
	Mon, 14 Sep 2026 09:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377783; cv=none; b=S6o7+m09MKIS4uQ7MXVcy/lNSlkvf7kRo3l5ODkiG/a9r4QiIeLCPkt1GZf/BqAmQj63yjAmbudwJoe4X1h4knMEqwCokyllmhcQcjdDRwvFslJuAw50hkQgJVYIogjrgqAVy92LVP8vWlszrCPY/misHtjylan5U1xnRHdJJkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377783; c=relaxed/simple;
	bh=EBlEnSGuCnJVwiujMjlFOqeFXEqyFnYzRW7W0NWQNRY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gVgb62R9YF1AHCeBy5Uny8zYM6vAtlGNvlKWev18SDQWFsBV00swH9v5qbUACX7FC867/Jd2ZuUwE9egXclfZ3KxZVpGvQ5q3tc2EBuAUomqEjbKCzB0ZZBOs8oM/wwOk9jbFsP+sORkmboa2L6iYwwj95A/6Yo7jf7BrbYY8As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h1YfuEEU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1YfuEEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0FC1F0089A;
	Mon, 14 Sep 2026 09:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789377781;
	bh=kU2taAW2zjsL9Ma3CzB5TbBN6AIOAn4hVTWBK2Wl6c8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h1YfuEEUr1jL82h2ZqdJ44qNoHvt9yx6buktBtngN8pjpbfu9FIsuq/gzrB9EyEwa
	 ig3BWeyieBeR/Wzpz8+tG8OLEwaK7HJCiUsBRVobDJjuonQT9a3ivCdCVoPl37yA+d
	 HkKSEKIzuLXGwNBcRN4KNeehquasJC+eMloCgx5g++n2UfOjFY2qVopCHnCuOAK2G3
	 i1FCwq8uDPbjtqA6lj452gaM+zTc6yDL+ATUwMEyo/jqJ1n4k74D0RwsNglCg66DAb
	 4KbMmwNdfdDJ999PZrPrgJTdauP2Y/vVSJXxIh0G8NJ6QLb4GzKpHE9kLsYeKMGCFs
	 pkcc3Z0/ttRvQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 10:22:04 +0100
Subject: [PATCH v2 05/21] kbuild: only emit vmlinux relocations when
 required
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-build-speedup-v2-5-39817ec5db23@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2346; i=ljs@kernel.org;
 h=from:subject:message-id; bh=EBlEnSGuCnJVwiujMjlFOqeFXEqyFnYzRW7W0NWQNRY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKW79mfJjlH8lu8/bIJm9d7ln/oNL91RHnWxNU80nppj
 xVmpp960lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ5OgzMvz1DJHzd/INU7hz
 Xqjx3K3WJyzPP2vfli0OT1Kdfav8yByG/+lXQlvNtt2sNmkxv2q55HjohuyO38eXLXj7wEll/d7
 rpiwA
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
  x86 defconfig, touch mm/vma.c, gcc        9.5s     9.1s    -0.42s (-4%)
  x86 defconfig, clean, gcc                30.1s    29.5s    -0.59s (-2%)
  x86 allmodconfig, touch mm/vma.c, gcc    37.2s    35.8s     -1.4s (-4%)

Note that this has little impact on LLVM ld which performs this operation
more efficiently.

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Makefile                | 2 +-
 scripts/link-vmlinux.sh | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0f1b80100b47..dd4c10afbb7f 100644
--- a/Makefile
+++ b/Makefile
@@ -1263,7 +1263,7 @@ LDFLAGS_vmlinux += --orphan-handling=$(CONFIG_LD_ORPHAN_WARN_LEVEL)
 endif
 
 ifneq ($(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS),)
-LDFLAGS_vmlinux	+= --emit-relocs --discard-none
+LDFLAGS_vmlinux	+= --discard-none
 endif
 
 # Align the architecture of userspace programs with the kernel
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 970ca10f8fa9..ed5ff97c0667 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -96,6 +96,11 @@ vmlinux_link()
 		ldflags="${ldflags} ${wl}--strip-debug"
 	fi
 
+	# Only the final link actually requires the relocations.
+	if [ "${output}" = "${VMLINUX}" ] && is_enabled CONFIG_ARCH_VMLINUX_NEEDS_RELOCS; then
+		ldflags="${ldflags} ${wl}--emit-relocs"
+	fi
+
 	if [ -n "${generate_map}" ];  then
 		ldflags="${ldflags} ${wl}-Map=vmlinux.map"
 	fi

-- 
2.55.0

