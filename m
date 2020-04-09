Return-Path: <SRS0=7pYY=5Z=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90B4C38A24
	for <linux-efi@archiver.kernel.org>; Thu,  9 Apr 2020 13:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1001214DB
	for <linux-efi@archiver.kernel.org>; Thu,  9 Apr 2020 13:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586437519;
	bh=U7IetTerUYNpcR10zlJAkIrjjq2uos2SYYzL0HOR3ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RwT25FKLSssJsR/bYBYSSzbEIEF+4Rx5uP0yrydEB7GUk20HU7NNdrqyroP8YXmEs
	 mKBZ7op6p7tDOSW0I9nNrbbNqxQ2wzVR8h8kW70/V6B2u6E36D7MNVFN2BX3v2VRaj
	 Cpn4ZtvXSsVxWjXntYqRUdy5M5U7l0DxY7dOwGr0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgDINFP (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbgDINFO (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 9 Apr 2020 09:05:14 -0400
Received: from e123331-lin.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A15B2145D;
        Thu,  9 Apr 2020 13:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586437514;
        bh=U7IetTerUYNpcR10zlJAkIrjjq2uos2SYYzL0HOR3ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVivXXWyqayWq6D9G+GLJSsib5ank0YIP/DlXzSb3ojl9NUp29WtTFoTRjchC+1/w
         A28mpGBqaNA2Ho+J+3n77Wx/iwLrbFCH9nbhcihRObyk4M6yxnpXrPRX4CQSUuW4+l
         k3HlNVVBXb1Jhla4DRwvTMZyM51y1pURzKWFi2mc=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>,
        Colin Ian King <colin.king@canonical.com>,
        Gary Lin <glin@suse.com>, Jiri Slaby <jslaby@suse.cz>,
        Sergey Shatunov <me@prok.pw>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7/9] efi/libstub/file: merge filename buffers to reduce stack usage
Date:   Thu,  9 Apr 2020 15:04:32 +0200
Message-Id: <20200409130434.6736-8-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200409130434.6736-1-ardb@kernel.org>
References: <20200409130434.6736-1-ardb@kernel.org>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Arnd reports that commit

  9302c1bb8e47 ("efi/libstub: Rewrite file I/O routine")

reworks the file I/O routines in a way that triggers the following
warning:

  drivers/firmware/efi/libstub/file.c:240:1: warning: the frame size
            of 1200 bytes is larger than 1024 bytes [-Wframe-larger-than=]

We can work around this issue dropping an instance of efi_char16_t[256]
from the stack frame, and reusing the 'filename' field of the file info
struct that we use to obtain file information from EFI (which contains
the filename even though we already know it since we used it to open
the file in the first place)

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/file.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/efi/libstub/file.c b/drivers/firmware/efi/libstub/file.c
index d4c7e5f59d2c..ea66b1f16a79 100644
--- a/drivers/firmware/efi/libstub/file.c
+++ b/drivers/firmware/efi/libstub/file.c
@@ -29,30 +29,31 @@
  */
 #define EFI_READ_CHUNK_SIZE	SZ_1M
 
+struct finfo {
+	efi_file_info_t info;
+	efi_char16_t	filename[MAX_FILENAME_SIZE];
+};
+
 static efi_status_t efi_open_file(efi_file_protocol_t *volume,
-				  efi_char16_t *filename_16,
+				  struct finfo *fi,
 				  efi_file_protocol_t **handle,
 				  unsigned long *file_size)
 {
-	struct {
-		efi_file_info_t info;
-		efi_char16_t	filename[MAX_FILENAME_SIZE];
-	} finfo;
 	efi_guid_t info_guid = EFI_FILE_INFO_ID;
 	efi_file_protocol_t *fh;
 	unsigned long info_sz;
 	efi_status_t status;
 
-	status = volume->open(volume, &fh, filename_16, EFI_FILE_MODE_READ, 0);
+	status = volume->open(volume, &fh, fi->filename, EFI_FILE_MODE_READ, 0);
 	if (status != EFI_SUCCESS) {
 		pr_efi_err("Failed to open file: ");
-		efi_char16_printk(filename_16);
+		efi_char16_printk(fi->filename);
 		efi_printk("\n");
 		return status;
 	}
 
-	info_sz = sizeof(finfo);
-	status = fh->get_info(fh, &info_guid, &info_sz, &finfo);
+	info_sz = sizeof(struct finfo);
+	status = fh->get_info(fh, &info_guid, &info_sz, fi);
 	if (status != EFI_SUCCESS) {
 		pr_efi_err("Failed to get file info\n");
 		fh->close(fh);
@@ -60,7 +61,7 @@ static efi_status_t efi_open_file(efi_file_protocol_t *volume,
 	}
 
 	*handle = fh;
-	*file_size = finfo.info.file_size;
+	*file_size = fi->info.file_size;
 	return EFI_SUCCESS;
 }
 
@@ -146,13 +147,13 @@ static efi_status_t handle_cmdline_files(efi_loaded_image_t *image,
 
 	alloc_addr = alloc_size = 0;
 	do {
-		efi_char16_t filename[MAX_FILENAME_SIZE];
+		struct finfo fi;
 		unsigned long size;
 		void *addr;
 
 		offset = find_file_option(cmdline, cmdline_len,
 					  optstr, optstr_size,
-					  filename, ARRAY_SIZE(filename));
+					  fi.filename, ARRAY_SIZE(fi.filename));
 
 		if (!offset)
 			break;
@@ -166,7 +167,7 @@ static efi_status_t handle_cmdline_files(efi_loaded_image_t *image,
 				return status;
 		}
 
-		status = efi_open_file(volume, filename, &file, &size);
+		status = efi_open_file(volume, &fi, &file, &size);
 		if (status != EFI_SUCCESS)
 			goto err_close_volume;
 
-- 
2.17.1

