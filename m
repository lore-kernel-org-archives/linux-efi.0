Return-Path: <SRS0=kHOp=4H=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB50C34047
	for <linux-efi@archiver.kernel.org>; Wed, 19 Feb 2020 15:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7790D2465D
	for <linux-efi@archiver.kernel.org>; Wed, 19 Feb 2020 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582125886;
	bh=6Bb/XDrQj62mgjsnnjc8MUx6FAqHwX/duWE9OWSLzeo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=q8pE1pdBkVGapiqijVEtiTZn+o4XEyGvWxs9PepGTPGWzbLTaTBOOA6DSWBX6/Obl
	 NlxPr4M91gZSd8iGt236FPf2xG+S5Ze4/VvReq0b5yd/DgUwUsSPiOESKUbJVyjdXy
	 yLSU5hv6nI6QYVcK6vB4GvEWhmHAURny64ikv45o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgBSPYq (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 19 Feb 2020 10:24:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbgBSPYq (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 19 Feb 2020 10:24:46 -0500
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F4B424654;
        Wed, 19 Feb 2020 15:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582125885;
        bh=6Bb/XDrQj62mgjsnnjc8MUx6FAqHwX/duWE9OWSLzeo=;
        h=From:To:Cc:Subject:Date:From;
        b=kT0KVK5xLXQvKXUzDzt/U9r0G2ZjNHQ5ZaK4jhH+R/BuO5R38tyxdP8pjZ0+0Q1Rp
         K/7G0boEKlg9eje4ERuwkLHXDcnDXUM1sRScWRSuy2nc1FIHwYts7QyAswRcGlVWVN
         21mRYOfplaOqTBb1eD7bL4gxiRA65JStMmgo+IHQ=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, atish.patra@wdc.com,
        leif@nuviainc.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/3] efi/arm: refactor DT EFI param parsing 
Date:   Wed, 19 Feb 2020 16:24:37 +0100
Message-Id: <20200219152440.11561-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

In preparation for another arrival (RISC-V), do some janitorial work on
the FDT param parsing code for EFI as well. The code sits in an #ifdef
block in efi.c, which is usually a good indicator that it should be moved
into its own source file. Then, we simplify the DT handling, by switching
to the FDT library, instead of going through the more high level early OF
enumeration code, which in our case will be doing libfdt calls under the
hood as well, as EFI on ARM specifically uses *flattened* DT. (note that
the EFI stub for ARM uses libfdt as well to populate the DT properties
that we read back here)

Ard Biesheuvel (3):
  efi/arm: move FDT param discovery code out of efi.c
  efi/arm: move FDT specific definitions into fdtparams.c
  efi/arm: rewrite FDT param discovery routines

 drivers/firmware/efi/Makefile    |   1 +
 drivers/firmware/efi/arm-init.c  |  17 +--
 drivers/firmware/efi/efi.c       | 135 --------------------
 drivers/firmware/efi/fdtparams.c | 125 ++++++++++++++++++
 include/linux/efi.h              |  10 +-
 5 files changed, 133 insertions(+), 155 deletions(-)
 create mode 100644 drivers/firmware/efi/fdtparams.c

-- 
2.17.1

