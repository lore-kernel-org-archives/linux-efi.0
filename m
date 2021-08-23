Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D765EC4338F
	for <linux-efi@archiver.kernel.org>; Mon, 23 Aug 2021 11:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC07761357
	for <linux-efi@archiver.kernel.org>; Mon, 23 Aug 2021 11:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhHWL5m (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 23 Aug 2021 07:57:42 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:56053 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230289AbhHWL5l (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 23 Aug 2021 07:57:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UlKNrJN_1629719817;
Received: from localhost.localdomain(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0UlKNrJN_1629719817)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 23 Aug 2021 19:56:57 +0800
From:   Shuai Xue <xueshuai@linux.alibaba.com>
To:     ardb@kernel.org
Cc:     xueshuai@linux.alibaba.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhangliguang@linux.alibaba.com
Subject: [PATCH] efi: cper: check section header more appropriately
Date:   Mon, 23 Aug 2021 19:56:54 +0800
Message-Id: <20210823115654.45405-1-xueshuai@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

When checking a generic status block, we iterate over all the generic data
blocks. The loop condition checks that the generic data block is valid.
Because the size of data blocks (excluding error data) may vary depending
on the revision and the revision is contained within the data block, we
should ensure that enough of the current data block is valid appropiriately
for different revision.

Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
---
 drivers/firmware/efi/cper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index e15d484b6a5a..e80706d9e78a 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -635,7 +635,7 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 	data_len = estatus->data_length;
 
 	apei_estatus_for_each_section(estatus, gdata) {
-		if (sizeof(struct acpi_hest_generic_data) > data_len)
+		if (acpi_hest_get_size(gdata) > data_len)
 			return -EINVAL;
 
 		record_size = acpi_hest_get_record_size(gdata);
-- 
2.20.1.12.g72788fdb

