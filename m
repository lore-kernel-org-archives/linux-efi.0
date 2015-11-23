From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH v2 5/6] x86/efi: Build our own page table structures
Date: Mon, 23 Nov 2015 13:33:13 +0000
Message-ID: <1448285594-17617-6-git-send-email-matt@codeblueprint.co.uk>
References: <1448285594-17617-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448285594-17617-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

With commit e1a58320a38d ("x86/mm: Warn on W^X mappings") all users
booting on 64-bit UEFI machines see the following warning,

  ------------[ cut here ]------------
  WARNING: CPU: 7 PID: 1 at arch/x86/mm/dump_pagetables.c:225 note_page+0x5dc/0x780()
  x86/mm: Found insecure W+X mapping at address ffff88000005f000/0xffff88000005f000
  ...
  x86/mm: Checked W+X mappings: FAILED, 165660 W+X pages found.
  ...

This is caused by mapping EFI regions with RWX permissions. There
isn't much we can do to restrict the permissions for these regions due
to the way the firmware toolchains mix code and data, but we can at
least isolate these mappings so that they do not appear in the regular
kernel page tables.

In commit d2f7cbe7b26a ("x86/efi: Runtime services virtual mapping")
we started using 'trampoline_pgd' to map the EFI regions because there
was an existing identity mapping there which we use during the
SetVirtualAddressMap() call and for broken firmware that accesses
those addresses.

But 'trampoline_pgd' shares some PGD entries with 'swapper_pg_dir' and
does not provide the isolation we require. Notably the virtual address
for __START_KERNEL_map and MODULES_START are mapped by the same PGD
entry so we need to be more careful when copying changes over in
efi_sync_low_kernel_mappings().

This patch doesn't go the full mile, we still want to share some PGD
entries with 'swapper_pg_dir'. Having completely separate page tables
brings its own issues such as synchronising new mappings after memory
hotplug and module loading. Sharing also keeps memory usage down.

Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
Cc: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---

Changes in v2:
 - Move efi_alloc_page_tables() earlier in __efi_enter_virtual_mode()
   so we return early if we fail to allocate memory.

 - More checkpatch warning fixes.

 - Ident the BUILD_BUG_ON() asserts according to Boris' request

 arch/x86/include/asm/efi.h     |  1 +
 arch/x86/platform/efi/efi.c    | 39 ++++++-----------
 arch/x86/platform/efi/efi_32.c |  5 +++
 arch/x86/platform/efi/efi_64.c | 97 +++++++++++++++++++++++++++++++++++-------
 4 files changed, 102 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0eb45a187339..9be9f4963070 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -124,6 +124,7 @@ extern void __init efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
 extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
+extern int __init efi_alloc_page_tables(void);
 extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init old_map_region(efi_memory_desc_t *md);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c69e58fb7f19..e1f7c7f79ec5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -804,7 +804,7 @@ static void __init kexec_enter_virtual_mode(void)
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, we look through the EFI memmap and map every region that
  * has the runtime attribute bit set in its memory descriptor into the
- * ->trampoline_pgd page table using a top-down VA allocation scheme.
+ * efi_pgd page table.
  *
  * The old method which used to update that memory descriptor with the
  * virtual address obtained from ioremap() is still supported when the
@@ -814,8 +814,8 @@ static void __init kexec_enter_virtual_mode(void)
  *
  * The new method does a pagetable switch in a preemption-safe manner
  * so that we're in a different address space when calling a runtime
- * function. For function arguments passing we do copy the PGDs of the
- * kernel page table into ->trampoline_pgd prior to each call.
+ * function. For function arguments passing we do copy the PUDs of the
+ * kernel page table into efi_pgd prior to each call.
  *
  * Specially for kexec boot, efi runtime maps in previous kernel should
  * be passed in via setup_data. In that case runtime ranges will be mapped
@@ -830,6 +830,12 @@ static void __init __efi_enter_virtual_mode(void)
 
 	efi.systab = NULL;
 
