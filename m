From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 07/19] x86, boot: Move z_extract_offset calculation to header.S
Date: Wed, 18 Mar 2015 00:28:14 -0700
Message-ID: <1426663706-23979-8-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

Old extract_offset calculation is done without knowledge of decompressor size.
so it guess one big size.

We can move it out header.S, we have exact decompressor size there.

We save 8 pages for init_size with this patch.

before patch:
kernel: [13e000000,13fa1dfff]
  input: [0x13f32d3b4-0x13fa01cc7], output: [0x13e000000-0x13f9ef81f], heap: [0x13fa0b680-0x13fa1367f]

after patch:
kernel: [13e000000,13fa15fff]
  input: [0x13f3253b4-0x13f9f9cc7], output: [0x13e000000-0x13f9ef81f], heap: [0x13fa03680-0x13fa0b67f]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/Makefile             |  2 +-
 arch/x86/boot/compressed/misc.c    |  5 +----
 arch/x86/boot/compressed/mkpiggy.c | 16 +---------------
 arch/x86/boot/header.S             | 29 +++++++++++++++++++++++++++++
 4 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index e7ee9cd..19dbd32 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -77,7 +77,7 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_rodata\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_rodata\|_ehead\|_text\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 7ef0eed..8e81a88 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -84,13 +84,10 @@
  * To avoid problems with the compressed data's meta information an extra 18
  * bytes are needed.  Leading to the formula:
  *
- * extra_bytes = (uncompressed_size >> 12) + 32768 + 18 + decompressor_size.
+ * extra_bytes = (uncompressed_size >> 12) + 32768 + 18.
  *
  * Adding 8 bytes per 32K is a bit excessive but much easier to calculate.
  * Adding 32768 instead of 32767 just makes for round numbers.
- * Adding the decompressor_size is necessary as it musht live after all
- * of the data as well.  Last I measured the decompressor is about 14K.
- * 10K of actual data and 4K of bss.
  *
  */
 
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index c03b009..c5148642 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -21,8 +21,7 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * Compute the desired load offset from a compressed program; outputs
- * a small assembly wrapper with the appropriate symbols defined.
+ * outputs a small assembly wrapper with the appropriate symbols defined.
  */
 
 #include <stdlib.h>
@@ -35,7 +34,6 @@ int main(int argc, char *argv[])
 {
 	uint32_t olen;
 	long ilen;
-	unsigned long offs;
 	FILE *f = NULL;
 	int retval = 1;
 
@@ -65,23 +63,11 @@ int main(int argc, char *argv[])
 	ilen = ftell(f);
 	olen = get_unaligned_le32(&olen);
 
-	/*
-	 * Now we have the input (compressed) and output (uncompressed)
-	 * sizes, compute the necessary decompression offset...
-	 */
-
-	offs = (olen > ilen) ? olen - ilen : 0;
-	offs += olen >> 12;	/* Add 8 bytes for each 32K block */
-	offs += 64*1024 + 128;	/* Add 64K + 128 bytes slack */
-	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
-
 	printf(".section \".rodata..compressed\",\"a\",@progbits\n");
 	printf(".globl z_input_len\n");
 	printf("z_input_len = %lu\n", ilen);
 	printf(".globl z_output_len\n");
 	printf("z_output_len = %lu\n", (unsigned long)olen);
-	printf(".globl z_min_extract_offset\n");
-	printf("z_min_extract_offset = 0x%lx\n", offs);
 
 	printf(".globl input_data, input_data_end\n");
 	printf("input_data:\n");
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 226d166..9a68962 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -443,7 +443,36 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 # don't overlap data area of ZO with VO bss
 #define ADDON_ZO_SIZE (ZO__end - ZO__rodata)
 
+/* check arch/x86/boot/compressed/misc.c for the formula about extra_bytes.  */
+#define ZO_z_extra_bytes ((ZO_z_output_len >> 12) + 32768 + 18)
+#if ZO_z_output_len > ZO_z_input_len
+#define ZO_z_extract_offset (ZO_z_output_len + ZO_z_extra_bytes - ZO_z_input_len)
+#else
+#define ZO_z_extract_offset ZO_z_extra_bytes
+#endif
+
+/*
+ * extract_offset has to be bigger than ZO head section.
+ * otherwise during head code running to move ZO to end of buffer,
+ * will overwrite head code itself.
+ */
+#if (ZO__ehead - ZO_startup_32) > ZO_z_extract_offset
+#define ZO_z_min_extract_offset ((ZO__ehead - ZO_startup_32 + 4095) & ~4095)
+#else
+#define ZO_z_min_extract_offset ((ZO_z_extract_offset + 4095) & ~4095)
+#endif
+
 #define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_min_extract_offset)
+
+/*
+ * ZO__end - ZO_startup_32 is (ZO__ehead - ZO_startup_32) + ZO_z_input_len + (ZO__end - ZO__text)
+ * ZO_z_min_extract_offset >= (ZO_z_output_len + ZO_z_extra_bytes - ZO_z_input_len)
+ * then ZO_INIT_SIZE >= (ZO__ehead - ZO_startup_32) + ZO_z_input_len + (ZO__end - ZO__text) + (ZO_z_output_len + ZO_z_extra_bytes - ZO_z_input_len)
+ * so (ZO_INIT_SIZE - ZO_z_output_len) > (ZO__end - ZO__text)
+ * That means during decompressor running, output could not
+ * overwrite the decompressor itself.
+ */
+
 #define VO_INIT_SIZE	(VO__end - VO__text)
 #if ZO_INIT_SIZE > VO_INIT_SIZE
 
-- 
1.8.4.5
