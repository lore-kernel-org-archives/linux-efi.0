Return-Path: <SRS0=zl8W=2Y=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA850C32767
	for <linux-efi@archiver.kernel.org>; Fri,  3 Jan 2020 11:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97D0221835
	for <linux-efi@archiver.kernel.org>; Fri,  3 Jan 2020 11:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578051674;
	bh=K/Vpxq9bymqTfdAJSTcXE+H+meoAXcrzQIb0UcJK45k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fGD94ZuIOTAXvpYuW621HIvYQsjV5t9XGutYGYoNpqjcDt8DYGtfDtSxCHo3hLk0i
	 7SRgMmAqvURXRBEvP518FAnqDa5L4lmJdB+uxTASPETugPG0ATcVPef8GM91DokBsT
	 0+0a5Y2gO17If2MzNCStGMDT0RluP0fv6qd7nhiI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgACLkp (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:40:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbgACLkp (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 3 Jan 2020 06:40:45 -0500
Received: from localhost.localdomain (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3638821D7D;
        Fri,  3 Jan 2020 11:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578051644;
        bh=K/Vpxq9bymqTfdAJSTcXE+H+meoAXcrzQIb0UcJK45k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfLUbEC7gpDcnJheUGq99EVH7M9j7DA3RyNKM8oqxvMnxY5FffMqqHm/BkDhLEG7p
         2+qSsROhTR+OiAyYWmCo58oU3mXfRHJoRChiavawTWBYqts8/m3oL3O7uekW+VJInI
         bDXDGOT9Q0fqQ210xVj7uYBHZiUTZJfYBSPewCQw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Matthew Garrett <mjg59@google.com>
Subject: [PATCH 14/20] efi/x86: remove unreachable code in kexec_enter_virtual_mode()
Date:   Fri,  3 Jan 2020 12:39:47 +0100
Message-Id: <20200103113953.9571-15-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200103113953.9571-1-ardb@kernel.org>
References: <20200103113953.9571-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Remove some code that is guaranteed to be unreachable, given
that we have already bailed by this time if EFI_OLD_MEMMAP is
set.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4f539bfdc051..b931c4bea284 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -850,9 +850,6 @@ static void __init kexec_enter_virtual_mode(void)
 	efi.runtime_version = efi_systab.hdr.revision;
 
 	efi_native_runtime_setup();
-
-	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
-		runtime_code_page_mkexec();
 #endif
 }
 
-- 
2.20.1

