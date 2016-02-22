From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/5] arm*: efi: take the Memory Attributes table into account
Date: Mon, 22 Feb 2016 15:29:15 +0100
Message-ID: <1456151355-25943-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1456151158-25849-4-git-send-email-ard.biesheuvel@linaro.org>
 <1456151355-25943-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456151355-25943-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Call into the generic memory attributes table support code at the
appropriate times during the init sequence so that the UEFI Runtime
Services region are mapped according to the strict permissions it
specifies.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h       | 2 ++
 drivers/firmware/efi/arm-init.c    | 1 +
 drivers/firmware/efi/arm-runtime.c | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8e88a696c9cb..4dafc89f373a 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -14,6 +14,8 @@ extern void efi_init(void);
 
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 
+#define efi_set_mapping_permissions	efi_create_mapping
+
 #define efi_call_virt(f, ...)						\
 ({									\
 	efi_##f##_t *__f;						\
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index aa1f743152a2..022f11157acd 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -202,6 +202,7 @@ void __init efi_init(void)
 		return;
 
 	reserve_regions();
+	efi_memattr_init();
 	early_memunmap(memmap.map, params.mmap_size);
 	memblock_mark_nomap(params.mmap & PAGE_MASK,
 			    PAGE_ALIGN(params.mmap_size +
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 3a3911641049..848ede1587dc 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -65,6 +65,9 @@ static bool __init efi_virtmap_init(void)
 			return false;
 		}
 	}
+
+	if (efi_memattr_apply_permissions(&efi_mm, efi_set_mapping_permissions))
+		return false;
 	return true;
 }
 
-- 
2.5.0
