Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718E9C74A5B
	for <linux-efi@archiver.kernel.org>; Tue, 21 Mar 2023 14:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCUOUo (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 21 Mar 2023 10:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjCUOUn (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 21 Mar 2023 10:20:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C923144A7
        for <linux-efi@vger.kernel.org>; Tue, 21 Mar 2023 07:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34E54B81664
        for <linux-efi@vger.kernel.org>; Tue, 21 Mar 2023 14:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D79C4339C;
        Tue, 21 Mar 2023 14:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679408437;
        bh=kzlXCEV6dsUhhuh44RDz72iM1mHvkqPbXlD3BqKDttI=;
        h=From:To:Cc:Subject:Date:From;
        b=bhQN/ox4zTLMyAeAKF3PLUgqKoCnaPZiVXEgIUtNqKaesojhUBBKHds3W4VxkQ6x2
         +TFip+UIRfOFmUeuusOEQE5qZdEt7Vl+XcS6OT2jkheiPI+3NZVJ+3WK+EPjTbORUZ
         sMHJ7vuYDBIlv4uFiN34v11hQpKWxJm29solTW+pHSa7paDjZfuQkSpOR7pKiKsMMp
         AJzrYcipSz9om9tcXhKyhDDSs2KyRsrVJkr1O1wrTX1L3Nfc88CrCXGzpzk1iic4Ib
         WoSAbFxnFp/nCa1O1lxuMjnXXP8LjChsYEBlOH2WzEDhn0Dn0rWGo4DaO/uyu3CqE0
         Htin1hwd5Oo3A==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] efi/libstub: zboot: Add compressed image to make targets
Date:   Tue, 21 Mar 2023 15:20:30 +0100
Message-Id: <20230321142030.3287974-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=827; i=ardb@kernel.org; h=from:subject; bh=kzlXCEV6dsUhhuh44RDz72iM1mHvkqPbXlD3BqKDttI=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIUVyr25R68/tR/dOdDklF+338dqyfwtD9V9tsjFKXtmi7 sLTN3tDRykLgxgHg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjItwJGhhMXhB6eWxGQJKm9 RFKr7JN34s55Z6/zbWONspzx4Jnn9n0M/1RkljzMqTh5ZPdk0eAPNavEk0t1TAWFBTrrZfxepbZ xsQAA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Avoid needlessly rebuilding the compressed image by adding the file
'vmlinuz' to the 'targets' Kbuild make variable.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile.zboot | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile.zboot b/drivers/firmware/efi/libstub/Makefile.zboot
index 43e9a4cab9f5dcf1..ccdd6a130d98618e 100644
--- a/drivers/firmware/efi/libstub/Makefile.zboot
+++ b/drivers/firmware/efi/libstub/Makefile.zboot
@@ -44,4 +44,4 @@ OBJCOPYFLAGS_vmlinuz.efi := -O binary
 $(obj)/vmlinuz.efi: $(obj)/vmlinuz.efi.elf FORCE
 	$(call if_changed,objcopy)
 
-targets += zboot-header.o vmlinuz.o vmlinuz.efi.elf vmlinuz.efi
+targets += zboot-header.o vmlinuz vmlinuz.o vmlinuz.efi.elf vmlinuz.efi
-- 
2.39.2

