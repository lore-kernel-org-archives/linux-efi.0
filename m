Return-Path: <SRS0=PY3k=WM=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82D1C3A59E
	for <linux-efi@archiver.kernel.org>; Fri, 16 Aug 2019 15:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA2B52133F
	for <linux-efi@archiver.kernel.org>; Fri, 16 Aug 2019 15:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfHPP5h (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 16 Aug 2019 11:57:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42648 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfHPP5h (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 16 Aug 2019 11:57:37 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hyebf-00047L-7c; Fri, 16 Aug 2019 17:57:35 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] efi: Allow efi=runtime
Date:   Fri, 16 Aug 2019 17:57:28 +0200
Message-Id: <20190816155729.12518-2-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190816155729.12518-1-bigeasy@linutronix.de>
References: <20190816155729.12518-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

In case the option "efi=3Dnoruntime" is default at built-time, the user
could overwrite its state by `efi=3Druntime' and allow it again.

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/firmware/efi/efi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -114,6 +114,9 @@ static int __init parse_efi_cmdline(char
 	if (parse_option_str(str, "noruntime"))
 		disable_runtime =3D true;
=20
+	if (parse_option_str(str, "runtime"))
+		disable_runtime =3D false;
+
 	return 0;
 }
 early_param("efi", parse_efi_cmdline);
