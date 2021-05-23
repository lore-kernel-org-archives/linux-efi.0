Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4793C47081
	for <linux-efi@archiver.kernel.org>; Sun, 23 May 2021 09:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C44C36128E
	for <linux-efi@archiver.kernel.org>; Sun, 23 May 2021 09:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhEWJFp (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 23 May 2021 05:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231636AbhEWJFp (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 23 May 2021 05:05:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1736D61263;
        Sun, 23 May 2021 09:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621760659;
        bh=i/nc1OrlPGzpVH/aTKSspa/XZTXPWeEdFI+EewgSTsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JalCXiYS3YgrmE/TOTd7JFSN5K8cCB7W3doh83aSIZ6m8XhtPXt4n7q+ZLd0bXm+H
         PlckOvxfvj7nXga9VoS675+i/lgi7D/XGcYozsVL+DQRZeg8kOYmPa9M4cdqD3SHot
         DbRVjHk91ywDOTh7eCTAryeOOq8bkHXOHzy8jPVKwE4Kf6sr6muKIf00d3qNzC/IKh
         BBIfesSUip5e22QlR/UoRTJBhK2YA6+s6PcKg3Yuoe0UnOQ4+uxYKjgTwt7lGFuyUV
         dMk9AR1rld8RBw01VzZ0TxS9wu/1RgZqHNH5+uOSjpyjR5oIefnT13XXWYPI+Uf7Ne
         gmsN1LaAJ1WUQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL] EFI updates for v5.14
Date:   Sun, 23 May 2021 11:04:13 +0200
Message-Id: <20210523090413.70225-2-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210523090413.70225-1-ardb@kernel.org>
References: <20210523090413.70225-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The following changes since commit 942859d969de7f6f7f2659a79237a758b42782da:

  efi: cper: fix snprintf() use in cper_dimm_err_location() (2021-05-22 14:05:37 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v5.14

for you to fetch changes up to bb11580f61b6c4ba5c35706abd927c8ac8c32852:

  x86/efi: Log 32/64-bit mismatch with kernel as an error (2021-05-22 14:09:07 +0200)

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>

----------------------------------------------------------------
EFI updates for v5.14

First microbatch of EFI updates - not a lot going on these days.

----------------------------------------------------------------
Andy Shevchenko (1):
      efi/dev-path-parser: Switch to use for_each_acpi_dev_match()

Heikki Krogerus (1):
      efi/apple-properties: Handle device properties with software node API

Paul Menzel (1):
      x86/efi: Log 32/64-bit mismatch with kernel as an error

 arch/x86/platform/efi/efi.c             |  2 +-
 drivers/firmware/efi/apple-properties.c |  2 +-
 drivers/firmware/efi/dev-path-parser.c  | 49 ++++++++++++---------------------
 3 files changed, 20 insertions(+), 33 deletions(-)
