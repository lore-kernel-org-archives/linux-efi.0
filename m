From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/4] efi/arm: apply persistent memory reservations during
 paging_init()
Date: Mon, 10 Dec 2018 17:29:48 +0100
Message-ID: <20181210162949.8597-4-ard.biesheuvel@linaro.org>
References: <20181210162949.8597-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181210162949.8597-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-efi@vger.kernel.org, Russell King <linux@armlinux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

The new memory EFI reservation feature we introduced to allow memory
reservations to persist across kexec may trigger an unbounded number
of calls to memblock_reserve(). The memblock subsystem can deal with
this fine, but not before memblock resizing is enabled, which we can
only do after paging_init(), when the memory we reallocate the array
into is actually mapped.

So  on ARM, call the broken out efi_apply_persistent_mem_reservations()
after memblock resizing has been enabled but before the early memremap
support that we rely on has been taken down.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/mm/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 078f82f89fe5..8ecffb8c0c0b 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -9,6 +9,7 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/efi.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/mman.h>
@@ -1629,6 +1630,7 @@ void __init paging_init(const struct machine_desc *mdesc)
 	memblock_set_current_limit(arm_lowmem_limit);
 	memblock_allow_resize();
 	dma_contiguous_remap();
+	efi_apply_persistent_mem_reservations();
 	early_ioremap_reset();
 	early_fixmap_shutdown();
 	devicemaps_init(mdesc);
-- 
2.19.2
