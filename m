Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFDD54936D
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 11:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954967; cv=none; b=DU8cKkEra8yvaQRhMMpwKQ6T3fc+S1b3sVOiaGTXyRl972gdbNlRnv4y3lMNM0y2DpeeScJ0YE0B5N+iVPvDMrODbKPPQ6T6KYeYnzQr9a3NvCpfZaUpYJZfPgMQrCNkpT1zglyJc35Y+7Tsh78kPwvnw6w6tOnXmP6e7r0wPNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954967; c=relaxed/simple;
	bh=Zwt0YiBEDCQK+Cormq85j9ZdjD4ex4uFhJdiF7GkcRo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fJvibWSDeUNdAg+fTmaA0yWluDSvsUFLdSTc/5F/NOATYKbCJ23aYc8Y/DCf+iL7FNvsLd771MnopvheygLyQcoz2jV3AcHqZ+uo5P/Jt0o3rtURK/i4jQCY5Gubt06qBNxguHUrVyDPOAmewmUoOzNmp2thburclzKhTUdv8DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=saGDrZBO; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="saGDrZBO"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49b7c1dcc82so36116435e9.0
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 04:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788954963; x=1789559763; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bSy3jB3blwxo3cqUryQeWVid+UYsufcubecd2NTDsjQ=;
        b=saGDrZBOKRzFfQqaDYSe5aceYEzMGQPICH+HEnqGggTBc1p1RywkHIpz3G2vwtrnRw
         oLDaQau8EIs83/1p1dbwEX7nhCalsX1Te0r8Ria6XHo6P+tqEqyBWY28hk09Y920CQ0W
         L+jAD4r8hTnjJrFQVKLrf2i08kAfNgrugqNgIPkYN0UupwsEV8HKHxw8csSkLL6YwaA6
         v45g55ndGHTj1Xg3/SI0M7TtwSu8O3VwX1b8OHCCHN6espo9wF/SMWgVMDFtrAR4yBIi
         NDmy9azITPNgVXks5B9aUwr7sAwhgJ/47Faj3cMgRjKjBtGewQuiXPncBSwpLt/1EFxm
         iBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788954963; x=1789559763;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bSy3jB3blwxo3cqUryQeWVid+UYsufcubecd2NTDsjQ=;
        b=VciS7aXhwfNYGxDKCAZ5ut0+JQsQ738ZEOM+jklPhLB1nUKeo1CHd8JV3yBPewWBKS
         vZGgc58XouQCgJZSahCA1RjWH8fBXzSyhol4n1IW9/SidmDeuC6Alfztr+USmVjeGFIM
         hnqHfBFz00tHxa1dJKuF1P1Yoxr6WJnLuOtYTdKoqZ2HmDsCzI37G5k66XEXn/N0qOf+
         eUMg3dNZNUWEv7abSacgZr2y4sHzDXs2x39lu38nlqdtlDsQpodbyGbycAUjCM7inq8v
         kVZdMctMx1bXx4f+QqPHf/J0/9oy3mH4qI6oy4sFV/AtdFIT/ERTAW3bmcIWAhhE5WeS
         TKZQ==
X-Gm-Message-State: AFuF++mdsgnTdt5R8xLLXCyUgk3F4JRGI1rmTZ0t92hrvw3OBmc4XDN5
	9E5xCCxDs+8xRoaF/U7ei7K+OOIM7E88W+cJT4bp+eyXMnWcmbA4qmOZF2sWzFowmbwNy5xaCJx
	80KMYX8dp+4NeAsbY84PTcboIrOzOtrbJenoSl07/Z3kkhdl08VDFUZdlmL44q34ubbufwimQw5
	EbXhHlkSx//ik2iUNs2qBdfXeGtvRs9Q==
X-Received: from wmbf17.prod.google.com ([2002:a05:600c:5951:b0:49d:23ae:8429])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:698c:b0:49c:fc6e:a3df
 with SMTP id 5b1f17b1804b1-49cfc6ea7camr340114115e9.30.1788954963023; Wed, 09
 Sep 2026 04:56:03 -0700 (PDT)
