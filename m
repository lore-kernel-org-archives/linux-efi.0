Return-Path: <SRS0=HfTe=2N=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A871DC2D0C0
	for <linux-efi@archiver.kernel.org>; Mon, 23 Dec 2019 15:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B98620709
	for <linux-efi@archiver.kernel.org>; Mon, 23 Dec 2019 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577114616;
	bh=osjy2qK69yjAAQdkQOcZUurhniBODraBI82bAEFIyn8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=c41LNDnvvYn3NHH7Ib2Wpwl+p+zfIB8+JRSHv6MDJZ4x8uIcOCbA4KZ9IvkogleOx
	 G3Usk3m1IlyRmx9WH1cfqRRZQAsuifHH4Q6MxAX3t4R3Mq97eMdcId+rKgM7Rhnj+1
	 77UpCE2pGzdADhzs1UqXWuSNxLYao9xOConT0Rfk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLWPXg (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 23 Dec 2019 10:23:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbfLWPXg (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 23 Dec 2019 10:23:36 -0500
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net [91.167.84.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81B96206B7;
        Mon, 23 Dec 2019 15:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577114615;
        bh=osjy2qK69yjAAQdkQOcZUurhniBODraBI82bAEFIyn8=;
        h=From:To:Cc:Subject:Date:From;
        b=Sxs2gqA0ysnUyc2tZNAT6pcJEGHisQ1/J9lvgm0gkNRmD5NnFd33V6Xr1ZzLL9/Nx
         etoOyRkhVWmJsgLHNfzuE1ilPm9Z4eM0oQ7D8BdQCPL3bH9QpczsV3EEAq1BNkZs+K
         e+lTDUUNsZWZvu0T/T8/y89gOnBVoRFUUObu9Wf4=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     hdegoede@redhat.com, x86@kernel.org, nivedita@alum.mit.edu,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] x86/efistub: disable paging at mixed mode entry
Date:   Mon, 23 Dec 2019 16:21:57 +0100
Message-Id: <20191223152157.68545-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The EFI mixed mode entry code goes through the ordinary startup_32()
routine before jumping into the kernel's EFI boot code in 64-bit
mode. The 32-bit startup code must be entered with paging disabled,
but this is not documented as a requirement for the EFI handover
protocol, and so we should disable paging explicitly when entering
the kernel from 32-bit EFI firmware.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/boot/compressed/head_64.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 58a512e33d8d..ee60b81944a7 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -244,6 +244,11 @@ SYM_FUNC_START(efi32_stub_entry)
 	leal	efi32_config(%ebp), %eax
 	movl	%eax, efi_config(%ebp)
 
+	/* Disable paging */
+	movl	%cr0, %eax
+	btrl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+
 	jmp	startup_32
 SYM_FUNC_END(efi32_stub_entry)
 #endif
-- 
2.20.1

