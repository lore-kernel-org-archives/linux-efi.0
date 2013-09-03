From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 07/11] acpi: Ignore acpi_rsdp kernel parameter when module loading is restricted
Date: Tue,  3 Sep 2013 19:50:14 -0400
Message-ID: <1378252218-18798-8-git-send-email-matthew.garrett@nebula.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378252218-18798-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This option allows userspace to pass the RSDP address to the kernel, which
makes it possible for a user to circumvent any restrictions imposed on
loading modules. Disable it in that case.

Signed-off-by: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
