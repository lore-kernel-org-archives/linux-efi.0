Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC20C6FA83
	for <linux-efi@archiver.kernel.org>; Tue,  6 Sep 2022 10:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239358AbiIFKl6 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 6 Sep 2022 06:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbiIFKlp (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 6 Sep 2022 06:41:45 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5E85F135;
        Tue,  6 Sep 2022 03:41:43 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 352AB407624D;
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
Subject: [PATCH 01/16] x86/boot: Align vmlinuz sections on page size
Date:   Tue,  6 Sep 2022 13:41:05 +0300
Message-Id: <27a078f43742063cc30e706b196fb5fff5d5c37e.1662459668.git.baskov@ispras.ru>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1662459668.git.baskov@ispras.ru>
References: <cover.1662459668.git.baskov@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

To protect sections on page table level each section
needs to be aligned on page size (4KB).

Set sections alignment in linker script.

Signed-off-by: Evgeniy Baskov <baskov@ispras.ru>
---
 arch/x86/boot/compressed/vmlinux.lds.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index 112b2375d021..6be90f1a1198 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -27,21 +27,27 @@ SECTIONS
 		HEAD_TEXT
 		_ehead = . ;
 	}
+	. = ALIGN(PAGE_SIZE);
 	.rodata..compressed : {
+		_compressed = .;
 		*(.rodata..compressed)
+		_ecompressed = .;
 	}
+	. = ALIGN(PAGE_SIZE);
 	.text :	{
 		_text = .; 	/* Text */
 		*(.text)
 		*(.text.*)
 		_etext = . ;
 	}
+	. = ALIGN(PAGE_SIZE);
 	.rodata : {
 		_rodata = . ;
 		*(.rodata)	 /* read-only data */
 		*(.rodata.*)
 		_erodata = . ;
 	}
+	. = ALIGN(PAGE_SIZE);
 	.data :	{
 		_data = . ;
 		*(.data)
-- 
2.35.1

