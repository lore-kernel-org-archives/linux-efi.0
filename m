Return-Path: <SRS0=w/lh=ZZ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,PDS_BTC_ID,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CB4C432C0
	for <linux-efi@archiver.kernel.org>; Tue,  3 Dec 2019 12:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D0E12073C
	for <linux-efi@archiver.kernel.org>; Tue,  3 Dec 2019 12:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575374980;
	bh=HLDxHA3u6zPkA2L16cd+TIrnIq/ec/amOCKSyTzNINA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=iyInhZGnBovLT+LlDxRyzwykKwHag609xlRJ5vEkslZzE+17CEN3VhCKCKOO9NYD6
	 zKW7RV9Px70i7koNfp4nZGQp3EimDGSwq55WZhZYgFTu6D+9V1f1enU5qtoYZoq212
	 ZG+4Ht3q2VfDryRwJbLpnaO5nbVwfiC3PWueDTS8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfLCMJk (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 3 Dec 2019 07:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbfLCMJk (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 3 Dec 2019 07:09:40 -0500
Received: from e123331-lin.cambridge.arm.com (fw-tnat-cam5.arm.com [217.140.106.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 313F3206EC;
        Tue,  3 Dec 2019 12:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575374979;
        bh=HLDxHA3u6zPkA2L16cd+TIrnIq/ec/amOCKSyTzNINA=;
        h=From:To:Cc:Subject:Date:From;
        b=0aqxQRQQMi4A6lW+SzviNDpHyP8y95CWHyDkHQfyQ8TdHG/CkzreQi9kQ8xs5aFxY
         S4LwA1GXUVOTXKnv6/vVnufU82An+JWdNQs4hNTc49sqepTOrWCcL+yn+NLzzTctbk
         xcYMReIIjaBi3DxNj7QgwBsSSZ6u2Cwu4eruLUxk=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        james.morse@arm.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/2] efi: simplify property table handling on ARM
Date:   Tue,  3 Dec 2019 12:09:15 +0000
Message-Id: <20191203120917.25981-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Instead of sorting the memory map and comparing the placement and
type of adjacent entries in the EFI memory map, which was implemented
to prevent breakage when the pointless and deprecated UEFI property
table feature is provided by the firmware, boot with a 1:1 mapping
for runtime services in this case, which works around the issue as
well.

Also, move the code that handles this feature into arch/x86, which
is the only architecture which is known to have shipped systems with
this feature enabled.

Ard Biesheuvel (2):
  efi/arm64: use 1:1 mapping of RT services if property table exists
  efi: move handling of properties table to x86 specific code

 arch/x86/platform/efi/efi.c             |  22 ++++-
 drivers/firmware/efi/efi.c              |  19 ----
 drivers/firmware/efi/libstub/Makefile   |   1 -
 drivers/firmware/efi/libstub/arm-stub.c | 103 ++++++--------------
 include/linux/efi.h                     |   1 -
 5 files changed, 50 insertions(+), 96 deletions(-)

-- 
2.17.1

