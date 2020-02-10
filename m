Return-Path: <SRS0=jkYB=36=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0BEC352A4
	for <linux-efi@archiver.kernel.org>; Mon, 10 Feb 2020 16:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55FDC2467C
	for <linux-efi@archiver.kernel.org>; Mon, 10 Feb 2020 16:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581350601;
	bh=8QU6xWOD++ImMvlFPWMW63as1Y64bu7fTBDNti6PZUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HnC7CvVMOJYIEp1WcYIV9F4pgO8IFT0tf6jpq4yzw/8Llsoo23s1DAQvP1BvjpNkW
	 AanYZIeRWpcqrBsEFl+7e972LroO4XblEUfXUl67ATyoHUeQSZnE1o+Kpkzk1HrNnW
	 6hK3uMou+xWKNrSxICjoAZFFmhrRZ26fPk8IFmoI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgBJQDV (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 10 Feb 2020 11:03:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbgBJQDV (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 10 Feb 2020 11:03:21 -0500
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1555C24677;
        Mon, 10 Feb 2020 16:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581350600;
        bh=8QU6xWOD++ImMvlFPWMW63as1Y64bu7fTBDNti6PZUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEc8pPJB57zDXvbF/8YyKNOB274qLjqvVdaEnVzqdl99oCkuVTU4s9lM8+BFZ6/f6
         2o4rLAWX4Eb0uBDKkIXVLOfZQ8lC650osjb3RAQJ/QCzcOdnG4Vf5yJMvDmJLjPwG7
         DbuLZ3vWhR8a2VnFH5Zxp1c8s6iWId9y6Fecl4aw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, nivedita@alum.mit.edu,
        mingo@kernel.org, lukas@wunner.de, atish.patra@wdc.com
Subject: [PATCH 13/19] efi/libstub: Move get_dram_base() into arm-stub.c
Date:   Mon, 10 Feb 2020 17:02:42 +0100
Message-Id: <20200210160248.4889-14-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200210160248.4889-1-ardb@kernel.org>
References: <20200210160248.4889-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

get_dram_base() is only called from arm-stub.c so move it into
the same source file as its caller.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/arm-stub.c        | 33 ++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub-helper.c | 35 --------------------
 drivers/firmware/efi/libstub/efistub.h         |  2 --
 3 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index ebdf1964dd5c..fb5b2b35d3be 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -87,6 +87,39 @@ void install_memreserve_table(void)
 		pr_efi_err("Failed to install memreserve config table!\n");
 }
 
+static unsigned long get_dram_base(void)
+{
+	efi_status_t status;
+	unsigned long map_size, buff_size;
+	unsigned long membase  = EFI_ERROR;
+	struct efi_memory_map map;
+	efi_memory_desc_t *md;
+	struct efi_boot_memmap boot_map;
+
+	boot_map.map		= (efi_memory_desc_t **)&map.map;
+	boot_map.map_size	= &map_size;
+	boot_map.desc_size	= &map.desc_size;
+	boot_map.desc_ver	= NULL;
+	boot_map.key_ptr	= NULL;
+	boot_map.buff_size	= &buff_size;
+
+	status = efi_get_memory_map(&boot_map);
+	if (status != EFI_SUCCESS)
+		return membase;
+
+	map.map_end = map.map + map_size;
+
+	for_each_efi_memory_desc_in_map(&map, md) {
+		if (md->attribute & EFI_MEMORY_WB) {
+			if (membase > md->phys_addr)
+				membase = md->phys_addr;
+		}
+	}
+
+	efi_bs_call(free_pool, map.map);
+
+	return membase;
+}
 
 /*
  * This function handles the architcture specific differences between arm and
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 92ccd0a51ae6..1a8f2cf5a2bd 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -75,41 +75,6 @@ void efi_printk(char *str)
 	}
 }
 
-
-unsigned long get_dram_base(void)
-{
-	efi_status_t status;
-	unsigned long map_size, buff_size;
-	unsigned long membase  = EFI_ERROR;
-	struct efi_memory_map map;
-	efi_memory_desc_t *md;
-	struct efi_boot_memmap boot_map;
-
-	boot_map.map =		(efi_memory_desc_t **)&map.map;
-	boot_map.map_size =	&map_size;
-	boot_map.desc_size =	&map.desc_size;
-	boot_map.desc_ver =	NULL;
-	boot_map.key_ptr =	NULL;
-	boot_map.buff_size =	&buff_size;
-
-	status = efi_get_memory_map(&boot_map);
-	if (status != EFI_SUCCESS)
-		return membase;
-
-	map.map_end = map.map + map_size;
-
-	for_each_efi_memory_desc_in_map(&map, md) {
-		if (md->attribute & EFI_MEMORY_WB) {
-			if (membase > md->phys_addr)
-				membase = md->phys_addr;
-		}
-	}
-
-	efi_bs_call(free_pool, map.map);
-
-	return membase;
-}
-
 static efi_status_t efi_file_size(void *__fh, efi_char16_t *filename_16,
 				  void **handle, u64 *file_sz)
 {
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index b94c63d17a4f..5123def761e9 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -549,8 +549,6 @@ efi_status_t efi_exit_boot_services(void *handle,
 
 void efi_char16_printk(efi_char16_t *);
 
-unsigned long get_dram_base(void);
-
 efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 					    unsigned long *new_fdt_addr,
 					    unsigned long max_addr,
-- 
2.17.1

