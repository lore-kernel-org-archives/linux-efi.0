From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: Clean up the efi_call_phys_[prolog|epilog]()
 save/restore interaction
Date: Tue, 3 Mar 2015 07:48:50 +0100
Message-ID: <20150303064850.GA30036@gmail.com>
References: <20150303025804.GA24587@kt-Inspiron-3542>
 <20150303063433.GA30468@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150303063433.GA30468-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tapasweni Pathak <tapaswenipathak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


Also clean up the save_pgd global variable while at it.

untested as well.

Thanks,

	Ingo

==============>
>From 166625ceaef68fcbeee63adc63c02d75abcaf0db Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 3 Mar 2015 07:42:48 +0100
Subject: [PATCH] efi: Clean up the efi_call_phys_[prolog|epilog]() save/restore interaction

Currently x86-64 efi_call_phys_prolog() saves into a global variable (save_pgd),
and efi_call_phys_epilog() restores the kernel pagetables from that global
variable.

Change this to a cleaner save/restore pattern where the saving function returns
the saved object and the restore function restores that.

Apply the same concept to the 32-bit code as well.

Plus this approach, as an added bonus, allows us to express the
!efi_enabled(EFI_OLD_MEMMAP) situation in a clean fashion as well,
via a 'NULL' return value.

Cc: Tapasweni Pathak <tapaswenipathak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 arch/x86/include/asm/efi.h     |  6 ++++--
 arch/x86/platform/efi/efi.c    |  5 +++--
 arch/x86/platform/efi/efi_32.c | 11 ++++++++---
 arch/x86/platform/efi/efi_64.c | 26 ++++++++++++++++----------
 4 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 25bce45c6fc4..3738b138b843 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -2,6 +2,8 @@
 #define _ASM_X86_EFI_H
 
 #include <asm/i387.h>
+#include <asm/pgtable.h>
+
 /*
  * We map the EFI regions needed for runtime services non-contiguously,
  * with preserved alignment on virtual addresses starting from -4G down
@@ -89,8 +91,8 @@ extern void __iomem *__init efi_ioremap(unsigned long addr, unsigned long size,
 extern struct efi_scratch efi_scratch;
 extern void __init efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int __init efi_memblock_x86_reserve_range(void);
-extern void __init efi_call_phys_prolog(void);
-extern void __init efi_call_phys_epilog(void);
+extern pgd_t * __init efi_call_phys_prolog(void);
+extern void __init efi_call_phys_epilog(pgd_t *save_pgd);
 extern void __init efi_unmap_memmap(void);
 extern void __init efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2490a15d18f1..aa5bd2b986c2 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -86,8 +86,9 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 {
 	efi_status_t status;
 	unsigned long flags;
+	pgd_t *save_pgd;
 
-	efi_call_phys_prolog();
+	save_pgd = efi_call_phys_prolog();
 
 	/* Disable interrupts around EFI calls: */
 	local_irq_save(flags);
@@ -96,7 +97,7 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 			       descriptor_version, virtual_map);
 	local_irq_restore(flags);
 
-	efi_call_phys_epilog();
+	efi_call_phys_epilog(save_pgd);
 
 	return status;
 }
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index abecc6e1dc90..ed5b67338294 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -56,19 +56,24 @@ void __init efi_map_region(efi_memory_desc_t *md)
 void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
 void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
 
-void __init efi_call_phys_prolog(void)
+pgd_t * __init efi_call_phys_prolog(void)
 {
 	struct desc_ptr gdt_descr;
+	pgd_t *save_pgd;
 
+	/* Current pgd is swapper_pg_dir, we'll restore it later: */
+	save_pgd = swapper_pg_dir;
 	load_cr3(initial_page_table);
 	__flush_tlb_all();
 
 	gdt_descr.address = __pa(get_cpu_gdt_table(0));
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
+
+	return save_pgd;
 }
 
-void __init efi_call_phys_epilog(void)
+void __init efi_call_phys_epilog(pgd_t *save_pgd)
 {
 	struct desc_ptr gdt_descr;
 
@@ -76,7 +81,7 @@ void __init efi_call_phys_epilog(void)
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 
-	load_cr3(swapper_pg_dir);
+	load_cr3(save_pgd);
 	__flush_tlb_all();
 }
 
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 427eb3540e5f..a0ac0f9c307f 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -41,8 +41,6 @@
 #include <asm/realmode.h>
 #include <asm/time.h>
 
-static pgd_t *save_pgd __initdata;
-
 /*
  * We allocate runtime services regions bottom-up, starting from -4G, i.e.
  * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
@@ -77,14 +75,16 @@ static void __init early_code_mapping_set_exec(int executable)
 	}
 }
 
-void __init efi_call_phys_prolog(void)
+pgd_t * __init efi_call_phys_prolog(void)
 {
 	unsigned long vaddress;
+	pgd_t *save_pgd;
+
 	int pgd;
 	int n_pgds;
 
 	if (!efi_enabled(EFI_OLD_MEMMAP))
-		return;
+		return NULL;
 
 	early_code_mapping_set_exec(1);
 
@@ -97,22 +97,28 @@ void __init efi_call_phys_prolog(void)
 		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
 	}
 	__flush_tlb_all();
+
+	return save_pgd;
 }
 
-void __init efi_call_phys_epilog(void)
+void __init efi_call_phys_epilog(pgd_t *save_pgd)
 {
 	/*
 	 * After the lock is released, the original page table is restored.
 	 */
-	int pgd;
-	int n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
+	int pgd_idx;
+	int nr_pgds;
 
-	if (!efi_enabled(EFI_OLD_MEMMAP))
+	if (!save_pgd)
 		return;
 
-	for (pgd = 0; pgd < n_pgds; pgd++)
-		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), save_pgd[pgd]);
+	nr_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
+
+	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++)
+		set_pgd(pgd_offset_k(pgd_idx * PGDIR_SIZE), save_pgd[pgd_idx]);
+
 	kfree(save_pgd);
+
 	__flush_tlb_all();
 	early_code_mapping_set_exec(0);
 }
