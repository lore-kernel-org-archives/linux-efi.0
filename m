From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 8/9] efi/cper: Use consistent types for UUIDs
Date: Fri, 20 Jul 2018 10:47:25 +0900
Message-ID: <20180720014726.24031-9-ard.biesheuvel@linaro.org>
References: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

The commit

  2f74f09bce4f ("efi: parse ARM processor error")

brought inconsistency in UUID types which are used across the CPER.

Fix this by moving to use guid_t API everywhere.

Cc: Tyler Baicar <tbaicar@codeaurora.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/cper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index b73fc4cab083..a7902fccdcfa 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -472,7 +472,7 @@ cper_estatus_print_section(const char *pfx, struct acpi_hest_generic_data *gdata
 		else
 			goto err_section_too_small;
 #if defined(CONFIG_ARM64) || defined(CONFIG_ARM)
-	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_ARM)) {
+	} else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
 		struct cper_sec_proc_arm *arm_err = acpi_hest_get_payload(gdata);
 
 		printk("%ssection_type: ARM processor error\n", newpfx);
-- 
2.17.1
