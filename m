From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2] fix setup_efi_pci()
Date: Fri, 18 Jan 2013 12:35:14 +0000
Message-ID: <50F94F9202000078000B74EE@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This fixes two issues:
- wrong memory type used for allocation intended to persist post-boot
- four similar build warnings on 32-bit (casts between different size
  pointers and integers)

Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
---
v2: Drop the change that was already applied separately (commit
    886d751a2ea99a160f2d0a472231566d9cb0cf58 "x86, efi: correct
    precedence of operators in setup_efi_pci")

---
 arch/x86/boot/compressed/eboot.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- 3.8-rc4/arch/x86/boot/compressed/eboot.c
+++ 3.8-rc4-x86-EFI-PCI-ROMs/arch/x86/boot/compressed/eboot.c
@@ -256,10 +256,10 @@ static efi_status_t setup_efi_pci(struct
 	int i;
 	struct setup_data *data;
 
-	data = (struct setup_data *)params->hdr.setup_data;
+	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
 
 	while (data && data->next)
-		data = (struct setup_data *)data->next;
+		data = (struct setup_data *)(unsigned long)data->next;
 
 	status = efi_call_phys5(sys_table->boottime->locate_handle,
 				EFI_LOCATE_BY_PROTOCOL, &pci_proto,
@@ -311,7 +311,7 @@ static efi_status_t setup_efi_pci(struct
 		size = pci->romsize + sizeof(*rom);
 
 		status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, &rom);
+					EFI_RUNTIME_SERVICES_DATA, size, &rom);
 
 		if (status != EFI_SUCCESS)
 			continue;
@@ -345,9 +345,9 @@ static efi_status_t setup_efi_pci(struct
 		memcpy(rom->romdata, pci->romimage, pci->romsize);
 
 		if (data)
-			data->next = (uint64_t)rom;
+			data->next = (unsigned long)rom;
 		else
-			params->hdr.setup_data = (uint64_t)rom;
+			params->hdr.setup_data = (unsigned long)rom;
 
 		data = (struct setup_data *)rom;
 
