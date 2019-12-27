Return-Path: <SRS0=vIKq=2R=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735B3C2D0CE
	for <linux-efi@archiver.kernel.org>; Fri, 27 Dec 2019 17:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47F96206F4
	for <linux-efi@archiver.kernel.org>; Fri, 27 Dec 2019 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577469494;
	bh=k/2SQb0Wyh2q7lBsIGnPkNgrKZoK4ytmvHItYS6lE+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HFOZ5WRRJ8yjnR08PCMriS3/RODIfEhWRNSI1jW6SsPtFrcbNutMSNtol3IZFS9kj
	 H8+d2tDKpnjwvAfHp1ggwRoE3VOKYtNfMhC1PMk+Ucf31v2ByuBlu5CYemIhZZseqh
	 5D9Qr34aHxbCNHwzrYyOVA5mX58ggZDyPRkUX/ck=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfL0Rlc (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 27 Dec 2019 12:41:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbfL0Rlb (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 102A221775;
        Fri, 27 Dec 2019 17:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468491;
        bh=k/2SQb0Wyh2q7lBsIGnPkNgrKZoK4ytmvHItYS6lE+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riXWrw3NrCgeJn8Hq3myDbh2TH3g0mvnyUDtaKH14c1VEqL6Xo0rpTz72ggq7sv2Z
         8ROb0bZloKLcnjGTpH7w9VE8SmetrNiPdH72edpZcPd9NIdMrlsvDknXT8SsXq19/r
         vD05OlvgJz4lVwBXnr18lFH/hUaByQk6yDwjjmGQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 027/187] efi/gop: Return EFI_SUCCESS if a usable GOP was found
Date:   Fri, 27 Dec 2019 12:38:15 -0500
Message-Id: <20191227174055.4923-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit dbd89c303b4420f6cdb689fd398349fc83b059dd ]

If we've found a usable instance of the Graphics Output Protocol
(GOP) with a framebuffer, it is possible that one of the later EFI
calls fails while checking if any support console output. In this
case status may be an EFI error code even though we found a usable
GOP.

Fix this by explicitly return EFI_SUCCESS if a usable GOP has been
located.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: linux-efi@vger.kernel.org
Link: https://lkml.kernel.org/r/20191206165542.31469-4-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/gop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index 08f3c1a2fb48..69b2b019a1d0 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -198,7 +198,7 @@ setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
 
 	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
 
-	return status;
+	return EFI_SUCCESS;
 }
 
 static efi_status_t
@@ -316,7 +316,7 @@ setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
 
 	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
 
-	return status;
+	return EFI_SUCCESS;
 }
 
 /*
-- 
2.20.1

