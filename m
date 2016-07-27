From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V3 4/4] x86/efi: Use efi_exit_boot_services()
Date: Wed, 27 Jul 2016 11:42:25 -0600
Message-ID: <1469641345-17739-5-git-send-email-jhugo@codeaurora.org>
References: <1469641345-17739-1-git-send-email-jhugo@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469641345-17739-1-git-send-email-jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The eboot code directly calls ExitBootServices.  This is inadvisable, and
the eboot code attempts allocations after calling ExitBootSerives which is
not permitted per the spec.  The efi_exit_boot_services() helper handles
this scenario.

Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 130 ++++++++++++++++++++-------------------
 1 file changed, 67 insertions(+), 63 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 9036ec9..3d3224d 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1006,79 +1006,87 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 	return status;
 }
 
+struct exit_boot_struct {
+	struct boot_params *boot_params;
+	struct efi_info *efi;
+	struct setup_data *e820ext;
+	__u32 e820ext_size;
+	bool is64;
+};
+
+static efi_status_t exit_boot_func(efi_system_table_t *sys_table,
+				   void *handle,
+				   efi_memory_desc_t *memory_map,
+				   unsigned long *map_size,
+				   unsigned long *desc_size,
+				   u32 *desc_ver,
+				   unsigned long *mmap_key,
+				   unsigned long buff_size,
+				   void *priv)
+{
+	static bool first = true;
+	const char *signature;
+	__u32 nr_desc;
+	efi_status_t status;
+	struct exit_boot_struct *p = priv;
+
+	if (first) {
+		nr_desc = buff_size / *desc_size;
+		if (nr_desc > ARRAY_SIZE(p->boot_params->e820_map)) {
+			u32 nr_e820ext = nr_desc -
+					ARRAY_SIZE(p->boot_params->e820_map);
+
+			status = alloc_e820ext(nr_e820ext, &p->e820ext,
+					       &p->e820ext_size);
+			if (status != EFI_SUCCESS)
+				return status;
+		}
+		first = false;
+	}
+
+	signature = p->is64 ? EFI64_LOADER_SIGNATURE : EFI32_LOADER_SIGNATURE;
+	memcpy(&p->efi->efi_loader_signature, signature, sizeof(__u32));
+
+	p->efi->efi_systab = (unsigned long)sys_table;
+	p->efi->efi_memdesc_size = *desc_size;
+	p->efi->efi_memdesc_version = *desc_ver;
+	p->efi->efi_memmap = (unsigned long)memory_map;
+	p->efi->efi_memmap_size = *map_size;
+
+#ifdef CONFIG_X86_64
+	p->efi->efi_systab_hi = (unsigned long)sys_table >> 32;
+	p->efi->efi_memmap_hi = (unsigned long)memory_map >> 32;
+#endif
+
+	return EFI_SUCCESS;
+}
+
 static efi_status_t exit_boot(struct boot_params *boot_params,
 			      void *handle, bool is64)
 {
-	struct efi_info *efi = &boot_params->efi_info;
 	unsigned long map_sz, key, desc_size, buff_size;
 	efi_memory_desc_t *mem_map;
 	struct setup_data *e820ext;
-	const char *signature;
 	__u32 e820ext_size;
-	__u32 nr_desc, prev_nr_desc;
 	efi_status_t status;
 	__u32 desc_version;
-	bool called_exit = false;
-	u8 nr_entries;
-	int i;
-
-	nr_desc = 0;
-	e820ext = NULL;
-	e820ext_size = 0;
+	struct exit_boot_struct priv;
 
-get_map:
-	status = efi_get_memory_map(sys_table, &mem_map, &map_sz, &desc_size,
-				    &desc_version, &key, &buff_size);
+	priv.boot_params = boot_params;
+	priv.efi = &boot_params->efi_info;
+	priv.e820ext = NULL;
+	priv.e820ext_size = 0;
+	priv.is64 = is64;
 
+	/* Might as well exit boot services now */
+	status = efi_exit_boot_services(sys_table, handle, &mem_map,
+					&map_sz, &desc_size, &desc_version,
+					&key, &priv, exit_boot_func);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	prev_nr_desc = nr_desc;
-	nr_desc = map_sz / desc_size;
-	if (nr_desc > prev_nr_desc &&
-	    nr_desc > ARRAY_SIZE(boot_params->e820_map)) {
-		u32 nr_e820ext = nr_desc - ARRAY_SIZE(boot_params->e820_map);
-
-		status = alloc_e820ext(nr_e820ext, &e820ext, &e820ext_size);
-		if (status != EFI_SUCCESS)
-			goto free_mem_map;
-
-		efi_call_early(free_pool, mem_map);
-		goto get_map; /* Allocated memory, get map again */
-	}
-
-	signature = is64 ? EFI64_LOADER_SIGNATURE : EFI32_LOADER_SIGNATURE;
-	memcpy(&efi->efi_loader_signature, signature, sizeof(__u32));
-
-	efi->efi_systab = (unsigned long)sys_table;
-	efi->efi_memdesc_size = desc_size;
-	efi->efi_memdesc_version = desc_version;
-	efi->efi_memmap = (unsigned long)mem_map;
-	efi->efi_memmap_size = map_sz;
-
-#ifdef CONFIG_X86_64
-	efi->efi_systab_hi = (unsigned long)sys_table >> 32;
-	efi->efi_memmap_hi = (unsigned long)mem_map >> 32;
-#endif
-
-	/* Might as well exit boot services now */
-	status = efi_call_early(exit_boot_services, handle, key);
-	if (status != EFI_SUCCESS) {
-		/*
-		 * ExitBootServices() will fail if any of the event
-		 * handlers change the memory map. In which case, we
-		 * must be prepared to retry, but only once so that
-		 * we're guaranteed to exit on repeated failures instead
-		 * of spinning forever.
-		 */
-		if (called_exit)
-			goto free_mem_map;
-
-		called_exit = true;
-		efi_call_early(free_pool, mem_map);
-		goto get_map;
-	}
-
+	e820ext = priv.e820ext;
+	e820ext_size = priv.e820ext_size;
 	/* Historic? */
 	boot_params->alt_mem_k = 32 * 1024;
 
@@ -1087,10 +1095,6 @@ get_map:
 		return status;
 
 	return EFI_SUCCESS;
-
-free_mem_map:
-	efi_call_early(free_pool, mem_map);
-	return status;
 }
 
 /*
-- 
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
