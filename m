Return-Path: <SRS0=8H/N=4Z=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DA4C18E7A
	for <linux-efi@archiver.kernel.org>; Sun,  8 Mar 2020 08:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CEFA208CD
	for <linux-efi@archiver.kernel.org>; Sun,  8 Mar 2020 08:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583655037;
	bh=5SC+HI9MHr7LdNhxNxpWEXOBZOuUx1D7HzGLFIUcHFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zApbEFEduUwCDp8qwh1ZhZ3miteNofUPl8PzXwu5/orweRjwT4N9eTXp/AFW1T7w0
	 zHchvB3CB6xaks8YP9jQZZL2ZFaNXYMtP/0NXuGHz+Zr9oeZMIJsAxC/xPp4171fEs
	 ZqKanDpmsbCk6gjVx6eF00HNEgmiloqiVmX/N+Gw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgCHIKd (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 8 Mar 2020 04:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbgCHIKc (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 8 Mar 2020 04:10:32 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05C9320866;
        Sun,  8 Mar 2020 08:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583655032;
        bh=5SC+HI9MHr7LdNhxNxpWEXOBZOuUx1D7HzGLFIUcHFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhVJS+13p9fNy4wznVN9g3m2Xiuio7BAfMyF+tWnM4YCZCiqP6V5Yw4uuP129z5OZ
         Ypbe+DytMbNOAH61N+Ypxfhmo6D2NQYkMN5lFSOnmFc8Xj7ec87jLq2sASQ1FLug85
         Lr3SgZ0p42L7xa/yu35rP41DNOIIG6FCGsOyE+sg=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Christoph Hellwig <hch@lst.de>,
        David Hildenbrand <david@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nikolai Merinov <n.merinov@inango-systems.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH 24/28] efi: add a sanity check to efivar_store_raw()
Date:   Sun,  8 Mar 2020 09:08:55 +0100
Message-Id: <20200308080859.21568-25-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200308080859.21568-1-ardb@kernel.org>
References: <20200308080859.21568-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Vladis Dronov <vdronov@redhat.com>

Add a sanity check to efivar_store_raw() the same way
efivar_{attr,size,data}_read() and efivar_show_raw() have it.

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Link: https://lore.kernel.org/r/20200305084041.24053-3-vdronov@redhat.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efivars.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 485c592d7990..78ad1ba8c987 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -208,6 +208,9 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	u8 *data;
 	int err;
 
+	if (!entry || !buf)
+		return -EINVAL;
+
 	if (in_compat_syscall()) {
 		struct compat_efi_variable *compat;
 
-- 
2.17.1

