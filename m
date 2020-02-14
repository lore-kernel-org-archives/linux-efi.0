Return-Path: <SRS0=Dmk2=4C=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E036AC3B1A1
	for <linux-efi@archiver.kernel.org>; Fri, 14 Feb 2020 16:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B702724696
	for <linux-efi@archiver.kernel.org>; Fri, 14 Feb 2020 16:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581698157;
	bh=u4qyc8uNB1l2T+CyO/foQ1KOl/EGrkXWAq28DrRAVi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DNT1Rk28Z7F/6kN+l2aINOjnKfEtsKhk02E8jFvIdgnnL8P219towLZV556VJgzNU
	 Co4p1giF4q+X6jjDTnVz+bjxbahNWxZeOWcrE+wzi6hw9QDhjjx2W385ktYERMlU1v
	 tfK/3Ju/q4cW/ZlkRD4KsAywh2GzuLpnXeY9xORE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393652AbgBNQft (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405921AbgBNQYg (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 14 Feb 2020 11:24:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D128F2479D;
        Fri, 14 Feb 2020 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697476;
        bh=u4qyc8uNB1l2T+CyO/foQ1KOl/EGrkXWAq28DrRAVi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4rcD326m2vNUk7WIzU4Z61e5TaTyQ3q6vSG0DlfLZGYxplJJXw62r6EU0MTN5PEA
         U8M2pM6wrwATTdARqIGHnhcukoTT6WxhOdkvFzHgqQoArTOeQzzzw1p1OL29NfNCj2
         OlXig9nMVQXYryOwK2k0p4rZPjGutqIDmXkZTfNk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Matthew Garrett <mjg59@google.com>, linux-efi@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org, x86@kernel.org
Subject: [PATCH AUTOSEL 4.4 008/100] efi/x86: Map the entire EFI vendor string before copying it
Date:   Fri, 14 Feb 2020 11:22:52 -0500
Message-Id: <20200214162425.21071-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit ffc2760bcf2dba0dbef74013ed73eea8310cc52c ]

Fix a couple of issues with the way we map and copy the vendor string:
- we map only 2 bytes, which usually works since you get at least a
  page, but if the vendor string happens to cross a page boundary,
  a crash will result
- only call early_memunmap() if early_memremap() succeeded, or we will
  call it with a NULL address which it doesn't like,
- while at it, switch to early_memremap_ro(), and array indexing rather
  than pointer dereferencing to read the CHAR16 characters.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Matthew Garrett <mjg59@google.com>
Cc: linux-efi@vger.kernel.org
Fixes: 5b83683f32b1 ("x86: EFI runtime service support")
Link: https://lkml.kernel.org/r/20200103113953.9571-5-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/efi/efi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4bc352fc08f19..105872617be08 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -465,7 +465,6 @@ void __init efi_init(void)
 	efi_char16_t *c16;
 	char vendor[100] = "unknown";
 	int i = 0;
-	void *tmp;
 
 #ifdef CONFIG_X86_32
 	if (boot_params.efi_info.efi_systab_hi ||
@@ -490,14 +489,16 @@ void __init efi_init(void)
 	/*
 	 * Show what we know for posterity
 	 */
-	c16 = tmp = early_memremap(efi.systab->fw_vendor, 2);
+	c16 = early_memremap_ro(efi.systab->fw_vendor,
+				sizeof(vendor) * sizeof(efi_char16_t));
 	if (c16) {
-		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
-			vendor[i] = *c16++;
+		for (i = 0; i < sizeof(vendor) - 1 && c16[i]; ++i)
+			vendor[i] = c16[i];
 		vendor[i] = '\0';
-	} else
+		early_memunmap(c16, sizeof(vendor) * sizeof(efi_char16_t));
+	} else {
 		pr_err("Could not map the firmware vendor!\n");
-	early_memunmap(tmp, 2);
+	}
 
 	pr_info("EFI v%u.%.02u by %s\n",
 		efi.systab->hdr.revision >> 16,
-- 
2.20.1

