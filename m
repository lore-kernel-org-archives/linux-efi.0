From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 1/6] of/fdt: make generic early_init_dt_add_memory_arch() a weak alias
Date: Mon, 21 Sep 2015 17:21:23 -0700
Message-ID: <1442881288-13962-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1442881288-13962-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442881288-13962-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The function early_init_dt_add_memory_arch() is defined as __weak
so that archs can override it. However, in this override implementation,
it may still be useful to invoke the generic implementation, so instead,
rename the generic version to early_init_dt_add_memory() and turn the
original definition into a weak alias. This way, the generic version can
still be called even in the presence of an arch specific override.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/of/fdt.c       | 7 +++++--
 include/linux/of_fdt.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 07496560e5b9..8b758e10c9f8 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -969,7 +969,7 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 #ifdef CONFIG_HAVE_MEMBLOCK
 #define MAX_PHYS_ADDR	((phys_addr_t)~0)
 
-void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
+void __init early_init_dt_add_memory(u64 base, u64 size)
 {
 	const u64 phys_offset = __pa(PAGE_OFFSET);
 
@@ -1027,7 +1027,7 @@ void * __init __weak early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	return __va(memblock_alloc(size, align));
 }
 #else
-void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
+void __init early_init_dt_add_memory(u64 base, u64 size)
 {
 	WARN_ON(1);
 }
@@ -1047,6 +1047,9 @@ void * __init __weak early_init_dt_alloc_memory_arch(u64 size, u64 align)
 }
 #endif
 
+__weak __alias(early_init_dt_add_memory)
+void early_init_dt_add_memory_arch(u64 base, u64 size);
+
 bool __init early_init_dt_verify(void *params)
 {
 	if (!params)
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index df9ef3801812..463a06ba87ac 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -65,6 +65,7 @@ extern int early_init_dt_scan_memory(unsigned long node, const char *uname,
 				     int depth, void *data);
 extern void early_init_fdt_scan_reserved_mem(void);
 extern void early_init_fdt_reserve_self(void);
+extern void early_init_dt_add_memory(u64 base, u64 size);
 extern void early_init_dt_add_memory_arch(u64 base, u64 size);
 extern int early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
 					     bool no_map);
-- 
1.9.1
