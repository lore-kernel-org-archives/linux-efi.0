From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V4 2/4] efi/libstub: Introduce ExitBootServices helper
Date: Mon, 15 Aug 2016 13:22:11 -0600
Message-ID: <1471288933-31810-3-git-send-email-jhugo@codeaurora.org>
References: <1471288933-31810-1-git-send-email-jhugo@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471288933-31810-1-git-send-email-jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The spec allows ExitBootServices to fail with EFI_INVALID_PARAMETER if a
race condition has occurred where the EFI has updated the memory map after
the stub grabbed a reference to the map.  The spec defines a retry
proceedure with specific requirements to handle this scenario.

This scenario was previously observed on x86 - commit d3768d885c6c ("x86,
efi: retry ExitBootServices() on failure") but the current fix is not spec
compliant and the scenario is now observed on the Qualcomm Technologies
QDF2432 via the FDT stub which does not handle the error and thus causes
boot failures.

Add a helper to the stub library that correctly adhears to the spec in the
case of EFI_INVALID_PARAMETER from ExitBootServices and can be universally
used across all stub implementations.

Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 72 ++++++++++++++++++++++++++
 include/linux/efi.h                            | 11 ++++
 2 files changed, 83 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index bbb5166..ca0a4f9 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -740,3 +740,75 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 	*cmd_line_len = options_bytes;
 	return (char *)cmdline_addr;
 }
+
+/*
+ * Handle calling ExitBootServices according to the requirements set out by the
+ * spec.  Obtains the current memory map, and returns that info after calling
+ * ExitBootServices.  The client must specify a function to perform any
+ * processing of the memory map data prior to ExitBootServices.  A client
+ * specific structure may be passed to the function via priv.  The client
+ * function may be called multiple times.
+ */
+efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table_arg,
+				    void *handle,
+				    efi_boottime_memory_map_t *map,
+				    void *priv,
+				    efi_exit_boot_map_processing priv_func)
+{
+	efi_status_t status;
+
+	status = efi_get_memory_map(sys_table_arg, map);
+
+	if (status != EFI_SUCCESS)
+		goto fail;
+
+	status = priv_func(sys_table_arg, map, priv);
+	if (status != EFI_SUCCESS)
+		goto free_map;
+
+	status = efi_call_early(exit_boot_services, handle, *map->key_ptr);
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
+		*map->map_size = *map->buff_size;
+		status = efi_call_early(get_memory_map,
+					map->map_size,
+					*map->map,
+					map->key_ptr,
+					map->desc_size,
+					map->desc_ver);
+		if (status != EFI_SUCCESS)
+			/* exit_boot_services() was called, thus cannot free*/
+			goto fail;
+
+		status = priv_func(sys_table_arg, map, priv);
+		if (status != EFI_SUCCESS)
+			/* exit_boot_services() was called, thus cannot free*/
+			goto fail;
+
+		status = efi_call_early(exit_boot_services, handle,
+					*map->key_ptr);
+	}
+
+	if (status != EFI_SUCCESS)
+		/* exit_boot_services() was called, thus cannot free*/
+		goto fail;
+
+	return EFI_SUCCESS;
+
+free_map:
+	efi_call_early(free_pool, *map->map);
+fail:
+	return status;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 61400a1..65eca9a 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1470,4 +1470,15 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
 			   unsigned long size);
 
 bool efi_runtime_disabled(void);
+
+typedef efi_status_t (*efi_exit_boot_map_processing)(
+	efi_system_table_t *sys_table_arg,
+	efi_boottime_memory_map_t *map,
+	void *priv);
+
+efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
+				    void *handle,
+				    efi_boottime_memory_map_t *map,
+				    void *priv,
+				    efi_exit_boot_map_processing priv_func);
 #endif /* _LINUX_EFI_H */
-- 
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
