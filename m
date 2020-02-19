Return-Path: <SRS0=kHOp=4H=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF15DC34047
	for <linux-efi@archiver.kernel.org>; Wed, 19 Feb 2020 17:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAC032467D
	for <linux-efi@archiver.kernel.org>; Wed, 19 Feb 2020 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582132793;
	bh=pXJDSzIZtMSagSdlfwm+ONGH3QeQ0GQQeVSwpy7bxpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PFbaUZnVrW90RbaN8qVfqcMckDeZ2wij9G+7UgbsVTPAzZ/XQpe6ftELb/4Myyk9f
	 24DWwlQyzTHeRRr+clRu1WQ6UNldqWXN3APZF+hXJxUDEBbxFrIKD4T8AK3nEOd741
	 ajN3ftu/FvOG6VKAINqo1U319XXpOTO6OThkZEJc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgBSRTx (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 19 Feb 2020 12:19:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbgBSRTx (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 19 Feb 2020 12:19:53 -0500
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B21B224676;
        Wed, 19 Feb 2020 17:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582132792;
        bh=pXJDSzIZtMSagSdlfwm+ONGH3QeQ0GQQeVSwpy7bxpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPRNqok1M05ByCjGDFf70xFHDQO0E8tPetVMm3WTkVPN/mSisSRfwVbQcbbYM8Z8+
         z2lc5a2hj6yeXk8TDPQ6/aAS4frvIiTBXlG7ewXS5rtJhOjKd3o7d1CrSGZpUYsyP3
         bKVE7GgNdjGwsaEgDEah8dgr3bHo9zOpuopZlZ1U=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Leif Lindholm <leif@nuviainc.com>,
        Peter Jones <pjones@redhat.com>,
        Alexander Graf <agraf@csgraf.de>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Jeff Brasen <jbrasen@nvidia.com>,
        Atish Patra <Atish.Patra@wdc.com>, x86@kernel.org
Subject: [PATCH 7/9] efi: use EFI ResetSystem only when available
Date:   Wed, 19 Feb 2020 18:19:05 +0100
Message-Id: <20200219171907.11894-8-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219171907.11894-1-ardb@kernel.org>
References: <20200219171907.11894-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Do not attempt to call EFI ResetSystem if the runtime supported mask tells
us it is no longer functional at OS runtime.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/reboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index 7effff969eb9..73089a24f04b 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -15,7 +15,7 @@ void efi_reboot(enum reboot_mode reboot_mode, const char *__unused)
 	const char *str[] = { "cold", "warm", "shutdown", "platform" };
 	int efi_mode, cap_reset_mode;
 
-	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_RESET_SYSTEM))
 		return;
 
 	switch (reboot_mode) {
@@ -64,7 +64,7 @@ static void efi_power_off(void)
 
 static int __init efi_shutdown_init(void)
 {
-	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_RESET_SYSTEM))
 		return -ENODEV;
 
 	if (efi_poweroff_required()) {
-- 
2.17.1

