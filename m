Return-Path: <SRS0=iIKs=4U=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C27C3F2C6
	for <linux-efi@archiver.kernel.org>; Tue,  3 Mar 2020 09:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D51492166E
	for <linux-efi@archiver.kernel.org>; Tue,  3 Mar 2020 09:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583228480;
	bh=RDqMCLqIdI8wJFCMY0CzY1beACA6SkRvqkCn41KnmhI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=oZMrTefmZFzYnAFUj+832GwK6XdUrfNT4Iy4Hs94SJeUVU4TtJDXnMI8sQvLGzPZ9
	 iu5rE0Sv8/N3zjXAh+0dZC0XrgG91r/0r3hlJT/q5UFK9w+UFK7gvf/8esZ+Kt/JPn
	 F9/uD3On2XqmRv7tq1KiJduAhrTtNNTfhxvYPMcI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgCCJlU (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 3 Mar 2020 04:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:47894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgCCJlU (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 3 Mar 2020 04:41:20 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98840208C3;
        Tue,  3 Mar 2020 09:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583228479;
        bh=RDqMCLqIdI8wJFCMY0CzY1beACA6SkRvqkCn41KnmhI=;
        h=From:To:Cc:Subject:Date:From;
        b=v2U4blOHpnl1qVt9NVp3fGNBPRkuHm1sWLaqHSOKz47JNTswsSziSGSanVuGvP2Z0
         0dOBUA/ZWKH9tVtHWZXEtk79sA40ZgMnN7WQYnP3cqVLLF5pH6rbQuVo6nc/7Q8oNM
         VgG+mST1HKl2eP52VFcZgAfKusI9Iwt0LX3rbZuA=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] shared stable branch between EFI, platform/x86 and driver tree
Date:   Tue,  3 Mar 2020 10:41:15 +0100
Message-Id: <20200303094115.7982-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Hi Ingo, Thomas,

Please pull the following changes into the efi/core tree. They will serve
as a shared base between different trees for Hans's work on driver firmware
loaded from EFI boot services memory regions.

The following changes since commit bb6d3fb354c5ee8d6bde2d576eb7220ea09862b9:

  Linux 5.6-rc1 (2020-02-09 16:08:48 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/stable-shared-branch-for-driver-tree

for you to fetch changes up to f0df68d5bae8825ee5b62f00af237ae82247f045:

  efi: Add embedded peripheral firmware support (2020-03-03 10:28:00 +0100)

Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>

----------------------------------------------------------------
Stable shared branch between EFI and driver tree

Stable shared branch to ease the integration of Hans's series to support
device firmware loaded from EFI boot service memory regions.

[PATCH v12 00/10] efi/firmware/platform-x86: Add EFI embedded fw support
https://lore.kernel.org/linux-efi/20200115163554.101315-1-hdegoede@redhat.com/

----------------------------------------------------------------
Hans de Goede (2):
      efi: Export boot-services code and data as debugfs-blobs
      efi: Add embedded peripheral firmware support

 arch/x86/platform/efi/efi.c              |   2 +
 arch/x86/platform/efi/quirks.c           |   4 +
 drivers/firmware/efi/Kconfig             |   5 ++
 drivers/firmware/efi/Makefile            |   1 +
 drivers/firmware/efi/efi.c               |  57 ++++++++++++
 drivers/firmware/efi/embedded-firmware.c | 147 +++++++++++++++++++++++++++++++
 include/linux/efi.h                      |   7 ++
 include/linux/efi_embedded_fw.h          |  41 +++++++++
 8 files changed, 264 insertions(+)
 create mode 100644 drivers/firmware/efi/embedded-firmware.c
 create mode 100644 include/linux/efi_embedded_fw.h
