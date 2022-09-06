Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0EFECAAA1
	for <linux-efi@archiver.kernel.org>; Tue,  6 Sep 2022 10:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbiIFKl7 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 6 Sep 2022 06:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbiIFKlp (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 6 Sep 2022 06:41:45 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1285F9B9;
        Tue,  6 Sep 2022 03:41:43 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 784744076251;
        Tue,  6 Sep 2022 10:41:38 +0000 (UTC)
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
Subject: [PATCH 03/16] x86/boot: Set cr0 to known state in trampoline
Date:   Tue,  6 Sep 2022 13:41:07 +0300
Message-Id: <a155c20eec6343d34b3bdf40c024ce8b35a90e02.1662459668.git.baskov@ispras.ru>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1662459668.git.baskov@ispras.ru>
References: <cover.1662459668.git.baskov@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Ensure WP bit to be set to prevent boot code from writing to
non-writable memory pages.

Signed-off-by: Evgeniy Baskov <baskov@ispras.ru>
---
 arch/x86/boot/compressed/head_64.S | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index d33f060900d2..5273367283b7 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -619,9 +619,8 @@ SYM_CODE_START(trampoline_32bit_src)
 	/* Set up new stack */
 	leal	TRAMPOLINE_32BIT_STACK_END(%ecx), %esp
 
-	/* Disable paging */
-	movl	%cr0, %eax
-	btrl	$X86_CR0_PG_BIT, %eax
+	/* Disable paging and setup CR0 */
+	movl	$(CR0_STATE & ~X86_CR0_PG), %eax
 	movl	%eax, %cr0
 
 	/* Check what paging mode we want to be in after the trampoline */
-- 
2.35.1

