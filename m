Return-Path: <SRS0=EqbT=6S=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784F1C3A5A9
	for <linux-efi@archiver.kernel.org>; Mon,  4 May 2020 08:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5274B20746
	for <linux-efi@archiver.kernel.org>; Mon,  4 May 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588580179;
	bh=J8IyhWwdsQ3y/pRh68I7Hr2aH501MMjSOApSNu1oB+A=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=mgC9YB36XrMTEq0tCRNcKg3FZlUneYud00gN1KXg77XOzuPQTAJ4NFMskmzkpPSkV
	 L1UWXsVsu/xVsqwzJIWGzMky6BZ8g2IuMLFo0Ez/0bWWALSP2n22Wo3b5vb4en26Jq
	 LptUZTLR3nb3uzeRh90rlktzjKdMK4k6ijELCnt0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgEDIQT (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 4 May 2020 04:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgEDIQS (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 4 May 2020 04:16:18 -0400
Received: from e123331-lin.nice.arm.com (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0575D206B9;
        Mon,  4 May 2020 08:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588580178;
        bh=J8IyhWwdsQ3y/pRh68I7Hr2aH501MMjSOApSNu1oB+A=;
        h=From:To:Cc:Subject:Date:From;
        b=t5N83AI+/LrZriW4Raca/J+fDHCPtGE218mmFMRnAr7ce7sqNEbNPquqmyOeGs2xK
         lcueMlz0Nb6CQ1C85/wEHPVw0BeItF2wZ3I2eDzEKIREwBI8ELz/vUl5/VdqDIFzdR
         fpC1DcKUk0+VrICH6WQf/tgzIoRezAiKhscDHjKc=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     arnd@arndb.de, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH] efi/libstub/x86: work around LLVM ELF quirk build regression
Date:   Mon,  4 May 2020 10:16:05 +0200
Message-Id: <20200504081605.32624-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

When building the x86 EFI stub with Clang, the libstub Makefile rules
that manipulate the ELF object files may throw an error like:

    STUBCPY drivers/firmware/efi/libstub/efi-stub-helper.stub.o
  strip: drivers/firmware/efi/libstub/efi-stub-helper.stub.o: Failed to find link section for section 10
  objcopy: drivers/firmware/efi/libstub/efi-stub-helper.stub.o: Failed to find link section for section 10

This is the result of a LLVM 'feature' [0] where symbol references are
stored in a LLVM specific .llvm_addrsig section in a non-transparent way,
causing generic ELF tools such as strip or objcopy to choke on them.

So drop the .llvm_addrsig section explicitly as well, to work around
this behavior.

[0] https://sourceware.org/bugzilla/show_bug.cgi?id=23817

Cc: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 8d246b51bd49..4d137615a666 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -66,7 +66,8 @@ CFLAGS_arm64-stub.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 # .data section of the compressed kernel to ensure initialization. Rename the
 # .bss section here so it's easy to pick out in the linker script.
 #
-STUBCOPY_FLAGS-$(CONFIG_X86)	+= --rename-section .bss=.bss.efistub,load,alloc
+STUBCOPY_FLAGS-$(CONFIG_X86)	+= -R .llvm_addrsig \
+				   --rename-section .bss=.bss.efistub,load,alloc
 STUBCOPY_RELOC-$(CONFIG_X86_32)	:= R_386_32
 STUBCOPY_RELOC-$(CONFIG_X86_64)	:= R_X86_64_64
 
@@ -111,7 +112,7 @@ $(obj)/%.stub.o: $(obj)/%.o FORCE
 #
 quiet_cmd_stubcopy = STUBCPY $@
       cmd_stubcopy =							\
-	$(STRIP) --strip-debug -o $@ $<;				\
+	$(STRIP) --strip-debug -R .llvm_addrsig -o $@ $<;		\
 	if $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y); then		\
 		echo "$@: absolute symbol references not allowed in the EFI stub" >&2; \
 		/bin/false;						\
-- 
2.17.1

