From: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v2] arm64:efi fix the format of debug message from efi
Date: Fri, 27 May 2016 17:27:24 +0800
Message-ID: <1464341244-14152-1-git-send-email-dennis.chen@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, steve.capper-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.orgnd-5wv7dgnIgG8@public.gmane.org, Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When enable debug of efi and memblock with 'efi=debug memblock=debug' appended
to the kernel command line, the debug message output for earyly_con looks like:

[    0.000000] efi:   0x0000e1050000-0x0000e105ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x0000e1300000-0x0000e1300fff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x0000e8200000-0x0000e827ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x008000000000-0x008001e7ffff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00008000000000-0x00008001e7ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] *
...

This patch is trying to fix the above output messed up by memblock_add(), so we can get below debug mesg looks
more formally after applied:

[    0.000000] efi:   0x0000e1050000-0x0000e105ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x0000e1300000-0x0000e1300fff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x0000e8200000-0x0000e827ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x008000000000-0x008001e7ffff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] memblock_add: [0x00008000000000-0x00008001e7ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
...

Signed-off-by: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Since v1[1]:
 According to the suggestion from Mark Rutland, v2 folds the pr_cont("\n") into pr_info.
 [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-May/431233.html
---
 drivers/firmware/efi/arm-init.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index a850cbc..c49d50e 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -174,6 +174,7 @@ static __init void reserve_regions(void)
 {
 	efi_memory_desc_t *md;
 	u64 paddr, npages, size;
+	int resv;
 
 	if (efi_enabled(EFI_DBG))
 		pr_info("Processing EFI memory map:\n");
@@ -190,12 +191,14 @@ static __init void reserve_regions(void)
 		paddr = md->phys_addr;
 		npages = md->num_pages;
 
+		resv = is_reserve_region(md);
 		if (efi_enabled(EFI_DBG)) {
 			char buf[64];
 
-			pr_info("  0x%012llx-0x%012llx %s",
+			pr_info("  0x%012llx-0x%012llx %s%s\n",
 				paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
-				efi_md_typeattr_format(buf, sizeof(buf), md));
+				efi_md_typeattr_format(buf, sizeof(buf), md),
+				resv ? "*" : "");
 		}
 
 		memrange_efi_to_native(&paddr, &npages);
@@ -204,14 +207,9 @@ static __init void reserve_regions(void)
 		if (is_normal_ram(md))
 			early_init_dt_add_memory_arch(paddr, size);
 
-		if (is_reserve_region(md)) {
+		if (resv)
 			memblock_mark_nomap(paddr, size);
-			if (efi_enabled(EFI_DBG))
-				pr_cont("*");
-		}
 
-		if (efi_enabled(EFI_DBG))
-			pr_cont("\n");
 	}
 
 	set_bit(EFI_MEMMAP, &efi.flags);
-- 
2.7.4
