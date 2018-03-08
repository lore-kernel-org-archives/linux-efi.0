From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 10/12] efi: reorder pr_notice() with add_device_randomness() call
Date: Thu,  8 Mar 2018 08:00:18 +0000
Message-ID: <20180308080020.22828-11-ard.biesheuvel@linaro.org>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Currently, when we receive a random seed from the EFI stub, we call
add_device_randomness() to incorporate it into the entropy pool, and
issue a pr_notice() saying we are about to do that, e.g.,

  [    0.000000] efi:  RNG=0x87ff92cf18
  [    0.000000] random: fast init done
  [    0.000000] efi: seeding entropy pool

Let's reorder those calls to make the output look less confusing.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index c0dda400d22a..232f4915223b 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -551,9 +551,9 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 			seed = early_memremap(efi.rng_seed,
 					      sizeof(*seed) + size);
 			if (seed != NULL) {
+				pr_notice("seeding entropy pool\n");
 				add_device_randomness(seed->bits, seed->size);
 				early_memunmap(seed, sizeof(*seed) + size);
-				pr_notice("seeding entropy pool\n");
 			} else {
 				pr_err("Could not map UEFI random seed!\n");
 			}
-- 
2.15.1
