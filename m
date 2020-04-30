Return-Path: <SRS0=rTkh=6O=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E65C47247
	for <linux-efi@archiver.kernel.org>; Thu, 30 Apr 2020 19:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80308207DD
	for <linux-efi@archiver.kernel.org>; Thu, 30 Apr 2020 19:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgD3TMt (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 30 Apr 2020 15:12:49 -0400
Received: from smtprelay0106.hostedemail.com ([216.40.44.106]:49208 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726272AbgD3TMs (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Thu, 30 Apr 2020 15:12:48 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 65EE718224D67;
        Thu, 30 Apr 2020 19:12:47 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: wine71_8ca3b86da0a02
X-Filterd-Recvd-Size: 2589
Received: from joe-laptop.perches.com (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Thu, 30 Apr 2020 19:12:46 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Arvind Sankar <nivedita@alum.mit.edu>, linux-kernel@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH 2/2] efi/libstub: Correct comment typos
Date:   Thu, 30 Apr 2020 12:12:42 -0700
Message-Id: <ec53e67b3ac928922807db3cb1585e911971dadc.1588273612.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <091e3fc3bdbc5f480af7d3b3ac096d174a4480d0.1588273612.git.joe@perches.com>
References: <091e3fc3bdbc5f480af7d3b3ac096d174a4480d0.1588273612.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Fix a couple typos in comments.

Signed-off-by: Joe Perches <joe@perches.com>
---

Perhaps these trivialities on top of this series?

drivers/firmware/efi/libstub/pci.c      | 2 +-
 drivers/firmware/efi/libstub/relocate.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/pci.c b/drivers/firmware/efi/libstub/pci.c
index 111c44b..17a53d8 100644
--- a/drivers/firmware/efi/libstub/pci.c
+++ b/drivers/firmware/efi/libstub/pci.c
@@ -69,7 +69,7 @@ void efi_pci_disable_bridge_busmaster(void)
 		 * access to the framebuffer. Drivers for true PCIe graphics
 		 * controllers that are behind a PCIe root port do not use
 		 * DMA to implement the GOP framebuffer anyway [although they
-		 * may use it in their implentation of Gop->Blt()], and so
+		 * may use it in their implementation of Gop->Blt()], and so
 		 * disabling DMA in the PCI bridge should not interfere with
 		 * normal operation of the device.
 		 */
diff --git a/drivers/firmware/efi/libstub/relocate.c b/drivers/firmware/efi/libstub/relocate.c
index 62e2d6..a7ad26 100644
--- a/drivers/firmware/efi/libstub/relocate.c
+++ b/drivers/firmware/efi/libstub/relocate.c
@@ -140,7 +140,7 @@ efi_status_t efi_relocate_kernel(unsigned long *image_addr,
 	 * The EFI firmware loader could have placed the kernel image
 	 * anywhere in memory, but the kernel has restrictions on the
 	 * max physical address it can run at.  Some architectures
-	 * also have a prefered address, so first try to relocate
+	 * also have a preferred address, so first try to relocate
 	 * to the preferred address.  If that fails, allocate as low
 	 * as possible while respecting the required alignment.
 	 */
-- 
2.26.0

