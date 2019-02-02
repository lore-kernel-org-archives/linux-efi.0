From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 05/10] efi/fdt: More cleanups
Date: Sat,  2 Feb 2019 10:41:14 +0100
Message-ID: <20190202094119.13230-6-ard.biesheuvel@linaro.org>
References: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Alexander Graf <agraf@suse.de>, Bjorn Andersson <bjorn.andersson@linaro.org>, Borislav Petkov <bp@alien8.de>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jeffrey Hugo <jhugo@codeaurora.org>, Lee Jones <lee.jones@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Apply a number of cleanups:

 - Introduce fdt_setprop_*var() helper macros to simplify and shorten repetitive
   sequences - this also makes it less likely that the wrong variable size is
   passed in. This change makes a lot of the property-setting calls single-line
   and easier to read.

 - Harmonize comment style: capitalization, punctuation, whitespaces, etc.

 - Fix some whitespace noise in the libstub Makefile which I happened to notice.

 - Use the standard tabular initialization style:

    -       map.map =       &runtime_map;
    -       map.map_size =  &map_size;
    -       map.desc_size = &desc_size;
    -       map.desc_ver =  &desc_ver;
    -       map.key_ptr =   &mmap_key;
    -       map.buff_size = &buff_size;

    +       map.map         = &runtime_map;
    +       map.map_size    = &map_size;
    +       map.desc_size   = &desc_size;
    +       map.desc_ver    = &desc_ver;
    +       map.key_ptr     = &mmap_key;
    +       map.buff_size   = &buff_size;

 - Use tabular structure definition for better readability.

 - Make all pr*() lines single-line, even if they marginally exceed 80 cols - this
   makes them visually less intrusive.

 - Unbreak line breaks into single lines when the length exceeds 80 cols only
   marginally, for better readability.

 - Move assignment closer to the actual usage site.

 - Plus some other smaller cleanups, spelling fixes, etc.

No change in functionality intended.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ardb: move changes to upstream libfdt into local header]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/Makefile  |   4 +-
 drivers/firmware/efi/libstub/efistub.h |  11 +++
 drivers/firmware/efi/libstub/fdt.c     | 107 ++++++++++++-------------
 3 files changed, 64 insertions(+), 58 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d9845099635e..b0103e16fc1b 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -52,7 +52,7 @@ lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o random.o \
 
 lib-$(CONFIG_ARM)		+= arm32-stub.o
 lib-$(CONFIG_ARM64)		+= arm64-stub.o
-CFLAGS_arm64-stub.o 		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
+CFLAGS_arm64-stub.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 #
 # arm64 puts the stub in the kernel proper, which will unnecessarily retain all
@@ -89,7 +89,7 @@ quiet_cmd_stubcopy = STUBCPY $@
       cmd_stubcopy = if $(STRIP) --strip-debug $(STUBCOPY_RM-y) -o $@ $<; \
 		     then if $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y); \
 		     then (echo >&2 "$@: absolute symbol references not allowed in the EFI stub"; \
-			   rm -f $@; /bin/false); 			  \
+			   rm -f $@; /bin/false);			  \
 		     else $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; fi	  \
 		     else /bin/false; fi
 
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 32799cf039ef..cefcf6ba3150 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -64,4 +64,15 @@ efi_status_t check_platform_features(efi_system_table_t *sys_table_arg);
 
 efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg);
 
+/* Helper macros for the usual case of using simple C variables: */
+#ifndef fdt_setprop_inplace_var
+#define fdt_setprop_inplace_var(fdt, node_offset, name, var) \
+	fdt_setprop_inplace((fdt), (node_offset), (name), &(var), sizeof(var))
+#endif
+
+#ifndef fdt_setprop_var
+#define fdt_setprop_var(fdt, node_offset, name, var) \
+	fdt_setprop((fdt), (node_offset), (name), &(var), sizeof(var))
+#endif
+
 #endif
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 0dc7b4987cc2..d474964b873b 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -26,10 +26,8 @@ static void fdt_update_cell_size(efi_system_table_t *sys_table, void *fdt)
 	offset = fdt_path_offset(fdt, "/");
 	/* Set the #address-cells and #size-cells values for an empty tree */
 
-	fdt_setprop_u32(fdt, offset, "#address-cells",
-			EFI_DT_ADDR_CELLS_DEFAULT);
-
-	fdt_setprop_u32(fdt, offset, "#size-cells", EFI_DT_SIZE_CELLS_DEFAULT);
+	fdt_setprop_u32(fdt, offset, "#address-cells", EFI_DT_ADDR_CELLS_DEFAULT);
+	fdt_setprop_u32(fdt, offset, "#size-cells",    EFI_DT_SIZE_CELLS_DEFAULT);
 }
 
 static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
@@ -42,7 +40,7 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	u32 fdt_val32;
 	u64 fdt_val64;
 
