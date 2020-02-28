Return-Path: <SRS0=uAFW=4Q=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52190C3F2D2
	for <linux-efi@archiver.kernel.org>; Fri, 28 Feb 2020 12:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F2542087F
	for <linux-efi@archiver.kernel.org>; Fri, 28 Feb 2020 12:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582892075;
	bh=FoQDG3xdJuBlX9Uf6sQGSNLk3h0Lwk3nb9QI5kC4A5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tM5MXQJ9May634EnRxdlDRYBsrv9NxkoSjNwMY+etq5fe57Ibk/IAbXLWmKC2fmmI
	 eOVZmkZhiO4JFbPQXSgOsYpeWTb0gq5QCv1OH8Pybf0IMz1d6UP582M5pSjiag6dSq
	 GRYi3xKkom7tTI5DSH/87UiBsCmC5L1KGphc5DkM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgB1MOV (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 28 Feb 2020 07:14:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgB1MOV (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 28 Feb 2020 07:14:21 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A510B246B6;
        Fri, 28 Feb 2020 12:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582892060;
        bh=FoQDG3xdJuBlX9Uf6sQGSNLk3h0Lwk3nb9QI5kC4A5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+qoS2prwh0smdk1Ih84pqcIFbf4cmbb+oj9xxTVjc37OFQmji/GNZ+YXPRB518gJ
         6HwyHNOVl8iMarvvCYVxzKRAGQzMHLzEa2vMWnVGWMOYSfN2zK1b8I1JOl+vwLYzZW
         ASAqKt5Ohw3metMGkew1mxt2tteRQD+qlEvwa4a8=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 3/6] efi: don't shadow i in efi_config_parse_tables()
Date:   Fri, 28 Feb 2020 13:14:05 +0100
Message-Id: <20200228121408.9075-4-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200228121408.9075-1-ardb@kernel.org>
References: <20200228121408.9075-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

Shadowing variables is generally frowned upon.

Let's simply reuse the existing loop counter i instead of shadowing it.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Link: https://lore.kernel.org/r/20200223221324.156086-1-xypron.glpk@gmx.de
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 1e79f77d4e6c..41269a95ff85 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -554,7 +554,6 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 		while (prsv) {
 			struct linux_efi_memreserve *rsv;
 			u8 *p;
-			int i;
 
 			/*
 			 * Just map a full page: that is what we will get
-- 
2.17.1

