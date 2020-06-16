Return-Path: <SRS0=sDd0=75=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36809C433E0
	for <linux-efi@archiver.kernel.org>; Tue, 16 Jun 2020 11:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 067D320786
	for <linux-efi@archiver.kernel.org>; Tue, 16 Jun 2020 11:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592305236;
	bh=6iykV8yTO9x29fZKbGvA221ZIaReCNzafH3wTMLBVls=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=SMbpFcRq4ELi8krfO94JnYeTZZW2VhzcojxpWZQ02xUxUmNHKtyDmNqx9+GLCwpYC
	 EOlmB/QzFiXZNdNg1QoB7sjyx6OltlHMrUWp5RqEIev1boK8spMOc2HE+NTgnEAdSm
	 RpR8C/c4ZB8OIcpvqW8JQgjRBnT9AXEzJDK+oH+Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgFPLAf (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 16 Jun 2020 07:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728154AbgFPLAf (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 16 Jun 2020 07:00:35 -0400
Received: from localhost.localdomain (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE15D20739;
        Tue, 16 Jun 2020 11:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592305235;
        bh=6iykV8yTO9x29fZKbGvA221ZIaReCNzafH3wTMLBVls=;
        h=From:To:Cc:Subject:Date:From;
        b=tt5GA0SYEuIzOBJhC+a2M9YQphW9EYlD+NdfvX5kZhwJ9j8oHGjXfDQmujUOEGToC
         IIVSb0/keFAG1nsJqQEM5ldGk3hhSUDwGgr26F00kY6pGWoIhi6Fbg+K9/rqRHECdu
         FuOQN8Ivi3bfNqsKbUD3L8KdIB/suZK34gvEcFNo=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, xypron.glpk@gmx.de,
        leif@nuviainc.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] efi/libstub: arm: Omit arch specific config table matching array on arm64
Date:   Tue, 16 Jun 2020 13:00:30 +0200
Message-Id: <20200616110030.1054015-1-ardb@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On arm64, the EFI stub is built into the kernel proper, and so the stub
can refer to its symbols directly. Therefore, the practice of using EFI
configuration tables to pass information between them is never needed,
so we can omit any code consuming such tables when building for arm64.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---

This will be applied before 'efi/libstub: arm: Print CPU boot mode and MMU 
state at boot' [v3] sent out today

 drivers/firmware/efi/arm-init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index c697e70ca7e7..6f4baf70db16 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -62,7 +62,8 @@ static void __init init_screen_info(void)
 {
 	struct screen_info *si;
 
-	if (screen_info_table != EFI_INVALID_TABLE_ADDR) {
+	if (IS_ENABLED(CONFIG_ARM) &&
+	    screen_info_table != EFI_INVALID_TABLE_ADDR) {
 		si = early_memremap_ro(screen_info_table, sizeof(*si));
 		if (!si) {
 			pr_err("Could not map screen_info config table\n");
@@ -116,7 +117,8 @@ static int __init uefi_init(u64 efi_system_table)
 		goto out;
 	}
 	retval = efi_config_parse_tables(config_tables, systab->nr_tables,
-					 arch_tables);
+					 IS_ENABLED(CONFIG_ARM) ? arch_tables
+								: NULL);
 
 	early_memunmap(config_tables, table_size);
 out:
-- 
2.27.0

