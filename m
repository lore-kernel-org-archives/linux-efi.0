Return-Path: <SRS0=ukhU=5L=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FB3C43331
	for <linux-efi@archiver.kernel.org>; Thu, 26 Mar 2020 16:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8740220714
	for <linux-efi@archiver.kernel.org>; Thu, 26 Mar 2020 16:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585241998;
	bh=WqWf8eNck8zzklsL8CT7yC/cR29ZkC/4yp+5+cuQni8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sx/HSadk9dwwq0Hu8J0oeuu2B4IAKexMl8NLkkpK4EpP0dtcv1/H9CnYGwBHrfgjl
	 6P83NU6P+8t7po3TpaW2Flhln2Pjklh5K/Mt9D/ueeP+FqT0qqKu8lxRsl1suAvEKa
	 WOYOypssc83jEdee3DBuBsJYR3CSgANihuzl2gSw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgCZQ76 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 26 Mar 2020 12:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727393AbgCZQ76 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 26 Mar 2020 12:59:58 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71EC820775;
        Thu, 26 Mar 2020 16:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585241997;
        bh=WqWf8eNck8zzklsL8CT7yC/cR29ZkC/4yp+5+cuQni8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0JnADcL7reZbpz2hS+behuXijTSO5D3D6TN1XmyNf2f8lE/s4Ts8WVIsGRuOhfpq
         14b3oQo3fo+Wzr+Ie1w2FNxfrODOwCMqikbRV8BevLNapovPLZU6giqlJS37FXYl8D
         W/fKY9ZhTiIBEitSv8SenlLeNGZi87vpRfCPeSv8=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
        linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/2] efi/arm64: increase the PE/COFF alignment so the kernel can run in place
Date:   Thu, 26 Mar 2020 17:59:05 +0100
Message-Id: <20200326165905.2240-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200326165905.2240-1-ardb@kernel.org>
References: <20200326165905.2240-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Update the PE/COFF metadata so that the UEFI image loader will load the
kernel image at an offset that allows it to execute in place.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kernel/efi-header.S | 2 +-
 arch/arm64/kernel/image-vars.h | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
index 914999ccaf8a..f9ee1c2a5fd6 100644
--- a/arch/arm64/kernel/efi-header.S
+++ b/arch/arm64/kernel/efi-header.S
@@ -32,7 +32,7 @@ optional_header:
 
 extra_header_fields:
 	.quad	0					// ImageBase
-	.long	SZ_4K					// SectionAlignment
+	.long	PECOFF_SECTION_ALIGNMENT		// SectionAlignment
 	.long	PECOFF_FILE_ALIGNMENT			// FileAlignment
 	.short	0					// MajorOperatingSystemVersion
 	.short	0					// MinorOperatingSystemVersion
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index be0a63ffed23..7a7fa3ba7b2f 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -15,6 +15,13 @@
 __efistub_kernel_size		= _edata - _text;
 __efistub_primary_entry_offset	= primary_entry - _text;
 
+#ifndef CONFIG_RELOCATABLE
+PECOFF_SECTION_ALIGNMENT = SZ_4K;
+#elif THREAD_ALIGN > SEGMENT_ALIGN
+PECOFF_SECTION_ALIGNMENT = THREAD_ALIGN;
+#else
+PECOFF_SECTION_ALIGNMENT = SEGMENT_ALIGN;
+#endif
 
 /*
  * The EFI stub has its own symbol namespace prefixed by __efistub_, to
-- 
2.17.1

