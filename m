Return-Path: <SRS0=2niR=4E=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F002DC7619D
	for <linux-efi@archiver.kernel.org>; Sun, 16 Feb 2020 18:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBD4222B48
	for <linux-efi@archiver.kernel.org>; Sun, 16 Feb 2020 18:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581877446;
	bh=M6CtQIWxWimc9CTNa99EsOazRYurLdEN+0lz9EbRkzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PDGypRviU0Z/OGAK6fjCW0FpiGPEZzxatf/nYXzxHLAncibDx5PSNAwX7VI+F1mR4
	 QzMeEHzbsX/vDMaD/Ohl/4lEiagVLvJVE0d4wmWcltRUGyrR4b4pQ0lRhxm1JMKjOG
	 ojkypj7K+89wu2dUai6tYCL//DMTXiCz5Aqjjgr0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgBPSYF (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 16 Feb 2020 13:24:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727963AbgBPSYD (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 16 Feb 2020 13:24:03 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1234B2465D;
        Sun, 16 Feb 2020 18:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581877443;
        bh=M6CtQIWxWimc9CTNa99EsOazRYurLdEN+0lz9EbRkzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HF+fSYYCHuFY90WdfozOQ/Gg+MLB1ebGPUlwlpGiC5OyQbuTT7J7qecISnVTyY8Fz
         w7Z1mlXr2uRiv6VsFCnhx8poDOo8eS3nvWJQA9Hw/NeTHiAOqiPapXEntfifvNZvo3
         hoes4JQxVBBy9jejNEh4C6g5Oiox3GkIeL9mvBl4=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>, nivedita@alum.mit.edu,
        x86@kernel.org
Subject: [PATCH 10/18] efi/ia64: switch to efi_config_parse_tables()
Date:   Sun, 16 Feb 2020 19:23:26 +0100
Message-Id: <20200216182334.8121-11-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216182334.8121-1-ardb@kernel.org>
References: <20200216182334.8121-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

IA64 calls efi_config_parse_tables() via efi_config_init(), which
does an explicit memremap() of the tables, which is unnecessary
on IA64. So let's call efi_config_parse_tables() directly, passing
the __va() of the config table array.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/ia64/kernel/efi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 81bc5031a115..3b5cf551489c 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -531,7 +531,10 @@ efi_init (void)
 
 	palo_phys      = EFI_INVALID_TABLE_ADDR;
 
-	if (efi_config_init(arch_tables) != 0)
+	if (efi_config_parse_tables(__va(efi_systab->tables),
+				    efi_systab->nr_tables,
+				    sizeof(efi_config_table_t),
+				    arch_tables) != 0)
 		return;
 
 	if (palo_phys != EFI_INVALID_TABLE_ADDR)
-- 
2.17.1

