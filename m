From: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: [PATCH 4/4] x86/efi: Mark initialization code as such
Date: Sun,  7 Sep 2014 19:42:17 +0200
Message-ID: <1410111737-5220-5-git-send-email-minipli@googlemail.com>
References: <1410111737-5220-1-git-send-email-minipli@googlemail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410111737-5220-1-git-send-email-minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The 32 bit and 64 bit implementations differ in their __init annotations
for some functions referenced from the common EFI code. Namely, the 32
bit variant is missing some of the __init annotations the 64 bit variant
has.

To solve the colliding annotations, mark the corresponding functions in
efi_32.c as initialization code, too -- as it is such.

Actually, quite a few more functions are only used during initialization
and therefore can be marked __init. They are therefore annotated, too.
Also add the __init annotation to the prototypes in the efi.h header so
users of those functions will see it's meant as initialization code
only.

This patch also fixes the "prelog" typo. ("prologue" / "epilogue" might
be more appropriate but this is C code after all, not an opera! :D)

Signed-off-by: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>

---
The function efi_cleanup_page_tables() is not referenced at all so might
also be removed. But I didn't do this, only marked the code as __init
code. So, at least, at runtime it won't be occupying memory any more.
---
 arch/x86/include/asm/efi.h          |   20 ++++++++++----------
 arch/x86/platform/efi/efi.c         |    4 ++--
 arch/x86/platform/efi/efi_32.c      |   12 +++++++-----
 arch/x86/platform/efi/efi_64.c      |    6 +++---
 arch/x86/platform/efi/efi_stub_32.S |    4 ++--
 5 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index b07ecf332bdf..408ad6d3222e 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -81,23 +81,23 @@ extern u64 asmlinkage efi_call(void *fp, ...);
  */
 #define __efi_call_virt(f, args...) efi_call_virt(f, args)
 
-extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
-				 u32 type, u64 attribute);
+extern void __iomem *__init efi_ioremap(unsigned long addr, unsigned long size,
+					u32 type, u64 attribute);
 
 #endif /* CONFIG_X86_32 */
 
 extern struct efi_scratch efi_scratch;
-extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
-extern int efi_memblock_x86_reserve_range(void);
-extern void efi_call_phys_prelog(void);
-extern void efi_call_phys_epilog(void);
-extern void efi_unmap_memmap(void);
-extern void efi_memory_uc(u64 addr, unsigned long size);
+extern void __init efi_set_executable(efi_memory_desc_t *md, bool executable);
+extern int __init efi_memblock_x86_reserve_range(void);
+extern void __init efi_call_phys_prolog(void);
+extern void __init efi_call_phys_epilog(void);
+extern void __init efi_unmap_memmap(void);
+extern void __init efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
 extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
-extern int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
-extern void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
+extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
+extern void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init old_map_region(efi_memory_desc_t *md);
 extern void __init runtime_code_page_mkexec(void);
 extern void __init efi_runtime_mkexec(void);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 504174c36a73..0e439a34034d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -94,7 +94,7 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 {
 	efi_status_t status;
 
-	efi_call_phys_prelog();
+	efi_call_phys_prolog();
 	status = efi_call_phys(efi_phys.set_virtual_address_map,
 			       memory_map_size, descriptor_size,
 			       descriptor_version, virtual_map);
@@ -535,7 +535,7 @@ void __init runtime_code_page_mkexec(void)
 	}
 }
 
-void efi_memory_uc(u64 addr, unsigned long size)
+void __init efi_memory_uc(u64 addr, unsigned long size)
 {
 	unsigned long page_shift = 1UL << EFI_PAGE_SHIFT;
 	u64 npages;
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 9ee3491e31fb..40e7cda52936 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -33,7 +33,7 @@
 
 /*
  * To make EFI call EFI runtime service in physical addressing mode we need
- * prelog/epilog before/after the invocation to disable interrupt, to
+ * prolog/epilog before/after the invocation to disable interrupt, to
  * claim EFI runtime service handler exclusively and to duplicate a memory in
  * low memory space say 0 - 3G.
  */
@@ -41,11 +41,13 @@ static unsigned long efi_rt_eflags;
 
 void efi_sync_low_kernel_mappings(void) {}
 void __init efi_dump_pagetable(void) {}
-int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	return 0;
 }
-void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages) {}
+void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+{
+}
 
 void __init efi_map_region(efi_memory_desc_t *md)
 {
@@ -55,7 +57,7 @@ void __init efi_map_region(efi_memory_desc_t *md)
 void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
 void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
 
-void efi_call_phys_prelog(void)
+void __init efi_call_phys_prolog(void)
 {
 	struct desc_ptr gdt_descr;
 
@@ -69,7 +71,7 @@ void efi_call_phys_prelog(void)
 	load_gdt(&gdt_descr);
 }
 
-void efi_call_phys_epilog(void)
+void __init efi_call_phys_epilog(void)
 {
 	struct desc_ptr gdt_descr;
 
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 290d397e1dd9..35aecb6042fb 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -79,7 +79,7 @@ static void __init early_code_mapping_set_exec(int executable)
 	}
 }
 
-void __init efi_call_phys_prelog(void)
+void __init efi_call_phys_prolog(void)
 {
 	unsigned long vaddress;
 	int pgd;
@@ -139,7 +139,7 @@ void efi_sync_low_kernel_mappings(void)
 		sizeof(pgd_t) * num_pgds);
 }
 
-int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	unsigned long text;
 	struct page *page;
@@ -192,7 +192,7 @@ int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	return 0;
 }
 
-void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
 
diff --git a/arch/x86/platform/efi/efi_stub_32.S b/arch/x86/platform/efi/efi_stub_32.S
index fbe66e626c09..040192b50d02 100644
--- a/arch/x86/platform/efi/efi_stub_32.S
+++ b/arch/x86/platform/efi/efi_stub_32.S
@@ -27,13 +27,13 @@ ENTRY(efi_call_phys)
 	 * set to 0x0010, DS and SS have been set to 0x0018. In EFI, I found
 	 * the values of these registers are the same. And, the corresponding
 	 * GDT entries are identical. So I will do nothing about segment reg
-	 * and GDT, but change GDT base register in prelog and epilog.
+	 * and GDT, but change GDT base register in prolog and epilog.
 	 */
 
 	/*
 	 * 1. Now I am running with EIP = <physical address> + PAGE_OFFSET.
 	 * But to make it smoothly switch from virtual mode to flat mode.
-	 * The mapping of lower virtual memory has been created in prelog and
+	 * The mapping of lower virtual memory has been created in prolog and
 	 * epilog.
 	 */
 	movl	$1f, %edx
-- 
1.7.10.4
