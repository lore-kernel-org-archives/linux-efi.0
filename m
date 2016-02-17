From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 09/13] efi/arm64: Check for h/w support before booting a >4 KB granule kernel
Date: Wed, 17 Feb 2016 12:36:02 +0000
Message-ID: <1455712566-16727-10-git-send-email-matt@codeblueprint.co.uk>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Jeremy Linton <jeremy.linton@arm.com>, Mark Rutland <mark.rutland@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

A kernel built with support for a page size that is not supported by the
hardware it runs on cannot boot to a state where it can inform the user
about it.

If we happen to be booting via UEFI, we can fail gracefully so check
if the currently configured page size is supported by the hardware before
entering the kernel proper. Note that UEFI mandates support for 4 KB pages,
so in that case, no check is needed.

Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/libstub/arm64-stub.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 9e0342745e4f..aef04ad60e0d 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -12,6 +12,26 @@
 #include <linux/efi.h>
 #include <asm/efi.h>
 #include <asm/sections.h>
+#include <asm/sysreg.h>
+
+efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
+{
+	u64 tg;
+
+	/* UEFI mandates support for 4 KB granule, no need to check */
+	if (IS_ENABLED(CONFIG_ARM64_4K_PAGES))
+		return EFI_SUCCESS;
+
+	tg = (read_cpuid(ID_AA64MMFR0_EL1) >> ID_AA64MMFR0_TGRAN_SHIFT) & 0xf;
+	if (tg != ID_AA64MMFR0_TGRAN_SUPPORTED) {
+		if (IS_ENABLED(CONFIG_ARM64_64K_PAGES))
+			pr_efi_err(sys_table_arg, "This 64 KB granule kernel is not supported by your CPU\n");
+		else
+			pr_efi_err(sys_table_arg, "This 16 KB granule kernel is not supported by your CPU\n");
+		return EFI_UNSUPPORTED;
+	}
+	return EFI_SUCCESS;
+}
 
 efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 				 unsigned long *image_addr,
-- 
2.6.2
