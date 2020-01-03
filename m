Return-Path: <SRS0=zl8W=2Y=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A822CC3F68F
	for <linux-efi@archiver.kernel.org>; Fri,  3 Jan 2020 11:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 730EA2464B
	for <linux-efi@archiver.kernel.org>; Fri,  3 Jan 2020 11:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578051666;
	bh=f7ymohb97S6b58KJNRXy0ZTCMS6AMDRFCM6vKzcZbSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eCBlSajAplGsqyOqyEymShERGHGQUPWEUqXjL/N5azltyxusE4agNt2bAP1192O+q
	 oK6cSpb0oRMzhGOepVGANuZAfL9QLyPeKWH0W0ZczVmT3bbZ1fyx+KXTSN7SuZZg0O
	 xzMjzG2fBAG21fuifvnpo3fyMFrJVoX0hKsHImRE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgACLk5 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:40:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727890AbgACLk4 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 3 Jan 2020 06:40:56 -0500
Received: from localhost.localdomain (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF79824653;
        Fri,  3 Jan 2020 11:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578051655;
        bh=f7ymohb97S6b58KJNRXy0ZTCMS6AMDRFCM6vKzcZbSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bn/D8MffaovgfJrEgBR2/9qNzhjo27d/6t/OQ9z/zdLOm7PGiphRgUkP6ofpL0ZVd
         ZyL8zKpKiJnh0xix0u+tOhxRAtnrlPAPFiU4tyDIfEMacQZnJGcSIXyzMFMMCHU+dD
         7TA9cBVdwd0ZyGgfaWcC8Zov07IJBQS2fq9Xf38A=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Matthew Garrett <mjg59@google.com>
Subject: [PATCH 19/20] efi/x86: don't map the entire kernel text RW for mixed mode
Date:   Fri,  3 Jan 2020 12:39:52 +0100
Message-Id: <20200103113953.9571-20-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200103113953.9571-1-ardb@kernel.org>
References: <20200103113953.9571-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The mixed mode thunking routine requires a part of it to be
mapped 1:1, and for this reason, we currently map the entire
kernel .text read/write in the EFI page tables, which is bad.

In fact, the kernel_map_pages_in_pgd() invocation that installs
this mapping is entirely redundant, since all of DRAM is already
1:1 mapped read/write in the EFI page tables when we reach this
point, which means that .rodata is mapped read-write as well.

So let's remap both .text and .rodata read-only in the EFI
page tables.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index c13fa2150976..6ec58ff60b56 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -391,11 +391,11 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 
 	efi_scratch.phys_stack = page_to_phys(page + 1); /* stack grows down */
 
-	npages = (_etext - _text) >> PAGE_SHIFT;
+	npages = (__end_rodata_aligned - _text) >> PAGE_SHIFT;
 	text = __pa(_text);
 	pfn = text >> PAGE_SHIFT;
 
-	pf = _PAGE_RW | _PAGE_ENC;
+	pf = _PAGE_ENC;
 	if (kernel_map_pages_in_pgd(pgd, pfn, text, npages, pf)) {
 		pr_err("Failed to map kernel text 1:1\n");
 		return 1;
-- 
2.20.1

