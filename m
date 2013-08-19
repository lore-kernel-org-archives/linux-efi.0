From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 07/10] acpi: Ignore acpi_rsdp kernel parameter when module loading is restricted
Date: Mon, 19 Aug 2013 12:10:16 -0400
Message-ID: <1376928619-3775-7-git-send-email-matthew.garrett@nebula.com>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This option allows userspace to pass the RSDP address to the kernel, which
makes it possible for a user to circumvent any restrictions imposed on
loading modules. Disable it in that case.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 drivers/acpi/osl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 6ab2c35..e4c4410 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -45,6 +45,7 @@
 #include <linux/list.h>
 #include <linux/jiffies.h>
 #include <linux/semaphore.h>
+#include <linux/module.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -245,7 +246,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
 acpi_physical_address __init acpi_os_get_root_pointer(void)
 {
 #ifdef CONFIG_KEXEC
-	if (acpi_rsdp)
+	if (acpi_rsdp && !secure_modules())
 		return acpi_rsdp;
 #endif
 
-- 
1.8.3.1
