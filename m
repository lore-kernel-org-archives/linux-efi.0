Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C32E9C07E95
	for <linux-efi@archiver.kernel.org>; Tue, 20 Jul 2021 11:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A337C60FDB
	for <linux-efi@archiver.kernel.org>; Tue, 20 Jul 2021 11:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbhGTKfi (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 20 Jul 2021 06:35:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:33405 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237203AbhGTKfg (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 20 Jul 2021 06:35:36 -0400
Received: from ip6-localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 16KBE5N6017585;
        Tue, 20 Jul 2021 06:14:06 -0500
Message-ID: <c71fce9256e9caa7bd3400d525f22380b686d29e.camel@kernel.crashing.org>
Subject: [PATCH 1/2] arm64: efi: kaslr: Fix occasional random alloc (and
 boot) failure
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org Will Deacon" <will@kernel.org>
Date:   Tue, 20 Jul 2021 21:14:05 +1000
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The EFI stub random allocator used for kaslr on arm64 has a subtle
bug. In function get_entry_num_slots() which counts the number of
possible allocation "slots" for the image in a given chunk of free
EFI memory, "last_slot" can become negative if the chunk is smaller
than the requested allocation size.

The test "if (first_slot > last_slot)" doesn't catch it because
both first_slot and last_slot are unsigned.

I chose not to make them signed to avoid problems if this is ever
used on architectures where there are meaningful addresses with the
top bit set. Instead, fix it with an additional test against the
allocation size.

This can cause a boot failure in addition to a loss of randomisation
due to another bug in the arm64 stub fixed separately.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Fixes: 2ddbfc81eac8 (efi: stub: add implementation of efi_random_alloc())
---

 drivers/firmware/efi/libstub/randomalloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/randomalloc.c b/drivers/firmware/efi/libstub/randomalloc.c
index a408df474d83..724155b9e10d 100644
--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -30,6 +30,8 @@ static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
 
 	region_end = min(md->phys_addr + md->num_pages * EFI_PAGE_SIZE - 1,
 			 (u64)ULONG_MAX);
+	if (region_end < size)
+		return 0;
 
 	first_slot = round_up(md->phys_addr, align);
 	last_slot = round_down(region_end - size + 1, align);


