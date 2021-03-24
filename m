Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B66CC433C1
	for <linux-efi@archiver.kernel.org>; Wed, 24 Mar 2021 14:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF64561A0B
	for <linux-efi@archiver.kernel.org>; Wed, 24 Mar 2021 14:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbhCXOyy (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbhCXOyo (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 24 Mar 2021 10:54:44 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714FAC061763;
        Wed, 24 Mar 2021 07:54:44 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g15so17506248pfq.3;
        Wed, 24 Mar 2021 07:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CufDcifXJ/Uw1uQF2MtqEN59mHDmcpw3pDeu/OCHXuI=;
        b=NMI/8mZsAFtn4rGLJDdt4uI60SXiuSobOtyQ1C3pPCL2dNlWeKjvSGFfJcqzXVlGmU
         KCCuZTI27pUOPSLYJx5bNVTbz+m98LwlSHZJ22hXll0KxgtKbJBef7HChSkw/nLMYZ0P
         rWuWvFI4c0by3k7hE/kWE2yK1VUsuvpZFDl1GIfaB935OW4E3vRrPZcAfZJRzPuBVlNg
         RmhVxpboP3uOoABY6o0yjlGTKIIepna8NOLIKLEJP3oK95kUw7hdN/lH7wwYxP8JFWFV
         //3msJI5OyLlRHDbSrqTB1ccaeTp1ihXLQChB6/gI+vo7++SWMppLuPBCJ6WyUGufMlX
         lUfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CufDcifXJ/Uw1uQF2MtqEN59mHDmcpw3pDeu/OCHXuI=;
        b=Fdqc6HzTsFHdvVSZYgH+xd9WjiF8jttElXcYAc63T5hYvu4h5o6nZvRU22ztoIk0OA
         fWyBlCNRNEBAi2nWFOB+pyPRuAuYw7XlJo8YCkbPE70y7VVuZ2ugFfi9yzJHKLjPkL8E
         Lnq9jyjsHMJdwnZhm5Mk5FjRDjJNIIfr5+IMFhRUJu0FnzqA0UOU1+jwCpZhSeBZ2pjL
         /LzR0+k/xLUO4GFuWAK1FMi8tB7cpp5c3dwit9t3r//13q+xW3LX5Fv/Sxr5LN/lcxVe
         vlXokls3DtrM6rGkLA1hOu4F67cdPNwqmGuwo1WZGF971S12XSpY+kJMXVCXJHrU4gJN
         Hu+g==
X-Gm-Message-State: AOAM532tF3zQseiejrdMbWh5PPCZM/94TloJoUW+BcwyP3YRsgS+sCkR
        QGlhT0R+jAeIO4e4wkM+zNw=
X-Google-Smtp-Source: ABdhPJzArfH3pudnKs7NPxDCX6a9ScNLeEL7DmmSPKaMZnxnu2VDKOHt2fGAmbYigt2mdZAkxoO/Pg==
X-Received: by 2002:a63:4502:: with SMTP id s2mr3555241pga.94.1616597684005;
        Wed, 24 Mar 2021 07:54:44 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id o1sm2770116pjp.4.2021.03.24.07.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 07:54:43 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>
Subject: [PATCH] efi/fdt: fix panic when no valid fdt found
Date:   Wed, 24 Mar 2021 22:54:35 +0800
Message-Id: <20210324145435.19753-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

setup_arch() would invoke efi_init()->efi_get_fdt_params(). If no
valid fdt found then initial_boot_params will be null. So we
should stop further fdt processing here. I encountered this
issue on risc-v.

Signed-off-by: Changbin Du <changbin.du@gmail.com>
---
 drivers/firmware/efi/fdtparams.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/fdtparams.c b/drivers/firmware/efi/fdtparams.c
index bb042ab7c2be..e901f8564ca0 100644
--- a/drivers/firmware/efi/fdtparams.c
+++ b/drivers/firmware/efi/fdtparams.c
@@ -98,6 +98,9 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
 	BUILD_BUG_ON(ARRAY_SIZE(target) != ARRAY_SIZE(name));
 	BUILD_BUG_ON(ARRAY_SIZE(target) != ARRAY_SIZE(dt_params[0].params));
 
+	if (!fdt)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
 		node = fdt_path_offset(fdt, dt_params[i].path);
 		if (node < 0)
-- 
2.30.2

