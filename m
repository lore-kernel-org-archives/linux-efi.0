Return-Path: <SRS0=Hy2n=2U=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5941BC2D0C2
	for <linux-efi@archiver.kernel.org>; Mon, 30 Dec 2019 18:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26B8F20722
	for <linux-efi@archiver.kernel.org>; Mon, 30 Dec 2019 18:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577729386;
	bh=K/Vpxq9bymqTfdAJSTcXE+H+meoAXcrzQIb0UcJK45k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FB1PtTz1HIaRfKSfJHbVvxjhhky0mFuATYFK9pIKjlNEV0erATaWEsVR5I0sXxh4V
	 XzEZ75DsE1kmI7iniFK0Z6j9SNn3v2tpbTkvg5Rn9m2X56oTXUp4ByeqyiIq1QmRYu
	 JvevpIpTxc+1HR/8Omq7XtkpgExXHFLYJbjekrtQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfL3SJp (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 30 Dec 2019 13:09:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727635AbfL3SJp (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 30 Dec 2019 13:09:45 -0500
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net [91.167.84.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F23632071E;
        Mon, 30 Dec 2019 18:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577729385;
        bh=K/Vpxq9bymqTfdAJSTcXE+H+meoAXcrzQIb0UcJK45k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i59sWrsdL3IErTkDPiV9UQfrLazzYZRrSHnalAw7nwWSwW7kJ6blbtPaWQHVKgacM
         kRTrn+ptM1tBdAiUfcK3+BcQBCiiqdDSOiVJiIArDPpYih1mx6DvleYNH8Z7avmRMN
         VcMCHI4O0hRUDPVDkjGz7kt8NH36hSOOm83+D+zY=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 14/14] efi/x86: remove unreachable code in kexec_enter_virtual_mode()
Date:   Mon, 30 Dec 2019 19:08:34 +0100
Message-Id: <20191230180834.75601-15-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191230180834.75601-1-ardb@kernel.org>
References: <20191230180834.75601-1-ardb@kernel.org>
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

