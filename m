Return-Path: <SRS0=qzew=Z4=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C09F2C2BD09
	for <linux-efi@archiver.kernel.org>; Fri,  6 Dec 2019 16:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BB4A206DF
	for <linux-efi@archiver.kernel.org>; Fri,  6 Dec 2019 16:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575651362;
	bh=o08uCHzgAHGv+tapdz95ce96zQ+FlVUziNFbIeIlGG8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=oLotr+0NQSA4rvc2mP+yGNI0eLwwEvsPFCfFtBz0iJeszD4nsza1L2HPDRh3xEe3t
	 9YRb5jB54eHDaEEAOwpxYMnDo1qZiKuClxWQZLErGNXa/YkNeZNkfLodROJirPmfuG
	 GyZg2zy/p0ysXLmKGk7c3IZuO1bflWvYUo0eFUP8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfLFQ4C (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 6 Dec 2019 11:56:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbfLFQ4B (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 6 Dec 2019 11:56:01 -0500
Received: from e123331-lin.cambridge.arm.com (fw-tnat-cam5.arm.com [217.140.106.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB09B2064B;
        Fri,  6 Dec 2019 16:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575651361;
        bh=o08uCHzgAHGv+tapdz95ce96zQ+FlVUziNFbIeIlGG8=;
        h=From:To:Cc:Subject:Date:From;
        b=eJiMK/+1U/GKSOob7WKgQlOsLEXxBiMLINK5xYp/UVPpZbKvAdONSfwup3A233imk
         U8vm5qRsQK0zPL4Bl55k/W8+4BR1Vx2iZRCCCrrIp2tDzFAeO5FOzGr9R0M0gKQ2TW
         q22dbJxVRTVBS0cPhp87d/Cxj7PJ+Dum1uvbpvVM=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Subject: [GIT PULL 0/6] EFI fixes for v5.5
Date:   Fri,  6 Dec 2019 16:55:36 +0000
Message-Id: <20191206165542.31469-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The following changes since commit 2f13437b8917627119d163d62f73e7a78a92303a:

  Merge tag 'trace-v5.5-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace (2019-12-04 19:13:52 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to f74622f872e9cb59cabd89cd908ade976e2269b9:

  efi/earlycon: Remap entire framebuffer after page initialization (2019-12-05 16:40:06 +0000)

----------------------------------------------------------------
Some EFI fixes for the v5.5 cycle:
- Ensure that EFI persistent memory reservations are safe from being
  clobbered by the kexec userland tools by listing them in /proc/iomem
- Reinstate a EFIFB earlycon optimization that got lost when moving the
  code from x86 earlyprintk
- Various fixes for logic bugs in the handling of graphics output by
  the EFI stub.

----------------------------------------------------------------
Andy Shevchenko (1):
      efi/earlycon: Remap entire framebuffer after page initialization

Ard Biesheuvel (1):
      efi/memreserve: register reservations as 'reserved' in /proc/iomem

Arvind Sankar (4):
      efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs
      efi/gop: Return EFI_SUCCESS if a usable GOP was found
      efi/gop: Fix memory leak from __gop_query32/64
      efi: fix type of unload field in efi_loaded_image_t

 drivers/firmware/efi/earlycon.c    | 40 +++++++++++++++++++
 drivers/firmware/efi/efi.c         | 28 ++++++++++++-
 drivers/firmware/efi/libstub/gop.c | 80 +++++++++-----------------------------
 include/linux/efi.h                | 10 ++---
 4 files changed, 90 insertions(+), 68 deletions(-)
