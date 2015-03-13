From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] x86, boot: Move z_extract_offset calculation to header.S
Date: Thu, 12 Mar 2015 19:12:57 -0700
Message-ID: <1426212777-3622-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

At that point, we have exact decompressor size, so we don't need to guess
that size in mkpiggy.c

We use 8 pages less in final init_size with this patch.

  input: [0x13f2b33b4-0x13fe44346], output: [0x13e000000-0x13fe61fff], heap: [0x13fe4f080-0x13fe5707f]

before patch

  input: [0x13f2bb3b4-0x13fe4c346], output: [0x13e000000-0x13fe69fff], heap: [0x13fe57080-0x13fe5f07f]

Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

---
Please apply after patcheset: [PATCH v3 0/7] x86, boot: clean up kaslr

---
 arch/x86/boot/Makefile             |    2 +-
 arch/x86/boot/compressed/misc.c    |    5 +----
 arch/x86/boot/compressed/mkpiggy.c |   17 +----------------
 arch/x86/boot/header.S             |   29 ++++++++++++++++++++++++++++-
 4 files changed, 31 insertions(+), 22 deletions(-)

Index: linux-2.6/arch/x86/boot/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/boot/Makefile
+++ linux-2.6/arch/x86/boot/Makefile
@@ -86,7 +86,7 @@ targets += voffset.h
 $(obj)/voffset.h: vmlinux FORCE
 	$(call if_changed,voffset)
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_rodata\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_rodata\|_ehead\|_text\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
Index: linux-2.6/arch/x86/boot/header.S
===================================================================
--- linux-2.6.orig/arch/x86/boot/header.S
+++ linux-2.6/arch/x86/boot/header.S
@@ -443,7 +443,34 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR
 # don't overlap data area of ZO with VO
 #define ADDON_ZO_SIZE (ZO__end - ZO__rodata)
 
-#define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_min_extract_offset)
+/* check arch/x86/boot/compressed/misc.c for the formula about extra_bytes.  */
+#define ZO_z_extra_bytes ((ZO_z_output_len >> 12) + 32768 + 18)
+#if ZO_z_output_len > ZO_z_input_len
+#define ZO_z_extract_offset (ZO_z_output_len + ZO_z_extra_bytes - ZO_z_input_len)
+#else
+#define ZO_z_extract_offset ZO_z_extra_bytes
+#endif
+/*
+ * extract_offset has to be bigger than ZO head section.
+ * otherwise during head code running to move ZO to end of buffer,
+ * will overwrite head code itself.
+ */
+#if (ZO__ehead - ZO_startup_32) > ZO_z_extract_offset
+#define ZO_z_extract_offset_new	((ZO__ehead - ZO_startup_32 + 4095) & ~4095)
+#else
+#define ZO_z_extract_offset_new	((ZO_z_extract_offset + 4095) & ~4095)
+#endif
+#define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_extract_offset_new)
+
+/*
+ * ZO__end - ZO_startup_32 is (ZO__ehead - ZO_startup_32) + ZO_z_input_len + (ZO__end - ZO__text)
+ * ZO_z_extract_offset_new >= (ZO_z_output_len + ZO_z_extra_bytes - ZO_z_input_len)
+ * then ZO_INIT_SIZE >= (ZO__ehead - ZO_startup_32) + ZO_z_input_len + (ZO__end - ZO__text) + (ZO_z_output_len + ZO_z_extra_bytes - ZO_z_input_len)
+ * so (ZO_INIT_SIZE - ZO_z_output_len) > (ZO__end - ZO__text)
+ * That means during decompressor running, output could not
+ * overwrite the decompressor itself.
+ */
+
 #define VO_INIT_SIZE	(VO__end - VO__text)
 #if ZO_INIT_SIZE > VO_INIT_SIZE
 #define INIT_SIZE (ZO_INIT_SIZE + ADDON_ZO_SIZE)
Index: linux-2.6/arch/x86/boot/compressed/mkpiggy.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/mkpiggy.c
+++ linux-2.6/arch/x86/boot/compressed/mkpiggy.c
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
 
@@ -65,24 +63,11 @@ int main(int argc, char *argv[])
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
-
 	printf(".globl input_data, input_data_end\n");
 	printf("input_data:\n");
 	printf(".incbin \"%s\"\n", argv[1]);
Index: linux-2.6/arch/x86/boot/compressed/misc.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/misc.c
+++ linux-2.6/arch/x86/boot/compressed/misc.c
@@ -83,13 +83,10 @@
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
 
