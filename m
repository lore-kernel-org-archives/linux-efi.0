Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F0CC433F5
	for <linux-efi@archiver.kernel.org>; Fri, 30 Sep 2022 02:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiI3CDu (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 29 Sep 2022 22:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiI3CDt (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 29 Sep 2022 22:03:49 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB0C20589F;
        Thu, 29 Sep 2022 19:03:48 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Mdtkb6Cp7zHqTX;
        Fri, 30 Sep 2022 10:01:27 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 10:03:46 +0800
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 10:03:45 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     Ard Biesheuvel <ardb@kernel.org>, <linux-efi@vger.kernel.org>,
        <linux@armlinux.org.uk>
CC:     <linux-kernel@vger.kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] efi/arm: dump UEFI runtime page tables for ARM
Date:   Fri, 30 Sep 2022 10:24:10 +0800
Message-ID: <20220930022410.107297-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

UEFI runtime page tables dump only for ARM64 at present,
but ARM support EFI and ARM_PTDUMP_DEBUGFS now, so enable
it for ARM too.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
note: build test only.
 drivers/firmware/efi/arm-runtime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 3359ae2adf24..e04956ed1b0a 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -25,7 +25,7 @@
 #include <asm/mmu.h>
 #include <asm/pgalloc.h>
 
-#if defined(CONFIG_PTDUMP_DEBUGFS) && defined(CONFIG_ARM64)
+#if defined(CONFIG_PTDUMP_DEBUGFS) || defined(CONFIG_ARM_PTDUMP_DEBUGFS)
 #include <asm/ptdump.h>
 
 static struct ptdump_info efi_ptdump_info = {
-- 
2.35.3

