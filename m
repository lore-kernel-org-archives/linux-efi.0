From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/1] efi/x86: remove pointless call to PciIo->Attributes()
Date: Wed, 11 Jul 2018 11:02:35 +0200
Message-ID: <20180711090235.9327-2-ard.biesheuvel@linaro.org>
References: <20180711090235.9327-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711090235.9327-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

When it was first introduced, the EFI stub code that copies the
contents of PCI option ROMs originally only intended to do so if
the EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM attribute was *not* set.

The reason was that the UEFI spec permits PCI option ROM images
to be provided by the platform directly, rather than via the ROM
BAR, and in this case, the OS can only access them at runtime if
they are preserved at boot time by copying them from the areas
described by PciIo->RomImage and PciIo->RomSize.

However, it implemented this check erroneously, as can be seen in
commit dd5fc854de5fd ("EFI: Stash ROMs if they're not in the PCI
BAR"):

    if (!attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM)
            continue;

and given that the numeric value of EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM
is 0x4000, this condition never becomes true, and so the option ROMs
were copied unconditionally.

This was spotted and 'fixed' by commit 886d751a2ea99a160
("x86, efi: correct precedence of operators in setup_efi_pci"),
but inadvertently inverted the logic at the same time, defeating
the purpose of the code, since it now only preserves option ROM
images that can be read from the ROM BAR as well.

Unsurprisingly, this broke some systems, and so the check was removed
entirely in commit 739701888f5d ("x86, efi: remove attribute check
from setup_efi_pci").

It is debatable whether this check should have been included in the
first place, since the option ROM image provided to the UEFI driver by
the firmware may be different from the one that is actually present in
the card's flash ROM, and so whatever PciIo->RomImage points at should
be preferred regardless of whether the attribute is set.

As this was the only use of the attributes field, we can remove
the call to PciIo->Attributes() entirely, which is especially
nice because its prototype involves uint64_t type by-value
arguments which the EFI mixed mode has trouble dealing with.

Tested-by: Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index e57665b4ba1c..e98522ea6f09 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -114,18 +114,12 @@ __setup_efi_pci(efi_pci_io_protocol_t *pci, struct pci_setup_rom **__rom)
 	struct pci_setup_rom *rom = NULL;
 	efi_status_t status;
 	unsigned long size;
-	uint64_t attributes, romsize;
+	uint64_t romsize;
 	void *romimage;
 
-	status = efi_call_proto(efi_pci_io_protocol, attributes, pci,
-				EfiPciIoAttributeOperationGet, 0ULL,
-				&attributes);
-	if (status != EFI_SUCCESS)
-		return status;
-
 	/*
-	 * Some firmware images contain EFI function pointers at the place where the
-	 * romimage and romsize fields are supposed to be. Typically the EFI
+	 * Some firmware images contain EFI function pointers at the place where
+	 * the romimage and romsize fields are supposed to be. Typically the EFI
 	 * code is mapped at high addresses, translating to an unrealistically
 	 * large romsize. The UEFI spec limits the size of option ROMs to 16
 	 * MiB so we reject any ROMs over 16 MiB in size to catch this.
-- 
2.17.1
