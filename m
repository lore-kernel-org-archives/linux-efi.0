From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 2/2] x86/efi: Allow invocation of arbitrary boot services
Date: Mon, 22 Aug 2016 12:01:21 +0200
Message-ID: <19e0ac48c448dabbed8ed87bf872a39d1e7ea3b2.1471823100.git.lukas@wunner.de>
References: <188ea850c957034d482576dfdcf8c8a2536460cf.1471823100.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <188ea850c957034d482576dfdcf8c8a2536460cf.1471823100.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

We currently allow invocation of 8 boot services with efi_call_early().
Not included are LocateHandleBuffer and LocateProtocol in particular.
For graphics output or to retrieve PCI ROMs and Apple device properties,
we're thus forced to use the LocateHandle + AllocatePool + LocateHandle
combo, which is cumbersome and needs more code.

The ARM folks allow invocation of the full set of boot services but are
restricted to our 8 boot services in functions shared across arches.

Thus, rather than adding just LocateHandleBuffer and LocateProtocol to
struct efi_config, let's rework efi_call_early() to allow invocation of
arbitrary boot services by selecting the 64 bit vs 32 bit code path in
the macro itself.

When compiling for 32 bit or for 64 bit without mixed mode, the unused
code path is optimized away and the binary code is the same as before.
But on 64 bit with mixed mode enabled, this commit adds one compare
instruction to each invocation of a boot service and, depending on the
code path selected, two jump instructions. (Most of the time gcc
arranges the jumps in the 32 bit code path.) The result is a minuscule
performance penalty and the binary code becomes slightly larger and more
difficult to read when disassembled. This isn't a hot path, so these
drawbacks are arguably outweighed by the attainable simplification of
the C code. We have some overhead anyway for thunking or conversion
between calling conventions.

The 8 boot services can consequently be removed from struct efi_config.

No functional change intended (for now).

Example -- invocation of free_pool before (64 bit code path):
0x2d4      movq  %ds:efi_early, %rdx          ; efi_early
0x2db      movq  %ss:arg_0-0x20(%rsp), %rsi
0x2e0      xorl  %eax, %eax
0x2e2      movq  %ds:0x28(%rdx), %rdi         ; efi_early->free_pool
0x2e6      callq *%ds:0x58(%rdx)              ; efi_early->call()

Example -- invocation of free_pool after (64 / 32 bit mixed code path):
0x0dc      movq  %ds:efi_early, %rax          ; efi_early
0x0e3      cmpb  $0, %ds:0x28(%rax)           ; !efi_early->is64 ?
0x0e7      movq  %ds:0x20(%rax), %rdx         ; efi_early->call()
0x0eb      movq  %ds:0x10(%rax), %rax         ; efi_early->boot_services
0x0ef      je    $0x150
0x0f1      movq  %ds:0x48(%rax), %rdi         ; free_pool (64 bit)
0x0f5      xorl  %eax, %eax
0x0f7      callq *%rdx
...
0x150      movl  %ds:0x30(%rax), %edi         ; free_pool (32 bit)
0x153      jmp   $0x0f5

Size of eboot.o text section:
CONFIG_X86_32:                         6464 before, 6318 after
CONFIG_X86_64 && !CONFIG_EFI_MIXED:    7670 before, 7573 after
CONFIG_X86_64 &&  CONFIG_EFI_MIXED:    7670 before, 8319 after

Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c   | 13 +------------
 arch/x86/boot/compressed/head_32.S |  6 +++---
 arch/x86/boot/compressed/head_64.S |  8 ++++----
 arch/x86/include/asm/efi.h         | 15 ++++++---------
 4 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index f7fc85b..447a6a2 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -29,22 +29,11 @@ __pure const struct efi_config *__efi_early(void)
 static void setup_boot_services##bits(struct efi_config *c)		\
 {									\
 	efi_system_table_##bits##_t *table;				\
-	efi_boot_services_##bits##_t *bt;				\
 									\
 	table = (typeof(table))sys_table;				\
 									\
+	c->boot_services = table->boottime;				\
 	c->text_output = table->con_out;				\
-									\
-	bt = (typeof(bt))(unsigned long)(table->boottime);		\
-									\
-	c->allocate_pool = bt->allocate_pool;				\
-	c->allocate_pages = bt->allocate_pages;				\
-	c->get_memory_map = bt->get_memory_map;				\
-	c->free_pool = bt->free_pool;					\
-	c->free_pages = bt->free_pages;					\
-	c->locate_handle = bt->locate_handle;				\
-	c->handle_protocol = bt->handle_protocol;			\
-	c->exit_boot_services = bt->exit_boot_services;			\
 }
 BOOT_SERVICES(32);
 BOOT_SERVICES(64);
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 1038524..fd0b6a2 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -82,7 +82,7 @@ ENTRY(efi_pe_entry)
 
 	/* Relocate efi_config->call() */
 	leal	efi32_config(%esi), %eax
