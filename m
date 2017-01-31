From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/7] x86/efi: Allow invocation of arbitrary runtime services
 [ver #7]
Date: Tue, 31 Jan 2017 15:13:18 +0000
Message-ID: <148587559825.4026.10932771233262003656.stgit@warthog.procyon.org.uk>
References: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <148587558696.4026.16034622623568539004.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Provide the ability to perform mixed-mode runtime service calls for x86 in
the same way that commit 0a637ee61247bd4bed9b2a07568ef7a1cfc76187
("x86/efi: Allow invocation of arbitrary boot services") provides the
ability to invoke arbitrary boot services.

Suggested-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 arch/x86/boot/compressed/eboot.c   |    1 +
 arch/x86/boot/compressed/head_32.S |    6 +++---
 arch/x86/boot/compressed/head_64.S |    8 ++++----
 arch/x86/include/asm/efi.h         |    5 +++++
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 6d3aeabbce68..f99978db6b6f 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -32,6 +32,7 @@ static void setup_boot_services##bits(struct efi_config *c)		\
 									\
 	table = (typeof(table))sys_table;				\
 									\
+	c->runtime_services = table->runtime;				\
 	c->boot_services = table->boottime;				\
 	c->text_output = table->con_out;				\
 }
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index fd0b6a272dd5..d85b9625e836 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -82,7 +82,7 @@ ENTRY(efi_pe_entry)
 
 	/* Relocate efi_config->call() */
 	leal	efi32_config(%esi), %eax
-	add	%esi, 32(%eax)
+	add	%esi, 40(%eax)
 	pushl	%eax
 
 	call	make_boot_params
@@ -108,7 +108,7 @@ ENTRY(efi32_stub_entry)
 
 	/* Relocate efi_config->call() */
 	leal	efi32_config(%esi), %eax
-	add	%esi, 32(%eax)
+	add	%esi, 40(%eax)
 	pushl	%eax
 2:
 	call	efi_main
@@ -264,7 +264,7 @@ relocated:
 #ifdef CONFIG_EFI_STUB
 	.data
 efi32_config:
-	.fill 4,8,0
+	.fill 5,8,0
 	.long efi_call_phys
 	.long 0
 	.byte 0
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 4d85e600db78..d2ae1f821e0c 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -264,7 +264,7 @@ ENTRY(efi_pe_entry)
 	/*
 	 * Relocate efi_config->call().
 	 */
-	addq	%rbp, efi64_config+32(%rip)
+	addq	%rbp, efi64_config+40(%rip)
 
 	movq	%rax, %rdi
 	call	make_boot_params
@@ -284,7 +284,7 @@ handover_entry:
 	 * Relocate efi_config->call().
 	 */
 	movq	efi_config(%rip), %rax
-	addq	%rbp, 32(%rax)
+	addq	%rbp, 40(%rax)
 2:
 	movq	efi_config(%rip), %rdi
 	call	efi_main
@@ -456,14 +456,14 @@ efi_config:
 #ifdef CONFIG_EFI_MIXED
 	.global efi32_config
 efi32_config:
-	.fill	4,8,0
+	.fill	5,8,0
 	.quad	efi64_thunk
 	.byte	0
 #endif
 
 	.global efi64_config
 efi64_config:
-	.fill	4,8,0
+	.fill	5,8,0
 	.quad	efi_call
 	.byte	1
 #endif /* CONFIG_EFI_STUB */
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index e99675b9c861..2f77bcefe6b4 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -191,6 +191,7 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 struct efi_config {
 	u64 image_handle;
 	u64 table;
+	u64 runtime_services;
 	u64 boot_services;
 	u64 text_output;
 	efi_status_t (*call)(unsigned long, ...);
@@ -226,6 +227,10 @@ static inline bool efi_is_64bit(void)
 #define __efi_call_early(f, ...)					\
 	__efi_early()->call((unsigned long)f, __VA_ARGS__);
 
+#define efi_call_runtime(f, ...)					\
+	__efi_early()->call(efi_table_attr(efi_runtime_services, f,	\
+		__efi_early()->runtime_services), __VA_ARGS__)
+
 extern bool efi_reboot_required(void);
 
 #else
