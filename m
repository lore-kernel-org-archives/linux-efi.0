Return-Path: <SRS0=0j+e=T6=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0456C28CC0
	for <linux-efi@archiver.kernel.org>; Thu, 30 May 2019 23:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E8AA262F4
	for <linux-efi@archiver.kernel.org>; Thu, 30 May 2019 23:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfE3XNr (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 30 May 2019 19:13:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:24907 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfE3XNr (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 30 May 2019 19:13:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 16:13:46 -0700
X-ExtLoop1: 1
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga003.jf.intel.com with ESMTP; 30 May 2019 16:13:46 -0700
Subject: [PATCH v2 7/8] acpi/hmat: Register HMAT at device_initcall level
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-efi@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Keith Busch <keith.busch@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        vishal.l.verma@intel.com, ard.biesheuvel@linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-nvdimm@lists.01.org
Date:   Thu, 30 May 2019 15:59:58 -0700
Message-ID: <155925719885.3775979.7601024961163509938.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155925716254.3775979.16716824941364738117.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155925716254.3775979.16716824941364738117.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

In preparation for registering device-dax instances for accessing EFI
specific-purpose memory, arrange for the HMAT registration to occur
later in the init process. Critically HMAT initialization needs to occur
after e820__reserve_resources_late() which is the point at which the
iomem resource tree is populated with "Application Reserved"
(IORES_DESC_APPLICATION_RESERVED). e820__reserve_resources_late()
happens at subsys_initcall time.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/hmat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/hmat.c b/drivers/acpi/hmat.c
index 2c220cb7b620..1d329c4af3bf 100644
--- a/drivers/acpi/hmat.c
+++ b/drivers/acpi/hmat.c
@@ -671,4 +671,4 @@ static __init int hmat_init(void)
 	acpi_put_table(tbl);
 	return 0;
 }
-subsys_initcall(hmat_init);
+device_initcall(hmat_init);

