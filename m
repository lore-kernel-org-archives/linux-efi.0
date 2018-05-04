From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 14/17] efi/x86: fold __setup_efi_pci32 and __setup_efi_pci64 into one
Date: Fri,  4 May 2018 08:00:00 +0200
Message-ID: <20180504060003.19618-15-ard.biesheuvel@linaro.org>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

As suggested by Lukas, use his efi_call_proto() and efi_table_attr()
macros to merge __setup_efi_pci32() and __setup_efi_pci64() into a
single function, removing the need to duplicate changes made in
subsequent patches across both.

Cc: Lukas Wunner <lukas@wunner.de>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c | 107 ++++++++-----------------------
 1 file changed, 25 insertions(+), 82 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 3994f48c4043..dadf32312082 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -109,23 +109,27 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 }
 
 static efi_status_t
-__setup_efi_pci32(efi_pci_io_protocol_32_t *pci, struct pci_setup_rom **__rom)
+__setup_efi_pci(efi_pci_io_protocol_t *pci, struct pci_setup_rom **__rom)
 {
 	struct pci_setup_rom *rom = NULL;
 	efi_status_t status;
 	unsigned long size;
-	uint64_t attributes;
+	uint64_t attributes, romsize;
+	void *romimage;
 
-	status = efi_early->call(pci->attributes, pci,
-				 EfiPciIoAttributeOperationGet, 0, 0,
-				 &attributes);
+	status = efi_call_proto(efi_pci_io_protocol, attributes, pci,
+				EfiPciIoAttributeOperationGet, 0, 0,
+				&attributes);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!pci->romimage || !pci->romsize)
+	romimage = (void *)(unsigned long)efi_table_attr(efi_pci_io_protocol,
+							 romimage, pci);
+	romsize = efi_table_attr(efi_pci_io_protocol, romsize, pci);
+	if (!romimage || !romsize)
 		return EFI_INVALID_PARAMETER;
 
-	size = pci->romsize + sizeof(*rom);
+	size = romsize + sizeof(*rom);
 
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, size, &rom);
 	if (status != EFI_SUCCESS) {
@@ -141,30 +145,32 @@ __setup_efi_pci32(efi_pci_io_protocol_32_t *pci, struct pci_setup_rom **__rom)
 	rom->pcilen = pci->romsize;
 	*__rom = rom;
 
-	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
-				 PCI_VENDOR_ID, 1, &(rom->vendor));
+	status = efi_call_proto(efi_pci_io_protocol, pci.read, pci,
+				EfiPciIoWidthUint16, PCI_VENDOR_ID, 1,
+				&rom->vendor);
 
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to read rom->vendor\n");
 		goto free_struct;
 	}
 
-	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
-				 PCI_DEVICE_ID, 1, &(rom->devid));
+	status = efi_call_proto(efi_pci_io_protocol, pci.read, pci,
+				EfiPciIoWidthUint16, PCI_DEVICE_ID, 1,
+				&rom->devid);
 
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to read rom->devid\n");
 		goto free_struct;
 	}
 
-	status = efi_early->call(pci->get_location, pci, &(rom->segment),
-				 &(rom->bus), &(rom->device), &(rom->function));
+	status = efi_call_proto(efi_pci_io_protocol, get_location, pci,
+				&rom->segment, &rom->bus, &rom->device,
+				&rom->function);
 
 	if (status != EFI_SUCCESS)
 		goto free_struct;
 
-	memcpy(rom->romdata, (void *)(unsigned long)pci->romimage,
-	       pci->romsize);
+	memcpy(rom->romdata, romimage, romsize);
 	return status;
 
 free_struct:
@@ -176,7 +182,7 @@ static void
 setup_efi_pci32(struct boot_params *params, void **pci_handle,
 		unsigned long size)
 {
-	efi_pci_io_protocol_32_t *pci = NULL;
+	efi_pci_io_protocol_t *pci = NULL;
 	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
 	u32 *handles = (u32 *)(unsigned long)pci_handle;
 	efi_status_t status;
@@ -203,7 +209,7 @@ setup_efi_pci32(struct boot_params *params, void **pci_handle,
 		if (!pci)
 			continue;
 
-		status = __setup_efi_pci32(pci, &rom);
+		status = __setup_efi_pci(pci, &rom);
 		if (status != EFI_SUCCESS)
 			continue;
 
@@ -217,74 +223,11 @@ setup_efi_pci32(struct boot_params *params, void **pci_handle,
 	}
 }
 
-static efi_status_t
-__setup_efi_pci64(efi_pci_io_protocol_64_t *pci, struct pci_setup_rom **__rom)
-{
-	struct pci_setup_rom *rom;
-	efi_status_t status;
-	unsigned long size;
-	uint64_t attributes;
-
-	status = efi_early->call(pci->attributes, pci,
-				 EfiPciIoAttributeOperationGet, 0,
-				 &attributes);
-	if (status != EFI_SUCCESS)
-		return status;
-
-	if (!pci->romimage || !pci->romsize)
-		return EFI_INVALID_PARAMETER;
-
-	size = pci->romsize + sizeof(*rom);
-
-	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, size, &rom);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to alloc mem for rom\n");
-		return status;
-	}
-
-	rom->data.type = SETUP_PCI;
-	rom->data.len = size - sizeof(struct setup_data);
-	rom->data.next = 0;
-	rom->pcilen = pci->romsize;
-	*__rom = rom;
-
-	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
-				 PCI_VENDOR_ID, 1, &(rom->vendor));
-
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to read rom->vendor\n");
-		goto free_struct;
-	}
-
-	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
-				 PCI_DEVICE_ID, 1, &(rom->devid));
-
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to read rom->devid\n");
-		goto free_struct;
-	}
-
-	status = efi_early->call(pci->get_location, pci, &(rom->segment),
-				 &(rom->bus), &(rom->device), &(rom->function));
-
-	if (status != EFI_SUCCESS)
-		goto free_struct;
-
-	memcpy(rom->romdata, (void *)(unsigned long)pci->romimage,
-	       pci->romsize);
-	return status;
-
-free_struct:
-	efi_call_early(free_pool, rom);
-	return status;
-
-}
-
 static void
 setup_efi_pci64(struct boot_params *params, void **pci_handle,
 		unsigned long size)
 {
-	efi_pci_io_protocol_64_t *pci = NULL;
+	efi_pci_io_protocol_t *pci = NULL;
 	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
 	u64 *handles = (u64 *)(unsigned long)pci_handle;
 	efi_status_t status;
@@ -311,7 +254,7 @@ setup_efi_pci64(struct boot_params *params, void **pci_handle,
 		if (!pci)
 			continue;
 
-		status = __setup_efi_pci64(pci, &rom);
+		status = __setup_efi_pci(pci, &rom);
 		if (status != EFI_SUCCESS)
 			continue;
 
-- 
2.17.0
