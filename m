From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 1/5] x86/efi: Delete most of the efi_call* macros
Date: Thu, 27 Mar 2014 15:10:39 -0700
Message-ID: <1395958243-14458-2-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1395958243-14458-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395958243-14458-1-git-send-email-ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

We really only need one phys and one virt function call, and then only
one assembly function to make firmware calls.

Since we are not using the C type system anyway, we're not really losing
much by deleting the macros apart from no longer having a check that
we are passing the correct number of parameters. The lack of duplicated
code seems like a worthwhile trade-off.

Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c       | 142 ++++++++++++++++-----------------
 arch/x86/include/asm/efi.h             |  72 ++---------------
 arch/x86/platform/efi/efi.c            |  52 ++++++------
 arch/x86/platform/efi/efi_stub_64.S    |  81 +------------------
 drivers/firmware/efi/efi-stub-helper.c |  92 ++++++++++-----------
 5 files changed, 150 insertions(+), 289 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index a7677ba..d4046c8 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -62,20 +62,20 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 	while (data && data->next)
 		data = (struct setup_data *)(unsigned long)data->next;
 
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, &pci_proto,
-				NULL, &size, pci_handle);
+	status = efi_call_phys(sys_table->boottime->locate_handle,
+			       EFI_LOCATE_BY_PROTOCOL, &pci_proto,
+			       NULL, &size, pci_handle);
 
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		status = efi_call_phys3(sys_table->boottime->allocate_pool,
-					EFI_LOADER_DATA, size, &pci_handle);
+		status = efi_call_phys(sys_table->boottime->allocate_pool,
+				       EFI_LOADER_DATA, size, &pci_handle);
 
 		if (status != EFI_SUCCESS)
 			return status;
 
-		status = efi_call_phys5(sys_table->boottime->locate_handle,
-					EFI_LOCATE_BY_PROTOCOL, &pci_proto,
-					NULL, &size, pci_handle);
+		status = efi_call_phys(sys_table->boottime->locate_handle,
+				       EFI_LOCATE_BY_PROTOCOL, &pci_proto,
+				       NULL, &size, pci_handle);
 	}
 
 	if (status != EFI_SUCCESS)
@@ -87,8 +87,8 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		uint64_t attributes;
 		struct pci_setup_rom *rom;
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					h, &pci_proto, &pci);
+		status = efi_call_phys(sys_table->boottime->handle_protocol,
+				       h, &pci_proto, &pci);
 
 		if (status != EFI_SUCCESS)
 			continue;
@@ -97,13 +97,13 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 			continue;
 
 #ifdef CONFIG_X86_64
-		status = efi_call_phys4(pci->attributes, pci,
-					EfiPciIoAttributeOperationGet, 0,
-					&attributes);
+		status = efi_call_phys(pci->attributes, pci,
+				       EfiPciIoAttributeOperationGet, 0,
+				       &attributes);
 #else
-		status = efi_call_phys5(pci->attributes, pci,
-					EfiPciIoAttributeOperationGet, 0, 0,
-					&attributes);
+		status = efi_call_phys(pci->attributes, pci,
+				       EfiPciIoAttributeOperationGet, 0, 0,
+				       &attributes);
 #endif
 		if (status != EFI_SUCCESS)
 			continue;
@@ -113,7 +113,7 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 
 		size = pci->romsize + sizeof(*rom);
 
-		status = efi_call_phys3(sys_table->boottime->allocate_pool,
+		status = efi_call_phys(sys_table->boottime->allocate_pool,
 				EFI_LOADER_DATA, size, &rom);
 
 		if (status != EFI_SUCCESS)
@@ -124,23 +124,23 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		rom->data.next = 0;
 		rom->pcilen = pci->romsize;
 
-		status = efi_call_phys5(pci->pci.read, pci,
-					EfiPciIoWidthUint16, PCI_VENDOR_ID,
-					1, &(rom->vendor));
+		status = efi_call_phys(pci->pci.read, pci,
+				       EfiPciIoWidthUint16, PCI_VENDOR_ID,
+				       1, &(rom->vendor));
 
 		if (status != EFI_SUCCESS)
 			goto free_struct;
 
-		status = efi_call_phys5(pci->pci.read, pci,
-					EfiPciIoWidthUint16, PCI_DEVICE_ID,
-					1, &(rom->devid));
+		status = efi_call_phys(pci->pci.read, pci,
+				       EfiPciIoWidthUint16, PCI_DEVICE_ID,
+				       1, &(rom->devid));
 
 		if (status != EFI_SUCCESS)
 			goto free_struct;
 
-		status = efi_call_phys5(pci->get_location, pci,
-					&(rom->segment), &(rom->bus),
-					&(rom->device), &(rom->function));
+		status = efi_call_phys(pci->get_location, pci,
+				       &(rom->segment), &(rom->bus),
+				       &(rom->device), &(rom->function));
 
 		if (status != EFI_SUCCESS)
 			goto free_struct;
@@ -156,11 +156,11 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 
 		continue;
 	free_struct:
-		efi_call_phys1(sys_table->boottime->free_pool, rom);
+		efi_call_phys(sys_table->boottime->free_pool, rom);
 	}
 
 free_handle:
