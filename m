From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] x86: move parse_early_param to earlier code for
 add_efi_memmap
Date: Thu, 30 Nov 2017 13:23:27 +0800
Message-ID: <20171130052327.GA3500@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
List-Id: linux-efi@vger.kernel.org

'add_efi_memmap' is an early param, but do_add_efi_memmap() has no
chance to run because the code path is before parse_early_param().
I believe it worked when the param was introduced but probably later
some other changes caused the wrong order and nobody noticed it.

Move parse_early_param before efi_memblock_x86_reserve_range to fix
this.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/setup.c |   55 ++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

--- linux-x86.orig/arch/x86/kernel/setup.c
+++ linux-x86/arch/x86/kernel/setup.c
@@ -897,6 +897,34 @@ void __init setup_arch(char **cmdline_p)
 	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
+
+#ifdef CONFIG_CMDLINE_BOOL
+#ifdef CONFIG_CMDLINE_OVERRIDE
+	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+#else
+	if (builtin_cmdline[0]) {
+		/* append boot loader cmdline to builtin */
+		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
+		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+	}
+#endif
+#endif
+
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = command_line;
+
+	/*
+	 * x86_configure_nx() is called before parse_early_param() to detect
+	 * whether hardware doesn't support NX (so that the early EHCI debug
+	 * console setup can safely call set_fixmap()). It may then be called
+	 * again from within noexec_setup() during parsing early parameters
+	 * to honor the respective command line option.
+	 */
+	x86_configure_nx();
+
+	parse_early_param();
+
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
 		     EFI32_LOADER_SIGNATURE, 4)) {
@@ -935,33 +963,6 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = __pa_symbol(__bss_start);
 	bss_resource.end = __pa_symbol(__bss_stop)-1;
 
-#ifdef CONFIG_CMDLINE_BOOL
-#ifdef CONFIG_CMDLINE_OVERRIDE
-	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
-#else
-	if (builtin_cmdline[0]) {
-		/* append boot loader cmdline to builtin */
-		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
-		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
-		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
-	}
-#endif
-#endif
-
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
-
-	/*
-	 * x86_configure_nx() is called before parse_early_param() to detect
-	 * whether hardware doesn't support NX (so that the early EHCI debug
-	 * console setup can safely call set_fixmap()). It may then be called
-	 * again from within noexec_setup() during parsing early parameters
-	 * to honor the respective command line option.
-	 */
-	x86_configure_nx();
-
-	parse_early_param();
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/*
 	 * Memory used by the kernel cannot be hot-removed because Linux
