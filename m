Return-Path: <SRS0=7R7h=V4=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79799C433FF
	for <linux-efi@archiver.kernel.org>; Wed, 31 Jul 2019 22:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F003206B8
	for <linux-efi@archiver.kernel.org>; Wed, 31 Jul 2019 22:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NQeE8brz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731434AbfGaWRj (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 31 Jul 2019 18:17:39 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:57299 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731432AbfGaWRj (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 31 Jul 2019 18:17:39 -0400
Received: by mail-vk1-f202.google.com with SMTP id a4so29862953vki.23
        for <linux-efi@vger.kernel.org>; Wed, 31 Jul 2019 15:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BzJTfX0sYPsZSKyjJWnAiNewKfNmb8++vKsSknaZcxY=;
        b=NQeE8brzaM3nBKem2ZVyyY3FlEol8+CrHwKsZLyG2nOLqNXrqwU1ggJ6taMJBGtcvu
         u7ivnCOY/vCLH1PL1/ogOR1ufcUTaOZ5A/mx04CAwV3BoOuxIBirZiRs95dk3JRblihh
         tXPBxMpECDPUl9yY6d9SLCc2j/+TY7PF7+dohxG/zRAacI1a3PqRwnerhdX3/TNysAoS
         v/R6NSDtkIvFt4+d+hrBiGHwm3+8hQa3NyNj3mVZY9VVwj/L7gOlu1B21IDKaq5Gi8qX
         tOMgZItvzzSlRYr4GQVKc1U79UZPz8SKxqxaYhkJRhn4p2NfwVnpKyTpZK6Vvz1uJwiT
         QjVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BzJTfX0sYPsZSKyjJWnAiNewKfNmb8++vKsSknaZcxY=;
        b=G1VTGkY+oUMWypV9tVZtfgLVdA5uL+qCw6Uz3nVFD2R8hbQtIvVaawCRE5ou6vYgxG
         Ri7O6assn5eZ/zkX9xvshzHuS+/YEtcDaZ4Pvx4tpvFotzxGiN2+A6rGQemHfOlxacxQ
         Z32zjL8/t8fMlp1zXZYfGnx57CBjGNcZ38L3X1DhmfFn0gRO5PtqmDRM3nPqID7jxbZO
         lb5oCca/yhyPirgVCXKukghtftxF0LR1EI4XhMONqH5kv7BgciuYRpJF7ad3L4vF57cY
         AKwXZQs4uifrHVJL7SNZVG7tRu5MUPlrrHJ4mDF6YNopoYyO+qj3pkqWSIadGeyzAmy2
         YY2g==
X-Gm-Message-State: APjAAAUlVsE85b/nyiKe2mXV+1efTgR3nWZikl24f1FIt48z0IZfR20y
        DWyt7058Uu9AyC+Yv1Df2JbCeFSbxnorLcriEg97HA==
X-Google-Smtp-Source: APXvYqxXL/N38PSOgMKwgKt2xZvaRoxQEDDLyN7w15v7c2XIakO5nBHL6rYO8tJ55Q7U2Z/pstfcpGH7UN4+XC4dCW0dhQ==
X-Received: by 2002:a67:8907:: with SMTP id l7mr80628361vsd.194.1564611458042;
 Wed, 31 Jul 2019 15:17:38 -0700 (PDT)
Date:   Wed, 31 Jul 2019 15:16:16 -0700
In-Reply-To: <20190731221617.234725-1-matthewgarrett@google.com>
Message-Id: <20190731221617.234725-29-matthewgarrett@google.com>
Mime-Version: 1.0
References: <20190731221617.234725-1-matthewgarrett@google.com>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH V37 28/29] efi: Restrict efivar_ssdt_load when the kernel is
 locked down
From:   Matthew Garrett <matthewgarrett@google.com>
To:     jmorris@namei.org
Cc:     linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Matthew Garrett <matthewgarrett@google.com>,
        Matthew Garrett <mjg59@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kees Cook <keescook@chromium.org>, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

efivar_ssdt_load allows the kernel to import arbitrary ACPI code from an
EFI variable, which gives arbitrary code execution in ring 0. Prevent
that when the kernel is locked down.

Signed-off-by: Matthew Garrett <mjg59@google.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org
---
 drivers/firmware/efi/efi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index ad3b1f4866b3..776f479e5499 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -30,6 +30,7 @@
 #include <linux/acpi.h>
 #include <linux/ucs2_string.h>
 #include <linux/memblock.h>
+#include <linux/security.h>
 
 #include <asm/early_ioremap.h>
 
@@ -242,6 +243,11 @@ static void generic_ops_unregister(void)
 static char efivar_ssdt[EFIVAR_SSDT_NAME_MAX] __initdata;
 static int __init efivar_ssdt_setup(char *str)
 {
+	int ret = security_locked_down(LOCKDOWN_ACPI_TABLES);
+
+	if (ret)
+		return ret;
+
 	if (strlen(str) < sizeof(efivar_ssdt))
 		memcpy(efivar_ssdt, str, strlen(str));
 	else
-- 
2.22.0.770.g0f2c4a37fd-goog

