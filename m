From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 02/16] x86/efi: Add get and set variable to EFI services pointer table
Date: Tue, 11 Aug 2015 14:13:33 +0800
Message-ID: <1439273627-25111-3-git-send-email-jlee@suse.com>
References: <1439273627-25111-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439273627-25111-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add get variable and set variable function to EFI services pointer
table for supporting later functions of hibernate signature
verification to keep the HMAC key in efi boot service variable.
EFI boot stub needs get/set_variable functions for accessing key.

Reviewed-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
Tested-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c   | 4 ++++
 arch/x86/boot/compressed/head_32.S | 6 +++---
 arch/x86/boot/compressed/head_64.S | 8 ++++----
 arch/x86/include/asm/efi.h         | 2 ++
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 2c82bd1..0ffb6db 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -30,12 +30,14 @@ static void setup_boot_services##bits(struct efi_config *c)		\
 {									\
 	efi_system_table_##bits##_t *table;				\
 	efi_boot_services_##bits##_t *bt;				\
+	efi_runtime_services_##bits##_t *rt;				\
 									\
 	table = (typeof(table))sys_table;				\
 									\
 	c->text_output = table->con_out;				\
 									\
 	bt = (typeof(bt))(unsigned long)(table->boottime);		\
+	rt = (typeof(rt))(unsigned long)(table->runtime);		\
 									\
 	c->allocate_pool = bt->allocate_pool;				\
 	c->allocate_pages = bt->allocate_pages;				\
@@ -45,6 +47,8 @@ static void setup_boot_services##bits(struct efi_config *c)		\
 	c->locate_handle = bt->locate_handle;				\
 	c->handle_protocol = bt->handle_protocol;			\
 	c->exit_boot_services = bt->exit_boot_services;			\
+	c->get_variable = rt->get_variable;				\
+	c->set_variable = rt->set_variable;				\
 }
 BOOT_SERVICES(32);
 BOOT_SERVICES(64);
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 8ef964d..a7db5e3 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -54,7 +54,7 @@ ENTRY(efi_pe_entry)
 
 	/* Relocate efi_config->call() */
 	leal	efi32_config(%esi), %eax
-	add	%esi, 88(%eax)
+	add	%esi, 104(%eax)
 	pushl	%eax
 
 	call	make_boot_params
@@ -80,7 +80,7 @@ ENTRY(efi32_stub_entry)
 
 	/* Relocate efi_config->call() */
 	leal	efi32_config(%esi), %eax
-	add	%esi, 88(%eax)
+	add	%esi, 104(%eax)
 	pushl	%eax
 2:
 	call	efi_main
@@ -230,7 +230,7 @@ relocated:
 #ifdef CONFIG_EFI_STUB
 	.data
 efi32_config:
-	.fill 11,8,0
+	.fill 13,8,0
 	.long efi_call_phys
 	.long 0
 	.byte 0
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index b0c0d16..471b1c1 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -255,7 +255,7 @@ ENTRY(efi_pe_entry)
 	/*
 	 * Relocate efi_config->call().
 	 */
-	addq	%rbp, efi64_config+88(%rip)
+	addq	%rbp, efi64_config+104(%rip)
 
 	movq	%rax, %rdi
 	call	make_boot_params
@@ -275,7 +275,7 @@ handover_entry:
 	 * Relocate efi_config->call().
 	 */
 	movq	efi_config(%rip), %rax
-	addq	%rbp, 88(%rax)
+	addq	%rbp, 104(%rax)
 2:
 	movq	efi_config(%rip), %rdi
 	call	efi_main
@@ -448,14 +448,14 @@ efi_config:
 #ifdef CONFIG_EFI_MIXED
 	.global efi32_config
 efi32_config:
-	.fill	11,8,0
+	.fill	13,8,0
 	.quad	efi64_thunk
 	.byte	0
 #endif
 
 	.global efi64_config
 efi64_config:
-	.fill	11,8,0
+	.fill	13,8,0
 	.quad	efi_call
 	.byte	1
 #endif /* CONFIG_EFI_STUB */
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 155162e..a274aa8 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -175,6 +175,8 @@ struct efi_config {
 	u64 handle_protocol;
 	u64 exit_boot_services;
 	u64 text_output;
+	u64 get_variable;
+	u64 set_variable;
 	efi_status_t (*call)(unsigned long, ...);
 	bool is64;
 } __packed;
-- 
2.1.4
