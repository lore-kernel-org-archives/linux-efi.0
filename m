Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3DB4EB840;
	Thu, 17 Sep 2026 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661384; cv=none; b=lFUWFpj2yZSKGIqevwO8ftJ9XYGaCwAuqlvIafIbbOA/HVllfADDSy/w3AqqbidMRvLUkkXsKrchE7fp/74ZmMD/jTvplltu74yogurkDuLmUCLQTikwrdQ+S4gAoLCO2TNvEXNlv6XVB2uVtdDnQHnLTQB8FVabnVIt2l3HMwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661384; c=relaxed/simple;
	bh=RLQvuwM41WcrPKnU42zhRNFNmVgfkGG+NjknfyWXoEs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DJf2uVPGZvrMPR2vzlVIPsBk3EoXtdSuKdOIGd27GtJgThWXbr+fwJmZ5MQ7p3PQMzaXp8U3tW8l/tnJlMiT298pmKh/w8SyXD6scVTht0laQCjXjb/ieqkgMw8HnSJHhSkXQOpnzZ9l3VDMcW6Y9le7+eU0cwyPlpeoC5JAdc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ScL4qLbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ScL4qLbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E811F000FF;
	Thu, 17 Sep 2026 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789661382;
	bh=5xWV9qPVBA53NbkJvCBIcKASWfrmhIW9Yj44HCnJWZE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ScL4qLbiZVwfot7DpKhh+O7lMtqBadEU0+rC0KGvgjKCkr327ni5YSnvqz7A9+1Jg
	 yZsLSIFwN1//ROP8EvzVHFkCSfT75hdjMU1xs+SAe4tYO+DpmTO2xyC2MAsLovK+a6
	 wT1pJUGyXHT6zAhUiueVxXdlEtfvK/JadN2SYt43IGlk0gSuruQuJ+tH8ZZsGKlubP
	 HnwcDR4pMy//z6KLBx8KfGsa0DLdVa8MWNT+tTf3HZBH6LEqqCm4NcJqnYvmpYmkIY
	 eKB3SHl881nKnmiAvMi0wKOshjeAjhiNajeA98AuR/SeKClAdBOTQge+ZJJQptNF2e
	 R0a35RxAy6y1Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:06:24 +0100
Subject: [PATCH v3 14/20] kbuild: batch module finalisation
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-build-speedup-v3-14-9ecf4163ff36@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4961; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RLQvuwM41WcrPKnU42zhRNFNmVgfkGG+NjknfyWXoEs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLW8P83uuuzImrWs4oGRoM3LzJK1/bxdnt6PCpc/CNY/
 t7X0rcnO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARthJGhh33Wc9M3vecPY5L
 fvl73hYHJePz35d6B03203kt3SFeGcXIsLawonZZFHfZ9/Jb26clqf+98arCZZ5Slazrvrs+Wya
 a8AEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

With the .mod.S change in place, module finalisation on allmodconfig builds
consists of a large number of very short-lived jobs.

For allmodconfig x86-64 this can be on the order of ~22,000 jobs of a few
milliseconds in duration each.

Each job entails processing ~22k .cmd files, so the combination of heavy
overhead and small individual job results in a lot of unnecessary and
repeated work even with all cores being utilised.

The solution is to batch by a number of jobs. Determining which value makes
sense was done empirically.

On a 128-thread threadripper box doing an allmodconfig build, best of
2, *.ko, *.mod.o deleted each time:

    modules per chunk    instances    wall
    -----------------    ---------    ------
                    1        11171    10.22s
                    2         5586     6.72s
                    4         2793     4.97s
                    8         1397     4.26s
                   16          699     4.05s
                   32          350     4.05s
                   64          175     4.07s
                  128           88     4.05s
                  256           44     4.03s
                  512           22     4.18s

Wall time flattens for 16-256 module batches.

A slower/lower core machine will do better with fewer modules-per-batch, a
faster/higher core machine will do better with more modules-per-batch.

Therefore, take the midpoint which works in the most margin in either
direction - 128 modules per batch.

This naturally scales with module count too as the optimum gains are
obtained with higher module count, so fewer batches in this case costs less
overhead.

Each instance holds only its own modules' variables and the top-level one
reads no per-module .cmd files at all, the same rules serve both levels,
and an instance is told its chunk with modfinal-first=<index>.

Only the top-level instance builds .module-common.o, to the chunks it is a
plain prerequisite, so no two instances ever write it.

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
 scripts/Makefile.modfinal | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 75e9effdf02c..4d5e6e1a0ff9 100644
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
@@ -29,8 +50,11 @@ quiet_cmd_as_mod_o = AS [M]  $@
 %.mod.o: %.mod.S FORCE
 	$(call if_changed,as_mod_o)
 
+# Built by the top-level instance alone, the chunks take it as a plain file.
+ifndef modfinal-first
 .module-common.o: $(srctree)/scripts/module-common.c FORCE
 	$(call if_changed_rule,cc_o_c)
+endif
 
 ifneq ($(WARN_ON_UNUSED_TRACEPOINTS),)
 cmd_check_tracepoint = $(objtree)/scripts/tracepoint-update --module $<;
@@ -58,7 +82,11 @@ ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 endif
 	+$(call cmd,check_tracepoint)
 
-targets += $(modules:%.o=%.ko) $(modules:%.o=%.mod.o) .module-common.o
+ifdef modfinal-first
+targets += $(modules:%.o=%.ko) $(modules:%.o=%.mod.o)
+else
+targets += .module-common.o
+endif
 
 # Add FORCE to the prerequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------

-- 
2.55.0

