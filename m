From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 10/15] acpi: Ignore acpi_rsdp kernel parameter in a secure boot environment
Date: Mon, 28 Jan 2013 11:42:34 -0500
Message-ID: <1359391359-25783-11-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This option allows userspace to pass the RSDP address to the kernel.  This
could potentially be used to circumvent the secure boot trust model.
We ignore the setting if we don't have the CAP_COMPROMISE_KERNEL capability.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 drivers/acpi/osl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index bd22f86..88251d2 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -246,7 +246,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
 acpi_physical_address __init acpi_os_get_root_pointer(void)
 {
 #ifdef CONFIG_KEXEC
-	if (acpi_rsdp)
+	if (acpi_rsdp && capable(CAP_COMPROMISE_KERNEL))
 		return acpi_rsdp;
 #endif
 
-- 
1.8.0.2

