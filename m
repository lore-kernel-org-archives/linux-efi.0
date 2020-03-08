Return-Path: <SRS0=8H/N=4Z=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF95C2BB58
	for <linux-efi@archiver.kernel.org>; Sun,  8 Mar 2020 08:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E861D2146E
	for <linux-efi@archiver.kernel.org>; Sun,  8 Mar 2020 08:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583654967;
	bh=ZC3Ht6M1A+48LStSHQkp1WSEU79DLzGExzetr4ZF0/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uYtXExY5qCXZ4NVcsiLDvXzW6CCAosOiLOb18CY2PvQ8rSFoFrKxbraH2EH5D8wn1
	 evnROlFC64PnAsojNWpqEl6TMGScy4/8bXwkBUUWI3CS8i4jvKU06G3Zqf5stz19wE
	 Rrs2SaRp9X8bLsCAawOwwE2aUhvFncWENwsziI/A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgCHIJ0 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 8 Mar 2020 04:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgCHIJY (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 8 Mar 2020 04:09:24 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 085C921739;
        Sun,  8 Mar 2020 08:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583654964;
        bh=ZC3Ht6M1A+48LStSHQkp1WSEU79DLzGExzetr4ZF0/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlqYQQbJf49fo+tvqgZnzRXtZ+4PXamCyT3Ob1WyM/4LPYjRDDJSAWsoUJTE4RXdA
         DOM26GVL6jE7ZRJBfxzTu/nbMjG08PuURjECThsAsqHtDb6HxbiAps/grmjPew4/JA
         2q6ow5vvHoI6WtZ9PJSk8hxmZ9an5a1wgAEG0JNQ=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Christoph Hellwig <hch@lst.de>,
        David Hildenbrand <david@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nikolai Merinov <n.merinov@inango-systems.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH 05/28] efi/arm64: clean EFI stub exit code from cache instead of avoiding it
Date:   Sun,  8 Mar 2020 09:08:36 +0100
Message-Id: <20200308080859.21568-6-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200308080859.21568-1-ardb@kernel.org>
References: <20200308080859.21568-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Commit 9f9223778 ("efi/libstub/arm: Make efi_entry() an ordinary PE/COFF
entrypoint") modified the handover code written in assembler, and for
maintainability, aligned the logic with the logic used in the 32-bit ARM
version, which is to avoid cache maintenance on the remaining instructions
in the subroutine that will be executed with the MMU and caches off, and
instead, branch into the relocated copy of the kernel image.

However, this assumes that this copy is executable, and this means we
expect EFI_LOADER_DATA regions to be executable as well, which is not
a reasonable assumption to make, even if this is true for most UEFI
implementations today.

So change this back, and add a __clean_dcache_area_poc() call to cover
the remaining code in the subroutine. While at it, switch the other
call site over to __clean_dcache_area_poc() as well, and clean up the
terminology in comments to avoid using 'flush' in the context of cache
maintenance. Also, let's switch to the new style asm annotations.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kernel/efi-entry.S  | 26 +++++++++++++-------------
 arch/arm64/kernel/image-vars.h |  4 ++--
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index 4cfd03c35c49..1a03618df0df 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -12,32 +12,32 @@
 
 	__INIT
 
-ENTRY(efi_enter_kernel)
+SYM_CODE_START(efi_enter_kernel)
 	/*
 	 * efi_entry() will have copied the kernel image if necessary and we
 	 * end up here with device tree address in x1 and the kernel entry
 	 * point stored in x0. Save those values in registers which are
 	 * callee preserved.
 	 */
-	mov	x19, x0			// relocated Image address
+	ldr	w2, =stext_offset
+	add	x19, x0, x2		// relocated Image entrypoint
 	mov	x20, x1			// DTB address
 
 	/*
-	 * Flush the copied Image to the PoC, and ensure it is not shadowed by
+	 * Clean the copied Image to the PoC, and ensure it is not shadowed by
 	 * stale icache entries from before relocation.
 	 */
 	ldr	w1, =kernel_size
-	bl	__flush_dcache_area
+	bl	__clean_dcache_area_poc
 	ic	ialluis
-	dsb	sy
 
 	/*
-	 * Jump across, into the copy of the image that we just cleaned
-	 * to the PoC, so that we can safely disable the MMU and caches.
+	 * Clean the remainder of this routine to the PoC
+	 * so that we can safely disable the MMU and caches.
 	 */
-	ldr	w0, .Ljmp
-	sub	x0, x19, w0, sxtw
-	br	x0
+	adr	x0, 0f
+	ldr	w1, 3f
+	bl	__clean_dcache_area_poc
 0:
 	/* Turn off Dcache and MMU */
 	mrs	x0, CurrentEL
@@ -63,6 +63,6 @@ ENTRY(efi_enter_kernel)
 	mov	x1, xzr
 	mov	x2, xzr
 	mov	x3, xzr
-	b	stext
-ENDPROC(efi_enter_kernel)
-.Ljmp:	.long	_text - 0b
+	br	x19
+SYM_CODE_END(efi_enter_kernel)
+3:	.long	. - 0b
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 9a7aef0d6f70..7f06ad93fc95 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_EFI
 
 __efistub_kernel_size		= _edata - _text;
+__efistub_stext_offset		= stext - _text;
 
 
 /*
@@ -34,7 +35,7 @@ __efistub_strnlen		= __pi_strnlen;
 __efistub_strcmp		= __pi_strcmp;
 __efistub_strncmp		= __pi_strncmp;
 __efistub_strrchr		= __pi_strrchr;
-__efistub___flush_dcache_area	= __pi___flush_dcache_area;
+__efistub___clean_dcache_area_poc = __pi___clean_dcache_area_poc;
 
 #ifdef CONFIG_KASAN
 __efistub___memcpy		= __pi_memcpy;
@@ -43,7 +44,6 @@ __efistub___memset		= __pi_memset;
 #endif
 
 __efistub__text			= _text;
-__efistub_stext			= stext;
 __efistub__end			= _end;
 __efistub__edata		= _edata;
 __efistub_screen_info		= screen_info;
-- 
2.17.1

