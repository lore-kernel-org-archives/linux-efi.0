Return-Path: <SRS0=1wuS=3L=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BCBDC2D0DB
	for <linux-efi@archiver.kernel.org>; Wed, 22 Jan 2020 13:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F335820704
	for <linux-efi@archiver.kernel.org>; Wed, 22 Jan 2020 13:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579699891;
	bh=RSUDhfPhXk0dWiZ10UxNgdPkWdvoHWDWWByQvoZi8Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mFdhBZmnsNXu/P2U1ITTpRjnsqc7g+VKENxUQY1dZwe7A0Nvo28CxcQ6K4GwgTCs9
	 2WQFHqLc0Ge6wfWAH2WVay6hArXEjXXiGzNzuXi6A3bAiHxkyEyZ2ulPgfgni3ulGR
	 xKnVmtlRIO4Cl8qPtlgQwdP4t/Wq2YPvYRCaI91E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgAVNTt (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 22 Jan 2020 08:19:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728811AbgAVNTr (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 22 Jan 2020 08:19:47 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4861820678;
        Wed, 22 Jan 2020 13:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699186;
        bh=RSUDhfPhXk0dWiZ10UxNgdPkWdvoHWDWWByQvoZi8Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yeOfO4omESxdLvcUs6gqyvwKYXhk3SJdL8/Ynx5bKc2MIUaAk0U9XcX/x+EF/TSos
         eV8Pyr5t4R3g/BiezgWxRXyS5nR4Og8zYT2Yz+uwXXIfxUtV9n66xPb1CPiIigEQJT
         HgGeVx2L7iCe3h0qSCzzwYCzZ5xL6QkbdknCOr2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 066/222] x86/efistub: Disable paging at mixed mode entry
Date:   Wed, 22 Jan 2020 10:27:32 +0100
Message-Id: <20200122092838.449657394@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 4911ee401b7ceff8f38e0ac597cbf503d71e690c upstream.

The EFI mixed mode entry code goes through the ordinary startup_32()
routine before jumping into the kernel's EFI boot code in 64-bit
mode. The 32-bit startup code must be entered with paging disabled,
but this is not documented as a requirement for the EFI handover
protocol, and so we should disable paging explicitly when entering
the kernel from 32-bit EFI firmware.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: https://lkml.kernel.org/r/20191224132909.102540-4-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/head_64.S |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -244,6 +244,11 @@ ENTRY(efi32_stub_entry)
 	leal	efi32_config(%ebp), %eax
 	movl	%eax, efi_config(%ebp)
 
+	/* Disable paging */
+	movl	%cr0, %eax
+	btrl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+
 	jmp	startup_32
 ENDPROC(efi32_stub_entry)
 #endif


