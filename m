Return-Path: <SRS0=imLm=43=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738F4C18E5B
	for <linux-efi@archiver.kernel.org>; Tue, 10 Mar 2020 13:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B9AC208E4
	for <linux-efi@archiver.kernel.org>; Tue, 10 Mar 2020 13:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583845495;
	bh=vEJRaIWZP1JrsXk0SSZIMme2Ea/tPhjTX/5WV+l20Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BMFt57pTCsvQTknSNEf8tYZy76WSLuuyVgLHTvyVdUnjWM0aasVnEZAdZfCWHqzn4
	 MD9WwO21VNGWAxb60tkm94gKS2EKCyXJPKqosb0+PH4WOExqaJJq/PNRRmvhdsyyAI
	 4IqvRfOKshlFeLERMjCvPLoley0rw2toygGEJQ7k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgCJNEX (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 10 Mar 2020 09:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729287AbgCJNES (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 10 Mar 2020 09:04:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3113F24695;
        Tue, 10 Mar 2020 13:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845457;
        bh=vEJRaIWZP1JrsXk0SSZIMme2Ea/tPhjTX/5WV+l20Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPnghW//FNQbkzXYPb/o+76QpJcXrQKAiKT/JH65oZVMGPEO/Li764EJI+DZXNjn0
         PvtiZTp90WQgOXk3mJdsmNV/KnYrNgFVeolt4PbhM0cn5UATuNw63kUOukySlz/o8q
         twUxij0lKsB4Wih9DyQKoNbfgQB4lUDmg7t06mN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.5 188/189] efi: READ_ONCE rng seed size before munmap
Date:   Tue, 10 Mar 2020 13:40:25 +0100
Message-Id: <20200310123658.428463192@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit be36f9e7517e17810ec369626a128d7948942259 upstream.

This function is consistent with using size instead of seed->size
(except for one place that this patch fixes), but it reads seed->size
without using READ_ONCE, which means the compiler might still do
something unwanted. So, this commit simply adds the READ_ONCE
wrapper.

Fixes: 636259880a7e ("efi: Add support for seeding the RNG from a UEFI ...")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200217123354.21140-1-Jason@zx2c4.com
Link: https://lore.kernel.org/r/20200221084849.26878-5-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/efi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -552,7 +552,7 @@ int __init efi_config_parse_tables(void
 
 		seed = early_memremap(efi.rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = seed->size;
+			size = READ_ONCE(seed->size);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
@@ -562,7 +562,7 @@ int __init efi_config_parse_tables(void
 					      sizeof(*seed) + size);
 			if (seed != NULL) {
 				pr_notice("seeding entropy pool\n");
-				add_bootloader_randomness(seed->bits, seed->size);
+				add_bootloader_randomness(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 			} else {
 				pr_err("Could not map UEFI random seed!\n");


