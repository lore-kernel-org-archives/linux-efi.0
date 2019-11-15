Return-Path: <SRS0=3FKS=ZH=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F3CFC43141
	for <linux-efi@archiver.kernel.org>; Fri, 15 Nov 2019 15:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED29220715
	for <linux-efi@archiver.kernel.org>; Fri, 15 Nov 2019 15:36:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZPkZWj3s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfKOPgD (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 15 Nov 2019 10:36:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36225 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727805AbfKOPgD (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 15 Nov 2019 10:36:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573832162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xEBrDdwqBspifEyrKVUN4LwxDIQDuRZSkP0oQyfCJjI=;
        b=ZPkZWj3sQfqRrNN3YzFsAuQQvWMkr53f5+y8qWT2y0k4waTPsgbFjycsIkUG/gRKhKgqoo
        vsNQS6vljYn5SR8Km4k3Dk986Z838mEHI3Dtl3lAzrlHYkPT/VdNB9h+rwDnVFdVm2IJ0i
        VheeRjaBbk02SXlZ0WQAtxJe37Y/wpI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-tcC1Bu11M6aF265k8bJJRw-1; Fri, 15 Nov 2019 10:35:58 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07F69DB8A;
        Fri, 15 Nov 2019 15:35:55 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-154.ams2.redhat.com [10.36.116.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6016E6117E;
        Fri, 15 Nov 2019 15:35:51 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Peter Jones <pjones@redhat.com>,
        Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH v8 5/8] Input: silead - Switch to firmware_request_platform for retreiving the fw
Date:   Fri, 15 Nov 2019 16:35:26 +0100
Message-Id: <20191115153529.215244-6-hdegoede@redhat.com>
In-Reply-To: <20191115153529.215244-1-hdegoede@redhat.com>
References: <20191115153529.215244-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: tcC1Bu11M6aF265k8bJJRw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Unfortunately sofar we have been unable to get permission to redistribute
Silead touchscreen firmwares in linux-firmware. This means that people
need to find and install the firmware themselves before the touchscreen
will work

Some UEFI/x86 tablets with a Silead touchscreen have a copy of the fw
embedded in their UEFI boot-services code.

This commit makes the silead driver use the new firmware_request_platform
function, which will fallback to looking for such an embedded copy when
direct filesystem lookup fails. This will make the touchscreen work OOTB
on devices where there is a fw copy embedded in the UEFI code.

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/input/touchscreen/silead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/silead.c b/drivers/input/touchscreen=
/silead.c
index ad8b6a2bfd36..8fa2f3b7cfd8 100644
--- a/drivers/input/touchscreen/silead.c
+++ b/drivers/input/touchscreen/silead.c
@@ -288,7 +288,7 @@ static int silead_ts_load_fw(struct i2c_client *client)
=20
 =09dev_dbg(dev, "Firmware file name: %s", data->fw_name);
=20
-=09error =3D request_firmware(&fw, data->fw_name, dev);
+=09error =3D firmware_request_platform(&fw, data->fw_name, dev);
 =09if (error) {
 =09=09dev_err(dev, "Firmware request error %d\n", error);
 =09=09return error;
--=20
2.23.0

