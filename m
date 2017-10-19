From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/27] acpi: Ignore acpi_rsdp kernel param when the kernel
 has been locked down
Date: Thu, 19 Oct 2017 15:52:27 +0100
Message-ID: <150842474713.7923.4851355698276917280.stgit@warthog.procyon.org.uk>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This option allows userspace to pass the RSDP address to the kernel, which
makes it possible for a user to modify the workings of hardware .  Reject
the option when the kernel is locked down.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Dave Young <dyoung@redhat.com>
cc: linux-acpi@vger.kernel.org
---

 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index db78d353bab1..36c6527c1b0a 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -192,7 +192,7 @@ acpi_physical_address __init acpi_os_get_root_pointer(void)
 	acpi_physical_address pa = 0;
 
 #ifdef CONFIG_KEXEC
-	if (acpi_rsdp)
+	if (acpi_rsdp && !kernel_is_locked_down("ACPI RSDP specification"))
 		return acpi_rsdp;
 #endif
 
