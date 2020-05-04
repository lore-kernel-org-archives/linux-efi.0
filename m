Return-Path: <SRS0=EqbT=6S=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE57C4724C
	for <linux-efi@archiver.kernel.org>; Mon,  4 May 2020 18:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C770D2073E
	for <linux-efi@archiver.kernel.org>; Mon,  4 May 2020 18:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbgEDS3o (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 4 May 2020 14:29:44 -0400
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:33792 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730292AbgEDS3n (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 4 May 2020 14:29:43 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id BCBAE180050EA;
        Mon,  4 May 2020 18:29:41 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: care86_8eb3f26475931
X-Filterd-Recvd-Size: 3895
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Mon,  4 May 2020 18:29:40 +0000 (UTC)
Message-ID: <f1926d434cdeb091405ef8c01a90c0140d296bed.camel@perches.com>
Subject: [trivial PATCH] efi/libstub: Reduce efi_printk object size
From:   Joe Perches <joe@perches.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>
Date:   Mon, 04 May 2020 11:29:39 -0700
In-Reply-To: <CAMj1kXHwdy3BTqt-q_qnezyz666BcqKiFxeumfsD+Qjy5qRzZA@mail.gmail.com>
References: <091e3fc3bdbc5f480af7d3b3ac096d174a4480d0.1588273612.git.joe@perches.com>
         <ec53e67b3ac928922807db3cb1585e911971dadc.1588273612.git.joe@perches.com>
         <CAMj1kXHwdy3BTqt-q_qnezyz666BcqKiFxeumfsD+Qjy5qRzZA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Use a few more common kernel styles.

Trivially reduce efi_printk object size by using a dereference to
a temporary instead of multiple dereferences of the same object.

Use efi_printk(const char *str) and static or static const for its
internal variables.

Use the more common form of while instead of a for loop.

Change efi_char16_printk argument to const.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 16 ++++++++--------
 drivers/firmware/efi/libstub/efistub.h         |  6 +++---
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 1c92ac231f94..dfd72a4360ac 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -26,19 +26,19 @@ bool __pure __efi_soft_reserve_enabled(void)
 	return !efi_nosoftreserve;
 }
 
-void efi_printk(char *str)
+void efi_printk(const char *str)
 {
-	char *s8;
+	char s8;
 
-	for (s8 = str; *s8; s8++) {
-		efi_char16_t ch[2] = { 0 };
+	while ((s8 = *str++)) {
+		static efi_char16_t ch[2] = {0, 0};
 
-		ch[0] = *s8;
-		if (*s8 == '\n') {
-			efi_char16_t nl[2] = { '\r', 0 };
+		if (s8 == '\n') {
+			static const efi_char16_t nl[2] = { '\r', 0 };
 			efi_char16_printk(nl);
 		}
 
+		ch[0] = s8;
 		efi_char16_printk(ch);
 	}
 }
@@ -284,7 +284,7 @@ void *get_efi_config_table(efi_guid_t guid)
 	return NULL;
 }
 
-void efi_char16_printk(efi_char16_t *str)
+void efi_char16_printk(const efi_char16_t *str)
 {
 	efi_call_proto(efi_table_attr(efi_system_table, con_out),
 		       output_string, str);
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 5ff63230a1f1..a03a92c665f0 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -251,7 +251,7 @@ union efi_simple_text_output_protocol {
 	struct {
 		void *reset;
 		efi_status_t (__efiapi *output_string)(efi_simple_text_output_protocol_t *,
-						       efi_char16_t *);
+						       const efi_char16_t *);
 		void *test_string;
 	};
 	struct {
@@ -599,7 +599,7 @@ efi_status_t efi_exit_boot_services(void *handle,
 				    void *priv,
 				    efi_exit_boot_map_processing priv_func);
 
-void efi_char16_printk(efi_char16_t *);
+void efi_char16_printk(const efi_char16_t *str);
 
 efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 					    unsigned long *new_fdt_addr,
@@ -624,7 +624,7 @@ efi_status_t check_platform_features(void);
 
 void *get_efi_config_table(efi_guid_t guid);
 
-void efi_printk(char *str);
+void efi_printk(const char *str);
 
 void efi_free(unsigned long size, unsigned long addr);
 

