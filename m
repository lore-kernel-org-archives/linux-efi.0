Return-Path: <SRS0=ZTBG=25=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DF1C00523
	for <linux-efi@archiver.kernel.org>; Wed,  8 Jan 2020 10:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAED12077B
	for <linux-efi@archiver.kernel.org>; Wed,  8 Jan 2020 10:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578478992;
	bh=wCfg2ssSFutFVGkbtoCVz2iPKb67wYGKG6IyCNR1lyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Mb/xL2mCLCVq/muzR8ZQsdAkHVwufADq/5i7b82FQluwnnaVb1xGK0q4YI5izYP5a
	 PLlm4+yodCLvl/dMqsZQwR2WRh48iGXQuD/brKvhUWiTr0JrB4m4RHgisrp/ohAy/d
	 hdXFbKIsh/bN2zwt3lZyzbEuDIkvV4iES9GJgdTY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgAHKXM (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 8 Jan 2020 05:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgAHKXM (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 8 Jan 2020 05:23:12 -0500
Received: from localhost.localdomain (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDA4A2082E;
        Wed,  8 Jan 2020 10:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578478991;
        bh=wCfg2ssSFutFVGkbtoCVz2iPKb67wYGKG6IyCNR1lyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qTg2IkYhepZw5OIwlGyLiL1eS1lQVkc5XJ2gP82L0KG5WHcG47/cHlVzaYzkKxYu
         VaUSbQxS8dPE9aZi/C+uZZI9dOHdutpN9FCHMc1aX7O+9icPM29hzhaJQmvEEDnOci
         c/K8+Fi/fIP8e1lUJK+/bD/N76vL5z+kKGHZz50Y=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     x86@kernel.org, luto@kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: [RFC PATCH 1/3] x86/boot/compressed: move .got.plt entries out of the .got section
Date:   Wed,  8 Jan 2020 11:23:02 +0100
Message-Id: <20200108102304.25800-2-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200108102304.25800-1-ardb@kernel.org>
References: <20200108102304.25800-1-ardb@kernel.org>
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
fixing them up based on the actual placement of the executable in
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
index 508cfa6828c5..51ca654e43a9 100644
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
@@ -74,3 +77,11 @@ SECTIONS
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

