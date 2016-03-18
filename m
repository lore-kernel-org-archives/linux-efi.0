From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 8/9] efi/arm*: wire up struct screen_info to efi-framebuffer platform device
Date: Fri, 18 Mar 2016 17:47:40 +0100
Message-ID: <1458319661-19762-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1458319661-19762-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458319661-19762-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, linux@arm.linux.org.uk, pjones@redhat.com, dh.herrmann@gmail.com
Cc: leif.lindholm@linaro.org, mark.rutland@arm.com, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

This adds code to the ARM and arm64 EFI init routines to expose a platform
device of type 'efi-framebuffer' if struct screen_info has been populated
appropriately from the GOP protocol by the stub. Since the framebuffer may
potentially be located in system RAM, make sure that the region is reserved
and marked MEMBLOCK_NOMAP.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/arm-init.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index acd44de30504..f5f13b871d42 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -19,6 +19,7 @@
 #include <linux/mm_types.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
+#include <linux/platform_device.h>
 #include <linux/screen_info.h>
 
 #include <asm/efi.h>
@@ -76,6 +77,10 @@ static void __init init_screen_info(void)
 		screen_info = *si;
 		early_memunmap(si, sizeof(*si));
 	}
+
+	if (screen_info.orig_video_isVGA == VIDEO_TYPE_EFI &&
+	    memblock_is_map_memory(screen_info.lfb_base))
+		memblock_mark_nomap(screen_info.lfb_base, screen_info.lfb_size);
 }
 
 static int __init uefi_init(void)
@@ -235,3 +240,16 @@ void __init efi_init(void)
 
 	init_screen_info();
 }
+
+static int __init register_gop_device(void)
+{
+	void *pd;
+
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+		return 0;
+
+	/* the efifb driver accesses screen_info directly, no need to pass it */
+	pd = platform_device_register_simple("efi-framebuffer", 0, NULL, 0);
+	return PTR_ERR_OR_ZERO(pd);
+}
+subsys_initcall(register_gop_device);
-- 
2.5.0
