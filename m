From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/24] ACPI: Limit access to custom_method when the kernel
 is locked down
Date: Wed, 05 Apr 2017 21:16:50 +0100
Message-ID: <149142340999.5101.7799938986753834830.stgit@warthog.procyon.org.uk>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-efi@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org, dhowells@redhat.com, linux-acpi@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Matthew Garrett <matthew.garrett@nebula.com>

custom_method effectively allows arbitrary access to system memory, making
it possible for an attacker to circumvent restrictions on module loading.
Disable it if the kernel is locked down.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-acpi@vger.kernel.org
---

 drivers/acpi/custom_method.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
index c68e72414a67..e4d721c330c0 100644
--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -29,6 +29,9 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
 	struct acpi_table_header table;
 	acpi_status status;
 
+	if (kernel_is_locked_down())
+		return -EPERM;
+
 	if (!(*ppos)) {
 		/* parse the table header to get the table length */
 		if (count <= sizeof(struct acpi_table_header))

