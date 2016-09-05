From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 6/6] x86/efi: Use efi_exit_boot_services()
Date: Mon,  5 Sep 2016 15:42:37 +0100
Message-ID: <20160905144237.2361-7-matt@codeblueprint.co.uk>
References: <20160905144237.2361-1-matt@codeblueprint.co.uk>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160905144237.2361-1-matt@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Jeffrey Hugo <jhugo@codeaurora.org>

The eboot code directly calls ExitBootServices.  This is inadvisable as the
UEFI spec details a complex set of errors, race conditions, and API
interactions that the caller of ExitBootServices must get correct.  The
eboot code attempts allocations after calling ExitBootSerives which is
not permitted per the spec.  Call the efi_exit_boot_services() helper
intead, which handles the allocation scenario properly.

Signed-off-by: Jeffrey Hugo <jhugo@codeaurora.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/boot/compressed/eboot.c | 136 +++++++++++++++++++--------------------
 1 file changed, 67 insertions(+), 69 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index c5b7c7b4f0d7..94dd4a31f5b3 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1004,85 +1004,87 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
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
 
@@ -1091,10 +1093,6 @@ get_map:
 		return status;
 
 	return EFI_SUCCESS;
-
-free_mem_map:
-	efi_call_early(free_pool, mem_map);
-	return status;
 }
 
 /*
-- 
2.9.3
