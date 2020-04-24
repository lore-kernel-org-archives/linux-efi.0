Return-Path: <SRS0=8DUf=6I=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A5A4C54FD0
	for <linux-efi@archiver.kernel.org>; Fri, 24 Apr 2020 13:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C5BD20728
	for <linux-efi@archiver.kernel.org>; Fri, 24 Apr 2020 13:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587733659;
	bh=xfSWHVVKn3KbC6cxywgzau1V2atH9TVMfdBBeCUGOTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VeJ+Q2O7Anayu/WeAbBGq/r7rocswsWWWAmqewe/44/sYoBBHCXvSpx4kBprGTFbS
	 MPdc0usYh4LQ/j2lhe4kk1d0jNaMYtYNQnnpbRyr7kuC9dRRdJrIEOCZKKG5sp1WbH
	 SVfhXQrjKT65AULlToyomNqLhNu/Wyf+Nz25Bcq0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgDXNHU (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbgDXNHU (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 24 Apr 2020 09:07:20 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99DEF20776;
        Fri, 24 Apr 2020 13:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587733639;
        bh=xfSWHVVKn3KbC6cxywgzau1V2atH9TVMfdBBeCUGOTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2qx7LAynjfezNLRBGrHdQOjzuBzQfV05mGc5gYsUmx18g3OS8beayhCn7Ml9Vv/2
         J17VRgsU42yiQLX9RTm6g5VtwIk7PZSnSaj35XIg/qEkkO4xPcFoPE4XW503JCUWYs
         lWAN22A8sZrSOJDudmFvGYuRzCd4eJHl8VmICE/0=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH 31/33] efi/libstub/x86: Avoid getter function for efi_is64
Date:   Fri, 24 Apr 2020 15:05:29 +0200
Message-Id: <20200424130531.30518-32-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424130531.30518-1-ardb@kernel.org>
References: <20200424130531.30518-1-ardb@kernel.org>
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
index 78e839925a81..cd0c3fbf6156 100644
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
index bddbc103a34b..597793fe8d22 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -21,16 +21,8 @@
 #define MAXMEM_X86_64_4LEVEL (1ull << 46)
 
 const efi_system_table_t *efi_system_table;
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