+	if (efi_alloc_page_tables()) {
+		pr_err("Failed to allocate EFI page tables\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return;
+	}
+
 	efi_merge_regions();
 	new_memmap = efi_map_regions(&count, &pg_shift);
 	if (!new_memmap) {
@@ -889,28 +895,11 @@ static void __init __efi_enter_virtual_mode(void)
 	efi_runtime_mkexec();
 
 	/*
-	 * We mapped the descriptor array into the EFI pagetable above but we're
-	 * not unmapping it here. Here's why:
-	 *
-	 * We're copying select PGDs from the kernel page table to the EFI page
-	 * table and when we do so and make changes to those PGDs like unmapping
-	 * stuff from them, those changes appear in the kernel page table and we
-	 * go boom.
-	 *
-	 * From setup_real_mode():
-	 *
-	 * ...
-	 * trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
-	 *
-	 * In this particular case, our allocation is in PGD 0 of the EFI page
-	 * table but we've copied that PGD from PGD[272] of the EFI page table:
-	 *
-	 *	pgd_index(__PAGE_OFFSET = 0xffff880000000000) = 272
-	 *
-	 * where the direct memory mapping in kernel space is.
-	 *
-	 * new_memmap's VA comes from that direct mapping and thus clearing it,
-	 * it would get cleared in the kernel page table too.
+	 * We mapped the descriptor array into the EFI pagetable above
+	 * but we're not unmapping it here because if we're running in
+	 * EFI mixed mode we need all of memory to be accessible when
+	 * we pass parameters to the EFI runtime services in the
+	 * thunking code.
 	 *
 	 * efi_cleanup_page_tables(__pa(new_memmap), 1 << pg_shift);
 	 */
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index ed5b67338294..58d669bc8250 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -38,6 +38,11 @@
  * say 0 - 3G.
  */
 
+int __init efi_alloc_page_tables(void)
+{
+	return 0;
+}
+
 void efi_sync_low_kernel_mappings(void) {}
 void __init efi_dump_pagetable(void) {}
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 530e8cdc1764..4489f0945dcd 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -40,6 +40,7 @@
 #include <asm/fixmap.h>
 #include <asm/realmode.h>
 #include <asm/time.h>
+#include <asm/pgalloc.h>
 
 /*
  * We allocate runtime services regions bottom-up, starting from -4G, i.e.
@@ -121,22 +122,92 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
 	early_code_mapping_set_exec(0);
 }
 
+static pgd_t *efi_pgd;
+
+/*
+ * We need our own copy of the higher levels of the page tables
+ * because we want to avoid inserting EFI region mappings (EFI_VA_END
+ * to EFI_VA_START) into the standard kernel page tables. Everything
+ * else can be shared, see efi_sync_low_kernel_mappings().
+ */
+int __init efi_alloc_page_tables(void)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	gfp_t gfp_mask;
+
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		return 0;
+
+	gfp_mask = GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO;
+	efi_pgd = (pgd_t *)__get_free_page(gfp_mask);
+	if (!efi_pgd)
+		return -ENOMEM;
+
+	pgd = efi_pgd + pgd_index(EFI_VA_END);
+
+	pud = pud_alloc_one(NULL, 0);
+	if (!pud) {
+		free_page((unsigned long)efi_pgd);
+		return -ENOMEM;
+	}
+
+	pgd_populate(NULL, pgd, pud);
+
+	return 0;
+}
+
 /*
  * Add low kernel mappings for passing arguments to EFI functions.
  */
 void efi_sync_low_kernel_mappings(void)
 {
-	unsigned num_pgds;
-	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+	unsigned num_entries;
+	pgd_t *pgd_k, *pgd_efi;
+	pud_t *pud_k, *pud_efi;
 
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return;
 
-	num_pgds = pgd_index(MODULES_END - 1) - pgd_index(PAGE_OFFSET);
+	/*
+	 * We can share all PGD entries apart from the one entry that
+	 * covers the EFI runtime mapping space.
+	 *
+	 * Make sure the EFI runtime region mappings are guaranteed to
+	 * only span a single PGD entry and that the entry also maps
+	 * other important kernel regions.
+	 */
+	BUILD_BUG_ON(pgd_index(EFI_VA_END) != pgd_index(MODULES_END));
+	BUILD_BUG_ON((EFI_VA_START & PGDIR_MASK) !=
+			(EFI_VA_END & PGDIR_MASK));
+
+	pgd_efi = efi_pgd + pgd_index(PAGE_OFFSET);
+	pgd_k = pgd_offset_k(PAGE_OFFSET);
+
+	num_entries = pgd_index(EFI_VA_END) - pgd_index(PAGE_OFFSET);
+	memcpy(pgd_efi, pgd_k, sizeof(pgd_t) * num_entries);
 
-	memcpy(pgd + pgd_index(PAGE_OFFSET),
-		init_mm.pgd + pgd_index(PAGE_OFFSET),
-		sizeof(pgd_t) * num_pgds);
+	/*
+	 * We share all the PUD entries apart from those that map the
+	 * EFI regions. Copy around them.
+	 */
+	BUILD_BUG_ON((EFI_VA_START & ~PUD_MASK) != 0);
+	BUILD_BUG_ON((EFI_VA_END & ~PUD_MASK) != 0);
+
+	pgd_efi = efi_pgd + pgd_index(EFI_VA_END);
+	pud_efi = pud_offset(pgd_efi, 0);
+
+	pgd_k = pgd_offset_k(EFI_VA_END);
+	pud_k = pud_offset(pgd_k, 0);
+
+	num_entries = pud_index(EFI_VA_END);
+	memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
+
+	pud_efi = pud_offset(pgd_efi, EFI_VA_START);
+	pud_k = pud_offset(pgd_k, EFI_VA_START);
+
+	num_entries = PTRS_PER_PUD - pud_index(EFI_VA_START);
+	memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
 }
 
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
@@ -150,8 +221,8 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return 0;
 
-	efi_scratch.efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
-	pgd = __va(efi_scratch.efi_pgt);
+	efi_scratch.efi_pgt = (pgd_t *)__pa(efi_pgd);
+	pgd = efi_pgd;
 
 	/*
 	 * It can happen that the physical address of new_memmap lands in memory
@@ -216,16 +287,14 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 
 void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
-	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
-
-	kernel_unmap_pages_in_pgd(pgd, pa_memmap, num_pages);
+	kernel_unmap_pages_in_pgd(efi_pgd, pa_memmap, num_pages);
 }
 
 static void __init __map_region(efi_memory_desc_t *md, u64 va)
 {
-	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
 	unsigned long flags = 0;
 	unsigned long pfn;
+	pgd_t *pgd = efi_pgd;
 
 	if (!(md->attribute & EFI_MEMORY_WB))
 		flags |= _PAGE_PCD;
@@ -334,9 +403,7 @@ void __init efi_runtime_mkexec(void)
 void __init efi_dump_pagetable(void)
 {
 #ifdef CONFIG_EFI_PGT_DUMP
-	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
-
-	ptdump_walk_pgd_level(NULL, pgd);
+	ptdump_walk_pgd_level(NULL, efi_pgd);
 #endif
 }
 
-- 
2.6.2
