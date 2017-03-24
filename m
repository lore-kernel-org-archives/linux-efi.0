From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/4] ef/libstub: arm/arm64: randomize the base of the UEFI rt services region
Date: Fri, 24 Mar 2017 13:24:10 +0000
Message-ID: <20170324132410.16628-5-ard.biesheuvel@linaro.org>
References: <20170324132410.16628-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170324132410.16628-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rfranz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Update the allocation logic for the virtual mapping of the UEFI runtime
services to start from a randomized base address if KASLR is in effect,
and if the UEFI firmware exposes an implementation of EFI_RNG_PROTOCOL.

This makes it more difficult to predict the location of exploitable
data structures in the runtime UEFI firmware, which increases robustness
against attacks. Note that these regions are only mapped during the
time a runtime service call is in progress, and only on a single CPU
at a time, bit give the lack of a downside, let's enable it nonetheless.

Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/arm-stub.c | 48 ++++++++++++++------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 6f522e3091af..eb5225884098 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -18,6 +18,22 @@
 
 #include "efistub.h"
 
+/*
+ * This is the base address at which to start allocating virtual memory ranges
+ * for UEFI Runtime Services. This is in the low TTBR0 range so that we can use
+ * any allocation we choose, and eliminate the risk of a conflict after kexec.
+ * The value chosen is the largest non-zero power of 2 suitable for this purpose
+ * both on 32-bit and 64-bit ARM CPUs, to maximize the likelihood that it can
+ * be mapped efficiently.
+ * Since 32-bit ARM could potentially execute with a 1G/3G user/kernel split,
+ * map everything below 1 GB. (512 MB is a reasonable upper bound for the
+ * entire footprint of the UEFI runtime services memory regions)
+ */
+#define EFI_RT_VIRTUAL_BASE	SZ_512M
+#define EFI_RT_VIRTUAL_SIZE	SZ_512M
+
+static u64 efi_virt_base = EFI_RT_VIRTUAL_BASE;
+
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 			     void *__image, void **__fh)
 {
@@ -209,6 +225,25 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 	efi_random_get_seed(sys_table);
 
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && !nokaslr()) {
+		/*
+		 * Randomize the base of the UEFI runtime services region.
+		 * Preserve the 2 MB alignment of the region by taking a
+		 * shift of 21 bit positions into account when scaling
+		 * the headroom value using a 32-bit random value.
+		 */
+		u64 headroom = TASK_SIZE - EFI_RT_VIRTUAL_BASE -
+			       EFI_RT_VIRTUAL_SIZE;
+		u32 rnd;
+
+		status = efi_get_random_bytes(sys_table, sizeof(rnd),
+					      (u8 *)&rnd);
+		if (status == EFI_SUCCESS) {
+			efi_virt_base = EFI_RT_VIRTUAL_BASE +
+					(((headroom >> 21) * rnd) >> (32 - 21));
+		}
+	}
+
 	new_fdt_addr = fdt_addr;
 	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
 				&new_fdt_addr, efi_get_max_fdt_addr(dram_base),
@@ -238,18 +273,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	return EFI_ERROR;
 }
 
-/*
- * This is the base address at which to start allocating virtual memory ranges
- * for UEFI Runtime Services. This is in the low TTBR0 range so that we can use
- * any allocation we choose, and eliminate the risk of a conflict after kexec.
- * The value chosen is the largest non-zero power of 2 suitable for this purpose
- * both on 32-bit and 64-bit ARM CPUs, to maximize the likelihood that it can
- * be mapped efficiently.
- * Since 32-bit ARM could potentially execute with a 1G/3G user/kernel split,
- * map everything below 1 GB.
- */
-#define EFI_RT_VIRTUAL_BASE	SZ_512M
-
 static int cmp_mem_desc(const void *l, const void *r)
 {
 	const efi_memory_desc_t *left = l, *right = r;
@@ -299,7 +322,6 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
 		     unsigned long desc_size, efi_memory_desc_t *runtime_map,
 		     int *count)
 {
-	u64 efi_virt_base = EFI_RT_VIRTUAL_BASE;
 	efi_memory_desc_t *in, *prev = NULL, *out = runtime_map;
 	int l;
 
-- 
2.9.3