-	efi_call_phys1(sys_table->boottime->free_pool, pci_handle);
+	efi_call_phys(sys_table->boottime->free_pool, pci_handle);
 	return status;
 }
 
@@ -181,14 +181,14 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 	int pixel_format;
 	int i;
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, &gop_handle);
+	status = efi_call_phys(sys_table->boottime->allocate_pool,
+			       EFI_LOADER_DATA, size, &gop_handle);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, proto,
-				NULL, &size, gop_handle);
+	status = efi_call_phys(sys_table->boottime->locate_handle,
+			       EFI_LOCATE_BY_PROTOCOL, proto,
+			       NULL, &size, gop_handle);
 	if (status != EFI_SUCCESS)
 		goto free_handle;
 
@@ -202,19 +202,19 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 		void *dummy;
 		void *h = gop_handle[i];
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					h, proto, &gop);
+		status = efi_call_phys(sys_table->boottime->handle_protocol,
+				       h, proto, &gop);
 		if (status != EFI_SUCCESS)
 			continue;
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					h, &conout_proto, &dummy);
+		status = efi_call_phys(sys_table->boottime->handle_protocol,
+				       h, &conout_proto, &dummy);
 
 		if (status == EFI_SUCCESS)
 			conout_found = true;
 
-		status = efi_call_phys4(gop->query_mode, gop,
-					gop->mode->mode, &size, &info);
+		status = efi_call_phys(gop->query_mode, gop,
+				       gop->mode->mode, &size, &info);
 		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
@@ -303,7 +303,7 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
 
 free_handle:
-	efi_call_phys1(sys_table->boottime->free_pool, gop_handle);
+	efi_call_phys(sys_table->boottime->free_pool, gop_handle);
 	return status;
 }
 
@@ -320,14 +320,14 @@ static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
 	void **uga_handle = NULL;
 	int i;
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, &uga_handle);
+	status = efi_call_phys(sys_table->boottime->allocate_pool,
+			       EFI_LOADER_DATA, size, &uga_handle);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, uga_proto,
-				NULL, &size, uga_handle);
+	status = efi_call_phys(sys_table->boottime->locate_handle,
+			       EFI_LOCATE_BY_PROTOCOL, uga_proto,
+			       NULL, &size, uga_handle);
 	if (status != EFI_SUCCESS)
 		goto free_handle;
 
@@ -340,16 +340,16 @@ static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
 		u32 w, h, depth, refresh;
 		void *pciio;
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					handle, uga_proto, &uga);
+		status = efi_call_phys(sys_table->boottime->handle_protocol,
+				       handle, uga_proto, &uga);
 		if (status != EFI_SUCCESS)
 			continue;
 
-		efi_call_phys3(sys_table->boottime->handle_protocol,
-			       handle, &pciio_proto, &pciio);
+		efi_call_phys(sys_table->boottime->handle_protocol,
+			      handle, &pciio_proto, &pciio);
 
-		status = efi_call_phys5(uga->get_mode, uga, &w, &h,
-					&depth, &refresh);
+		status = efi_call_phys(uga->get_mode, uga, &w, &h,
+				       &depth, &refresh);
 		if (status == EFI_SUCCESS && (!first_uga || pciio)) {
 			width = w;
 			height = h;
@@ -386,7 +386,7 @@ static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
 
 
 free_handle:
-	efi_call_phys1(sys_table->boottime->free_pool, uga_handle);
+	efi_call_phys(sys_table->boottime->free_pool, uga_handle);
 	return status;
 }
 
