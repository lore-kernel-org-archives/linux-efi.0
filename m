From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC Part1 PATCH v3 15/17] x86: Add support for changing memory encryption attribute in early boot
Date: Mon, 24 Jul 2017 14:07:55 -0500
Message-ID: <20170724190757.11278-16-brijesh.singh@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170724190757.11278-1-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>Paul Mackerras <p>
List-Id: linux-efi@vger.kernel.org

Some KVM-specific custom MSRs shares the guest physical address with
hypervisor. When SEV is active, the shared physical address must be mapped
with encryption attribute cleared so that both hypervsior and guest can
access the data.

Add APIs to change memory encryption attribute in early boot code.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/mem_encrypt.h |  17 ++++++
 arch/x86/mm/mem_encrypt.c          | 117 +++++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 9cb6472..30b539e 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -46,6 +46,11 @@ void __init sme_early_init(void);
 void __init sme_encrypt_kernel(void);
 void __init sme_enable(struct boot_params *bp);
 
+int __init early_set_memory_decrypted(resource_size_t paddr,
+				      unsigned long size);
+int __init early_set_memory_encrypted(resource_size_t paddr,
+				      unsigned long size);
+
 /* Architecture __weak replacement functions */
 void __init mem_encrypt_init(void);
 
@@ -69,6 +74,18 @@ static inline void __init sme_early_init(void) { }
 static inline void __init sme_encrypt_kernel(void) { }
 static inline void __init sme_enable(struct boot_params *bp) { }
 
+static inline int __init early_set_memory_decrypted(resource_size_t paddr,
+						    unsigned long size)
+{
+	return 0;
+}
+
+static inline int __init early_set_memory_encrypted(resource_size_t paddr,
+						    unsigned long size)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
 /*
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index ed8780e..d174b1c 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -28,6 +28,8 @@
 #include <asm/msr.h>
 #include <asm/cmdline.h>
 
+#include "mm_internal.h"
+
 static char sme_cmdline_arg[] __initdata = "mem_encrypt";
 static char sme_cmdline_on[]  __initdata = "on";
 static char sme_cmdline_off[] __initdata = "off";
@@ -257,6 +259,121 @@ static void sme_free(struct device *dev, size_t size, void *vaddr,
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
 
+static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
+{
+	pgprot_t old_prot, new_prot;
+	unsigned long pfn;
+	pte_t new_pte;
+
+	switch (level) {
+	case PG_LEVEL_4K:
+		pfn = pte_pfn(*kpte);
+		old_prot = pte_pgprot(*kpte);
+		break;
+	case PG_LEVEL_2M:
+		pfn = pmd_pfn(*(pmd_t *)kpte);
+		old_prot = pmd_pgprot(*(pmd_t *)kpte);
+		break;
+	case PG_LEVEL_1G:
+		pfn = pud_pfn(*(pud_t *)kpte);
+		old_prot = pud_pgprot(*(pud_t *)kpte);
+		break;
+	default:
+		return;
+	}
+
+	new_prot = old_prot;
+	if (enc)
+		pgprot_val(new_prot) |= _PAGE_ENC;
+	else
+		pgprot_val(new_prot) &= ~_PAGE_ENC;
+
+	/* if prot is same then do nothing */
+	if (pgprot_val(old_prot) == pgprot_val(new_prot))
+		return;
+
+	new_pte = pfn_pte(pfn, new_prot);
+	set_pte_atomic(kpte, new_pte);
+}
+
+static int __init early_set_memory_enc_dec(resource_size_t paddr,
+					   unsigned long size, bool enc)
+{
+	unsigned long vaddr, vaddr_end, vaddr_next;
+	unsigned long psize, pmask;
+	int split_page_size_mask;
+	pte_t *kpte;
+	int level;
+
+	vaddr = (unsigned long)__va(paddr);
+	vaddr_next = vaddr;
+	vaddr_end = vaddr + size;
+
+	/*
+	 * We are going to change the physical page attribute from C=1 to C=0
+	 * or vice versa. Flush the caches to ensure that data is written into
+	 * memory with correct C-bit before we change attribute.
+	 */
+	clflush_cache_range(__va(paddr), size);
+
+	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
+		kpte = lookup_address(vaddr, &level);
+		if (!kpte || pte_none(*kpte))
+			return 1;
+
+		if (level == PG_LEVEL_4K) {
+			__set_clr_pte_enc(kpte, level, enc);
+			vaddr_next = (vaddr & PAGE_MASK) + PAGE_SIZE;
+			continue;
+		}
+
+		psize = page_level_size(level);
+		pmask = page_level_mask(level);
+
+		/*
+		 * Check, whether we can change the large page in one go.
+		 * We request a split, when the address is not aligned and
+		 * the number of pages to set/clear encryption bit is smaller
+		 * than the number of pages in the large page.
+		 */
+		if (vaddr == (vaddr & pmask) &&
+			((vaddr_end - vaddr) >= psize)) {
+			__set_clr_pte_enc(kpte, level, enc);
+			vaddr_next = (vaddr & pmask) + psize;
+			continue;
+		}
+
+		/*
+		 * virtual address is part of large page, create the page table
+		 * mapping to use smaller pages (4K or 2M). If virtual address
+		 * is part of 2M page the we request spliting the large page
+		 * into 4K, similarly 1GB large page is requested to split into
+		 * 2M pages.
+		 */
+		if (level == PG_LEVEL_2M)
+			split_page_size_mask = 0;
+		else
+			split_page_size_mask = 1 << PG_LEVEL_2M;
+
+		kernel_physical_mapping_init(__pa(vaddr & pmask),
+					     __pa((vaddr_end & pmask) + psize),
+					     split_page_size_mask);
+	}
+
+	__flush_tlb_all();
+	return 0;
+}
+
+int __init early_set_memory_decrypted(resource_size_t paddr, unsigned long size)
+{
+	return early_set_memory_enc_dec(paddr, size, false);
+}
+
+int __init early_set_memory_encrypted(resource_size_t paddr, unsigned long size)
+{
+	return early_set_memory_enc_dec(paddr, size, true);
+}
+
 static const struct dma_map_ops sme_dma_ops = {
 	.alloc                  = sme_alloc,
 	.free                   = sme_free,
-- 
2.9.4
