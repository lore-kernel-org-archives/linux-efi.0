From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 07/10] efi: Constify EFI_RNG_PROTOCOL.GetRNG()
Date: Mon, 2 Jan 2017 11:24:33 +0100
Message-ID: <435dd0ce2aa0c6006a5ead4a84e5a6b92e5fd794.1483318593.git.lukas@wunner.de>
References: <cover.1483318593.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1483318593.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

GUIDs passed to EFI_RNG_PROTOCOL.GetRNG() are not modified, so declare
them const.  This allows the compiler to place them in the rodata
section instead of generating them on the stack at runtime.  Pass GUIDs
as literals rather than assigning them to temporary variables to save a
bit on code.  Constification of the GUIDs is in compliance with the EFI
spec which marks them "IN" for this protocol function.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 drivers/firmware/efi/libstub/random.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index c29a722..844bdc9 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -17,7 +17,7 @@ struct efi_rng_protocol {
 	efi_status_t (*get_info)(struct efi_rng_protocol *,
 				 unsigned long *, efi_guid_t *);
 	efi_status_t (*get_rng)(struct efi_rng_protocol *,
-				efi_guid_t *, unsigned long, u8 *out);
+				const efi_guid_t *, unsigned long, u8 *out);
 };
 
 efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table_arg,
@@ -148,7 +148,6 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 
 efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 {
-	efi_guid_t rng_algo_raw = EFI_RNG_ALGORITHM_RAW;
 	struct efi_rng_protocol *rng;
 	struct linux_efi_random_seed *seed;
 	efi_status_t status;
@@ -164,7 +163,7 @@ efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = rng->get_rng(rng, &rng_algo_raw, RANDOM_SEED_SIZE,
+	status = rng->get_rng(rng, &EFI_RNG_ALGORITHM_RAW, RANDOM_SEED_SIZE,
 			      seed->bits);
 	if (status == EFI_UNSUPPORTED)
 		/*
-- 
2.11.0
