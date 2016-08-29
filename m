From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V5 4/4] x86/efi: Use efi_exit_boot_services()
Date: Mon, 29 Aug 2016 14:38:54 -0600
Message-ID: <1472503134-23057-5-git-send-email-jhugo@codeaurora.org>
References: <1472503134-23057-1-git-send-email-jhugo@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472503134-23057-1-git-send-email-jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The eboot code directly calls ExitBootServices.  This is inadvisable as the
UEFI spec details a complex set of errors, race conditions, and API
interactions that the caller of ExitBootServices must get correct.  The
eboot code attempts allocations after calling ExitBootSerives which is
not permitted per the spec.  Call the efi_exit_boot_services() helper
intead, which handles the allocation scenario properly.

Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 136 +++++++++++++++++++--------------------
 1 file changed, 67 insertions(+), 69 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index eb36fe0..a34da5b 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1006,85 +1006,87 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
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
+static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
+				   struct efi_boot_memmap *map,
+				   void *priv)
+{
+	static bool first = true;
+	const char *signature;
+	__u32 nr_desc;
+	efi_status_t status;
+	struct exit_boot_struct *p = priv;
+
+	if (first) {
+		nr_desc = *map->buff_size / *map->desc_size;
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
+	p->efi->efi_systab = (unsigned long)sys_table_arg;
+	p->efi->efi_memdesc_size = *map->desc_size;
+	p->efi->efi_memdesc_version = *map->desc_ver;
+	p->efi->efi_memmap = (unsigned long)*map->map;
+	p->efi->efi_memmap_size = *map->map_size;
+
+#ifdef CONFIG_X86_64
+	p->efi->efi_systab_hi = (unsigned long)sys_table_arg >> 32;
+	p->efi->efi_memmap_hi = (unsigned long)*map->map >> 32;
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
 	struct efi_boot_memmap map;
+	struct exit_boot_struct priv;
+
+	map.map =		&mem_map;
+	map.map_size =		&map_sz;
+	map.desc_size =		&desc_size;
+	map.desc_ver =		&desc_version;
+	map.key_ptr =		&key;
+	map.buff_size =		&buff_size;
+	priv.boot_params =	boot_params;
+	priv.efi =		&boot_params->efi_info;
+	priv.e820ext =		NULL;
+	priv.e820ext_size =	0;
+	priv.is64 =		is64;
 
-	nr_desc =	0;
-	e820ext =	NULL;
-	e820ext_size =	0;
-	map.map =	&mem_map;
-	map.map_size =	&map_sz;
-	map.desc_size =	&desc_size;
-	map.desc_ver =	&desc_version;
-	map.key_ptr =	&key;
-	map.buff_size =	&buff_size;
-
-get_map:
-	status = efi_get_memory_map(sys_table, &map);
-
+	/* Might as well exit boot services now */
+	status = efi_exit_boot_services(sys_table, handle, &map, &priv,
+					exit_boot_func);
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
 
@@ -1093,10 +1095,6 @@ get_map:
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
