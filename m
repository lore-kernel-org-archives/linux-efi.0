Return-Path: <SRS0=ZyQ3=6A=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10824C2BB55
	for <linux-efi@archiver.kernel.org>; Thu, 16 Apr 2020 19:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4CAD221E8
	for <linux-efi@archiver.kernel.org>; Thu, 16 Apr 2020 19:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587064742;
	bh=m1V2Mc3j0eRKeaJf5mM4RJY50zz51ZWaSlFfeOm1cDM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ZelCFOXmh9axZnq0ILQuiwt5/Q7LMbYdz+8NVUN2oKAEhAs+7x2CUpdelT+TVKhfF
	 GvPYSXrFKV22ucW6XFuWaP92oZIQNk0j2yxdDsJCzdU4x2n7LYPnMP7a5QoHIgbhFc
	 1TRywyZGczqfLgnLRMn1TNQsNIo7nynqtsB50Y2o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgDPTTC (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 16 Apr 2020 15:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbgDPTTC (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 16 Apr 2020 15:19:02 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF570206E9;
        Thu, 16 Apr 2020 19:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587064741;
        bh=m1V2Mc3j0eRKeaJf5mM4RJY50zz51ZWaSlFfeOm1cDM=;
        h=From:To:Cc:Subject:Date:From;
        b=hRUwgCEWkR+NNcdpyW2K0YOGWRE0d+IUwNJVOodwDWtFoHwHvttN3FoFIvov52QGY
         kOMZuxl9W/LY+bIo3V3J0F1Y7K2Z+7p5H9TtaDRHFHTMZIQQyCHoMzQES7GeX9DzcB
         izWOTeVYCaYYoJBWaBYhVEr7fSIAGmH0MXBI7vHw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     nivedita@alum.mit.edu, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] efi/libstub/x86: avoid getter function for efi_is64
Date:   Thu, 16 Apr 2020 21:18:55 +0200
Message-Id: <20200416191855.17706-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

We no longer need to take special care when using global variables
in the EFI stub, so switch to a simple symbol reference for efi_is64.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/include/asm/efi.h              | 11 ++++++++---
 drivers/firmware/efi/libstub/x86-stub.c |  8 --------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index d7e40bf88f7e..a34f36084ac0 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -225,14 +225,19 @@ efi_status_t efi_set_virtual_address_map(unsigned long memory_map_size,
 
 /* arch specific definitions used by the stub code */
 
-__attribute_const__ bool efi_is_64bit(void);
+extern const bool efi_is64;
+
+static inline bool efi_is_64bit(void)
+{
+	if (IS_ENABLED(CONFIG_EFI_MIXED))
+		return efi_is64;
+	return IS_ENABLED(CONFIG_X86_64);
+}
 
 static inline bool efi_is_native(void)
 {
 	if (!IS_ENABLED(CONFIG_X86_64))
 		return true;
-	if (!IS_ENABLED(CONFIG_EFI_MIXED))
-		return true;
 	return efi_is_64bit();
 }
 
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index 6012bb5d1b75..a252fd8234db 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -21,16 +21,8 @@
 #define MAXMEM_X86_64_4LEVEL (1ull << 46)
 
 efi_system_table_t *efi_system_table;
-extern const bool efi_is64;
 extern u32 image_offset;
 
-__attribute_const__ bool efi_is_64bit(void)
-{
-	if (IS_ENABLED(CONFIG_EFI_MIXED))
-		return efi_is64;
-	return IS_ENABLED(CONFIG_X86_64);
-}
-
 static efi_status_t
 preserve_pci_rom_image(efi_pci_io_protocol_t *pci, struct pci_setup_rom **__rom)
 {
-- 
2.17.1

