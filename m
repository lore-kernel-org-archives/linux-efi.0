From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 2/3] efi/libstub: add random.c to ARM build
Date: Thu, 20 Oct 2016 12:21:25 +0100
Message-ID: <1476962486-18368-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1476962486-18368-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476962486-18368-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
Cc: tytso-3s7WtUTddSA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Make random.c build for ARM by moving the fallback definition of
EFI_ALLOC_ALIGN to efistub.h

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/Makefile          | 4 ++--
 drivers/firmware/efi/libstub/efi-stub-helper.c | 9 ---------
 drivers/firmware/efi/libstub/efistub.h         | 9 +++++++++
 3 files changed, 11 insertions(+), 11 deletions(-)

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
index aded10662020..3c2fe209bbfe 100644
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
-- 
2.7.4
