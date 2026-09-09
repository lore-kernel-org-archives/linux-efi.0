Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E5254EEC5
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 11:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954966; cv=none; b=XwefOSNFf+BdyLe5KAoMDe3u/F8DJ14H7xhwut1gqj0aZbeuFOHlJIUjxI6jpYX/972FpTeuWSE2+0OHOLRNY5OKOlIfHN00AWKiz8z5+IuIzraG45N19YGxLsAPa/QxDggBVhmfH29Mdw4aMmiuwwAULLozC0MPfUAz3nBinBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954966; c=relaxed/simple;
	bh=ku20SOigH8CJ8SYKLPGcw9FWogCbCHali0pAF7pIo/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vob/xb0HmGGf3Ynk2yY47M6R4CKqD3j+V58M2ppT1e1uOT0Vrt9kRvLN6+a/JRtPulo6fLH0Ufea31JKjwU0G+IUof0iEUeKYr8Sj+Bh8/sRoAxOFY947LCg/Cugiu7J+U4aQo96S4tGxjazTSUjxO/H8EMGcnmSRdnehg6raUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xb0iYXJA; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xb0iYXJA"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49cf5bd2f12so76707975e9.1
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 04:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788954961; x=1789559761; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5sXaakZK3FdjYjcilMqr9ZDO21ZR7yjsXqS533qtI9o=;
        b=Xb0iYXJARnEJ7HWqHHH+ipsAY67B4Ls/3RYgkGowGlG12VLtWNOw9ziSTYCQ1NvABh
         Qzm+rGPN8Ej4T0PTb/pSOgmNHjrzRHobW/4Oc75oXGtbXdlyFT5R7/VpgiDp8TBQnOyy
         lfrpFIWvd93SpuQx1OTOsMxwg3X9RdLI9BThyXpz+PTe+hatLxzI3oP8SIp6OzNXIjln
         cWgXy6XUf/0YxSPEhucj6fH3F65hMc7GGcap49ySivwjR+hav2MvDHH8U6dFsgsKg1cO
         xpcsfTDCRaE/cC89/4LxLExBb59SCu0WMUH6icvXhoSSx9KKv/4mYuur3SJeo3qihrFa
         FFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788954961; x=1789559761;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5sXaakZK3FdjYjcilMqr9ZDO21ZR7yjsXqS533qtI9o=;
        b=sfo77wkoYIZSOCoXZGxHs24MMJAD7525ww63b9iEphzWO8t+/lHHwfCImcAU0/QgXx
         uB6IxNJCamT4SbNTA5O62aKXjWh71+rlbJTJTAq1P6qEKJ/Wh91FyUxYn44jGkFs8uYb
         G0W5PEOLTdXpAiB3aQZStTqZVDxM3kfVezmlAOK5r8KfohZKLLz8KevY3jBmBqEKP/Uh
         9YRY3hrpuOSiZwXQi4wi5odu4jtr95AmlIJMLTnYhZnUghhoK0ZCx0wmrJ3mT9eLOPy+
         yKFHmpSqy5B+rc8/a2G9qNmNifXK6/QEGEXstNjXlI/gup35jRNVpZosr5x9nS+g5+Hj
         5FAg==
X-Gm-Message-State: AFuF++mjEOIyrGDXBvOsQT5oAne2pjLpSYGmcGt5JZKz1JK6ueE4Eiay
	/0BdIEFgdgjQQr3OxerD9KmR5/EuLw3QvaOolt8/PdUv2649YHhSWbSQ8iZHvTX1hlOlCgaGpSf
	MlHzrVHNFxLMX8u6R9CnrIfwF2i3gLf8KR5E42IQwyVLhN678o0EsPEFJHCNit3AxTjbvHNpzQC
	d5kjoTBigiVLkv5hoETfmrfmaDLDs3sg==
X-Received: from wmoy23.prod.google.com ([2002:a05:600c:17d7:b0:49c:e6be:fb62])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:310e:b0:49c:fa21:1c84
 with SMTP id 5b1f17b1804b1-49cfa211ce7mr321466165e9.25.1788954960859; Wed, 09
 Sep 2026 04:56:00 -0700 (PDT)
Date: Wed,  9 Sep 2026 13:55:36 +0200
In-Reply-To: <20260909115530.1924665-12-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260909115530.1924665-12-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6503; i=ardb@kernel.org;
 h=from:subject; bh=gKNtPYPXH1wWBdst62Gf5YPrCrwaAq8jBD0FshjFfRc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuhp0VTtr6k0wK3FN6lU6v2HnJv+Jn/nKPoiezW/2uUZ
 asW3e/vKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABP5t5Xhn6HTsxaDWKMtD3Yf
 uzVLwpo1tHPJAa71nVU7dqdlfLD5ksnwP1W0N95y+7u5h+Sb/kZMSnxxLCyIr/ZijYWk+KTNItk i3AA=
