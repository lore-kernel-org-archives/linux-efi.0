Return-Path: <SRS0=3aIX=7C=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764ACC433DF
	for <linux-efi@archiver.kernel.org>; Wed, 20 May 2020 21:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48FE020823
	for <linux-efi@archiver.kernel.org>; Wed, 20 May 2020 21:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590010382;
	bh=lEGVH641CKUJvebvQobI9pOc/m43hhJIu1Jj9AP1Ueg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=QFJW/7xdfOg+bk9UOya1yB1ev+WJ+2s22PJr2reA08LmHTSDDOPM6bgMLL3aDSM31
	 c1C7hOkmgoL/wfaJts6ONPMMbKeKNPPYAf5h3+yCCnBaDNyoVY43tEU0ruPE2sVY7w
	 PQAg+D2Pj6YaDMjjKOBZhNQ1Txa7ZNAJ0J3h2irk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgETVdC (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 20 May 2020 17:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgETVdB (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 20 May 2020 17:33:01 -0400
Received: from e123331-lin.nice.arm.com (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82905207F9;
        Wed, 20 May 2020 21:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590010381;
        bh=lEGVH641CKUJvebvQobI9pOc/m43hhJIu1Jj9AP1Ueg=;
        h=From:To:Cc:Subject:Date:From;
        b=15GC8tigoyxpJQpHMpX+pH6fS2ipKa1JQkP+/RHvscumr/tBBl10Vs59ThKeBkIRH
         GsWyeztMGVgCWtDAI7sK+jNBBFodTohnWrubkM5DCu5/f1HZFODdhztJP2Na7hgOxy
         01obYBJgfZgrBbNxzXGEbueZAjTolkEKr5W8HTZw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux+pull@armlinux.org.uk
Subject: [GIT PULL v2] ARM: simplify handover from UEFI to decompressor
Date:   Wed, 20 May 2020 23:32:56 +0200
Message-Id: <20200520213256.16004-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Hello Russell,

As discussed in the context of Geert's reverted v6 of the DTB memory
node discovery patch [0], EFI boot is one possible workaround for systems
where the base of memory is not a round multiple of 128 MB. U-boot today
supports the bootefi command out of the box, so this does not require any
special firmware.

So please pull the changes below for v5.8

[0] https://lore.kernel.org/linux-arm-kernel/20200429082120.16259-1-geert+renesas@glider.be/

The following changes since commit a780e485b5768e78aef087502499714901b68cc4:

  ARM: 8971/1: replace the sole use of a symbol with its definition (2020-04-29 13:30:20 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git tags/efi-arm-no-relocate-for-rmk

for you to fetch changes up to d0f9ca9be11f25ef4151195eab7ea36d136084f6:

  ARM: decompressor: run decompressor in place if loaded via UEFI (2020-05-19 18:23:22 +0200)

----------------------------------------------------------------
Simplify EFI handover to decompressor

The EFI stub in the ARM kernel runs in the context of the firmware, which
means it usually runs with the caches and MMU on. Currently, we relocate
the zImage so it appears in the first 128 MiB, disable the MMU and caches
and invoke the decompressor via its ordinary entry point. However, since we
can pass the base of DRAM directly, there is no need to relocate the zImage,
which also means there is no need to disable and re-enable the caches and
create new page tables etc.

This also allows systems whose DRAM start address is not a round multiple
of 128 MB to decompress the kernel proper to the base of memory, ensuring
that all memory is usable at runtime.

----------------------------------------------------------------
Ard Biesheuvel (5):
      ARM: decompressor: move headroom variable out of LC0
      ARM: decompressor: split off _edata and stack base into separate object
      ARM: decompressor: defer loading of the contents of the LC0 structure
      ARM: decompressor: move GOT into .data for EFI enabled builds
      ARM: decompressor: run decompressor in place if loaded via UEFI

 arch/arm/boot/compressed/head.S           | 79 +++++++++++++------------------
 arch/arm/boot/compressed/vmlinux.lds.S    |  5 ++
 drivers/firmware/efi/libstub/arm32-stub.c | 45 +++---------------
 3 files changed, 43 insertions(+), 86 deletions(-)
