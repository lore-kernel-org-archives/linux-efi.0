From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 2/6] ARM: mm: permit memblock resizing right after mapping
 the linear region
Date: Wed,  7 Nov 2018 15:16:07 +0100
Message-ID: <20181107141611.12076-3-ard.biesheuvel@linaro.org>
References: <20181107141611.12076-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181107141611.12076-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk
Cc: marc.zyngier@arm.com, bhsharma@redhat.com, linux-efi@vger.kernel.org, will.deacon@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

The memblock arrays can be resized dynamically if needed, but this is
only done after memblock_allow_resize() is called, since it is up to
the architecture to decide at which point doing so is possible (i.e.,
when all the memory that memblock describes is actually mapped)

ARM grants this permission in bootmem_init(), but in order for the EFI
persistent memory reservation code (which may create memblock
reservations that trigger such a dynamic resize) to be able to be called
before shutting down early fixmap (upon which the EFI code depends due
to its use of early_memremap()), we need to do this earlier.

So let's move the call to memblock_allow_resize() to right after the
point where low memory is mapped and declared as the memory limit for
memblock allocation.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/mm/init.c | 1 -
 arch/arm/mm/mmu.c  | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 32e4845af2b6..797fad2b16ee 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -304,7 +304,6 @@ void __init bootmem_init(void)
 {
 	unsigned long min, max_low, max_high;
 
-	memblock_allow_resize();
 	max_low = max_high = 0;
 
 	find_limits(&min, &max_low, &max_high);
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index f5cc1ccfea3d..f6bf6686559d 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1626,6 +1626,7 @@ void __init paging_init(const struct machine_desc *mdesc)
 	prepare_page_table();
 	map_lowmem();
 	memblock_set_current_limit(arm_lowmem_limit);
+	memblock_allow_resize();
 	dma_contiguous_remap();
 	early_fixmap_shutdown();
 	devicemaps_init(mdesc);
-- 
2.19.1
