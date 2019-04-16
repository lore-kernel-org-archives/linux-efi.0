Return-Path: <SRS0=bC01=SS=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD83C10F13
	for <linux-efi@archiver.kernel.org>; Tue, 16 Apr 2019 10:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B616206BA
	for <linux-efi@archiver.kernel.org>; Tue, 16 Apr 2019 10:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfDPKAR (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 16 Apr 2019 06:00:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:28749 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbfDPKAR (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 16 Apr 2019 06:00:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Apr 2019 03:00:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,357,1549958400"; 
   d="scan'208";a="143348823"
Received: from jdkarpin-mobl2.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.30.146])
  by fmsmga007.fm.intel.com with ESMTP; 16 Apr 2019 03:00:13 -0700
From:   Rob Bradford <robert.bradford@intel.com>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Rob Bradford <robert.bradford@intel.com>
Subject: [PATCH v2] efi: Check the number of EFI configuration tables entries
Date:   Tue, 16 Apr 2019 10:59:58 +0100
Message-Id: <20190416095958.26163-1-robert.bradford@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Only try and access the EFI configuration tables if there there are any
reported. This allows EFI to be continued to used on systems where there
are no configuration table entries.

v2: Move return on nr_tables==0 earlier

Signed-off-by: Rob Bradford <robert.bradford@intel.com>
---
 arch/x86/platform/efi/quirks.c | 3 +++
 drivers/firmware/efi/efi.c     | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 95e77a667ba5..6b9a4792242b 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -471,6 +471,9 @@ int __init efi_reuse_config(u64 tables, int nr_tables)
 	void *p, *tablep;
 	struct efi_setup_data *data;
 
+	if (nr_tables == 0)
+		return 0;
+
 	if (!efi_setup)
 		return 0;
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 415849bab233..185424a8b879 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -628,6 +628,9 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 	void *config_tables;
 	int sz, ret;
 
+	if (efi.systab->nr_tables == 0)
+		return 0;
+
 	if (efi_enabled(EFI_64BIT))
 		sz = sizeof(efi_config_table_64_t);
 	else
-- 
2.20.1

