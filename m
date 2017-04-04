From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 12/12] ef/libstub: arm/arm64: Randomize the base of the UEFI rt services region
Date: Tue,  4 Apr 2017 17:09:10 +0100
Message-ID: <20170404160910.28115-3-ard.biesheuvel@linaro.org>
References: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
 <20170404160910.28115-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404160910.28115-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, roy.franz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, evgeny.kalugin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eugene-VXdhtT5mjnY@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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
 drivers/firmware/efi/libstub/arm-stub.c | 49 ++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 657bb72c9e0b..1e45ec51b094 100644
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
+static u64 virtmap_base = EFI_RT_VIRTUAL_BASE;
+
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 			     void *__image, void **__fh)
 {
@@ -213,6 +229,25 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 	efi_random_get_seed(sys_table);
 
+	if (!nokaslr()) {
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
+			virtmap_base = EFI_RT_VIRTUAL_BASE +
+				       (((headroom >> 21) * rnd) >> (32 - 21));
+		}
+	}
+
 	new_fdt_addr = fdt_addr;
 	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
 				&new_fdt_addr, efi_get_max_fdt_addr(dram_base),
@@ -242,18 +277,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
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
@@ -303,7 +326,7 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
 		     unsigned long desc_size, efi_memory_desc_t *runtime_map,
 		     int *count)
 {
-	u64 efi_virt_base = EFI_RT_VIRTUAL_BASE;
+	u64 efi_virt_base = virtmap_base;
 	efi_memory_desc_t *in, *prev = NULL, *out = runtime_map;
 	int l;
 
-- 
2.9.3
