From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: v4.4-rc8 based tip tree kernel hangs on boot.
Date: Fri, 15 Jan 2016 22:29:21 +0000
Message-ID: <20160115222921.GA5378@codeblueprint.co.uk>
References: <20160110192921.GD17012@linux.vnet.ibm.com>
 <20160111140140.GA2644@codeblueprint.co.uk>
 <20160112103043.GA5707@gmail.com>
 <20160115162011.GA2935@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160115162011.GA2935-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srikar Dronamraju <srikar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 15 Jan, at 09:50:11PM, Srikar Dronamraju wrote:
> 
> So when I cherry-pick 67a9108 "x86/efi: Build our own page table
> structures", the built kernel stops booting.
 
Yeah, figures. At least that's less surprising that the linker script
change causing your machine to stop booting.

> i.e until until I cherry-pick c9f2a9a, the kernel boots.
> 
> I still have to verify why git bisect was failing to give the right
> commit.
> 
> Attached the dmesg of a good kernel boot as requested by Matt.

Can you confirm that CONFIG_DEBUG_WX isn't enabled in the .config you
used to test tip? Because the dmesg you attached shows that it is
enabled, but it wasn't enabled in the .config you attached in the
beginning of this thread.

Was it disabled when you tested commit 67a9108?

Could you try the following patch on top of commit c9f2a9a ("x86/efi:
Hoist page table switching code into efi_call_virt()")? Be sure to
enable CONFIG_EFI_PGT_DUMP and send me the output of dmesg.

---

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 347eeacb06a8..8fd9e637629a 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -136,6 +136,7 @@ extern void __init efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
 extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
+extern int __init efi_alloc_page_tables(void);
 extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init old_map_region(efi_memory_desc_t *md);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ad285404ea7f..8f778817ae9f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -895,6 +895,12 @@ static void __init __efi_enter_virtual_mode(void)
 
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
index b19cdac959b2..71121a9d06cf 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -40,6 +40,7 @@
 #include <asm/fixmap.h>
 #include <asm/realmode.h>
 #include <asm/time.h>
+#include <asm/pgalloc.h>
 
 /*
  * We allocate runtime services regions bottom-up, starting from -4G, i.e.
@@ -121,6 +122,41 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
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
@@ -128,6 +164,9 @@ void efi_sync_low_kernel_mappings(void)
 {
 	unsigned num_pgds;
 	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+	unsigned num_entries;
+	pgd_t *pgd_k, *pgd_efi;
+	pud_t *pud_k, *pud_efi;
 
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return;
@@ -137,6 +176,46 @@ void efi_sync_low_kernel_mappings(void)
 	memcpy(pgd + pgd_index(PAGE_OFFSET),
 		init_mm.pgd + pgd_index(PAGE_OFFSET),
 		sizeof(pgd_t) * num_pgds);
+
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
+
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
@@ -337,6 +416,7 @@ void __init efi_dump_pagetable(void)
 	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
 
 	ptdump_walk_pgd_level(NULL, pgd);
+	ptdump_walk_pgd_level(NULL, efi_pgd);
 #endif
 }
 
