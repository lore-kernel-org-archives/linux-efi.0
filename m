Return-Path: <SRS0=vceF=Y7=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8771AC5DF60
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 15:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C2F621D6C
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573139455;
	bh=Qkglv5lZHVxnBcuUB4qmpT6t2JaTNwYPtliF7VcRcwI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Iyv5eQnYnzO0ryIhaPcJYEqGczjeADR/gop8onFAMQ04E512gm2/dI9PQ/Hh5gy6x
	 IlSXf1khyh63iD0hc6w1z4d2VVm2kENZJRZ/djdtAYXX5YtFcRzVuXHLIE9NU28RU4
	 3PMvj2Mr2qzMswYK3uEymoMEvpEL1JnK0qv8LMbs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbfKGPKz (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 7 Nov 2019 10:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388215AbfKGPKy (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 7 Nov 2019 10:10:54 -0500
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr [90.118.215.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0F08207FA;
        Thu,  7 Nov 2019 15:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573139454;
        bh=Qkglv5lZHVxnBcuUB4qmpT6t2JaTNwYPtliF7VcRcwI=;
        h=From:To:Cc:Subject:Date:From;
        b=YH6i2pz8mdC87AGoSELTm3qNQmdhv7s4badW59RvW9uVOCWXGU5Or8rhwvc7JKYIu
         CwqzwmSLsYOwuwooogQv/RIiuGuGseendiUrjn2AXXfhkE9C9ee7N3NZJDHd4ioh/D
         SQAMISj+G+InMRoiVxSneOdlXHbvuGCx92nUvE7M=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Zou Cao <zoucao@linux.alibaba.com>
Subject: [GIT PULL 0/4] EFI updates for v5.5
Date:   Thu,  7 Nov 2019 16:10:32 +0100
Message-Id: <20191107151036.5586-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The following changes since commit a99d8080aaf358d5d23581244e5da23b35e340b9:

  Linux 5.4-rc6 (2019-11-03 14:07:26 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to d99c1ba6a73b9e93e2884b7893fe19e3c082ba03:

  efi: libstub/tpm: enable tpm eventlog function for ARM platforms (2019-11-07 10:18:45 +0100)

----------------------------------------------------------------
EFI changes for v5.5:
- Change my email address to @kernel.org so I am no longer at the mercy of
  useless corporate email infrastructure
- Wire up the EFI RNG code for x86. This enables an additional source of
  entropy during early boot.
- Enable the TPM event log code on ARM platforms.

----------------------------------------------------------------
Ard Biesheuvel (1):
      MAINTAINERS: update Ard's email address to @kernel.org

Dominik Brodowski (2):
      efi/random: use arch-independent efi_call_proto()
      x86: efi/random: Invoke EFI_RNG_PROTOCOL to seed the UEFI RNG table

Xinwei Kong (1):
      efi: libstub/tpm: enable tpm eventlog function for ARM platforms

 .mailmap                                |  1 +
 MAINTAINERS                             |  8 ++++----
 arch/x86/boot/compressed/eboot.c        |  3 +++
 drivers/firmware/efi/libstub/Makefile   |  5 +++--
 drivers/firmware/efi/libstub/arm-stub.c |  2 ++
 drivers/firmware/efi/libstub/efistub.h  |  2 --
 drivers/firmware/efi/libstub/random.c   | 23 ++++++++++++++++++-----
 include/linux/efi.h                     |  2 ++
 8 files changed, 33 insertions(+), 13 deletions(-)