@@ -404,17 +404,17 @@ void setup_graphics(struct boot_params *boot_params)
 	memset(si, 0, sizeof(*si));
 
 	size = 0;
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, &graphics_proto,
-				NULL, &size, gop_handle);
+	status = efi_call_phys(sys_table->boottime->locate_handle,
+			       EFI_LOCATE_BY_PROTOCOL, &graphics_proto,
+			       NULL, &size, gop_handle);
 	if (status == EFI_BUFFER_TOO_SMALL)
 		status = setup_gop(si, &graphics_proto, size);
 
 	if (status != EFI_SUCCESS) {
 		size = 0;
-		status = efi_call_phys5(sys_table->boottime->locate_handle,
-					EFI_LOCATE_BY_PROTOCOL, &uga_proto,
-					NULL, &size, uga_handle);
+		status = efi_call_phys(sys_table->boottime->locate_handle,
+				       EFI_LOCATE_BY_PROTOCOL, &uga_proto,
+				       NULL, &size, uga_handle);
 		if (status == EFI_BUFFER_TOO_SMALL)
 			setup_uga(si, &uga_proto, size);
 	}
@@ -451,8 +451,8 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		return NULL;
 
-	status = efi_call_phys3(sys_table->boottime->handle_protocol,
-				handle, &proto, (void *)&image);
+	status = efi_call_phys(sys_table->boottime->handle_protocol,
+			       handle, &proto, (void *)&image);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
 		return NULL;
@@ -641,13 +641,13 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 		sizeof(struct e820entry) * nr_desc;
 
 	if (*e820ext) {
-		efi_call_phys1(sys_table->boottime->free_pool, *e820ext);
+		efi_call_phys(sys_table->boottime->free_pool, *e820ext);
 		*e820ext = NULL;
 		*e820ext_size = 0;
 	}
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, e820ext);
+	status = efi_call_phys(sys_table->boottime->allocate_pool,
+			       EFI_LOADER_DATA, size, e820ext);
 
 	if (status == EFI_SUCCESS)
 		*e820ext_size = size;
@@ -691,7 +691,7 @@ get_map:
 		if (status != EFI_SUCCESS)
 			goto free_mem_map;
 
-		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+		efi_call_phys(sys_table->boottime->free_pool, mem_map);
 		goto get_map; /* Allocated memory, get map again */
 	}
 
@@ -708,8 +708,8 @@ get_map:
 #endif
 
 	/* Might as well exit boot services now */
