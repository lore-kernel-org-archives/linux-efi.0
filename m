From: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 6/6] x86, boot: Deliver us from evil
Date: Thu, 10 Jan 2013 18:04:28 +0000
Message-ID: <1357841068-6582-6-git-send-email-dwmw2@infradead.org>
References: <1357841068-6582-1-git-send-email-dwmw2@infradead.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357841068-6582-1-git-send-email-dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Check for broken bootloaders jumping into the kernel image at 0x200, which
was never a defined entry point. It was *always* broken for a 32-bit kernel,
and there's no sane way to tell a 32-bit bzImage from a 64-bit one. (Anyone
who suggests looking at the kernel_alignment field, go and stand in the
naughty corner. Besides, the offending bootloaders *didn't* do this.)

Signed-off-by: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/compressed/head_64.S | 49 +++++++++++++++++++++++---------------
 arch/x86/kernel/setup.c            |  6 +++++
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index f5d1aaa..a7d8b7e 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -185,27 +185,28 @@ no_longmode:
 #include "../../kernel/verify_cpu.S"
 
 	/*
-	 * Be careful here startup_64 needs to be at a predictable
-	 * address so I can export it in an ELF header.  Bootloaders
-	 * should look at the ELF header to find this address, as
-	 * it may change in the future.
+	 * startup_64 was once here, and some very naughty bootloaders decided
+	 * to jump directly to it despite the fact that it was clearly marked
+	 * 'this may change' and in fact had already moved once without
+	 * fanfare. And despite the fact that they were not even checking for
+	 * 32-bit vs. 64-bit kernels, so they were just jumping right into
+	 * the compressed payload when asked to boot the former!
+	 *
+	 * These bootloaders are so *egregiously* broken, and for 32-bit
+	 * kernels they broken in the "it just crashes instead of booting"
+	 * sense of the word rather than just the "you got away with it, but
+	 * someone needs to be whipped for this" sense of the word. So we don't
+	 * feel the need to pander to them and retroactively "define" the
+	 * entry point to be at 0x200. But for a *little* while let's catch it
+	 * and give a nasty warning message during boot that their bootloader
+	 * needs to be updated.
 	 */
 	.code64
 	.org 0x200
-ENTRY(startup_64)
-	/*
-	 * We come here either from startup_32 or directly from a
-	 * 64bit bootloader.  If we come here from a bootloader we depend on
-	 * an identity mapped page table being provied that maps our
-	 * entire text+data+bss and hopefully all of memory.
-	 */
-#ifdef CONFIG_EFI_STUB
-	/*
-	 * The entry point for the PE/COFF executable is efi_pe_entry, so
-	 * only legacy boot loaders will execute this jmp.
-	 */
+	movl	$0xbad10ad, %edx
 	jmp	preferred_addr
 
+#ifdef CONFIG_EFI_STUB
 ENTRY(efi_pe_entry)
 	mov	%rcx, %rdi
 	mov	%rdx, %rsi
@@ -234,12 +235,19 @@ ENTRY(efi_stub_entry)
 	subq	$3b, %rax
 	subq	BP_pref_address(%rsi), %rax
 	add	BP_code32_start(%esi), %eax
-	leaq	preferred_addr(%rax), %rax
+	leaq	startup_64(%rax), %rax
 	jmp	*%rax
-
-preferred_addr:
 #endif
+	/*
+	 * We come here either from startup_32 or directly from a
+	 * 64bit bootloader.  If we come here from a bootloader we depend on
+	 * an identity mapped page table being provied that maps our
+	 * entire text+data+bss and hopefully all of memory.
+	 */
+ENTRY(startup_64)
+	movl	$0, %edx
 
+preferred_addr:
 	/* Setup data segments. */
 	xorl	%eax, %eax
 	movl	%eax, %ds
@@ -251,6 +259,9 @@ preferred_addr:
 	movl    $0x20, %eax
 	ltr	%ax
 
+	/* Store 'bad load' flag in BP */
+	movl	%edx, BP_scratch(%rsi)
+
 	/*
 	 * Compute the decompressed kernel start address.  It is where
 	 * we were loaded at aligned to a 2M boundary. %rbp contains the
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 23ddd55..02ce7d9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1061,6 +1061,12 @@ void __init setup_arch(char **cmdline_p)
 		efi_enabled = 0;
 	}
 #endif
+#ifdef CONFIG_X86_64
+	if (boot_params.scratch == 0xbad10ad) {
+		WARN(1, "Broken bootloader jumped to wrong entry point in the kernel image. "
+		     "Please update your bootloader or new kernels may not boot.");
+	}
+#endif
 }
 
 #ifdef CONFIG_X86_32
-- 
1.8.0.1
