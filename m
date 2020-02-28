Return-Path: <SRS0=uAFW=4Q=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A40C3F2D2
	for <linux-efi@archiver.kernel.org>; Fri, 28 Feb 2020 12:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 633DC2087F
	for <linux-efi@archiver.kernel.org>; Fri, 28 Feb 2020 12:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582892076;
	bh=fsUSHqSO8WF5liIRA+Rrk+SECjOcvWOfT3GkhH9jRbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sB8I4mTj70MIfDpDVavAqzVJlp5q/u5eLiBbqFAmIENNmknD51/MWzOS6Y2Z1KJ+Q
	 Z3DN815wyj4uvavq5osLzA4BF2hxonNZY3/G/Q4J1tj+u1Y/lhKLvqAIv8TJRsaSfa
	 irtG4NrL911ZPa1HlwkOIt3Tvf9Sl+8crzsIgryk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgB1MOR (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 28 Feb 2020 07:14:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgB1MOQ (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Fri, 28 Feb 2020 07:14:16 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FA84246AF;
        Fri, 28 Feb 2020 12:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582892056;
        bh=fsUSHqSO8WF5liIRA+Rrk+SECjOcvWOfT3GkhH9jRbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKOGIRX78xyAAkqESJCuuFajLWlg/Eg8Mt/X2efQBzp7ZZWa0MOR6gxnRKcg22Qo6
         pAMD4nMP3PTf960ka5sOQrG7wZWgcjsy5Nw53fYmu5FlnZwZDE6DiaytDzBN0/Cr0Y
         awNyTwTSSkEPpC9Vyi4QJ0k+fPqi5qO4Rcf0ASeM=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 1/6] efi/x86: Add TPM related EFI tables to unencrypted mapping checks
Date:   Fri, 28 Feb 2020 13:14:03 +0100
Message-Id: <20200228121408.9075-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200228121408.9075-1-ardb@kernel.org>
References: <20200228121408.9075-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When booting with SME active, EFI tables must be mapped unencrypted since
they were built by UEFI in unencrypted memory. Update the list of tables
to be checked during early_memremap() processing to account for the EFI
TPM tables.

This fixes a bug where an EFI TPM log table has been created by UEFI, but
it lives in memory that has been marked as usable rather than reserved.

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/4144cd813f113c20cdfa511cf59500a64e6015be.1582662842.git.thomas.lendacky@amd.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 43b24e149312..0a8117865430 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -88,6 +88,8 @@ static const unsigned long * const efi_tables[] = {
 #ifdef CONFIG_EFI_RCI2_TABLE
 	&rci2_table_phys,
 #endif
+	&efi.tpm_log,
+	&efi.tpm_final_log,
 };
 
 u64 efi_setup;		/* efi setup_data physical address */
-- 
2.17.1

