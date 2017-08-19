From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: random: increase size of firmware supplied randomness
Date: Sat, 19 Aug 2017 18:19:51 +0100
Message-ID: <20170819171951.18932-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardened-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The crng code requires at least 64 bytes (2 * CHACHA20_BLOCK_SIZE)
to complete the fast boot-time init, so provide that many bytes
when invoking UEFI protocols to seed the entropy pool. Also, add
a notice so we can tell from the boot log when the seeding actually
took place.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c            | 3 ++-
 drivers/firmware/efi/libstub/random.c | 2 --
 include/linux/efi.h                   | 2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 6519be44387c..9e822906adcb 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -522,6 +522,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 			if (seed != NULL) {
 				add_device_randomness(seed->bits, seed->size);
 				early_memunmap(seed, sizeof(*seed) + size);
+				pr_notice("seeding entropy pool\n");
 			} else {
 				pr_err("Could not map UEFI random seed!\n");
 			}
@@ -867,7 +868,7 @@ static int update_efi_random_seed(struct notifier_block *nb,
 
 	seed = memremap(efi.rng_seed, sizeof(*seed), MEMREMAP_WB);
 	if (seed != NULL) {
-		size = min(seed->size, 32U);
+		size = min(seed->size, EFI_RANDOM_SEED_SIZE);
 		memunmap(seed);
 	} else {
 		pr_err("Could not map UEFI random seed!\n");
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index fa10e14862b3..e460c59b448b 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -165,8 +165,6 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 	return status;
 }
 
-#define RANDOM_SEED_SIZE	32
-
 efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 {
 	efi_guid_t rng_table_guid = LINUX_EFI_RANDOM_SEED_TABLE_GUID;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 253749cd9b62..cd23e1c4803c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1566,6 +1566,8 @@ efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
 				    void *priv,
 				    efi_exit_boot_map_processing priv_func);
 
+#define EFI_RANDOM_SEED_SIZE		64U
+
 struct linux_efi_random_seed {
 	u32	size;
 	u8	bits[];
-- 
2.11.0
