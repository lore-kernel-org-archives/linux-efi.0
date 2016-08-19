From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 3/6] efi/libstub: Introduce ExitBootServices helper
Date: Fri, 19 Aug 2016 21:35:01 +0100
Message-ID: <1471638904-3494-4-git-send-email-matt@codeblueprint.co.uk>
References: <1471638904-3494-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471638904-3494-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Jeffrey Hugo <jhugo@codeaurora.org>

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

Signed-off-by: Jeffrey Hugo <jhugo@codeaurora.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 72 ++++++++++++++++++++++++++
 include/linux/efi.h                            | 11 ++++
 2 files changed, 83 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index bbb5166e8fd0..ca0a4f9ac1e5 100644
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
index c468010ac245..1f39dd7c600d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1462,4 +1462,15 @@ extern void efi_call_virt_check_flags(unsigned long flags, const char *call);
 	arch_efi_call_virt_teardown();					\
 })
 
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
+
 #endif /* _LINUX_EFI_H */
-- 
2.7.3
