From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 13/17] efi: align efi_pci_io_protocol typedefs to type naming convention
Date: Fri,  4 May 2018 07:59:59 +0200
Message-ID: <20180504060003.19618-14-ard.biesheuvel@linaro.org>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

In order to use the helper macros that perform type mangling with the
EFI PCI I/O protocol struct typedefs, align their Linux typenames with
the convention we use for definitionns that originate in the UEFI spec,
and add the trailing _t to each.

Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c | 8 ++++----
 include/linux/efi.h              | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 09f36c0d9d4f..3994f48c4043 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -109,7 +109,7 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 }
 
 static efi_status_t
-__setup_efi_pci32(efi_pci_io_protocol_32 *pci, struct pci_setup_rom **__rom)
+__setup_efi_pci32(efi_pci_io_protocol_32_t *pci, struct pci_setup_rom **__rom)
 {
 	struct pci_setup_rom *rom = NULL;
 	efi_status_t status;
@@ -176,7 +176,7 @@ static void
 setup_efi_pci32(struct boot_params *params, void **pci_handle,
 		unsigned long size)
 {
-	efi_pci_io_protocol_32 *pci = NULL;
+	efi_pci_io_protocol_32_t *pci = NULL;
 	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
 	u32 *handles = (u32 *)(unsigned long)pci_handle;
 	efi_status_t status;
@@ -218,7 +218,7 @@ setup_efi_pci32(struct boot_params *params, void **pci_handle,
 }
 
 static efi_status_t
-__setup_efi_pci64(efi_pci_io_protocol_64 *pci, struct pci_setup_rom **__rom)
+__setup_efi_pci64(efi_pci_io_protocol_64_t *pci, struct pci_setup_rom **__rom)
 {
 	struct pci_setup_rom *rom;
 	efi_status_t status;
@@ -284,7 +284,7 @@ static void
 setup_efi_pci64(struct boot_params *params, void **pci_handle,
 		unsigned long size)
 {
-	efi_pci_io_protocol_64 *pci = NULL;
+	efi_pci_io_protocol_64_t *pci = NULL;
 	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
 	u64 *handles = (u64 *)(unsigned long)pci_handle;
 	efi_status_t status;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 3016d8c456bc..56add823f190 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -397,7 +397,7 @@ typedef struct {
 	u32 set_bar_attributes;
 	u64 romsize;
 	u32 romimage;
-} efi_pci_io_protocol_32;
+} efi_pci_io_protocol_32_t;
 
 typedef struct {
 	u64 poll_mem;
@@ -417,7 +417,7 @@ typedef struct {
 	u64 set_bar_attributes;
 	u64 romsize;
 	u64 romimage;
-} efi_pci_io_protocol_64;
+} efi_pci_io_protocol_64_t;
 
 typedef struct {
 	void *poll_mem;
@@ -437,7 +437,7 @@ typedef struct {
 	void *set_bar_attributes;
 	uint64_t romsize;
 	void *romimage;
-} efi_pci_io_protocol;
+} efi_pci_io_protocol_t;
 
 #define EFI_PCI_IO_ATTRIBUTE_ISA_MOTHERBOARD_IO 0x0001
 #define EFI_PCI_IO_ATTRIBUTE_ISA_IO 0x0002
-- 
2.17.0
