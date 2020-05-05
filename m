Return-Path: <SRS0=BkE4=6T=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF84C47254
	for <linux-efi@archiver.kernel.org>; Tue,  5 May 2020 08:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 974742075A
	for <linux-efi@archiver.kernel.org>; Tue,  5 May 2020 08:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588667578;
	bh=tEtYwbHIEBSjoO7xCVKA06ixFT9BcUomNx/PjkEJSkM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=t+F2TfkMySt9X4QKVfTxo1j3JanKa/dkBxVO4MtLuzr+QyyNvJ3kt7cIsOSLWF8+k
	 piJtfxz/vx3txhfeVDjziBZEh5txGsbOJlKFFTtgN0zu6NKpG+LUqbJc0b09KZZMXk
	 d8FDSrCkd/zYVSY14J2zvDcwnUrEWHJj3PGxBi0Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgEEIc6 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 5 May 2020 04:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgEEIc6 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 5 May 2020 04:32:58 -0400
Received: from e123331-lin.nice.arm.com (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA18320658;
        Tue,  5 May 2020 08:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588667577;
        bh=tEtYwbHIEBSjoO7xCVKA06ixFT9BcUomNx/PjkEJSkM=;
        h=From:To:Cc:Subject:Date:From;
        b=HgAOoSfbgsnpGFrO5hXYXPkhT3Zoafq0c2IpIt8VZyTLnjknshZD9hSb3PRAAZ2QV
         h5M0tRLHGPX/OtAd6HDTgQ9FiTmGWQeN4lOU4HJ9k2zdElMZV9g9pg70pOKiRZYmnB
         GMghntIp9bEuU+uV55uXYVkaNLqrqVGLh+bb7LIo=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     nivedita@alum.mit.edu, joe@perches.com,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] efi/libstub: Make efi_printk() input argument const char*
Date:   Tue,  5 May 2020 10:32:51 +0200
Message-Id: <20200505083251.12193-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

To help the compiler figure out that efi_printk() will not modify
the string it is given, make the input argument type const char*.

While at it, simplify the implementation as well.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 .../firmware/efi/libstub/efi-stub-helper.c    | 19 +++++++------------
 drivers/firmware/efi/libstub/efistub.h        |  2 +-
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 7aac89e928ec..2927f3d30344 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -26,20 +26,15 @@ bool __pure __efi_soft_reserve_enabled(void)
 	return !efi_nosoftreserve;
 }
 
-void efi_printk(char *str)
+void efi_printk(const char *str)
 {
-	char *s8;
-
-	for (s8 = str; *s8; s8++) {
-		efi_char16_t ch[2] = { 0 };
-
-		ch[0] = *s8;
-		if (*s8 == '\n') {
-			efi_char16_t nl[2] = { '\r', 0 };
-			efi_char16_printk(nl);
-		}
+	while (*str) {
+		efi_char16_t ch[] = { *str++, L'\0' };
 
-		efi_char16_printk(ch);
+		if (ch[0] == L'\n')
+			efi_char16_printk(L"\r\n");
+		else
+			efi_char16_printk(ch);
 	}
 }
 
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 4f10a09563f3..15d0b6f3f6c6 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -625,7 +625,7 @@ efi_status_t check_platform_features(void);
 
 void *get_efi_config_table(efi_guid_t guid);
 
-void efi_printk(char *str);
+void efi_printk(const char *str);
 
 void efi_free(unsigned long size, unsigned long addr);
 
-- 
2.17.1

