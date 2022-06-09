Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E05C433EF
	for <linux-efi@archiver.kernel.org>; Thu,  9 Jun 2022 11:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243429AbiFILj5 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 9 Jun 2022 07:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243047AbiFILji (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 9 Jun 2022 07:39:38 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C771D4202;
        Thu,  9 Jun 2022 04:39:35 -0700 (PDT)
Received: from localhost.localdomain (unknown [80.240.223.29])
        by mail.ispras.ru (Postfix) with ESMTPSA id 9350F40737CE;
        Thu,  9 Jun 2022 11:39:31 +0000 (UTC)
From:   Evgeniy Baskov <baskov@ispras.ru>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Evgeniy Baskov <baskov@ispras.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] efi/x86: libstub: Fix typo in __efi64_argmap* name
Date:   Thu,  9 Jun 2022 14:37:30 +0300
Message-Id: <20220609113730.32062-1-baskov@ispras.ru>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The actual name of the DXE services function used
is set_memory_space_attributes(), not set_memory_space_descriptor().

Change EFI mixed mode helper macro name to match the function name.

Fixes: 31f1a0edff78 ("efi/x86: libstub: Make DXE calls mixed mode safe")
Signed-off-by: Evgeniy Baskov <baskov@ispras.ru>
---
 arch/x86/include/asm/efi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 71943dce691e..9636742a80f2 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -323,7 +323,7 @@ static inline u32 efi64_convert_status(efi_status_t status)
 #define __efi64_argmap_get_memory_space_descriptor(phys, desc) \
 	(__efi64_split(phys), (desc))
 
-#define __efi64_argmap_set_memory_space_descriptor(phys, size, flags) \
+#define __efi64_argmap_set_memory_space_attributes(phys, size, flags) \
 	(__efi64_split(phys), __efi64_split(size), __efi64_split(flags))
 
 /*
-- 
2.36.1

