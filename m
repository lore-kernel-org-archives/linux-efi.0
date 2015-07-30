From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] x86_64/efi: Mapping Boot and Runtime EFI memory regions to different starting virtual address
Date: Thu, 30 Jul 2015 12:32:37 +0800
Message-ID: <1438230757-30840-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When testing hibernate, I found the EFI runtime services was broken
on some old EFI machines on my hand, Intel DQ57TM development board
and Acer Gateway Z5WT2 notebook.

After printing the EFI memmap and virtual address mapping on -4G area,
found those issue machines keep the physical address of Runtime
Data/Code regions unchanged but not Boot Data/Code. The logs were
attached on openSUSE bug:
    https://bugzilla.suse.com/show_bug.cgi?id=939979

Due to Boot Data/Code can be used by OS as available memory regions,
so those old EFI BIOS do not keep the physical address of Boot regions
unchanged. But, address of Runtime regions are the same.

On Intel DQ57TM, sometimes the order of EFI Boot regions changed. On
Acer Gateway Z5WT2, the amount of EFI Boot regions changed.

The above changing of EFI Boot regions causes the EFI Runtime Data/Code
may not mapping to constant virtual address, that's because the EFI Boot
and Runtime regions are interleaved and EFI va mapping applied PMD
2M-aligned logic.

A workaround of this situation is mapping Boot and Runtime regions to
different starting virtual address. Then the changing of Boot Data/Code
regions will not affect to the virtual address mapping to Runtime
Data/Code.

This patch adds codes for mapping Boot Data/Code regions start from
0xffff_ffff_0000_0000, has 1G space. And mapping Runtime Data/Code
regions start from 0xffff_fffe_c000_0000 that has 63G space.

Link: https://bugzilla.suse.com/show_bug.cgi?id=939979
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index a0ac0f9..fde7f8f 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -42,10 +42,14 @@
 #include <asm/time.h>
 
 /*
- * We allocate runtime services regions bottom-up, starting from -4G, i.e.
- * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
+ * We allocate boot and runtime services regions bottom-up, starting from -4G,
+ * i.e. 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
+ *
+ * Boot Data/Code are starting from 0xffff_ffff_0000_0000 (1G space)
+ * Runtime Data/Code are starting from 0xffff_fffe_c000_0000 (63G space)
  */
-static u64 efi_va = EFI_VA_START;
+static u64 efi_boot_va = EFI_VA_START;
+static u64 efi_runtime_va = EFI_VA_START - 0x40000000;
 
 /*
  * Scratch space used for switching the pagetable in the EFI stub
@@ -218,6 +222,7 @@ void __init efi_map_region(efi_memory_desc_t *md)
 {
 	unsigned long size = md->num_pages << PAGE_SHIFT;
 	u64 pa = md->phys_addr;
+	u64 *efi_va = &efi_boot_va;
 
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return old_map_region(md);
@@ -239,30 +244,33 @@ void __init efi_map_region(efi_memory_desc_t *md)
 		return;
 	}
 
-	efi_va -= size;
+	if (md->attribute & EFI_MEMORY_RUNTIME)
+		efi_va = &efi_runtime_va;
+
+	*efi_va -= size;
 
 	/* Is PA 2M-aligned? */
 	if (!(pa & (PMD_SIZE - 1))) {
-		efi_va &= PMD_MASK;
+		*efi_va &= PMD_MASK;
 	} else {
 		u64 pa_offset = pa & (PMD_SIZE - 1);
-		u64 prev_va = efi_va;
+		u64 prev_va = *efi_va;
 
 		/* get us the same offset within this 2M page */
-		efi_va = (efi_va & PMD_MASK) + pa_offset;
+		*efi_va = (*efi_va & PMD_MASK) + pa_offset;
 
-		if (efi_va > prev_va)
-			efi_va -= PMD_SIZE;
+		if (*efi_va > prev_va)
+			*efi_va -= PMD_SIZE;
 	}
 
-	if (efi_va < EFI_VA_END) {
+	if (*efi_va < EFI_VA_END) {
 		pr_warn(FW_WARN "VA address range overflow!\n");
 		return;
 	}
 
 	/* Do the VA map */
-	__map_region(md, efi_va);
-	md->virt_addr = efi_va;
+	__map_region(md, *efi_va);
+	md->virt_addr = *efi_va;
 }
 
 /*
-- 
1.8.4.5
