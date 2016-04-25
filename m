From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 23/40] efi/arm*: Wire up struct screen_info to efi-framebuffer platform device
Date: Mon, 25 Apr 2016 21:06:55 +0100
Message-ID: <1461614832-17633-24-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, David Herrmann <dh.herrmann@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Peter Jones <pjones@redhat.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This adds code to the ARM and arm64 EFI init routines to expose a platform
device of type 'efi-framebuffer' if struct screen_info has been populated
appropriately from the GOP protocol by the stub. Since the framebuffer may
potentially be located in system RAM, make sure that the region is reserved
and marked MEMBLOCK_NOMAP.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/arm-init.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index ac95dd8b119f..7a3318dd4319 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -19,6 +19,7 @@
 #include <linux/mm_types.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
+#include <linux/platform_device.h>
 #include <linux/screen_info.h>
 
 #include <asm/efi.h>
@@ -78,6 +79,10 @@ static void __init init_screen_info(void)
 		screen_info.orig_video_cols = 80;
 		screen_info.orig_video_lines = 25;
 	}
+
+	if (screen_info.orig_video_isVGA == VIDEO_TYPE_EFI &&
+	    memblock_is_map_memory(screen_info.lfb_base))
+		memblock_mark_nomap(screen_info.lfb_base, screen_info.lfb_size);
 }
 
 static int __init uefi_init(void)
@@ -256,3 +261,16 @@ void __init efi_init(void)
 
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
+	pd = platform_device_register_data(NULL, "efi-framebuffer", 0,
+					   &screen_info, sizeof(screen_info));
+	return PTR_ERR_OR_ZERO(pd);
+}
+subsys_initcall(register_gop_device);
-- 
2.7.3
