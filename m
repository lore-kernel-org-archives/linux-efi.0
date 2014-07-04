From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] efi/arm64: handle missing virtual mapping for UEFI System Table
Date: Fri,  4 Jul 2014 12:16:37 +0200
Message-ID: <1404468997-6925-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

If we cannot resolve the virtual address of the UEFI System Table, its physical
offset must be missing from the virtual memory map, and there is really no point
in proceeding with installing the virtual memory map and the runtime services
dispatch table. So back out gracefully.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---

v2:
- release mappings and free virtmap before bailing

 arch/arm64/kernel/efi.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 56c3327bbf79..23942158e0f8 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -416,11 +416,23 @@ static int __init arm64_enter_virtual_mode(void)
 			continue;
 		if (remap_region(md, &virt_md))
 			++count;
+		else
+			goto err_unmap;
 	}
 
 	efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
-	if (efi.systab)
-		set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+	if (!efi.systab) {
+		/*
+		 * If we have no virtual mapping for the System Table at this
+		 * point, the memory map doesn't cover the physical offset where
+		 * it resides. This means the System Table will be inaccessible
+		 * to Runtime Services themselves once the virtual mapping is
+		 * installed.
+		 */
+		pr_err("Failed to remap EFI System Table -- buggy firmware?\n");
+		goto err_unmap;
+	}
+	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
 
 	local_irq_save(flags);
 	cpu_switch_mm(idmap_pg_dir, &init_mm);
@@ -453,5 +465,17 @@ static int __init arm64_enter_virtual_mode(void)
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
 	return 0;
+
+err_unmap:
+	/* unmap all mappings that succeeded: there are 'count' of those */
+	for_each_efi_memory_desc(&memmap, md) {
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+			continue;
+		if (!count--)
+			break;
+		iounmap((__force void *)md->virt_addr);
+	}
+	kfree(virtmap);
+	return -1;
 }
 early_initcall(arm64_enter_virtual_mode);
-- 
1.8.3.2
