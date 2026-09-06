Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EA43CF209;
	Sun,  6 Sep 2026 13:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788700124; cv=none; b=d2XiyllTAy2aQaVD8g3xFu+uuNNAiioK8u+v/a+oeDh52k7PMGJz2T4+BUR/OVAjzoluuz6vA1WLAjDWQIqEywtSPZRxUUhzE8A/U/hPHAmTUYFnYb/2EhirovH1HxEM84KbbYQByYnrHKKYYTD6KMHTG68bJVtlOp0WtWP0yjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788700124; c=relaxed/simple;
	bh=45M/Hsc6CXuQzJCiLuWB++v23YCdS474I4sUrpQUDiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SafPdfgr+j04OS42fL2uF3QBFfzXyPiTakBaKeYmN149Vvlq6gUMh+tJjBZD8MZak5tKCt9tCe4LlSUhOlehBuW2JmECT14CP3tOpIacG5DKIo3+urkT9GOqHz1tk9Ju/6V13H1YQWgnTiYOtbckausd25O1FCROHS0WWeaXrSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msVQ5AH1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msVQ5AH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BA91F00A3A;
	Sun,  6 Sep 2026 13:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788700122;
	bh=yo2CnbwEpgDJetynsarnjAiwnB2/EA1CTVqiPjFuZs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msVQ5AH1vD4ykGh7fQO0VohKo8n8GMPzHp7RFJYe858kC8IJPo/IyseEODyu3wI1w
	 46w0e43npcW1J8Zfv6W8zp0pIlRaz1NXNT/t4aZrDSYFk7Dbeu//euMhrjZSEBaDwe
	 bCOd7UOxXc/YcWoPwb/s35d+OxIbIUrOsTsT794lLfeWjLO+yc0tagMZFTwtKJ2S8X
	 wA1C/kraLdCewr9McvFQtMKQ3OJpw4d8PUkUEHmuTrHwSCM0+u0gzuXLj7L+Hevc6y
	 3jGxuQiiwhSrX0uWQeeOEiLUp+i3RwSIKNcKqQZzAUHZks39uldGf6XTOfKyoLgr+I
	 o5RCieT/E3gQA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Vincent Mailhol <mailhol@kernel.org>,
	x86@kernel.org
Subject: [PATCH 3/7] efi/libstub: Use ucs2_string library for UTF-16 to UTF-8 conversion
Date: Sun,  6 Sep 2026 15:08:21 +0200
Message-ID: <20260906130817.1151961-12-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906130817.1151961-9-ardb@kernel.org>
References: <20260906130817.1151961-9-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4985; i=ardb@kernel.org; h=from:subject; bh=45M/Hsc6CXuQzJCiLuWB++v23YCdS474I4sUrpQUDiY=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWtu6omG/H23Bf9nBu6Q4kvjOWQp8XDxd+6qBUxp56ysD nq856rrKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABMR4GFk+H33/wKtnus3A77P 0tW9qnpii4sI682Jt/fNMV79zEi5bCXD/yh7pf+ZHDah+QIvg9Z9PNFotNf3Cl/l69a2SVzvTBR 4WQA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Don't rely on sprintf() with a wide string conversion modifier to
convert the command line from UTF-16 to UTF-8. Instead, use the
existing ucs2 string library routine that does the same. Note that while
UEFI claims support for UTF-16, in practice it ignores surrogate pairs
entirely, and so the simplified UCS-2 character set (where each
character takes up exactly 2 bytes) is sufficient here.

This removes the only user of sprintf() in the EFI stub, so drop that
function as well.

While at it, make cmdline_addr a char* and remove the pointless casts.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile          |  3 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c | 59 ++++++--------------
 drivers/firmware/efi/libstub/vsprintf.c        | 11 ----
 3 files changed, 18 insertions(+), 55 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 77a2b2d74f3f..12c0c7deb5cb 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -66,7 +66,8 @@ KBUILD_AFLAGS			:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 lib-y				:= efi-stub-helper.o gop.o secureboot.o tpm.o \
 				   file.o mem.o random.o randomalloc.o pci.o \
 				   skip_spaces.o lib-cmdline.o lib-ctype.o \
