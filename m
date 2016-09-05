From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 4/6] efi/libstub: Introduce ExitBootServices helper
Date: Mon,  5 Sep 2016 15:42:35 +0100
Message-ID: <20160905144237.2361-5-matt@codeblueprint.co.uk>
References: <20160905144237.2361-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160905144237.2361-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

The spec allows ExitBootServices to fail with EFI_INVALID_PARAMETER if a
race condition has occurred where the EFI has updated the memory map after
the stub grabbed a reference to the map.  The spec defines a retry
proceedure with specific requirements to handle this scenario.

This scenario was previously observed on x86 - commit d3768d885c6c ("x86,
efi: retry ExitBootServices() on failure") but the current fix is not spec
compliant and the scenario is now observed on the Qualcomm Technologies
QDF2432 via the FDT stub which does not handle the error and thus causes
boot failures.  The user will notice the boot failure as the kernel is not
executed and the system may drop back to a UEFI shell, but will be
unresponsive to input and the system will require a power cycle to recover.

Add a helper to the stub library that correctly adheres to the spec in the
case of EFI_INVALID_PARAMETER from ExitBootServices and can be universally
used across all stub implementations.

Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 73 ++++++++++++++++++++++++++
 include/linux/efi.h                            | 10 ++++
 2 files changed, 83 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 29368ac69221..aded10662020 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -740,3 +740,76 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
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
+				    struct efi_boot_memmap *map,
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
+		 * exit_boot_services().  Per the UEFI Spec v2.6, Section 6.4:
+		 * EFI_BOOT_SERVICES.ExitBootServices we need to get the
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
+
+		/* exit_boot_services() was called, thus cannot free */
+		if (status != EFI_SUCCESS)
+			goto fail;
+
+		status = priv_func(sys_table_arg, map, priv);
+		/* exit_boot_services() was called, thus cannot free */
+		if (status != EFI_SUCCESS)
+			goto fail;
+
+		status = efi_call_early(exit_boot_services, handle, *map->key_ptr);
+	}
+
+	/* exit_boot_services() was called, thus cannot free */
+	if (status != EFI_SUCCESS)
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
index 943fee524176..0148a3046b48 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1462,4 +1462,14 @@ extern void efi_call_virt_check_flags(unsigned long flags, const char *call);
 	arch_efi_call_virt_teardown();					\
 })
 
+typedef efi_status_t (*efi_exit_boot_map_processing)(
+	efi_system_table_t *sys_table_arg,
+	struct efi_boot_memmap *map,
+	void *priv);
+
+efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
+				    void *handle,
+				    struct efi_boot_memmap *map,
+				    void *priv,
+				    efi_exit_boot_map_processing priv_func);
 #endif /* _LINUX_EFI_H */
-- 
2.9.3
