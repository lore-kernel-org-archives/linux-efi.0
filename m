From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH] arm64: efi: fix chicken-and-egg problem in memreserve code
Date: Fri, 18 Jan 2019 18:43:24 +0100
Message-ID: <20190118174324.24715-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org
Cc: mark.rutland@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Unfortunately, it appears that the recently introduced and repaired
EFI memreserve code is still broken.

Originally, we applied all memory reservation passed via the EFI table
before doing any memblock allocations. However, this turned out to be
problematic, given that the number of reservations is unbounded, and
a GICv3 system will reserve a block of memory for each CPU, resulting
in hundreds of reservations.

We 'fixed' this by deferring the reservations in the memblock table
until after we enabled memblock resizing. However, to reach this
point, we must have mapped DRAM and the kernel, which itself relies
on some memblock allocations for page tables. Also, memblock resizing
itself relies on the ability to invoke memblock_alloc() to reallocate
those tables themselves.

So this is a nice chicken-and-egg problem which is rather difficult
to fix cleanly. So instead of a clean solution, I came up with the
patch below.

The idea is to set a memblock allocation limit below the lowest
reservation entry that occurs in the memreserve table. This way,
we can map DRAM and the kernel and enable memblock resizing without
running the risk of clobbering those reserved regions. After applying
all the reservations, the memblock limit restriction is lifted again,
allowing the boot to proceed normally.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

The problem with this approach is that it is not guaranteed that the
temporary limit will leave enough memory to allocate the page tables
and resize the memblock reserved array. Since this is only 10s of KBs,
it is unlikely to break in practice, but some pathological behavior
may still occur, which is rather nasty :-(

 arch/arm64/include/asm/memblock.h |  1 +
 arch/arm64/kernel/setup.c         |  2 +-
 arch/arm64/mm/init.c              | 19 ++++++++++
 drivers/firmware/efi/efi.c        | 39 +++++++++++++++++++-
 include/linux/efi.h               |  7 ++++
 5 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/memblock.h b/arch/arm64/include/asm/memblock.h
index 6afeed2467f1..461d093e67cf 100644
--- a/arch/arm64/include/asm/memblock.h
+++ b/arch/arm64/include/asm/memblock.h
@@ -17,5 +17,6 @@
 #define __ASM_MEMBLOCK_H
 
 extern void arm64_memblock_init(void);
+extern void arm64_memblock_post_paging_init(void);
 
 #endif
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 4b0e1231625c..a76b165e3f16 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -313,7 +313,7 @@ void __init setup_arch(char **cmdline_p)
 	arm64_memblock_init();
 
 	paging_init();
-	efi_apply_persistent_mem_reservations();
+	arm64_memblock_post_paging_init();
 
 	acpi_table_upgrade();
 
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 7205a9085b4d..6e95b52b5d07 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -355,6 +355,7 @@ static void __init fdt_enforce_memory_region(void)
 void __init arm64_memblock_init(void)
 {
 	const s64 linear_region_size = -(s64)PAGE_OFFSET;
+	u64 memblock_limit;
 
 	/* Handle linux,usable-memory-range property */
 	fdt_enforce_memory_region();
@@ -399,6 +400,18 @@ void __init arm64_memblock_init(void)
 		memblock_add(__pa_symbol(_text), (u64)(_end - _text));
 	}
 
+	/*
+	 * Set a temporary memblock allocation limit so that we don't clobber
+	 * regions that we will want to reserve later. However, since the
+	 * number of reserved regions that can be described this way is
+	 * basically unbounded, we have to defer applying the actual
+	 * reservations until after we have mapped enough memory to allow
+	 * the memblock resize routines to run.
+	 */
+	efi_prepare_persistent_mem_reservations(&memblock_limit);
+	if (memblock_limit < memory_limit)
+		memblock_set_current_limit(memblock_limit);
+
 	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && phys_initrd_size) {
 		/*
 		 * Add back the memory we just removed if it results in the
@@ -666,3 +679,9 @@ static int __init register_mem_limit_dumper(void)
 	return 0;
 }
 __initcall(register_mem_limit_dumper);
+
+void __init arm64_memblock_post_paging_init(void)
+{
+	memblock_set_current_limit(memory_limit);
+	efi_apply_persistent_mem_reservations();
+}
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 4c46ff6f2242..643e38f5e200 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -595,11 +595,13 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 	return 0;
 }
 
-int __init efi_apply_persistent_mem_reservations(void)
+int __init efi_prepare_persistent_mem_reservations(u64 *lowest)
 {
 	if (efi.mem_reserve != EFI_INVALID_TABLE_ADDR) {
 		unsigned long prsv = efi.mem_reserve;
 
+		*lowest = U64_MAX;
+
 		while (prsv) {
 			struct linux_efi_memreserve *rsv;
 			u8 *p;
@@ -622,6 +624,41 @@ int __init efi_apply_persistent_mem_reservations(void)
 			/* reserve the entry itself */
 			memblock_reserve(prsv, EFI_MEMRESERVE_SIZE(rsv->size));
 
+			for (i = 0; i < atomic_read(&rsv->count); i++)
+				*lowest = min(*lowest, rsv->entry[i].base);
+
+			prsv = rsv->next;
+			early_memunmap(p, PAGE_SIZE);
+		}
+	}
+
+	return 0;
+}
+
+int __init efi_apply_persistent_mem_reservations(void)
+{
+	if (efi.mem_reserve != EFI_INVALID_TABLE_ADDR) {
+		unsigned long prsv = efi.mem_reserve;
+
+		while (prsv) {
+			struct linux_efi_memreserve *rsv;
+			u8 *p;
+			int i;
+
+			/*
+			 * Just map a full page: that is what we will get
+			 * anyway, and it permits us to map the entire entry
+			 * before knowing its size.
+			 */
+			p = early_memremap(ALIGN_DOWN(prsv, PAGE_SIZE),
+					   PAGE_SIZE);
+			if (p == NULL) {
+				pr_err("Could not map UEFI memreserve entry!\n");
+				return -ENOMEM;
+			}
+
+			rsv = (void *)(p + prsv % PAGE_SIZE);
+
 			for (i = 0; i < atomic_read(&rsv->count); i++) {
 				memblock_reserve(rsv->entry[i].base,
 						 rsv->entry[i].size);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index be08518c2553..2ec2153fc12e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1212,6 +1212,7 @@ extern void efi_reboot(enum reboot_mode reboot_mode, const char *__unused);
 
 extern bool efi_is_table_address(unsigned long phys_addr);
 
+extern int efi_prepare_persistent_mem_reservations(u64 *lowest);
 extern int efi_apply_persistent_mem_reservations(void);
 #else
 static inline bool efi_enabled(int feature)
@@ -1232,6 +1233,12 @@ static inline bool efi_is_table_address(unsigned long phys_addr)
 	return false;
 }
 
+static inline int efi_prepare_persistent_mem_reservations(u64 *lowest)
+{
+	*lowest = U64_MAX;
+	return 0;
+}
+
 static inline int efi_apply_persistent_mem_reservations(void)
 {
 	return 0;
-- 
2.20.1
