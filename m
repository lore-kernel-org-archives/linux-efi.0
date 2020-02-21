Return-Path: <SRS0=8Umt=4J=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FC6C35640
	for <linux-efi@archiver.kernel.org>; Fri, 21 Feb 2020 08:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D0F32071E
	for <linux-efi@archiver.kernel.org>; Fri, 21 Feb 2020 08:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582274964;
	bh=bapAttMT/RXTqagAhgnEldb9Kde9T0RQHIsyb+9aKdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FCmye+Vew4yYbMrBlc9NpY/D0Hm1bDRNo9oaY3RU/6wL2NnVm6N1v2bUD6zPxjdQQ
	 Fo2pBzme1PVcXLZRnbwT7ihr2PNgcf4VGth23U+enlMTX+tCo9Od0oO14iFwnhiztK
	 SymWsF0z+t/gdceVinOldon88guK9kyd4w8HkxJQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgBUItU (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 21 Feb 2020 03:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730187AbgBUItN (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 21 Feb 2020 03:49:13 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8BF4206DB;
        Fri, 21 Feb 2020 08:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582274952;
        bh=bapAttMT/RXTqagAhgnEldb9Kde9T0RQHIsyb+9aKdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwrhxIc5ImPUfMFuZCzx0x1FVNxLKStzNueuWO4aYvTKENoPEbB1qNMf4KN+FMR4n
         185q0EKJ9GKah2EAOlWcTXgJ9RacCZirm25Ie8QB1OjhgYY0p7ZpnaK516zXPniNCc
         6mL3m11n/pSxfXWCyFA7blprusgUwApOnHyKy0dM=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] efi: READ_ONCE rng seed size before munmap
Date:   Fri, 21 Feb 2020 09:48:49 +0100
Message-Id: <20200221084849.26878-5-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200221084849.26878-1-ardb@kernel.org>
References: <20200221084849.26878-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

This function is consistent with using size instead of seed->size
(except for one place that this patch fixes), but it reads seed->size
without using READ_ONCE, which means the compiler might still do
something unwanted. So, this commit simply adds the READ_ONCE
wrapper.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Fixes: 636259880a7e ("efi: Add support for seeding the RNG from a UEFI ...")
Link: https://lore.kernel.org/r/20200217123354.21140-1-Jason@zx2c4.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 621220ab3d0e..21ea99f65113 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -552,7 +552,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 
 		seed = early_memremap(efi.rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = seed->size;
+			size = READ_ONCE(seed->size);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
@@ -562,7 +562,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 					      sizeof(*seed) + size);
 			if (seed != NULL) {
 				pr_notice("seeding entropy pool\n");
-				add_bootloader_randomness(seed->bits, seed->size);
+				add_bootloader_randomness(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 			} else {
 				pr_err("Could not map UEFI random seed!\n");
-- 
2.17.1