X-Mailer: git-send-email 2.55.0.1003.g10538fe699-goog
Message-ID: <20260909115530.1924665-17-ardb+git@google.com>
Subject: [PATCH v2 05/10] efi/libstub: Use ucs2_string library for UTF-16 to
 UTF-8 conversion
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Don't rely on sprintf() with a wide string conversion modifier to
convert the command line from UTF-16 to UTF-8. Instead, use the
existing ucs2 string library routine that does the same. Note that while
UEFI claims support for UTF-16, in practice it ignores surrogate pairs
entirely, and so the simplified UCS-2 character set (where each
character takes up exactly 2 bytes) is sufficient here.

This removes the only user of sprintf() in the EFI stub, so drop that
function as well.

Since boot memory is plentiful on UEFI systems, just establish a worst
case upper bound for the size of the buffer (which can never exceed
COMMAND_LINE_SIZE), and allocate that first. Then, perform the
conversion, and only fall back to processing the command line character
by character if that resulted in truncation. This makes the common
execution path much simpler.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile          |   3 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c | 100 ++++++++------------
 drivers/firmware/efi/libstub/vsprintf.c        |  11 ---
 3 files changed, 41 insertions(+), 73 deletions(-)

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
index f27f2e1f0019..4b51a0bf0e66 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -12,6 +12,7 @@
 #include <linux/efi.h>
 #include <linux/kernel.h>
 #include <linux/overflow.h>
+#include <linux/ucs2_string.h>
 #include <asm/efi.h>
 #include <asm/setup.h>
 
@@ -334,81 +335,58 @@ char *efi_convert_cmdline(efi_loaded_image_t *image)
 {
 	const efi_char16_t *options = efi_table_attr(image, load_options);
 	u32 options_size = efi_table_attr(image, load_options_size);
-	int options_bytes = 0, safe_options_bytes = 0;  /* UTF-8 bytes */
-	unsigned long cmdline_addr = 0;
-	const efi_char16_t *s2;
-	bool in_quote = false;
+	unsigned long options_chars = 0;
+	unsigned long cmdline_bytes;
 	efi_status_t status;
-	u32 options_chars;
+	char *cmdline_addr;
 
 	if (options_size > 0)
 		efi_measure_tagged_event((unsigned long)options, options_size,
 					 EFISTUB_EVT_LOAD_OPTIONS);
 
 	efi_apply_loadoptions_quirk((const void **)&options, &options_size);
-	options_chars = options_size / sizeof(efi_char16_t);
-
-	if (options) {
-		s2 = options;
-		while (options_bytes < COMMAND_LINE_SIZE && options_chars--) {
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
-		}
-		if (options_bytes >= COMMAND_LINE_SIZE) {
-			options_bytes = safe_options_bytes;
-			efi_err("Command line is too long: truncated to %d bytes\n",
-				options_bytes);
-		}
-	}
+	if (options)
+		options_chars = ucs2_strnlen(options,
+					     options_size / sizeof(efi_char16_t));
 
-	options_bytes++;	/* NUL termination */
+	/* Each UCS-2 char takes up at most 3 UTF-8 bytes */
+	cmdline_bytes = min(3 * options_chars, COMMAND_LINE_SIZE - 1) + 1;
 
-	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, options_bytes,
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, cmdline_bytes,
 			     (void **)&cmdline_addr);
 	if (status != EFI_SUCCESS)
 		return NULL;
 
-	snprintf((char *)cmdline_addr, options_bytes, "%.*ls",
-		 options_bytes - 1, options);
+	if (ucs2_as_utf8_l(cmdline_addr, options, options_chars,
+			   cmdline_bytes) >= COMMAND_LINE_SIZE) {
+		/*
+		 * The output fills up the entire buffer, and may have been
+		 * truncated. This can only happen when options_bytes equals
+		 * COMMAND_LINE_SIZE.
+		 *
+		 * Work backwards through the buffer to find a safe truncation
+		 * point (i.e., a blank character not inside a quoted string).
+		 */
+		int safe_pos[2] = {};
+		int in_quote = 0;
+
+		for (int i = COMMAND_LINE_SIZE - 1; i >= 0; i--) {
+			char c = cmdline_addr[i];
+
+			if (!c)
+				return cmdline_addr;
+			else if (c == '"')
+				in_quote ^= 1;
+			else if (!safe_pos[in_quote] && isspace(c))
+				safe_pos[in_quote] = i;
+		}
+
+		efi_err("Command line is too long: truncated to %d bytes\n",
+			safe_pos[in_quote]);
+		cmdline_addr[safe_pos[in_quote]] = '\0';
+	}
 
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
2.55.0.1003.g10538fe699-goog

