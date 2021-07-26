Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B173C4338F
	for <linux-efi@archiver.kernel.org>; Mon, 26 Jul 2021 14:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0541460F51
	for <linux-efi@archiver.kernel.org>; Mon, 26 Jul 2021 14:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbhGZOLm (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 26 Jul 2021 10:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234584AbhGZOLg (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 26 Jul 2021 10:11:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E27560F38;
        Mon, 26 Jul 2021 14:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627311125;
        bh=gnNV9EQh5IiAr/CAJwM4mhUxm5MFeqtQobkTnzPl3xY=;
        h=From:To:Cc:Subject:Date:From;
        b=b9noUNYyiBx8XArgoI8M/kRI+NdgOoRaOer1f7md1ZGsUuC5Qx84mhGfpr7OHNhZz
         xR9u4PR54/D56C11roNCSu3LMH/ind4iojCbBUTp1Ioh8ddmHdPEy+vCcv4cajdRb7
         MiFFtXt6oSEQkKhfqbbmFQdXmHBq4iuw5EZ/IyigPdxRoufarpLuvgm7ejnLOH7UEu
         ev73pKsrKnnzftiqtpX2Bgg0MdYe2mroR/QyoitMlByiMYf1+/XQEfC+TbgmPx7YB3
         RUPukmSzqDzy5YfsJQWjEVSRVLR0LiutIMAvcFxuQiLQvOEruk4snkMBWBPNjiRJDQ
         4Nt0vi/UucSEg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v3 0/4] efi/arm64: work around Image placement issues
Date:   Mon, 26 Jul 2021 16:51:52 +0200
Message-Id: <20210726145156.12006-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Ben reported that distro GRUB may fail to boot in some circumstances,
and tracked it down to an issue in the way distro GRUB allocates space
for the image. Due to an oversight (addressed in patch #2), this
condition is rarely triggered, but let's work around it in any case (#1)

Remaining patches add further warnings for conditions that are unlikely
to occur, but should not be ignored.

Build tested only.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Ard Biesheuvel (4):
  efi/libstub: arm64: Force Image reallocation if BSS was not reserved
  efi/libstub: arm64: Relax 2M alignment again for relocatable kernels
  efi/libstub: arm64: Warn when efi_random_alloc() fails
  efi/libstub: arm64: Double check image alignment at entry

 drivers/firmware/efi/libstub/arm64-stub.c | 71 +++++++++++++++++---
 1 file changed, 61 insertions(+), 10 deletions(-)

-- 
2.20.1

