From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 08/13] efi/arm: Check for LPAE support before booting a LPAE kernel
Date: Wed, 17 Feb 2016 12:36:01 +0000
Message-ID: <1455712566-16727-9-git-send-email-matt@codeblueprint.co.uk>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Jeremy Linton <jeremy.linton@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

A kernel built with support for LPAE cannot boot to a state where it
can inform the user about it if it fails due to missing LPAE support
in the hardware.

If we happen to be booting via UEFI, we can fail gracefully so check
for LPAE support in the hardware on CONFIG_ARM_LPAE builds before
entering the kernel proper.

Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
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
2.6.2
