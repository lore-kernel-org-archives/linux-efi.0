Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E356CC433ED
	for <linux-efi@archiver.kernel.org>; Sun,  4 Apr 2021 17:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB9BE6120E
	for <linux-efi@archiver.kernel.org>; Sun,  4 Apr 2021 17:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhDDR7t (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 4 Apr 2021 13:59:49 -0400
Received: from fgw23-7.mail.saunalahti.fi ([62.142.5.84]:53174 "EHLO
        fgw23-7.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229918AbhDDR7t (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Sun, 4 Apr 2021 13:59:49 -0400
Received: from localhost (88-115-248-186.elisa-laajakaista.fi [88.115.248.186])
        by fgw23.mail.saunalahti.fi (Halon) with ESMTP
        id 4a7f91e6-956d-11eb-8ccd-005056bdfda7;
        Sun, 04 Apr 2021 20:43:40 +0300 (EEST)
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Lukas Wunner <lukas@wunner.de>
Subject: [PATCH v1 1/1] efi/dev-path-parser: Switch to use for_each_acpi_dev_match()
Date:   Sun,  4 Apr 2021 20:43:18 +0300
Message-Id: <20210404174318.1441996-1-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Switch to use for_each_acpi_dev_match() instead of home grown analogue.
No functional change intended.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/firmware/efi/dev-path-parser.c | 47 +++++++++-----------------
 1 file changed, 16 insertions(+), 31 deletions(-)

diff --git a/drivers/firmware/efi/dev-path-parser.c b/drivers/firmware/efi/dev-path-parser.c
index 5c9625e552f4..e898013fd2a4 100644
--- a/drivers/firmware/efi/dev-path-parser.c
+++ b/drivers/firmware/efi/dev-path-parser.c
@@ -12,52 +12,37 @@
 #include <linux/efi.h>
 #include <linux/pci.h>
 
-struct acpi_hid_uid {
-	struct acpi_device_id hid[2];
-	char uid[11]; /* UINT_MAX + null byte */
-};
-
-static int __init match_acpi_dev(struct device *dev, const void *data)
-{
-	struct acpi_hid_uid hid_uid = *(const struct acpi_hid_uid *)data;
-	struct acpi_device *adev = to_acpi_device(dev);
-
-	if (acpi_match_device_ids(adev, hid_uid.hid))
-		return 0;
-
-	if (adev->pnp.unique_id)
-		return !strcmp(adev->pnp.unique_id, hid_uid.uid);
-	else
-		return !strcmp("0", hid_uid.uid);
-}
-
 static long __init parse_acpi_path(const struct efi_dev_path *node,
 				   struct device *parent, struct device **child)
 {
-	struct acpi_hid_uid hid_uid = {};
+	char hid[ACPI_ID_LEN], uid[11]; /* UINT_MAX + null byte */
+	struct acpi_device *adev;
 	struct device *phys_dev;
 
 	if (node->header.length != 12)
 		return -EINVAL;
 
-	sprintf(hid_uid.hid[0].id, "%c%c%c%04X",
+	sprintf(hid, "%c%c%c%04X",
 		'A' + ((node->acpi.hid >> 10) & 0x1f) - 1,
 		'A' + ((node->acpi.hid >>  5) & 0x1f) - 1,
 		'A' + ((node->acpi.hid >>  0) & 0x1f) - 1,
 			node->acpi.hid >> 16);
-	sprintf(hid_uid.uid, "%u", node->acpi.uid);
+	sprintf(uid, "%u", node->acpi.uid);
 
-	*child = bus_find_device(&acpi_bus_type, NULL, &hid_uid,
-				 match_acpi_dev);
-	if (!*child)
+	for_each_acpi_dev_match(adev, hid, NULL, -1) {
+		if (adev->pnp.unique_id && !strcmp(adev->pnp.unique_id, uid))
+			break;
+		if (!adev->pnp.unique_id && node->acpi.uid == 0)
+			break;
+	}
+	if (!adev)
 		return -ENODEV;
 
-	phys_dev = acpi_get_first_physical_node(to_acpi_device(*child));
-	if (phys_dev) {
-		get_device(phys_dev);
-		put_device(*child);
-		*child = phys_dev;
-	}
+	phys_dev = acpi_get_first_physical_node(adev);
+	if (phys_dev)
+		*child = get_device(phys_dev);
+	else
+		*child = get_device(&adev->dev);
 
 	return 0;
 }
-- 
2.31.1

