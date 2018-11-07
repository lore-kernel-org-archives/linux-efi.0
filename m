From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 4/6] efi/arm: defer persistent reservations until after
 paging_init()
Date: Wed,  7 Nov 2018 15:16:09 +0100
Message-ID: <20181107141611.12076-5-ard.biesheuvel@linaro.org>
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

The new memory EFI reservation feature we introduced to allow memory
reservations to persist across kexec may trigger an unbounded number
of calls to memblock_reserve(). The memblock subsystem can deal with
this fine, but not before memblock resizing is enabled, which we can
only do after paging_init(), when the memory we reallocate the array
into is actually mapped.

So break out the memreserve table processing into a separate function
and call if after paging_init() on arm64, and from paging_init() on
ARM, after memblock resizing has been enabled but before the early
memremap support that we rely on has been taken down.

Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/mm/mmu.c          | 2 ++
 arch/arm64/kernel/setup.c  | 1 +
 drivers/firmware/efi/efi.c | 4 ++++
 include/linux/efi.h        | 7 +++++++
 4 files changed, 14 insertions(+)

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
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 953e316521fc..f4fc1e0544b7 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -313,6 +313,7 @@ void __init setup_arch(char **cmdline_p)
 	arm64_memblock_init();
 
 	paging_init();
+	efi_apply_persistent_mem_reservations();
 
 	acpi_table_upgrade();
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 249eb70691b0..72a4da76d274 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -592,7 +592,11 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 
 		early_memunmap(tbl, sizeof(*tbl));
 	}
+	return 0;
+}
 
+int __init efi_apply_persistent_mem_reservations(void)
+{
 	if (efi.mem_reserve != EFI_INVALID_TABLE_ADDR) {
 		unsigned long prsv = efi.mem_reserve;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 845174e113ce..100ce4a4aff6 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1167,6 +1167,8 @@ static inline bool efi_enabled(int feature)
 extern void efi_reboot(enum reboot_mode reboot_mode, const char *__unused);
 
 extern bool efi_is_table_address(unsigned long phys_addr);
+
+extern int efi_apply_persistent_mem_reservations(void);
 #else
 static inline bool efi_enabled(int feature)
 {
@@ -1185,6 +1187,11 @@ static inline bool efi_is_table_address(unsigned long phys_addr)
 {
 	return false;
 }
+
+static inline int efi_apply_persistent_mem_reservations(void)
+{
+	return 0;
+}
 #endif
 
 extern int efi_status_to_err(efi_status_t status);
-- 
2.19.1