Date: Wed,  9 Sep 2026 13:55:38 +0200
In-Reply-To: <20260909115530.1924665-12-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260909115530.1924665-12-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=9530; i=ardb@kernel.org;
 h=from:subject; bh=PJF6hAVvzPDzaVpBjuHCyEhWK6Oza3jt1IYjY2Y611s=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIWuhp3Xr6ypumzZGg9IZMc+fyPz2P+3d/yDiygW5xvU1Y
 nVMDj4dpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCJ6oYwMT2LX3M03azwV1igW
 sfjKpYuxzwy6F5h1lG62O3Yrql5jEiPDH++t4qorNiy6+crZzklRwll/V0C96r8LWjaWsyVaYza wAQA=
X-Mailer: git-send-email 2.55.0.1003.g10538fe699-goog
Message-ID: <20260909115530.1924665-19-ardb+git@google.com>
Subject: [PATCH v2 07/10] efi/libstub: Output UTF-16 directly from vsnprintf()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Vincent Mailhol <mailhol@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The only remaining users of vsnprintf() in the EFI stub are the
diagnostic printk()'s, which are emitted to the console and not recorded
for posterity.

The EFI console uses UTF-16 (or actually, UCS-2) natively, and so all
non-UTF16 strings that are emitted need to be converted. Given the
stub's vsnprintf() support for wide strings (using the %ls conversion
modifier), which uses UTF-16 to UTF-8 conversion internally, the final
conversion to UTF-16 needs to support not just plain ASCII but UTF-8 as
well.

This is all pointless, of course, and it makes more sense to use UTF-16
internally. This removes the need for UTF-16 to UTF-8 conversion in
vsnprintf(), and given that all non-wide string inputs to vsnprintf()
that exist in the stub today are compile time constant ASCII strings,
the need to convert UTF-8 to UTF-16 disappears as well.

So implement efi_vsnprintf() taking a const char *fmt as before, but
outputting a efi_char16_t[] that can be passed to the EFI console
directly, rather than via efi_puts(), leaving the latter unused and
therefore removed.

Note that efi_puts() performs LF to CR-LF conversion internally, so add
this capability to efi_vsnprintf() as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efistub.h  |  5 +-
 drivers/firmware/efi/libstub/printk.c   | 91 ++-----------------
 drivers/firmware/efi/libstub/vsprintf.c | 96 +++-----------------
 3 files changed, 22 insertions(+), 170 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec81..36056c624782 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1078,9 +1078,10 @@ efi_status_t check_platform_features(void);
 
 void *get_efi_config_table(efi_guid_t guid);
 
-/* NOTE: These functions do not print a trailing newline after the string */
 void efi_char16_puts(efi_char16_t *);
-void efi_puts(const char *str);
+
+int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
+		  bool crlf);
 
 __printf(1, 2) int efi_printk(char const *fmt, ...);
 
diff --git a/drivers/firmware/efi/libstub/printk.c b/drivers/firmware/efi/libstub/printk.c
index f36639886d00..0a18cfe32528 100644
--- a/drivers/firmware/efi/libstub/printk.c
+++ b/drivers/firmware/efi/libstub/printk.c
@@ -23,98 +23,20 @@ void efi_char16_puts(efi_char16_t *str)
 		       output_string, str);
 }
 
