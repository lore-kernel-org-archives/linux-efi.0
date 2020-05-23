Return-Path: <SRS0=c6ga=7F=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9036C433E1
	for <linux-efi@archiver.kernel.org>; Sat, 23 May 2020 12:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F6AF207FB
	for <linux-efi@archiver.kernel.org>; Sat, 23 May 2020 12:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590235252;
	bh=hF++qON33FDEhXyfOJT5GlLwxjX0LMfIv3Aguj9zmVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bM5hoVs7nznhFR0BwCB3RZetja6B1z2MhAWphkxtGaJg8AJtgoyuHilD8vyV3GUaD
	 EefW2ngFIQ7R3ZnWuwiZnVWEAwrRQpCZ5RKx4HWSP4lvKXSnXSG/SXuYkJUzETSqxZ
	 WmeutL+3m+L+eA7lbi2yfOT/gvCUgWpUndt/vM2g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgEWMAl (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 23 May 2020 08:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728749AbgEWMAk (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sat, 23 May 2020 08:00:40 -0400
Received: from localhost.localdomain (82-64-249-211.subs.proxad.net [82.64.249.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9551720812;
        Sat, 23 May 2020 12:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590235240;
        bh=hF++qON33FDEhXyfOJT5GlLwxjX0LMfIv3Aguj9zmVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4vQgeI26LH6oA7w3U3atCFRouqfnq0TVguU+x+BFFwEbX2cKIaUIp+Im2HB0wnf3
         Gzr9jDQVVbGzozpYJnyrfPUE/NoM9pT5F2fSFZeyuEjcStFvFkGIym5T7fk1D/lGel
         cLmLWI8VA2D/Tf2pIeh/hAkttznd4iStuxr8pCCk=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: [PATCH v2 1/3] x86/boot/compressed: move .got.plt entries out of the .got section
Date:   Sat, 23 May 2020 14:00:19 +0200
Message-Id: <20200523120021.34996-2-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200523120021.34996-1-ardb@kernel.org>
References: <20200523120021.34996-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The .got.plt section contains the part of the GOT which is used by PLT
entries, and which gets updated lazily by the dynamic loader when
function calls are dispatched through those PLT entries.

On fully linked binaries such as the kernel proper or the decompressor,
this never happens, and so in practice, the .got.plt section consists
only of the first 3 magic entries that are meant to point at the _DYNAMIC
section and at the fixup routine in the loader. However, since we don't
use a dynamic loader, those entries are never populated or used.

This means that treating those entries like ordinary GOT entries, and
updating their values based on the actual placement of the executable in
memory is completely pointless, and we can just ignore the .got.plt
section entirely, provided that it has no additional entries beyond
the first 3 ones.

So add an assertion in the linker script to ensure that this assumption
holds, and move the contents out of the [_got, _egot) memory range that
is modified by the GOT fixup routines.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/boot/compressed/vmlinux.lds.S | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index 0dc5c2b9614b..ce3fdfb93b57 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -44,10 +44,13 @@ SECTIONS
 	}
 	.got : {
 		_got = .;
-		KEEP(*(.got.plt))
 		KEEP(*(.got))
 		_egot = .;
 	}
+	.got.plt : {
+		KEEP(*(.got.plt))
+	}
+
 	.data :	{
 		_data = . ;
 		*(.data)
@@ -75,3 +78,11 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);	/* keep ZO size page aligned */
 	_end = .;
 }
+
+#ifdef CONFIG_X86_64
+ASSERT (SIZEOF(.got.plt) == 0 || SIZEOF(.got.plt) == 0x18,
+	"Unexpected GOT/PLT entries detected!")
+#else
+ASSERT (SIZEOF(.got.plt) == 0 || SIZEOF(.got.plt) == 0xc,
+	"Unexpected GOT/PLT entries detected!")
+#endif
-- 
2.20.1

