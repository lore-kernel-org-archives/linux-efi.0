From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 09/11] x86/efi: Firmware agnostic handover entry points
Date: Wed, 29 Jan 2014 16:23:55 +0000
Message-ID: <1391012637-4839-10-git-send-email-matt@console-pimps.org>
References: <1391012637-4839-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391012637-4839-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The EFI handover code only works if the "bitness" of the firmware and
the kernel match, i.e. 64-bit firmware and 64-bit kernel - it is not
possible to mix the two. This goes against the tradition that a 32-bit
kernel can be loaded on a 64-bit BIOS platform without having to do
anything special in the boot loader. Linux distributions, for one thing,
regularly run only 32-bit kernels on their live media.

Despite having only one 'handover_offset' field in the kernel header,
EFI boot loaders use two separate entry points to enter the kernel based
on the architecture the boot loader was compiled for,

    (1) 32-bit loader: handover_offset
    (2) 64-bit loader: handover_offset + 512

Since we already have two entry points, we can leverage them to infer
the bitness of the firmware we're running on, without requiring any boot
loader modifications, by making (1) and (2) valid entry points for both
CONFIG_X86_32 and CONFIG_X86_64 kernels.

To be clear, a 32-bit boot loader will always use (1) and a 64-bit boot
loader will always use (2). It's just that, if a single kernel image
supports (1) and (2) that image can be used with both 32-bit and 64-bit
boot loaders, and hence both 32-bit and 64-bit EFI.

(1) and (2) must be 512 bytes apart at all times, but that is already
part of the boot ABI and we could never change that delta without
breaking existing boot loaders anyhow.

Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/Makefile             |  2 +-
 arch/x86/boot/compressed/eboot.c   |  5 ++-
 arch/x86/boot/compressed/head_64.S | 69 +++++++++++++++++++++++++++++++++-----
 arch/x86/boot/tools/build.c        | 17 +++++++---
 arch/x86/include/asm/efi.h         |  6 ++--
 5 files changed, 82 insertions(+), 17 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index de7066918005..f1a32d077725 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -93,7 +93,7 @@ targets += voffset.h
 $(obj)/voffset.h: vmlinux FORCE
 	$(call if_changed,voffset)
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|startup_64\|efi_pe_entry\|efi_stub_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|efi_stub_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 4e428380bd56..c7e378eb38cd 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1077,6 +1077,7 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 	unsigned long map_sz, key, desc_size;
 	efi_memory_desc_t *mem_map;
 	struct setup_data *e820ext;
+	const char *signature;
 	__u32 e820ext_size;
 	__u32 nr_desc, prev_nr_desc;
 	efi_status_t status;
@@ -1110,7 +1111,9 @@ get_map:
 		goto get_map; /* Allocated memory, get map again */
 	}
 
-	memcpy(&efi->efi_loader_signature, EFI_LOADER_SIGNATURE, sizeof(__u32));
+	signature = is64 ? EFI64_LOADER_SIGNATURE : EFI32_LOADER_SIGNATURE;
+	memcpy(&efi->efi_loader_signature, signature, sizeof(__u32));
+
 	efi->efi_systab = (unsigned long)sys_table;
 	efi->efi_memdesc_size = desc_size;
 	efi->efi_memdesc_version = desc_version;
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 5e8e56f4d3f1..c112527a8900 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -178,6 +178,13 @@ ENTRY(startup_32)
 	 */
 	pushl	$__KERNEL_CS
 	leal	startup_64(%ebp), %eax
+#ifdef CONFIG_EFI_STUB
+	movl	efi32_config(%ebp), %ebx
+	cmp	$0, %ebx
+	jz	1f
+	leal	handover_entry(%ebp), %eax
+1:
+#endif
 	pushl	%eax
 
 	/* Enter paged protected Mode, activating Long Mode */
@@ -188,6 +195,30 @@ ENTRY(startup_32)
 	lret
 ENDPROC(startup_32)
 
+#ifdef CONFIG_EFI_STUB
+	.org 0x190
+ENTRY(efi32_stub_entry)
+	add	$0x4, %esp		/* Discard return address */
+	popl	%ecx
+	popl	%edx
+	popl	%esi
+
+	leal	(BP_scratch+4)(%esi), %esp
+	call	1f
+1:	pop	%ebp
+	subl	$1b, %ebp
+
+	movl	%ecx, efi32_config(%ebp)
+	movl	%edx, efi32_config+8(%ebp)
+	sgdtl	efi32_boot_gdt(%ebp)
+
+	leal	efi32_config(%ebp), %eax
+	movl	%eax, efi_config(%ebp)
+
+	jmp	startup_32
+ENDPROC(efi32_stub_entry)
+#endif
+
 	.code64
 	.org 0x200
 ENTRY(startup_64)
