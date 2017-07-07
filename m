From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v9 12/38] x86/mm: Extend early_memremap() support with
	additional attrs
Date: Fri, 07 Jul 2017 08:40:15 -0500
Message-ID: <20170707134015.29711.5885.stgit@tlendack-t1.amdoffice.net>
References: <20170707133804.29711.1616.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170707133804.29711.1616.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add early_memremap() support to be able to specify encrypted and
decrypted mappings with and without write-protection. The use of
write-protection is necessary when encrypting data "in place". The
write-protect attribute is considered cacheable for loads, but not
stores. This implies that the hardware will never give the core a
dirty line with this memtype.

Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/Kconfig                     |    4 +++
 arch/x86/include/asm/fixmap.h        |   13 ++++++++++
 arch/x86/include/asm/pgtable_types.h |    8 ++++++
 arch/x86/mm/ioremap.c                |   44 ++++++++++++++++++++++++++++++++++
 include/asm-generic/early_ioremap.h  |    2 ++
 mm/early_ioremap.c                   |   10 ++++++++
 6 files changed, 81 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0f2f8b3..ad3ddc6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1435,6 +1435,10 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
 	  If set to N, then the encryption of system memory can be
 	  activated with the mem_encrypt=on command line option.
 
+config ARCH_USE_MEMREMAP_PROT
+	def_bool y
+	depends on AMD_MEM_ENCRYPT
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index d9ff226..dcd9fb5 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -164,6 +164,19 @@ static inline void __set_fixmap(enum fixed_addresses idx,
  */
 #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_IO_NOCACHE
 
+/*
+ * Early memremap routines used for in-place encryption. The mappings created
+ * by these routines are intended to be used as temporary mappings.
+ */
+void __init *early_memremap_encrypted(resource_size_t phys_addr,
+				      unsigned long size);
+void __init *early_memremap_encrypted_wp(resource_size_t phys_addr,
+					 unsigned long size);
+void __init *early_memremap_decrypted(resource_size_t phys_addr,
+				      unsigned long size);
+void __init *early_memremap_decrypted_wp(resource_size_t phys_addr,
+					 unsigned long size);
+
 #include <asm-generic/fixmap.h>
 
 #define __late_set_fixmap(idx, phys, flags) __set_fixmap(idx, phys, flags)
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index de32ca3..32095af 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -161,6 +161,7 @@ enum page_cache_mode {
 
 #define _PAGE_CACHE_MASK	(_PAGE_PAT | _PAGE_PCD | _PAGE_PWT)
 #define _PAGE_NOCACHE		(cachemode2protval(_PAGE_CACHE_MODE_UC))
+#define _PAGE_CACHE_WP		(cachemode2protval(_PAGE_CACHE_MODE_WP))
 
 #define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
 #define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | \
@@ -189,6 +190,7 @@ enum page_cache_mode {
 #define __PAGE_KERNEL_VVAR		(__PAGE_KERNEL_RO | _PAGE_USER)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
+#define __PAGE_KERNEL_WP		(__PAGE_KERNEL | _PAGE_CACHE_WP)
 
 #define __PAGE_KERNEL_IO		(__PAGE_KERNEL)
 #define __PAGE_KERNEL_IO_NOCACHE	(__PAGE_KERNEL_NOCACHE)
@@ -202,6 +204,12 @@ enum page_cache_mode {
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
 			 _PAGE_DIRTY | _PAGE_ENC)
 
+#define __PAGE_KERNEL_ENC	(__PAGE_KERNEL | _PAGE_ENC)
+#define __PAGE_KERNEL_ENC_WP	(__PAGE_KERNEL_WP | _PAGE_ENC)
+
+#define __PAGE_KERNEL_NOENC	(__PAGE_KERNEL)
+#define __PAGE_KERNEL_NOENC_WP	(__PAGE_KERNEL_WP)
+
 #define PAGE_KERNEL		__pgprot(__PAGE_KERNEL | _PAGE_ENC)
 #define PAGE_KERNEL_RO		__pgprot(__PAGE_KERNEL_RO | _PAGE_ENC)
 #define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC | _PAGE_ENC)
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index bfc3e2d..26db273 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -414,6 +414,50 @@ void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
 	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
 }
 
+#ifdef CONFIG_ARCH_USE_MEMREMAP_PROT
+/* Remap memory with encryption */
+void __init *early_memremap_encrypted(resource_size_t phys_addr,
+				      unsigned long size)
+{
+	return early_memremap_prot(phys_addr, size, __PAGE_KERNEL_ENC);
+}
+
+/*
+ * Remap memory with encryption and write-protected - cannot be called
+ * before pat_init() is called
+ */
+void __init *early_memremap_encrypted_wp(resource_size_t phys_addr,
+					 unsigned long size)
+{
+	/* Be sure the write-protect PAT entry is set for write-protect */
+	if (__pte2cachemode_tbl[_PAGE_CACHE_MODE_WP] != _PAGE_CACHE_MODE_WP)
+		return NULL;
+
+	return early_memremap_prot(phys_addr, size, __PAGE_KERNEL_ENC_WP);
+}
+
+/* Remap memory without encryption */
+void __init *early_memremap_decrypted(resource_size_t phys_addr,
+				      unsigned long size)
+{
+	return early_memremap_prot(phys_addr, size, __PAGE_KERNEL_NOENC);
+}
+
+/*
+ * Remap memory without encryption and write-protected - cannot be called
+ * before pat_init() is called
+ */
+void __init *early_memremap_decrypted_wp(resource_size_t phys_addr,
+					 unsigned long size)
+{
+	/* Be sure the write-protect PAT entry is set for write-protect */
+	if (__pte2cachemode_tbl[_PAGE_CACHE_MODE_WP] != _PAGE_CACHE_MODE_WP)
+		return NULL;
+
+	return early_memremap_prot(phys_addr, size, __PAGE_KERNEL_NOENC_WP);
+}
+#endif	/* CONFIG_ARCH_USE_MEMREMAP_PROT */
+
 static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
diff --git a/include/asm-generic/early_ioremap.h b/include/asm-generic/early_ioremap.h
index 734ad4d..2edef8d 100644
--- a/include/asm-generic/early_ioremap.h
+++ b/include/asm-generic/early_ioremap.h
@@ -13,6 +13,8 @@ extern void *early_memremap(resource_size_t phys_addr,
 			    unsigned long size);
 extern void *early_memremap_ro(resource_size_t phys_addr,
 			       unsigned long size);
+extern void *early_memremap_prot(resource_size_t phys_addr,
+				 unsigned long size, unsigned long prot_val);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
 extern void early_memunmap(void *addr, unsigned long size);
 
diff --git a/mm/early_ioremap.c b/mm/early_ioremap.c
index 6d5717b..d7d30da 100644
--- a/mm/early_ioremap.c
+++ b/mm/early_ioremap.c
@@ -226,6 +226,16 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 }
 #endif
 
+#ifdef CONFIG_ARCH_USE_MEMREMAP_PROT
+void __init *
+early_memremap_prot(resource_size_t phys_addr, unsigned long size,
+		    unsigned long prot_val)
+{
+	return (__force void *)__early_ioremap(phys_addr, size,
+					       __pgprot(prot_val));
+}
+#endif
+
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 
 void __init copy_from_early_mem(void *dest, phys_addr_t src, unsigned long size)
