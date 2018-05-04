From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 15/17] efi/x86: Ignore unrealistically large option roms
Date: Fri,  4 May 2018 08:00:01 +0200
Message-ID: <20180504060003.19618-16-ard.biesheuvel@linaro.org>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Hans de Goede <hdegoede@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

setup_efi_pci() tries to save a copy of each PCI option ROM as this may
be necessary for the device driver for the PCI device to have access too.

On some systems the efi_pci_io_protocol's romimage and romsize fields
contain invalid data, which looks a bit like pointers pointing back into
other EFI code or data. Interpreting these pointers as romsize leads to
a very large value and if we then try to alloc this amount of memory to
save a copy the alloc call fails.

This leads to a "Failed to alloc mem for rom" error being printed on the
EFI console for each PCI device.

This commit avoids the printing of these errors, by checking romsize before
doing the alloc and if it is larger then the EFI spec limit of 16 MiB
silently ignore the ROM fields instead of trying to alloc mem and fail.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
[ardb: deduplicate 32/64 bit changes, use SZ_16M symbolic constant]
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index dadf32312082..720b06e86698 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -123,10 +123,17 @@ __setup_efi_pci(efi_pci_io_protocol_t *pci, struct pci_setup_rom **__rom)
 	if (status != EFI_SUCCESS)
 		return status;
 
+	/*
+	 * Some firmwares contain EFI function pointers at the place where the
+	 * romimage and romsize fields are supposed to be. Typically the EFI
+	 * code is mapped at high addresses, translating to an unrealistically
+	 * large romsize. The UEFI spec limits the size of option ROMs to 16
+	 * MiB so we reject any roms over 16 MiB in size to catch this.
+	 */
 	romimage = (void *)(unsigned long)efi_table_attr(efi_pci_io_protocol,
 							 romimage, pci);
 	romsize = efi_table_attr(efi_pci_io_protocol, romsize, pci);
-	if (!romimage || !romsize)
+	if (!romimage || !romsize || romsize > SZ_16M)
 		return EFI_INVALID_PARAMETER;
 
 	size = romsize + sizeof(*rom);
-- 
2.17.0
