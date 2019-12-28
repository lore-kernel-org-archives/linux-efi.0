Return-Path: <SRS0=sq0l=2S=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5049C2D0C6
	for <linux-efi@archiver.kernel.org>; Sat, 28 Dec 2019 15:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE8D821582
	for <linux-efi@archiver.kernel.org>; Sat, 28 Dec 2019 15:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577546516;
	bh=bfc0k2d45gRUUDsLjr6Xt4N0gUcHV+sU/1oZWW7LWak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kAzhHRaasIOF4AGzZMUlbXdPsJWByu/eMdAAOp410h64wtq2d+zbwOs38pxpf4ZOP
	 dzWUjOO5MvcoEnwbUkaCD17yNj9osNMC9xFSr5Rujf9Yd0fMRE6JBkv8FMoHQeSgxL
	 PGWtKNp9C9lLFgK4jgA0FLXh9VAekt5S5LsNa4c4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfL1PV4 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 28 Dec 2019 10:21:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:32906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfL1PV4 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sat, 28 Dec 2019 10:21:56 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CBA92173E;
        Sat, 28 Dec 2019 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577546515;
        bh=bfc0k2d45gRUUDsLjr6Xt4N0gUcHV+sU/1oZWW7LWak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LboXIcsT14rYqroAd6J+/VdvuKfE8d4mqvZOgSMJkZ6zEPqDB5TaE/ssF8pjNk6JT
         zPKwf27k1uEtB468q8l/iJAGnxWv/ZhnHq1b9WJ75USfrFMdpFr0xKJh3VuUsjAsdo
         pR4MNwul4TIwmIpthKaq4ZwPAmTKDuMyYE3lvke8=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/7] efi/libstub: use correct system table pointer in mixed mode efi_free()
Date:   Sat, 28 Dec 2019 16:21:04 +0100
Message-Id: <20191228152109.6301-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191228152109.6301-1-ardb@kernel.org>
References: <20191228152109.6301-1-ardb@kernel.org>
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
2.17.1

