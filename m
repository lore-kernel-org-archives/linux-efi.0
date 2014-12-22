From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/8] arm64/efi: register UEFI reserved regions as iomem resources
Date: Mon, 22 Dec 2014 19:08:36 +0000
Message-ID: <1419275322-29811-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1419275322-29811-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1419275322-29811-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

To prevent device drivers from attaching to device or memory regions
owned by the firmware, register all UEFI reserved regions in the iomem
resource table at init time.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index d2f483a7cffe..ba5fe66c3634 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -305,6 +305,50 @@ void efi_virtmap_unload(void)
 	efi_set_pgd(current->active_mm);
 }
 
+static __init void efi_reserve_iomem_resource(efi_memory_desc_t *md)
+{
+	struct resource *res;
+
+	res = alloc_bootmem_low(sizeof(*res));
+	res->start = md->phys_addr;
+	res->end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
+	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+
+	if (!is_reserve_region(md)) {
+		/*
+		 * Non-RAM regions with the EFI_MEMORY_RUNTIME attribute
+		 * are owned by the UEFI firmware, so make sure they are
+		 * tagged as exclusive: this will prevent device drivers
+		 * from binding to the memory region, and will also prevent
+		 * access via /dev/mem if CONFIG_STRICT_DEVMEM is in effect.
+		 */
+		res->name = "UEFI Runtime [MMIO]";
+		res->flags |= IORESOURCE_EXCLUSIVE;
+	} else if (md->type == EFI_RUNTIME_SERVICES_DATA) {
+		/*
+		 * UEFI Runtime Services Data regions may be used to store
+		 * configuration tables such as SMBIOS, which are often
+		 * accessed using userland tools such as 'dmidecode', that
+		 * are /dev/mem based. So don't set the exclusive flag in
+		 * this case.
+		 */
+		res->name = "UEFI Runtime [Data]";
+	} else {
+		/*
+		 * Register all remaining reserved RAM regions as both busy
+		 * and exclusive in the iomem resource table. This prevents
+		 * drivers from claiming the region, and also disallows
+		 * /dev/mem access.
+		 */
+		if (md->type == EFI_RUNTIME_SERVICES_CODE)
+			res->name = "UEFI Runtime [Code]";
+		else
+			res->name = "UEFI Reserved";
+		res->flags |= IORESOURCE_EXCLUSIVE;
+	}
+	request_resource(&iomem_resource, res);
+}
+
 void __init efi_virtmap_init(void)
 {
 	efi_memory_desc_t *md;
@@ -316,6 +360,8 @@ void __init efi_virtmap_init(void)
 		u64 paddr, npages, size;
 		pgprot_t prot;
 
+		if (is_reserve_region(md) || md->attribute & EFI_MEMORY_RUNTIME)
+			efi_reserve_iomem_resource(md);
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
 		if (WARN(md->virt_addr == 0,
-- 
1.8.3.2
