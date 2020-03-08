Return-Path: <SRS0=8H/N=4Z=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CFCC18E5B
	for <linux-efi@archiver.kernel.org>; Sun,  8 Mar 2020 08:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D66E21744
	for <linux-efi@archiver.kernel.org>; Sun,  8 Mar 2020 08:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583654976;
	bh=bemc6Y0qptmJiJAj2ALf99Zpw/1+L3qkVJoyD2rMNn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=B4doAiJRNLe4gxm8UR8JvYUksRCb1izwU61fyFHEkkx7y7ELEJVWhhRyCzleZhWpI
	 f61u/ksjlqGEI57NmyfU4qpr4Pt4pwpvkO2INnSRLAF66YAfadJmtumaNxP9iOeyg4
	 jprdHbcpGPw+87sxexFp5GogwwsAuCLrFGDn8twI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgCHIJc (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Sun, 8 Mar 2020 04:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgCHIJb (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Sun, 8 Mar 2020 04:09:31 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 059EE20880;
        Sun,  8 Mar 2020 08:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583654971;
        bh=bemc6Y0qptmJiJAj2ALf99Zpw/1+L3qkVJoyD2rMNn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6Y4eCizWK8KT99pA9rIbDWu/7fBwKXxiKY6G0rSn7r48deu9TNKEjS97cmJF3Y3h
         JSXOEe/qjz9j4X+7JK2/PA/YvwbRBtVyWEG21oqYLDU5nicKukPQOisdAkGXOqY9/T
         aJ1o96veqJXRnEqY7g03YWDkGSrIO5+B6Ozz5XPc=
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
Subject: [PATCH 07/28] MAINTAINERS: adjust EFI entry to removing eboot.c
Date:   Sun,  8 Mar 2020 09:08:38 +0100
Message-Id: <20200308080859.21568-8-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200308080859.21568-1-ardb@kernel.org>
References: <20200308080859.21568-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Commit c2d0b470154c ("efi/libstub/x86: Incorporate eboot.c into libstub")
removed arch/x86/boot/compressed/eboot.[ch], but missed to adjust the
MAINTAINERS entry.

Since then, ./scripts/get_maintainer.pl --self-test complains:

  warning: no file matches F: arch/x86/boot/compressed/eboot.[ch]

Rectify EXTENSIBLE FIRMWARE INTERFACE (EFI) entry in MAINTAINERS.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Link: https://lore.kernel.org/r/20200301155748.4788-1-lukas.bulwahn@gmail.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8f27f40d22bb..5df99dab099f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6344,7 +6344,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
 S:	Maintained
 F:	Documentation/admin-guide/efi-stub.rst
 F:	arch/*/kernel/efi.c
-F:	arch/x86/boot/compressed/eboot.[ch]
 F:	arch/*/include/asm/efi.h
 F:	arch/x86/platform/efi/
 F:	drivers/firmware/efi/
-- 
2.17.1

