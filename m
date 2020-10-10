Return-Path: <SRS0=Bg5U=DR=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B99AC43457
	for <linux-efi@archiver.kernel.org>; Sat, 10 Oct 2020 23:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09BDB20760
	for <linux-efi@archiver.kernel.org>; Sat, 10 Oct 2020 23:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602371470;
	bh=bQ433BPiPH3WV+0TzDf7+XQH/XT77Abe4ID+6OA73Ek=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=NTqN/DGbjfbS8UVuVlbxHzkoyiQzs7atYecc7aqpBiVrCglNr7uqYcXGGS635rbVY
	 N25e6NqZtUibjvQTh/+dn2/sSgXApo7Vx1AoVhKzo3YlWqDTDRfCvRrwF5+2oEj9B4
	 OhZYEDTvl+7xdVBQd5z842KgpK654hBAGG31Qv2o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgJJWz7 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730431AbgJJS5V (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sat, 10 Oct 2020 14:57:21 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE6AE223C7;
        Sat, 10 Oct 2020 16:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602347573;
        bh=bQ433BPiPH3WV+0TzDf7+XQH/XT77Abe4ID+6OA73Ek=;
        h=From:To:Cc:Subject:Date:From;
        b=T4LU2k4OjnDkOWbQtI9lbV2XBKriNYFm/wTWW8Zcz3ua/caxi458ra/brV/aF49ns
         WkL/bSnm2fVJbupA3SlamdDw5IXcLxDJ+MzdTnzgKiLYhCJ49widQ16N9gfBEMRtO3
         +P6Z2B620pdndqUPLU54Ftkl7TFlClE5jJ9WzOBc=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     ardb@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL] Final EFI update for v5.10
Date:   Sat, 10 Oct 2020 18:32:45 +0200
Message-Id: <20201010163245.27655-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The following changes since commit 963fabf37f6a94214a823df0a785e653cb8ad6ea:

  efi: efivars: limit availability to X86 builds (2020-09-29 19:40:57 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v5.10-3

for you to fetch changes up to cc383a9e245c527d3175e2cf4cced9dbbedbbac6:

  efi: mokvar: add missing include of asm/early_ioremap.h (2020-10-02 10:08:29 +0200)

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>

----------------------------------------------------------------
Final ARM build fix for the EFI changes queued up for v5.10

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi: mokvar: add missing include of asm/early_ioremap.h

 drivers/firmware/efi/mokvar-table.c | 2 ++
 1 file changed, 2 insertions(+)
