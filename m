Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD2834E764
	for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 14:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570054; cv=none; b=o4cgSiCzLbRjpEUPVUfIl39oihWS0l+LPB8pAPOrBxKPW1Mqjd6K9Bs5RrHXgGb1oehGbdMalnaiuuSX+Nr1xKJ/TqBXORMBsda3TAnTMoLC6E+XvqhdScDdLx/tHCSWISJ8TQ6lnC/DJlK70GGVNXxtJYKKLwkayeNfIJSaVkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570054; c=relaxed/simple;
	bh=lV61vs9JQIXl38QxVWcMXNAs0mu8Nv86ErgGTYp+mDc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b352MiBKoauYSaI3PxQ8vbBEIvJHl3ac2jSB+v7+bW9gC0W0yQDZ2W6S+KkGX910sQpUlO4mMAvxqmIZ4rxN1XV77EdSi3MTWRdzXHzgylKvEfdvwuPdtB756zGwpgeMT+bddAvVcJM30LuWSlJW/qXHUwZa1mINygaEAbCOJow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MPrS5gAR; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MPrS5gAR"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a9b7c7f405so6013529a12.0
        for <linux-efi@vger.kernel.org>; Wed, 16 Sep 2026 07:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789570051; x=1790174851; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GBPfJ5mOgmXCGpvBT7L71rofeWFO21wBMVUvFZChAjM=;
        b=MPrS5gARbs9tigTMJ8B1plfxWjSvusBNi+4EtWfufNnlbqP7Fa/PaeuP7c8gqC/VAT
         2dYCysljRrS0wmaLYrn86RVZJGiJiSNJkvANz5W+EbazOdUINTHBfGtEPi8VWdKiLlT9
         N9qAiU0iHuwLfohhz3y4GYm7asIi6BH46GtJ3QjErBEy/hPQwdcFKDk/o28jgW92QxZ7
         WZgxj7CTtwmx03F0CK5mO5Fvu+Jxk7+MlJYUIHnM84uPd+XjfrSz6mjcpG4+oOhEh/y/
         aQLiX77N52880HhRlOsfPc1n8bUzjil2lKpF1rr6sNcESeihGWby0EIgkuUawg4zBD0z
         goGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570051; x=1790174851;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GBPfJ5mOgmXCGpvBT7L71rofeWFO21wBMVUvFZChAjM=;
        b=UkGH++36HTsqPvHq07zipZJg6AQKo4rfhAKAWfEzqoDE1VTjiS0nPYG4TApZgTj2Pp
         YxXaLfgRr0t1PelNYkGVR1NQ06TCAxUGBjJKc5nijtNKhlRWxU1gYUnNuiWZc1+WCafW
         tyDiojkqQ2l69w6gOUN5DkSJixkysHVYFF8Us8FIZGfRVLJMSB1pW6fn/I3ju//9L+BY
         eiLGBhpBgXYfOC3dpekakiIoLeixwOwzWqZzLa8nzRUVo7hvJUO1Dum5unruxW48Gb82
         qLHPc0ZGdfJ/KIZbPCQZGEJ5Iczw8qWZOy/Ccq6nLD8jJxwLwCM7IASGe3ctBUuECug6
         lg+g==
X-Gm-Message-State: AFuF++mMyZb0YGZ1PThpvbEqpnEbCfMbMLJ6IcRsCao758VAIRlt3cMz
	uK7OYNWxjNudmZcKLcG19vMuxYbKo8FME67X93ZntHzFfS5ipZk1zvlQpKNkCXYkWXE2Y/HYLND
	GQqq98nFZ9eqGCNsvmOlFDc22yd5W5/RpFPBAo2NEgEEVfHirwzIAzw4scZBx051QshWifREnr3
	GUQBaLHUDj4V53nQCIxmU7hAhdgQ1wUA==
X-Received: from edej18.prod.google.com ([2002:a05:6402:5692:b0:6a7:ee17:5c2b])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:400c:b0:6aa:f0e:a150
 with SMTP id 4fb4d7f45d1cf-6aa2247ca1emr2169373a12.42.1789570050651; Wed, 16
 Sep 2026 07:47:30 -0700 (PDT)
Date: Wed, 16 Sep 2026 16:46:52 +0200
In-Reply-To: <20260916144647.2651379-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260916144647.2651379-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6555; i=ardb@kernel.org;
 h=from:subject; bh=COS4mnBB6kmKQSlmrKytUWBFvUccXJP8C3EuJ+M7AW4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWvV6ru3ri1/k/HqYXoUHyNb19yfay9f6v570m/h2heWR
 7kr5XusO0pZGMS4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBE1rIy/Pep3vfp5jR76+1a
 WwpP2XOvybq2tTD68Mmk8IACztypr/4z/PfqXakXPWG24fv9bzSsvx+9tFfxwtETr7+wGF4PWvV vdRk7AA==
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260916144647.2651379-15-ardb+git@google.com>
Subject: [PATCH v3 4/9] efi/libstub: Use ucs2_string library for UTF-16 to
 UTF-8 conversion
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>
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

Note that this no longer truncates the command line at the first
newline, but there is no evidence that this has ever been needed.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile          |  3 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c | 98 ++++++++------------
 drivers/firmware/efi/libstub/vsprintf.c        | 11 ---
 3 files changed, 39 insertions(+), 73 deletions(-)

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
index f27f2e1f0019..3dc365492301 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -12,6 +12,7 @@
 #include <linux/efi.h>
 #include <linux/kernel.h>
 #include <linux/overflow.h>
+#include <linux/ucs2_string.h>
 #include <asm/efi.h>
 #include <asm/setup.h>
 
@@ -334,81 +335,56 @@ char *efi_convert_cmdline(efi_loaded_image_t *image)
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
+	cmdline_bytes = min(3 * options_chars, COMMAND_LINE_SIZE - 1) + 3;
 
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
+		 * truncated. Work backwards through the buffer to find a safe
+		 * truncation point (i.e., a blank character not inside a
+		 * quoted string).
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
2.55.0.1032.g73a4cd73de-goog

