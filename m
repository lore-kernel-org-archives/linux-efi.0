From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/9] efi/x86: merge setup_efi_pci32 and setup_efi_pci64 routines
Date: Fri, 20 Jul 2018 10:47:19 +0900
Message-ID: <20180720014726.24031-3-ard.biesheuvel@linaro.org>
References: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

After merging the 32-bit and 64-bit versions of the code that invokes
the PCI I/O protocol methods to preserve PCI ROM images in commit

  2c3625cb9fa2 ("efi/x86: Fold __setup_efi_pci32() and __setup_efi_pci64() ...")

there are still separate code paths for 32-bit and 64-bit, where the only
difference is the size of a EFI_HANDLE. So let's parameterize a single
implementation for that difference only, and get rid of the two copies of
the code.

While at it, rename __setup_efi_pci() to preserve_pci_rom_image() to
better reflect its purpose.

Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c | 123 ++++++++-----------------------
 1 file changed, 32 insertions(+), 91 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 9f6813493945..c72550783c16 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -111,7 +111,7 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 }
 
 static efi_status_t
-__setup_efi_pci(efi_pci_io_protocol_t *pci, struct pci_setup_rom **__rom)
+preserve_pci_rom_image(efi_pci_io_protocol_t *pci, struct pci_setup_rom **__rom)
 {
 	struct pci_setup_rom *rom = NULL;
 	efi_status_t status;
@@ -181,92 +181,6 @@ __setup_efi_pci(efi_pci_io_protocol_t *pci, struct pci_setup_rom **__rom)
 	return status;
 }
 
-static void
-setup_efi_pci32(struct boot_params *params, void **pci_handle, unsigned long size)
-{
-	efi_pci_io_protocol_t *pci = NULL;
-	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
-	u32 *handles = (u32 *)(unsigned long)pci_handle;
-	efi_status_t status;
-	unsigned long nr_pci;
-	struct setup_data *data;
-	int i;
-
-	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
-
-	while (data && data->next)
-		data = (struct setup_data *)(unsigned long)data->next;
-
-	nr_pci = size / sizeof(u32);
-	for (i = 0; i < nr_pci; i++) {
-		struct pci_setup_rom *rom = NULL;
-		u32 h = handles[i];
-
-		status = efi_call_early(handle_protocol, h,
-					&pci_proto, (void **)&pci);
-
-		if (status != EFI_SUCCESS)
-			continue;
-
-		if (!pci)
-			continue;
-
-		status = __setup_efi_pci(pci, &rom);
-		if (status != EFI_SUCCESS)
-			continue;
-
-		if (data)
-			data->next = (unsigned long)rom;
-		else
-			params->hdr.setup_data = (unsigned long)rom;
-
-		data = (struct setup_data *)rom;
-	}
-}
-
-static void
-setup_efi_pci64(struct boot_params *params, void **pci_handle, unsigned long size)
-{
-	efi_pci_io_protocol_t *pci = NULL;
-	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
-	u64 *handles = (u64 *)(unsigned long)pci_handle;
-	efi_status_t status;
-	unsigned long nr_pci;
-	struct setup_data *data;
-	int i;
-
-	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
-
-	while (data && data->next)
-		data = (struct setup_data *)(unsigned long)data->next;
-
-	nr_pci = size / sizeof(u64);
-	for (i = 0; i < nr_pci; i++) {
-		struct pci_setup_rom *rom = NULL;
-		u64 h = handles[i];
-
-		status = efi_call_early(handle_protocol, h,
-					&pci_proto, (void **)&pci);
-
-		if (status != EFI_SUCCESS)
-			continue;
-
-		if (!pci)
-			continue;
-
-		status = __setup_efi_pci(pci, &rom);
-		if (status != EFI_SUCCESS)
-			continue;
-
-		if (data)
-			data->next = (unsigned long)rom;
-		else
-			params->hdr.setup_data = (unsigned long)rom;
-
-		data = (struct setup_data *)rom;
-	}
-}
-
 /*
  * There's no way to return an informative status from this function,
  * because any analysis (and printing of error messages) needs to be
@@ -282,6 +196,9 @@ static void setup_efi_pci(struct boot_params *params)
 	void **pci_handle = NULL;
 	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
 	unsigned long size = 0;
+	unsigned long nr_pci;
+	struct setup_data *data;
+	int i;
 
 	status = efi_call_early(locate_handle,
 				EFI_LOCATE_BY_PROTOCOL,
@@ -305,10 +222,34 @@ static void setup_efi_pci(struct boot_params *params)
 	if (status != EFI_SUCCESS)
 		goto free_handle;
 
-	if (efi_early->is64)
-		setup_efi_pci64(params, pci_handle, size);
-	else
-		setup_efi_pci32(params, pci_handle, size);
+	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
+
+	while (data && data->next)
+		data = (struct setup_data *)(unsigned long)data->next;
+
+	nr_pci = size / (efi_is_64bit() ? sizeof(u64) : sizeof(u32));
+	for (i = 0; i < nr_pci; i++) {
+		efi_pci_io_protocol_t *pci = NULL;
+		struct pci_setup_rom *rom;
+
+		status = efi_call_early(handle_protocol,
+					efi_is_64bit() ? ((u64 *)pci_handle)[i]
+						       : ((u32 *)pci_handle)[i],
+					&pci_proto, (void **)&pci);
+		if (status != EFI_SUCCESS || !pci)
+			continue;
+
+		status = preserve_pci_rom_image(pci, &rom);
+		if (status != EFI_SUCCESS)
+			continue;
+
+		if (data)
+			data->next = (unsigned long)rom;
+		else
+			params->hdr.setup_data = (unsigned long)rom;
+
+		data = (struct setup_data *)rom;
+	}
 
 free_handle:
 	efi_call_early(free_pool, pci_handle);
-- 
2.17.1
