From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] efi: fix boot panic because of invalid bgrt image address
Date: Fri,  9 Jun 2017 08:45:58 +0000
Message-ID: <20170609084558.26766-2-ard.biesheuvel@linaro.org>
References: <20170609084558.26766-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170609084558.26766-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Dave Young <dyoung@redhat.com>

Maniaxx <tripleshiftone@gmail.com> reported a kernel boot failure of below:
(emulated the panic by using same invalid phys addr in code)
There are also a bug in bugzilla.kernel.org:
https://bugzilla.kernel.org/show_bug.cgi?id=195633

The reported panic happens after below commit:
7b0a911478c7 efi/x86: Move the EFI BGRT init code to early init code

The root cause is the firmware on those machines provides invalid bgrt
image addresses.

In a kernel before above commit bgrt initializes late and use ioremap
to map the image address. Ioremap validate the address, if it is not a
valid physical address ioremap just fails and returns. However in current
kernel efi bgrt initializes early and uses early_memremap which does not
validate the image address, and kernel panic happens.

According to ACPI spec the BGRT image address should fall into
EFI_BOOT_SERVICES_DATA, see the section 5.2.22.4 of below document:
http://www.uefi.org/sites/default/files/resources/ACPI_6_1.pdf

Fix this issue by validating the image address in efi_bgrt_init(). If the
image address does not fall into any EFI_BOOT_SERVICES_DATA areas we just
bail out.

  BUG: unable to handle kernel paging request at ffffffffff280001
  IP: efi_bgrt_init+0xfb/0x153
  ...
  Call Trace:
   ? bgrt_init+0xbc/0xbc
   acpi_parse_bgrt+0xe/0x12
   acpi_table_parse+0x89/0xb8
   acpi_boot_init+0x445/0x4e2
   ? acpi_parse_x2apic+0x79/0x79
   ? dmi_ignore_irq0_timer_override+0x33/0x33
   setup_arch+0xb63/0xc82
   ? early_idt_handler_array+0x120/0x120
   start_kernel+0xb7/0x443
   ? early_idt_handler_array+0x120/0x120
   x86_64_start_reservations+0x29/0x2b
   x86_64_start_kernel+0x154/0x177
   secondary_startup_64+0x9f/0x9f

Fixes: 7b0a911478c7 ("efi/x86: Move the EFI BGRT init code to early init code")
Reported-by: Maniaxx <tripleshiftone@gmail.com>
Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi-bgrt.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index 8bf27323f7a3..b58233e4ed71 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -27,6 +27,26 @@ struct bmp_header {
 	u32 size;
 } __packed;
 
+static bool efi_bgrt_addr_valid(u64 addr)
+{
+	efi_memory_desc_t *md;
+
+	for_each_efi_memory_desc(md) {
+		u64 size;
+		u64 end;
+
+		if (md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+
+		size = md->num_pages << EFI_PAGE_SHIFT;
+		end = md->phys_addr + size;
+		if (addr >= md->phys_addr && addr < end)
+			return true;
+	}
+
+	return false;
+}
+
 void __init efi_bgrt_init(struct acpi_table_header *table)
 {
 	void *image;
@@ -36,7 +56,7 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 	if (acpi_disabled)
 		return;
 
-	if (!efi_enabled(EFI_BOOT))
+	if (!efi_enabled(EFI_MEMMAP))
 		return;
 
 	if (table->length < sizeof(bgrt_tab)) {
@@ -65,6 +85,10 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 		goto out;
 	}
 
+	if (!efi_bgrt_addr_valid(bgrt->image_address)) {
+		pr_notice("Ignoring BGRT: invalid image address\n");
+		goto out;
+	}
 	image = early_memremap(bgrt->image_address, sizeof(bmp_header));
 	if (!image) {
 		pr_notice("Ignoring BGRT: failed to map image header memory\n");
-- 
2.9.3
