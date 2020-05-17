Return-Path: <SRS0=jxMq=67=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A594C433E0
	for <linux-efi@archiver.kernel.org>; Sun, 17 May 2020 12:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA4F720801
	for <linux-efi@archiver.kernel.org>; Sun, 17 May 2020 12:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589720316;
	bh=odAfPtsXVyhUKaIWs8xG3NNQZw4n00GnkhpwXSmjrl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hP6+ki5AoYVGzbmqetnRICjG9KiRjyUYTikPAAxrcmYCS7k9+w9olGcvcsJSQUEae
	 bb42j7tC4oGhp/hv5jOLAsuyaObmXlAilt4ZBnn4yiyORakW2mBCN5YjjOiFBeaKME
	 9YX4LCLgDjdIH0B5z9MFr4utgPlSFUKws/IZypvo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgEQM6g (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 17 May 2020 08:58:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727896AbgEQM6g (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 17 May 2020 08:58:36 -0400
Received: from e123331-lin.nice.arm.com (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72BCA20735;
        Sun, 17 May 2020 12:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589720315;
        bh=odAfPtsXVyhUKaIWs8xG3NNQZw4n00GnkhpwXSmjrl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjwPl3SYEAwfMt+cSUaQAii7yrGd1L1dlu1N26KDnUMy0VKVEm8I79TubxBZrNMmE
         EJ97dNX+z3Io5tjQ48fk9E18hVtIsgnHSbRAskh6zxjUw9rAfOiBXG0brkVuxWGRMN
         xyr0KlHA6hxfMRN3IcAAoyoVgdOvep9k1kQjBdsA=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        linux-acpi@vger.kernel.org, Loic Yhuel <loic.yhuel@gmail.com>,
        Matthew Garrett <mjg59@google.com>,
        Mike Lothian <mike@fireburn.co.uk>,
        Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Subject: [PATCH 1/7] efi/libstub: Avoid returning uninitialized data from setup_graphics()
Date:   Sun, 17 May 2020 14:57:48 +0200
Message-Id: <20200517125754.8934-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200517125754.8934-1-ardb@kernel.org>
References: <20200517125754.8934-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

Currently, setup_graphics() ignores the return value of efi_setup_gop(). As
AllocatePool() does not zero out memory, the screen information table will
contain uninitialized data in this case.

We should free the screen information table if efi_setup_gop() returns an
error code.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Link: https://lore.kernel.org/r/20200426194946.112768-1-xypron.glpk@gmx.de
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/arm-stub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 99a5cde7c2d8..48161b1dd098 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -60,7 +60,11 @@ static struct screen_info *setup_graphics(void)
 		si = alloc_screen_info();
 		if (!si)
 			return NULL;
-		efi_setup_gop(si, &gop_proto, size);
+		status = efi_setup_gop(si, &gop_proto, size);
+		if (status != EFI_SUCCESS) {
+			free_screen_info(si);
+			return NULL;
+		}
 	}
 	return si;
 }
-- 
2.17.1

