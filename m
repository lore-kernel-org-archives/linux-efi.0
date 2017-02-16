From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [RFC PATCH v4 26/28] x86: Allow kexec to be used with SME
Date: Thu, 16 Feb 2017 09:47:55 -0600
Message-ID: <20170216154755.19244.51276.stgit@tlendack-t1.amdoffice.net>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170216154158.19244.66630.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Provide support so that kexec can be used to boot a kernel when SME is
enabled.

Support is needed to allocate pages for kexec without encryption.  This
is needed in order to be able to reboot in the kernel in the same manner
as originally booted.

Additionally, when shutting down all of the CPUs we need to be sure to
disable caches, flush the caches and then halt. This is needed when booting
from a state where SME was not active into a state where SME is active.
Without these steps, it is possible for cache lines to exist for the same
physical location but tagged both with and without the encryption bit. This
can cause random memory corruption when caches are flushed depending on
which cacheline is written last.

Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/include/asm/cacheflush.h    |    2 ++
 arch/x86/include/asm/init.h          |    1 +
 arch/x86/include/asm/mem_encrypt.h   |   10 ++++++++
 arch/x86/include/asm/pgtable_types.h |    1 +
 arch/x86/kernel/machine_kexec_64.c   |    3 ++
 arch/x86/kernel/process.c            |   43 +++++++++++++++++++++++++++++++++-
 arch/x86/kernel/smp.c                |    4 ++-
 arch/x86/mm/ident_map.c              |    6 +++--
 arch/x86/mm/pageattr.c               |    2 ++
 include/linux/mem_encrypt.h          |   10 ++++++++
 kernel/kexec_core.c                  |   24 +++++++++++++++++++
 11 files changed, 100 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 33ae60a..2180cd5 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -48,8 +48,10 @@
 int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_np(unsigned long addr, int numpages);
 int set_memory_4k(unsigned long addr, int numpages);
+#ifdef CONFIG_AMD_MEM_ENCRYPT
 int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
+#endif
 
 int set_memory_array_uc(unsigned long *addr, int addrinarray);
 int set_memory_array_wc(unsigned long *addr, int addrinarray);
diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 737da62..b2ec511 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -6,6 +6,7 @@ struct x86_mapping_info {
 	void *context;			 /* context for alloc_pgt_page */
 	unsigned long pmd_flag;		 /* page flag for PMD entry */
 	unsigned long offset;		 /* ident mapping offset */
+	unsigned long kernpg_flag;	 /* kernel pagetable flag override */
 };
 
 int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 5a17f1b..1fd5426 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -64,6 +64,16 @@ static inline u64 sme_dma_mask(void)
 	return 0ULL;
 }
 
+static inline int set_memory_encrypted(unsigned long vaddr, int numpages)
+{
+	return 0;
+}
+
+static inline int set_memory_decrypted(unsigned long vaddr, int numpages)
+{
+	return 0;
+}
+
 #endif
 
 static inline void __init sme_early_encrypt(resource_size_t paddr,
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index f00e70f..456c5cc 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -213,6 +213,7 @@ enum page_cache_mode {
 #define PAGE_KERNEL		__pgprot(__PAGE_KERNEL | _PAGE_ENC)
 #define PAGE_KERNEL_RO		__pgprot(__PAGE_KERNEL_RO | _PAGE_ENC)
 #define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC | _PAGE_ENC)
+#define PAGE_KERNEL_EXEC_NOENC	__pgprot(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RX		__pgprot(__PAGE_KERNEL_RX | _PAGE_ENC)
 #define PAGE_KERNEL_NOCACHE	__pgprot(__PAGE_KERNEL_NOCACHE | _PAGE_ENC)
 #define PAGE_KERNEL_LARGE	__pgprot(__PAGE_KERNEL_LARGE | _PAGE_ENC)
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 307b1f4..b01648c 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -76,7 +76,7 @@ static int init_transition_pgtable(struct kimage *image, pgd_t *pgd)
 		set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
 	}
 	pte = pte_offset_kernel(pmd, vaddr);
-	set_pte(pte, pfn_pte(paddr >> PAGE_SHIFT, PAGE_KERNEL_EXEC));
+	set_pte(pte, pfn_pte(paddr >> PAGE_SHIFT, PAGE_KERNEL_EXEC_NOENC));
 	return 0;
 err:
 	free_transition_pgtable(image);
@@ -104,6 +104,7 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 		.alloc_pgt_page	= alloc_pgt_page,
 		.context	= image,
 		.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
+		.kernpg_flag	= _KERNPG_TABLE_NOENC,
 	};
 	unsigned long mstart, mend;
 	pgd_t *level4p;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3ed869c..9b01261 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -279,8 +279,43 @@ bool xen_set_default_idle(void)
 	return ret;
 }
 #endif
