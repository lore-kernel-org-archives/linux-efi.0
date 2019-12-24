Return-Path: <SRS0=cs/k=2O=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43EF2C2D0CF
	for <linux-efi@archiver.kernel.org>; Tue, 24 Dec 2019 13:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FBF720706
	for <linux-efi@archiver.kernel.org>; Tue, 24 Dec 2019 13:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577194185;
	bh=KZGSUwHmGeohaS5c+JhndSQNyEP4Qj6gg5SvZS25hXE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=n04VP/nTidzeu1uqHDOApGxV4Fapg+uJ8Dtv5+eEIrQ0fIw6HFSO21JwUma1YRHMO
	 h+DQeRL27e3rByS7zpgjbfsRKV44f9MemZl7sN8jFVbDwVBz1ch2CVVMK/LNjO7c1b
	 bmqFBV1+U7bMew+PPHBPeV4n5IG8+3+Uj65jRcb8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfLXN3o (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 24 Dec 2019 08:29:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfLXN3o (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 24 Dec 2019 08:29:44 -0500
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net [91.167.84.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FDD720643;
        Tue, 24 Dec 2019 13:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577194183;
        bh=KZGSUwHmGeohaS5c+JhndSQNyEP4Qj6gg5SvZS25hXE=;
        h=From:To:Cc:Subject:Date:From;
        b=1QC00Am48MJBZXQSWkj+/5MWCdVeOfvI2y7VuGjue3DbRm8qPqjD9MTpZecJvOiyZ
         IbkamCbhlaKEzWcpeiww9Hi6wHzB8oOuB5xr5sdvFDtDiV0yZcrvXVGftJvK8wWBHY
         5VJD+prImRPlLYuako6WKWX2oS9Sukpy7X97Q0bU=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [GIT PULL 0/3] EFI fixes for v5.5
Date:   Tue, 24 Dec 2019 14:29:06 +0100
Message-Id: <20191224132909.102540-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The following changes since commit a470552ee8965da0fe6fd4df0aa39c4cda652c7c:

  efi: Don't attempt to map RCI2 config table if it doesn't exist (2019-12-10 12:13:02 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 77217fcc8e04f27127b32825376ed508705fd946:

  x86/efistub: disable paging at mixed mode entry (2019-12-23 16:25:21 +0100)

----------------------------------------------------------------
Some more fixes for the EFI subsystem:
- Ensure that the EFI framebuffer earlycon uses WC attributes on x86 (Arvind)
- Another mixed mode fix from Hans, for the RNG code this time.
- Fix mixed mode boot from OVMF, by disabling paging at entry.

----------------------------------------------------------------
Ard Biesheuvel (1):
      x86/efistub: disable paging at mixed mode entry

Arvind Sankar (1):
      efi/earlycon: Fix write-combine mapping on x86

Hans de Goede (1):
      efi/libstub/random: Initialize pointer variables to zero for mixed mode

 arch/x86/boot/compressed/head_64.S    |  5 +++++
 drivers/firmware/efi/earlycon.c       | 16 +++++++---------
 drivers/firmware/efi/libstub/random.c |  6 +++---
 3 files changed, 15 insertions(+), 12 deletions(-)