-	/* Do some checks on provided FDT, if it exists*/
+	/* Do some checks on provided FDT, if it exists: */
 	if (orig_fdt) {
 		if (fdt_check_header(orig_fdt)) {
 			pr_efi_err(sys_table, "Device Tree header not valid!\n");
@@ -50,7 +48,7 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 		}
 		/*
 		 * We don't get the size of the FDT if we get if from a
-		 * configuration table.
+		 * configuration table:
 		 */
 		if (orig_fdt_size && fdt_totalsize(orig_fdt) > orig_fdt_size) {
 			pr_efi_err(sys_table, "Truncated device tree! foo!\n");
@@ -64,8 +62,8 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 		status = fdt_create_empty_tree(fdt, new_fdt_size);
 		if (status == 0) {
 			/*
-			 * Any failure from the following function is non
-			 * critical
+			 * Any failure from the following function is
+			 * non-critical:
 			 */
 			fdt_update_cell_size(sys_table, fdt);
 		}
@@ -86,12 +84,13 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	if (node < 0) {
 		node = fdt_add_subnode(fdt, 0, "chosen");
 		if (node < 0) {
-			status = node; /* node is error code when negative */
+			/* 'node' is an error code when negative: */
+			status = node;
 			goto fdt_set_fail;
 		}
 	}
 
-	if ((cmdline_ptr != NULL) && (strlen(cmdline_ptr) > 0)) {
+	if (cmdline_ptr != NULL && strlen(cmdline_ptr) > 0) {
 		status = fdt_setprop(fdt, node, "bootargs", cmdline_ptr,
 				     strlen(cmdline_ptr) + 1);
 		if (status)
@@ -103,13 +102,12 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 		u64 initrd_image_end;
 		u64 initrd_image_start = cpu_to_fdt64(initrd_addr);
 
-		status = fdt_setprop(fdt, node, "linux,initrd-start",
-				     &initrd_image_start, sizeof(u64));
+		status = fdt_setprop_var(fdt, node, "linux,initrd-start", initrd_image_start);
 		if (status)
 			goto fdt_set_fail;
+
 		initrd_image_end = cpu_to_fdt64(initrd_addr + initrd_size);
-		status = fdt_setprop(fdt, node, "linux,initrd-end",
-				     &initrd_image_end, sizeof(u64));
+		status = fdt_setprop_var(fdt, node, "linux,initrd-end", initrd_image_end);
 		if (status)
 			goto fdt_set_fail;
 	}
@@ -117,30 +115,28 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	/* Add FDT entries for EFI runtime services in chosen node. */
 	node = fdt_subnode_offset(fdt, 0, "chosen");
 	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)sys_table);
-	status = fdt_setprop(fdt, node, "linux,uefi-system-table",
-			     &fdt_val64, sizeof(fdt_val64));
+
+	status = fdt_setprop_var(fdt, node, "linux,uefi-system-table", fdt_val64);
 	if (status)
 		goto fdt_set_fail;
 
 	fdt_val64 = U64_MAX; /* placeholder */
-	status = fdt_setprop(fdt, node, "linux,uefi-mmap-start",
-			     &fdt_val64,  sizeof(fdt_val64));
+
+	status = fdt_setprop_var(fdt, node, "linux,uefi-mmap-start", fdt_val64);
 	if (status)
 		goto fdt_set_fail;
 
 	fdt_val32 = U32_MAX; /* placeholder */
-	status = fdt_setprop(fdt, node, "linux,uefi-mmap-size",
-			     &fdt_val32,  sizeof(fdt_val32));
+
+	status = fdt_setprop_var(fdt, node, "linux,uefi-mmap-size", fdt_val32);
 	if (status)
 		goto fdt_set_fail;
 
-	status = fdt_setprop(fdt, node, "linux,uefi-mmap-desc-size",
-			     &fdt_val32, sizeof(fdt_val32));
+	status = fdt_setprop_var(fdt, node, "linux,uefi-mmap-desc-size", fdt_val32);
 	if (status)
 		goto fdt_set_fail;
 
-	status = fdt_setprop(fdt, node, "linux,uefi-mmap-desc-ver",
-			     &fdt_val32, sizeof(fdt_val32));
+	status = fdt_setprop_var(fdt, node, "linux,uefi-mmap-desc-ver", fdt_val32);
 	if (status)
 		goto fdt_set_fail;
 
@@ -150,8 +146,7 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 		efi_status = efi_get_random_bytes(sys_table, sizeof(fdt_val64),
 						  (u8 *)&fdt_val64);
 		if (efi_status == EFI_SUCCESS) {
-			status = fdt_setprop(fdt, node, "kaslr-seed",
-					     &fdt_val64, sizeof(fdt_val64));
+			status = fdt_setprop_var(fdt, node, "kaslr-seed", fdt_val64);
 			if (status)
 				goto fdt_set_fail;
 		} else if (efi_status != EFI_NOT_FOUND) {
@@ -159,7 +154,7 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 		}
 	}
 
-	/* shrink the FDT back to its minimum size */
+	/* Shrink the FDT back to its minimum size: */
 	fdt_pack(fdt);
 
 	return EFI_SUCCESS;
