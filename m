From: Ross Lagerwall <ross.lagerwall@citrix.com>
Subject: [PATCH 1/2] acpi/apei: Avoid possible OOB when accessing BERT region
Date: Tue, 22 Jan 2019 16:09:11 +0000
Message-ID: <20190122160912.27312-2-ross.lagerwall@citrix.com>
References: <20190122160912.27312-1-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122160912.27312-1-ross.lagerwall@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Huang Ying <ying.huang@intel.com>, Ross Lagerwall <ross.lagerwall@citrix.com>
List-Id: linux-efi@vger.kernel.org

Check that the length recorded in the generic error status block is
within the region before checking the contents of the region itself.
Otherwise it may result in an OOB access if the system firmware has
generated a status block with an invalid length (larger than the mapped
region). Also move the block_status check so that it only happens after
the block has been verified to be within the mapped region.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
---
 drivers/acpi/apei/bert.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/apei/bert.c b/drivers/acpi/apei/bert.c
index 12771fcf0417..0d948d0a41af 100644
--- a/drivers/acpi/apei/bert.c
+++ b/drivers/acpi/apei/bert.c
@@ -42,15 +42,7 @@ static void __init bert_print_all(struct acpi_bert_region *region,
 	int remain = region_len;
 	u32 estatus_len;
 
-	if (!estatus->block_status)
-		return;
-
-	while (remain > sizeof(struct acpi_bert_region)) {
-		if (cper_estatus_check(estatus)) {
-			pr_err(FW_BUG "Invalid error record.\n");
-			return;
-		}
-
+	while (remain >= sizeof(struct acpi_bert_region)) {
 		estatus_len = cper_estatus_len(estatus);
 		if (remain < estatus_len) {
 			pr_err(FW_BUG "Truncated status block (length: %u).\n",
@@ -58,6 +50,15 @@ static void __init bert_print_all(struct acpi_bert_region *region,
 			return;
 		}
 
+		/* No more error records. */
+		if (!estatus->block_status)
+			return;
+
+		if (cper_estatus_check(estatus)) {
+			pr_err(FW_BUG "Invalid error record.\n");
+			return;
+		}
+
 		pr_info_once("Error records from previous boot:\n");
 
 		cper_estatus_print(KERN_INFO HW_ERR, estatus);
@@ -70,10 +71,6 @@ static void __init bert_print_all(struct acpi_bert_region *region,
 		estatus->block_status = 0;
 
 		estatus = (void *)estatus + estatus_len;
-		/* No more error records. */
-		if (!estatus->block_status)
-			return;
-
 		remain -= estatus_len;
 	}
 }
-- 
2.17.2