@@ -231,13 +262,7 @@ ENTRY(efi_pe_entry)
 	mov	%rax, %rsi
 	jmp	2f		/* Skip the relocation */
 
-ENTRY(efi_stub_entry)
-	movq	%rdx, efi64_config(%rip)	/* Handle */
-	movq	%rcx, efi64_config+8(%rip) /* EFI System table pointer */
-
-	leaq	efi64_config(%rip), %rax
-	movq	%rax, efi_config(%rip)
-
+handover_entry:
 	call	1f
 1:	popq	%rbp
 	subq	$1b, %rbp
@@ -247,7 +272,6 @@ ENTRY(efi_stub_entry)
 	 */
 	movq	efi_config(%rip), %rax
 	addq	%rbp, 88(%rax)
-	movq	%rdx, %rsi
 2:
 	movq	efi_config(%rip), %rdi
 	call	efi_main
@@ -336,6 +360,19 @@ preferred_addr:
 	leaq	relocated(%rbx), %rax
 	jmp	*%rax
 
+#ifdef CONFIG_EFI_STUB
+	.org 0x390
+ENTRY(efi64_stub_entry)
+	movq	%rdx, efi64_config(%rip)
+	movq	%rcx, efi64_config+8(%rip)
+
+	leaq	efi64_config(%rip), %rax
+	movq	%rax, efi_config(%rip)
+
+	jmp	handover_entry
+ENDPROC(efi64_stub_entry)
+#endif
+
 	.text
 relocated:
 
@@ -405,6 +442,22 @@ gdt_end:
 efi_config:
 	.quad	0
 
+	.global efi32_config
+efi32_config:
+	.quad	0
+	.quad	0
+	.quad	0
+	.quad	0
+	.quad	0
+	.quad	0
+	.quad	0
+	.quad	0
+	.quad	0
+	.quad	0
+	.quad	0
+	.quad	efi64_thunk
+	.byte	0
+
 	.global efi64_config
 efi64_config:
 	.quad	0
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index bf262077ec92..0483a8ef5ff0 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -54,6 +54,8 @@ int is_big_kernel;
 #define PECOFF_RELOC_RESERVE 0x20
 
 unsigned long efi_stub_entry;
+unsigned long efi32_stub_entry;
+unsigned long efi64_stub_entry;
 unsigned long efi_pe_entry;
 unsigned long startup_64;
 
@@ -241,10 +243,15 @@ static void efi_stub_defaults(void)
 
 static void efi_stub_entry_update(void)
 {
-#ifdef CONFIG_X86_64 /* Yes, this is really how we defined it :( */
-	efi_stub_entry -= 0x200;
-#endif
-	put_unaligned_le32(efi_stub_entry, &buf[0x264]);
+	/* Don't worry about older kernels for now */
+
+	/* Yes, this is really how we defined it :( */
+	efi64_stub_entry -= 0x200;
+
+	if (efi32_stub_entry != efi64_stub_entry)
+		die("32-bit and 64-bit EFI entry points do not match\n");
+
+	put_unaligned_le32(efi32_stub_entry, &buf[0x264]);
 }
 
 #else
@@ -290,6 +297,8 @@ static void parse_zoffset(char *fname)
 
 	while (p && *p) {
 		PARSE_ZOFS(p, efi_stub_entry);
+		PARSE_ZOFS(p, efi32_stub_entry);
+		PARSE_ZOFS(p, efi64_stub_entry);
 		PARSE_ZOFS(p, efi_pe_entry);
 		PARSE_ZOFS(p, startup_64);
 
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index d3c099f53ff2..6647efb6c6e8 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -19,9 +19,11 @@
  */
 #define EFI_OLD_MEMMAP		EFI_ARCH_1
 
+#define EFI32_LOADER_SIGNATURE	"EL32"
+#define EFI64_LOADER_SIGNATURE	"EL64"
+
 #ifdef CONFIG_X86_32
 
-#define EFI_LOADER_SIGNATURE	"EL32"
 
 extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
@@ -57,8 +59,6 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #else /* !CONFIG_X86_32 */
 
-#define EFI_LOADER_SIGNATURE	"EL64"
-
 extern u64 efi_call0(void *fp);
 extern u64 efi_call1(void *fp, u64 arg1);
 extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
-- 
1.8.3.1
