Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F69C433F5
	for <linux-efi@archiver.kernel.org>; Tue, 24 May 2022 02:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbiEXCre (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 23 May 2022 22:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiEXCrd (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 23 May 2022 22:47:33 -0400
Received: from mail.meizu.com (edge07.meizu.com [112.91.151.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EA0369F1;
        Mon, 23 May 2022 19:47:30 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail11.meizu.com
 (172.16.1.15) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 24 May
 2022 10:47:30 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Tue, 24 May
 2022 10:47:28 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>
CC:     Haowen Bai <baihaowen@meizu.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] LoongArch: Fix unsigned function returning negative constant
Date:   Tue, 24 May 2022 10:47:25 +0800
Message-ID: <1653360446-15598-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The function set_virtual_map has an unsigned return type, but returns a
negative constant to indicate an error condition. So we change unsigned
to int.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 arch/loongarch/kernel/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/efi.c b/arch/loongarch/kernel/efi.c
index 69ebdd4220ec..f9fdeb1ae358 100644
--- a/arch/loongarch/kernel/efi.c
+++ b/arch/loongarch/kernel/efi.c
@@ -102,7 +102,7 @@ static void __init fix_efi_mapping(void)
  * in @memory_map whose EFI_MEMORY_RUNTIME attribute is set. Those descriptors
  * are also copied to @runtime_map, and their total count is returned in @count.
  */
-static unsigned int __init set_virtual_map(void)
+static int __init set_virtual_map(void)
 {
 	int count = 0;
 	unsigned int size;
-- 
2.7.4

