Return-Path: <SRS0=J2WW=4G=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470B3C34037
	for <linux-efi@archiver.kernel.org>; Tue, 18 Feb 2020 11:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18E4122527
	for <linux-efi@archiver.kernel.org>; Tue, 18 Feb 2020 11:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582025654;
	bh=AdgygElFjm+9+VrUlac437cYd/rQkrwPTj+u9i3/SSw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=L3h8+ShGdElAClOhBURQI7ndNTbIGSqwpwXbwF9aav8isQUNhPPGozW3TkycXk9zd
	 xNVmaumC0dSs25SK5CtAL8fRVCXablgV1dFP2FIiZnkhlgcx3xVzopZTesHvpEm/zD
	 bKW49tnMd5aDTs6x4KoEMOBMZjvrALaQtY0LBIFo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgBRLeN (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 18 Feb 2020 06:34:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgBRLeN (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 18 Feb 2020 06:34:13 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E75D121D56;
        Tue, 18 Feb 2020 11:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582025653;
        bh=AdgygElFjm+9+VrUlac437cYd/rQkrwPTj+u9i3/SSw=;
        h=From:To:Cc:Subject:Date:From;
        b=SE1sAy3CDFfufWhk8g9D3KU1M8JIQb7e3vt/C3wWuSkCDeWCBcu/Aqz9xvmSK/2Bm
         hzjaFn8ZepB6CGmDumIEYq1aI6ejIzHNqCGEqr/35jgOzj2WkPU3afk4ETjiJ9Zi5f
         Mqo33c+TL85bMcGGOrU2474Iq8ItVxsfpv5nMrOg=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, maz@kernel.org,
        ilias.apalodimas@linaro.org, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] efi/arm: work around missing cache maintenance in decompressor handover
Date:   Tue, 18 Feb 2020 12:34:05 +0100
Message-Id: <20200218113405.31342-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The EFI stub executes within the context of the zImage as it was
loaded by the firmware, which means it is treated as an ordinary
PE/COFF executable, which is loaded into memory, and cleaned to
the PoU to ensure that it can be executed safely while the MMU
and caches are on.

When the EFI stub hands over to the decompressor, we clean the caches
by set/way and disable the MMU and D-cache, to comply with the Linux
boot protocol for ARM. However, cache maintenance by set/way is not
sufficient to ensure that subsequent instruction fetches and data
accesses done with the MMU off see the correct data. This means that
proceeding as we do currently is not safe, especially since we also
perform data accesses with the MMU off, from a literal pool as well as
the stack.

So let's kick this can down the road a bit, and jump into the relocated
zImage before disabling the caches. This removes the requirement to
perform any by-VA cache maintenance on the original PE/COFF executable,
but it does require that the relocated zImage is cleaned to the PoC,
which is currently not the case. This will be addressed in a subsequent
patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/boot/compressed/head.S | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 088b0a060876..4010f6e4b047 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1458,6 +1458,18 @@ ENTRY(efi_stub_entry)
 		cmn	r0, #1
 		beq	efi_load_fail
 
+		@ The PE/COFF loader might not have cleaned the code we are
+		@ running beyond the PoU, and so calling cache_off below from
+		@ inside the PE/COFF loader allocated region is unsafe. Let's
+		@ assume our own zImage relocation code did a better job, and
+		@ jump into it before proceeding.
+		ldr	lr, [sp]			@ relocated zImage
+		ldr	ip, 0f
+		sub	lr, lr, ip
+		mov	pc, lr				@ no mode switch
+		.align	2
+0:		.long	start - (. + 4)
+
 		@ Preserve return value of efi_entry() in r4
 		mov	r4, r0
 		bl	cache_clean_flush
@@ -1469,12 +1481,7 @@ ENTRY(efi_stub_entry)
 		mov	r0, #0
 		mov	r1, #0xFFFFFFFF
 		mov	r2, r4
-
-		@ Branch to (possibly) relocated zImage that is in [sp]
-		ldr	lr, [sp]
-		ldr	ip, =start_offset
-		add	lr, lr, ip
-		mov	pc, lr				@ no mode switch
+		b	__efi_start
 
 efi_load_fail:
 		@ Return EFI_LOAD_ERROR to EFI firmware on error.
-- 
2.17.1

