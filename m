From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/5] efi/random: Increase size of firmware supplied randomness
Date: Fri, 25 Aug 2017 16:50:16 +0100
Message-ID: <20170825155019.6740-3-ard.biesheuvel@linaro.org>
References: <20170825155019.6740-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170825155019.6740-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

The crng code requires at least 64 bytes (2 * CHACHA20_BLOCK_SIZE)
to complete the fast boot-time init, so provide that many bytes
when invoking UEFI protocols to seed the entropy pool. Also, add
a notice so we can tell from the boot log when the seeding actually
took place.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi.c            |  3 ++-
 drivers/firmware/efi/libstub/random.c | 10 ++++------
 include/linux/efi.h                   |  2 ++
 3 files changed, 8 insertions(+), 7 deletions(-)

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
index 7e72954d5860..e0e603a89aa9 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -145,8 +145,6 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 	return status;
 }
 
-#define RANDOM_SEED_SIZE	32
-
 efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 {
 	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
@@ -162,25 +160,25 @@ efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 		return status;
 
 	status = efi_call_early(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
-				sizeof(*seed) + RANDOM_SEED_SIZE,
+				sizeof(*seed) + EFI_RANDOM_SEED_SIZE,
 				(void **)&seed);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = rng->get_rng(rng, &rng_algo_raw, RANDOM_SEED_SIZE,
+	status = rng->get_rng(rng, &rng_algo_raw, EFI_RANDOM_SEED_SIZE,
 			      seed->bits);
 	if (status == EFI_UNSUPPORTED)
 		/*
 		 * Use whatever algorithm we have available if the raw algorithm
 		 * is not implemented.
 		 */
-		status = rng->get_rng(rng, NULL, RANDOM_SEED_SIZE,
+		status = rng->get_rng(rng, NULL, EFI_RANDOM_SEED_SIZE,
 				      seed->bits);
 
 	if (status != EFI_SUCCESS)
 		goto err_freepool;
 
-	seed->size = RANDOM_SEED_SIZE;
+	seed->size = EFI_RANDOM_SEED_SIZE;
 	status = efi_call_early(install_configuration_table, &rng_table_guid,
 				seed);
 	if (status != EFI_SUCCESS)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 12e05118657c..8dc3d94a3e3c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1564,6 +1564,8 @@ efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
 				    void *priv,
 				    efi_exit_boot_map_processing priv_func);
 
+#define EFI_RANDOM_SEED_SIZE		64U
+
 struct linux_efi_random_seed {
 	u32	size;
 	u8	bits[];
-- 
2.11.0
