From: ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org
Subject: [PATCH 1/1] arch/x86: Add better error logging to efi main
Date: Thu, 10 Jul 2014 02:12:41 +0200
Message-ID: <1404951161-2677-1-git-send-email-ulf@winkelvos.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>

Hopefully this will enable us to better debug:
https://bugzilla.kernel.org/show_bug.cgi?id=68761

Signed-off-by: Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 3b5c66c..f277184 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1376,7 +1376,10 @@ struct boot_params *efi_main(struct efi_config *c,

	setup_graphics(boot_params);

-	setup_efi_pci(boot_params);
+	status = setup_efi_pci(boot_params);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "setup_efi_pci() failed!\n");
+	}

	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
				sizeof(*gdt), (void **)&gdt);
@@ -1403,16 +1406,20 @@ struct boot_params *efi_main(struct efi_config *c,
					     hdr->init_size, hdr->init_size,
					     hdr->pref_address,
					     hdr->kernel_alignment);
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table, "efi_relocate_kernel() failed!\n");
			goto fail;
+		}

		hdr->pref_address = hdr->code32_start;
		hdr->code32_start = bzimage_addr;
	}

	status = exit_boot(boot_params, handle, is64);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "exit_boot() failed!\n");
		goto fail;
+	}

	memset((char *)gdt->address, 0x0, gdt->size);
	desc = (struct desc_struct *)gdt->address;
@@ -1472,5 +1479,6 @@ struct boot_params *efi_main(struct efi_config *c,

	return boot_params;
 fail:
+	efi_printk(sys_table, "efi_main() failed!\n");
	return NULL;
 }
--
2.0.1
