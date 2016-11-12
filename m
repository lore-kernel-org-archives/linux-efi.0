From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 4/9] efi/libstub: Add random.c to ARM build
Date: Sat, 12 Nov 2016 21:32:32 +0000
Message-ID: <20161112213237.8804-5-matt@codeblueprint.co.uk>
References: <20161112213237.8804-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161112213237.8804-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Make random.c build for ARM by moving the fallback definition of
EFI_ALLOC_ALIGN to efistub.h, and replacing a division by a value
we know to be a power of 2 with a right shift (this is required since
ARM does not have any integer division helper routines in its decompressor)

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/Makefile          | 4 ++--
 drivers/firmware/efi/libstub/efi-stub-helper.c | 9 ---------
 drivers/firmware/efi/libstub/efistub.h         | 9 +++++++++
 drivers/firmware/efi/libstub/random.c          | 8 +++++---
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index c06945160a41..40ddf8f763a8 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -36,11 +36,11 @@ arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
 $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
-lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o \
+lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o random.o \
 				   $(patsubst %.c,lib-%.o,$(arm-deps))
 
 lib-$(CONFIG_ARM)		+= arm32-stub.o
-lib-$(CONFIG_ARM64)		+= arm64-stub.o random.o
+lib-$(CONFIG_ARM64)		+= arm64-stub.o
 CFLAGS_arm64-stub.o 		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 #
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 4b74bf86c74d..757badc1debb 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -32,15 +32,6 @@
 
 static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
-/*
- * Allow the platform to override the allocation granularity: this allows
- * systems that have the capability to run with a larger page size to deal
- * with the allocations for initrd and fdt more efficiently.
- */
-#ifndef EFI_ALLOC_ALIGN
-#define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
-#endif
-
 #define EFI_MMAP_NR_SLACK_SLOTS	8
 
 struct file_info {
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index ee49cd23ee63..fe1f22584c69 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -15,6 +15,15 @@
  */
 #undef __init
 
+/*
+ * Allow the platform to override the allocation granularity: this allows
+ * systems that have the capability to run with a larger page size to deal
+ * with the allocations for initrd and fdt more efficiently.
+ */
+#ifndef EFI_ALLOC_ALIGN
+#define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
+#endif
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 0c9f58c5ba50..f8e2e5ae6872 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/efi.h>
+#include <linux/log2.h>
 #include <asm/efi.h>
 
 #include "efistub.h"
@@ -41,8 +42,9 @@ efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table_arg,
  */
 static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
 					 unsigned long size,
-					 unsigned long align)
+					 unsigned long align_shift)
 {
+	unsigned long align = 1UL << align_shift;
 	u64 start, end;
 
 	if (md->type != EFI_CONVENTIONAL_MEMORY)
@@ -55,7 +57,7 @@ static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
 	if (start > end)
 		return 0;
 
-	return (end - start + 1) / align;
+	return (end - start + 1) >> align_shift;
 }
 
 /*
@@ -98,7 +100,7 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 		efi_memory_desc_t *md = (void *)memory_map + map_offset;
 		unsigned long slots;
 
-		slots = get_entry_num_slots(md, size, align);
+		slots = get_entry_num_slots(md, size, ilog2(align));
 		MD_NUM_SLOTS(md) = slots;
 		total_slots += slots;
 	}
-- 
2.10.0
