Return-Path: <SRS0=sq0l=2S=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B84C2D0C6
	for <linux-efi@archiver.kernel.org>; Sat, 28 Dec 2019 15:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB85A2173E
	for <linux-efi@archiver.kernel.org>; Sat, 28 Dec 2019 15:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577546523;
	bh=cie2lHcEW38WBLvF3eOT4LAXFbTA+2gOZO99z/rEdis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DBNBW0Mjh9mMSu9eXiKHPa76sDO9Lu4aN1S+LNAq25DWHnlVnlKxE3sm7f+6EZaco
	 iXYrNUh/+ysQyyW4DQnjcKzJpiJIXENrzqFQ1OjLaSOwY9RwyMTfGitSBmlxsltacq
	 xu3PaLABj47WRkWbYI+4/XCexDB4Vrd0zlj5rM9A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfL1PWC (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 28 Dec 2019 10:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfL1PWC (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sat, 28 Dec 2019 10:22:02 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5057821582;
        Sat, 28 Dec 2019 15:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577546521;
        bh=cie2lHcEW38WBLvF3eOT4LAXFbTA+2gOZO99z/rEdis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9/J31qaTJ8mVleI+ijiAS/kuBqflKF/q50Vnr8KgSuj32P9nMeJLtBNY2N6X1tKF
         yYkqKYKSw83Rt2WPyQ8HAwNrF1X1ftCiYxrCsn/GQocVV1ngv6+Ns71A+0a1ptWWPQ
         NgQld98wRbDh/kC9LMEdjjDxzEq1zMt5C/nSapq4=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5/7] efi/x86: avoid redundant cast of EFI firmware service pointer
Date:   Sat, 28 Dec 2019 16:21:07 +0100
Message-Id: <20191228152109.6301-6-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191228152109.6301-1-ardb@kernel.org>
References: <20191228152109.6301-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

All EFI firmware call prototypes have been annotated as __efiapi,
permitting us to attach attributes regarding the calling convention
by overriding __efiapi to an architecture specific value.

On 32-bit x86, EFI firmware calls use the plain calling convention
where all arguments are passed via the stack, and cleaned up by the
caller. Let's add this to the __efiapi definition so we no longer
need to cast the function pointers before invoking them.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/include/asm/efi.h | 8 +-------
 include/linux/efi.h        | 4 +++-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 9f4281aae779..9d25fc2ddc50 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -51,13 +51,7 @@ extern asmlinkage unsigned long efi_call_phys(void *, ...);
 })
 
 
-/*
- * Wrap all the virtual calls in a way that forces the parameters on the stack.
- */
-#define arch_efi_call_virt(p, f, args...)				\
-({									\
-	((efi_##f##_t __attribute__((regparm(0)))*) p->f)(args);	\
-})
+#define arch_efi_call_virt(p, f, args...)	p->f(args)
 
 #define efi_ioremap(addr, size, type, attr)	ioremap_cache(addr, size)
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 726673e98990..952c1659dfd9 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -48,8 +48,10 @@ typedef u16 efi_char16_t;		/* UNICODE character */
 typedef u64 efi_physical_addr_t;
 typedef void *efi_handle_t;
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64)
 #define __efiapi __attribute__((ms_abi))
+#elif defined(CONFIG_X86_32)
+#define __efiapi __attribute__((regparm(0)))
 #else
 #define __efiapi
 #endif
-- 
2.17.1