-	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
-				handle, key);
+	status = efi_call_phys(sys_table->boottime->exit_boot_services,
+			       handle, key);
 	if (status != EFI_SUCCESS) {
 		/*
 		 * ExitBootServices() will fail if any of the event
@@ -722,7 +722,7 @@ get_map:
 			goto free_mem_map;
 
 		called_exit = true;
-		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+		efi_call_phys(sys_table->boottime->free_pool, mem_map);
 		goto get_map;
 	}
 
@@ -736,7 +736,7 @@ get_map:
 	return EFI_SUCCESS;
 
 free_mem_map:
-	efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+	efi_call_phys(sys_table->boottime->free_pool, mem_map);
 	return status;
 }
 
@@ -764,9 +764,9 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 
 	setup_efi_pci(boot_params);
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, sizeof(*gdt),
-				(void **)&gdt);
+	status = efi_call_phys(sys_table->boottime->allocate_pool,
+			       EFI_LOADER_DATA, sizeof(*gdt),
+			       (void **)&gdt);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for gdt structure\n");
 		goto fail;
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index acd86c8..0eafd59 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -25,16 +25,6 @@
 
 extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
-#define efi_call_phys0(f)		efi_call_phys(f)
-#define efi_call_phys1(f, a1)		efi_call_phys(f, a1)
-#define efi_call_phys2(f, a1, a2)	efi_call_phys(f, a1, a2)
-#define efi_call_phys3(f, a1, a2, a3)	efi_call_phys(f, a1, a2, a3)
-#define efi_call_phys4(f, a1, a2, a3, a4)	\
-	efi_call_phys(f, a1, a2, a3, a4)
-#define efi_call_phys5(f, a1, a2, a3, a4, a5)	\
-	efi_call_phys(f, a1, a2, a3, a4, a5)
-#define efi_call_phys6(f, a1, a2, a3, a4, a5, a6)	\
-	efi_call_phys(f, a1, a2, a3, a4, a5, a6)
 /*
  * Wrap all the virtual calls in a way that forces the parameters on the stack.
  */
@@ -42,77 +32,27 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 #define efi_call_virt(f, args...) \
 	((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
 
-#define efi_call_virt0(f)		efi_call_virt(f)
-#define efi_call_virt1(f, a1)		efi_call_virt(f, a1)
-#define efi_call_virt2(f, a1, a2)	efi_call_virt(f, a1, a2)
-#define efi_call_virt3(f, a1, a2, a3)	efi_call_virt(f, a1, a2, a3)
-#define efi_call_virt4(f, a1, a2, a3, a4)	\
-	efi_call_virt(f, a1, a2, a3, a4)
-#define efi_call_virt5(f, a1, a2, a3, a4, a5)	\
-	efi_call_virt(f, a1, a2, a3, a4, a5)
-#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
-	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
-
 #define efi_ioremap(addr, size, type, attr)	ioremap_cache(addr, size)
 
 #else /* !CONFIG_X86_32 */
 
 #define EFI_LOADER_SIGNATURE	"EL64"
 
-extern u64 efi_call0(void *fp);
-extern u64 efi_call1(void *fp, u64 arg1);
-extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
-extern u64 efi_call3(void *fp, u64 arg1, u64 arg2, u64 arg3);
-extern u64 efi_call4(void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4);
-extern u64 efi_call5(void *fp, u64 arg1, u64 arg2, u64 arg3,
-		     u64 arg4, u64 arg5);
-extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
-		     u64 arg4, u64 arg5, u64 arg6);
-
-#define efi_call_phys0(f)			\
-	efi_call0((f))
-#define efi_call_phys1(f, a1)			\
-	efi_call1((f), (u64)(a1))
-#define efi_call_phys2(f, a1, a2)			\
-	efi_call2((f), (u64)(a1), (u64)(a2))
-#define efi_call_phys3(f, a1, a2, a3)				\
-	efi_call3((f), (u64)(a1), (u64)(a2), (u64)(a3))
-#define efi_call_phys4(f, a1, a2, a3, a4)				\
-	efi_call4((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
-		  (u64)(a4))
-#define efi_call_phys5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
-		  (u64)(a4), (u64)(a5))
-#define efi_call_phys6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
-		  (u64)(a4), (u64)(a5), (u64)(a6))
-
-#define _efi_call_virtX(x, f, ...)					\
+extern u64 asmlinkage efi_call(void *fp, ...);
+
+#define efi_call_phys(f, args...)		efi_call((f), args)
+
+#define efi_call_virt(f, ...)						\
 ({									\
 	efi_status_t __s;						\
 									\
 	efi_sync_low_kernel_mappings();					\
 	preempt_disable();						\
-	__s = efi_call##x((void *)efi.systab->runtime->f, __VA_ARGS__);	\
+	__s = efi_call((void *)efi.systab->runtime->f, __VA_ARGS__);	\
 	preempt_enable();						\
 	__s;								\
 })
 
-#define efi_call_virt0(f)				\
-	_efi_call_virtX(0, f)
-#define efi_call_virt1(f, a1)				\
-	_efi_call_virtX(1, f, (u64)(a1))
-#define efi_call_virt2(f, a1, a2)			\
-	_efi_call_virtX(2, f, (u64)(a1), (u64)(a2))
-#define efi_call_virt3(f, a1, a2, a3)			\
-	_efi_call_virtX(3, f, (u64)(a1), (u64)(a2), (u64)(a3))
-#define efi_call_virt4(f, a1, a2, a3, a4)		\
-	_efi_call_virtX(4, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4))
-#define efi_call_virt5(f, a1, a2, a3, a4, a5)		\
-	_efi_call_virtX(5, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4), (u64)(a5))
-#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
-	_efi_call_virtX(6, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
-
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 				 u32 type, u64 attribute);
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0b3c4de..e9e2fe0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -121,7 +121,7 @@ static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt2(get_time, tm, tc);
+	status = efi_call_virt(get_time, tm, tc);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -132,7 +132,7 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt1(set_time, tm);
+	status = efi_call_virt(set_time, tm);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -145,8 +145,7 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt3(get_wakeup_time,
-				enabled, pending, tm);
+	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -157,8 +156,7 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt2(set_wakeup_time,
-				enabled, tm);
+	status = efi_call_virt(set_wakeup_time, enabled, tm);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -169,17 +167,17 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 					  unsigned long *data_size,
 					  void *data)
 {
-	return efi_call_virt5(get_variable,
-			      name, vendor, attr,
-			      data_size, data);
+	return efi_call_virt(get_variable,
+			     name, vendor, attr,
+			     data_size, data);
 }
 
 static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 					       efi_char16_t *name,
 					       efi_guid_t *vendor)
 {
-	return efi_call_virt3(get_next_variable,
-			      name_size, name, vendor);
+	return efi_call_virt(get_next_variable,
+			     name_size, name, vendor);
 }
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,
@@ -188,9 +186,9 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  unsigned long data_size,
 					  void *data)
 {
-	return efi_call_virt5(set_variable,
-			      name, vendor, attr,
-			      data_size, data);
+	return efi_call_virt(set_variable,
+			     name, vendor, attr,
+			     data_size, data);
 }
 
 static efi_status_t virt_efi_query_variable_info(u32 attr,
@@ -201,13 +199,13 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt4(query_variable_info, attr, storage_space,
-			      remaining_space, max_variable_size);
+	return efi_call_virt(query_variable_info, attr, storage_space,
+			     remaining_space, max_variable_size);
 }
 
 static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 {
-	return efi_call_virt1(get_next_high_mono_count, count);
+	return efi_call_virt(get_next_high_mono_count, count);
 }
 
 static void virt_efi_reset_system(int reset_type,
@@ -215,8 +213,8 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
-	efi_call_virt4(reset_system, reset_type, status,
-		       data_size, data);
+	efi_call_virt(reset_system, reset_type, status,
+		      data_size, data);
 }
 
 static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
