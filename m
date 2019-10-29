Return-Path: <SRS0=+8OP=YW=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87D4CA9EAE
	for <linux-efi@archiver.kernel.org>; Tue, 29 Oct 2019 17:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91BC920856
	for <linux-efi@archiver.kernel.org>; Tue, 29 Oct 2019 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572370751;
	bh=GBeza5p8WGEvTqzWSjJUDKX9RvIIFgkMR8VvUvUMP2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Yfp9kdbpwIlIhDylhaeGXHtJcQxFGPBQb9/b5gtYC2x+Oa/ex95tCXxNvY9jXe9dl
	 GQf2AiZjKH9S/FU4PtKCcZCgBM4IuKCE9F2dY4tP0m3VgPOfkPObzTVfoAUl17JgzW
	 bZxixOmqq6gySvj2P8bSK6UpiMk/4ennho6PohR8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfJ2RjH (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 29 Oct 2019 13:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbfJ2RjG (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 29 Oct 2019 13:39:06 -0400
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr [90.118.215.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D4FD208E3;
        Tue, 29 Oct 2019 17:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572370746;
        bh=GBeza5p8WGEvTqzWSjJUDKX9RvIIFgkMR8VvUvUMP2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOxUEvSJkDU0GBuWyEMx0SaHO4nEupao0qdBOAT6Wu48CJRJPUFmLWAd1Z75GMpMO
         MBhA2SNJJffeHkGsVyFSCkS6kMB94mxdSwMF5zF0TWI6khDSn+3zc7sz5Pz5oewoD0
         ttXyY7KDpCpVfcZyTrdDQWLxMTMrt2dHaNe2JnMg=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] efi/tpm: return -EINVAL when determining tpm final events log size fails
Date:   Tue, 29 Oct 2019 18:37:51 +0100
Message-Id: <20191029173755.27149-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191029173755.27149-1-ardb@kernel.org>
References: <20191029173755.27149-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Jerry Snitselaar <jsnitsel@redhat.com>

Currently nothing checks the return value of efi_tpm_eventlog_init,
but in case that changes in the future make sure an error is
returned when it fails to determine the tpm final events log
size.

Fixes: e658c82be556 ("efi/tpm: Only set 'efi_tpm_final_log_size' after ...")
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/tpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index ebd7977653a8..31f9f0e369b9 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -88,6 +88,7 @@ int __init efi_tpm_eventlog_init(void)
 
 	if (tbl_size < 0) {
 		pr_err(FW_BUG "Failed to parse event in TPM Final Events Log\n");
+		ret = -EINVAL;
 		goto out_calc;
 	}
 
-- 
2.17.1

