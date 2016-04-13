From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] efi: check EFI_MEMORY_DESCRIPTOR version explicitly
Date: Wed, 13 Apr 2016 17:37:52 +0200
Message-ID: <1460561873-27756-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Our efi_memory_desc_t type is based on EFI_MEMORY_DESCRIPTOR version 1 in
the UEFI spec. No version updates are expected, but since we are about to
introduce support for new firmware tables that use the same descriptor
type, it makes sense to at least warn if we encounter other versions.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/platform/efi/efi.c     | 4 ++++
 drivers/firmware/efi/arm-init.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 88d2fb2cb3ef..dde46cd78b8f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -211,6 +211,10 @@ int __init efi_memblock_x86_reserve_range(void)
 	efi.memmap.desc_size	= e->efi_memdesc_size;
 	efi.memmap.desc_version	= e->efi_memdesc_version;
 
+	WARN(efi.memmap.desc_version != 1,
+	     "Unexpected EFI_MEMORY_DESCRIPTOR version %ld",
+	     efi.memmap.desc_version);
+
 	memblock_reserve(pmap, efi.memmap.nr_map * efi.memmap.desc_size);
 
 	return 0;
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 93e46bfd6c23..aafaac3c02d5 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -198,6 +198,10 @@ void __init efi_init(void)
 	efi.memmap.desc_size = params.desc_size;
 	efi.memmap.desc_version = params.desc_ver;
 
+	WARN(efi.memmap.desc_version != 1,
+	     "Unexpected EFI_MEMORY_DESCRIPTOR version %ld",
+	      efi.memmap.desc_version);
+
 	if (uefi_init() < 0)
 		return;
 
-- 
2.5.0
