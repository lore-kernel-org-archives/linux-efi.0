Return-Path: <SRS0=dwzu=4K=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE53C35672
	for <linux-efi@archiver.kernel.org>; Sat, 22 Feb 2020 01:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E77B02072C
	for <linux-efi@archiver.kernel.org>; Sat, 22 Feb 2020 01:41:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tiWAct/l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgBVBky (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 21 Feb 2020 20:40:54 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:51972 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbgBVBkw (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 21 Feb 2020 20:40:52 -0500
Received: by mail-pl1-f202.google.com with SMTP id 71so2138117plb.18
        for <linux-efi@vger.kernel.org>; Fri, 21 Feb 2020 17:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KcPp0gP7GELHPbQmhvOuNvrhkif2qUrzumcvFBDOK9U=;
        b=tiWAct/lW1qWhKwT1NraZmKOl/hogEF7BkErGRXVit1viyco6ajvbC9mz3kiFMua6i
         TXNq2t+i0wPehD/a08VL1JQQH9Rnr9VR2NEKeEmZ8FLJhmSFDZ0rVirUFv3+tELLG6Gp
         1Odhw8Q7qlUlkq1pZqeqAMwP3dTqnrHwG/aPULh9Zktd5pHO30UGcf0fGZWZPZ85s0Y6
         g5vruuy+o5NmhnAq1Bi7z5UhTM9KxLDhHYWDSFQ31yZ5D0g/dNjltCGyIjGVEk50kOv0
         /sABPtof6x7ACZaNTuqAWywFBrRPUIP1zVHm1SpMLSbhEsUJQJhGbghszJjbeEqYP4d+
         zPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KcPp0gP7GELHPbQmhvOuNvrhkif2qUrzumcvFBDOK9U=;
        b=bHpG7i8f9GtVp69R2bKV/JsIAhPShio9FW4rQVyB2eckhw64RV6DVgrMKTOWW8p3TF
         se9YzZCMXdn5B8o/J4xC/+Z/aU9T0g6v7dIopCGsHYfDZCVt4QboR01CN6tdlqV1rqgq
         ySC8OgHPXW7LobjTyH5xgVBjQ1cWBOg4EYbgkpCy8Mk5LIRDNoL5Q7u+ofD8yQpvwx2u
         /RGvUrvZfMxGOkQNbpLHFG3W8BnnNAPZw9ijUZ9TKOns6bzqSfVk+k859UhMSI2NAT7U
         MbmvumTWWC2JJfJLFOQKuH2Jcum0XQF/+/64q7HhVKAqUBuWnaCTDApzYbmGkMikqsNm
         CM7g==
X-Gm-Message-State: APjAAAVzuNYHXOPWGCAkCqATcdFNkMvpNrhBh9Md4sW4VQHWTcTsvJtS
        OPdGE2qASrbA0wcC3j47HgFMThBk4R/vPCM=
X-Google-Smtp-Source: APXvYqzPdWRjgeOkhSTiaxyK4n8nsnHWWk0aEfT3lTbN5PVbLfvLNibYxGOnd/zAFy69mSlFb3/Z8610AQaog60=
X-Received: by 2002:a63:ec49:: with SMTP id r9mr41310425pgj.445.1582335652146;
 Fri, 21 Feb 2020 17:40:52 -0800 (PST)
Date:   Fri, 21 Feb 2020 17:40:36 -0800
In-Reply-To: <20200222014038.180923-1-saravanak@google.com>
Message-Id: <20200222014038.180923-4-saravanak@google.com>
Mime-Version: 1.0
References: <20200222014038.180923-1-saravanak@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v1 3/5] efi/arm: Start using fw_devlink_get_flags()
From:   Saravana Kannan <saravanak@google.com>
To:     Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Len Brown <lenb@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The fw_devlink_get_flags() provides the right flags to use when creating
mandatory device links derived from information provided by the
firmware. So, use that.

Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/firmware/efi/arm-init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index d99f5b0c8a09..6703bedfa9e1 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -349,7 +349,7 @@ static int efifb_add_links(const struct fwnode_handle *fwnode,
 	 * If this fails, retrying this function at a later point won't
 	 * change anything. So, don't return an error after this.
 	 */
-	if (!device_link_add(dev, sup_dev, 0))
+	if (!device_link_add(dev, sup_dev, fw_devlink_get_flags()))
 		dev_warn(dev, "device_link_add() failed\n");
 
 	put_device(sup_dev);
-- 
2.25.0.265.gbab2e86ba0-goog

