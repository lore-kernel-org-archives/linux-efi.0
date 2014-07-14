From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] arm64: add C struct definition for Image header
Date: Mon, 14 Jul 2014 18:17:50 +0200
Message-ID: <1405354671-14031-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1405354671-14031-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405354671-14031-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

In order to be able to interpret the Image header from C code, we need a
struct definition that reflects the specification for Image headers as laid
out in Documentation/arm64/booting.txt.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/image_hdr.h | 75 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 arch/arm64/include/asm/image_hdr.h

diff --git a/arch/arm64/include/asm/image_hdr.h b/arch/arm64/include/asm/image_hdr.h
new file mode 100644
index 000000000000..9dc74b672124
--- /dev/null
+++ b/arch/arm64/include/asm/image_hdr.h
@@ -0,0 +1,75 @@
+/*
+ * image_hdr.h - C struct definition of the arm64 Image header format
+ *
+ * Copyright (C) 2014 Linaro Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_IMAGE_HDR_H
+#define __ASM_IMAGE_HDR_H
+
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
+/**
+ * struct arm64_image_hdr - arm64 kernel Image binary header format
+ * @code0:		entry point, first instruction to jump to when booting
+ *			the Image
+ * @code1:		second instruction of entry point
+ * @text_offset:	mandatory offset (little endian) beyond a 2 megabyte
+ * 			aligned boundary that needs to be taken into account
+ * 			when deciding where to load the image
+ * @image_size:		total size (little endian) of the memory area (counted
+ *			from the offset where the image was loaded) that may be
+ *			used by the booting kernel before memory reservations
+ *			can be honoured
+ * @flags:		little endian bit field
+ *			Bit 0:		Kernel endianness.  1 if BE, 0 if LE.
+ *			Bits 1-63:	Reserved.
+ * @res2:		reserved, must be 0
+ * @res3:		reserved, must be 0
+ * @res4:		reserved, must be 0
+ * @magic:		Magic number (little endian): "ARM\x64"
+ * @res5:		reserved (used for PE COFF offset)
+ *
+ * This definition reflects the definition in Documentation/arm64/booting.txt in
+ * the Linux source tree.
+ */
+struct arm64_image_hdr {
+	uint32_t code0;
+	uint32_t code1;
+	uint64_t text_offset;
+	uint64_t image_size;
+	uint64_t flags;
+	uint64_t res2;
+	uint64_t res3;
+	uint64_t res4;
+	uint32_t magic;
+	uint32_t res5;
+};
+
+static const union {
+	uint8_t		le_val[4];
+	uint32_t	cpu_val;
+} arm64_image_hdr_magic = {
+	.le_val		= "ARM\x64"
+};
+
+/**
+ * int arm64_image_hdr_check() - check whether hdr points to an arm64 Image
+ * @hdr:	pointer to an arm64 Image
+ *
+ * Return: 1 if check is successful, 0 otherwise
+ */
+static inline int arm64_image_hdr_check(struct arm64_image_hdr const *hdr)
+{
+	return hdr->magic == arm64_image_hdr_magic.cpu_val;
+}
+
+#endif
-- 
1.8.3.2
