Return-Path: <SRS0=+8OP=YW=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE32DCA9EAE
	for <linux-efi@archiver.kernel.org>; Tue, 29 Oct 2019 17:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DADE20679
	for <linux-efi@archiver.kernel.org>; Tue, 29 Oct 2019 17:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572370789;
	bh=seibnrRNRbSPy1J1lWeJMDFnX5JQTvYifsg77MzzXhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Z7o7GXqHpwF+ZJafHgsxWtdPfkVacZnTBOHrxu8snmQNwYiNsDfrVTiOKG27IIq56
	 zRrZjuzMCABD2PBIcmXqViQXRDguQ19P8ZcomCD42sJ0pIni5oviuGDIDhMW+XWMzn
	 6HkmxvSnzgdiiK/Zj3Kp691r/iRZAtWS9agaAzFo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfJ2RjE (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 29 Oct 2019 13:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbfJ2RjE (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 29 Oct 2019 13:39:04 -0400
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr [90.118.215.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4852020856;
        Tue, 29 Oct 2019 17:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572370743;
        bh=seibnrRNRbSPy1J1lWeJMDFnX5JQTvYifsg77MzzXhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZ2+Mf0FboDrCDBF7qwaLAOyhzrruAsrSFoMvn+aY8Q17n7HP4Maxk+1xU+6G19nr
         VPRR+0FDnnfONTcLpHLlfb2mtX3LfECi6+zKM75oKmu7xXC8kztbWB50JLpTt/xJlJ
         QYwKUDYEVUVCqOiPv0X3Yhhl1d0vp4hFqAEJf4eg=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Narendra K <Narendra.K@dell.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] efi: Make CONFIG_EFI_RCI2_TABLE selectable on x86 only
Date:   Tue, 29 Oct 2019 18:37:50 +0100
Message-Id: <20191029173755.27149-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191029173755.27149-1-ardb@kernel.org>
References: <20191029173755.27149-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Narendra K <Narendra.K@dell.com>

For the EFI_RCI2_TABLE kconfig option, 'make oldconfig' asks the user
for input on platforms where the option may not be applicable. This patch
modifies the kconfig option to ask the user for input only when CONFIG_X86
or CONFIG_COMPILE_TEST is set to y.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Narendra K <Narendra.K@dell.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 178ee8106828..b248870a9806 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -182,6 +182,7 @@ config RESET_ATTACK_MITIGATION
 
 config EFI_RCI2_TABLE
 	bool "EFI Runtime Configuration Interface Table Version 2 Support"
+	depends on X86 || COMPILE_TEST
 	help
 	  Displays the content of the Runtime Configuration Interface
 	  Table version 2 on Dell EMC PowerEdge systems as a binary
-- 
2.17.1

