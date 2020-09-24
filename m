Return-Path: <SRS0=dVV2=DB=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241B8C4363D
	for <linux-efi@archiver.kernel.org>; Thu, 24 Sep 2020 02:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB4C821D20
	for <linux-efi@archiver.kernel.org>; Thu, 24 Sep 2020 02:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgIXCW5 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 23 Sep 2020 22:22:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14267 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbgIXCW5 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 23 Sep 2020 22:22:57 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 43E614B8EFADAD95D79E;
        Thu, 24 Sep 2020 10:22:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Thu, 24 Sep 2020 10:22:45 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <ardb@kernel.org>, <linux-efi@vger.kernel.org>
CC:     <linuxarm@huawei.com>
Subject: [PATCH] efi: Delete deprecated parameter comments
Date:   Thu, 24 Sep 2020 10:20:18 +0800
Message-ID: <1600914018-12697-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Delete deprecated parameter comments to  fix warnings reported by make
W=1.
drivers/firmware/efi/vars.c:428: warning: Excess function parameter
'atomic' description in 'efivar_init'

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/firmware/efi/vars.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 973eef2..274b0ee 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -414,7 +414,6 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
  * efivar_init - build the initial list of EFI variables
  * @func: callback function to invoke for every variable
  * @data: function-specific data to pass to @func
- * @atomic: do we need to execute the @func-loop atomically?
  * @duplicates: error if we encounter duplicates on @head?
  * @head: initialised head of variable list
  *
-- 
2.7.4

