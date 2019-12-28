Return-Path: <SRS0=sq0l=2S=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5558C2D0C6
	for <linux-efi@archiver.kernel.org>; Sat, 28 Dec 2019 15:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B304520838
	for <linux-efi@archiver.kernel.org>; Sat, 28 Dec 2019 15:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577546520;
	bh=nJer2+812w4RtPEumPeee6j1q7ehNNTgsktiTu+P4h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=S9lvZZd1Ce/rwZTdTbusIgaemBQfqdi2jtkPV7vzLDb5W1lz0p9mEi9tEU10vnFa4
	 ZI47AYit4SE8bSz6O42fxvL+3c2Y/arWkfjryYTf12Agn/dHyg00d8dr1f0j2mc4Mh
	 w+TPVQgsW5YmRk81rGgAUDnhCYTClZolGPJTNRow=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfL1PWA (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 28 Dec 2019 10:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:32990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfL1PWA (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sat, 28 Dec 2019 10:22:00 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3202F2168B;
        Sat, 28 Dec 2019 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577546519;
        bh=nJer2+812w4RtPEumPeee6j1q7ehNNTgsktiTu+P4h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZCKY8U/Q9pF4EHC7alBIZr7hO22reqpFWI6LGRb1erMCgDI3I+YTtThuodLI4Z+X
         i0WpJXLNvpL9bjpqoD20WEdcQE8y4vdoO3TRM+vjwGu9jxCMIKfqqULO6vuxW0ZTqe
         7ODl5nL5hqWmd2GDP0w2GrpxVLQ35IYCSKzPGXt8=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4/7] efi/x86: map the entire EFI vendor string before copying it
Date:   Sat, 28 Dec 2019 16:21:06 +0100
Message-Id: <20191228152109.6301-5-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191228152109.6301-1-ardb@kernel.org>
References: <20191228152109.6301-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Fix a couple of issues with the way we map and copy the vendor string:
- we map only 2 bytes, which usually works since you get at least a
  page, but if the vendor string happens to cross a page boundary,
  a crash will result
- only call early_memunmap() if early_memremap() succeeded, or we will
  call it with a NULL address which it doesn't like,
- while at it, switch to early_memremap_ro(), and array indexing rather
  than pointer dereferencing to read the CHAR16 characters.

Fixes: 5b83683f32b1 ("x86: EFI runtime service support")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d96953d9d4e7..3ce32c31bb61 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -541,7 +541,6 @@ void __init efi_init(void)
 	efi_char16_t *c16;
 	char vendor[100] = "unknown";
 	int i = 0;
-	void *tmp;
 
 #ifdef CONFIG_X86_32
 	if (boot_params.efi_info.efi_systab_hi ||
@@ -566,14 +565,16 @@ void __init efi_init(void)
 	/*
 	 * Show what we know for posterity
 	 */
-	c16 = tmp = early_memremap(efi.systab->fw_vendor, 2);
+	c16 = early_memremap_ro(efi.systab->fw_vendor,
+				sizeof(vendor) * sizeof(efi_char16_t));
 	if (c16) {
-		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
-			vendor[i] = *c16++;
+		for (i = 0; i < sizeof(vendor) - 1 && c16[i]; ++i)
+			vendor[i] = c16[i];
 		vendor[i] = '\0';
-	} else
+		early_memunmap(c16, sizeof(vendor) * sizeof(efi_char16_t));
+	} else {
 		pr_err("Could not map the firmware vendor!\n");
-	early_memunmap(tmp, 2);
+	}
 
 	pr_info("EFI v%u.%.02u by %s\n",
 		efi.systab->hdr.revision >> 16,
-- 
2.17.1

