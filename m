Return-Path: <SRS0=CtL2=UV=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE25C43613
	for <linux-efi@archiver.kernel.org>; Sat, 22 Jun 2019 00:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB02120881
	for <linux-efi@archiver.kernel.org>; Sat, 22 Jun 2019 00:05:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AlJqBCOH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfFVAFO (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:05:14 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:41733 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfFVAFN (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 21 Jun 2019 20:05:13 -0400
Received: by mail-pf1-f202.google.com with SMTP id q14so3631014pff.8
        for <linux-efi@vger.kernel.org>; Fri, 21 Jun 2019 17:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RH4r7kndiMZuzkloO60/eV46GQCIwbbHWtivaOQNx8E=;
        b=AlJqBCOH77JCstgkPmGAZLgRUSD9zvatMOj3hlS41EdO8GggJp6HBONVpx/jhauvgq
         8AJYbxCo4G0bCR/ZL4FQ8B8+IWJY2WfIJ1YRwYg5JXFKA/gXZcRwW59UyJpziaVKPJMD
         w/V/JtAWur3tBIDTeoEHR7ZUYTOlGArmeV75OKSfGB53kteVVkiD50m114i64uhrcDHW
         kKiF2N+0rp0kEs0/V6xldaibUNauG2QYFkENtyXQ2vJG3z/F6Xg3uIhwM6tlnXlcDucd
         /iycXpCPysDjGuvfZjg6xm7UFHlgNwKHAPLDV5kfEXLPXmjXQ7Mys9GnXKhb3JR5lTB6
         04eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RH4r7kndiMZuzkloO60/eV46GQCIwbbHWtivaOQNx8E=;
        b=Dcw4MI8vMuNFsbdBqObahaYJGJ5IqB7AjAe5ktmXW6t2Kn5ayabCYB6DOGHxcrU1SR
         kjX3tKB1T263LwhRoLv4hBkz1vWVZw1DIwgVCjH6Qwo/h/ODD8GAT5rjy870L+a1hxR7
         I/koakC587lsj8auR1G9J5xondgQHPDB+SmNlOoKCcg8wmb6N8XgV7Po/KgaywduMHOu
         GpcnhCfQpS0aSpNxJzo7oRibtro6/MG1ExTiCNpctrPaH5uY6olHLefydC2dBz1VrGFi
         M3VvFObuqyrIpVO5HE1ccGwHwfuifYRnml2rbjMTv8oIl7UIh9laGa1u4TlZlLEPwQ0i
         SQgg==
X-Gm-Message-State: APjAAAVYnlEpTI69dOWfqWtiPbC6G3/QVbvP+Y/E98Z68IuGiHCzm6wV
        IGr5Rm9r7UYz5++D/t67M1tPfR9l11TIA/5qK0yZXg==
X-Google-Smtp-Source: APXvYqyVHJVn9d0VYeGJ4jqknCWJTY1KI/Z/06tozEDcOyTsuENI6t9yu2qMQUxyG2gPRdwFuoh5T585JPCvavnyfPVFAQ==
X-Received: by 2002:a63:1d5:: with SMTP id 204mr21711270pgb.207.1561161912148;
 Fri, 21 Jun 2019 17:05:12 -0700 (PDT)
Date:   Fri, 21 Jun 2019 17:03:57 -0700
In-Reply-To: <20190622000358.19895-1-matthewgarrett@google.com>
Message-Id: <20190622000358.19895-29-matthewgarrett@google.com>
Mime-Version: 1.0
References: <20190622000358.19895-1-matthewgarrett@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH V34 28/29] efi: Restrict efivar_ssdt_load when the kernel is
 locked down
From:   Matthew Garrett <matthewgarrett@google.com>
To:     jmorris@namei.org
Cc:     linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Matthew Garrett <matthewgarrett@google.com>,
        Matthew Garrett <mjg59@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

efivar_ssdt_load allows the kernel to import arbitrary ACPI code from an
EFI variable, which gives arbitrary code execution in ring 0. Prevent
that when the kernel is locked down.

Signed-off-by: Matthew Garrett <mjg59@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org
---
 drivers/firmware/efi/efi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 55b77c576c42..9f92a013ab27 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -31,6 +31,7 @@
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
2.22.0.410.gd8fdbe21b5-goog

