From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] x86_64/efi: enforce 32 bit address for command line buffer
Date: Tue, 14 Apr 2015 17:45:52 -0700
Message-ID: <1429058752-13478-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The boot_params structure has a 32 bit field for storing the address of
the kernel command line.  When the EFI stub allocates memory for the command
line, it allocates at as low and address as possible, but does not ensure
that the address of memory allocated is below 4G.
This patch enforces this limit, and the stub now returns an error if the
command line buffer is allocated at too high of an address.
For 32 bit systems, the EFI mandated 1-1 memory mapping ensures
that all memory is 32 bit addressable, so we don't have a problem.
Also, mixed-mode booting on EFI platforms does not use the stub
code, so we don't need to handle the case of booting a 32 bit
kernel on a 64 bit EFI platform.

Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ef17683..82dbe27 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1108,6 +1108,19 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	cmdline_ptr = efi_convert_cmdline(sys_table, image, &options_size);
 	if (!cmdline_ptr)
 		goto fail;
+
+#ifdef CONFIG_X86_64
+	/*
+	 * hdr->cmd_line_ptr is a 32 bit field, so on 64 bit systems we need
+	 * to ensure that the allocated buffer for the commandline is 32 bit
+	 * addressable.
+	  */
+	if ((u64)(cmdline_ptr) + options_size > (u64)U32_MAX) {
+		efi_printk(sys_table, "Failed to alloc lowmem for command line\n");
+		efi_free(sys_table, options_size, (unsigned long)cmdline_ptr);
+		goto fail;
+	}
+#endif /* CONFIG_X86_64 */
 	hdr->cmd_line_ptr = (unsigned long)cmdline_ptr;
 
 	hdr->ramdisk_image = 0;
-- 
1.9.1
