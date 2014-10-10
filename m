From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] arm64/efi: set PE/COFF file alignment to 512 bytes
Date: Fri, 10 Oct 2014 18:58:55 +0200
Message-ID: <1412960335-22905-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Change our PE/COFF header to use the minimum file alignment of
512 bytes (0x200), as mandated by the PE/COFF spec v8.3

Also update the linker script so that the Image file itself is also a
round multiple of FileAlignment.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---

Another one from the PE/COFF rabbit hole. I will follow up next week and repost
as a coherent series, once I have collected all the feedback.

 arch/arm64/kernel/head.S        |  2 +-
 arch/arm64/kernel/vmlinux.lds.S | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index ba715ce3f7f1..e7e83b3128fd 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -162,7 +162,7 @@ optional_header:
 extra_header_fields:
 	.quad	0				// ImageBase
 	.long	0x1000				// SectionAlignment
-	.long	0x8				// FileAlignment
+	.long	PECOFF_FILE_ALIGNMENT		// FileAlignment
 	.short	0				// MajorOperatingSystemVersion
 	.short	0				// MinorOperatingSystemVersion
 	.short	0				// MajorImageVersion
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index edf8715ba39b..4596f46d0244 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -32,6 +32,22 @@ jiffies = jiffies_64;
 	*(.hyp.text)					\
 	VMLINUX_SYMBOL(__hyp_text_end) = .;
 
+/*
+ * The size of the PE/COFF section that covers the kernel image, which
+ * runs from stext to _edata, must be a round multiple of the PE/COFF
+ * FileAlignment, which we set to its minimum value of 0x200. 'stext'
+ * itself is 4 KB aligned, so padding out _edata to a 0x200 aligned
+ * boundary should be sufficient.
+ */
+PECOFF_FILE_ALIGNMENT = 0x200;
+
+#ifdef CONFIG_EFI
+#define PECOFF_EDATA_PADDING	\
+	.pecoff_edata_padding : { BYTE(0); . = ALIGN(PECOFF_FILE_ALIGNMENT); }
+#else
+#define PECOFF_EDATA_PADDING
+#endif
+
 SECTIONS
 {
 	/*
@@ -103,6 +119,7 @@ SECTIONS
 	_data = .;
 	_sdata = .;
 	RW_DATA_SECTION(64, PAGE_SIZE, THREAD_SIZE)
+	PECOFF_EDATA_PADDING
 	_edata = .;
 
 	BSS_SECTION(0, 0, 0)
-- 
1.8.3.2
