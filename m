Return-Path: <SRS0=HBNP=B5=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52521C433E1
	for <linux-efi@archiver.kernel.org>; Wed, 19 Aug 2020 09:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC7720639
	for <linux-efi@archiver.kernel.org>; Wed, 19 Aug 2020 09:28:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJg96UPN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgHSJ2o (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 19 Aug 2020 05:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgHSJ2n (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 19 Aug 2020 05:28:43 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0CCC061757;
        Wed, 19 Aug 2020 02:28:43 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 128so11112244pgd.5;
        Wed, 19 Aug 2020 02:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sfALJ3tnvI7h4k/zG4r6toxyODZkz1A4RL+TTCxV1MQ=;
        b=UJg96UPNkqjdaV4Z8G1IDr8c6TPIWfXOxPYd3O0SO5WoJKuI7jCmUbACjWzBZHo9U7
         0c7nnXAgDABQEBuR0un7P4giAqlg814vs3v74WUKa4O3jHlp5d9Peg+8lpFHu6SmfEBX
         T8OsGUc+M40aP4W28v0M6kqxwGgTcZDzMTgzPm2JLXfUdp+3cII65MNQJdmQl8cWud4Z
         k3F0lqNF8NUMnE5OQdYexzBoLJ2mSWn/W7hs6/zxeYfNl58kw70iZIseA4f0limFxE47
         Smr+gNjgXUG+xFLsiOrrxvcHlpMjISJ9qMWHeHAqYXd6oxHVdWktrACBujKwqcrj972f
         mkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sfALJ3tnvI7h4k/zG4r6toxyODZkz1A4RL+TTCxV1MQ=;
        b=IPyyRhnzb1UVApTLyYKUQ/t+YopR3LVLXnLpwE6tvtmfhSFyGhfYHnEaDP3aNRMruE
         Xt2JedL9FxVsuvGcANAGVPzfyvfh1x86gvAICQybO1XsoVyt5n5p+4+geyFNsGxHzvsb
         IijhAQ9MA0XY+CbEtPIuIe+FeX49zwK/usOXJqBCPhHD4MpKqzKvrwH5vZyF+O9KStgD
         3YFZzMjGbk9dZTcav9ZqQ03IjR6vKUqp+voe4+3oRLcdOJMvPSMAgEQ4hFXCGAgUBXGN
         ys0Au3Gu3LmN96xApNpKALxOQr/94GByOKEcBsQ16jbCpqOwo/7R5WXV6AP/tbh35v18
         POdQ==
X-Gm-Message-State: AOAM531B6gldqAib0bJLeryEO5g4WPumqQFmnMAU0Fyh9t0vFqCojbZ2
        TjNI1njgRbNukjjVT+yaZWo=
X-Google-Smtp-Source: ABdhPJx7gzRQZ4ej9DhjQf8YqJN5RJv4x/cQ7y4ijPpmhsFEfzKb+5fPtlTWpjDM8h6ry27HPjOUUg==
X-Received: by 2002:a63:ff18:: with SMTP id k24mr16640114pgi.109.1597829323025;
        Wed, 19 Aug 2020 02:28:43 -0700 (PDT)
Received: from linux-691t.suse.de ([124.11.22.254])
        by smtp.gmail.com with ESMTPSA id y1sm27060156pfl.136.2020.08.19.02.28.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Aug 2020 02:28:42 -0700 (PDT)
From:   "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
X-Google-Original-From: "Lee, Chun-Yi" <jlee@suse.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] efi/efivars: create efivars mount point when get variable services are available
Date:   Wed, 19 Aug 2020 17:28:38 +0800
Message-Id: <20200819092838.11290-1-jlee@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The efivars filesystem depends on GetVariable or GetNextVariable EFI
runtime services. So the /sys/firmware/efi/efivars does not need to be
created when GetVariable and GetNextVariable are not available.

It is useful for userland to determine the availability of efivars
filesystem.

Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 drivers/firmware/efi/efi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index fdd1db025dbf..929fbf4dfd5d 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -404,11 +404,14 @@ static int __init efisubsys_init(void)
 	if (error)
 		goto err_remove_group;
 
-	/* and the standard mountpoint for efivarfs */
-	error = sysfs_create_mount_point(efi_kobj, "efivars");
-	if (error) {
-		pr_err("efivars: Subsystem registration failed.\n");
-		goto err_remove_group;
+	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
+				      EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME)) {
+		/* and the standard mountpoint for efivarfs */
+		error = sysfs_create_mount_point(efi_kobj, "efivars");
+		if (error) {
+			pr_err("efivars: Subsystem registration failed.\n");
+			goto err_remove_group;
+		}
 	}
 
 	if (efi_enabled(EFI_DBG) && efi_enabled(EFI_PRESERVE_BS_REGIONS))
-- 
2.16.4

