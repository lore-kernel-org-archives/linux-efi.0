From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 2/2] arm64/efi: esrt: add missing call to efi_esrt_init()
Date: Mon, 15 Feb 2016 12:32:33 +0100
Message-ID: <1455535953-5056-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1455535953-5056-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455535953-5056-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

ESRT support is built by default for all architectures that define
CONFIG_EFI. However, this support was not wired up yet for ARM/arm64,
since efi_esrt_init() was never called. So add the missing call.

Since efi_esrt_init() uses efi_mem_desc_lookup(), which in turn relies
on efi.memmap having been assigned and populated completetely, add the
missing assignments of efi.memmap and efi.memmap->nr_map.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/arm-init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 9e15d571b53c..5c5e799bdb50 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -197,10 +197,13 @@ void __init efi_init(void)
 	memmap.map_end = memmap.map + params.mmap_size;
 	memmap.desc_size = params.desc_size;
 	memmap.desc_version = params.desc_ver;
+	memmap.nr_map = params.mmap_size / params.desc_size;
+	efi.memmap = &memmap;
 
 	if (uefi_init() < 0)
 		return;
 
+	efi_esrt_init();
 	reserve_regions();
 	early_memunmap(memmap.map, params.mmap_size);
 	memblock_mark_nomap(params.mmap & PAGE_MASK,
-- 
2.5.0
