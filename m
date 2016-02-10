From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5sub3 1/4] efi: stub: implement efi_get_random_bytes() based on EFI_RNG_PROTOCOL
Date: Wed, 10 Feb 2016 18:55:02 +0100
Message-ID: <1455126905-22688-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1455126905-22688-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455126905-22688-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This exposes the firmware's implementation of EFI_RNG_PROTOCOL via a new
function efi_get_random_bytes().

Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/Makefile  |  2 +-
 drivers/firmware/efi/libstub/efistub.h |  3 ++
 drivers/firmware/efi/libstub/random.c  | 35 ++++++++++++++++++++
 include/linux/efi.h                    |  5 ++-
 4 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index aaf9c0bab42e..ad077944aa0e 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -36,7 +36,7 @@ lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o \
 				   $(patsubst %.c,lib-%.o,$(arm-deps))
 
 lib-$(CONFIG_ARM)		+= arm32-stub.o
-lib-$(CONFIG_ARM64)		+= arm64-stub.o
+lib-$(CONFIG_ARM64)		+= arm64-stub.o random.o
 CFLAGS_arm64-stub.o 		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 #
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 6b6548fda089..206b7252b9d1 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -43,4 +43,7 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
 		     unsigned long desc_size, efi_memory_desc_t *runtime_map,
 		     int *count);
 
+efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table,
+				  unsigned long size, u8 *out);
+
 #endif
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
new file mode 100644
index 000000000000..97941ee5954f
--- /dev/null
+++ b/drivers/firmware/efi/libstub/random.c
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2016 Linaro Ltd;  <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+#include "efistub.h"
+
+struct efi_rng_protocol {
+	efi_status_t (*get_info)(struct efi_rng_protocol *,
+				 unsigned long *, efi_guid_t *);
+	efi_status_t (*get_rng)(struct efi_rng_protocol *,
+				efi_guid_t *, unsigned long, u8 *out);
+};
+
+efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table_arg,
+				  unsigned long size, u8 *out)
+{
+	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
+	efi_status_t status;
+	struct efi_rng_protocol *rng;
+
+	status = efi_call_early(locate_protocol, &rng_proto, NULL,
+				(void **)&rng);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	return rng->get_rng(rng, NULL, size, out);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 569b5a866bb1..13783fdc9bdd 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -299,7 +299,7 @@ typedef struct {
 	void *open_protocol_information;
 	void *protocols_per_handle;
 	void *locate_handle_buffer;
-	void *locate_protocol;
+	efi_status_t (*locate_protocol)(efi_guid_t *, void *, void **);
 	void *install_multiple_protocol_interfaces;
 	void *uninstall_multiple_protocol_interfaces;
 	void *calculate_crc32;
@@ -599,6 +599,9 @@ void efi_native_runtime_setup(void);
 #define EFI_PROPERTIES_TABLE_GUID \
     EFI_GUID(  0x880aaca3, 0x4adc, 0x4a04, 0x90, 0x79, 0xb7, 0x47, 0x34, 0x08, 0x25, 0xe5 )
 
+#define EFI_RNG_PROTOCOL_GUID \
+    EFI_GUID(  0x3152bca5, 0xeade, 0x433d, 0x86, 0x2e, 0xc0, 0x1c, 0xdc, 0x29, 0x1f, 0x44 )
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
-- 
2.5.0
