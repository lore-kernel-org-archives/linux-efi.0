Return-Path: <SRS0=ukhU=5L=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0330AC43331
	for <linux-efi@archiver.kernel.org>; Thu, 26 Mar 2020 13:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4D2F206E6
	for <linux-efi@archiver.kernel.org>; Thu, 26 Mar 2020 13:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="TQsKFk1d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgCZNuw (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 26 Mar 2020 09:50:52 -0400
Received: from mout01.posteo.de ([185.67.36.65]:59961 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727593AbgCZNuw (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 26 Mar 2020 09:50:52 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id BDFE2160062
        for <linux-efi@vger.kernel.org>; Thu, 26 Mar 2020 14:50:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1585230649; bh=Wfwb5J/Q7BKagPRQW/+SJSL7f1pRtVAwrIOlSaoPic4=;
        h=From:To:Cc:Subject:Date:From;
        b=TQsKFk1dQ8TG7b2Jp0Unw4jhQZuxdPB2ykyuzvMOl1U9vnyrtXgdEUz8cg2PR3Buk
         IwcZbFIVmXxqTy1kacoMjg519JGhWjqQ7NKJkAgmJ3WkmBTp+ZcMUSk2YPtW+b/E28
         yjU2VBqrPeOXix/nRHt7bbFV8Vn01ZwWrbQ+aTVRB0vrQ4NXjh3Z4nei0+b6edklVy
         Df2kSXEUn7gcVPyLGRmanN1tslL3hkYw1NNJkONVCOqgp9mTayipngTU06U3NLzeG0
         PMNzM0xDX3BkJo3e7xlsUDp6LiyLlPAY8Q3HJLyf6F6PZjxjlnrxTJJsoKyCDGacPA
         LsrBChN5kMuJQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 48p5wn19bbz6tmJ;
        Thu, 26 Mar 2020 14:50:49 +0100 (CET)
From:   Benjamin Thiel <b.thiel@posteo.de>
To:     X86 ML <x86@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        Benjamin Thiel <b.thiel@posteo.de>
Subject: [PATCH] x86/efi: Add a prototype for efi_arch_mem_reserve()
Date:   Thu, 26 Mar 2020 14:50:41 +0100
Message-Id: <20200326135041.3264-1-b.thiel@posteo.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

... in order to fix a -Wmissing-ptototypes warning:

arch/x86/platform/efi/quirks.c:245:13: warning:
no previous prototype for ‘efi_arch_mem_reserve’ [-Wmissing-prototypes]
void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)

Signed-off-by: Benjamin Thiel <b.thiel@posteo.de>
---
 include/linux/efi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 7efd7072cca5..e4b28ae1ba61 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1703,4 +1703,6 @@ struct linux_efi_memreserve {
 
 void efi_pci_disable_bridge_busmaster(void);
 
+void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
+
 #endif /* _LINUX_EFI_H */
-- 
2.17.1