-static
-u32 utf8_to_utf32(const u8 **s8)
-{
-	u32 c32;
-	u8 c0, cx;
-	size_t clen, i;
-
-	c0 = cx = *(*s8)++;
-	/*
-	 * The position of the most-significant 0 bit gives us the length of
-	 * a multi-octet encoding.
-	 */
-	for (clen = 0; cx & 0x80; ++clen)
-		cx <<= 1;
-	/*
-	 * If the 0 bit is in position 8, this is a valid single-octet
-	 * encoding. If the 0 bit is in position 7 or positions 1-3, the
-	 * encoding is invalid.
-	 * In either case, we just return the first octet.
-	 */
-	if (clen < 2 || clen > 4)
-		return c0;
-	/* Get the bits from the first octet. */
-	c32 = cx >> clen--;
-	for (i = 0; i < clen; ++i) {
-		/* Trailing octets must have 10 in most significant bits. */
-		cx = (*s8)[i] ^ 0x80;
-		if (cx & 0xc0)
-			return c0;
-		c32 = (c32 << 6) | cx;
-	}
-	/*
-	 * Check for validity:
-	 * - The character must be in the Unicode range.
-	 * - It must not be a surrogate.
-	 * - It must be encoded using the correct number of octets.
-	 */
-	if (c32 > 0x10ffff ||
-	    (c32 & 0xf800) == 0xd800 ||
-	    clen != (c32 >= 0x80) + (c32 >= 0x800) + (c32 >= 0x10000))
-		return c0;
-	*s8 += clen;
-	return c32;
-}
-
-/**
- * efi_puts() - Write a UTF-8 encoded string to the console
- * @str:	UTF-8 encoded string
- */
-void efi_puts(const char *str)
-{
-	efi_char16_t buf[128];
-	size_t pos = 0, lim = ARRAY_SIZE(buf);
-	const u8 *s8 = (const u8 *)str;
-	u32 c32;
-
-	while (*s8) {
-		if (*s8 == '\n')
-			buf[pos++] = L'\r';
-		c32 = utf8_to_utf32(&s8);
-		if (c32 < 0x10000) {
-			/* Characters in plane 0 use a single word. */
-			buf[pos++] = c32;
-		} else {
-			/*
-			 * Characters in other planes encode into a surrogate
-			 * pair.
-			 */
-			buf[pos++] = (0xd800 - (0x10000 >> 10)) + (c32 >> 10);
-			buf[pos++] = 0xdc00 + (c32 & 0x3ff);
-		}
-		if (*s8 == '\0' || pos >= lim - 2) {
-			buf[pos] = L'\0';
-			efi_char16_puts(buf);
-			pos = 0;
-		}
-	}
-}
-
 /**
  * efi_printk() - Print a kernel message
  * @fmt:	format string
  *
  * The first letter of the format string is used to determine the logging level
  * of the message. If the level is less then the current EFI logging level, the
- * message is suppressed. The message will be truncated to 255 bytes.
+ * message is suppressed. The message will be truncated to 255 characters
+ * (ignoring surrogates).
  *
  * Return:	number of printed characters
  */
 int efi_printk(const char *fmt, ...)
 {
-	char printf_buf[256];
+	efi_char16_t printf_buf[256];
 	va_list args;
 	int printed;
 	int loglevel = printk_get_level(fmt);
@@ -141,11 +63,12 @@ int efi_printk(const char *fmt, ...)
 	fmt = printk_skip_level(fmt);
 
 	va_start(args, fmt);
-	printed = vsnprintf(printf_buf, sizeof(printf_buf), fmt, args);
+	printed = efi_vsnprintf(printf_buf, ARRAY_SIZE(printf_buf), fmt, args,
+				true);
 	va_end(args);
 
-	efi_puts(printf_buf);
-	if (printed >= sizeof(printf_buf)) {
+	efi_char16_puts(printf_buf);
+	if (printed >= ARRAY_SIZE(printf_buf)) {
 		efi_char16_puts(L"[Message truncated]\r\n");
 		return -1;
 	}
diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
index dba136679172..bd32af6b4f4d 100644
--- a/drivers/firmware/efi/libstub/vsprintf.c
+++ b/drivers/firmware/efi/libstub/vsprintf.c
@@ -14,10 +14,14 @@
 
 #include <linux/compiler.h>
 #include <linux/ctype.h>
+#include <linux/efi.h>
 #include <linux/kernel.h>
 #include <linux/limits.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/ucs2_string.h>
+
+#include "efistub.h"
 
 static
 int skip_atoi(const char **s)
@@ -239,58 +243,6 @@ char get_sign(long long *num, int flags)
 	return 0;
 }
 
-static
-size_t utf16s_utf8nlen(const u16 *s16, size_t maxlen)
-{
-	size_t len, clen;
-
-	for (len = 0; len < maxlen && *s16; len += clen) {
-		u16 c0 = *s16++;
-
-		/* First, get the length for a BMP character */
-		clen = 1 + (c0 >= 0x80) + (c0 >= 0x800);
-		if (len + clen > maxlen)
-			break;
-		/*
-		 * If this is a high surrogate, and we're already at maxlen, we
-		 * can't include the character if it's a valid surrogate pair.
-		 * Avoid accessing one extra word just to check if it's valid
-		 * or not.
-		 */
-		if ((c0 & 0xfc00) == 0xd800) {
-			if (len + clen == maxlen)
-				break;
-			if ((*s16 & 0xfc00) == 0xdc00) {
-				++s16;
-				++clen;
-			}
-		}
-	}
-
-	return len;
-}
-
-static
-u32 utf16_to_utf32(const u16 **s16)
-{
-	u16 c0, c1;
-
-	c0 = *(*s16)++;
-	/* not a surrogate */
-	if ((c0 & 0xf800) != 0xd800)
-		return c0;
-	/* invalid: low surrogate instead of high */
-	if (c0 & 0x0400)
-		return 0xfffd;
-	c1 = **s16;
-	/* invalid: missing low surrogate */
-	if ((c1 & 0xfc00) != 0xdc00)
-		return 0xfffd;
-	/* valid surrogate pair */
-	++(*s16);
-	return (0x10000 - (0xd800 << 10) - 0xdc00) + (c0 << 10) + c1;
-}
-
 #define PUTC(c) \
 do {				\
 	if (pos < size)		\
@@ -298,7 +250,8 @@ do {				\
 	++pos;			\
 } while (0);
 
-int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
+int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
+		  bool crlf)
 {
 	/* The maximum space required is to print a 64-bit number in octal */
 	char tmp[(sizeof(unsigned long long) * 8 + 2) / 3];
@@ -336,6 +289,8 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
 
 	for (pos = 0; *fmt; ++fmt) {
 		if (*fmt != '%' || *++fmt == '%') {
+			if (crlf && *fmt == '\n')
+				PUTC('\r');
 			PUTC(*fmt);
 			continue;
 		}
@@ -400,7 +355,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
 			else if (qualifier == 'l') {
 		wstring:
 				flags |= WIDE;
-				precision = len = utf16s_utf8nlen((const u16 *)s, precision);
+				precision = len = ucs2_strnlen((const u16 *)s, precision);
 				goto output;
 			}
 			precision = len = strnlen(s, precision);
@@ -505,36 +460,9 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
 		if (flags & WIDE) {
 			const u16 *ws = (const u16 *)s;
 
-			while (len-- > 0) {
-				u32 c32 = utf16_to_utf32(&ws);
-				u8 *s8;
-				size_t clen;
-
-				if (c32 < 0x80) {
-					PUTC(c32);
-					continue;
-				}
-
-				/* Number of trailing octets */
-				clen = 1 + (c32 >= 0x800) + (c32 >= 0x10000);
-
-				len -= clen;
-				s8 = (u8 *)&buf[pos];
-
-				/* Avoid writing partial character */
-				PUTC('\0');
-				pos += clen;
-				if (pos >= size)
-					continue;
-
-				/* Set high bits of leading octet */
-				*s8 = (0xf00 >> 1) >> clen;
-				/* Write trailing octets in reverse order */
-				for (s8 += clen; clen; --clen, c32 >>= 6)
-					*s8-- = 0x80 | (c32 & 0x3f);
-				/* Set low bits of leading octet */
-				*s8 |= c32;
-			}
+			if (pos < size)
+				memcpy(&buf[pos], ws, min(len, size - pos) * sizeof(*ws));
+			pos += len;
 		} else {
 			while (len-- > 0)
 				PUTC(*s++);
-- 
2.55.0.1003.g10538fe699-goog

