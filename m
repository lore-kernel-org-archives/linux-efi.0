Return-Path: <SRS0=vIKq=2R=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8B9C2D0C6
	for <linux-efi@archiver.kernel.org>; Fri, 27 Dec 2019 16:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 971C721582
	for <linux-efi@archiver.kernel.org>; Fri, 27 Dec 2019 16:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577464458;
	bh=6nSUzSgrpfankKJ5wIiQWPhA/Ug4dMl2yJTJv9+a3BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=w2Kv3yKE0gYau8Ma5iMesUT27O3s/PDCNRWhEQpFpt0e8WTU8/p5i4H3a+sQuenyq
	 HB8rB/njhBgLYo2G9ZwA0mS/sN79rGQ2sWiL4kCF3scOhv7BlMJpVUEw1XdRq78qE+
	 qGzTV5vIqwlhzrC3U0pFaqR7SAGtlfxGew5Ds7Zo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfL0QeS (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 27 Dec 2019 11:34:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfL0QeS (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 27 Dec 2019 11:34:18 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 571A020CC7;
        Fri, 27 Dec 2019 16:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577464457;
        bh=6nSUzSgrpfankKJ5wIiQWPhA/Ug4dMl2yJTJv9+a3BI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IL9a3t2Q1yGElpZxUs2g0MvfBNmjgs5ViH3pR9HE+E2qaP9l+mdYmWiv+wlBgG70W
         hZnjXENgDsLb2o0d7ZYp+fyeRf6qAX9mCejijbGba8dJ+TrsHvgcZaPlr0pWg+GOVi
         tCiJ25VckLOwBlBH0JX8t2ppdKd4lAQf2OFYkpBQ=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     nivedita@alum.mit.edu, hdegoede@redhat.com,
        Ard Biesheuvel <ardb@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/3] efi/x86: don't map the entire kernel text RW for mixed mode
Date:   Fri, 27 Dec 2019 17:34:17 +0100
Message-Id: <20191227163418.16139-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227163418.16139-1-ardb@kernel.org>
References: <20191227163418.16139-1-ardb@kernel.org>
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
index 5cb081107d10..9e9a4b31f74b 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -402,11 +402,11 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	efi_scratch.phys_stack = virt_to_phys(page_address(page));
 	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
 
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
2.17.1

