Return-Path: <SRS0=JpIZ=6W=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E34C38A2A
	for <linux-efi@archiver.kernel.org>; Fri,  8 May 2020 18:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B141B2184D
	for <linux-efi@archiver.kernel.org>; Fri,  8 May 2020 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588960995;
	bh=oMjpzDDlh2D1GE9o+Fjd+U1ibu0bpncO6VpG1sd997M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1o5meq27AESgynnystoIjxKqwMSiGevRkovSr1cYfbatKnydNdBQcfNTt8t0znrJr
	 0OKqwWj6ipEJ1Kt3f6j++bEYYNUnDxgwMGIyyfORwqPqrkLpruzpJR4xo319IBCS08
	 QKXuNMkH7XYHp6CV1jHCdQLsnSB2o9iy9BPU6Xuk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgEHSCj (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 8 May 2020 14:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgEHSCi (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 8 May 2020 14:02:38 -0400
Received: from e123331-lin.nice.arm.com (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D607924966;
        Fri,  8 May 2020 18:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588960958;
        bh=oMjpzDDlh2D1GE9o+Fjd+U1ibu0bpncO6VpG1sd997M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhj4MoXdUqj8yzhTUGgvYW+H0XQoe3/Zz/3lcPtHgGzEURkTg/ySvKnHgAhDpdIAT
         ui9qEe1p+jXCZ8SXhTjYbLI9CWaS8bLjiMQuuLfr9iarzNy5EmjKtg79eA5mcLQySl
         8ZhIsUrSnWMc/6AO6TpyTfZ2WNec59jI7H7slTio=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 07/15] efi/libstub: Upgrade ignored dtb= argument message to error
Date:   Fri,  8 May 2020 20:01:49 +0200
Message-Id: <20200508180157.1816-8-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200508180157.1816-1-ardb@kernel.org>
References: <20200508180157.1816-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

Use efi_err if we ignore a command-line dtb= argument, so that it shows
up even on a quiet boot.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Link: https://lore.kernel.org/r/20200430182843.2510180-8-nivedita@alum.mit.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 72ffd2670f99..cb02e8bb6b44 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -241,7 +241,7 @@ efi_status_t efi_entry(efi_handle_t handle, efi_system_table_t *sys_table_arg)
 	if (!IS_ENABLED(CONFIG_EFI_ARMSTUB_DTB_LOADER) ||
 	     secure_boot != efi_secureboot_mode_disabled) {
 		if (strstr(cmdline_ptr, "dtb="))
-			efi_info("Ignoring DTB from command line.\n");
+			efi_err("Ignoring DTB from command line.\n");
 	} else {
 		status = efi_load_dtb(image, &fdt_addr, &fdt_size);
 
-- 
2.17.1

