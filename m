Return-Path: <SRS0=PR+K=ZM=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D37EC432C3
	for <linux-efi@archiver.kernel.org>; Wed, 20 Nov 2019 13:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5E53224FA
	for <linux-efi@archiver.kernel.org>; Wed, 20 Nov 2019 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574257333;
	bh=ImiUar8SpFecCMDnr8VK71R7PTUkzqO+RyLiTn28ha4=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=jCXZws2AMcPvUKgElK/sOS1E3uu0vmaQBwnic5NHRWTFy8x2aLhGTFaExAl2IlS/t
	 g83iD3uQRKlwh23LfJ2L2eIYlP65QFiJTC9xJRxNunPVdO90BF2YzVR2PrT5ELOP9F
	 QEzKzr0BTgDJJR/mzHQOuSe5PBD9dCPiEc9jctBw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbfKTNmI (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730200AbfKTNmG (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 20 Nov 2019 08:42:06 -0500
Received: from localhost.localdomain (unknown [118.189.143.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76FC122528;
        Wed, 20 Nov 2019 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574257325;
        bh=ImiUar8SpFecCMDnr8VK71R7PTUkzqO+RyLiTn28ha4=;
        h=From:To:Cc:Subject:Date:From;
        b=qtyggUEszVHGCy2JsYZqfZIS9QkZa2YGAnfxWo+R+M1qk/HhWKv3fXeUC10SmcoXv
         CYBD/VHiT9dcOT3RPlI/ATGGlmBpVtgIl2pZrUph3V9hmfbqXD7ri1mnVd1XtMXCoc
         Wru/wm1MR5pttRW955JKf1QhH2TWsH9RbC8c5PF4=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH] firmware/efi: Fix Kconfig indentation
Date:   Wed, 20 Nov 2019 21:42:02 +0800
Message-Id: <20191120134202.15531-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:
	$ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/firmware/Kconfig     | 4 ++--
 drivers/firmware/efi/Kconfig | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index e40a77bfe821..312c27876b60 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -86,8 +86,8 @@ config EDD
 	  BIOS tries boot from.  This information is then exported via sysfs.
 
 	  This option is experimental and is known to fail to boot on some
-          obscure configurations. Most disk controller BIOS vendors do
-          not yet implement this feature.
+	  obscure configurations. Most disk controller BIOS vendors do
+	  not yet implement this feature.
 
 config EDD_OFF
 	bool "Sets default behavior for EDD detection to off"
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index bcc378c19ebe..47a3231755d7 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -101,7 +101,7 @@ config EFI_PARAMS_FROM_FDT
 	help
 	  Select this config option from the architecture Kconfig if
 	  the EFI runtime support gets system table address, memory
-          map address, and other parameters from the device tree.
+	  map address, and other parameters from the device tree.
 
 config EFI_RUNTIME_WRAPPERS
 	bool
-- 
2.17.1

