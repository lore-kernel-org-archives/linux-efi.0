Return-Path: <SRS0=8H/N=4Z=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A5DC10F28
	for <linux-efi@archiver.kernel.org>; Sun,  8 Mar 2020 08:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2F7320838
	for <linux-efi@archiver.kernel.org>; Sun,  8 Mar 2020 08:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583654993;
	bh=KQv/xtY1MKKNnT2VGICT365t0IzcUS1bdTTVauTkWwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0nFoDGo0PIEBr98QYYU3T9VhTiofMRurKlMbPagF2Y8a5S325tW0rBUpgwiN2+HRl
	 etE7RKGHxu3SQx1KyXq7+GUjRuS6QqJZpMnZ+hKSRC9uyeVDEIt4hdNdr1kYBf4FJT
	 mpLgVDuekWAZgTn67ksjbdem+swaDRWzC61gORX0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgCHIJu (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 8 Mar 2020 04:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgCHIJt (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 8 Mar 2020 04:09:49 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E44EA208C3;
        Sun,  8 Mar 2020 08:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583654989;
        bh=KQv/xtY1MKKNnT2VGICT365t0IzcUS1bdTTVauTkWwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJcgrbxkslkpYFu0pX2sV5Bb8iQ3B12uk5z4KYOEbrrXQXGb73NnHOtll7v+2uymC
         1iaQU4npVcqAgTlMnaYuCRz9AcajQ0cS+dkjyFKK2avE9ToqmNLDK6ZLsQ7SxELTCX
         lItxsoqD5hlX8C3zSIn7x1C3ggtkejkc91zC8emU=
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
Subject: [PATCH 12/28] efi/x86: Avoid using code32_start
Date:   Sun,  8 Mar 2020 09:08:43 +0100
Message-Id: <20200308080859.21568-13-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200308080859.21568-1-ardb@kernel.org>
References: <20200308080859.21568-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

code32_start is meant for 16-bit real-mode bootloaders to inform the
kernel where the 32-bit protected mode code starts. Nothing in the
protected mode kernel except the EFI stub uses it.

efi_main currently returns boot_params, with code32_start set inside it
to tell efi_stub_entry where startup_32 is located. Since it was invoked
by efi_stub_entry in the first place, boot_params is already known.
Return the address of startup_32 instead.

This will allow a 64-bit kernel to live above 4Gb, for example, and it's
cleaner.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Link: https://lore.kernel.org/r/20200301230436.2246909-5-nivedita@alum.mit.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/boot/compressed/head_32.S      |  3 +--
 arch/x86/boot/compressed/head_64.S      |  4 ++--
 arch/x86/kernel/asm-offsets.c           |  1 -
 drivers/firmware/efi/libstub/x86-stub.c | 10 +++++-----
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 356060c5332c..9ffc9454fd22 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -157,9 +157,8 @@ SYM_FUNC_END(startup_32)
 SYM_FUNC_START(efi32_stub_entry)
 SYM_FUNC_START_ALIAS(efi_stub_entry)
 	add	$0x4, %esp
+	movl	8(%esp), %esi	/* save boot_params pointer */
 	call	efi_main
-	movl	%eax, %esi
-	movl	BP_code32_start(%esi), %eax
 	leal	startup_32(%eax), %eax
 	jmp	*%eax
 SYM_FUNC_END(efi32_stub_entry)
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index b74a012a6fea..08351d16ccc0 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -472,9 +472,9 @@ SYM_CODE_END(startup_64)
 SYM_FUNC_START(efi64_stub_entry)
 SYM_FUNC_START_ALIAS(efi_stub_entry)
 	and	$~0xf, %rsp			/* realign the stack */
+	movq	%rdx, %rbx			/* save boot_params pointer */
 	call	efi_main
-	movq	%rax,%rsi
-	movl	BP_code32_start(%esi), %eax
+	movq	%rbx,%rsi
 	leaq	startup_64(%rax), %rax
 	jmp	*%rax
 SYM_FUNC_END(efi64_stub_entry)
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 5c7ee3df4d0b..3ca07ad552ae 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -88,7 +88,6 @@ static void __used common(void)
 	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
 	OFFSET(BP_init_size, boot_params, hdr.init_size);
 	OFFSET(BP_pref_address, boot_params, hdr.pref_address);
-	OFFSET(BP_code32_start, boot_params, hdr.code32_start);
 
 	BLANK();
 	DEFINE(PTREGS_SIZE, sizeof(struct pt_regs));
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index 9db98839d7b4..7f3e97c2aad3 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -703,10 +703,11 @@ static efi_status_t exit_boot(struct boot_params *boot_params, void *handle)
 }
 
 /*
- * On success we return a pointer to a boot_params structure, and NULL
- * on failure.
+ * On success, we return the address of startup_32, which has potentially been
+ * relocated by efi_relocate_kernel.
+ * On failure, we exit to the firmware via efi_exit instead of returning.
  */
-struct boot_params *efi_main(efi_handle_t handle,
+unsigned long efi_main(efi_handle_t handle,
 			     efi_system_table_t *sys_table_arg,
 			     struct boot_params *boot_params)
 {
@@ -736,7 +737,6 @@ struct boot_params *efi_main(efi_handle_t handle,
 			goto fail;
 		}
 	}
-	hdr->code32_start = (u32)bzimage_addr;
 
 	/*
 	 * efi_pe_entry() may have been called before efi_main(), in which
@@ -799,7 +799,7 @@ struct boot_params *efi_main(efi_handle_t handle,
 		goto fail;
 	}
 
-	return boot_params;
+	return bzimage_addr;
 fail:
 	efi_printk("efi_main() failed!\n");
 
-- 
2.17.1

