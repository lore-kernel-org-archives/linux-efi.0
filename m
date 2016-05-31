From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 2/2] efi/arm: Fix the format of debug message from efi
Date: Tue, 31 May 2016 11:23:44 +0100
Message-ID: <1464690224-4503-3-git-send-email-matt@codeblueprint.co.uk>
References: <1464690224-4503-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464690224-4503-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>, Steve McIntyre <steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>

When enable debug of efi and memblock with 'efi=debug memblock=debug' appended
to the kernel command line, the debug message output for earyly_con looks like:

[    0.000000] efi:   0x0000e1050000-0x0000e105ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x0000e1300000-0x0000e1300fff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x0000e8200000-0x0000e827ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x008000000000-0x008001e7ffff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00008000000000-0x00008001e7ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] *
...

This patch is trying to fix the above output messed up by memblock_add(),
so we can get below debug mesg looks more formally after applied:

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
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve McIntyre <steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/arm-init.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index a850cbc48d8d..c49d50e68aee 100644
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
2.7.3