@@ -226,7 +224,7 @@ static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt3(update_capsule, capsules, count, sg_list);
+	return efi_call_virt(update_capsule, capsules, count, sg_list);
 }
 
 static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
@@ -237,8 +235,8 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt4(query_capsule_caps, capsules, count, max_size,
-			      reset_type);
+	return efi_call_virt(query_capsule_caps, capsules, count, max_size,
+			     reset_type);
 }
 
 static efi_status_t __init phys_efi_set_virtual_address_map(
@@ -250,9 +248,9 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	efi_status_t status;
 
 	efi_call_phys_prelog();
-	status = efi_call_phys4(efi_phys.set_virtual_address_map,
-				memory_map_size, descriptor_size,
-				descriptor_version, virtual_map);
+	status = efi_call_phys(efi_phys.set_virtual_address_map,
+			       memory_map_size, descriptor_size,
+			       descriptor_version, virtual_map);
 	efi_call_phys_epilog();
 	return status;
 }
@@ -265,8 +263,8 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 
 	spin_lock_irqsave(&rtc_lock, flags);
 	efi_call_phys_prelog();
-	status = efi_call_phys2(efi_phys.get_time, virt_to_phys(tm),
-				virt_to_phys(tc));
+	status = efi_call_phys(efi_phys.get_time, virt_to_phys(tm),
+			       virt_to_phys(tc));
 	efi_call_phys_epilog();
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 88073b1..2800293 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -69,84 +69,7 @@
 	2:
 	.endm
 
-ENTRY(efi_call0)
-	SAVE_XMM
-	subq $32, %rsp
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $32, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call0)
-
-ENTRY(efi_call1)
-	SAVE_XMM
-	subq $32, %rsp
-	mov  %rsi, %rcx
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $32, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call1)
-
-ENTRY(efi_call2)
-	SAVE_XMM
-	subq $32, %rsp
-	mov  %rsi, %rcx
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $32, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call2)
-
-ENTRY(efi_call3)
-	SAVE_XMM
-	subq $32, %rsp
-	mov  %rcx, %r8
-	mov  %rsi, %rcx
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $32, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call3)
-
-ENTRY(efi_call4)
-	SAVE_XMM
-	subq $32, %rsp
-	mov %r8, %r9
-	mov %rcx, %r8
-	mov %rsi, %rcx
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $32, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call4)
-
-ENTRY(efi_call5)
-	SAVE_XMM
-	subq $48, %rsp
-	mov %r9, 32(%rsp)
-	mov %r8, %r9
-	mov %rcx, %r8
-	mov %rsi, %rcx
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $48, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call5)
-
-ENTRY(efi_call6)
+ENTRY(efi_call)
 	SAVE_XMM
 	mov (%rsp), %rax
 	mov 8(%rax), %rax
