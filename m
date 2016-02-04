From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 5/7] ARM: efistub: check for LPAE support before booting a LPAE kernel
Date: Thu,  4 Feb 2016 16:50:28 +0100
Message-ID: <1454601030-9093-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1454601030-9093-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454601030-9093-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, jeremy.linton-5wv7dgnIgG8@public.gmane.org, suzuki.poulose-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

A kernel built with support for LPAE cannot boot to a state where it
can inform the user about it if it fails due to missing LPAE support
in the hardware.

If we happen to be booting via UEFI, we can fail gracefully so check
for LPAE support in the hardware on CONFIG_ARM_LPAE builds before
entering the kernel proper.

Reviewed-by: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/arm32-stub.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index 495ebd657e38..6f42be4d0084 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -9,6 +9,23 @@
 #include <linux/efi.h>
 #include <asm/efi.h>
 
+efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
+{
+	int block;
+
+	/* non-LPAE kernels can run anywhere */
+	if (!IS_ENABLED(CONFIG_ARM_LPAE))
+		return EFI_SUCCESS;
+
+	/* LPAE kernels need compatible hardware */
+	block = cpuid_feature_extract(CPUID_EXT_MMFR0, 0);
+	if (block < 5) {
+		pr_efi_err(sys_table_arg, "This LPAE kernel is not supported by your CPU\n");
+		return EFI_UNSUPPORTED;
+	}
+	return EFI_SUCCESS;
+}
+
 efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 				 unsigned long *image_addr,
 				 unsigned long *image_size,
-- 
2.5.0
