Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD793E1CFD;
	Wed, 23 Sep 2026 17:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183957; cv=none; b=LW+dYAd+DbX4TiTr7Do3lI61QIKY26j7+INp3Qo891CdeFSlxxJw5LnHPMmjaLxd5f4wzkkQ9GsPfyeBpiVOL+uyMeT3swKluT0Rn+mw1B2s56ZP2bMHnHrkyCrmy1e4HqzcYXQn7IvTsBjfM6CIiETGKNWxl7YfQ6jf5E5Bmg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183957; c=relaxed/simple;
	bh=wNUVaWGrUfq1J8fZ3VtZkSo4KZCUQiuLpouzmc9mPms=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NtYPu0shXWlKb5BRc/mbLw/oekTakoG6uhQDJsJkOuPFVXdl1g20LV7wE+87maX1pfdsMukG30BE7h8YquoVU3j1oaLP/2w1uSqu1g2j0U1Y2iktJjPpY8g5ax25gAIp5XeQqu+wn9TBx/mMMhcNuKwemobDTM/glvmQemMPZgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajlS9Rgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajlS9Rgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533291F000FF;
	Wed, 23 Sep 2026 17:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790183956;
	bh=EwUTC03iMe3mqDQCwXS0ElhwJ195RFfSMSvYZMg9K5c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ajlS9RgcgJmPHoodht9q1Tjuf5/xG6VV5yZ0cMtOxjKRN40NqZx25yf2S1S46TbTx
	 oxL+FAeAVUQPgrWhhpeL06lXnXe1S/qond5RIz1HEwTOZuD5t9JqOgfg7JjcHEBVaT
	 i9JEHZPLF466KVBqI6pEXknFBlyCthgTa1D6vtH8CjUGlNJYO5+ocBLw+G2PJstRaB
	 v2GnA5/E6Mwqt/ORFNEIVMJzqBncb9oR+8w5WNLjj+Qy/uoYYXVFFuSngalJiiZ39Y
	 26VOG4Fme44YuFKGl0jBz7vhNF4xbEu+vi+CFEZafSkhxd7KffQAzwp1GJZfn05/hq
	 OZqSvZaZeGShQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 23 Sep 2026 18:17:53 +0100
Subject: [PATCH v4 04/22] sorttable: parse nm output correctly
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260923-build-speedup-v4-4-73128809a4a4@kernel.org>
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
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2694; i=ljs@kernel.org;
 h=from:subject:message-id; bh=wNUVaWGrUfq1J8fZ3VtZkSo4KZCUQiuLpouzmc9mPms=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2cF7yMz8as2ltfPXBEIaTk5edNbUrLlkulXbQrz9Mn
 6O992lyRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZyew4jw6bmxf1ON1g32D6L
 KxSzr41NTJnFaaTQn2nM7rPySN3BTwz/s180n1zKz7WxfIvY/3ueffm+MzeY/j/64e4/i7m3ck/
 z8gMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

sorttable reads a list of functions from vmlinux, provided by the output of
nm, with the -S flag specified providing function sizes.

It does so using fscanf(fp, "%16s %16s %c %*s\n", ...) reading address,
size, type (a single character) and name.

However, nm outputs no size for a symbol which has none, meaning that it
misinterprets these entries - interpreting the type character as the size,
and, if the name is a single character, ignores the newline and swallows
the address of the next entry.

Size-less single character names exist (e.g. the assemblers' loop counters
left over as local absolute symbols):

      0000000000000001 a i
      000000000000000f a i
      0000000000000050 a j
      0000000000000052 a t
      000000000000009f a i
      0000000000000200 a i

sorttable is looking for functions and these are not that, and with nm's
output sorted, it just so happens to be that what's swallowed is never a
function.

However the next commit in this series stops sorting nm's output, so this
bug can results in function names being lost.

Fix the issue by using '%*[^\n]' in fscanf() rather than '%*s' such that
the scan cannot move past the newline.

Then, compare the address and size fields (which are always padded to the
same width if output by nm) - if they differ, then this is a misread, so
simply discard the entry.

It's fine to discard these, as sorttable's raison d'être is to discover
whether a call site is contained within a function and an empty function
can't contain anything.

Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 scripts/sorttable.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/scripts/sorttable.c b/scripts/sorttable.c
index d7b50581c732..88e49a5c4251 100644
--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -322,10 +322,23 @@ static int parse_symbols(const char *fname)
 		return -1;
 	}
 
-	while (fscanf(fp, "%16s %16s %c %*s\n", addr_str, size_str, &type) == 3) {
+	while (fscanf(fp, "%16s %16s %c%*[^\n]", addr_str, size_str, &type) == 3) {
 		uint64_t addr;
 		uint64_t size;
 
+		/*
+		 * nm outputs size-less entries with a missing 2nd value, which
+		 * means fscanf() just misread its fields.
+		 *
+		 * These don't matter as a call site cannot be in an empty
+		 * function, so just skip them.
+		 *
+		 * nm pads address and size to the same width, so if their
+		 * widths differ, this is a misread.
+		 */
+		if (strlen(size_str) != strlen(addr_str))
+			continue;
+
 		/* Only care about functions */
 		if (type != 't' && type != 'T' && type != 'W')
 			continue;

-- 
2.55.0

