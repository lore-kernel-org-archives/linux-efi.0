Return-Path: <SRS0=BNvh=UD=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC91C282CE
	for <linux-efi@archiver.kernel.org>; Tue,  4 Jun 2019 23:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0AE9206BB
	for <linux-efi@archiver.kernel.org>; Tue,  4 Jun 2019 23:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfFDXEp (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 4 Jun 2019 19:04:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36672 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfFDXEo (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 4 Jun 2019 19:04:44 -0400
Received: from 95.172.237.253.ip.static.uno.uk.net ([95.172.237.253] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <chris.coulson@canonical.com>)
        id 1hYITz-0006ef-69; Tue, 04 Jun 2019 23:04:43 +0000
From:   Chris Coulson <chris.coulson@canonical.com>
To:     linux-integrity@vger.kernel.org
Cc:     Chris Coulson <chris.coulson@canonical.com>,
        linux-efi@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matthew Garrett <mjg59@google.com>,
        Bartosz Szczepanek <bsz@semihalf.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] tpm: Don't dereference event after it's unmapped in __calc_tpm2_event_size
Date:   Wed,  5 Jun 2019 00:04:33 +0100
Message-Id: <20190604230433.20936-2-chris.coulson@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604230433.20936-1-chris.coulson@canonical.com>
References: <20190604230433.20936-1-chris.coulson@canonical.com>
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

The pointer to the event header is dereferenced on each loop iteration in
order to obtain the digest count, but when called from
tpm2_calc_event_log_size, the event header is unmapped on the first
iteration of the loop. This results in an invalid access for on subsequent
loop iterations for log entries that have more than one digest.

Signed-off-by: Chris Coulson <chris.coulson@canonical.com>
---
 include/linux/tpm_eventlog.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index 63238c84dc0b..7b76abbff7d8 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -165,6 +165,7 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 	int mapping_size;
 	void *marker;
 	void *marker_start;
+	u32 count;
 	u32 halg_size;
 	size_t size;
 	u16 halg;
@@ -190,16 +191,17 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 	}
 
 	event = (struct tcg_pcr_event2_head *)mapping;
+	count = event->count;
 
 	efispecid = (struct tcg_efi_specid_event_head *)event_header->event;
 
 	/* Check if event is malformed. */
-	if (event->count > efispecid->num_algs) {
+	if (count > efispecid->num_algs) {
 		size = 0;
 		goto out;
 	}
 
-	for (i = 0; i < event->count; i++) {
+	for (i = 0; i < count; i++) {
 		halg_size = sizeof(event->digests[i].alg_id);
 
 		/* Map the digest's algorithm identifier */
-- 
2.17.1

