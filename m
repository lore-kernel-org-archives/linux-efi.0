Return-Path: <SRS0=8DUf=6I=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26DBC54FD0
	for <linux-efi@archiver.kernel.org>; Fri, 24 Apr 2020 13:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B847120728
	for <linux-efi@archiver.kernel.org>; Fri, 24 Apr 2020 13:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587733585;
	bh=u1ihzwM3c8sBg0EnXWrxx9MwjgT7QgXNP2f7CYbiPaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=C5fm62NMLoESVrVzwGePDJBAjelUJPv2EMefxovMYTW3XpRFAL7NOkpxmkFC2IVbO
	 aQgRt2N1W9okwGv1ifzu77fAgNY1uUCRMRqOnmouq3RLE9o7XiCGAwEM8TOnggdfMu
	 Mo/qZzARaQo3UU9ML7lGb6nXRbMtl6vCpgrm1VCc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgDXNGY (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727845AbgDXNGV (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 24 Apr 2020 09:06:21 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90A402084D;
        Fri, 24 Apr 2020 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587733581;
        bh=u1ihzwM3c8sBg0EnXWrxx9MwjgT7QgXNP2f7CYbiPaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZ12YDITGAWJ4Ho0reLEQROfzFFA99IIlJVzJ4miYcYcAYjJSbeghz0rgytmnR3BL
         2UEiRSbgYlecjiqV+zgtID9KGjji4BQaAap6ZxhePJWhZnGkAsPAf59pV0RohBwHt6
         277vwkkXC8sm9TXP+gRxNW30jCIfUf0aC3japAAM=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH 04/33] efi/libstub/arm: Make install_memreserve_table static
Date:   Fri, 24 Apr 2020 15:05:02 +0200
Message-Id: <20200424130531.30518-5-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424130531.30518-1-ardb@kernel.org>
References: <20200424130531.30518-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

Fix the following sparse warning:

drivers/firmware/efi/libstub/arm-stub.c:68:6: warning:
symbol 'install_memreserve_table' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1587643713-28169-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 99a5cde7c2d8..8a26cc11ca4a 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -65,7 +65,7 @@ static struct screen_info *setup_graphics(void)
 	return si;
 }
 
-void install_memreserve_table(void)
+static void install_memreserve_table(void)
 {
 	struct linux_efi_memreserve *rsv;
 	efi_guid_t memreserve_table_guid = LINUX_EFI_MEMRESERVE_TABLE_GUID;
-- 
2.17.1

