Return-Path: <SRS0=hWye=7V=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAD6C433DF
	for <linux-efi@archiver.kernel.org>; Mon,  8 Jun 2020 23:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0175B2078C
	for <linux-efi@archiver.kernel.org>; Mon,  8 Jun 2020 23:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591660780;
	bh=MdW3KQHJFjrbPO/7LWBN3FFilQj3utVGrULWCGVyXAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kp+2EKkP9NOiKi10wVd9a4c/X/SJ5tQa2H8ZyxQKfaiaMNUlb05F5cOm33BUZvtLn
	 MvhrcxOMvp5VUkoW7CPtuyhYC6O5V9GKK61aMDLDVypIGxi1hvzh8nXqqAt76oEKGh
	 lqHqI1K43/Bcw6v0VIbcHezmK2F0j+IPnnISOSZM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbgFHXWw (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 8 Jun 2020 19:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731382AbgFHXWv (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 129A2208C7;
        Mon,  8 Jun 2020 23:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658571;
        bh=MdW3KQHJFjrbPO/7LWBN3FFilQj3utVGrULWCGVyXAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFzj5DtNBC9rdXAHAq8LBeOGPZJb01xahgIsUFoff3dVSenc1QXKeDd9UuGK7S3X8
         1RSxH1T1LRlZYYpmDwy3Vy/1aqLyD5j/4wstvYxYL991DTdz+04ebQOkKDDiS8N6oF
         hSQ62adPTBoe5k8dp8KGBEzYmIVAtp7qzL+Ik0H4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fangrui Song <maskray@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 010/106] efi/libstub/x86: Work around LLVM ELF quirk build regression
Date:   Mon,  8 Jun 2020 19:21:02 -0400
Message-Id: <20200608232238.3368589-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit f77767ed5f4d398b29119563155e4ece2dfeee13 ]

When building the x86 EFI stub with Clang, the libstub Makefile rules
that manipulate the ELF object files may throw an error like:

    STUBCPY drivers/firmware/efi/libstub/efi-stub-helper.stub.o
  strip: drivers/firmware/efi/libstub/efi-stub-helper.stub.o: Failed to find link section for section 10
  objcopy: drivers/firmware/efi/libstub/efi-stub-helper.stub.o: Failed to find link section for section 10

This is the result of a LLVM feature [0] where symbol references are
stored in a LLVM specific .llvm_addrsig section in a non-transparent way,
causing generic ELF tools such as strip or objcopy to choke on them.

So force the compiler not to emit these sections, by passing the
appropriate command line option.

[0] https://sourceware.org/bugzilla/show_bug.cgi?id=23817

Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Fangrui Song <maskray@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d9845099635e..d3777d754984 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -28,6 +28,7 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   -D__NO_FORTIFY \
 				   $(call cc-option,-ffreestanding) \
 				   $(call cc-option,-fno-stack-protector) \
+				   $(call cc-option,-fno-addrsig) \
 				   -D__DISABLE_EXPORTS
 
 GCOV_PROFILE			:= n
-- 
2.25.1

