Return-Path: <SRS0=JpIZ=6W=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8987C47255
	for <linux-efi@archiver.kernel.org>; Fri,  8 May 2020 18:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D8E2496F
	for <linux-efi@archiver.kernel.org>; Fri,  8 May 2020 18:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588960957;
	bh=qZE5oO9tju445FImkD+DKILGWfHrF6QF4ZLT8Y5GGew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=NB95Kt13Qif2qdxD80+Wgru9FDCJsYPa52tp7/oP4w24Om1rruntj4cQqcViPUCU9
	 Qh/K5MnOmlEgEurqbA5S+xuCekacEYci4LSVOY8t6nEfZG15qgI2od97sUDwQp5imo
	 wVCiI4yWno+BjG3CJ2YI2LkQffLo2aq4yeB53zrk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgEHSCg (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 8 May 2020 14:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbgEHSCf (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 8 May 2020 14:02:35 -0400
Received: from e123331-lin.nice.arm.com (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B07D24956;
        Fri,  8 May 2020 18:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588960955;
        bh=qZE5oO9tju445FImkD+DKILGWfHrF6QF4ZLT8Y5GGew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NW8I9yrkG9EvgNwvgfjPPNcyarFFwwWu5RFXZZVVdQGFNnXHBQYz8zpFS7f30BHCd
         vz8gh6lcQq7hJhRFSE9KNJ9EYonB1xvxF5p6lXn8Tgj2s6l1MICQfcKlNsxtUL3OeR
         u7naWWpZVwOaNobhHJtGwvgJeVFImM3i7aEli+po=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 06/15] efi/tpm: Use efi_err for error messages
Date:   Fri,  8 May 2020 20:01:48 +0200
Message-Id: <20200508180157.1816-7-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200508180157.1816-1-ardb@kernel.org>
References: <20200508180157.1816-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

Use efi_err instead of bare efi_printk for error messages.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Link: https://lore.kernel.org/r/20200430182843.2510180-7-nivedita@alum.mit.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/tpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
index 1d59e103a2e3..09adcf51b75b 100644
--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -119,7 +119,7 @@ void efi_retrieve_tpm2_eventlog(void)
 			     sizeof(*log_tbl) + log_size, (void **)&log_tbl);
 
 	if (status != EFI_SUCCESS) {
-		efi_printk("Unable to allocate memory for event log\n");
+		efi_err("Unable to allocate memory for event log\n");
 		return;
 	}
 
-- 
2.17.1

