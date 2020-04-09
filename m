Return-Path: <SRS0=7pYY=5Z=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C072C2BA2B
	for <linux-efi@archiver.kernel.org>; Thu,  9 Apr 2020 13:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2429520B1F
	for <linux-efi@archiver.kernel.org>; Thu,  9 Apr 2020 13:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586437499;
	bh=Ls1FByjaGoM039Qe5lBEXVKfmaYzJQyH1QArsy3/P9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JlmsZTWhpvd2dik0KDrBU8nzIOJOEn9E5tqNDBRRJFnQegvlAi54pff8ThaVI0cu6
	 5wr1LsMBMXbsUEoDOWDldY4LHV6T7yEgn6snLHaJr+Esd9nWt6aDAaligAbp7IygkM
	 ax9a9zj1SrlFXcKojasdmEKWfCM7gfOh5SGh2lSw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgDINE6 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgDINE5 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 9 Apr 2020 09:04:57 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C4B420A8B;
        Thu,  9 Apr 2020 13:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586437497;
        bh=Ls1FByjaGoM039Qe5lBEXVKfmaYzJQyH1QArsy3/P9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvYIreikvtFkV/KnHxIKCsbGz/OpFoNieDELpZ/M5Y5gZss9t0Bs5dZd3izlgb2Qm
         Ni3/JH8qX5J1w7RnZZnGofuz+CpllSdRRjmz3XlfoZ5QLpEnoYEleA37HCHdICkcyh
         3LJAR1ji609hDjdKRzLDYjYIb0nzYLWkcXKUlGXE=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>,
        Colin Ian King <colin.king@canonical.com>,
        Gary Lin <glin@suse.com>, Jiri Slaby <jslaby@suse.cz>,
        Sergey Shatunov <me@prok.pw>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 1/9] efi/cper: Use scnprintf() for avoiding potential buffer overflow
Date:   Thu,  9 Apr 2020 15:04:26 +0200
Message-Id: <20200409130434.6736-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200409130434.6736-1-ardb@kernel.org>
References: <20200409130434.6736-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20200311072145.5001-1-tiwai@suse.de
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/cper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index b1af0de2e100..9d2512913d25 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -101,7 +101,7 @@ void cper_print_bits(const char *pfx, unsigned int bits,
 		if (!len)
 			len = snprintf(buf, sizeof(buf), "%s%s", pfx, str);
 		else
-			len += snprintf(buf+len, sizeof(buf)-len, ", %s", str);
+			len += scnprintf(buf+len, sizeof(buf)-len, ", %s", str);
 	}
 	if (len)
 		printk("%s\n", buf);
-- 
2.17.1

