From: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 5/6] x86, boot: Lead us not into temptation
Date: Thu, 10 Jan 2013 18:04:27 +0000
Message-ID: <1357841068-6582-5-git-send-email-dwmw2@infradead.org>
References: <1357841068-6582-1-git-send-email-dwmw2@infradead.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357841068-6582-1-git-send-email-dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Avoid hard-coded addresses in compressed startup code

We have historically hard-coded entry points in head.S just so it's easy
to build the executable/bzImage headers with references to them.

Unfortunately, this leads to boot loaders abusing these "known" addresses
even when they are *explicitly* told that they "should look at the ELF
header to find this address, as it may change in the future". And even
when the address in question *has* actually been changed in the past,
without fanfare or thought to compatibility.

Thus we have bootloaders doing stunningly broken things like jumping to
offset 0x200 in the kernel startup code in 64-bit mode, *hoping* that
startup_64 is still there. And hoping that it's actually a 64-bit kernel
despite the fact that we don't give them any indication of that fact.

Yes, this abomination has been seen in the wild, and yes the offending
bootloaders just jump right into the compressed payload of a 32-bit
bzImage, in 64-bit mode. And no, it doesn't work.

This patch should hopefully remove the temptation to abuse internal
addresses, where sternly worded comments have not sufficed. Instead of
having hard-coded addresses and saying "please don't abuse these", we
actually pull the addresses out of the ELF payload into zoffset.h, and
make build.c shove them back into the right places.

Rather than including zoffset.h into build.c and thus having to rebuild
the tool for every kernel build, we parse it instead. The parsing code
is small and simple.

Signed-off-by: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/x86/boot.txt         | 14 +++++++
 arch/x86/boot/Makefile             |  4 +-
 arch/x86/boot/compressed/head_32.S |  6 +--
 arch/x86/boot/compressed/head_64.S |  8 ++--
 arch/x86/boot/header.S             |  5 ++-
 arch/x86/boot/tools/build.c        | 81 +++++++++++++++++++++++++++++---------
 6 files changed, 89 insertions(+), 29 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 0841b21..62acb5b 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -1003,6 +1003,20 @@ IMPORTANT: All the hooks are required to preserve %esp, %ebp, %esi and
 	(relocated, if appropriate.)
 
 
+**** 64-bit BOOT PROTOCOL
+
+There is no 64-bit boot protocol when using the bzImage format; a
+bootloader cannot even reliably tell a 64-bit from a 32-bit kernel.
+64-bit bootloaders, unless using the 64-bit EFI handover protocol (see
+below), must switch the CPU into 32-bit mode and use the 32-bit boot
+protocolas described below.
+
+Special-purpose bootloaders using an ELF image file (such as is found
+in arch/x86/boot/compressed/vmlinux after a kernel build) may use the
+entry point indicated by the ELF headers, exactly as documented for
+the 32-bit boot protocol below, except in 64-bit mode.
+
+
 **** 32-bit BOOT PROTOCOL
 
 For machine with some new BIOS other than legacy BIOS, such as EFI,
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index ccce0ed..379814b 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -71,7 +71,7 @@ GCOV_PROFILE := n
 $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
 
 quiet_cmd_image = BUILD   $@
-cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin > $@
+cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/zoffset.h > $@
 
 $(obj)/bzImage: $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/tools/build FORCE
 	$(call if_changed,image)
@@ -92,7 +92,7 @@ targets += voffset.h
 $(obj)/voffset.h: vmlinux FORCE
 	$(call if_changed,voffset)
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|startup_64\|efi_pe_entry\|efi_stub_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index ccb2f4a..1e3184f 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -35,11 +35,11 @@ ENTRY(startup_32)
 #ifdef CONFIG_EFI_STUB
 	jmp	preferred_addr
 
-	.balign	0x10
 	/*
 	 * We don't need the return address, so set up the stack so
-	 * efi_main() can find its arugments.
+	 * efi_main() can find its arguments.
 	 */
+ENTRY(efi_pe_entry)
 	add	$0x4, %esp
 
 	call	make_boot_params
@@ -52,7 +52,7 @@ ENTRY(startup_32)
 	pushl	%ecx
 	sub	$0x4, %esp
 
-	.org 0x30,0x90
+ENTRY(efi_stub_entry)
 	add	$0x4, %esp
 	call	efi_main
 	cmpl	$0, %eax
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2c4b171..f5d1aaa 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -201,12 +201,12 @@ ENTRY(startup_64)
 	 */
 #ifdef CONFIG_EFI_STUB
 	/*
-	 * The entry point for the PE/COFF executable is 0x210, so only
-	 * legacy boot loaders will execute this jmp.
+	 * The entry point for the PE/COFF executable is efi_pe_entry, so
+	 * only legacy boot loaders will execute this jmp.
 	 */
 	jmp	preferred_addr
 
-	.org 0x210
+ENTRY(efi_pe_entry)
 	mov	%rcx, %rdi
 	mov	%rdx, %rsi
 	pushq	%rdi
@@ -218,7 +218,7 @@ ENTRY(startup_64)
 	popq	%rsi
 	popq	%rdi
 
