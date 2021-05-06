Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DA9C433B4
	for <linux-efi@archiver.kernel.org>; Thu,  6 May 2021 12:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F9EE61132
	for <linux-efi@archiver.kernel.org>; Thu,  6 May 2021 12:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhEFMA6 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 6 May 2021 08:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbhEFMA6 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 6 May 2021 08:00:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FADC061574;
        Thu,  6 May 2021 05:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=avXjQyyXyzGS9m4LwVGQpHuFukA7i1ettBlXqzydNzE=; b=bEK/2its/QQiHchGAImUAgKNMm
        QYYl/fokc2O6xjVb88qk2Aihwou9aABdHNQT+aYSiVKhdwaj5cbFaV4FiBL/tzAECFrXSMGp+b0Kz
        jKrimyr2mnQZxNxlqYrxfjOf6kTGRFkx6WvD64lWMeu0/HUf15ZV9B2/cslLxgLreSmCcXXXvQtdJ
        +d7k+c9QjCRdUJ9CGtQKziK40Y43Ah8HWIU6B2mhBhfPzacb6/SvLvZHTGuJi0y4VJ7/Ct2Qc0BsL
        z4wMYhGAemIilm2vWPrDR+H5Jl+cj7NX/CKiv76qXV3gv+mRsrmIwH8PwLSjApYTDtrUBLo/wJPye
        Y1x+iyog==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lecdy-001fSz-Rj; Thu, 06 May 2021 11:58:42 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-efi@vger.kernel.org, debian-efi@lists.debian.org,
        debian-kernel@lists.debian.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        efi@lists.einval.com, mjg59@srcf.ucam.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-kbuild@vger.kernel.org
Subject: [PATCH] builddeb: Support signing kernels with a Machine Owner Key
Date:   Thu,  6 May 2021 12:58:12 +0100
Message-Id: <20210506115813.397657-1-willy@infradead.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

If the config file specifies a signing key, use it to sign
the kernel so that machines with SecureBoot enabled can boot.
See https://wiki.debian.org/SecureBoot

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 scripts/package/builddeb | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 91a502bb97e8..4fa6ff2b5cac 100755
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -147,7 +147,15 @@ else
 	cp System.map "$tmpdir/boot/System.map-$version"
 	cp $KCONFIG_CONFIG "$tmpdir/boot/config-$version"
 fi
-cp "$($MAKE -s -f $srctree/Makefile image_name)" "$tmpdir/$installed_image_path"
+
+vmlinux=$($MAKE -s -f $srctree/Makefile image_name)
+if is_enabled CONFIG_MODULE_SIG; then
+	cert=$srctree/$(grep ^CONFIG_MODULE_SIG_KEY= include/config/auto.conf | cut -d\" -f2)
+	key=${cert%pem}priv
+	sbsign --key $key --cert $cert "$vmlinux" --output "$tmpdir/$installed_image_path"
+else
+	cp "$vmlinux" "$tmpdir/$installed_image_path"
+fi
 
 if is_enabled CONFIG_OF_EARLY_FLATTREE; then
 	# Only some architectures with OF support have this target
-- 
2.30.2

