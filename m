Return-Path: <SRS0=Hy2n=2U=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAEEC2D0C2
	for <linux-efi@archiver.kernel.org>; Mon, 30 Dec 2019 18:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BABBB20748
	for <linux-efi@archiver.kernel.org>; Mon, 30 Dec 2019 18:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577729365;
	bh=CnPi0Fo3fyHi96VWGOpwo+ck2sY8c64d064M6vJyMy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ugX+BJkiby/dfe6gUqrrE6Qh8JamCGQo8/FrzkI5A1wVjI7pQDN+APKInlIghSeUL
	 N49759CetaryUowY6EaeV1LTRb8wpwT/H7Q+Dln8GXsnUl7TZz+VjdQkY/YQutDo0u
	 YGz9U80u29eOZpnMti4OTJdFMpnFh5UKKxZpBP8E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfL3SJZ (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 30 Dec 2019 13:09:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbfL3SJZ (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 30 Dec 2019 13:09:25 -0500
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net [91.167.84.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7EFF20722;
        Mon, 30 Dec 2019 18:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577729365;
        bh=CnPi0Fo3fyHi96VWGOpwo+ck2sY8c64d064M6vJyMy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jsFZG0QcCiEilwATZ7ENhUQinAFwlU2k2IiGzbxjW5PcmVyQSd5Ow6NXjQMGmNSX
         Detu64E9YCLApOzcP0ZoNz5mWJwm+lyMJ7kuJpk9gvEtIbnDKEFmeWQqY8LPETESws
         jM5+hLNlCcgb6BiTlSAKnj2O2ELsNigpfJ9R1s3k=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 02/14] efi/libstub: use correct system table pointer in mixed mode efi_free()
Date:   Mon, 30 Dec 2019 19:08:22 +0100
Message-Id: <20191230180834.75601-3-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191230180834.75601-1-ardb@kernel.org>
References: <20191230180834.75601-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

There is a special implementation for mixed mode of the efi_free()
function, to work around the incompatibility of the mixed mode
plumbing with the prototype of the EFI FreePages boot service,
which takes a 64-bit physical address as its first argument.

Calling FreePages in mixed mode involves passing the mixed mode
address of the FreePages code from the mixed mode version of the
EFI system table, and the current code dereferences the ordinary
system table instead, producing the wrong results. So fix this by
using the efi_table_attr() macro.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/boot/compressed/eboot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index da04948d75ed..98477f3529f6 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -901,7 +901,8 @@ void efi_free(unsigned long size, unsigned long addr)
 	if (efi_is_native())
 		efi_free_native(size, addr);
 	else
-		efi64_thunk(efi_system_table()->boottime->mixed_mode.free_pages,
+		efi64_thunk(efi_table_attr(efi_system_table(),
+					   boottime)->mixed_mode.free_pages,
 			    addr, 0, DIV_ROUND_UP(size, EFI_PAGE_SIZE));
 }
 #endif
-- 
2.20.1

