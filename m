Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE4F421251;
	Mon, 14 Sep 2026 09:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377901; cv=none; b=FQ532oqFwTgWJZnUc6XML37Zv4FBNTsTnIXCn81a9RD2dGZiBemUjaRv6yMxP11RbIs+rtEkTUE+6LOMjjqRr/EnOU+L7fhusyZdTtQ4Nejm5XsAtO6mji2rmBNK3xNadDtaJUINSXzeXT0nCQFbcJsg3PdtTKUL5X+XP4RKw/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377901; c=relaxed/simple;
	bh=kx145CbsbOZNlrJo3YNnQ6X8zzclemP0tqvdTYAGrNw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s7YMfSlT5DDpz4fs5n9Qgg4BKfQhrbDA3w+aCDgA1sXLAaqGL2S4ZA5v8YfBX68oAgGqJ3ObJwVCS5xniV+AUBFp7INu0KE6bpZsIwHbW7e9EULWCag18l5pkC4pYFe6KuBOLlSoempXISApeO13IryRPMuLdLSMXCxVpSAkgaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3APckzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3APckzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BE61F0089C;
	Mon, 14 Sep 2026 09:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789377900;
	bh=RpyglNkLvgtO+g1zDJNpkY3JopuChXGi3ttcKAuST+8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=U3APckzcNb8JbHUrZoRsUAYzbb2c1GG3R21FSCiQl7qGnktoxcrbO5lQ1vnZIHOt0
	 UgAQtI9JIL23r52AaC8GHgQ5spR1CSkcKSTLzuob6H2/KGNx04h8NLIzGN0PTe1qab
	 WmLKdME1iAZ4rlIMc38H/Twr1zbJf2hLQUXRLpfyh9bucU1GUncLmAKCjUcpgbsoJH
	 q5xzRSbX30gawk84mxWqQGyD0RpF9V0RRW4691rZWARXSTa8YrRAfa4NpBuMWp08np
	 5N1M1ikxC7g5MsACM4LVKuNGTbLb1d81V1Elb0+sRCQfhcLoqIdkmPMymr6ajsVPvd
	 phDdRui2DdyRQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 10:22:18 +0100
Subject: [PATCH v2 19/21] rust: make exports.o depend on the headers
 generated for it
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-build-speedup-v2-19-39817ec5db23@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1286; i=ljs@kernel.org;
 h=from:subject:message-id; bh=kx145CbsbOZNlrJo3YNnQ6X8zzclemP0tqvdTYAGrNw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKW7zlkoemU35h/acemw+aTIx/+ZZy6y/DfZ4m925e/k
 ft8ZaukQUcpC4MYF4OsmCLL8y/i+4NEwuZ1XvB3g5nDygQyhIGLUwAmIvuIkeHRkV/PN5sz5D0q
 vFnKZfCRT1ErvnOmu0BJ1cYTZ3Y8PeLB8N9/3XuJuy1rmbb97z242mYK94ozySlyMl27Nh30fly
 8PoMHAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

rust/exports.c includes the exports_*_generated.h listing the symbols of
the core, bindings, kernel and helpers objects, but this is not expressed
in its Makefile.

This worked previously because the headers are always-y targets, and make
prepare built all of the rust crates first, which is an implicit
dependency.

Fix this as it is a dependency of the subsequent commit.

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 rust/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/rust/Makefile b/rust/Makefile
index da1a7409d984..74d21ae6f383 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -728,6 +728,11 @@ endef
 $(obj)/helpers/helpers.o: $(src)/helpers/helpers.c $(recordmcount_source) FORCE
 	+$(call if_changed_rule,rust_cc_library)
 
+# The exported symbol lists are generated from the crates' objects.
+$(obj)/exports.o: $(obj)/exports_core_generated.h \
+    $(obj)/exports_bindings_generated.h $(obj)/exports_kernel_generated.h \
+    $(if $(CONFIG_RUST_INLINE_HELPERS),,$(obj)/exports_helpers_generated.h)
+
 # Disable symbol versioning for exports.o to avoid conflicts with the actual
 # symbol versions generated from Rust objects.
 $(obj)/exports.o: private skip_gendwarfksyms = 1

-- 
2.55.0