-void stop_this_cpu(void *dummy)
+
+static bool is_smt_thread(int cpu)
 {
+#ifdef CONFIG_SCHED_SMT
+	if (cpumask_test_cpu(smp_processor_id(), cpu_smt_mask(cpu)))
+		return true;
+#endif
+	return false;
+}
+
+void stop_this_cpu(void *data)
+{
+	atomic_t *stopping_cpu = data;
+	bool do_cache_disable = false;
+	bool do_wbinvd = false;
+
+	if (stopping_cpu) {
+		int stopping_id = atomic_read(stopping_cpu);
+		struct cpuinfo_x86 *c = &cpu_data(stopping_id);
+
+		/*
+		 * If the processor supports SME then we need to clear
+		 * out cache information before halting it because we could
+		 * be performing a kexec. With kexec, going from SME
+		 * inactive to SME active requires clearing cache entries
+		 * so that addresses without the encryption bit set don't
+		 * corrupt the same physical address that has the encryption
+		 * bit set when caches are flushed. If this is not an SMT
+		 * thread of the stopping CPU then we disable caching at this
+		 * point to keep the cache clean.
+		 */
+		if (cpu_has(c, X86_FEATURE_SME)) {
+			do_cache_disable = !is_smt_thread(stopping_id);
+			do_wbinvd = true;
+		}
+	}
+
 	local_irq_disable();
 	/*
 	 * Remove this CPU:
@@ -289,6 +324,12 @@ void stop_this_cpu(void *dummy)
 	disable_local_APIC();
 	mcheck_cpu_clear(this_cpu_ptr(&cpu_info));
 
+	if (do_cache_disable)
+		write_cr0(read_cr0() | X86_CR0_CD);
+
+	if (do_wbinvd)
+		wbinvd();
+
 	for (;;)
 		halt();
 }
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index d3c66a1..64b2cda 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -162,7 +162,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
 		return NMI_HANDLED;
 
-	stop_this_cpu(NULL);
+	stop_this_cpu(&stopping_cpu);
 
 	return NMI_HANDLED;
 }
@@ -174,7 +174,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 asmlinkage __visible void smp_reboot_interrupt(void)
 {
 	ipi_entering_ack_irq();
-	stop_this_cpu(NULL);
+	stop_this_cpu(&stopping_cpu);
 	irq_exit();
 }
 
diff --git a/arch/x86/mm/ident_map.c b/arch/x86/mm/ident_map.c
index 4473cb4..3e7da84 100644
--- a/arch/x86/mm/ident_map.c
+++ b/arch/x86/mm/ident_map.c
@@ -20,6 +20,7 @@ static void ident_pmd_init(struct x86_mapping_info *info, pmd_t *pmd_page,
 static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
 			  unsigned long addr, unsigned long end)
 {
+	unsigned long kernpg_flag = info->kernpg_flag ? : _KERNPG_TABLE;
 	unsigned long next;
 
 	for (; addr < end; addr = next) {
@@ -39,7 +40,7 @@ static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
 		if (!pmd)
 			return -ENOMEM;
 		ident_pmd_init(info, pmd, addr, next);
-		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+		set_pud(pud, __pud(__pa(pmd) | kernpg_flag));
 	}
 
 	return 0;
@@ -48,6 +49,7 @@ static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
 int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
 			      unsigned long pstart, unsigned long pend)
 {
+	unsigned long kernpg_flag = info->kernpg_flag ? : _KERNPG_TABLE;
 	unsigned long addr = pstart + info->offset;
 	unsigned long end = pend + info->offset;
 	unsigned long next;
@@ -75,7 +77,7 @@ int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
 		result = ident_pud_init(info, pud, addr, next);
 		if (result)
 			return result;
-		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
+		set_pgd(pgd, __pgd(__pa(pud) | kernpg_flag));
 	}
 
 	return 0;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 9710f5c..46cc89d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1742,6 +1742,7 @@ int set_memory_4k(unsigned long addr, int numpages)
 					__pgprot(0), 1, 0, NULL);
 }
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
 static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 {
 	struct cpa_data cpa;
@@ -1807,6 +1808,7 @@ int set_memory_decrypted(unsigned long addr, int numpages)
 	return __set_memory_enc_dec(addr, numpages, false);
 }
 EXPORT_SYMBOL(set_memory_decrypted);
+#endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
 int set_pages_uc(struct page *page, int numpages)
 {
diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
index 6829ff1..913cf80 100644
--- a/include/linux/mem_encrypt.h
+++ b/include/linux/mem_encrypt.h
@@ -34,6 +34,16 @@ static inline u64 sme_dma_mask(void)
 	return 0ULL;
 }
 
+static inline int set_memory_encrypted(unsigned long vaddr, int numpages)
+{
+	return 0;
+}
+
+static inline int set_memory_decrypted(unsigned long vaddr, int numpages)
+{
+	return 0;
+}
+
 #endif
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 5617cc4..ab62f41 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -38,6 +38,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/compiler.h>
 #include <linux/hugetlb.h>
+#include <linux/mem_encrypt.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -315,6 +316,18 @@ static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
 		count = 1 << order;
 		for (i = 0; i < count; i++)
 			SetPageReserved(pages + i);
+
+		/*
+		 * If SME is active we need to be sure that kexec pages are
+		 * not encrypted because when we boot to the new kernel the
+		 * pages won't be accessed encrypted (initially).
+		 */
+		if (sme_active()) {
+			void *vaddr = page_address(pages);
+
+			set_memory_decrypted((unsigned long)vaddr, count);
+			memset(vaddr, 0, count * PAGE_SIZE);
+		}
 	}
 
 	return pages;
@@ -326,6 +339,17 @@ static void kimage_free_pages(struct page *page)
 
 	order = page_private(page);
 	count = 1 << order;
+
+	/*
+	 * If SME is active we need to reset the pages back to being an
+	 * encrypted mapping before freeing them.
+	 */
+	if (sme_active()) {
+		void *vaddr = page_address(page);
+
+		set_memory_encrypted((unsigned long)vaddr, count);
+	}
+
 	for (i = 0; i < count; i++)
 		ClearPageReserved(page + i);
 	__free_pages(page, order);
