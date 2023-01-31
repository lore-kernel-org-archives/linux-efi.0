Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2571C38142
	for <linux-efi@archiver.kernel.org>; Tue, 31 Jan 2023 04:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjAaEEH (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 30 Jan 2023 23:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjAaEEG (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 30 Jan 2023 23:04:06 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39C5E113CB;
        Mon, 30 Jan 2023 20:04:05 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEF262F4;
        Mon, 30 Jan 2023 20:04:46 -0800 (PST)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.132])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A40E23F64C;
        Mon, 30 Jan 2023 20:04:02 -0800 (PST)
From:   Jia He <justin.he@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Huacai Chen <chenhuacai@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Jia He <justin.he@arm.com>
Subject: [PATCH 0/2] Fix boot hang issue on Ampere Emag server
Date:   Tue, 31 Jan 2023 04:03:53 +0000
Message-Id: <20230131040355.3116-1-justin.he@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

I met a hung task warning and then kernel was hung forever with latest
kernel on an Ampere Emag server.

The root cause is kernel was hung  when invoking an efi rts call to set
the RandomSeed variable during the booting stage. The arch_efi_call_virt
call (set_variable) was never returned and then caused the hung task error.

On the Emag server, efi_rt_services_supported(EFI_RT_SUPPORTED_SET_VARIABLE)
is returned with "true"

Fix it by introducing the efi_get_supported_rt_services() and then determine
to set or clear the runtime services bit of efi.flags.

Jia He (2):
  efi: libstub: Fix the retriving of supported rutime services
  efi: Introduce efi_get_supported_rt_services() to get the runtime
    services mask

 drivers/firmware/efi/arm-runtime.c      |  5 ++++-
 drivers/firmware/efi/efi.c              | 28 +++++++++++++++++--------
 drivers/firmware/efi/libstub/efi-stub.c |  2 ++
 include/linux/efi.h                     |  1 +
 4 files changed, 26 insertions(+), 10 deletions(-)

-- 
2.25.1

