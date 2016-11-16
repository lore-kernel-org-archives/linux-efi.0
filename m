From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/16] acpi: Ignore acpi_rsdp kernel param when the kernel
 has been locked down
Date: Wed, 16 Nov 2016 21:49:05 +0000
Message-ID: <147933294499.19316.17682060500981577979.stgit@warthog.procyon.org.uk>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-efi@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This option allows userspace to pass the RSDP address to the kernel, which
makes it possible for a user to circumvent any restrictions imposed on
loading modules.  Ignore the option when the kernel is locked down.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/acpi/osl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 416953a42510..fb1dc79a7f1b 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -40,6 +40,7 @@
 #include <linux/list.h>
 #include <linux/jiffies.h>
 #include <linux/semaphore.h>
+#include <linux/security.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -191,7 +192,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
 acpi_physical_address __init acpi_os_get_root_pointer(void)
 {
 #ifdef CONFIG_KEXEC
-	if (acpi_rsdp)
+	if (acpi_rsdp && !kernel_is_locked_down())
 		return acpi_rsdp;
 #endif
 
