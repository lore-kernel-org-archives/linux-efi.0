From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2] efi: Ignore unrealistically large option roms
Date: Fri, 27 Apr 2018 23:35:09 +0200
Message-ID: <20180427213509.20385-1-hdegoede@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Hans de Goede <hdegoede@redhat.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

setup_efi_pci() tries to save a copy of each PCI option ROM as this may
be necessary for the device driver for the PCI device to have access too.

On some systems the efi_pci_io_protocol_64's romimage and romsize fields
contain invalid data, which looks a bit like pointers pointing back into
other EFI code or data. Interpreting these pointers as romsize leads to
a very large value and if we then try to alloc this amount of memory to
save a copy the alloc call fails.

This leads to a "Failed to alloc mem for rom" error being printed on the
EFI console for each PCI device.

This commit avoids the printing of these errors, by checking romsize
before doing the alloc and if it is larger then 256M silently ignore the
ROM fields instead of trying to alloc mem and fail.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Add the check to both __setup_efi_pci32 and __setup_efi_pci64 instead of
 only to __setup_efi_pci64, some CHT devices which need this still use a
 32 bit UEFI
---
 arch/x86/boot/compressed/eboot.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 47d3efff6805..6d3257a459c8 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -122,7 +122,13 @@ __setup_efi_pci32(efi_pci_io_protocol_32 *pci, struct pci_setup_rom **__rom)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!pci->romimage || !pci->romsize)
+	/*
+	 * Some firmwares contain EFI function pointers at the place where the
+	 * romimage and romsize fields are supposed to be. Typically the EFI
+	 * code is mapped at high addresses, translating to an unrealistically
+	 * large romsize. We reject any roms over 256M in size to catch this.
+	 */
+	if (!pci->romimage || !pci->romsize || pci->romsize > 0x10000000)
 		return EFI_INVALID_PARAMETER;
 
 	size = pci->romsize + sizeof(*rom);
@@ -230,7 +236,13 @@ __setup_efi_pci64(efi_pci_io_protocol_64 *pci, struct pci_setup_rom **__rom)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!pci->romimage || !pci->romsize)
+	/*
+	 * Some firmwares contain EFI function pointers at the place where the
+	 * romimage and romsize fields are supposed to be. Typically the EFI
+	 * code is mapped at high addresses, translating to an unrealistically
+	 * large romsize. We reject any roms over 256M in size to catch this.
+	 */
+	if (!pci->romimage || !pci->romsize || pci->romsize > 0x10000000)
 		return EFI_INVALID_PARAMETER;
 
 	size = pci->romsize + sizeof(*rom);
-- 
2.16.2
