Return-Path: <SRS0=jkYB=36=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9B0C352A5
	for <linux-efi@archiver.kernel.org>; Mon, 10 Feb 2020 16:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 961F420863
	for <linux-efi@archiver.kernel.org>; Mon, 10 Feb 2020 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581350609;
	bh=1jCLSpuxWNvqDDktboTcTA462Gp+IJGKbFelxV2ZYVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CGp5Vl9c2cZTjrMKsJXAjk82cBMyS+fiATWjuUhKNi+fDHm8QCiqqMDtwJaGRyHYl
	 wofJnqGjmhcdIHDKyd1b0rkkhtpwLWs+zvzbTVGc3Jagy9bq579rjnKBj+IdhUMxP+
	 4vBe57iRlfr6hR1vS6QRP49yY7612bbFr4H3llWk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgBJQD3 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 10 Feb 2020 11:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbgBJQD3 (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 10 Feb 2020 11:03:29 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76FD824683;
        Mon, 10 Feb 2020 16:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581350608;
        bh=1jCLSpuxWNvqDDktboTcTA462Gp+IJGKbFelxV2ZYVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03ux1Q+Vm+C2tBAUwfCPQasLYb2lOqUR20UipexcqE6i9is+wueJrEE6eQ0u9Y3/m
         pz4Z+FxKzkjKnkq6SFcTt6O60jVqo5RA+gPPGBJaw+7wbpgNSJtkpKFp1gEU73pgJL
         mkSFccEbdObwCxmOqA1yYlBVRDmgWqfTKjvkOIBo=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, nivedita@alum.mit.edu,
        mingo@kernel.org, lukas@wunner.de, atish.patra@wdc.com
Subject: [PATCH 18/19] efi/libstub: Expose LocateDevicePath boot service
Date:   Mon, 10 Feb 2020 17:02:47 +0100
Message-Id: <20200210160248.4889-19-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200210160248.4889-1-ardb@kernel.org>
References: <20200210160248.4889-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

We will be adding support for loading the initrd from a GUIDed
device path in a subsequent patch, so update the prototype of
the LocateDevicePath() boot service to make it callable from
our code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/include/asm/efi.h             | 3 +++
 drivers/firmware/efi/libstub/efistub.h | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 85f79accd3f8..9ced980b123b 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -283,6 +283,9 @@ static inline void *efi64_zero_upper(void *p)
 #define __efi64_argmap_locate_protocol(protocol, reg, interface)	\
 	((protocol), (reg), efi64_zero_upper(interface))
 
+#define __efi64_argmap_locate_device_path(protocol, path, handle)	\
+	((protocol), (path), efi64_zero_upper(handle))
+
 /* PCI I/O */
 #define __efi64_argmap_get_location(protocol, seg, bus, dev, func)	\
 	((protocol), efi64_zero_upper(seg), efi64_zero_upper(bus),	\
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index d282d907cd33..afa774a312f5 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -100,6 +100,8 @@ struct efi_boot_memmap {
 	unsigned long		*buff_size;
 };
 
+typedef struct efi_generic_dev_path efi_device_path_protocol_t;
+
 /*
  * EFI Boot Services table
  */
@@ -134,7 +136,9 @@ union efi_boot_services {
 		efi_status_t (__efiapi *locate_handle)(int, efi_guid_t *,
 						       void *, unsigned long *,
 						       efi_handle_t *);
-		void *locate_device_path;
+		efi_status_t (__efiapi *locate_device_path)(efi_guid_t *,
+							    efi_device_path_protocol_t **,
+							    efi_handle_t *);
 		efi_status_t (__efiapi *install_configuration_table)(efi_guid_t *,
 								     void *);
 		void *load_image;
-- 
2.17.1

