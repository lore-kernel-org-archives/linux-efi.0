Return-Path: <SRS0=kHOp=4H=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD74BC34056
	for <linux-efi@archiver.kernel.org>; Wed, 19 Feb 2020 17:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC04A24656
	for <linux-efi@archiver.kernel.org>; Wed, 19 Feb 2020 17:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582132797;
	bh=h+tuakNcgoRmbltb5wRmkwf67McBEmqsj9caQdfjLLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XLGbkn5tG2052hQ5xgpKUlS20oIh661Ef84XrY/bb/6MomhgUabpQIjrESrXcqyWU
	 wGd7Uk/dVD7MGGxg848gEGGbgtKUl5Xkpt9V4g16X9MBALJ6ij8Fu0vQUZXewoKSiz
	 6FYxbeKWhf5uZ+FT41uakbpfsGlB1GpoiQ7syQTI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgBSRT5 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 19 Feb 2020 12:19:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgBSRT4 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 19 Feb 2020 12:19:56 -0500
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6941D24680;
        Wed, 19 Feb 2020 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582132795;
        bh=h+tuakNcgoRmbltb5wRmkwf67McBEmqsj9caQdfjLLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEYIGo7HMdb2atbEUkgTmvlk5AGebqyp10o7t+KNvNLe+pTSuPMGBwIOadFPWfXOm
         PRxfjwYsDhT1qWd++yX31ad+WDozEKoBVRtFpA4pPxGr35l0Vld9E/FMhCNxdHZh7k
         K3uscsaA/ECnu48wrWGnwLpo3wbgBQS2VMU36JcA=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Leif Lindholm <leif@nuviainc.com>,
        Peter Jones <pjones@redhat.com>,
        Alexander Graf <agraf@csgraf.de>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Jeff Brasen <jbrasen@nvidia.com>,
        Atish Patra <Atish.Patra@wdc.com>, x86@kernel.org
Subject: [PATCH 8/9] x86/ima: use EFI GetVariable only when available
Date:   Wed, 19 Feb 2020 18:19:06 +0100
Message-Id: <20200219171907.11894-9-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219171907.11894-1-ardb@kernel.org>
References: <20200219171907.11894-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Replace the EFI runtime services check with one that tells us whether
EFI GetVariable() is implemented by the firmware.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/kernel/ima_arch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ima_arch.c b/arch/x86/kernel/ima_arch.c
index 4d4f5d9faac3..cb6ed616a543 100644
--- a/arch/x86/kernel/ima_arch.c
+++ b/arch/x86/kernel/ima_arch.c
@@ -19,7 +19,7 @@ static enum efi_secureboot_mode get_sb_mode(void)
 
 	size = sizeof(secboot);
 
-	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE)) {
 		pr_info("ima: secureboot mode unknown, no efi\n");
 		return efi_secureboot_mode_unknown;
 	}
-- 
2.17.1

