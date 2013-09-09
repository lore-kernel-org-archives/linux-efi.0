From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 06/12] acpi: Limit access to custom_method if securelevel is set
Date: Mon,  9 Sep 2013 11:49:40 -0400
Message-ID: <1378741786-18430-7-git-send-email-matthew.garrett@nebula.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org, jmorris@namei.org, linux-security-module@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

custom_method effectively allows arbitrary access to system memory, making
it possible for an attacker to modify the kernel at runtime. Prevent this
if securelevel has been set.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/acpi/custom_method.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
index 12b62f2..8b881db 100644
--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/uaccess.h>
 #include <linux/debugfs.h>
+#include <linux/security.h>
 #include <acpi/acpi_drivers.h>
 
 #include "internal.h"
@@ -29,6 +30,9 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
 	struct acpi_table_header table;
 	acpi_status status;
 
+	if (get_securelevel() > 0)
+		return -EPERM;
+
 	if (!(*ppos)) {
 		/* parse the table header to get the table length */
 		if (count <= sizeof(struct acpi_table_header))
-- 
1.8.3.1
