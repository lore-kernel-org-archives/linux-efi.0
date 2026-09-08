Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7784E3B6BF2;
	Tue,  8 Sep 2026 20:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901046; cv=none; b=kUdwZ+1UM/Sdhb3TVp+h7WC/+sUgUTkAWp6IdCHMymXJrKk6SJWBxd4c738zten6amXcCWH/VmB27phqvViXWUhyJvSks/ExOpXA5gTdI/Z4ZmIOdaj3JuWEpDGkAasRwQTe4dqDglcpVTk99wqWwIxqehT2y4FETv5NZZ/f+P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901046; c=relaxed/simple;
	bh=TtGzRcvdpH1o/Q/maX3eAqRdjLYh9rcQLyvEGgPc5lo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fmzrLWbM5CmXVmH+/FJIVrjcW4r/IK+oITWjAcA3MuuCYGh+IFnnAMGCbROSF1R3W2oEz6Xs4f9jVBpbCqHCxutSpZT4gzYiBsD+0fISIXpr6VFDHZxYnmUSfK9DP976Z5ojUXbrridtiDr0Jw88Ix5sJ5uKvYGo8Ela/tj+scU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUt/Q2g+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUt/Q2g+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC6D1F00A3A;
	Tue,  8 Sep 2026 20:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901045;
	bh=Zp+1QGtqTWMKHztfUixkIr/p7k1hkTe9DSbsity3M/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EUt/Q2g+NKaQ6S9lFZONrRdJapaT1x9rVJ0A9T48zaQRh1S544VNiCfglDSAJxYOe
	 0VJfwfGqdWhSMhOtk3C+HRU0yiUsplApEb3u1NGmEb/A447ROZaiCvc7jGZJSxxQ0i
	 57CIJfVZLHcZ2u8R4p7iBirtj7QRoylDHEfSmUnJ25duqw5thHuFFDqwSgasODWmYe
	 KhqeJ7XNBet3kWpmY8O6OQOUthcFVEZiFWdFZ0mhrigAf1m3KihCiOekibd8CjQekA
	 /B+299FwQ65IAfJ02Mme2/7KTRNgDDpVdxacj6iHcv/EfqS1JiQXdrk8q1fk02QGli
	 4vfQMWnG3EfdQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:55:10 +0100
Subject: [PATCH 10/23] kbuild: cache list, composite object state per
 object
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-build-speedup-v1-10-5dc1ac01672d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3457; i=ljs@kernel.org;
 h=from:subject:message-id; bh=TtGzRcvdpH1o/Q/maX3eAqRdjLYh9rcQLyvEGgPc5lo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWlJlf+Pln5qwZhy76pPI49jarLjh5M5ZvurHztdCMS
 SsP9jy71lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ/HjByHAyt/PJ57JakwfH
 fQXXqjz6pHfwseSa+DMnwn5m//vOn83HyHB+Thzvs+ALT57z2jRyv/Uq6tktxSN/0PrlyzLbFT9
 2nGEAAA==
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

Fix the issue by caching this data and looking it up instead of getting it
over and over again.

This has a particularly large impact on allmodconfig builds.

Whole build, 128-thread Threadripper 9980X, best of N runs:

                                         before   after     delta
                                         -------------------------------
  x86 defconfig, no-op make, gcc           0.94s    0.92s    -0.02s (-2%)
  x86 defconfig, no-op make, clang          1.1s     1.1s    -0.01s (-1%)
  x86 allmodconfig, no-op make, gcc        13.0s    12.3s    -0.64s (-5%)
  x86 allmodconfig, no-op make, clang      13.8s    13.2s    -0.64s (-5%)
  x86 allmodconfig, touch mm/vma.c, gcc    41.6s    40.9s    -0.70s (-2%)
  x86 allmodconfig, touch mm/vma.c, clang  38.1s    37.6s    -0.52s (-1%)

Assisted-by: LLM
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