-				   alignedmem.o printk.o vsprintf.o
+				   alignedmem.o printk.o vsprintf.o \
+				   lib-ucs2_string.o
 
 # include the stub's libfdt dependencies from lib/ when needed
 libfdt-deps			:= fdt_rw.c fdt_ro.c fdt_wip.c fdt.c \
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index f27f2e1f0019..c221d67bfff6 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -12,6 +12,7 @@
 #include <linux/efi.h>
 #include <linux/kernel.h>
 #include <linux/overflow.h>
+#include <linux/ucs2_string.h>
 #include <asm/efi.h>
 #include <asm/setup.h>
 
@@ -335,10 +336,10 @@ char *efi_convert_cmdline(efi_loaded_image_t *image)
 	const efi_char16_t *options = efi_table_attr(image, load_options);
 	u32 options_size = efi_table_attr(image, load_options_size);
 	int options_bytes = 0, safe_options_bytes = 0;  /* UTF-8 bytes */
-	unsigned long cmdline_addr = 0;
 	const efi_char16_t *s2;
 	bool in_quote = false;
 	efi_status_t status;
+	char *cmdline_addr;
 	u32 options_chars;
 
 	if (options_size > 0)
@@ -351,45 +352,18 @@ char *efi_convert_cmdline(efi_loaded_image_t *image)
 	if (options) {
 		s2 = options;
 		while (options_bytes < COMMAND_LINE_SIZE && options_chars--) {
-			efi_char16_t c = *s2++;
-
-			if (c < 0x80) {
-				if (c == L'\0' || c == L'\n')
-					break;
-				if (c == L'"')
-					in_quote = !in_quote;
-				else if (!in_quote && isspace((char)c))
-					safe_options_bytes = options_bytes;
-
-				options_bytes++;
-				continue;
-			}
-
-			/*
-			 * Get the number of UTF-8 bytes corresponding to a
-			 * UTF-16 character.
-			 * The first part handles everything in the BMP.
-			 */
-			options_bytes += 2 + (c >= 0x800);
-			/*
-			 * Add one more byte for valid surrogate pairs. Invalid
-			 * surrogates will be replaced with 0xfffd and take up
-			 * only 3 bytes.
-			 */
-			if ((c & 0xfc00) == 0xd800) {
-				/*
-				 * If the very last word is a high surrogate,
-				 * we must ignore it since we can't access the
-				 * low surrogate.
-				 */
-				if (!options_chars) {
-					options_bytes -= 3;
-				} else if ((*s2 & 0xfc00) == 0xdc00) {
-					options_bytes++;
-					options_chars--;
-					s2++;
-				}
-			}
+			efi_char16_t c[2] = { *s2++, L'\0' };
+
+			if (c[0] == L'\0' || c[0] == L'\n')
+				break;
+
+			// Check whether the current position is a safe
+			// truncation point
+			in_quote ^= (c[0] == L'"');
+			if (!in_quote && isspace((char)c[0]))
+				safe_options_bytes = options_bytes;
+
+			options_bytes += ucs2_utf8size(c);
 		}
 		if (options_bytes >= COMMAND_LINE_SIZE) {
 			options_bytes = safe_options_bytes;
@@ -405,10 +379,9 @@ char *efi_convert_cmdline(efi_loaded_image_t *image)
 	if (status != EFI_SUCCESS)
 		return NULL;
 
-	snprintf((char *)cmdline_addr, options_bytes, "%.*ls",
-		 options_bytes - 1, options);
+	ucs2_as_utf8(cmdline_addr, options, options_bytes);
 
-	return (char *)cmdline_addr;
+	return cmdline_addr;
 }
 
 /**
diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
index 71c71c222346..dba136679172 100644
--- a/drivers/firmware/efi/libstub/vsprintf.c
+++ b/drivers/firmware/efi/libstub/vsprintf.c
@@ -551,14 +551,3 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
 
 	return pos;
 }
-
-int snprintf(char *buf, size_t size, const char *fmt, ...)
-{
-	va_list args;
-	int i;
-
-	va_start(args, fmt);
-	i = vsnprintf(buf, size, fmt, args);
-	va_end(args);
-	return i;
-}
-- 
2.47.3

