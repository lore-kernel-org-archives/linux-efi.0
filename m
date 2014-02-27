From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 02/13] x86, tools: Consolidate #ifdef code
Date: Thu, 27 Feb 2014 19:46:33 +0000
Message-ID: <1393530404-12479-3-git-send-email-matt@console-pimps.org>
References: <1393530404-12479-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393530404-12479-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Instead of littering main() with #ifdef CONFIG_EFI_STUB, move the logic
into separate functions that do nothing if the config option isn't set.
This makes main() much easier to read.

Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/tools/build.c | 64 +++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 8e15b22391fc..bf262077ec92 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -219,6 +219,45 @@ static void update_pecoff_text(unsigned int text_start, unsigned int file_sz)
 	update_pecoff_section_header(".text", text_start, text_sz);
 }
 
+static int reserve_pecoff_reloc_section(int c)
+{
+	/* Reserve 0x20 bytes for .reloc section */
+	memset(buf+c, 0, PECOFF_RELOC_RESERVE);
+	return PECOFF_RELOC_RESERVE;
+}
+
+static void efi_stub_defaults(void)
+{
+	/* Defaults for old kernel */
+#ifdef CONFIG_X86_32
+	efi_pe_entry = 0x10;
+	efi_stub_entry = 0x30;
+#else
+	efi_pe_entry = 0x210;
+	efi_stub_entry = 0x230;
+	startup_64 = 0x200;
+#endif
+}
+
+static void efi_stub_entry_update(void)
+{
+#ifdef CONFIG_X86_64 /* Yes, this is really how we defined it :( */
+	efi_stub_entry -= 0x200;
+#endif
+	put_unaligned_le32(efi_stub_entry, &buf[0x264]);
+}
+
+#else
+
+static inline void update_pecoff_setup_and_reloc(unsigned int) {}
+static inline void update_pecoff_text(unsigned int, unsigned int) {}
+static inline void efi_stub_defaults(void) {}
+static inline void efi_stup_entry_update(void) {}
+
+static inline int reserve_pecoff_reloc_section(int c)
+{
+	return 0;
+}
 #endif /* CONFIG_EFI_STUB */
 
 
@@ -271,15 +310,7 @@ int main(int argc, char ** argv)
 	void *kernel;
 	u32 crc = 0xffffffffUL;
 
-	/* Defaults for old kernel */
-#ifdef CONFIG_X86_32
-	efi_pe_entry = 0x10;
-	efi_stub_entry = 0x30;
-#else
-	efi_pe_entry = 0x210;
-	efi_stub_entry = 0x230;
-	startup_64 = 0x200;
-#endif
+	efi_stub_defaults();
 
 	if (argc != 5)
 		usage();
@@ -302,11 +333,7 @@ int main(int argc, char ** argv)
 		die("Boot block hasn't got boot flag (0xAA55)");
 	fclose(file);
 
-#ifdef CONFIG_EFI_STUB
-	/* Reserve 0x20 bytes for .reloc section */
-	memset(buf+c, 0, PECOFF_RELOC_RESERVE);
-	c += PECOFF_RELOC_RESERVE;
-#endif
+	c += reserve_pecoff_reloc_section(c);
 
 	/* Pad unused space with zeros */
 	setup_sectors = (c + 511) / 512;
@@ -315,9 +342,7 @@ int main(int argc, char ** argv)
 	i = setup_sectors*512;
 	memset(buf+c, 0, i-c);
 
-#ifdef CONFIG_EFI_STUB
 	update_pecoff_setup_and_reloc(i);
-#endif
 
 	/* Set the default root device */
 	put_unaligned_le16(DEFAULT_ROOT_DEV, &buf[508]);
@@ -342,14 +367,9 @@ int main(int argc, char ** argv)
 	buf[0x1f1] = setup_sectors-1;
 	put_unaligned_le32(sys_size, &buf[0x1f4]);
 
-#ifdef CONFIG_EFI_STUB
 	update_pecoff_text(setup_sectors * 512, sz + i + ((sys_size * 16) - sz));
 
-#ifdef CONFIG_X86_64 /* Yes, this is really how we defined it :( */
-	efi_stub_entry -= 0x200;
-#endif
-	put_unaligned_le32(efi_stub_entry, &buf[0x264]);
-#endif
+	efi_stub_entry_update();
 
 	crc = partial_crc32(buf, i, crc);
 	if (fwrite(buf, 1, i, dest) != i)
-- 
1.8.5.3
