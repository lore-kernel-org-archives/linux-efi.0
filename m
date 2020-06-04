Return-Path: <SRS0=hUir=7R=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82309C433E1
	for <linux-efi@archiver.kernel.org>; Thu,  4 Jun 2020 02:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DA10207D5
	for <linux-efi@archiver.kernel.org>; Thu,  4 Jun 2020 02:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591237274;
	bh=JXzA3Ak1d2MpERrq3m3X5YXDWmtjBZJPXkrY0d6wfOc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=kgCUM89aNGHPzjZWrVwjvE7Krr7yYukkcfzj/ar5cqKNXrf+eHRgVdJfEKfVR07df
	 d3aFLWNUTWcncMnloGJ2x5s274QgvecO49UKcgxgkbnbJUurEOCzaSIXBbPldGE0lD
	 vFnrjit8vGz48BulcF3X6D3JwA4oA1+CcC1Ni3WQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgFDCVK (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 3 Jun 2020 22:21:10 -0400
Received: from conuserg-09.nifty.com ([210.131.2.76]:37645 "EHLO
        conuserg-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgFDCVH (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 3 Jun 2020 22:21:07 -0400
Received: from oscar.flets-west.jp (softbank126090202047.bbtec.net [126.90.202.47]) (authenticated)
        by conuserg-09.nifty.com with ESMTP id 0542KXGT019289;
        Thu, 4 Jun 2020 11:20:33 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 0542KXGT019289
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1591237233;
        bh=j5z5U8gxv5Bq9EeLtwXOFVCIgYpxEiWeySsn4UELVC0=;
        h=From:To:Cc:Subject:Date:From;
        b=l3hc3eMTKCTGcLsqrYFNALD8sumV26FfVYsxlenVWAIi++aYmRLSdkFTBSn2sZTU8
         c4UlrFpODwUKLWfzhGZeGbV7zqcm/dYozKtCix5eaK1jxadWC9bvMUkcxhyIfI83Q7
         Hr1ppF1CuDETSqcYc/UsK4PDszvtoOI2UacRuJFXPffIdYNvEEM+6EMsHPW69fs+da
         A7GwZvKXz7gD7+HKTT7TKbqbsNFXpSBBrt5228MENzNr/Sxi5CakeC7cN59zw+zRLM
         bys0wJxdTHjlhIy5UIJx/2iuxPmNAzktVZJVfXkG3rI4s+/LUjzbmyy4yC4wpcFwGP
         1mtcRFPtkAzug==
X-Nifty-SrcIP: [126.90.202.47]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] efi/libstub/arm64: link stub lib.a conditionally
Date:   Thu,  4 Jun 2020 11:20:30 +0900
Message-Id: <20200604022031.164207-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Since commit 799c43415442 ("kbuild: thin archives make default for
all archs"), core-y is passed to the linker with --whole-archive.
Hence, the whole of stub library is linked to vmlinux.

Use libs-y so that lib.a is passed after --no-whole-archive for
conditional linking.

The unused drivers/firmware/efi/libstub/relocate.o will be dropped
for ARCH=arm64.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

This patch touches under arch/arm64/, but
this is more related to efi.
I am sending this to Ard.

 arch/arm64/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 650e1185c190..48a6afa774fc 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -145,7 +145,7 @@ export	TEXT_OFFSET
 
 core-y		+= arch/arm64/
 libs-y		:= arch/arm64/lib/ $(libs-y)
-core-$(CONFIG_EFI_STUB) += $(objtree)/drivers/firmware/efi/libstub/lib.a
+libs-$(CONFIG_EFI_STUB) += $(objtree)/drivers/firmware/efi/libstub/lib.a
 
 # Default target when executing plain make
 boot		:= arch/arm64/boot
-- 
2.25.1

