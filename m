Return-Path: <SRS0=a7xh=Y5=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FCCCA9ED5
	for <linux-efi@archiver.kernel.org>; Tue,  5 Nov 2019 08:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6110E2084D
	for <linux-efi@archiver.kernel.org>; Tue,  5 Nov 2019 08:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387675AbfKEI3n (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 5 Nov 2019 03:29:43 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:60382 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387575AbfKEI3m (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 5 Nov 2019 03:29:42 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7E387F1619D937D41398;
        Tue,  5 Nov 2019 16:29:40 +0800 (CST)
Received: from szxy7k002784261.china.huawei.com (10.57.64.164) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 5 Nov 2019 16:29:31 +0800
From:   Xinwei Kong <kong.kongxinwei@hisilicon.com>
To:     <ard.biesheuvel@linaro.org>, <mingo@kernel.org>, <will@kernel.org>,
        <kstewart@linuxfoundation.org>, <tglx@linutronix.de>,
        <steve.capper@arm.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <linuxarm@huawei.com>, <zoucao@linux.alibaba.com>,
        <kong.kongxinwei@hisilicon.com>
Subject: [PATCH] EFI/stub: tpm: enable tpm eventlog function for ARM64 platform
Date:   Tue, 5 Nov 2019 16:29:24 +0800
Message-ID: <20191105082924.289-1-kong.kongxinwei@hisilicon.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.57.64.164]
X-CFilter-Loop: Reflected
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

this patch gets tpm eventlog information such as device boot status,event guid
and so on, which will be from bios stage. it use "efi_retrieve_tpm2_eventlog"
functions to get it for ARM64 platorm.

Signed-off-by: Xinwei Kong <kong.kongxinwei@hisilicon.com>
Signed-off-by: Zou Cao <zoucao@linux.alibaba.com>
---
 drivers/firmware/efi/libstub/arm-stub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index c382a48..37c8f81 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -139,6 +139,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	if (status != EFI_SUCCESS)
 		goto fail;
 
+	efi_retrieve_tpm2_eventlog(sys_table);
+
 	/*
 	 * Get a handle to the loaded image protocol.  This is used to get
 	 * information about the running image, such as size and the command
-- 
2.7.4


