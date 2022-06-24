Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A84CCA480
	for <linux-efi@archiver.kernel.org>; Fri, 24 Jun 2022 15:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiFXPXt (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 24 Jun 2022 11:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiFXPXs (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 24 Jun 2022 11:23:48 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E11E4ECD8;
        Fri, 24 Jun 2022 08:23:47 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C4161480;
        Fri, 24 Jun 2022 08:23:47 -0700 (PDT)
Received: from usa.arm.com (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 015693F534;
        Fri, 24 Jun 2022 08:23:45 -0700 (PDT)
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jose Marinho <jose.marinho@arm.com>
Subject: [PATCH 2/3] ACPI: Enable Platform Runtime Mechanism(PRM) support on ARM64
Date:   Fri, 24 Jun 2022 16:23:30 +0100
Message-Id: <20220624152331.4009502-3-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220624152331.4009502-1-sudeep.holla@arm.com>
References: <20220624152331.4009502-1-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

There is interest to make use of PRM(Platform Runtime Mechanism) even on
ARM64 ACPI platforms. Allow PRM to be enabled on ARM64 platforms. It will
be enabled by default as on x86_64.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 drivers/acpi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 1e34f846508f..d08b7408f0a5 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -592,7 +592,7 @@ config X86_PM_TIMER
 
 config ACPI_PRMT
 	bool "Platform Runtime Mechanism Support"
-	depends on EFI && X86_64
+	depends on EFI && (X86_64 || ARM64)
 	default y
 	help
 	  Platform Runtime Mechanism (PRM) is a firmware interface exposing a
-- 
2.36.1

