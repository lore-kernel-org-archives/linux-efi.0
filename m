Return-Path: <SRS0=ZTBG=25=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62C9C33C9E
	for <linux-efi@archiver.kernel.org>; Wed,  8 Jan 2020 10:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADFC12075D
	for <linux-efi@archiver.kernel.org>; Wed,  8 Jan 2020 10:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578478997;
	bh=850Gzv2RRXpgVvFLdzqsajavn+oWE12MwONFtdvvECw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gfiaWjrRXpi2s41XZR2A1Im90tpsAXvhCeaXWOFk1znPfwdlyXftYFB0HO+oAJtIt
	 IimGXsXOOLFJMz0h7OpvSI8lXcC1QUHr/UI4mfbPrXmeL8MD3bDlKBwSLzCvEYv+eN
	 HmvflWDx/9bmXqgz5vYmdN076IDEdkcnTG9tM6rs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgAHKXO (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 8 Jan 2020 05:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgAHKXO (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 8 Jan 2020 05:23:14 -0500
Received: from localhost.localdomain (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF31920848;
        Wed,  8 Jan 2020 10:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578478993;
        bh=850Gzv2RRXpgVvFLdzqsajavn+oWE12MwONFtdvvECw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJEGpOQLTCzYG3nGEE7oplTGup89llsZJf0KbfrRxSy77gQYKbM77EGogPfxd1zgs
         mOngeFn/rJHEl5A4n6iy7mKH7u9DETeHTrtd9A75J1AgaR5xu8LsfXosTsX0VL1e+V
         baHkUx5WR1qZW7t1SYOklHglPSXg2HSqpBsIhbkI=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     x86@kernel.org, luto@kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: [RFC PATCH 2/3] x86/boot/compressed: force hidden visibility for all symbol references
Date:   Wed,  8 Jan 2020 11:23:03 +0100
Message-Id: <20200108102304.25800-3-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200108102304.25800-1-ardb@kernel.org>
References: <20200108102304.25800-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Eliminate all GOT entries in the decompressor binary, by forcing hidden
visibility for all symbol references, which informs the compiler that
such references will be resolved at link time without the need for
allocating GOT entries.

To ensure that no GOT entries will creep back in, add an assertion to
the decompressor linker script that will fire if the .got section has
a non-zero size.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/boot/compressed/Makefile      |  1 +
 arch/x86/boot/compressed/hidden.h      | 19 +++++++++++++++++++
 arch/x86/boot/compressed/vmlinux.lds.S |  1 +
 3 files changed, 21 insertions(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 56aa5fa0a66b..361df91b2288 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -39,6 +39,7 @@ KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)
 KBUILD_CFLAGS += $(call cc-disable-warning, gnu)
 KBUILD_CFLAGS += -Wno-pointer-sign
 KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
+KBUILD_CFLAGS += -include hidden.h
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
diff --git a/arch/x86/boot/compressed/hidden.h b/arch/x86/boot/compressed/hidden.h
new file mode 100644
index 000000000000..2a1693373cc7
--- /dev/null
+++ b/arch/x86/boot/compressed/hidden.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * When building position independent code with GCC using the -fPIC option,
+ * (or even the -fPIE one on older versions), it will assume that we are
+ * building a dynamic object (either a shared library or an executable) that
+ * may have symbol references that can only be resolved at load time. For a
+ * variety of reasons (ELF symbol preemption, the CoW footprint of the section
+ * that is modified by the loader), this results in all references to symbols
+ * with external linkage to go via entries in the Global Offset Table (GOT),
+ * which carries absolute addresses which need to be fixed up when the
+ * executable image is loaded at an offset which is different from its link
+ * time offset.
+ *
+ * Fortunately, there is a way to inform the compiler that such symbol
+ * references will be satisfied at link time rather than at load time, by
+ * giving them 'hidden' visibility.
+ */
+
+#pragma GCC visibility push(hidden)
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index 51ca654e43a9..955496ff2fcd 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -78,6 +78,7 @@ SECTIONS
 	_end = .;
 }
 
+ASSERT (SIZEOF(.got) == 0, "Unexpected GOT entries detected!")
 #ifdef CONFIG_X86_64
 ASSERT (SIZEOF(.got.plt) == 0 || SIZEOF(.got.plt) == 0x18,
 	"Unexpected GOT/PLT entries detected!")
-- 
2.20.1

