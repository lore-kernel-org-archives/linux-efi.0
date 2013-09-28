From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/6] Add shared update_fdt() function for ARM/ARM64
Date: Sat, 28 Sep 2013 09:23:19 -0700
Message-ID: <1380385403-31904-3-git-send-email-roy.franz@linaro.org>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380385403-31904-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Both ARM and ARM64 stubs will update the device tree
that they pass to the kernel.  In both cases they
primarily need to add the same UEFI related information,
so the function can be shared.

Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   86 ++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index cc0581d..d3448a9 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -4,6 +4,7 @@
  * implementation files.
  *
  * Copyright 2011 Intel Corporation; author Matt Fleming
+ * Copyright 2013 Linaro Limited; author Roy Franz
  *
  * This file is part of the Linux kernel, and is made available
  * under the terms of the GNU General Public License version 2.
@@ -636,3 +637,88 @@ static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
 	*cmd_line_len = options_size;
 	return (char *)cmdline_addr;
 }
+
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
+static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
+			       void *fdt, int new_fdt_size, char *cmdline_ptr,
+			       u64 initrd_addr, u64 initrd_size,
+			       efi_memory_desc_t *memory_map,
+			       unsigned long map_size, unsigned long desc_size,
+			       u32 desc_ver)
+{
+	int node;
+	int status;
+	u32 fdt_val32;
+	u64 fdt_val64;
+
+	status = fdt_open_into(orig_fdt, fdt, new_fdt_size);
+	if (status != 0)
+		goto fdt_set_fail;
+
+	node = fdt_subnode_offset(fdt, 0, "chosen");
+	if (node < 0) {
+		node = fdt_add_subnode(fdt, 0, "chosen");
+		if (node < 0) {
+			status = node; /* node is error code when negative */
+			goto fdt_set_fail;
+		}
+	}
+
+	if ((cmdline_ptr != NULL) && (strlen(cmdline_ptr) > 0)) {
+		status = fdt_setprop(fdt, node, "bootargs", cmdline_ptr,
+				     strlen(cmdline_ptr) + 1);
+		if (status)
+			goto fdt_set_fail;
+	}
+
+	/* Set intird address/end in device tree, if present */
+	if (initrd_size != 0) {
+		u64 initrd_image_end;
+		u64 initrd_image_start = cpu_to_fdt64(initrd_addr);
+		status = fdt_setprop(fdt, node, "linux,initrd-start",
+				     &initrd_image_start, sizeof(u64));
+		if (status)
+			goto fdt_set_fail;
+		initrd_image_end = cpu_to_fdt64(initrd_addr + initrd_size);
+		status = fdt_setprop(fdt, node, "linux,initrd-end",
+				     &initrd_image_end, sizeof(u64));
+		if (status)
+			goto fdt_set_fail;
+	}
+
+	/* Add FDT entries for EFI runtime services in chosen node. */
+	node = fdt_subnode_offset(fdt, 0, "chosen");
+	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)sys_table);
+	status = fdt_setprop(fdt, node, "linux,efi-system-table",
+			     &fdt_val64, sizeof(fdt_val64));
+	if (status)
+		goto fdt_set_fail;
+
+	fdt_val32 = cpu_to_fdt32(desc_size);
+	status = fdt_setprop(fdt, node, "linux,efi-mmap-desc-size",
+			     &fdt_val32, sizeof(fdt_val32));
+	if (status)
+		goto fdt_set_fail;
+
+	fdt_val32 = cpu_to_fdt32(desc_ver);
+	status = fdt_setprop(fdt, node, "linux,efi-mmap-desc-version",
+			     &fdt_val32, sizeof(fdt_val32));
+	if (status)
+		goto fdt_set_fail;
+
+
+	/* Stuff the whole memory map into FDT */
+	status = fdt_setprop(fdt, node, "linux,efi-mmap",
+			     memory_map, map_size);
+	if (status)
+		goto fdt_set_fail;
+
+	return EFI_SUCCESS;
+
+fdt_set_fail:
+	if (status == -FDT_ERR_NOSPACE)
+		return EFI_BUFFER_TOO_SMALL;
+
+	return EFI_LOAD_ERROR;
+}
+#endif
-- 
1.7.10.4
