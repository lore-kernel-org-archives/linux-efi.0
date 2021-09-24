Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0489CC433EF
	for <linux-efi@archiver.kernel.org>; Fri, 24 Sep 2021 13:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E685261076
	for <linux-efi@archiver.kernel.org>; Fri, 24 Sep 2021 13:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346319AbhIXNvA (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 24 Sep 2021 09:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346438AbhIXNu6 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 24 Sep 2021 09:50:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B51FC0614ED
        for <linux-efi@vger.kernel.org>; Fri, 24 Sep 2021 06:49:25 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632491364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ONl3MV01UsH4T0W2s5TRiHZ+lGL9GNvabRy9wn1vXMs=;
        b=E/VbplaSyB47x1GnwB9PMr4huVZCihIEtP4wbYdAKow8P+idAND9iByjSW9biNO5mMLnwW
        BFmEW7uHk/SbRFEuAgbB3BfaSuTmPDScm/sOFYwTGXx5LycMmlZbcwcYjXEPQtDOM6izi2
        hDQVXpa632yT/u/0OJX+nGXiqxsTBNKZRJ8ftPy9i4eWYxgW+uTWwEwVbWpMfBbrUXFagQ
        8ZGd2CG+XRFo4I9Xc4tDumY8HT9ad40ovQwRkr4HqhVyTopy//W1KGXpfURqejoHEkjExK
        ct1WFymlAo1HiMABVyDgIh/IBLy3M1fCk14HNjiiKzBJpKayqB5iH+E3TyjkLQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632491364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ONl3MV01UsH4T0W2s5TRiHZ+lGL9GNvabRy9wn1vXMs=;
        b=a8CuoSvkISQCS04opwadQMzwUkasoZYPsutI2rVUyTFiYo4seAPFVOriG+DdPSTxhq7rzi
        HLzizn6f1Wj7gzCA==
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] efi: Allow efi=runtime
Date:   Fri, 24 Sep 2021 15:49:19 +0200
Message-Id: <20210924134919.1913476-3-bigeasy@linutronix.de>
In-Reply-To: <20210924134919.1913476-1-bigeasy@linutronix.de>
References: <20210924134919.1913476-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

In case the command line option "efi=3Dnoruntime" is default at built-time,=
 the user
could overwrite its state by `efi=3Druntime' and allow it again.

This is useful on PREEMPT_RT where "efi=3Dnoruntime" is default and the
user might need to alter the boot order for instance.

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/firmware/efi/efi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 39031cfcb6b92..ae79c33001297 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -97,6 +97,9 @@ static int __init parse_efi_cmdline(char *str)
 	if (parse_option_str(str, "noruntime"))
 		disable_runtime =3D true;
=20
+	if (parse_option_str(str, "runtime"))
+		disable_runtime =3D false;
+
 	if (parse_option_str(str, "nosoftreserve"))
 		set_bit(EFI_MEM_NO_SOFT_RESERVE, &efi.flags);
=20
--=20
2.33.0

