From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5/5] efi: bgrt: use efi_mem_type()
Date: Fri, 25 Aug 2017 16:50:19 +0100
Message-ID: <20170825155019.6740-6-ard.biesheuvel@linaro.org>
References: <20170825155019.6740-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170825155019.6740-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <JBeulich@suse.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

Avoid effectively open-coding the function.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi-bgrt.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index b58233e4ed71..50793fda7819 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -27,26 +27,6 @@ struct bmp_header {
 	u32 size;
 } __packed;
 
-static bool efi_bgrt_addr_valid(u64 addr)
-{
-	efi_memory_desc_t *md;
-
-	for_each_efi_memory_desc(md) {
-		u64 size;
-		u64 end;
-
-		if (md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
-
-		size = md->num_pages << EFI_PAGE_SHIFT;
-		end = md->phys_addr + size;
-		if (addr >= md->phys_addr && addr < end)
-			return true;
-	}
-
-	return false;
-}
-
 void __init efi_bgrt_init(struct acpi_table_header *table)
 {
 	void *image;
@@ -85,7 +65,7 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 		goto out;
 	}
 
-	if (!efi_bgrt_addr_valid(bgrt->image_address)) {
+	if (efi_mem_type(bgrt->image_address) != EFI_BOOT_SERVICES_DATA) {
 		pr_notice("Ignoring BGRT: invalid image address\n");
 		goto out;
 	}
-- 
2.11.0
