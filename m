Return-Path: <SRS0=1qxX=B3=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD78C433DF
	for <linux-efi@archiver.kernel.org>; Mon, 17 Aug 2020 10:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3E0E206FA
	for <linux-efi@archiver.kernel.org>; Mon, 17 Aug 2020 10:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597660254;
	bh=VI5Zm6i8tU/2vxnB9co08fDYXEv3bUnq3E1L0ZTwvM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RtTmx/AIZ1PKvRs7pf/CH6aCBbuoA6DfJhS/HD2hk6+EGsn6NPY8w/srrqIPta/cX
	 mUwbqGEOaHWeaB53J+W/0HqIsB0kN+J2AmmkUz6ylxV7zdA6W/j7TEyVJvzRzwX0p5
	 v1fG5v3sDzjDcL6uL3zYFZzXpUt0ZYLdPapFSTtg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgHQKay (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 17 Aug 2020 06:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgHQKax (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 17 Aug 2020 06:30:53 -0400
Received: from e123331-lin.nice.arm.com (ip-213-127-60-218.ip.prioritytelecom.net [213.127.60.218])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CDED20758;
        Mon, 17 Aug 2020 10:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597660253;
        bh=VI5Zm6i8tU/2vxnB9co08fDYXEv3bUnq3E1L0ZTwvM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mH2yTuVyMmiq8hj8EhQ2NPyHgFSyeH/zySCoCQU1Frs+YTjJsBRoI/BWXd55xr+Th
         y3b2ihfdLCx2gaD0Ku+HwKhu7K+n4U5p0GEkuwKBw6KZ+v1rGMFPx+V5TOtAOWevWw
         AIC4NEkQ/I8j1wKBpCyGR3HsZYQrmC+5hDHMC04Y=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH 2/2] Documentation: efi: remove description of efi=old_map
Date:   Mon, 17 Aug 2020 12:30:44 +0200
Message-Id: <20200817103044.12163-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817103044.12163-1-ardb@kernel.org>
References: <20200817103044.12163-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The old EFI runtime region mapping logic that was kept around for some
time has finally been removed entirely, along with the SGI UV1 support
code that was its last remaining user. So remove any mention of the
efi=old_map command line parameter from the docs.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index bdc1f33fd3d1..a1068742a6df 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1233,8 +1233,7 @@
 	efi=		[EFI]
 			Format: { "debug", "disable_early_pci_dma",
 				  "nochunk", "noruntime", "nosoftreserve",
-				  "novamap", "no_disable_early_pci_dma",
-				  "old_map" }
+				  "novamap", "no_disable_early_pci_dma" }
 			debug: enable misc debug output.
 			disable_early_pci_dma: disable the busmaster bit on all
 			PCI bridges while in the EFI boot stub.
@@ -1251,8 +1250,6 @@
 			novamap: do not call SetVirtualAddressMap().
 			no_disable_early_pci_dma: Leave the busmaster bit set
 			on all PCI bridges while in the EFI boot stub
-			old_map [X86-64]: switch to the old ioremap-based EFI
-			runtime services mapping. [Needs CONFIG_X86_UV=y]
 
 	efi_no_storage_paranoia [EFI; X86]
 			Using this parameter you can use more than 50% of
-- 
2.17.1

