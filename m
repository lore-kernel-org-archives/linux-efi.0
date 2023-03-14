Return-Path: <linux-efi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFE2C6FD1C
	for <linux-efi@archiver.kernel.org>; Tue, 14 Mar 2023 12:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjCNMhb (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 14 Mar 2023 08:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCNMh3 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 14 Mar 2023 08:37:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8263353DA7
        for <linux-efi@vger.kernel.org>; Tue, 14 Mar 2023 05:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678797301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LaZViyBTcEd0vXjCFW8utV4q3FTAQStS5kLOwGFHw1U=;
        b=LXXIv7Rg+RUdPcZqjZ4cEAymzZ4pkNdUBGiaLhqL+QGDiFxoLry7wPgtAfjzPC5XzYE3Jd
        no11YQfnaZY2KvV2vQ9XyUNMXwYoXDiZT/RoNyUN4LKRAJX7mZ2uD9wnWym0g2x43EwKyy
        3bywWJw8GHDa5PFM9fcQyqh2lSjdgEU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-uQtxW7hwMcOTgggwOsXEdg-1; Tue, 14 Mar 2023 08:31:14 -0400
X-MC-Unique: uQtxW7hwMcOTgggwOsXEdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05546280A320;
        Tue, 14 Mar 2023 12:31:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.195.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3D7AC158C2;
        Tue, 14 Mar 2023 12:31:12 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Javier Martinez Canillas <javierm@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org
Subject: [PATCH 2/2] efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L
Date:   Tue, 14 Mar 2023 13:31:03 +0100
Message-Id: <20230314123103.522115-2-hdegoede@redhat.com>
In-Reply-To: <20230314123103.522115-1-hdegoede@redhat.com>
References: <20230314123103.522115-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Another Lenovo convertable which reports a landscape resolution of
1920x1200 with a pitch of (1920 * 4) bytes, while the actual framebuffer
has a resolution of 1200x1920 with a pitch of (1200 * 4) bytes.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/firmware/efi/sysfb_efi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
index e76d6803bdd0..456d0e5eaf78 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -272,6 +272,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
 					"IdeaPad Duet 3 10IGL5"),
 		},
 	},
+	{
+		/* Lenovo Yoga Book X91F / X91L */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			/* Non exact match to match F + L versions */
+			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X91"),
+		},
+	},
 	{},
 };
 
-- 
2.39.1