@@ -162,7 +85,7 @@ ENTRY(efi_call6)
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
-ENDPROC(efi_call6)
+ENDPROC(efi_call)
 
 	.data
 ENTRY(efi_scratch)
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index b6bffbf..17d215b 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -25,7 +25,7 @@ static void efi_char16_printk(efi_system_table_t *sys_table_arg,
 	struct efi_simple_text_output_protocol *out;
 
 	out = (struct efi_simple_text_output_protocol *)sys_table_arg->con_out;
-	efi_call_phys2(out->output_string, out, str);
+	efi_call_phys(out->output_string, out, str);
 }
 
 static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
@@ -65,20 +65,20 @@ again:
 	 * allocation which may be in a new descriptor region.
 	 */
 	*map_size += sizeof(*m);
-	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
-				EFI_LOADER_DATA, *map_size, (void **)&m);
+	status = efi_call_phys(sys_table_arg->boottime->allocate_pool,
+			       EFI_LOADER_DATA, *map_size, (void **)&m);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-	status = efi_call_phys5(sys_table_arg->boottime->get_memory_map,
-				map_size, m, &key, desc_size, &desc_version);
+	status = efi_call_phys(sys_table_arg->boottime->get_memory_map,
+			       map_size, m, &key, desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
+		efi_call_phys(sys_table_arg->boottime->free_pool, m);
 		goto again;
 	}
 
 	if (status != EFI_SUCCESS)
-		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
+		efi_call_phys(sys_table_arg->boottime->free_pool, m);
 	if (key_ptr && status == EFI_SUCCESS)
 		*key_ptr = key;
 	if (desc_ver && status == EFI_SUCCESS)
@@ -158,9 +158,9 @@ again:
 	if (!max_addr)
 		status = EFI_NOT_FOUND;
 	else {
-		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
-					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-					nr_pages, &max_addr);
+		status = efi_call_phys(sys_table_arg->boottime->allocate_pages,
+				       EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+				       nr_pages, &max_addr);
 		if (status != EFI_SUCCESS) {
 			max = max_addr;
 			max_addr = 0;
@@ -170,7 +170,7 @@ again:
 		*addr = max_addr;
 	}
 
-	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
+	efi_call_phys(sys_table_arg->boottime->free_pool, map);
 
 fail:
 	return status;
@@ -231,9 +231,9 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		if ((start + size) > end)
 			continue;
 
-		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
-					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-					nr_pages, &start);
+		status = efi_call_phys(sys_table_arg->boottime->allocate_pages,
+				       EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+				       nr_pages, &start);
 		if (status == EFI_SUCCESS) {
 			*addr = start;
 			break;
@@ -243,7 +243,7 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	if (i == map_size / desc_size)
 		status = EFI_NOT_FOUND;
 
-	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
+	efi_call_phys(sys_table_arg->boottime->free_pool, map);
 fail:
 	return status;
 }
@@ -257,7 +257,7 @@ static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 		return;
 
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	efi_call_phys2(sys_table_arg->boottime->free_pages, addr, nr_pages);
+	efi_call_phys(sys_table_arg->boottime->free_pages, addr, nr_pages);
 }
 
 
@@ -319,10 +319,10 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 	if (!nr_files)
 		return EFI_SUCCESS;
 
-	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
-				EFI_LOADER_DATA,
-				nr_files * sizeof(*files),
-				(void **)&files);
+	status = efi_call_phys(sys_table_arg->boottime->allocate_pool,
+			       EFI_LOADER_DATA,
+			       nr_files * sizeof(*files),
+			       (void **)&files);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
 		goto fail;
@@ -372,23 +372,23 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 			boottime = sys_table_arg->boottime;
 
-			status = efi_call_phys3(boottime->handle_protocol,
+			status = efi_call_phys(boottime->handle_protocol,
 					image->device_handle, &fs_proto,
-						(void **)&io);
+					       (void **)&io);
 			if (status != EFI_SUCCESS) {
 				efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
 				goto free_files;
 			}
 
