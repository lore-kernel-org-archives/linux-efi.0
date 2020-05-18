Return-Path: <SRS0=pLtV=7A=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA07C433E1
	for <linux-efi@archiver.kernel.org>; Mon, 18 May 2020 19:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FE54207FB
	for <linux-efi@archiver.kernel.org>; Mon, 18 May 2020 19:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgERTHa (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 18 May 2020 15:07:30 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33913 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgERTH3 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 18 May 2020 15:07:29 -0400
Received: by mail-qk1-f194.google.com with SMTP id 190so11494842qki.1
        for <linux-efi@vger.kernel.org>; Mon, 18 May 2020 12:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcVOI4bTvGdmseb9izDC28hu18FuF1C8gCQHxtv2LOA=;
        b=W9Jijkh8V9VRQ9abKoc9XoK3vIja5TvvhWmNFH0Zn5il2ZOV1bjjOVU/X3NUSNQloY
         DGQX58Pk/3MxifVNZtgkbsLtl729zczQd7i860i3kNLDsNJmgqEKyQZXQ0jzOB/CkLuh
         kWOuaJx6SKE9kxh5hqHVbT2KI7MyslAQEzN1zwl7Dh7mfvTE19/79Oidg//KDSMRGi08
         +sOokgyyF8BCExrBrjCjt49ULXvStFe+kS5iv6HvubSAIfuJpT+ukJzECZXdxlifgeXV
         SxITIdKKBRfokBcndLrJY/CMf9VNxZTDzEYjp7hdAu9ZpuH7wwqibHvonU1CUgbkeKJ7
         ewpA==
X-Gm-Message-State: AOAM531hhjVV+OW7G3Pyc0fmCzCeDv4RJsqrxm9AUl4to0iDok3FaMAT
        mjeM7sQ/+6sRZHlcN6l0Fc71Id5KjNE=
X-Google-Smtp-Source: ABdhPJxivg1UYhpgmy92eWVrebwvqA90W/S3MFnB9KvV1rD/dcfcxRm6NyG5Q/TjvSQzaqwhnr214A==
X-Received: by 2002:a37:434b:: with SMTP id q72mr18285910qka.352.1589828847969;
        Mon, 18 May 2020 12:07:27 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id a1sm9862811qtj.65.2020.05.18.12.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 12:07:27 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org
Subject: [PATCH 13/24] efi/printf: Handle null string input
Date:   Mon, 18 May 2020 15:07:05 -0400
Message-Id: <20200518190716.751506-14-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518190716.751506-1-nivedita@alum.mit.edu>
References: <20200518190716.751506-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Print "(null)" for 's' if the input is a NULL pointer.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
---
 drivers/firmware/efi/libstub/vsprintf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
index dee9bd068cb6..048276d9c376 100644
--- a/drivers/firmware/efi/libstub/vsprintf.c
+++ b/drivers/firmware/efi/libstub/vsprintf.c
@@ -14,6 +14,7 @@
 
 #include <linux/compiler.h>
 #include <linux/ctype.h>
+#include <linux/limits.h>
 #include <linux/string.h>
 
 static int skip_atoi(const char **s)
@@ -355,7 +356,11 @@ int vsprintf(char *buf, const char *fmt, va_list ap)
 			continue;
 
 		case 's':
+			if (precision < 0)
+				precision = INT_MAX;
 			s = va_arg(args, char *);
+			if (!s)
+				s = precision < 6 ? "" : "(null)";
 			len = strnlen(s, precision);
 
 			if (!(flags & LEFT))
-- 
2.26.2

