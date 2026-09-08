Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1F33C2796;
	Tue,  8 Sep 2026 20:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900956; cv=none; b=N0NAnvEZUFBbDv60s+dJbRu7L7E88xZllHbOnZFN0jWsdLsLoQEuch6lceVagj73XD38AhdqJi01Ior8dR4AqDC7dBoAPDXiwSEStPLS4XKaiX/pMwuxhM+YYVokBU5kgoaI1F5NbHWfSy0oeDIUFIrgIJhDFd/G1CyPN1gj7bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900956; c=relaxed/simple;
	bh=pcsijpekNt+DxklwcjLik4aRG5CCfOXcviThDorMTJE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lX0Qpb80WnL143UwfEBNIgRqvPGT4OIv5sZLh1FdWk8EXbn1S1x/uoGk+dyznGddHHjNMqA31KCeW+f/lYHMkS/aZEXTPDojW0iywYivgJ9KdOUAraKaU1W4Vetvfd3LvrelbAUVjsNnjzdSCk3j/mgt/tu06/DvanediM26EKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QyylYyUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QyylYyUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769721F00A3A;
	Tue,  8 Sep 2026 20:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900955;
	bh=Y87Ru0xfYAGxRwASt8W2uZE0vluulQEq4vWCkr2qehk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QyylYyUh712yA+wXv0MkQw/+SKQgxmL401+ubHQJwu+ZIzBE8vWqhj+V4R6TMaiHM
	 Y60hJq5rQ3/d9d5CNityd7xig6O+4487SsyyzAbI5j9JWEqg1fBPN4mW7Y0xf3E57W
	 oEGnEeBaKJnD4+eeJylQ06J8g6mUkNnGrMBWzpyf+bPrZStFN+yY63wBlvPS6YeupJ
	 SmNBcrI1XpyFQx9QaXKXWXDETpxFWmsyd/pCLcfeZuXv9msSqXrxIyTaDgz7ecm0jm
	 QsJMlDs7cKdvveUp91Za2I0LitMt5Y1sCLbcdrH1DKRVcK09/RvD8ADXffWwOfymjH
	 IyU9PE5QiiKvw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:55:02 +0100
Subject: [PATCH 02/23] scripts/mksysmap: fix escape of '$' in the __pi_
 pattern
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-build-speedup-v1-2-5dc1ac01672d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1197; i=ljs@kernel.org;
 h=from:subject:message-id; bh=pcsijpekNt+DxklwcjLik4aRG5CCfOXcviThDorMTJE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWlJker97TJDyrb4PQ+6XPvAN8LNze3ZELTohu0v29J
 yLUj39BRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZy/i0jw08mn4fvXq4u+Fa8
 i/Fq9u+vctwXl2RL3vaT5v0085vVum2MDK9+Kl4Xyq24lPJZ8b3/vJj9veGOjkp52yRuKrG/+/v
 8BhsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Commit b18b047002b7 ("kbuild: change scripts/mksysmap into sed script")
converted scripts/mksysmap from a shell script to a sed script.

However an error was made - escaping of '$' required \\ escaping in shell
but only \ in a sed script.

This was mostly corrected in commit 7a6c355b55c0 ("scripts/mksysmap: Fix
escape chars '$'"), but this fix missed arm64 PIE namespace local symbols
like __pi_$x and __pi_$d which appear in System.mapand /proc/kallsyms:

$ grep __pi_\\$ /proc/kallsyms | sort -u
0000000000000000 d __pi_$d
0000000000000000 t __pi_$x

Fix the escaping properly.

Fixes: b18b047002b7 ("kbuild: change scripts/mksysmap into sed script")

No measurable change in build time.

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 scripts/mksysmap | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mksysmap b/scripts/mksysmap
index 56a8b8bbdb37..856b26ba2ac0 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -35,7 +35,7 @@
 / __efistub_/d
 
 # arm64 local symbols in PIE namespace
-/ __pi_\\$/d
+/ __pi_\$/d
 / __pi_\.L/d
 
 # arm64 local symbols in non-VHE KVM namespace

-- 
2.55.0

