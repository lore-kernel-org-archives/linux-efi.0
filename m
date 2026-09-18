Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6801731352B;
	Fri, 18 Sep 2026 00:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692717; cv=none; b=OPbNKWBzL0uzLPlLK+8tZvEAj6TVbygp6ZZWd+0raARYyu5ZQ8pO3V+cxdjInW7DhIyYDtMLrXVuFzh9ARqyvl2jxODUnurlC/4WsPXuWoO7Ig6q7Q9Zx2M1pQrMv0FClM0XouBGlMytRB+8AnNgwVlIEkxzdTLjZ7wMM8wk3a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692717; c=relaxed/simple;
	bh=iGPHI5UWlo9rdQOFQokdsYKHregBEoWF9Yz0lFovr4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=beStfcGMx+NbQR4FlnSgPhqCxPCNurS12yzvHkihRMhICSazfbhICOS1WvnEe3Cx8eaHN2DjI4S/3iKUMDeZ1zntnIos4EBOjjTk4dZwJpUlRmpizfPDu6LC9finRevChHIUMAJryKPgohdn6GhTUOqrR3FElqWwlnLfI2fKIf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjvcDNB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjvcDNB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8230E1F000FF;
	Fri, 18 Sep 2026 00:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789692716;
	bh=yA3lnuWenPZEpso8xNSQIX74GwmYPRWoEfZxEhdIfSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mjvcDNB+okGYr3dG66y+BvYzLyk0Onz7snwgPiHEVmAvBEJJwHw3WccyPGdgVFjU2
	 rEg9+TLd1v6ZQ+iEXqwp0QgnThtFX7Dq2unDSzTMGTzq4PkqgguUjCNyXb43sSeX0e
	 xoHcVWgQm/BtOLlmWyOaxMoNLBZppCZIsiqpFvdpnut93RwJMNLKXu6zUzBIuaLfnk
	 AIMVDnbM2rpFb+17dsTiKOTWoOV3DvZ/JxSGvXYcnwe6gPK9BPBn1YGr8OvYz0l4m1
	 0urx7Cu8e7QeOh0SKCLMYfAw8CVZi9Z6zPuV7CleGYmLskIgGw8DRe+dfsdW4PfqWB
	 iK6YY6+jsUF8g==
Date: Thu, 17 Sep 2026 17:51:42 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Kees Cook <kees@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 01/20] kbuild: do not allocate .modinfo in vmlinux
Message-ID: <20260918005142.GA1585590@ax162>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-1-9ecf4163ff36@kernel.org>
 <202609170950.480F90A28@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609170950.480F90A28@keescook>

On Thu, Sep 17, 2026 at 09:52:32AM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2026 at 05:06:11PM +0100, Lorenzo Stoakes (ARM) wrote:
> > -# .modinfo in vmlinux.unstripped is aligned to 8 bytes for compatibility with
> > -# tools that expect vmlinux to have sufficiently aligned sections but the
> > -# additional bytes used for padding .modinfo to satisfy this requirement break
> > -# certain versions of kmod with
> > -#
> > -#   depmod: ERROR: kmod_builtin_iter_next: unexpected string without modname prefix
> > -#
> > -# Strip the trailing padding bytes after extracting .modinfo to comply with
> > -# what kmod expects to parse.
> 
> This comment still seems useful here (afaict the stripping is still
> happening with the "sed"). Maybe better to leave it, or future readers
> are left wondering what the sed is for?

Thanks for bringing this up. I think we can actually get rid of that sed
and comment altogether. It was added by

  a26a6c93edfe ("kbuild: Strip trailing padding bytes from modules.builtin.modinfo")

to fix

  d50f21091358 ("kbuild: align modinfo section for Secureboot Authenticode EDK2 compat")

but I do not think that this alignment is needed anymore since I
properly fixed Dimitri's issue in

  8678591b4746 ("kbuild: Split .modinfo out from ELF_DETAILS")

So I think we could go with something like

From 008046b33ef4b476048e3ddb2c679a453254e535 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 17 Sep 2026 17:29:53 -0700
Subject: [PATCH] kbuild: Remove alignment on .modinfo section

Commit d50f21091358 ("kbuild: align modinfo section for Secureboot
Authenticode EDK2 compat") aligned .modinfo because it appeared in the
x86_64 compressed kernel image after commit 3e86e4d74c04 ("kbuild: keep
.modinfo section in vmlinux.unstripped"), breaking boot.

Commit 8678591b4746 ("kbuild: Split .modinfo out from ELF_DETAILS")
properly addresses .modinfo appearing in unexpected contexts like
compressed images by moving it out of ELF_DETAILS and explicitly
specifying its location in every architecture's vmlinux linker script or
discarding it where it may appear elsewhere.

Effectively revert commit d50f21091358 ("kbuild: align modinfo section
for Secureboot Authenticode EDK2 compat") and its follow up fix,
commit a26a6c93edfe ("kbuild: Strip trailing padding bytes from
modules.builtin.modinfo"), as they are no longer necessary in the
current tree. This simplifies future cleanups.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |  2 +-
 scripts/Makefile.vmlinux          | 10 ----------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b2988aa12f66..26201821ea7f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -855,7 +855,7 @@
 		KLP_SYMID
 
 #define MODINFO								\
-		.modinfo : { *(.modinfo) . = ALIGN(8); }
+		.modinfo : { *(.modinfo) }
 
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index fcae1e432d9a..6833b517cacb 100644
--- a/scripts/Makefile.vmlinux
+++ b/scripts/Makefile.vmlinux
@@ -102,18 +102,8 @@ vmlinux: vmlinux.unstripped FORCE
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
       cmd_modules_builtin_modinfo = $(cmd_objcopy); \
-                                    sed -i 's/\x00\+$$/\x00/g' $@; \
                                     chmod -x $@
 
 OBJCOPYFLAGS_modules.builtin.modinfo := -j .modinfo -O binary
-- 

Then this patch becomes much more obvious (at least to me)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 26201821ea7f..a6730d34e8c6 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -855,7 +855,7 @@
 		KLP_SYMID
 
 #define MODINFO								\
-		.modinfo : { *(.modinfo) }
+		.modinfo (INFO) : { *(.modinfo) }
 
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index 6833b517cacb..95b523fe4f9e 100644
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
@@ -103,10 +100,7 @@ vmlinux: vmlinux.unstripped FORCE
 # ---------------------------------------------------------------------------
 
 quiet_cmd_modules_builtin_modinfo = GEN     $@
-      cmd_modules_builtin_modinfo = $(cmd_objcopy); \
-                                    chmod -x $@
-
-OBJCOPYFLAGS_modules.builtin.modinfo := -j .modinfo -O binary
+      cmd_modules_builtin_modinfo = $(OBJCOPY) -O binary -j .modinfo --dump-section .modinfo=$@ $< /dev/null
 
 targets += modules.builtin.modinfo
 modules.builtin.modinfo: vmlinux.unstripped FORCE
--

Thoughts?

-- 
Cheers,
Nathan
