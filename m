Return-Path: <SRS0=sYcs=EA=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8F7C55178
	for <linux-efi@archiver.kernel.org>; Sun, 25 Oct 2020 13:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C8C82225E
	for <linux-efi@archiver.kernel.org>; Sun, 25 Oct 2020 13:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414854AbgJYNtz (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 25 Oct 2020 09:49:55 -0400
Received: from foss.arm.com ([217.140.110.172]:46292 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1416426AbgJYNtz (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 25 Oct 2020 09:49:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BBB312FC;
        Sun, 25 Oct 2020 06:49:55 -0700 (PDT)
Received: from e123331-lin.nice.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E9543F68F;
        Sun, 25 Oct 2020 06:49:53 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@arm.com>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@arm.com>, grub-devel@gnu.org,
        daniel.kiper@oracle.com, leif@nuviainc.com
Subject: [PATCH v2 1/8] linux/arm: fix ARM Linux header layout
Date:   Sun, 25 Oct 2020 14:49:34 +0100
Message-Id: <20201025134941.4805-2-ard.biesheuvel@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201025134941.4805-1-ard.biesheuvel@arm.com>
References: <20201025134941.4805-1-ard.biesheuvel@arm.com>
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The hdr_offset member of the ARM Linux image header appears at
offset 0x3c, matching the PE/COFF spec's placement of the COFF
header offset in the MS-DOS header. We're currently off by four,
so fix that.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@arm.com>
---
 include/grub/arm/linux.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/grub/arm/linux.h b/include/grub/arm/linux.h
index 2e98a6689696..bcd5a7eb186e 100644
--- a/include/grub/arm/linux.h
+++ b/include/grub/arm/linux.h
@@ -30,7 +30,7 @@ struct linux_arm_kernel_header {
   grub_uint32_t magic;
   grub_uint32_t start; /* _start */
   grub_uint32_t end;   /* _edata */
-  grub_uint32_t reserved2[4];
+  grub_uint32_t reserved2[3];
   grub_uint32_t hdr_offset;
 };
 
-- 
2.17.1

