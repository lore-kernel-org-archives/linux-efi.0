Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DC943785D;
	Mon, 14 Sep 2026 09:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377860; cv=none; b=YPmiTPBbntDXNtGhu3BIejsDT6bWuyffDeHCtttz+POFKVks8Z717bMx8F0U275xWvRVOT6yEx8MH3CGNStcneFaqRkl4tVLGfJN+Kcs9aLjdKXq1mQqxo2Y0SEpNcK8PkVc76gGWbp6xekNfaaiQJi3fnYOvGfOl5fcvgxK0oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377860; c=relaxed/simple;
	bh=PX8IN9JrsL8iJYLg139us1x7mcO+XIIlC9tEYIW77Ho=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s4KDFKltCmcP+GQ+TJ/hQAA4Gg+qf4cE59VEW/Vs3DkxqOdFB687K02tLPBwxrWHXZA0nLB+ESzAjZDW66xy0Sw6dc76FEQqfLWg5O/4rN8qcDG0P+Xkq1oiWABijsSA1eockHkVF4r0Mpu/CpCTzsuknCb97+cgjY5N3xmMkxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iH8CDrUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iH8CDrUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A631F00898;
	Mon, 14 Sep 2026 09:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789377858;
	bh=2gnDaqR7QH9Z9HodpfUWD1aJEAoGawd7+ykHT7EyQU8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iH8CDrUk1TR7rZ/Ijm5+YidnQGMK07J0ho1v/afYDlb/e9WwluKvY7J5rJLDYnUj1
	 1QuAN516IgpqRz5DZ7e88DaO8Z8tB27Q4EJFfz2y42esOQvzNA7u2ttXXNCigxteM8
	 fZpJLfd4bp9s5yulyPOUfYWK8qBGyjrhab6pPUrcFNq0Qrbr7SpC5vlGm/yM7Wc/hL
	 hE8bX7jr7SWY9HvZwvFdkfq0Obr1M3rLfMmjRq4AmEOSSUSj1CviXrt9A/UxVGBib7
	 MtYZ3xBk5uOT0KLdVbCCzBnrpU9b2axIEw7Kbekm566hbat0pUUrI7HztVoUxjL9Ax
	 xScLzNPfRsH9A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 10:22:13 +0100
Subject: [PATCH v2 14/21] kbuild: batch module finalisation
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-build-speedup-v2-14-39817ec5db23@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3374; i=ljs@kernel.org;
 h=from:subject:message-id; bh=PX8IN9JrsL8iJYLg139us1x7mcO+XIIlC9tEYIW77Ho=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKW7zloe05tFaPol9Aw+1M3+4Q4AnpTDQ0jOwVaPzw64
 3xsb+PNjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkph4jw710v5K5zCbOX4VE
 TmYJn1FaocloYNIY6nB3Tk3d5ESpd4wM2/TDWwK0O8S9C+e5nz+70Wyf3j/Hirq1l6bnM+y7kb2
 BBwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Module finalisation on allmodconfig builds consists of a large number of
very short-lived jobs, and the make job dispatcher cannot possibly dispatch
jobs fast enough.

For allmodconfig x86-64 this can be on the order of ~22,000 jobs of a few
milliseconds in duration each.

However per-job cost grows with the variables the instance holds, here the
savedcmd_* of every .mod.o and .ko read back from the .cmd files, since it
walks them all to build each child's environment.

This makes module finalisation very inefficient when large numbers of
modules are being built.

Fix this by splitting modules.order into chunks of 128 at a time, run in
parallel.

Each instance holds only its own modules' variables and the top-level one
reads no per-module .cmd files at all, the same rules serve both levels,
and an instance is told its chunk with modfinal-first=<index>.

"make modules" with every *.mod.o and *.ko deleted goes from 28.9s to 15.9s
with clang 22. No-op "make modules" goes from 5.6s to 4.8s, as checking the
22,000 targets is spread over the chunks too.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 allmodconfig, no-op make, gcc         2.3s     1.4s    -0.85s (-38%)
  x86 allmodconfig, no-op make, clang       2.8s     1.8s    -0.94s (-34%)
  x86 allmodconfig, clean, gcc            306.6s   294.1s     -12.6s (-4%)
  x86 allmodconfig, clean, clang          290.2s   283.9s     -6.4s (-2%)

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 scripts/Makefile.modfinal | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 75e9effdf02c..858fa798090b 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -13,9 +13,30 @@ include $(srctree)/scripts/Makefile.lib
 # find all modules listed in modules.order
 modules := $(call read-file, modules.order)
 
+modfinal-chunk-size := 128
+
+ifdef modfinal-first
+
+# this instance handles the chunk of modules.order starting at $(modfinal-first)
+modules := $(wordlist $(modfinal-first), $(words $(modules)), $(modules))
+modules := $(wordlist 1, $(modfinal-chunk-size), $(modules))
+
 __modfinal: $(modules:%.o=%.ko)
 	@:
 
+else
+
+modfinal-chunks := $(addprefix chunk-, $(shell seq 1 $(modfinal-chunk-size) $(words $(modules))))
+
+PHONY += $(modfinal-chunks)
+$(modfinal-chunks): .module-common.o
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modfinal modfinal-first=$(@:chunk-%=%)
+
+__modfinal: $(modfinal-chunks)
+	@:
+
+endif
+
 # modname and part-of-module are set to make c_flags define proper module flags
 modname = $(notdir $(@:.mod.o=))
 part-of-module = y
@@ -58,7 +79,10 @@ ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 endif
 	+$(call cmd,check_tracepoint)
 
-targets += $(modules:%.o=%.ko) $(modules:%.o=%.mod.o) .module-common.o
+targets += .module-common.o
+ifdef modfinal-first
+targets += $(modules:%.o=%.ko) $(modules:%.o=%.mod.o)
+endif
 
 # Add FORCE to the prerequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------

-- 
2.55.0

