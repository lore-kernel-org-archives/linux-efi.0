Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C043B3E4C61;
	Wed, 23 Sep 2026 17:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184021; cv=none; b=T04VdbXLEgp+7xC+19Wc1nwE3xilLvH+TJHrdRAaqKmFVhtyjAdgPrRx8L+76XsBuMhc0MpkS//wWK0I9wFHo9h13heU9buEWk7NyfnSmuzvXyKrn97IVDMTv990yZTJVmsltQ2mrk+o9JZ5Nn6Y68IyjYdyKSWjxcrqx3Xs+zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184021; c=relaxed/simple;
	bh=1tlfspzVyupWDtDIq9Xi6b2r8IeD5B+p03B8UkqK1dA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YuYOkJxzmJUOkwnwOTHEIwvM/s5Hs+eMzPNOHLsVT0NmooptaW1VE2FqjlxAaIeOP8DCRn3UbF9ob30DwZ3YJjYwrHbJBgdUhWCVd35mjJR4+b1P12T00xECZuW/BHvAPRPSjVWJbemNdXRtz4ch8eVyVbWLPuea2Z3XbdW8y6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZ46Am8b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZ46Am8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FCE1F00893;
	Wed, 23 Sep 2026 17:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790184019;
	bh=+rwl1Zn9bU3CF5Lv6uJecPAyTurD5CJjPcxpUYcu/S0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mZ46Am8b6Wn9IMnH8S2ELNq04sKgdTBqXyocEc8OiLB0sIiwNs/r3xJS7H+Jps8UB
	 Nr6oNJarDDpQaWtichSPBo6WiOxV2I/l6AUnAGHuHANUHxpuu2aHkDkf4NJ3FdIYPs
	 LCw0TVk09iax4Vzz4tQdzXYTXcEPXUz34TFC+3lcSzfEhpFGFPbjAhQeHBqIQ/Dif8
	 ZFW0n3RzfA4QblsDN/VKZRAVIggc1iQPR5fT9pZ1lWsexJBduO/kql9jVY68tmvSvK
	 U9JRqHbVg4kFTgLsFXUxkNb+L4jPIRFRUxVfE9wd2ZGBl0Y1yNn7XtyaJSKrxrB/bh
	 7+S3dv4tqFp+g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 23 Sep 2026 18:17:58 +0100
Subject: [PATCH v4 09/22] kbuild: calculate list, composite object state
 per object
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-build-speedup-v4-9-73128809a4a4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3573; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1tlfspzVyupWDtDIq9Xi6b2r8IeD5B+p03B8UkqK1dA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2cF6e9yE+QOQp734n36qPH5XC1tztqeaztH+w+1ud6
 NnbN0xCO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARpuWMDD9uLjv/Tf5qzXuz
 +M+ue27qrjt6u2Xji/mi5iLfY+4//crH8E9zWuT8XfqLT783vWcXtMFMm4/zb/0vo393ec3/ZTG
 5cLMCAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

When each object's command line is expanded, kbuild has to figure out on
multiple occasions whether it's built-in or part of a module and which
composite object it belongs to.

This causes the time spent on each directory in the kernel tree to grow
O(n^2) with its object count, which is especially problematic for instance
in drivers/gpu/drm/amd/amdgpu with 310 objects.

No-op builds (i.e. make -j $(nproc) when nothing has changed) are
particularly impacted by this.

Fix the issue by calculating this data once and looking it up thereafter
instead of recomputing it over and over again.

This has a particularly large impact on allmodconfig builds.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 defconfig, no-op make, gcc            1.1s     1.1s    -0.02s (-2%)
  x86 defconfig, no-op make, clang          1.3s     1.3s    -0.01s (-1%)
  x86 allmodconfig, no-op make, gcc        15.3s    14.5s    -0.83s (-5%)
  x86 allmodconfig, no-op make, clang      16.2s    15.5s    -0.65s (-4%)
  x86 allmodconfig, touch mm/vma.c, gcc    35.0s    34.3s    -0.77s (-2%)
  x86 allmodconfig, touch mm/vma.c, clang  33.7s    33.2s    -0.51s (-2%)

Assisted-by: LLM
Reviewed-by: Nicolas Schier <n.schier@fritz.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 scripts/Makefile.build | 8 ++++++++
 scripts/Makefile.lib   | 7 +++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 4349108e75e1..2cabfe85b798 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -122,6 +122,14 @@ multi-obj-m	:= $(addprefix $(obj)/, $(multi-obj-m))
 subdir-ym	:= $(addprefix $(obj)/, $(subdir-ym))
 endif
 
+# Cache which list each object is in and which composite objects it belongs to,
+# once per object for $(part-of-builtin), $(part-of-module) and $(modname-multi).
+$(foreach o, $(real-obj-y) $(lib-y), $(eval part-of-builtin_$o := y))
+$(foreach o, $(real-obj-m), $(eval part-of-module_$o := y))
+$(foreach m, $(multi-obj-ym), \
+	$(foreach o, $(call suffix-search, $m, .o, -objs -y -m), \
+		$(eval modname-multi_$o += $(m:.o=))))
+
 ifndef obj
 $(warning kbuild: Makefile.build is included improperly)
 endif
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 0a4fdd8bd975..2f447bc25e7b 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -2,8 +2,7 @@
 
 # Finds the multi-part object the current object will be linked into.
 # If the object belongs to two or more multi-part objects, list them all.
-modname-multi = $(sort $(foreach m,$(multi-obj-ym),\
-		$(if $(filter $*.o, $(call suffix-search, $m, .o, -objs -y -m)),$(m:.o=))))
+modname-multi = $(sort $(modname-multi_$*.o))
 
 __modname = $(or $(modname-multi),$(basetarget))
 
@@ -149,8 +148,8 @@ endif
 # If $(is-kernel-object) is 'y', this object will be linked to vmlinux or modules
 is-kernel-object = $(or $(part-of-builtin),$(part-of-module))
 
-part-of-builtin = $(if $(filter $(basename $@).o, $(real-obj-y) $(lib-y)),y)
-part-of-module = $(if $(filter $(basename $@).o, $(real-obj-m)),y)
+part-of-builtin = $(part-of-builtin_$(basename $@).o)
+part-of-module = $(part-of-module_$(basename $@).o)
 quiet_modtag = $(if $(part-of-module),[M],   )
 
 modkern_cflags =                                          \

-- 
2.55.0

