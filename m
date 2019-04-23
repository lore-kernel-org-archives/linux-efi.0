Return-Path: <SRS0=iU5o=SZ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91368C282DD
	for <linux-efi@archiver.kernel.org>; Tue, 23 Apr 2019 14:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CF6A20645
	for <linux-efi@archiver.kernel.org>; Tue, 23 Apr 2019 14:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ulUfY9r4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbfDWOoF (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 23 Apr 2019 10:44:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33143 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfDWOoF (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 23 Apr 2019 10:44:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id a3so10947938wrx.0
        for <linux-efi@vger.kernel.org>; Tue, 23 Apr 2019 07:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ih4Kk3hTtclVMFJNHRQHC+YkLSTBqasBZplEu0qiFHA=;
        b=ulUfY9r4XZ2GUqlae4Bc21zayXmiSveLZvRCYu1CAsEIBDasKfwS4vfJ5Om8TDCCPQ
         VT6I/7WRyU3sdLANSA07aCPS8sh4rT+ABOnHGOOW2iqDFqIfBS7ESzE+18YqQGE8PkRh
         zoTm0B/N+NipFko5kA9oXXIJnNpWtN9r7Lo4p5159lFvOGff2a2Dij4gZ0riUzuk9KeS
         U/8NPk0F8o+qseS4kIKZIWyZdhSyeDf4dIzLjRb/vmgv8Zw/vFTbmBxIYR434S5/KfzR
         gkV9/92VpEWvHDD4TIxSui8YPjyl5/Ql4ag8aZyaHo1eRC1YqzuaKdCt2+LQ9hlfoE1I
         Yg5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ih4Kk3hTtclVMFJNHRQHC+YkLSTBqasBZplEu0qiFHA=;
        b=ma+U1tGl5xZBro3IZ4fm5Cn+G0dVagkCm3p1rEZt4syG6UnU4ab+ZFm1k/aLuW/kp8
         oPA2fq6+knOPjzBR4/MrWtj2HJNmmNTNfySIJ1JenXVpaVlo7kff8tog2h9kX3CGU1pU
         d1EjZBhSjHhtZG+fYmS1vZgXfNF9Iq4qTHthUSyvn47Tu39MPPgQrC5Oe2D/oNUvdO6Y
         IXlRAEV/djojQNny8QgnexUP6GM3hi2cdGC4zxd3e4FLuCI0Fgz+5UG9cKQ3n6I7bxN7
         tmt+SDoYSdBC9EBXNn4etTuuuEkYZkCO2SkYbNIDpD49WyWMoElJLp2jBBIcOf5uT0YZ
         Ufig==
X-Gm-Message-State: APjAAAVw+I73mz7js7AL762Yvk0HJcSc/Xoj/JRxnflQch3qY2eOZFGp
        pL/Q9orMr/aYLpjLEelpsXJPlm0+fZquFg==
X-Google-Smtp-Source: APXvYqy1sMo3LgCEmQVpXax70x5q2bBzIjHJ/Rvt1X3T3qQZL1gaIjCACFiI0cN9dEh9rPIUvD9oBw==
X-Received: by 2002:a5d:6947:: with SMTP id r7mr16598459wrw.167.1556030643585;
        Tue, 23 Apr 2019 07:44:03 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z10sm13932496wmi.15.2019.04.23.07.44.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 07:44:02 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-efi@vger.kernel.org
Cc:     mingo@kernel.org, pjones@redhat.com, b.zolnierkie@samsung.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        James Hilliard <james.hilliard1@gmail.com>
Subject: [PATCH] fbdev/efifb: ignore framebuffer memmap entries that lack any memory types
Date:   Tue, 23 Apr 2019 16:43:54 +0200
Message-Id: <20190423144354.3465-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Commit 38ac0287b7f4

  ("fbdev/efifb: Honour UEFI memory map attributes when mapping the FB")

updated the EFI framebuffer code to use memory mappings for the linear
framebuffer that are permitted by the memory attributes described by the
EFI memory map for the particular region, if the framebuffer happens to
be covered by the EFI memory map (which is typically only the case for
framebuffers in shared memory). This is required since non-X86 systems
may require cacheable attributes for memory mappings that are shared
with other masters (such as GPUs), and this information cannot be
described by the Graphics Output Protocol (GOP) EFI protocol itself,
and so we rely on the EFI memory map for this.

As reported by James, this breaks some x86 systems:

  [ 1.173368] efifb: probing for efifb
  [ 1.173386] efifb: abort, cannot remap video memory 0x1d5000 @ 0xcf800000
  [ 1.173395] Trying to free nonexistent resource <00000000cf800000-00000000cf9d4bff>
  [ 1.173413] efi-framebuffer: probe of efi-framebuffer.0 failed with error -5

The problem turns out to be that the memory map entry that describes the
framebuffer has no memory attributes listed at all, and so we end up with
a mem_flags value of 0x0.

So work around this by ensuring that the memory map entry's attribute field
has a sane value before using it to mask the set of usable attributes.

Reported-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

James, could you give this a try please? Thanks.

 drivers/video/fbdev/efifb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index ba906876cc45..1f9949f50900 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -476,8 +476,11 @@ static int efifb_probe(struct platform_device *dev)
 		 * If the UEFI memory map covers the efifb region, we may only
 		 * remap it using the attributes the memory map prescribes.
 		 */
-		mem_flags |= EFI_MEMORY_WT | EFI_MEMORY_WB;
-		mem_flags &= md.attribute;
+		md.attribute &= EFI_MEMORY_WC | EFI_MEMORY_WT | EFI_MEMORY_WB;
+		if (md.attribute) {
+			mem_flags |= EFI_MEMORY_WT | EFI_MEMORY_WB;
+			mem_flags &= md.attribute;
+		}
 	}
 	if (mem_flags & EFI_MEMORY_WC)
 		info->screen_base = ioremap_wc(efifb_fix.smem_start,
-- 
2.20.1