-	add	%esi, 88(%eax)
+	add	%esi, 32(%eax)
 	pushl	%eax
 
 	call	make_boot_params
@@ -108,7 +108,7 @@ ENTRY(efi32_stub_entry)
 
 	/* Relocate efi_config->call() */
 	leal	efi32_config(%esi), %eax
-	add	%esi, 88(%eax)
+	add	%esi, 32(%eax)
 	pushl	%eax
 2:
 	call	efi_main
@@ -264,7 +264,7 @@ relocated:
 #ifdef CONFIG_EFI_STUB
 	.data
 efi32_config:
-	.fill 11,8,0
+	.fill 4,8,0
 	.long efi_call_phys
 	.long 0
 	.byte 0
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 0d80a7a..efdfba2 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -265,7 +265,7 @@ ENTRY(efi_pe_entry)
 	/*
 	 * Relocate efi_config->call().
 	 */
-	addq	%rbp, efi64_config+88(%rip)
+	addq	%rbp, efi64_config+32(%rip)
 
 	movq	%rax, %rdi
 	call	make_boot_params
@@ -285,7 +285,7 @@ handover_entry:
 	 * Relocate efi_config->call().
 	 */
 	movq	efi_config(%rip), %rax
-	addq	%rbp, 88(%rax)
+	addq	%rbp, 32(%rax)
 2:
 	movq	efi_config(%rip), %rdi
 	call	efi_main
@@ -457,14 +457,14 @@ efi_config:
 #ifdef CONFIG_EFI_MIXED
 	.global efi32_config
 efi32_config:
-	.fill	11,8,0
+	.fill	4,8,0
 	.quad	efi64_thunk
 	.byte	0
 #endif
 
 	.global efi64_config
 efi64_config:
-	.fill	11,8,0
+	.fill	4,8,0
 	.quad	efi_call
 	.byte	1
 #endif /* CONFIG_EFI_STUB */
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 1bda245..65c714a 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -192,14 +192,7 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 struct efi_config {
 	u64 image_handle;
 	u64 table;
-	u64 allocate_pool;
-	u64 allocate_pages;
-	u64 get_memory_map;
-	u64 free_pool;
-	u64 free_pages;
-	u64 locate_handle;
-	u64 handle_protocol;
-	u64 exit_boot_services;
+	u64 boot_services;
 	u64 text_output;
 	efi_status_t (*call)(unsigned long, ...);
 	bool is64;
@@ -212,7 +205,11 @@ __pure const struct efi_config *__efi_early(void);
 				       || __efi_early()->is64))
 
 #define efi_call_early(f, ...)						\
-	__efi_early()->call(__efi_early()->f, __VA_ARGS__);
+	__efi_early()->call(efi_is_64bit() ?				\
+		((efi_boot_services_64_t *)(unsigned long)		\
+			__efi_early()->boot_services)->f :		\
+		((efi_boot_services_32_t *)(unsigned long)		\
+			__efi_early()->boot_services)->f, __VA_ARGS__)
 
 #define __efi_call_early(f, ...)					\
 	__efi_early()->call((unsigned long)f, __VA_ARGS__);
-- 
2.8.1
