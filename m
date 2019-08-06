Return-Path: <SRS0=J+Dl=WC=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68AC6C433FF
	for <linux-efi@archiver.kernel.org>; Tue,  6 Aug 2019 21:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 397CD21880
	for <linux-efi@archiver.kernel.org>; Tue,  6 Aug 2019 21:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565127818;
	bh=GTeKPiSpI0Ea9eCn2SaiWsSMjQ1GBjsNhDD41ADmNiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=u9lGidAf0knRAv79y5OWukVcNc05yUkJE2avLZQ2zTXa2p/lW0qOeLQcNKjqxODLF
	 WKr9aY07TSL4kc277W7jxPrXe4DBJeiRV2Vjr0ikRDnNHjCy6wcIbO8ELr6G352CR4
	 LVk+qf2Yazf3U+u3Qjyso5V+ACLQ/w6B3fT7TsC4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfHFVnh (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 6 Aug 2019 17:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727677AbfHFVe3 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 6 Aug 2019 17:34:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E447C21874;
        Tue,  6 Aug 2019 21:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127268;
        bh=GTeKPiSpI0Ea9eCn2SaiWsSMjQ1GBjsNhDD41ADmNiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+113blxGLI7+PZnfclsVDQFYDEsrGxj9BSbXIfimrkVD/p0mcuxWmye6Fl4DAcnJ
         +ixHFcmSLEMpLcEv1/jqfn50U+Jh5w8mBsXBwFe2CR9iKe1MbTluHmtpHky5b4ehBG
         usNMvREqC9k6ahCrqAOa4hHBWfcd46X3qpK5HJ3U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 36/59] arm64/efi: fix variable 'si' set but not used
Date:   Tue,  6 Aug 2019 17:32:56 -0400
Message-Id: <20190806213319.19203-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit f1d4836201543e88ebe70237e67938168d5fab19 ]

GCC throws out this warning on arm64.

drivers/firmware/efi/libstub/arm-stub.c: In function 'efi_entry':
drivers/firmware/efi/libstub/arm-stub.c:132:22: warning: variable 'si'
set but not used [-Wunused-but-set-variable]

Fix it by making free_screen_info() a static inline function.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/efi.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index c9e9a6978e73e..d3cb42fd51ec2 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -105,7 +105,11 @@ static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
 	((protocol##_t *)instance)->f(instance, ##__VA_ARGS__)
 
 #define alloc_screen_info(x...)		&screen_info
-#define free_screen_info(x...)
+
+static inline void free_screen_info(efi_system_table_t *sys_table_arg,
+				    struct screen_info *si)
+{
+}
 
 /* redeclare as 'hidden' so the compiler will generate relative references */
 extern struct screen_info screen_info __attribute__((__visibility__("hidden")));
-- 
2.20.1

