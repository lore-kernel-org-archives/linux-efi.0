Return-Path: <SRS0=Spkt=AE=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C74DC433E0
	for <linux-efi@archiver.kernel.org>; Tue, 23 Jun 2020 15:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D69B20776
	for <linux-efi@archiver.kernel.org>; Tue, 23 Jun 2020 15:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732910AbgFWPJn (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 23 Jun 2020 11:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732908AbgFWPJm (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 23 Jun 2020 11:09:42 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6E9C061755
        for <linux-efi@vger.kernel.org>; Tue, 23 Jun 2020 08:09:42 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed20:26:93a1:ff06:f8b0])
        by laurent.telenet-ops.be with bizsmtp
        id uf9h220034qCYS801f9hoj; Tue, 23 Jun 2020 17:09:41 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jnkYO-0007jy-TP; Tue, 23 Jun 2020 17:09:40 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jnkYO-0008Nr-Qd; Tue, 23 Jun 2020 17:09:40 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Ard Biesheuvel <ardb@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
Cc:     linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] efi/libstub: EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER should not default to yes
Date:   Tue, 23 Jun 2020 17:09:35 +0200
Message-Id: <20200623150935.32181-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER is deprecated, so it should not
be enabled by default.

In light of commit 4da0b2b7e67524cc ("efi/libstub: Re-enable command
line initrd loading for x86"), keep the default for X86.

Fixes: cf6b83664895a5c7 ("efi/libstub: Make initrd file loader configurable")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/firmware/efi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index e6fc022bc87e03ab..56055c61904e49f4 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -127,7 +127,7 @@ config EFI_ARMSTUB_DTB_LOADER
 config EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER
 	bool "Enable the command line initrd loader" if !X86
 	depends on EFI_STUB && (EFI_GENERIC_STUB || X86)
-	default y
+	default y if X86
 	help
 	  Select this config option to add support for the initrd= command
 	  line parameter, allowing an initrd that resides on the same volume
-- 
2.17.1

