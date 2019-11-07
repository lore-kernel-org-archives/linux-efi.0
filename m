Return-Path: <SRS0=vceF=Y7=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EC6C5DF60
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 15:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E36021D82
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 15:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573139470;
	bh=ShhuQJKj95tf70E5sIDo1oCgv9TkTuvFMWJ3C79oc+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Pq/MEskf1J5kJGzNvs9+Swxz1Y+6b3kJCZejDtag6DlKHACnJmvUfA6WE7AmsWeGw
	 rXO0w9sXVd0sblV4+8O13w+tqxamP4ao9gHbL8J6QOKuRA95qYtfUildWRFj4CeT9E
	 ZKJwukKMoNbQHvYJUrO39KIXOPM15fCMv0sgZeDA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389404AbfKGPLG (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 7 Nov 2019 10:11:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388215AbfKGPLF (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 7 Nov 2019 10:11:05 -0500
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr [90.118.215.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5051221D7F;
        Thu,  7 Nov 2019 15:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573139465;
        bh=ShhuQJKj95tf70E5sIDo1oCgv9TkTuvFMWJ3C79oc+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MARGOLWPTetCeNDq3mfDxXWifCDClaIzR9qEWhG4uCsHWtXuAz7X4MAYJllkjwUD1
         kvkjlTmcLbmn90XZ+QTy+yy1X5tP6b7GKBdTOW1n65bnWY1mL3LK7ExQR55gHhUxwI
         86cPvbcK3zmrw3ayaTCbpJmEsSyLyiLtZh4irQgE=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Zou Cao <zoucao@linux.alibaba.com>
Subject: [PATCH 4/4] efi: libstub/tpm: enable tpm eventlog function for ARM platforms
Date:   Thu,  7 Nov 2019 16:10:36 +0100
Message-Id: <20191107151036.5586-5-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107151036.5586-1-ardb@kernel.org>
References: <20191107151036.5586-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Xinwei Kong <kong.kongxinwei@hisilicon.com>

Wire up the existing code for ARM that loads the TPM event log into
OS accessible buffers while running the EFI stub so that the kernel
proper can access it at runtime.

Tested-by: Zou Cao <zoucao@linux.alibaba.com>
Signed-off-by: Xinwei Kong <kong.kongxinwei@hisilicon.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/arm-stub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index c382a48c6678..817237ce2420 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -189,6 +189,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail_free_cmdline;
 	}
 
+	efi_retrieve_tpm2_eventlog(sys_table);
+
 	/* Ask the firmware to clear memory on unclean shutdown */
 	efi_enable_reset_attack_mitigation(sys_table);
 
-- 
2.17.1

