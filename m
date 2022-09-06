Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9ADFC6FA91
	for <linux-efi@archiver.kernel.org>; Tue,  6 Sep 2022 10:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbiIFKmB (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 6 Sep 2022 06:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbiIFKl5 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 6 Sep 2022 06:41:57 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7217B5FF6B;
        Tue,  6 Sep 2022 03:41:47 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 107C4407625A;
        Tue,  6 Sep 2022 10:41:39 +0000 (UTC)
From:   Evgeniy Baskov <baskov@ispras.ru>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Evgeniy Baskov <baskov@ispras.ru>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 08/16] x86/boot: Remove mapping from page fault handler
Date:   Tue,  6 Sep 2022 13:41:12 +0300
Message-Id: <fae59721001d43db9a0ad2c9c09947284f1ecaa1.1662459668.git.baskov@ispras.ru>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1662459668.git.baskov@ispras.ru>
References: <cover.1662459668.git.baskov@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

After every implicit mapping is removed, this code is no longer needed.

Remove memory mapping from page fault handler to ensure that there are
no hidden invalid memory accesses.

Signed-off-by: Evgeniy Baskov <baskov@ispras.ru>
---
 arch/x86/boot/compressed/ident_map_64.c | 26 ++++++++++---------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index 880e08293023..c20cd31e665f 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -385,27 +385,21 @@ void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	unsigned long address = native_read_cr2();
 	unsigned long end;
-	bool ghcb_fault;
+	char *msg;
 
-	ghcb_fault = sev_es_check_ghcb_fault(address);
+	if (sev_es_check_ghcb_fault(address))
+		msg = "Page-fault on GHCB page:";
+	else
+		msg = "Unexpected page-fault:";
 
 	address   &= PMD_MASK;
 	end        = address + PMD_SIZE;
 
 	/*
-	 * Check for unexpected error codes. Unexpected are:
-	 *	- Faults on present pages
-	 *	- User faults
-	 *	- Reserved bits set
-	 */
-	if (error_code & (X86_PF_PROT | X86_PF_USER | X86_PF_RSVD))
-		do_pf_error("Unexpected page-fault:", error_code, address, regs->ip);
-	else if (ghcb_fault)
-		do_pf_error("Page-fault on GHCB page:", error_code, address, regs->ip);
-
-	/*
-	 * Error code is sane - now identity map the 2M region around
-	 * the faulting address.
+	 * Since all memory allocations are made explicit
+	 * now, every page fault at this stage is an
+	 * error and the error handler is there only
+	 * for debug purposes.
 	 */
-	kernel_add_identity_map(address, end, MAP_WRITE);
+	do_pf_error(msg, error_code, address, regs->ip);
 }
-- 
2.35.1

