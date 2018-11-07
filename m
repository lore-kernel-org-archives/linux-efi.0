From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 3/6] ARM: mm: permit early_memremap() to be used in
 paging_init()
Date: Wed,  7 Nov 2018 15:16:08 +0100
Message-ID: <20181107141611.12076-4-ard.biesheuvel@linaro.org>
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

early_memremap() and early_ioremap() rely on early fixmap support,
which shares its virtual address space with kmap(), and so it is
taken down in paging_init().

In order to permit the EFI persistent memory reservation code to
use early_memremap() when called from paging_init(), move the call
to early_ioremap_reset() into paging_init(), right before the call
to early_fixmap_shutdown(), creating a window where we can add the
call to efi_apply_persistent_mem_reservations() in a subsequent patch.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/setup.c | 2 --
 arch/arm/mm/mmu.c       | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index ac7e08886863..2f85cce38333 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1114,8 +1114,6 @@ void __init setup_arch(char **cmdline_p)
 	/* Memory may have been removed so recalculate the bounds. */
 	adjust_lowmem_bounds();
 
-	early_ioremap_reset();
-
 	paging_init(mdesc);
 	request_standard_resources(mdesc);
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index f6bf6686559d..078f82f89fe5 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -22,6 +22,7 @@
 #include <asm/cputype.h>
 #include <asm/sections.h>
 #include <asm/cachetype.h>
+#include <asm/early_ioremap.h>
 #include <asm/fixmap.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
@@ -1628,6 +1629,7 @@ void __init paging_init(const struct machine_desc *mdesc)
 	memblock_set_current_limit(arm_lowmem_limit);
 	memblock_allow_resize();
 	dma_contiguous_remap();
+	early_ioremap_reset();
 	early_fixmap_shutdown();
 	devicemaps_init(mdesc);
 	kmap_init();
-- 
2.19.1
