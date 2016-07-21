From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V2 2/4] efi/libstub: Introduce ExitBootServices helper
Date: Thu, 21 Jul 2016 14:28:12 -0600
Message-ID: <1469132894-17103-3-git-send-email-jhugo@codeaurora.org>
References: <1469132894-17103-1-git-send-email-jhugo@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469132894-17103-1-git-send-email-jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The spec allows ExitBootServices to fail with EFI_INVALID_PARAMETER if a
race condition has occurred where the EFI has updated the memory map after
the stub grabbed a reference to the map.  The spec defines a retry
proceedure with specific requirements to handle this scenario.

No current stub implementation correctly follows the spec in this regard,
so add a helper to the stub library that correctly adhears to the spec and
abstracts the complexity from stubs.

Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 93 ++++++++++++++++++++++++++
 include/linux/efi.h                            | 19 ++++++
 2 files changed, 112 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 3071269..d5be0b5 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -720,3 +720,96 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 	*cmd_line_len = options_bytes;
 	return (char *)cmdline_addr;
 }
+
+/*
+ * Handle calling ExitBootServices according to the requirements set out by the
+ * spec.  Obtains the current memory map, and returns that info after calling
+ * ExitBootServices.  Client has the option to specify a function to process the
+ * memory map data.  A client specific structure may be passed to the function
+ * via priv.  The client function may be called multiple times.
+ */
+efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
+				    void *handle,
+				    efi_memory_desc_t **memory_map,
+				    unsigned long *map_size,
+				    unsigned long *desc_size,
+				    u32 *desc_ver,
+				    unsigned long *mmap_key,
+				    void *priv,
+				    efi_status_t (*priv_func)(
+						efi_system_table_t *sys_table,
+						void *handle,
+						efi_memory_desc_t *memory_map,
+						unsigned long *map_size,
+						unsigned long *desc_size,
+						u32 *desc_ver,
+						unsigned long *mmap_key,
+						unsigned long buff_size,
+						void *priv))
+{
+	efi_status_t status;
+	unsigned long buff_size;
+
+	status = efi_get_memory_map(sys_table, memory_map, map_size,
+				    desc_size, desc_ver, mmap_key, &buff_size);
+
+	if (status != EFI_SUCCESS)
+		goto fail;
+
+	if (priv_func) {
+		status = priv_func(sys_table, handle, *memory_map, map_size,
+				   desc_size, desc_ver, mmap_key, buff_size,
+				   priv);
+		if (status != EFI_SUCCESS)
+			goto free_map;
+	}
+
+	status = sys_table->boottime->exit_boot_services(handle, *mmap_key);
+
+	if (status == EFI_INVALID_PARAMETER) {
+		/*
+		 * The memory map changed between efi_get_memory_map() and
+		 * exit_boot_services().  Per the spec we need to get the
+		 * updated map, and try again.  The spec implies one retry
+		 * should be sufficent, which is confirmed against the EDK2
+		 * implementation.  Per the spec, we can only invoke
+		 * get_memory_map() and exit_boot_services() - we cannot alloc
+		 * so efi_get_memory_map() cannot be used, and we must reuse
+		 * the buffer.  For all practical purposes, the headroom in the
+		 * buffer should account for any changes in the map so the call
+		 * to get_memory_map() is expected to succeed here.
+		 */
+		*map_size = buff_size;
+		status = sys_table->boottime->get_memory_map(map_size,
+							     *memory_map,
+							     mmap_key,
+							     desc_size,
+							     desc_ver);
+		if (status != EFI_SUCCESS)
+			/* exit_boot_services() was called, thus cannot free*/
+			goto fail;
+
+		if (priv_func) {
+			status = priv_func(sys_table, handle, *memory_map,
+					   map_size, desc_size, desc_ver,
+					   mmap_key, buff_size, priv);
+			if (status != EFI_SUCCESS)
+				/* exit_boot_services() called, cannot free*/
+				goto fail;
+		}
+
+		status = sys_table->boottime->exit_boot_services(handle,
+								 *mmap_key);
+	}
+
+	if (status != EFI_SUCCESS)
+		/* exit_boot_services() was called, thus cannot free*/
+		goto fail;
+
+	return EFI_SUCCESS;
+
+free_map:
+	sys_table->boottime->free_pool(*memory_map);
+fail:
+	return status;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c47fc5f..96f7b74 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1466,4 +1466,23 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
 			   unsigned long size);
 
 bool efi_runtime_disabled(void);
+
+efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
+				    void *handle,
+				    efi_memory_desc_t **memory_map,
+				    unsigned long *map_size,
+				    unsigned long *desc_size,
+				    u32 *desc_ver,
+				    unsigned long *mmap_key,
+				    void *priv,
+				    efi_status_t (*priv_func)(
+						efi_system_table_t *sys_table,
+						void *handle,
+						efi_memory_desc_t *memory_map,
+						unsigned long *map_size,
+						unsigned long *desc_size,
+						u32 *desc_ver,
+						unsigned long *mmap_key,
+						unsigned long buff_size,
+						void *priv));
 #endif /* _LINUX_EFI_H */
-- 
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
