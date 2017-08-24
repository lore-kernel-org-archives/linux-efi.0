From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 1/2] x86_32: boot, extract efi_pe_entry from startup_32
Date: Thu, 24 Aug 2017 09:33:26 +0200
Message-ID: <20170824073327.4129-1-jslaby@suse.cz>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

efi_pe_entry body is somehow squashed into startup_32. In the old days,
we forced startup_32 to start at offset 0x00 and efi_pe_entry to start
at 0x10. But this requirement was removed in 99f857db8857 ("x86, build:
Dynamically find entry points in compressed startup code") long time
ago.

The way it is now makes the code less readable and illogical. And given
we can now safely extract the inlined efi_pe_entry body from
startup_32 into a separate function, we do so and we separate it to two
functions as they are marked already: efi_pe_entry + efi32_stub_entry.

We also annotate the functions appropriatelly by ENTRY+ENDPROC.

ABI offset is preserved:
  0000   128 FUNC    GLOBAL DEFAULT    6 startup_32
  0080    60 FUNC    GLOBAL DEFAULT    6 efi_pe_entry
  00bc    68 FUNC    GLOBAL DEFAULT    6 efi32_stub_entry

On the top-level, it looked like:
	ENTRY(startup_32)
	#ifdef CONFIG_EFI_STUB		; start of inlined
		jmp     preferred_addr
	ENTRY(efi_pe_entry)
		... ; a lot of assembly (efi_pe_entry)
	ENTRY(efi32_stub_entry)
		... ; a lot of assembly (efi32_stub_entry)
		leal    preferred_addr(%eax), %eax
		jmp     *%eax
	preferred_addr:
	#endif				; end of inlined
		... ; a lot of assembly (startup_32)
	ENDPROC(startup_32)

And it is converted into:
	ENTRY(startup_32)
		... ; a lot of assembly (startup_32)
	ENDPROC(startup_32)

	#ifdef CONFIG_EFI_STUB
	ENTRY(efi_pe_entry)
		... ; a lot of assembly (efi_pe_entry)
	ENDPROC(efi_pe_entry)

	ENTRY(efi32_stub_entry)
		... ; a lot of assembly (efi32_stub_entry)
		leal    startup_32(%eax), %eax
		jmp     *%eax
	ENDPROC(efi32_stub_entry)
	#endif

Signed-off-by: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/boot/compressed/head_32.S | 129 ++++++++++++++++++-------------------
 1 file changed, 64 insertions(+), 65 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index d85b9625e836..11c68cf53d4e 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -61,71 +61,6 @@
 
 	__HEAD
 ENTRY(startup_32)
-#ifdef CONFIG_EFI_STUB
-	jmp	preferred_addr
-
-	/*
-	 * We don't need the return address, so set up the stack so
-	 * efi_main() can find its arguments.
-	 */
-ENTRY(efi_pe_entry)
-	add	$0x4, %esp
-
-	call	1f
-1:	popl	%esi
-	subl	$1b, %esi
-
-	popl	%ecx
-	movl	%ecx, efi32_config(%esi)	/* Handle */
-	popl	%ecx
-	movl	%ecx, efi32_config+8(%esi)	/* EFI System table pointer */
-
-	/* Relocate efi_config->call() */
-	leal	efi32_config(%esi), %eax
-	add	%esi, 40(%eax)
-	pushl	%eax
-
-	call	make_boot_params
-	cmpl	$0, %eax
-	je	fail
-	movl	%esi, BP_code32_start(%eax)
-	popl	%ecx
-	pushl	%eax
-	pushl	%ecx
-	jmp	2f		/* Skip efi_config initialization */
-
-ENTRY(efi32_stub_entry)
-	add	$0x4, %esp
-	popl	%ecx
-	popl	%edx
-
-	call	1f
-1:	popl	%esi
-	subl	$1b, %esi
-
-	movl	%ecx, efi32_config(%esi)	/* Handle */
-	movl	%edx, efi32_config+8(%esi)	/* EFI System table pointer */
-
-	/* Relocate efi_config->call() */
-	leal	efi32_config(%esi), %eax
-	add	%esi, 40(%eax)
-	pushl	%eax
-2:
-	call	efi_main
-	cmpl	$0, %eax
-	movl	%eax, %esi
-	jne	2f
-fail:
-	/* EFI init failed, so hang. */
-	hlt
-	jmp	fail
-2:
-	movl	BP_code32_start(%esi), %eax
-	leal	preferred_addr(%eax), %eax
-	jmp	*%eax
-
-preferred_addr:
-#endif
 	cld
 	/*
 	 * Test KEEP_SEGMENTS flag to see if the bootloader is asking
@@ -208,6 +143,70 @@ preferred_addr:
 	jmp	*%eax
 ENDPROC(startup_32)
 
+#ifdef CONFIG_EFI_STUB
+/*
+ * We don't need the return address, so set up the stack so efi_main() can find
+ * its arguments.
+ */
+ENTRY(efi_pe_entry)
+	add	$0x4, %esp
+
+	call	1f
+1:	popl	%esi
+	subl	$1b, %esi
+
+	popl	%ecx
+	movl	%ecx, efi32_config(%esi)	/* Handle */
+	popl	%ecx
+	movl	%ecx, efi32_config+8(%esi)	/* EFI System table pointer */
+
+	/* Relocate efi_config->call() */
+	leal	efi32_config(%esi), %eax
+	add	%esi, 40(%eax)
+	pushl	%eax
+
+	call	make_boot_params
+	cmpl	$0, %eax
+	je	fail
+	movl	%esi, BP_code32_start(%eax)
+	popl	%ecx
+	pushl	%eax
+	pushl	%ecx
+	jmp	2f		/* Skip efi_config initialization */
+ENDPROC(efi_pe_entry)
+
+ENTRY(efi32_stub_entry)
+	add	$0x4, %esp
+	popl	%ecx
+	popl	%edx
+
+	call	1f
+1:	popl	%esi
+	subl	$1b, %esi
+
+	movl	%ecx, efi32_config(%esi)	/* Handle */
+	movl	%edx, efi32_config+8(%esi)	/* EFI System table pointer */
+
+	/* Relocate efi_config->call() */
+	leal	efi32_config(%esi), %eax
+	add	%esi, 40(%eax)
+	pushl	%eax
+2:
+	call	efi_main
+	cmpl	$0, %eax
+	movl	%eax, %esi
+	jne	2f
+fail:
+	/* EFI init failed, so hang. */
+	hlt
+	jmp	fail
+2:
+	movl	BP_code32_start(%esi), %eax
+	leal	startup_32(%eax), %eax
+	jmp	*%eax
+ENDPROC(efi32_stub_entry)
+#endif
+
 	.text
 relocated:
 
-- 
2.14.1