-			status = efi_call_phys2(io->open_volume, io, &fh);
+			status = efi_call_phys(io->open_volume, io, &fh);
 			if (status != EFI_SUCCESS) {
 				efi_printk(sys_table_arg, "Failed to open volume\n");
 				goto free_files;
 			}
 		}
 
-		status = efi_call_phys5(fh->open, fh, &h, filename_16,
-					EFI_FILE_MODE_READ, (u64)0);
+		status = efi_call_phys(fh->open, fh, &h, filename_16,
+				       EFI_FILE_MODE_READ, (u64)0);
 		if (status != EFI_SUCCESS) {
 			efi_printk(sys_table_arg, "Failed to open file: ");
 			efi_char16_printk(sys_table_arg, filename_16);
@@ -399,32 +399,32 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 		file->handle = h;
 
 		info_sz = 0;
-		status = efi_call_phys4(h->get_info, h, &info_guid,
-					&info_sz, NULL);
+		status = efi_call_phys(h->get_info, h, &info_guid,
+				       &info_sz, NULL);
 		if (status != EFI_BUFFER_TOO_SMALL) {
 			efi_printk(sys_table_arg, "Failed to get file info size\n");
 			goto close_handles;
 		}
 
 grow:
-		status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
-					EFI_LOADER_DATA, info_sz,
-					(void **)&info);
+		status = efi_call_phys(sys_table_arg->boottime->allocate_pool,
+				       EFI_LOADER_DATA, info_sz,
+				       (void **)&info);
 		if (status != EFI_SUCCESS) {
 			efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
 			goto close_handles;
 		}
 
-		status = efi_call_phys4(h->get_info, h, &info_guid,
-					&info_sz, info);
+		status = efi_call_phys(h->get_info, h, &info_guid,
+				       &info_sz, info);
 		if (status == EFI_BUFFER_TOO_SMALL) {
-			efi_call_phys1(sys_table_arg->boottime->free_pool,
-				       info);
+			efi_call_phys(sys_table_arg->boottime->free_pool,
+				      info);
 			goto grow;
 		}
 
 		file_sz = info->file_size;
-		efi_call_phys1(sys_table_arg->boottime->free_pool, info);
+		efi_call_phys(sys_table_arg->boottime->free_pool, info);
 
 		if (status != EFI_SUCCESS) {
 			efi_printk(sys_table_arg, "Failed to get file info\n");
@@ -468,10 +468,10 @@ grow:
 					chunksize = EFI_READ_CHUNK_SIZE;
 				else
 					chunksize = size;
-				status = efi_call_phys3(fh->read,
-							files[j].handle,
-							&chunksize,
-							(void *)addr);
+				status = efi_call_phys(fh->read,
+						       files[j].handle,
+						       &chunksize,
+						       (void *)addr);
 				if (status != EFI_SUCCESS) {
 					efi_printk(sys_table_arg, "Failed to read file\n");
 					goto free_file_total;
@@ -480,12 +480,12 @@ grow:
 				size -= chunksize;
 			}
 
-			efi_call_phys1(fh->close, files[j].handle);
+			efi_call_phys(fh->close, files[j].handle);
 		}
 
 	}
 
-	efi_call_phys1(sys_table_arg->boottime->free_pool, files);
+	efi_call_phys(sys_table_arg->boottime->free_pool, files);
 
 	*load_addr = file_addr;
 	*load_size = file_size_total;
@@ -497,9 +497,9 @@ free_file_total:
 
 close_handles:
 	for (k = j; k < i; k++)
-		efi_call_phys1(fh->close, files[k].handle);
+		efi_call_phys(fh->close, files[k].handle);
 free_files:
-	efi_call_phys1(sys_table_arg->boottime->free_pool, files);
+	efi_call_phys(sys_table_arg->boottime->free_pool, files);
 fail:
 	*load_addr = 0;
 	*load_size = 0;
@@ -545,9 +545,9 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 	 * as possible while respecting the required alignment.
 	 */
 	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
-				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-				nr_pages, &efi_addr);
+	status = efi_call_phys(sys_table_arg->boottime->allocate_pages,
+			       EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+			       nr_pages, &efi_addr);
 	new_addr = efi_addr;
 	/*
 	 * If preferred address allocation failed allocate as low as
-- 
1.8.1.2