-	.org 0x230,0x90
+ENTRY(efi_stub_entry)
 	call	efi_main
 	movq	%rax,%rsi
 	cmpq	$0,%rax
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 318264e..ad3b7f8 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -398,9 +398,10 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 #define INIT_SIZE VO_INIT_SIZE
 #endif
 init_size:		.long INIT_SIZE		# kernel initialization size
-handover_offset:	.long 0x30 * IS_ENABLED(CONFIG_EFI_STUB)
-						# offset to the handover
+
+handover_offset:	.long 0			# offset to the EFI handover
 						# protocol entry point
+						# (filled in by build.c)
 
 # End of setup header #####################################################
 
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 4b8e165..94c5446 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -52,6 +52,10 @@ int is_big_kernel;
 
 #define PECOFF_RELOC_RESERVE 0x20
 
+unsigned long efi_stub_entry;
+unsigned long efi_pe_entry;
+unsigned long startup_64;
+
 /*----------------------------------------------------------------------*/
 
 static const u32 crctab32[] = {
@@ -132,7 +136,7 @@ static void die(const char * str, ...)
 
 static void usage(void)
 {
-	die("Usage: build setup system [> image]");
+	die("Usage: build setup system [zoffset.h] [> image]");
 }
 
 #ifdef CONFIG_EFI_STUB
@@ -206,30 +210,54 @@ static void update_pecoff_text(unsigned int text_start, unsigned int file_sz)
 	 */
 	put_unaligned_le32(file_sz - 512, &buf[pe_header + 0x1c]);
 
-#ifdef CONFIG_X86_32
 	/*
-	 * Address of entry point.
-	 *
-	 * The EFI stub entry point is +16 bytes from the start of
-	 * the .text section.
+	 * Address of entry point for PE/COFF executable
 	 */
-	put_unaligned_le32(text_start + 16, &buf[pe_header + 0x28]);
-#else
-	/*
-	 * Address of entry point. startup_32 is at the beginning and
-	 * the 64-bit entry point (startup_64) is always 512 bytes
-	 * after. The EFI stub entry point is 16 bytes after that, as
-	 * the first instruction allows legacy loaders to jump over
-	 * the EFI stub initialisation
-	 */
-	put_unaligned_le32(text_start + 528, &buf[pe_header + 0x28]);
-#endif /* CONFIG_X86_32 */
+	put_unaligned_le32(text_start + efi_pe_entry, &buf[pe_header + 0x28]);
 
 	update_pecoff_section_header(".text", text_start, text_sz);
 }
 
 #endif /* CONFIG_EFI_STUB */
 
+
+/*
+ * Parse zoffset.h and find the entry points. We could just #include zoffset.h
+ * but that would mean tools/build would have to be rebuilt every time. It's
+ * not as if parsing it is hard...
+ */
+#define PARSE_ZOFS(p, sym) do { \
+	if (!strncmp(p, "#define ZO_" #sym " ", 11+sizeof(#sym)))	\
+		sym = strtoul(p + 11 + sizeof(#sym), NULL, 16);		\
+} while (0)
+
+static void parse_zoffset(char *fname)
+{
+	FILE *file;
+	char *p;
+	int c;
+
+	file = fopen(fname, "r");
+	if (!file)
+		die("Unable to open `%s': %m", fname);
+	c = fread(buf, 1, sizeof(buf) - 1, file);
+	if (ferror(file))
+		die("read-error on `zoffset.h'");
+	buf[c] = 0;
+
+	p = (char *)buf;
+
+	while (p && *p) {
+		PARSE_ZOFS(p, efi_stub_entry);
+		PARSE_ZOFS(p, efi_pe_entry);
+		PARSE_ZOFS(p, startup_64);
+
+		p = strchr(p, '\n');
+		while (p && (*p == '\r' || *p == '\n'))
+			p++;
+	}
+}
+
 int main(int argc, char ** argv)
 {
 	unsigned int i, sz, setup_sectors;
@@ -241,7 +269,19 @@ int main(int argc, char ** argv)
 	void *kernel;
 	u32 crc = 0xffffffffUL;
 
-	if (argc != 3)
+	/* Defaults for old kernel */
+#ifdef CONFIG_X86_32
+	efi_pe_entry = 0x10;
+	efi_stub_entry = 0x30;
+#else
+	efi_pe_entry = 0x210;
+	efi_stub_entry = 0x230;
+	startup_64 = 0x200;
+#endif
+
+	if (argc == 4)
+		parse_zoffset(argv[3]);
+	else if (argc != 3)
 		usage();
 
 	/* Copy the setup code */
@@ -299,6 +339,11 @@ int main(int argc, char ** argv)
 
 #ifdef CONFIG_EFI_STUB
 	update_pecoff_text(setup_sectors * 512, sz + i + ((sys_size * 16) - sz));
+
+#ifdef CONFIG_X86_64 /* Yes, this is really how we defined it :( */
+	efi_stub_entry -= 0x200;
+#endif
+	put_unaligned_le32(efi_stub_entry, &buf[0x264]);
 #endif
 
 	crc = partial_crc32(buf, i, crc);
-- 
1.8.0.1
