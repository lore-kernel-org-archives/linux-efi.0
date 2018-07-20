From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/9] efi/x86: merge 32-bit and 64-bit UGA draw protocol setup routines
Date: Fri, 20 Jul 2018 10:47:21 +0900
Message-ID: <20180720014726.24031-5-ard.biesheuvel@linaro.org>
References: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

The two versions of setup_uga##() are mostly identical, with the
exception of the size of EFI_HANDLE. So let's merge the two, and
pull the implementation into the calling function setup_uga().

Note that the 32-bit version was only mixed-mode safe by accident:
it only calls the get_mode() method of the UGA draw protocol, which
happens to be the first member, and so truncating the 64-bit void* at
offset 0 to 32 bits happens to produce the correct value. But let's
not rely on that, and use the proper API instead.

Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c | 111 ++++++++-----------------------
 1 file changed, 26 insertions(+), 85 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 011d5c289449..ac8e442db71f 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -318,81 +318,54 @@ static void setup_quirks(struct boot_params *boot_params)
 	}
 }
 
+/*
+ * See if we have Universal Graphics Adapter (UGA) protocol
+ */
 static efi_status_t
-setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
+setup_uga(struct screen_info *si, efi_guid_t *uga_proto, unsigned long size)
 {
+	efi_status_t status;
+	u32 width, height;
+	void **uga_handle = NULL;
 	efi_uga_draw_protocol_t *uga = NULL, *first_uga;
-	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	unsigned long nr_ugas;
-	u32 *handles = (u32 *)uga_handle;
-	efi_status_t status = EFI_INVALID_PARAMETER;
 	int i;
 
-	first_uga = NULL;
-	nr_ugas = size / sizeof(u32);
-	for (i = 0; i < nr_ugas; i++) {
-		efi_guid_t pciio_proto = EFI_PCI_IO_PROTOCOL_GUID;
-		u32 w, h, depth, refresh;
-		void *pciio;
-		u32 handle = handles[i];
-
-		status = efi_call_early(handle_protocol, handle,
-					&uga_proto, (void **)&uga);
-		if (status != EFI_SUCCESS)
-			continue;
-
-		efi_call_early(handle_protocol, handle, &pciio_proto, &pciio);
-
-		status = efi_early->call((unsigned long)uga->get_mode, uga,
-					 &w, &h, &depth, &refresh);
-		if (status == EFI_SUCCESS && (!first_uga || pciio)) {
-			*width = w;
-			*height = h;
-
-			/*
-			 * Once we've found a UGA supporting PCIIO,
-			 * don't bother looking any further.
-			 */
-			if (pciio)
-				break;
-
-			first_uga = uga;
-		}
-	}
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				size, (void **)&uga_handle);
+	if (status != EFI_SUCCESS)
+		return status;
 
-	return status;
-}
+	status = efi_call_early(locate_handle,
+				EFI_LOCATE_BY_PROTOCOL,
+				uga_proto, NULL, &size, uga_handle);
+	if (status != EFI_SUCCESS)
+		goto free_handle;
 
-static efi_status_t
-setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
-{
-	efi_uga_draw_protocol_t *uga = NULL, *first_uga;
-	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
-	unsigned long nr_ugas;
-	u64 *handles = (u64 *)uga_handle;
-	efi_status_t status = EFI_INVALID_PARAMETER;
-	int i;
+	height = 0;
+	width = 0;
 
 	first_uga = NULL;
-	nr_ugas = size / sizeof(u64);
+	nr_ugas = size / (efi_is_64bit() ? sizeof(u64) : sizeof(u32));
 	for (i = 0; i < nr_ugas; i++) {
 		efi_guid_t pciio_proto = EFI_PCI_IO_PROTOCOL_GUID;
 		u32 w, h, depth, refresh;
 		void *pciio;
-		u64 handle = handles[i];
+		unsigned long handle = efi_is_64bit() ? ((u64 *)uga_handle)[i]
+						      : ((u32 *)uga_handle)[i];
 
 		status = efi_call_early(handle_protocol, handle,
-					&uga_proto, (void **)&uga);
+					uga_proto, (void **)&uga);
 		if (status != EFI_SUCCESS)
 			continue;
 
 		efi_call_early(handle_protocol, handle, &pciio_proto, &pciio);
 
-		status = efi_early->call((unsigned long)uga->get_mode, uga,
-					 &w, &h, &depth, &refresh);
+		status = efi_call_proto(efi_uga_draw_protocol, get_mode, uga,
+					&w, &h, &depth, &refresh);
 		if (status == EFI_SUCCESS && (!first_uga || pciio)) {
-			*width = w;
-			*height = h;
+			width = w;
+			height = h;
 
 			/*
 			 * Once we've found a UGA supporting PCIIO,
@@ -405,38 +378,6 @@ setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 		}
 	}
 
-	return status;
-}
-
-/*
- * See if we have Universal Graphics Adapter (UGA) protocol
- */
-static efi_status_t
-setup_uga(struct screen_info *si, efi_guid_t *uga_proto, unsigned long size)
-{
-	efi_status_t status;
-	u32 width, height;
-	void **uga_handle = NULL;
-
-	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
-				size, (void **)&uga_handle);
-	if (status != EFI_SUCCESS)
-		return status;
-
-	status = efi_call_early(locate_handle,
-				EFI_LOCATE_BY_PROTOCOL,
-				uga_proto, NULL, &size, uga_handle);
-	if (status != EFI_SUCCESS)
-		goto free_handle;
-
-	height = 0;
-	width = 0;
-
-	if (efi_early->is64)
-		status = setup_uga64(uga_handle, size, &width, &height);
-	else
-		status = setup_uga32(uga_handle, size, &width, &height);
-
 	if (!width && !height)
 		goto free_handle;
 
-- 
2.17.1
