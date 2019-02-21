From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.20 23/32] efi/arm: Revert "Defer persistent reservations until after paging_init()"
Date: Thu, 21 Feb 2019 15:36:11 +0100
Message-ID: <20190221125252.267742511@linuxfoundation.org>
References: <20190221125250.855065214@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190221125250.855065214@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Marc Zyngier <marc.zyngier@arm.com>, Mike Rapoport <rppt@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.20-stable review patch.  If anyone has any objections, please let me know.

------------------

Commit 582a32e708823e5957fd73ccd78dc4a9e49d21ea upstream.

This reverts commit eff896288872d687d9662000ec9ae11b6d61766f, which
deferred the processing of persistent memory reservations to a point
where the memory may have already been allocated and overwritten,
defeating the purpose.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20190215123333.21209-3-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/setup.c               | 1 -
 drivers/firmware/efi/efi.c              | 4 ----
 drivers/firmware/efi/libstub/arm-stub.c | 3 ---
 include/linux/efi.h                     | 7 -------
 4 files changed, 15 deletions(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index f4fc1e0544b73..953e316521fca 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -313,7 +313,6 @@ void __init setup_arch(char **cmdline_p)
 	arm64_memblock_init();
 
 	paging_init();
-	efi_apply_persistent_mem_reservations();
 
 	acpi_table_upgrade();
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 415849bab2339..bde3822cf539a 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -592,11 +592,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 
 		early_memunmap(tbl, sizeof(*tbl));
 	}
-	return 0;
-}
 
-int __init efi_apply_persistent_mem_reservations(void)
-{
 	if (efi.mem_reserve != EFI_INVALID_TABLE_ADDR) {
 		unsigned long prsv = efi.mem_reserve;
 
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 3d36142cf8120..30ac0c975f8a1 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -75,9 +75,6 @@ void install_memreserve_table(efi_system_table_t *sys_table_arg)
 	efi_guid_t memreserve_table_guid = LINUX_EFI_MEMRESERVE_TABLE_GUID;
 	efi_status_t status;
 
-	if (IS_ENABLED(CONFIG_ARM))
-		return;
-
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, sizeof(*rsv),
 				(void **)&rsv);
 	if (status != EFI_SUCCESS) {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 100ce4a4aff6c..845174e113ce9 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1167,8 +1167,6 @@ static inline bool efi_enabled(int feature)
 extern void efi_reboot(enum reboot_mode reboot_mode, const char *__unused);
 
 extern bool efi_is_table_address(unsigned long phys_addr);
-
-extern int efi_apply_persistent_mem_reservations(void);
 #else
 static inline bool efi_enabled(int feature)
 {
@@ -1187,11 +1185,6 @@ static inline bool efi_is_table_address(unsigned long phys_addr)
 {
 	return false;
 }
-
-static inline int efi_apply_persistent_mem_reservations(void)
-{
-	return 0;
-}
 #endif
 
 extern int efi_status_to_err(efi_status_t status);
-- 
2.19.1
