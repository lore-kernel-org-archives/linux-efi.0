From: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Subject: [RFC Part1 PATCH v3 12/17] x86/mm: DMA support for SEV memory encryption
Date: Mon, 24 Jul 2017 14:07:52 -0500
Message-ID: <20170724190757.11278-13-brijesh.singh@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724190757.11278-1-brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>Paul Mackerras <p>
List-Id: linux-efi@vger.kernel.org

From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>

DMA access to memory mapped as encrypted while SEV is active can not be
encrypted during device write or decrypted during device read. In order
for DMA to properly work when SEV is active, the SWIOTLB bounce buffers
must be used.

Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/mm/mem_encrypt.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/swiotlb.c             |  5 +--
 2 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 1e4643e..5e5d460 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -191,8 +191,86 @@ void __init sme_early_init(void)
 	/* Update the protection map with memory encryption mask */
 	for (i = 0; i < ARRAY_SIZE(protection_map); i++)
 		protection_map[i] = pgprot_encrypted(protection_map[i]);
+
+	if (sev_active())
+		swiotlb_force = SWIOTLB_FORCE;
+}
+
+static void *sme_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		       gfp_t gfp, unsigned long attrs)
+{
+	unsigned long dma_mask;
+	unsigned int order;
+	struct page *page;
+	void *vaddr = NULL;
+
+	dma_mask = dma_alloc_coherent_mask(dev, gfp);
+	order = get_order(size);
+
+	/*
+	 * Memory will be memset to zero after marking decrypted, so don't
+	 * bother clearing it before.
+	 */
+	gfp &= ~__GFP_ZERO;
+
+	page = alloc_pages_node(dev_to_node(dev), gfp, order);
+	if (page) {
+		dma_addr_t addr;
+
+		/*
+		 * Since we will be clearing the encryption bit, check the
+		 * mask with it already cleared.
+		 */
+		addr = __sme_clr(phys_to_dma(dev, page_to_phys(page)));
+		if ((addr + size) > dma_mask) {
+			__free_pages(page, get_order(size));
+		} else {
+			vaddr = page_address(page);
+			*dma_handle = addr;
+		}
+	}
+
+	if (!vaddr)
+		vaddr = swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
+
+	if (!vaddr)
+		return NULL;
+
+	/* Clear the SME encryption bit for DMA use if not swiotlb area */
+	if (!is_swiotlb_buffer(dma_to_phys(dev, *dma_handle))) {
+		set_memory_decrypted((unsigned long)vaddr, 1 << order);
+		memset(vaddr, 0, PAGE_SIZE << order);
+		*dma_handle = __sme_clr(*dma_handle);
+	}
+
+	return vaddr;
+}
+
+static void sme_free(struct device *dev, size_t size, void *vaddr,
+		     dma_addr_t dma_handle, unsigned long attrs)
+{
+	/* Set the SME encryption bit for re-use if not swiotlb area */
+	if (!is_swiotlb_buffer(dma_to_phys(dev, dma_handle)))
+		set_memory_encrypted((unsigned long)vaddr,
+				     1 << get_order(size));
+
+	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
 
+static const struct dma_map_ops sme_dma_ops = {
+	.alloc                  = sme_alloc,
+	.free                   = sme_free,
+	.map_page               = swiotlb_map_page,
+	.unmap_page             = swiotlb_unmap_page,
+	.map_sg                 = swiotlb_map_sg_attrs,
+	.unmap_sg               = swiotlb_unmap_sg_attrs,
+	.sync_single_for_cpu    = swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = swiotlb_sync_single_for_device,
+	.sync_sg_for_cpu        = swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device     = swiotlb_sync_sg_for_device,
+	.mapping_error          = swiotlb_dma_mapping_error,
+};
+
 /* Architecture __weak replacement functions */
 void __init mem_encrypt_init(void)
 {
@@ -202,6 +280,14 @@ void __init mem_encrypt_init(void)
 	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
 	swiotlb_update_mem_attributes();
 
+	/*
+	 * With SEV, DMA operations cannot use encryption. New DMA ops
+	 * are required in order to mark the DMA areas as decrypted or
+	 * to use bounce buffers.
+	 */
+	if (sev_active())
+		dma_ops = &sme_dma_ops;
+
 	pr_info("AMD Secure Memory Encryption (SME) active\n");
 }
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 8c6c83e..85fed2f 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -507,8 +507,9 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 	if (no_iotlb_memory)
 		panic("Can not allocate SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer");
 
-	if (sme_active())
-		pr_warn_once("SME is active and system is using DMA bounce buffers\n");
+	if (sme_active() || sev_active())
+		pr_warn_once("%s is active and system is using DMA bounce buffers\n",
+			     sme_active() ? "SME" : "SEV");
 
 	mask = dma_get_seg_boundary(hwdev);
 
-- 
2.9.4
