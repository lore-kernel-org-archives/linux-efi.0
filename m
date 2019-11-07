Return-Path: <SRS0=vceF=Y7=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C525C5DF61
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 08:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B04921D79
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 08:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfKGIX7 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:23:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:5741 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727027AbfKGIX6 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 7 Nov 2019 03:23:58 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5D7FB1B54EFADCFA7427;
        Thu,  7 Nov 2019 16:23:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 7 Nov 2019 16:23:46 +0800
From:   Xinwei Kong <kong.kongxinwei@hisilicon.com>
To:     <ard.biesheuvel@linaro.org>, <mingo@kernel.org>, <will@kernel.org>,
        <kstewart@linuxfoundation.org>, <tglx@linutronix.de>,
        <steve.capper@arm.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <linuxarm@huawei.com>, <zoucao@linux.alibaba.com>,
        <kong.kongxinwei@hisilicon.com>
Subject: [PATCH V2] EFI/stub: tpm: enable tpm eventlog function for ARM64 platform
Date:   Thu, 7 Nov 2019 16:24:21 +0800
Message-ID: <1573115061-34791-1-git-send-email-kong.kongxinwei@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

this patch gets tpm eventlog information such as device boot status,event guid
and so on, which will be from bios stage. it use "efi_retrieve_tpm2_eventlog"
functions to get it for ARM64 platorm.

Tested-by: Zou Cao <zoucao@linux.alibaba.com>
Signed-off-by: Xinwei Kong <kong.kongxinwei@hisilicon.com>
---
 drivers/firmware/efi/libstub/arm-stub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index c382a48..817237c 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -189,6 +189,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail_free_cmdline;
 	}
 
+	efi_retrieve_tpm2_eventlog(sys_table);
+
 	/* Ask the firmware to clear memory on unclean shutdown */
 	efi_enable_reset_attack_mitigation(sys_table);
 
-- 
2.7.4

