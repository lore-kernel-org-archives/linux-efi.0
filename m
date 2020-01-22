Return-Path: <SRS0=1wuS=3L=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65651C2D0DB
	for <linux-efi@archiver.kernel.org>; Wed, 22 Jan 2020 09:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 330E92465A
	for <linux-efi@archiver.kernel.org>; Wed, 22 Jan 2020 09:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579686973;
	bh=SZZSIre19pX2ghMbCXGVmCBnJhIcEsaSi5aYgH/A/s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZwYOf5rmF29iA8rx3/toj2TeZjKxXD3KqjKhrgo+2v/1g1I0UBy/SuriXLNCFl6H9
	 gQ9UlF1KAiRI+biPuUYIvUHku7UcwvlB1q2621UU+KCmY/Jxa0k/0+NX/xwp35SqUl
	 TMSLrORiGS8xqZb+HJcNxTyHXBgPE7QkzeEBQxgc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbgAVJcL (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 22 Jan 2020 04:32:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729992AbgAVJcK (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Wed, 22 Jan 2020 04:32:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BC9524672;
        Wed, 22 Jan 2020 09:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685530;
        bh=SZZSIre19pX2ghMbCXGVmCBnJhIcEsaSi5aYgH/A/s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRv5n9V9XRWBYL3VEGkxYvnPtZGMRJDzka6CwwCoh9PJ0Nks7GKLhld7wDBYxZO8H
         f1OJJQbQBOt8sm6M1M4ao8IzXsRVWMVE+TrcLcO95H6GNI/T5O8L0wd0bSmS2tHLt2
         f2s22qLq5q2vV4LPPfGyLtzwdctmRogR6iAQogoM=
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
Subject: [PATCH 4.4 51/76] x86/efistub: Disable paging at mixed mode entry
Date:   Wed, 22 Jan 2020 10:29:07 +0100
Message-Id: <20200122092758.413442383@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
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
@@ -225,6 +225,11 @@ ENTRY(efi32_stub_entry)
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


