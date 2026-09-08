Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3F53C4B6F;
	Tue,  8 Sep 2026 20:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900945; cv=none; b=uFsZYp40YuS2eB8cBPlaV5a14LOSvu1YAvvmuDHV5cs/POgdbBkfQTD67PcOXlipeaKYhIW6T5Ryc4LveJU1J/FtY8puHpCKv6ni2/HClE0FRlePppyG+CGE1++Lzb9K8SrbcNl9FKlyVuic0+exgdmMlIFh4IYxpJuH9fCL6SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900945; c=relaxed/simple;
	bh=QfW8/LMHKqPTf4R2pTPKjpcy4p10+jQ9pbl+SDhevC4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SuSvD+pht///GAQ/0rJLepjfAjsTF/xcW0cGpgcuBHx/n+YLeo0uH1rXN4fq2ZNYaQEnZgofd2wUHddz4KDV7iRjPYdblJX79ZsnV9Dp6ymBJNAjlCHIxzOzsw0ol5XaJZ1q9iZhzN3hkd7N4XXTcDQGcDsmJplBUwtEqn0tJ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gcuaImta; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gcuaImta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4539B1F00A3E;
	Tue,  8 Sep 2026 20:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900944;
	bh=7lHsIzzOaaem51+m++n0/DPnuKeNqmOjNP5os70+l/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gcuaImtaBdcvz4CtAgmXpjnv01updFVNTW9WrGABIcDEyojIPAOsJCbV00b87f+1y
	 j731oQYOWTNlFnkqkt4tAP7FENM+Jea0i9yZwJaTmXdW4Jnebjt6KILmgBa79eY7Wb
	 AYs0eoObe/OL3BO+4fv9qd775cOTxEm5cp7yekzIPAI6KSrFnuz9NBnVXpV9zj2V7f
	 IxYOAu6NkUYoPI/Su0ZN1y6dBZDYb8K6R2cVZnwazlJ5a7h1EgyXBF2Q3hxPxb6sWD
	 wDsVU9oltHTEIhNu+HRTNsz3Q5/Xmefqdlc2ZWGg0p6j/GsT1cQpBmQl1uwshl0ooA
	 mWpYEDYCsfnPw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:55:01 +0100
Subject: [PATCH 01/23] scripts/mksysmap: drop the MODULE_INFO() symbols
 from kallsyms
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-build-speedup-v1-1-5dc1ac01672d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1471; i=ljs@kernel.org;
 h=from:subject:message-id; bh=QfW8/LMHKqPTf4R2pTPKjpcy4p10+jQ9pbl+SDhevC4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWlJk+2pIZFHpy309v2WveEjvYda2cs/aYH+TcLjFzs
 8mmvJAJHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhI9RZGhtbpq42+L52/y/bk
 hEeZ91+buM15GnnuZeJ1nbfC50OLN3xkZGh/cZ31aezHKXeSZ0/wqbOcIHrcomFdBee8DKOAmNU
 3T3IDAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Commit 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
keeps .modinfo symbols out of System.map and kallsyms, which assumes unique
IDs have a format like '__UNIQUE_ID_modinfo123'.

However, commit afb026b6d35c ("compiler: Tweak __UNIQUE_ID() naming"), sent
in the same cycle, changes this to '__UNIQUE_ID_modinfo_123'.

As a result this regexp has never matched and every kernel since v6.18 has
carried one kallsyms entries for every MODULE_INFO() declaration in the
kernel whether the modules are compiled or not.

That's 5,810 entries for an x86 defconfig build and 15,200 for arm64.

On x86 defconfig that is 113 KiB of kallsyms tables and 32 KiB of bzImage,
and every lookup walks past them.

Fix the pattern.

Fixes: 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")

No measurable change in build time, the smaller tables are not on any path
the build waits for.

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 scripts/mksysmap | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mksysmap b/scripts/mksysmap
index c4531eacde20..56a8b8bbdb37 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -83,7 +83,7 @@
 / _SDA2_BASE_$/d
 
 # MODULE_INFO()
-/ __UNIQUE_ID_modinfo[0-9]*$/d
+/ __UNIQUE_ID_modinfo_[0-9]*$/d
 
 # ---------------------------------------------------------------------------
 # Ignored patterns

-- 
2.55.0