@@ -182,26 +177,26 @@ static efi_status_t update_fdt_memmap(void *fdt, struct efi_boot_memmap *map)
 		return EFI_LOAD_ERROR;
 
 	fdt_val64 = cpu_to_fdt64((unsigned long)*map->map);
-	err = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-start",
-				  &fdt_val64, sizeof(fdt_val64));
+
+	err = fdt_setprop_inplace_var(fdt, node, "linux,uefi-mmap-start", fdt_val64);
 	if (err)
 		return EFI_LOAD_ERROR;
 
 	fdt_val32 = cpu_to_fdt32(*map->map_size);
-	err = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-size",
-				  &fdt_val32, sizeof(fdt_val32));
+
+	err = fdt_setprop_inplace_var(fdt, node, "linux,uefi-mmap-size", fdt_val32);
 	if (err)
 		return EFI_LOAD_ERROR;
 
 	fdt_val32 = cpu_to_fdt32(*map->desc_size);
-	err = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-desc-size",
-				  &fdt_val32, sizeof(fdt_val32));
+
+	err = fdt_setprop_inplace_var(fdt, node, "linux,uefi-mmap-desc-size", fdt_val32);
 	if (err)
 		return EFI_LOAD_ERROR;
 
 	fdt_val32 = cpu_to_fdt32(*map->desc_ver);
-	err = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-desc-ver",
-				  &fdt_val32, sizeof(fdt_val32));
+
+	err = fdt_setprop_inplace_var(fdt, node, "linux,uefi-mmap-desc-ver", fdt_val32);
 	if (err)
 		return EFI_LOAD_ERROR;
 
@@ -209,13 +204,13 @@ static efi_status_t update_fdt_memmap(void *fdt, struct efi_boot_memmap *map)
 }
 
 #ifndef EFI_FDT_ALIGN
-#define EFI_FDT_ALIGN EFI_PAGE_SIZE
+# define EFI_FDT_ALIGN EFI_PAGE_SIZE
 #endif
 
 struct exit_boot_struct {
-	efi_memory_desc_t *runtime_map;
-	int *runtime_entry_count;
-	void *new_fdt_addr;
+	efi_memory_desc_t	*runtime_map;
+	int			*runtime_entry_count;
+	void			*new_fdt_addr;
 };
 
 static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
@@ -235,7 +230,7 @@ static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
 }
 
 #ifndef MAX_FDT_SIZE
-#define MAX_FDT_SIZE	SZ_2M
+# define MAX_FDT_SIZE SZ_2M
 #endif
 
 /*
@@ -266,16 +261,16 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	unsigned long mmap_key;
 	efi_memory_desc_t *memory_map, *runtime_map;
 	efi_status_t status;
-	int runtime_entry_count = 0;
+	int runtime_entry_count;
 	struct efi_boot_memmap map;
 	struct exit_boot_struct priv;
 
-	map.map =	&runtime_map;
-	map.map_size =	&map_size;
-	map.desc_size =	&desc_size;
-	map.desc_ver =	&desc_ver;
-	map.key_ptr =	&mmap_key;
-	map.buff_size =	&buff_size;
+	map.map		= &runtime_map;
+	map.map_size	= &map_size;
+	map.desc_size	= &desc_size;
+	map.desc_ver	= &desc_ver;
+	map.key_ptr	= &mmap_key;
+	map.buff_size	= &buff_size;
 
 	/*
 	 * Get a copy of the current memory map that we will use to prepare
@@ -289,15 +284,13 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 		return status;
 	}
 
-	pr_efi(sys_table,
-	       "Exiting boot services and installing virtual address map...\n");
+	pr_efi(sys_table, "Exiting boot services and installing virtual address map...\n");
 
 	map.map = &memory_map;
 	status = efi_high_alloc(sys_table, MAX_FDT_SIZE, EFI_FDT_ALIGN,
 				new_fdt_addr, max_addr);
 	if (status != EFI_SUCCESS) {
-		pr_efi_err(sys_table,
-			   "Unable to allocate memory for new device tree.\n");
+		pr_efi_err(sys_table, "Unable to allocate memory for new device tree.\n");
 		goto fail;
 	}
 
@@ -318,11 +311,12 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 		goto fail_free_new_fdt;
 	}
 
-	priv.runtime_map = runtime_map;
-	priv.runtime_entry_count = &runtime_entry_count;
-	priv.new_fdt_addr = (void *)*new_fdt_addr;
-	status = efi_exit_boot_services(sys_table, handle, &map, &priv,
-					exit_boot_func);
+	runtime_entry_count		= 0;
+	priv.runtime_map		= runtime_map;
+	priv.runtime_entry_count	= &runtime_entry_count;
+	priv.new_fdt_addr		= (void *)*new_fdt_addr;
+
+	status = efi_exit_boot_services(sys_table, handle, &map, &priv, exit_boot_func);
 
 	if (status == EFI_SUCCESS) {
 		efi_set_virtual_address_map_t *svam;
@@ -363,6 +357,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 
 fail:
 	sys_table->boottime->free_pool(runtime_map);
+
 	return EFI_LOAD_ERROR;
 }
 
-- 
2.17.1
