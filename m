Return-Path: <SRS0=pOKh=4W=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920D5C3F2D1
	for <linux-efi@archiver.kernel.org>; Thu,  5 Mar 2020 08:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E451208CD
	for <linux-efi@archiver.kernel.org>; Thu,  5 Mar 2020 08:41:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dk4YdkzT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgCEIlz (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 5 Mar 2020 03:41:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21078 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726390AbgCEIlz (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 5 Mar 2020 03:41:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583397714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qTt+sb/R1m5KV+j3++5Y1R9izPSSnxWSHBF4kFcR3H8=;
        b=dk4YdkzT69sRgPecu0w+kA9O9W/Oye6ClyaniG6mnZpEAooSmbYvGR3Ru9TQsflWbae5lo
        64BddvqkRV4p5R6+iFNlxLFn8Z85QghNNYzPLPRsQrAI1zmPSyMQvsvnlYU4m2TARaFhEt
        Bi7994wciNiAAXWdM0mRdrRXeUmhZ2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-GCKAEdzONp2JBsA7OFk58w-1; Thu, 05 Mar 2020 03:41:49 -0500
X-MC-Unique: GCKAEdzONp2JBsA7OFk58w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0DD0100550E;
        Thu,  5 Mar 2020 08:41:48 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-204-231.brq.redhat.com [10.40.204.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5278B46;
        Thu,  5 Mar 2020 08:41:44 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org,
        joeyli <jlee@suse.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] efi: add a sanity check to efivar_store_raw()
Date:   Thu,  5 Mar 2020 09:40:40 +0100
Message-Id: <20200305084041.24053-3-vdronov@redhat.com>
In-Reply-To: <20200305084041.24053-1-vdronov@redhat.com>
References: <CAKv+Gu_3ZRRcoAcLTVVQe26q5x9KALmztaNQF=e=KqWaAwxtpA@mail.gmail.com>
 <20200305084041.24053-1-vdronov@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Add a sanity check to efivar_store_raw() the same way
efivar_{attr,size,data}_read() and efivar_show_raw() have it.

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 drivers/firmware/efi/efivars.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivar=
s.c
index 69f13bc4b931..aff3dfb4d7ba 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -208,6 +208,9 @@ efivar_store_raw(struct efivar_entry *entry, const ch=
ar *buf, size_t count)
 	u8 *data;
 	int err;
=20
+	if (!entry || !buf)
+		return -EINVAL;
+
 	if (in_compat_syscall()) {
 		struct compat_efi_variable *compat;
=20
--=20
2.20.1

